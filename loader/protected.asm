
section _TEXT PUBLIC CLASS=CODE USE16

global _switchProtected
_switchProtected:
		push bp
		mov bp, sp
		mov ebx,	[bp+4]
		mov		ax, cs				; AX = ����� ᥣ���� PM_CODE
		mov		ds, ax

; ���뢠�� ����� �20 (��� 32-� ��⭮� ����樨):
		in		AL,92h
		or		AL,2
		out		92h,AL

; ����塞 ������� ���� ��⪨ ENTRY_POINT (�窠 �室� � ���饭�� ०��, 
; ��室���� � PM_CODE ᥣ����, ���⮬� �� ���� � ���襬):
		mov		ax, cs
		shl		eax, 4				; EAX = ������� ���� PM_CODE
		add		ax, entry_point 		; EAX = ������� ���� ENTRY_POINT
		mov		[entry], eax			; ��࠭塞 ��� � ��६����� ENTRY_OFF  	
; (����, ������� "���" ���뢠���� SMC ��� Self Modyfing Code - ᠬ����������騩�� ���)

; ⥯��� ���� ���᫨�� ������� ���� GDT (��� ����㧪� ॣ���� GDTR):
		xor		eax,eax
		mov		ax,cs     			; AX = ����� ᥣ���� RM_CODE
		shl		eax,4				; EAX = ������� ���� RM_CODE
		add		ax,GDT				; ⥯��� EAX = ������� ���� GDT

; ������� ���� GDT ������ � ��࠭�� �����⮢������ ��६�����:
		mov		[GDTR+2], eax

; � ������� ��� ������� SMC 㦥 �����, ��⮬� ��� �� ��� �� �������㥬 ����� :)

; ᮡ�⢥���, ����㧪� ॣ���� GDTR:
		lgdt		[GDTR]

; ����� ��᪨�㥬�� ���뢠���:
		cli

; ����� ����᪨�㥬�� ���뢠���:
		in		al,70h
		or		al,80h
		out		70h,al

; ��४��祭�� � ���饭�� ०��:
		mov		eax, CR0
		or		al, 1
		mov		CR0, eax


; ����㧨�� ���� ᥫ���� � ॣ���� CS
		db		66h				; ��䨪� ��������� ࠧ�來��� ���࠭��
		db		0EAh				; ����� ������� JMP FAR
entry:		dd		0				; 32-��⭮� ᬥ饭��
		dw		00001000b			; ᥫ���� ��ࢮ�� ���ਯ�� (CODE_descr)

; ������� ���������� ������������:
GDT:  
; �㫥��� ���ਯ�� (��易⥫쭮 ������ ������⢮���� � GDT!):
;                                                                         t
;                                                                         i
;                                                                   B L   m
;                                                                   / V   i
;                                                        DPL        D A   L
;                               |LIMIT  |  |BASE      | P---Type   G O ----   |B|
NULL_descr	db		000h,000h, 00h,00h,00h, 00000000b, 00000000b, 00h
CODE_descr	db		0FFh,0FFh, 00h,00h,00h, 10011010b, 11001111b, 00h
DATA_descr	db		0FFh,0FFh, 00h,00h,00h, 10010010b, 11001111b, 00h
GDT_size	equ 		$-GDT				; ࠧ��� GDT

GDTR		dw		GDT_size-1			; 16-���� ����� GDT
		dd		0				; ����� �㤥� 32-���� ������� ���� GDT

; ---------------------------------------------------------------------------------------------------------


use32
; ������� ���� (��� Protected Mode)
; ---------------------------------------------------------------------------------------------------------
entry_point:
; ����㧨� ᥣ����� ॣ����� ᥫ���ࠬ� �� ᮮ⢥�����騥 ���ਯ���:
                mov	       AX,00010000b                ; ᥫ���� �� ��ன ���ਯ�� (DATA_descr)
	        mov	       DS,AX                       ; � DS ���
	        mov	       ES,AX                       ; � ES ���
	        mov	       FS,AX                       ; � FS ���
	        mov	       GS,AX                       ; � GS ���
	        mov	       SS,AX                       ; � SS ���
	        mov	       ES,AX                       ; � ES ���

		mov		ESP, 0x400000
		jmp		EBX
