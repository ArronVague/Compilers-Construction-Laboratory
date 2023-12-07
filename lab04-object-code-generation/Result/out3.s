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
  li $t0, 2
  move $t1, $t0
  sw $t1, -4($fp)

  lw $t2, -12($fp)

  add $t3, $t2, $zero
  sw $t3, -16($fp)
  li $t4, 1
  lw $t5, -16($fp)
  sw $t4, 0($t5)

  lw $t6, -12($fp)

  li $t7, 4
  add $s0, $t6, $t7
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
