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

  la $t0, -8($fp)
  add $t1, $t0, $zero
  sw $t1, -12($fp)
  li $t2, 1
  lw $t3, -12($fp)
  sw $t2, 0($t3)

  la $t4, -8($fp)
  li $t5, 4
  add $t6, $t4, $t5
  sw $t6, -16($fp)
  li $t7, 2
  lw $s0, -16($fp)
  sw $t7, 0($s0)

  la $s1, -8($fp)
  li $s2, 4
  add $s3, $s1, $s2
  sw $s3, -20($fp)
  lw $s4, -20($fp)
  lw $s4, 0($s4)
  move $a0, $s4
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
