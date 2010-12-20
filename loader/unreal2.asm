nable_A20 proc near
        call    Wait8042BufferEmpty
        mov     AL,0D1h ;������� �ࠢ����� ����� A20
        out     64h,AL
        call    Wait8042BufferEmpty
        mov     AL,0DFh ;ࠧ���� ࠡ��� �����
        out     60h,AL
        call    Wait8042BufferEmpty
        ret
Enable_A20 endp

Wait8042BufferEmpty proc near
        push    CX
        mov     CX,0FFFFh  ;������ �᫮ 横���
@@kb:   in      AL,64h     ;������� �����
        test    AL,10b     ;���� i8042 ᢮�����?
        loopnz  @@kb       ;�᫨ ���, � 横�
        pop     CX
        ret
Wait8042BufferEmpty endp


����� ���� ��� ���� - ���� ⠪ 
Enable_A20:;push ax ;�᫨ �㦭� ��࠭��� ���祭�� AX
                    ;� �� � � ���� ���� �᪮����஢���
            in al,92h ;��.-  http://wasm.ru/forum/files/_625753930__ports.zip
            or al,02h ;��� 1(��� � �㫥����) - �������� ����� A 20
            out 92h,al
           ;pop ax
           ret
