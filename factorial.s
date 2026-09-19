# subroutine factorial, take one argument and return n in %rax
# `This subroutine will be about 14 instructions in length when it is finished, but writing it will be fairly difficult. ` so i guess it would be factorial(n-1) with base case that kind of thing
# the method mentioned in course assembly manual is exactly like that
# int factorial (int n) {
#   if (n == 1) return 1;
#   return n * factorial(n-1);
# }

  .extern printf
  .extern scanf

.section .rodata
prompt:
  .string "Enter n: "
input:
  .string "%d"
output:
  .string "result is %d\n"

# static memory, serve as function result address anchor
.section .bss
  .align 4
number:
  .zero 4

.section .text
  .global main    # expose it to gcc

factorial:
  pushq %rbp
  movq %rsp, %rbp

  # base case
  cmpq $1, %rdi
  jle base_case
  # %rdi is caller-saved
  pushq %rdi
  dec %rdi
  # call factorial(n-1), and result is %rax
  call factorial
  popq %rdi
  mulq %rdi
  jmp epilogue

base_case:
  movq $1, %rax

epilogue:
  movq %rbp, %rsp
  popq %rbp
  ret

main:
  # typical prologue
  pushq %rbp
  movq %rsp, %rbp

  # function
  # ask n
  movq $prompt, %rdi
  movq $0, %rax # no vector registers
  call printf

  movq $input, %rdi  # input format for scanf
  leaq number, %rsi    # static memory location for the n
  movq $0, %rax
  call scanf

  movslq number, %rdi

  # call factorial
  call factorial

  # print result
  movq %rax, %rsi       
  movq $output, %rdi
  movq $0, %rax         # printf has no vector-register arguments
  call printf

  # epilogue
  movq %rbp, %rsp
  popq %rbp
  ret


end:
.section .note.GNU-stack,"",@progbits
