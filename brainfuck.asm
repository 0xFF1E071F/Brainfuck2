;-----------------------------------------------------------------------
.data?
	BRAINFUCK_DATA_SIZE		equ	30000
	brainfuck_cells			db  BRAINFUCK_DATA_SIZE dup(?)	; standard 30k cells
	brainfuck_code			dd	?

;-----------------------------------------------------------------------
.code
brainfuck_initialize	proc	lpscript
	and		eax, 0
	mov		ecx, sizeof brainfuck_cells/4
	mov		edi, offset brainfuck_cells
	rep		stosd
	push	lpscript
	pop		brainfuck_code
	ret
brainfuck_initialize	endp

brainfuck_run	proc
	push	-1				; stack control flag
	
	mov		esi, brainfuck_code; code ptr (instruction ptr)
	mov		edi, esi
	invoke	interpreter_script_length
	mov		edi, offset brainfuck_cells; data ptr 
	xor		ebx, ebx

	.while	byte ptr [esi]
		lodsb
		dec		ecx				; script len
		movzx	eax, al
		switch	eax
			case	';'
				mov		al, 0Dh
				xchg	esi, edi
				repnz	scasb			; fukken scas werks over edi
				xchg	esi, edi
				;cmp		byte ptr [esi], 10h
				;jnz		.next
				;inc		esi
			case	'+'
				inc		byte ptr [edi]
			case	'-'
				dec		byte ptr [edi]
			case	3Eh
				inc		edi
				;cmp		edi, offset brainfuck?_cells+BRAINFUCK_DATA_SIZE
				;js		.ceil
				;mov		edi, offset brainfuck?_cells
				;.ceil:
			case	3Ch
				dec		edi
				;cmp		edi, offset brainfuck?_cells
				;jnc		.floor
				;mov		edi, offset brainfuck?_cells
				;add		edi, BRAINFUCK_DATA_SIZE
				;.floor:
			case	'['
				push	esi
				dec		dword ptr [esp]

				.if		!byte ptr [edi]
					.if		!ebx
						.repeat
							lodsb
							.if		al != ']'
								.if	al == '['
									inc		bl
								.endif
						
							.else
								.break .if !bl
								dec		bl
							.endif
						.until	TRUE
						mov		ebx, esi						
					.endif
					pop		esi
					mov		esi, ebx
					xor		ebx, ebx				
				.endif
			case	']'
				mov		ebx, esi
				.if		!dword ptr [esp] == -1
					pop		esi
				.endif
			case	'.'
				invoke	interpreter_console_putchar
			case	','
				invoke	interpreter_console_getchar
		endsw
	.endw
	.while	!dword ptr [esp] == -1
		add		esp, 4
	.endw
	ret
brainfuck_run	endp

