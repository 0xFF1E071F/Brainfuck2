;-----------------------------------------------------------------------
.data?
	interpreter_hconsole		dd	?
	interpreter_hscript			dd	?
	interpreter_console_bytesread	dd	?
	interpreter_script_buffer	db 1024*500 dup(?)

;-----------------------------------------------------------------------
.code
interpreter_initialize	proc
	invoke	GetStdHandle, -11
	mov		interpreter_hconsole, eax
	invoke	SetConsoleMode, eax, 4 or 2 or 1
	ret
interpreter_initialize	endp

interpreter_script_load	proc lpscript

	invoke	CreateFile, lpscript, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	test	eax, eax
	.if		!SIGN?
		mov		interpreter_hscript, eax
		invoke	ReadFile, eax, addr interpreter_script_buffer, sizeof interpreter_script_buffer, addr interpreter_console_bytesread, 0
		push	eax

		invoke	CloseHandle, interpreter_hscript
		
		pop		eax
		dec		eax
		.if		!SIGN?
			mov		eax, offset interpreter_script_buffer
		.endif
	.endif
	ret
interpreter_script_load	endp

interpreter_script_length	proc
	and		al, 0
	mov		ecx, -1
	repnz	scasb
	not		ecx
	ret
interpreter_script_length	endp
	
interpreter_console_argv	proc
	invoke	GetCommandLine
	mov		edi, eax
	movzx	eax, byte ptr [edi]
	inc		edi
	and		ecx, 0
	dec		ecx
	repne	scasb
	.if		byte ptr [edi]
		inc		edi
		mov		eax, edi
	.else
		xor		eax, eax
	.endif
	ret
interpreter_console_argv	endp
	
interpreter_console_getchar	proc
	push	ecx
    invoke	ReadFile, interpreter_hconsole, edi, 1, addr interpreter_console_bytesread, 0
    pop		ecx
	ret
interpreter_console_getchar	endp

interpreter_console_putchar	proc
	push	ecx
    invoke	WriteFile, interpreter_hconsole, edi, 1, addr interpreter_console_bytesread, 0
    pop		ecx
	ret
interpreter_console_putchar	endp

;-----------------------------------------------------------------------
