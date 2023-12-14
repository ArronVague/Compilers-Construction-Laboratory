.data
_prompt: .asciiz "Enter an integer:"
_ret: .asciiz "\n"
.globl main
.text
read:
  li $v0, 4
  la $a0, _prompt
  syscall
  li $v0, 5
  syscall
  jr $ra

write:
  li $v0, 1
  syscall
  li $v0, 4
  la $a0, _ret
  syscall
  move $v0, $0
  jr $ra

main:
  addi $sp, $sp, -4
  sw $fp, 0($sp)
  move $fp, $sp
  addi $sp, $sp, -20
  add $t0, $a1, $zero
  sw $t0, -12($fp)
  li $t1, 1
  lw $t2, -12($fp)
  sw $t1, 0($t2)
  li $t3, 4
  add $t4, $a1, $t3
  sw $t4, -16($fp)
  li $t5, 2
  lw $t6, -16($fp)
  sw $t5, 0($t6)
  li $t7, 4
  add $s0, $a1, $t7
  sw $s0, -20($fp)
  lw $s1, -20($fp)
  lw $s1, 0($s1)
  move $a0, $s1
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  move $v0, $zero
  move $sp, $fp
  lw $fp, 0($sp)
  addi $sp, $sp, 4
  jr $ra
