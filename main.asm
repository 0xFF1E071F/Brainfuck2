;-----------------------------------------------------------------------
; 
%out лллллл                лл          лллллл                 лл    
%out   лл   лл               лл          лл                     лл    
%out   лл   лл                           лл                     лл    
%out   лл   лл  лллл  лллл   лл  лл лл   лл      лл  лл   лллл  лл  лл
%out   лллллл   лл   л   лл  лл  ллл лл  лл      лл  лл  лл  лл лл лл 
%out   лл   лл  лл     лллл  лл  лл  лл  лллл    лл  лл  лл     лллл  
%out   лл   лл  лл    лл лл  лл  лл  лл  лл      лл  лл  лл     лллл  
%out   лл   лл  лл   лл  лл  лл  лл  лл  лл      лл  лл  лл     лл лл 
%out   лл   лл  лл   лл  лл  лл  лл  лл  лл      лл ллл  лл  лл лл лл 
%out лллллл   лл    ллллл  лл  лл  лл  лл       лл лл   лллл  лл  лл
;
; 29.09.10
;	10hs	Rainy day. Restart coding.
;			Changed branch format. Using the stack since it's how it manages;
;			 now can have an unlimited (virtually) number of nested blocks.
;			Removed preservation of edx. Using ebx instead.
;			Fixed unseen nested block bug.
;			Added stack control flag.
;			Added data block control.
;			Various testing scripts. Simplier ones werks, others doesn't.
;	11hs	Using extremelly nasty name conventions. Went too far.
;			 Classing brainfuck VM and interpreter (auxiliar functions).
;	12hs	Fukken frustrated can't find teh dammed bug!
;			Gone away.
;
; 28.09.10
;	18hs	Late afternoon. Start coding.
;			Switching to hardcore mode.
;			Switching to DOTNAME. Looks so cool.
;			Done interpreter. Manages input/output.
;			Done data pointer management, data management.
;			Added ';' for single line comments.
;	18:30hs	Problems with nested blocks.
;			Fixed trashing of ecx, edx (interpreter?getchar and setchar
;            caused it - added push reg / pop reg)
;			Still problems with nested blocks.
;	20hs	Gone to dinner.
;	23hs	Gone to sleep.
;
;-----------------------------------------------------------------------
.386
.model flat, stdcall
option casemap:none

;-----------------------------------------------------------------------
include		windows.inc
include		kernel32.inc
includelib	kernel32.lib
include		macros.asm

;-----------------------------------------------------------------------
.code
	include	interpreter.asm
	include	brainfuck.asm

start:
	invoke	interpreter_console_argv
	.if		eax
		push	eax
		invoke	interpreter_initialize
		pop		eax
		invoke	interpreter_script_load, eax
		test	eax, eax
		.if		!SIGN?
			invoke	brainfuck_initialize, eax
			invoke	brainfuck_run
		.endif
	.endif
	invoke	ExitProcess, 0    
    ret		; wait... what?

end start
;-----------------------------------------------------------------------

