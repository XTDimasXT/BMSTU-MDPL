EXTERN num: word
PUBLIC inputNum

DSEG SEGMENT PARA PUBLIC 'DATA'
	inputMsg db 10, 13, 'Input 16-bit unsigned decimal number: $'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG
	
inputNum proc near
	mov ah, 9
	mov dx, offset inputMsg
	int 21h
	
inputDigit:
	mov ah, 1
	int 21h
	
	cmp al, 13
	je inputEnd
	
	sub al, 30h
	mov cl, al
	
	mov ax, 10
	mul num
	mov num, ax
	xor ch, ch
	add num, cx
	
	jmp inputDigit
	
inputEnd:
	ret
inputNum ENDP
CSEG ENDS
END