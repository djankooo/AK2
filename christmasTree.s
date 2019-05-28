SYSEXIT=1
EXIT_SUCCESS=0
SYSWRITE=4
STDOUT=1
SYSREAD=3
STDIN=0
BUF_SIZE=32
BASE=10

.align 32

.data


msg_input: .ascii "Podaj znak do wyswietlenia\n\0"
msg_input_len = . - msg_input
msg_size: .ascii "Ile znakow\n\0"
msg_size_len = . - msg_size
newline: .ascii "\n\0"
newline_len = . - newline
space: .ascii " \0"

.bss

.lcomm input, 32
.lcomm inputLen, 4
.lcomm size, 4
.lcomm sizeLen, 4
.lcomm height, 4
.lcomm spaces, 4

.text

.global _start

_start:

movl $SYSWRITE,%eax 	#przechowuje numer funkcji do wywolania
movl $STDOUT,%ebx	#wypis na standardowe wyjscie (konsole)
movl $msg_input,%ecx 	#przechowuje funkcje/wartosc zwracana do systemu
movl $msg_input_len,%edx#dlugosc danych do wyswietlenia ( . - adres wiadomosci)
int $0x80 		#przerwanie systemowe (wykonuje powyzsze zdania)

movl $SYSREAD, %eax	#funkcja wczytujaca
movl $STDIN, %ebx	#standardowe wyjscie - klawiatura
movl $input, %ecx	#wczutuje pod zadeklarowany input
movl $BUF_SIZE, %edx	#okreslony rozmiar bufora
int $0x80

decl %eax
movl %eax, inputLen

#####################

movl $SYSWRITE,%eax 	#przechowuje numer funkcji do wywolania
movl $STDOUT,%ebx	#wypis na standardowe wyjscie (konsole)
movl $msg_size,%ecx 	#przechowuje funkcje/wartosc zwracana do systemu
movl $msg_size_len,%edx #dlugosc danych do wyswietlenia ( . - adres wiadomosci)
int $0x80 		#przerwanie systemowe (wykonuje powyzsze zdania)

movl $SYSREAD, %eax	#funkcja wczytujaca
movl $STDIN, %ebx	#standardowe wyjscie - klawiatura
movl $size, %ecx	#wczutuje pod zadeklarowany input
movl $BUF_SIZE, %edx	#okreslony rozmiar bufora
int $0x80

decl %eax
movl %eax, sizeLen

######################

pushl size

call convertfunction

movl %eax, size

#########test#########

push input

call rmNewLine

movl %eax, input

######################

push $0

movl size, %eax
movl %eax, height
movl %eax, spaces

movl $0, size

loopCol:


###spaces###

movl spaces, %eax
decl %eax
movl %eax, spaces

push spaces
push space

call print

pop %eax
pop %eax

###spaces###

###***###

movl size, %eax
movl $2, %ebx
mull %ebx
incl %eax
incl size

push %eax	#wrzucam par. 1
push input	#wrzucam par. 2

call print

pop %ecx 	#zrzucam par. 1
pop %ecx	#zrzucam par. 2

###***###

call newlinefunction

pop %ecx

incl %ecx
push %ecx

cmpl height, %ecx
jl loopCol

movl size, %eax
decl %eax

push %eax
push space

call print

push $1
push input

call print

call newlinefunction

######################

mov $SYSEXIT,%eax	#zaladowanie funkcji exit
mov $EXIT_SUCCESS,%ebx	#wyprowadzenie 0 w razie powodzenia
int $0x80

######################

.type rmNewLine, @function
rmNewLine:

movl  4(%esp), %ebx

movl $10, %esi
movl $0, %ecx

mov %bl, %cl
cmp $10, %cl
je end
mov %cl, %al

rem:
shr $8, %ebx
mov %bl, %cl
cmp $10, %cl
je end
shl $8, %eax
add %cl, %al
jmp rem

######################

.type convertfunction, @function
convertfunction:

movl  4(%esp), %ebx

movl $10, %esi
movl $0, %ecx

mov %bl, %cl
cmp $10, %cl
je end
sub $'0', %cl
mov %cl, %al

converter:
shr $8, %ebx
mov %bl, %cl
cmp $10, %cl
je end
sub $'0', %cl
mull %esi
add %cl, %al
jmp converter

######################

.type print, @function
print:

movl  8(%esp), %esi

print_loop_start:
cmpl $0, %esi
je end

movl $SYSWRITE, %eax
movl $STDOUT, %ebx
leal 4(%esp,%ebp,1), %ecx #load effective address
movl $4, %edx
int $0x80

decl %esi
jmp print_loop_start

######################

.type newlinefunction, @function
newlinefunction:

mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $newline, %ecx
mov $newline_len, %edx
int $0x80

jmp end

######################

end:
ret

