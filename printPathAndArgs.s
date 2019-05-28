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

path: .ascii "Sciezka %s\n\0"
arg: .ascii "Argument %s\n\0"
#newline_len = . - newline

.bss

.lcomm input, 32

.text

.global main

main:

leal 4(%esp,%ebp,1), %ecx
movl (%ecx), %ebx
movl %ebx, input

leal 8(%esp,%ebp,1), %ecx
movl (%ecx), %ebx

movl (%ebx), %ecx

push %ecx
push $path
call printf

add $4, %ebx

decl input

loop:

cmp $0, input
je eend

movl (%ebx), %ecx

push %ecx
push $arg
call printf

add $4, %ebx

decl input

jmp loop

eend:

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



end:
ret

