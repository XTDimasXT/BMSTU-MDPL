PUBLIC X
EXTRN print: near

SD1 SEGMENT para public 'DATA'
	X db 'A'
SD1 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, DS:SD1
main:	
	mov ax, SD1
	mov ds, ax

	mov ah, 01
	int 21h
	sub al, 30h

	mov bx, offset X
	mov byte ptr ds:[bx], al

	jmp print
SC1 ENDS
END main