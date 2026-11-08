bits 16

extern init
global _start
section .text


_start:
    MOV AH, 0AH
    MOV AL, 'S'
    MOV CX, 1
    INT 10H
    JMP enablea20

enablea20:

    CLI
    ; taken from wiki.OSDEV.org lolz
    mov     ax, 0x2403
    int     0x15
    jc      a20_ns
    test    ah, ah
    jnz     a20_ns

    mov     ax, 0x2402
    int     0x15
    jc      a20_failed
    test    ah, ah
    jnz     a20_failed
    test    al, al
    jnz     a20_activated

    mov     ax, 0x2401
    int     0x15
    jc      a20_failed
    test    ah, ah
    jnz     a20_failed       


a20_activated:
    LGDT [gdt_descriptor]

    MOV eax, cr0
    OR eax, 0x1
    MOV cr0, eax

    JMP CODE_SEG:init_pm

a20_failed:
    MOV AH, 0AH
    MOV AL, 'F'
    MOV BH, 0
    INT 10H
    JMP $
a20_ns:
    MOV AH, 0AH
    MOV AL, 'N'
    MOV BH, 0
    INT 10H
    JMP $


bits 32

init_pm:

    MOV AX, DATA_SEG
    MOV DS, AX
    MOV SS, AX
    MOV ES, AX
    MOV FS, AX
    MOV GS, AX

    MOV EBP, 0x9000
    MOV ESP, EBP


    CALL init
    JMP error
    
error:
    HLT
    JMP $
    

gdt_start:
    DW 0x0 
    DW 0x0
gdt_null:
    DD 0x00000000
    DD 0x00000000

gdt_code:
    DW 0xFFFF
    DW 0x0000
    DB 0x00
    DB 10011010B
    DB 11001111B
    DB 0x00

gdt_data:
    DW 0xFFFF
    DW 0x0000
    DB 0x00
    DB 10010010B
    DB 11001111B
    DB 0x00

gdt_end:

gdt_descriptor:
    DW gdt_end - gdt_start - 1
    DD gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

