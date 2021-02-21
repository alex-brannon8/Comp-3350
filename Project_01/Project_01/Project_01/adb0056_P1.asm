.386
.model flat, stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	
	input BYTE 1, 2, 3, 4, 5, 6, 7, 8
	shift BYTE 2

.code
main proc
		;sets all registers to 0
		mov eax, 0
		mov ebx, 0
		mov ecx, 0
		mov edx, 0

		;sets the first and second elements of input to eax
		mov al, input		
		add al, shift		
		xchg al, [input+1]	
		add al, shift		
		xchg al, input		
		mov ax, WORD PTR input 

		;sets the third and fourth elements of input to ebx
		mov bl, [input+2]
		add bl, shift
		xchg bl, [input+3]
		add bl, shift
		xchg bl, [input+2]
		mov bx, WORD PTR [input+2]

		;sets the fifth and sixth elements of input to ecx
		mov cl, [input+4]
		add cl, shift
		xchg cl, [input+5]
		add cl, shift
		xchg cl, [input+4]
		mov cx, WORD PTR [input+4]

		;sets the seventh and eighth elements of input to edx
		mov dl, [input+6]
		add dl, shift
		xchg dl, [input+7]
		add dl, shift
		xchg dl, [input+6]
		mov dx, WORD PTR [input+6]

		invoke ExitProcess, 0
main endp
end main