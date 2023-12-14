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

mod:
  addi $sp, $sp, -4
  sw $fp, 0($sp)
  move $fp, $sp
  addi $sp, $sp, -72
  sw $t9, 68($sp)
  sw $t8, 64($sp)
  sw $s7, 60($sp)
  sw $s6, 56($sp)
  sw $s5, 52($sp)
  sw $s4, 48($sp)
  sw $s3, 44($sp)
  sw $s2, 40($sp)
  sw $s1, 36($sp)
  sw $s0, 32($sp)
  sw $t7, 28($sp)
  sw $t6, 24($sp)
  sw $t5, 20($sp)
  sw $t4, 16($sp)
  sw $t3, 12($sp)
  sw $t2, 8($sp)
  sw $t1, 4($sp)
  sw $t0, 0($sp)
  addi $sp, $sp, -32
  move $t0, $a0
  sw $t0, -76($fp)
  move $t1, $a1
  sw $t1, -80($fp)
  lw $t2, -76($fp)
  lw $t3, -80($fp)
  div $t2, $t3
  sw $t4, -84($fp)
  lw $t5, -84($fp)
  lw $t6, -80($fp)
  mul $t7, $t5, $t6
  sw $t7, -88($fp)
  lw $s0, -76($fp)
  lw $s1, -88($fp)
  sub $s2, $s0, $s1
  sw $s2, -92($fp)
  lw $s3, -92($fp)
  move $a0, $s3
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  lw $s4, -76($fp)
  lw $s5, -80($fp)
  div $s4, $s5
  sw $s6, -96($fp)
  lw $s7, -96($fp)
  lw $t8, -80($fp)
  mul $t9, $s7, $t8
  sw $t9, -100($fp)
  lw $t0, -76($fp)
  lw $t1, -100($fp)
  sub $t2, $t0, $t1
  sw $t2, -104($fp)
  lw $t3, -104($fp)
  move $v0, $t3
  addi $sp, $fp, -72
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  lw $t2, 8($sp)
  lw $t3, 12($sp)
  lw $t4, 16($sp)
  lw $t5, 20($sp)
  lw $t6, 24($sp)
  lw $t7, 28($sp)
  lw $s0, 32($sp)
  lw $s1, 36($sp)
  lw $s2, 40($sp)
  lw $s3, 44($sp)
  lw $s4, 48($sp)
  lw $s5, 52($sp)
  lw $s6, 56($sp)
  lw $s7, 60($sp)
  lw $t8, 64($sp)
  lw $t9, 68($sp)
  addi $sp, $sp, 72
  lw $fp, 0($sp)
  addi $sp, $sp, 4
  jr $ra

do_work:
  addi $sp, $sp, -4
  sw $fp, 0($sp)
  move $fp, $sp
  addi $sp, $sp, -72
  sw $t9, 68($sp)
  sw $t8, 64($sp)
  sw $s7, 60($sp)
  sw $s6, 56($sp)
  sw $s5, 52($sp)
  sw $s4, 48($sp)
  sw $s3, 44($sp)
  sw $s2, 40($sp)
  sw $s1, 36($sp)
  sw $s0, 32($sp)
  sw $t7, 28($sp)
  sw $t6, 24($sp)
  sw $t5, 20($sp)
  sw $t4, 16($sp)
  sw $t3, 12($sp)
  sw $t2, 8($sp)
  sw $t1, 4($sp)
  sw $t0, 0($sp)
  addi $sp, $sp, -8
  move $t0, $a0
  sw $t0, -76($fp)
  lw $t1, -76($fp)
  move $a0, $t1
  li $t2, 5
  move $a1, $t2
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal mod
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  move $t3, $v0
  sw $t3, -80($fp)
  lw $t4, -80($fp)
  move $t5, $t4
  sw $t5, -76($fp)
  lw $t6, -76($fp)
  move $v0, $t6
  addi $sp, $fp, -72
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  lw $t2, 8($sp)
  lw $t3, 12($sp)
  lw $t4, 16($sp)
  lw $t5, 20($sp)
  lw $t6, 24($sp)
  lw $t7, 28($sp)
  lw $s0, 32($sp)
  lw $s1, 36($sp)
  lw $s2, 40($sp)
  lw $s3, 44($sp)
  lw $s4, 48($sp)
  lw $s5, 52($sp)
  lw $s6, 56($sp)
  lw $s7, 60($sp)
  lw $t8, 64($sp)
  lw $t9, 68($sp)
  addi $sp, $sp, 72
  lw $fp, 0($sp)
  addi $sp, $sp, 4
  jr $ra

