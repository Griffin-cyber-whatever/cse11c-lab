
.include "final.s"
.extern printf

.section .data
format: 
	.string "%c"
.section .bss
  .align 4
initial:
	.zero 8	

.section .text
.global main
# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************

# pseudocode
# void decode(int addr) {
#   # use casting to get pointer in c
# 	uint8_t *byte_ptr = (uint8_t *)addr;
#   # then use arithemtic on byte value type to get value at specific address
#   uint8_t sixth_byte = byte_ptr[5];  
#   but those r not necessary in assembly imo, especially the manualy emphasized u could use partial registers to get partial value
# 	so my idea is: get whole 8byte value in register and then parse it to lower registers
# }
print:
	pushq %rbp
	movq %rsp, %rbp
	# key: these partial registers literally share the same physcial storage space inside the CPU, so by obtaining %rdi, we automatically obtain %dh, %dil also
	# print char several times. %r12b is char, %r13b is times
	movq (%rdi), %r12
	movq 1(%rdi), %r13

loop:	
	movq $format, %rdi
	movzbq %r12b, %rsi
	movq $0, %rax	# no vector
	call printf

	dec %r13b
	cmp $0, %r13b
	jg loop	 

	movq %rbp, %rsp
	popq %rbp
	ret

decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	# your code goes here
	# function terminate when (inital address == current address)
	movq %rdi, initial(%rip)
continue:
	pushq %rdi
	call print
	popq %rdi	
	# In x86-64 architecture, any instruction that writes to a 32-bit register (like %edi) automatically clears the upper 32 bits of the corresponding 64-bit register to zero.
	movq initial, %rdx	# load initial address to %rdx
	movl 2(%rdi), %edi	# current index
	leaq (%rdx,%rdi,8), %rdi	# next address
	cmp %rdx, %rdi
	jne continue

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi	# first parameter: address of the message
	call	decode			# call decode

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program

