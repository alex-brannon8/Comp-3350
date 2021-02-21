;Author: Alexander Brannon
;Program that takes input array and shift variable and shifts input by what shifts equals. 
;It also wraps other elements to the end of the output array.
;It then saves the new array into output.
;3/29/2018
.386
.model flat, stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	;sets input, output, and shift variables	
	input BYTE 5, 0Ah, 3, 6, 0Ch
	output BYTE LENGTHOF input DUP(?)
	shift DWORD 3

.code
main proc
		;sets all registers to 0
		mov eax, 0
		mov ebx, 0
		mov ecx, 0
		mov edx, 0
		
		;moves lengthof input - shift + 1 into ecx and moves shift into ebx register
		mov ecx, LENGTHOF input
		sub ecx, shift
		inc ecx
		mov ebx, shift
		
		;loops through every element that comes after shift and saves it into output array
		M:
		mov al, [input+(ebx-1)]
		mov [output+(edx)], al
		inc ebx
		inc edx
		LOOP M
		
		;configures ecx and ebx for loop N
		mov ecx, shift
		dec ecx
		mov ebx, 1
		
		;loops through every element that comes before shift and saves it into output array
		N:
		mov al, [input+(ebx-1)]
		mov [output+(edx)], al
		inc ebx
		inc edx
		LOOP N
		
		;checks to see if all output elements are saved in the correct order
		mov al, output[1]
		mov ah, output
		mov bl, output[LENGTHOF output-1]
		mov bh, output[LENGTHOF output-2]

		invoke ExitProcess, 0
main endp
end main