main:
  addi $sp, $sp, -4
  sw $fp, 0($sp)
  move $fp, $sp
  addi $sp, $sp, -252
  li $t0, 2
  move $t1, $t0
  sw $t1, -4($fp)
  li $t2, 5
  move $t3, $t2
  sw $t3, -8($fp)
  li $t4, 10
  move $t5, $t4
  sw $t5, -12($fp)
  lw $t6, -8($fp)
  lw $t7, -12($fp)
  mul $s0, $t6, $t7
  sw $s0, -16($fp)
  li $s1, 3
  lw $s2, -16($fp)
  mul $s3, $s1, $s2
  sw $s3, -20($fp)
  lw $s4, -20($fp)
  li $s5, 20
  sub $s6, $s4, $s5
  sw $s6, -24($fp)
  lw $s7, -24($fp)
  move $t8, $s7
  sw $t8, -28($fp)
  lw $t9, -4($fp)
  lw $t0, -8($fp)
  mul $t2, $t9, $t0
  sw $t2, -32($fp)
  lw $t4, -8($fp)
  lw $s1, -12($fp)
  mul $s5, $t4, $s1
  sw $s5, -36($fp)
  lw $t1, -4($fp)
  lw $t3, -36($fp)
  mul $t5, $t1, $t3
  sw $t5, -40($fp)
  lw $t6, -40($fp)
  li $t7, 32
  div $t6, $t7
  sw $s0, -44($fp)
  lw $t7, -32($fp)
  lw $s2, -44($fp)
  mul $s3, $t7, $s2
  sw $s3, -48($fp)
  li $s4, 42
  lw $s6, -48($fp)
  sub $s7, $s4, $s6
  sw $s7, -52($fp)
  lw $s4, -52($fp)
  li $t8, 100
  add $t9, $s4, $t8
  sw $t9, -56($fp)
  lw $t8, -56($fp)
  move $t0, $t8
  sw $t0, -60($fp)
  lw $t2, -4($fp)
  lw $t4, -8($fp)
  mul $s1, $t2, $t4
  sw $s1, -64($fp)
  lw $s5, -64($fp)
  li $t1, 3
  mul $t3, $s5, $t1
  sw $t3, -68($fp)
  lw $t1, -68($fp)
  sub $t5, $zero, $t1
  sw $t5, -72($fp)
  li $t6, 50
  lw $s0, -72($fp)
  sub $t7, $t6, $s0
  sw $t7, -76($fp)
  lw $t6, -4($fp)
  lw $s2, -8($fp)
  mul $s3, $t6, $s2
  sw $s3, -80($fp)
  lw $s6, -76($fp)
  lw $s7, -80($fp)
  sub $s4, $s6, $s7
  sw $s4, -84($fp)
  lw $t9, -4($fp)
  lw $t8, -8($fp)
  mul $t0, $t9, $t8
  sw $t0, -88($fp)
  lw $t2, -84($fp)
  lw $t4, -88($fp)
  sub $s1, $t2, $t4
  sw $s1, -92($fp)
  lw $s5, -92($fp)
  li $t3, 3
  add $t1, $s5, $t3
  sw $t1, -96($fp)
  lw $t3, -96($fp)
  li $t5, 2
  add $s0, $t3, $t5
  sw $s0, -100($fp)
  lw $t5, -100($fp)
  li $t7, 1
  add $t6, $t5, $t7
  sw $t6, -104($fp)
  lw $t7, -104($fp)
  move $s2, $t7
  sw $s2, -108($fp)
  move $s3, $zero
  sw $s3, -112($fp)
  move $s6, $zero
  sw $s6, -116($fp)
  lw $s7, -4($fp)
  lw $s4, -8($fp)
  mul $t9, $s7, $s4
  sw $t9, -120($fp)
  lw $t8, -120($fp)
  move $t0, $t8
  sw $t0, -124($fp)
  lw $t2, -28($fp)
  move $a0, $t2
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  lw $t4, -60($fp)
  move $a0, $t4
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  lw $s1, -108($fp)
  move $a0, $s1
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
label1:
  lw $s5, -112($fp)
  lw $t1, -108($fp)
  blt $s5, $t1, label2
  j label3
