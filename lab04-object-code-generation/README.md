# Lab 4 - 目标代码生成

## 实现的功能

### 1）在存在空闲寄存器的情况下，为变量描述符分配寄存器

参考不存在空闲寄存器的情况：该情况下，程序会尝试找一个free并且存放常量的寄存器。如果找到了，那么将该寄存器分配给变量描述符；如果没找到，接着寻找未被使用时间interval最大的寄存器，将其分配给变量描述符。

而存在空闲寄存器的情况下，不需要替换寄存器。直接将空闲寄存器分配给变量描述符，模仿不存在空闲寄存器情况下的后半部分的分配代码。

```c
/*
 * 为变量描述符分配寄存器, load用于指示是否需要装载寄存器，
 * 形如 x = y op z 的表达式中，为x分配寄存器就不需要装载，而为y和z分配时都需要
 */
int allocateReg(VarDes var, FILE *fp, int load)
{
    // 查找是否有空闲寄存器
    int i = 8;
    for (; i < 26; i++)
        if (regs[i]->var == NULL)
            break;
    // 存在空闲寄存器
    if (i >= 8 && i < 26)
    {
        // TODO
        regs[i]->var = var;
        updateInterval(regs[i]);
        if (load == 1)
        {
            // 常量装载到寄存器中
            if (var->op->kind == CONSTANT_OP)
                fprintf(fp, "  li %s, %d\n", regs[i]->name, var->op->value);
            // 将栈中存储的变量的值装载到寄存器中
            else if (var->op->kind == VARIABLE_OP || var->op->kind == TEMP_VAR_OP)
                fprintf(fp, "  lw %s, %d($fp)\n", regs[i]->name, -var->offset);
        }
        return i;
    }
    // 不存在空闲寄存器
    else if (i == 26)
    {
        // 最长时间未使用算法
        // 先尝试找到一个free并且存放常量的寄存器
        for (i = 8; i < 26; i++)
            if (regs[i]->free == 1 && regs[i]->var->op->kind == CONSTANT_OP)
                break;
        // 然后找interval最大的那个寄存器
        if (i == 26)
        {
            int max = 0;
            int res = 8;
            for (i = 8; i < 26; i++)
                if (regs[i]->free == 1 && regs[i]->interval >= max)
                {
                    max = regs[i]->interval;
                    res = i;
                }
            i = res;
        }
        regs[i]->var = var;
        updateInterval(regs[i]);
        // var->regNo = i;
        if (load == 1)
        {
            // 常量装载到寄存器中
            if (var->op->kind == CONSTANT_OP)
                fprintf(fp, "  li %s, %d\n", regs[i]->name, var->op->value);
            // 将栈中存储的变量的值装载到寄存器中
            else if (var->op->kind == VARIABLE_OP || var->op->kind == TEMP_VAR_OP)
                fprintf(fp, "  lw %s, %d($fp)\n", regs[i]->name, -var->offset);
        }
        return i;
    }
}
```

### 2）地址操作数的装载

不会。其实必做的两个样例没有用到地址操作数。

### 3）ASSIGN_IR

参考PLUS_IR的代码，赋值指令与加法指令的区别就在于：赋值指令的右操作数只有一个，并且使用move指令替换add指令。

```c
        case ASSIGN_IR:
        {
            // TODO
            Operand left = curr->ops[0];
            Operand right = curr->ops[1];
            int regRight = handleOp(right, fp, 1);
            if (left->kind == VARIABLE_OP || left->kind == TEMP_VAR_OP)
            {
                int regLeft = getReg(left, fp, 0);
                fprintf(fp, "  move %s, %s\n", regs[regLeft]->name, regs[regRight]->name);
                spillReg(regs[regLeft], fp);
            }
            else if (left->kind == GET_VAL_OP)
            {
                int regLeft1 = getReg(left->opr, fp, 0);
                fprintf(fp, "  move %s, %s\n", regs[regLeft1]->name, regs[regRight]->name);
                int regLeft2 = getReg(left->opr, fp, 1);
                fprintf(fp, "  sw %s, 0(%s)\n", regs[regLeft1]->name, regs[regLeft2]->name);
            }
            break;
        }
```

### 4）SUB_IR

参考PLUS_IR的代码，将add指令替换成sub指令。

```c
        case SUB_IR:
        {
            // TODO
            Operand left = curr->ops[0];
            Operand right1 = curr->ops[1];
            Operand right2 = curr->ops[2];
            int regRight1 = handleOp(right1, fp, 1);
            int regRight2 = handleOp(right2, fp, 1);
            if (left->kind == VARIABLE_OP || left->kind == TEMP_VAR_OP)
            {
                int regLeft = getReg(left, fp, 0);
                fprintf(fp, "  sub %s, %s, %s\n", regs[regLeft]->name, regs[regRight1]->name, regs[regRight2]->name);
                spillReg(regs[regLeft], fp);
            }
            else if (left->kind == GET_VAL_OP)
            {
                int regLeft1 = getReg(left->opr, fp, 0);
                fprintf(fp, "  sub %s, %s, %s\n", regs[regLeft1]->name, regs[regRight1]->name, regs[regRight2]->name);
                int regLeft2 = getReg(left->opr, fp, 1);
                fprintf(fp, "  sw %s, 0(%s)\n", regs[regLeft1]->name, regs[regLeft2]->name);
            }
            break;
        }
```

### 5）DIV_IR

参考MUL_IR的代码，将mul指令替换成div指令。

```c
        case DIV_IR:
        {
            // TODO
            Operand left = curr->ops[0];
            Operand right1 = curr->ops[1];
            Operand right2 = curr->ops[2];
            int regRight1 = handleOp(right1, fp, 1);
            int regRight2 = handleOp(right2, fp, 1);
            if (left->kind == VARIABLE_OP || left->kind == TEMP_VAR_OP)
            {
                int regLeft = getReg(left, fp, 0);
                fprintf(fp, "  div %s, %s\n", regs[regRight1]->name, regs[regRight2]->name);
                spillReg(regs[regLeft], fp);
            }
            else if (left->kind == GET_VAL_OP)
            {
                int regLeft1 = getReg(left->opr, fp, 0);
                fprintf(fp, "  div %s, %s\n", regs[regRight1]->name, regs[regRight2]->name);
                int regLeft2 = getReg(left->opr, fp, 1);
                fprintf(fp, "  sw %s, 0(%s)\n", regs[regLeft1]->name, regs[regLeft2]->name);
            }
            break;
        }
```

## 如何编译

#### 编译

在Makefile所在文件夹下，即Code文件夹下执行，在Result文件夹中生成.s汇编代码文件。

```bash
make test
```

#### 测试

同时，添加了批量测试的命令。

```makefile
spim-test:
	echo "7" | spim -file ../Result/out1.s
	echo "7" | spim -file ../Result/out2.s
```

同样地，在Code文件夹下执行，批量测试输入为7时，两个样例的输出结果。

```bash
make spim-test
```



