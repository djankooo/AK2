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

.bss

.lcomm input, 32
.lcomm inputLen, 4
.lcomm size, 4
.lcomm sizeLen, 4

.text

.global _start

_start:

movl $SYSWRITE,%eax
movl $STDOUT,%ebx
movl $msg_input,%ecx
movl $msg_input_len,%edx
int $0x80

movl $SYSREAD, %eax
movl $STDIN, %ebx
movl $input, %ecx
movl $BUF_SIZE, %edx
int $0x80

decl %eax
movl %eax, inputLen

#####################

movl $SYSWRITE,%eax
movl $STDOUT,%ebx
movl $msg_size,%ecx
movl $msg_size_len,%edx
int $0x80

movl $SYSREAD, %eax
movl $STDIN, %ebx
movl $size, %ecx
movl $BUF_SIZE, %edx
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

push size	#size
push input	#input

call print

mov $SYSEXIT,%eax
mov $EXIT_SUCCESS,%ebx
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
leal 4(%esp,%ebp,1), %ecx
movl $4, %edx
int $0x80

decl %esi
jmp print_loop_start

###################### 


.type newlinefunction, @function
newlinefunction:
pushl %ebp
movl %esp, %ebp

mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $newline, %ecx
mov $newline_len, %edx
int $0x80

jmp end

######################

end:
ret

