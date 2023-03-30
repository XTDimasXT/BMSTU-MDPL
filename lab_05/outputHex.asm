EXTERN num: word
PUBLIC outputSignedHex

DSEG SEGMENT PARA PUBLIC 'DATA'
	sHexMsg db 13, 10, 'Signed heximal number: $'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG
	
outputSignedHex proc near
	mov ah, 9
	mov dx, offset sHexMsg
	int 21h
	
	xor ax, ax
	mov ax, 32768
	test num, ax
	jns output
	
	mov dl, '-'
	mov ah, 2
	int 21h
	neg num

output:
	mov bl, 4
	mov cx, 4
	outDigitHex:
		xchg cl, bl
		rol num, cl
		xchg bl, cl
		mov ax, 15
		and ax, num
		cmp al, 9
		jle digit
		add al, 7
		digit:
			mov dl, al
			add dl, 30h
			mov ah, 2
			int 21h
		loop outDigitHex
	ret
outputSignedHex ENDP
CSEG ENDS
END