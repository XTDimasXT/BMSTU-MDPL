.model tiny
.code
.186
org 100h   

MAIN:
    OLDPTR: ; дальше комманда в 2 байта, перезапишем ее
            ; И выделим еще два байта под дальний указатель
    JMP start_resident
    DW ?

    CUR_TIME DB 0
    SPEED DB 1fh  ; начальная скорость 01 1111 
    INSTALL_MARKER DB 'S' ; Маркер резидента
    

TIMER_HANDLER:
    pusha
    pushf
    push es
    push ds

    mov ah, 02h
    int 1ah         ; get current time from bios 
    ;02H ¦AT¦ читать время из "постоянных" (CMOS) часов реального времени
    ; выход: CH = часы в коде BCD   (пример: CX = 1243H = 12:43)
    ;        CL = минуты в коде BCD
    ;        DH = секунды в коде BCD

    cmp dh, CUR_TIME
    mov CUR_TIME, dh 
    je end_loop ; время не изменилось

    mov al, 0f3h
    out 60h, al
    mov al, SPEED
    out 60h, al

    dec SPEED
    test SPEED, 0fh ; 0000 1111 - маска только для скорости
    jz reset
    jmp end_loop
    reset:
        mov SPEED, 0fh

    end_loop:
        pop ds
        pop es

        popf
        popa

        jmp DWORD ptr CS:OLDPTR

STOP_MESSAGE db "Resident stopped", 10, 13 , '$'
START_MESSAGE db "Resident started", 10, 13 , '$'

start_resident:
    MOV AX, 351ch ; получить из вектора прерывание 1c (таймер) в ES, BX
    INT 21H
    
    ; check if resident started
    cmp ES:INSTALL_MARKER, 'S'
    JE stop_resident

    ; save old ptr
    MOV WORD PTR OLDPTR, BX
    MOV WORD PTR OLDPTR + 2, ES

    MOV DX, offset START_MESSAGE
    MOV AH, 09h
    int 21h

    ; set handler
    MOV AX, 251ch
    MOV DX, OFFSET TIMER_HANDLER
    INT 21H
    
    ; stop programm residently
    MOV DX, OFFSET start_resident
    INT 27H

stop_resident:
    MOV DX, offset STOP_MESSAGE
    MOV AH, 09h
    int 21h

    ; restore ptr
    mov dx, word ptr es:OLDPTR
    mov ds, word ptr es:OLDPTR + 2
    mov ax, 251ch
    int 21H
    
    ; free memory
    mov ah, 49h
    int 21h
    
    ; end program
    mov ah, 4Ch
    int 21h

END MAIN