PUBLIC num
EXTERN inputNum: near
EXTERN outputUnsignedBin: near
EXTERN outputSignedHex: near

STK SEGMENT PARA STACK 'STACK'
	db 200 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	num dw 0
	inputStr db 10, 13, '> $'
	newLine db 10, 13, '$'
	menu db 10, 13, 'Choose what you want: ', 10, 13
		 db ' 0. Input unsigned 10-system number', 10, 13
		 db ' 1. Output unsigned 2-system number', 10, 13
		 db ' 2. Output signed 16-system number', 10, 13
		 db ' 3. Exit $', 10, 13
	function dw inputNum, outputUnsignedBin, outputSignedHex, exit
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:STK
main:
	mov ax, DSEG
	mov ds, ax

menuLoop:	
	mov dx, offset menu
	mov ah, 9
	int 21h
	
	mov dx, offset inputStr
	int 21h
	mov ah, 1
	int 21h
	sub al, 30h
	
	xor bx, bx
	xor ah, ah
	
	mov bl, 2
	mul bl
	
	mov bx, ax
	call function[bx]
	jmp menuLoop
	
exit:
	mov ah, 4Ch
	int 21h
CSEG ENDS
END main