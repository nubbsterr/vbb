; simple x86 bootloader, originally derived from Nir Lichtman's vid: https://www.youtube.com/watch?v=xFrMXzKCXIc
; daedalus community's series on creating an x86 OS is very helpful for beginners, check it out here: https://www.youtube.com/watch?v=MwPjvJ9ulSc

bits 16         ; bootloaer runs in 16-bit real mode; basically a minimal amount of space to load the initial bootloader code (512B in size)
org 0x7c00      ; bootloader code gets loaded from this address, all instructions hereafter will be relative to this address so the bootloader code runs properly

KERNEL_LOCATION equ 0x1000 ; arbitrary location for kernel, security down the drain cuz no KASLR lol 
BOOT_DISK: db 0            ; disk bootloader is loaded from is stored in dl register, see findkernel label
mov [BOOT_DISK], dl        ; save drive # to later use in int 0x13

; offsets of each segment descriptor to GDT
CODE_SEGMENT equ code_descriptor - GDT_Start
DATA_SEGMENT equ data_descriptor - GDT_Start

prepstack:
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov bp, 0x8000  ; starting point for bp
    mov sp, bp      ; sp and bp start at the same place in memory initially, until push/pop is used, then sp starts moving

findkernel:
    ; read same disk of bootloader, stored in dl to retrieve kernel code, info on interrupt 0x13: https://stanislavs.org/helppc/int_13-2.html
    ; read 0th head/cylinder and 10 sectors to find ALL of kernel code
    mov ah, 2
    mov al, 10
    xor ch, ch              
    mov cl, 2               ; read from 2nd sector, after first sector read for bootloader
    xor dh, dh              
    mov dl, [BOOT_DISK]     ; read from same disk booted from
    mov bx, KERNEL_LOCATION ; load sector to kernel location; the stuff we read is our kernel code
    int 0x13
    ; clear screen by swapping text mode, see https://stanislavs.org/helppc/int_10-0.html
    xor ah, ah
    mov al, 0x3
    int 0x10
    jc findkernelfailure    ; if error occurs during interrupt
    jnc protectedmodeprep
    
findkernelfailure:
    mov ah, 0x0E               ; teletype mode to print text 
    xor bh, bh                 ; set page number to 0x00 to print text to the screen 
    mov al, 'K'                ; Failed to find kernel "message" lol
    int 0x10                   
    jmp exit

protectedmodeprep:
    cli                                  ; clear/disable interrupts since we can't use them in protected mode
    lgdt [GDT_Descriptor] 
    ; cr0 needs to be set to 1 now, logical OR against cr0 will do so
    ; can now use 32-bit subregisters
    mov eax, cr0
    or eax, 1
    mov cr0, eax                         ; congrats we are now in protected mode
    jmp CODE_SEGMENT:startprotectedmode  ; perform far jump to new protected mode code segment
    
; now officially switch to 32-bit mode
bits 32
startprotectedmode:
    ; firstly need to setup registers to operate in protected mode, otherwise there may be protection faults
    mov ax, DATA_SEGMENT
    mov ds, ax
    mov es, ax 
    mov ss, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp
    ; now print stuff to screen through VIDOE MEMORY, starting at 0xb8000, first byte is text, second is colour
    mov ebx, 0xb8000            
    mov esi, protectedmessage   
    mov ah, 0x1F                ; blue on white background, reference: https://wiki.osdev.org/Text_UI#Colours

welcomeprotected:
    mov al, [esi]      ; load character from message
    cmp byte [esi], 0  ; check for null termination  
    je exit            ; would be KERNEL_LOCATION and not exit if cross-compiled but this is for funsies
    mov [ebx], ax      ; print the character to screen
    inc esi            ; shift to next character
    add ebx, 2         ; skip two bytes over to print next character to video memory
    jmp welcomeprotected

exit:
    hlt ; stop executing instructions, more efficient than infinite loop

GDT_Start:
    null_descriptor:
        ; contains 8 bytes loaded w/ 0, dd = double word which is 4 bytes in size
        dd 0 ; 00000000 x 4
        dd 0 ; 00000000 x 4
    code_descriptor:
        dw 0xffff ; defines first 16 bits of limit/size for code descriptor, limit is 20 bits in total
        ; define first 24 bits of base for code descriptor, base is 32 bits in total
        dw 0          ; 2 bytes, 16 bits of 0s
        db 0          ; 1 byte, 8 bits of 0s
        db 0b10011010 ; present/privilege/type and Type lags
        db 0b11001111 ; Other flags and remaining 4 bits of limit
        db 0          ; last 8 bits of base
    data_descriptor:
        ; almost the same as code descriptor except Type flags change so it is not code + grows vertically + writable + 
        dw 0xffff
        dw 0
        db 0 
        db 0b10010010   ; Type flags are 0010
        db 0b11001111
        db 0

GDT_End:

; Responsible for loading GDT when lgdt is executed
GDT_Descriptor:
    dw GDT_End - GDT_Start - 1 ; size of GDT
    dd GDT_Start               ; pointer to GDT

onFindKernelFailure:
    db "Failed to find kernel.", 0

protectedmessage:
    db "VBB is now in protected mode!", 0

times 510 - ($ - $$) db 0; nasm command to fill remaining space with 0s to fill 512B sector, subtract from 510 since following line uses another 2 bytes for signature   
dw 0xAA55 ; magic number at the end of the bootloader to define the end of its instructions
