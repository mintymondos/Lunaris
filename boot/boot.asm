org 0x07c00
bits 16

global main

main:
    XOR AX, AX
    MOV DS, AX
    MOV ES, AX
    MOV SS, AX
    MOV SP, 0x07c00
    CLD


    ; what the actual fuck, i HAD the exact same code but in uppercase earlier
    ; but it only began working (not triple faulting immediately) when
    ; I copied it from wikipedia???? WTF????????????
    ; again: i dont fucking know why?????
    ; do wikipedia editors have divine intellect like is this divine fucking intellect? /ref
    mov ah, 2h
    mov al, 16
    mov ch, 0
    mov cl, 2
    mov dh, 0
    xor bx, bx    
    mov es, bx
    mov bx, 0x8000
    INT 13H

    JC ERR

    JMP 0x0000:0x8000

ERR:
    MOV AH, 0AH
    MOV AL, 'E'
    MOV BH, 0
    INT 10H



boot: DW 0x00

times 510-($-$$) DB 0 
DW 0AA55h
