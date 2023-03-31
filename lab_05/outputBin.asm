EXTERN num: word
PUBLIC outputUnsignedBin

DSEG SEGMENT PARA PUBLIC 'DATA'
	unsBinMsg db 13, 10, 'Unsigned binary number: $'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG
	
outputUnsignedBin proc near
	mov ah, 9
	mov dx, offset unsBinMsg
	int 21h
	
	mov cx, 16
	outDigitBin:
		xor ax, ax
		rol num, 1
		mov ax, 1
		and ax, num
		mov dl, al
		add dl, 30h
		mov ah, 2
		int 21h
		loop outDigitBin
	ret
outputUnsignedBin ENDP
CSEG ENDS
END