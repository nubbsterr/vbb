; will be an object file to be linked later
section .text
    bits 32     ; in protected mode still
    extern main ; in kernel.cpp

    call main
    jmp $       ; infinite loop lol
