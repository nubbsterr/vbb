; simple x86 bootloader, originally derived from Nir Lichtman's vid: https://www.youtube.com/watch?v=xFrMXzKCXIc
bits 16 ; bootloaer runs in 16-bit real mode; basically a minimal amount of space to load the initial bootloader code (512B in size)
org 0x7c00 ; bootloader code gets loaded from this address, all instructions hereafter will be relative to this address so the bootloader code runs properly

xor si, si ; counter for a loop we'll use to print characters to screen through video service
mov ah, 0x0E ; load video service to print text 
mov bl, 0x02 ; green text on black background
xor bh, bh ; set page number to 0x00 to print text to the screen 

print: 
    mov al, [message + si] ; message to print + null terminator, moving this outside the loop breaks the text lol
    int 0x10 ; video service interrupt to print characters
    inc si
    cmp byte [message + si], 0 ; cmp each character (byte) until string terminates, otherwise keep printing
    jne print ; repeat until everything gets printed 

hlt ; stop executing instructions, more efficient than infinite loop

message:
    db "x86 bootloader frfr", 0 

times 510 - ($ - $$) db 0; nasm command to fill remaining space with 0s to fill 512B sector, subtract from 510 since following line uses another 2 bytes for signature   
dw 0xAA55 ; magic number at the end of the bootloader to define the end of its instructions
