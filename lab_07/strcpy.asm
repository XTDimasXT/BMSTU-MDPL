.686
.MODEL FLAT, C
.STACK

.CODE
my_strcpy PROC to:dword, from:dword, len:dword
	pushf
	mov ECX, len

	mov ESI, from
	mov EDI, to

	cmp ESI, EDI
	je quit

	mov EAX, ESI
	add EAX, len

	cmp EAX, EDI
	jg overlap

	rep movsb

	jmp quit

overlap:
	add ESI, len
	dec ESI
	add EDI, len
	dec EDI

	std

	rep movsb

	jmp quit

quit:
	popf
	ret

my_strcpy ENDP
END