label2:
  lw $t3, -116($fp)
  li $s0, 1
  add $t5, $t3, $s0
  sw $t5, -208($fp)
  lw $s0, -208($fp)
  move $t6, $s0
  sw $t6, -116($fp)
  lw $t7, -112($fp)
  move $a0, $t7
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  lw $s2, -124($fp)
  move $a0, $s2
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  lw $s3, -112($fp)
  move $a0, $s3
  lw $s6, -124($fp)
  move $a1, $s6
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal mod
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  move $s7, $v0
  sw $s7, -212($fp)
  lw $s4, -212($fp)
  move $a0, $s4
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  lw $t9, -112($fp)
  move $a0, $t9
  lw $t8, -124($fp)
  move $a1, $t8
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal mod
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  move $t0, $v0
  sw $t0, -216($fp)
  lw $t2, -216($fp)
  li $t4, 4
  mul $s1, $t2, $t4
  sw $s1, -220($fp)
  lw $t4, -220($fp)
  add $s5, $a1, $t4
  sw $s5, -224($fp)
  lw $t1, -28($fp)
  lw $t3, -224($fp)
  sw $t1, 0($t3)
  lw $t5, -28($fp)
  li $s0, 1
  add $t6, $t5, $s0
  sw $t6, -228($fp)
  lw $s0, -228($fp)
  move $t7, $s0
  sw $t7, -28($fp)
  lw $s2, -112($fp)
  li $s3, 1
  add $s6, $s2, $s3
  sw $s6, -232($fp)
  lw $s3, -232($fp)
  move $s7, $s3
  sw $s7, -112($fp)
  j label1
label3:
  move $s4, $zero
  sw $s4, -112($fp)
label4:
  lw $t9, -112($fp)
  li $t8, 100
  blt $t9, $t8, label5
  j label6
label5:
  lw $t8, -112($fp)
  move $a0, $t8
  lw $t0, -124($fp)
  move $a1, $t0
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal mod
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  move $t2, $v0
  sw $t2, -236($fp)
  lw $s1, -236($fp)
  li $t4, 4
  mul $s5, $s1, $t4
  sw $s5, -240($fp)
  lw $t4, -240($fp)
  add $t1, $a1, $t4
  sw $t1, -244($fp)
  lw $t3, -28($fp)
  lw $t5, -244($fp)
  sw $t3, 0($t5)
  lw $t6, -28($fp)
  li $s0, 1
  add $t7, $t6, $s0
  sw $t7, -248($fp)
  lw $s0, -248($fp)
  move $s2, $s0
  sw $s2, -28($fp)
  lw $s6, -112($fp)
  li $s3, 1
  add $s7, $s6, $s3
  sw $s7, -252($fp)
  lw $s3, -252($fp)
  move $s4, $s3
  sw $s4, -112($fp)
  j label4
label6:
  move $v0, $zero
  move $sp, $fp
  lw $fp, 0($sp)
  addi $sp, $sp, 4
  jr $ra
