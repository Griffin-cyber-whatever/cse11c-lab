# int pow(int base, int exp) {
#  int total = 1;
#  if ( exp == 0 ) return total;
#  for (int i = 0; i < exp; ++i) {
#    total *= base;
#  }
#  return total;
# printf(person_info);
# }


  .extern printf
  .extern scanf

.section .rodata
prompt_exp:
  .string "Enter exponent: "
prompt_base:
  .string "Enter base: "
input:
  .string "%d"
output:
  .string "result is %d\n"

# static memory, serve as function result address anchor
.section .bss
  .align 4
number:
  .zero 4
base:
  .zero 4
exponent:
  .zero 4

.section .text
  .global main    # expose it to gcc

pow:
  pushq %rbp
  movq %rsp, %rbp

  # $rdi is base, %rsi is exp, %rax is result
  movq $1, %rax
  cmpq $0, %rsi
  jle end_loop
loop:
  # %rax * base
  mulq %rdi
  dec %rsi
  cmpq $0, %rsi
  jg loop

end_loop:
  movq %rbp, %rsp
  pop %rbp
  ret

main:
  # typical prologue
  pushq %rbp
  movq %rsp, %rbp

  # function
  # ask base
  movq $prompt_base, %rdi
  movq $0, %rax # no vector registers
  call printf

  movq $input, %rdi  # input format for scanf
  leaq base, %rsi    # static memory location for the base
  movq $0, %rax
  call scanf

  # ask exp
  movq $prompt_exp, %rdi
  movq $0, %rax
  call printf

  movq $input, %rdi
  leaq exponent, %rsi  # static memory location for the exponent
  movq $0, %rax
  call scanf

  movslq base, %rdi
  movslq exponent, %rsi

  # call pow
  call pow

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
