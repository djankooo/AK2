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

l1:	.float 8.5

l2:	.float 16.25

w:	.float 0.0

.text

.global _start

_start:

movl l1, %eax
shr $23, %eax

movl l2, %ebx
shr $23, %ebx

cmp %al, %bl
jg subbl

subal:
subb %bl, %al #a<b
jmp dodaj

subbl:
subb %al, %bl #a>b
jmp dodaj

dodaj:
#dodaj

adding:

popf

#movl dod1(,%ecx,4), %eax
#movl dod2(,%ecx,4), %edx

sbbl %eax, %edx

inc %ecx

#mov %edx, wynik1(,%ecx,4)

dec %ecx
dec %ecx

pushf

cmp $0, %ecx
jge adding

inc %ecx

popf
mov $0, %edx
sbbl $0, %edx
#mov %edx, wynik1(,%ecx,4)


#####################

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
leal 4(%esp,%ebp,1), %ecx #load effective address
movl $4, %edx
int $0x80

decl %esi
jmp print_loop_start

######################
end:
ret

