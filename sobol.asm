%macro _Push_all_reg 0
	PUSH eax
	PUSH ecx
	PUSH edx
	PUSH ebx
	PUSH ebp
	PUSH esi
	PUSH edi
%endmacro

%macro _Pop_all_reg 0
	POP edi
	POP esi
	POP ebp
	POP ebx
	POP edx
	POP ecx
	POP eax
%endmacro

%macro _PRINT 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    x dw 8
    y dw 12
    z dw 0
    num db '00'
    text db  "sum of x and y is "
    len dd $ - text
    
section .text:
    global _start
    
procedure1:
    _Push_all_reg
    pushf
    mov ax, [esi]
    mov ecx, [edi]
    sub ecx, 1
cycl1:
    add ax, [esi]
    loop cycl1
    mov [z], ax
    popf
    _Pop_all_reg
    ret

print_num2dig:
    _Push_all_reg
    pushf
    mov  bl, 10
    div bl
    add al, 0x30
    add ah, 0x30
    mov [num], al
    mov [num+1], ah
    _PRINT text, [len]
    _PRINT num, 2   
    popf
    _Pop_all_reg
    ret
   
procedure2:
    _Push_all_reg
    pushf
    mov dx, [esi]
    mov bx, [edi]
    mov ax, 0
    mov ecx, 0 
cycl:
    bt bx, cx
    jnc l1
    add ax, dx
l1: 
    inc ecx
    shl dx, 1
    cmp ecx, 7
    jle cycl
exit_cycl:
    mov [z], ax
    popf
    _Pop_all_reg
    ret
    
_start:
    mov esi, x
    mov edi, y
    call procedure2
    
    mov ax, [z]
    call print_num2dig

    mov eax, 1
    mov ebx, 0
    int 0x80