;Author: Alexander Brannon
;This program is given an input, key, and options variable. Depending on the options
;variable, it will either encrypt or decrypt the input with the key variable.
;04/24/2019
.386
.model flat, stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
		
	input BYTE "MEMORY"					;sets input, output, options, and key variables
	key BYTE "BAD"							;MEMORY
	keyUpdated BYTE LENGTHOF input DUP(?)	;ZZZZZZ
	options BYTE 1							;LDLNQX
	output BYTE LENGTHOF input DUP(?)

.code
main proc
		
		mov eax, 0						;This configures eax, esi, and edi 
		mov esi, 0						;registers for the UpdateKey loop.
		mov edi, LENGTHOF key
		
		UpdateKey:						;This takes all values from key
		mov al, key[esi]				;and puts them into another variable
		mov keyUpdated[esi], al			;keyUpdated. This variable is the same 
		inc esi							;size as input and output so that each
		dec edi							;element in input will have an 
		cmp edi, 0						;encryption/decryption key. 
		jne UpdateKey
		
		mov eax, 0						;This configures eax, esi, and edi for
		mov esi, LENGTHOF key			;the UpdateKey2 loop.
		mov edi, LENGTHOF keyUpdated
		sub edi, LENGTHOF key

		UpdateKey2:						;If key length is less than input length, 
		mov al, key[esi]				;this loop is responsible for copying key
		mov keyUpdated[esi], al			;as many times as necessary to fill 
		inc esi							;keyUpdated so each element in input has a key.
		dec edi
		cmp edi, 0
		jne UpdateKey2

		mov esi, 0						;This configures esi and eax for the Encrypt				
		mov eax, 0						;Loop. Also if options does not equal one
		cmp options, 1					;it will jump to the Decrypt loop.
		jne Decrypt

		Encrypt:						;This loop takes the input and keyUpdated to 
		movzx edi, input[esi]			;encrypt and save it into output. This 
		sub edi, 65						;loop excludes encryptions that are outside the 
		mov al, keyUpdated[esi]			;range of 65 (a) and 90 (z) because it must wrap 
		add eax, edi					;around for the exception. For the exception, it 
		mov output[esi], al				;will jump to the Wrap loop for it to be handled.
		cmp output[esi], 90						
		jnle Wrap
		inc esi
		cmp esi, [LENGTHOF input]
		jne Encrypt

		cmp options, 1					;This makes sure that after encryption it will
		je Done							;jump to the end of the program.
		
		Wrap:							;This loop handles exceptions for the encryption
		sub output[esi], 26				;that are greater than a value of 90. It will
		inc esi							;wrap around so that all encryption values have
		cmp esi, [LENGTHOF input]		;a value between 65 (a) and 90 (z). It will then 
		jne Encrypt						;jump back to the Encrypt loop.	

		cmp options, 1					;This makes sure that after encryption it will
		je Done							;jump to the end of the program.

		Decrypt:						;This is a placeholder loop so that the program
		Loop Decrypt					;has a place to start if options does not equal 1

		mov esi, 0						;This configures esi, eax, and ebx for the Decrypt1				
		mov eax, 0						;Loop.
		mov ebx, 0
		
		Decrypt1:						;This loop is responsible for decrypting the input
		movzx edi, input[esi]			;using the keyUpdated and saving it into output.			
		add edi, 65						;Further, if the value of output[esi] is outside the 			
		mov al, keyUpdated[esi]			;range of 65 (a) and 90 (z) it will jump to the Dewrap 
		sub edi, eax					;loop for it to be handled.
		mov ebx, edi
		mov output[esi], bl				
		cmp output[esi], 65						
		jnge Dewrap
		inc esi
		cmp esi, [LENGTHOF input]
		jne Decrypt1

		cmp esi, [LENGTHOF input]		;This compares esi and the length of input.
		je Done							;If they are equal then it jumps to Done so
										;that it may skip the Dewrap loop.

		Dewrap:							;This loop handles the exception if output[esi] is 			
		add output[esi], 26				;outside the range of 65 (a) and 90 (z).			
		inc esi							
		cmp esi, [LENGTHOF input]		 
		jne Decrypt1						



		Done:

		mov eax, 0						;This checks to make sure that output has 
		mov ebx, 0						;the correct values. (It is not necessary
		mov ecx, 0						;for the code; however, it was used to test
		mov al, output[1]				;the correct values)
		mov ah, output[0]
		mov bl, output[LENGTHOF output-3]
		mov bh, output[LENGTHOF output-4]
		mov cl, output[LENGTHOF output-1]
		mov ch, output[LENGTHOF output-2]

		invoke ExitProcess, 0
main endp
end main