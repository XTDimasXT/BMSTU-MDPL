EXTRN X: byte
PUBLIC print

SC1 SEGMENT para public 'CODE'
	assume CS:SC1
print:
	mov ax, seg X
	mov es, ax

	mov al, es:X
	mov bx, 2
	mul bx

	add al, 30h

	mov bl, al

	mov ah, 02
	mov dl, ' '
	int 21h

	mov ah, 02
	mov dl, bl
	int 21h
	
	mov ax, 4c00h
	int 21h
SC1 ENDS
END