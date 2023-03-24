STK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	newLine db 10, 13, '$'
DSEG ENDS

MATRIX SEGMENT PARA PUBLIC 'DATA'
	M dw (0)
	N dw (0)
	mtrx db 81 (0)
MATRIX ENDS

CSEG SEGMENT PARA PUBLIC 'DATA'
	assume CS:CSEG, DS:DSEG, ES:MATRIX, SS:STK
input:
	mov ah, 1
	int 21h
	xor ah, ah
	sub al, 30h
	mov M, ax
	
	mov dx, offset newLine
	mov ah, 9
	int 21h
	
	mov ah, 1
	int 21h
	xor ah, ah
	sub al, 30h
	mov N, ax
	
	mov dx, offset newLine
	mov ah, 9
	int 21h
	
	mov cx, m
	xor bx, bx
	
	inputMtx:
		call inputRow
		add bx, 9
		mov dx, offset newLine
		mov ah, 9
		int 21h
		loop inputMtx
	ret

inputRow:
	mov di, cx
	mov cx, n
	xor si, si
	
	mov ah, 1
	readElemLoop:
		int 21h
		sub al, 30h
		mov mtrx[bx][si], al
		inc si
		loop readElemLoop
		
	mov cx, di
	ret

change:
	xor di, di ; delColumn
	xor si, si
	xor al, al ; curSum
	xor dl, dl ; maxSum
	
	mov cx, n
	sum:
		xor al, al
		call columnSumCalc
		cmp dl, al
		jge lab
		mov dl, al
		mov di, si
		lab:
			inc si
		loop sum
		
	xor bx, bx
	mov cx, m
	delCol:
		call movRow
		add bx, 9
		loop delCol
		
	dec n
	ret
	
movRow:
	mov si, di
	push cx
	
	mov cx, n
	dec cx
	sub cx, di
	cmp cx, 0
	jle skip
	movLoop:
		mov al, mtrx[bx][si+1]
		mov mtrx[bx][si], al
		inc si
		loop movLoop
	skip:
	pop cx
	ret
	
columnSumCalc:
	xor bx, bx
	push cx
	mov cx, m
	columnSum:
		add al, mtrx[bx][si]
		add bx, 9
		loop columnSum
	pop cx
	ret
	
output:
	mov dx, offset newLine
	mov ah, 9
	int 21h
	
	mov cx, m
	xor bx, bx
	
	outputMtx:
		call outputRow
		add bx, 9
		mov dx, offset newLine
		mov ah, 9
		int 21h
		loop outputMtx
	ret
	
outputRow:
	xor si, si
	mov di, cx
	mov cx, n
	
	mov ah, 2
	output_elem:
		mov dl, mtrx[bx][si]
		add dl, 30h
		int 21h
		inc si
		loop output_elem
		
	mov cx, di
	ret
	
main:
	mov ax, DSEG
	mov ds, ax
	
	mov ax, MATRIX
	mov es, ax
	
	call input
	
	call change
	
	call output
	
	mov ax, 4c00h
	int 21h
CSEG ENDS
END main