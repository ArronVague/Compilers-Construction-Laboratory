free为1是表示寄存器空闲。

```c
// 寄存器描述符
struct RegDes_d {
    int free;   // 标记是否可用，用来协调寄存器分配的互不抢占
    int interval;   // 距上次访问的间隔，用于寄存器选择
    char name[6];   // 寄存器别名
    VarDes var; // 存储在该寄存器中的变量的描述符
};
```

会将作为参数传入的一个寄存器的interval设置为0，其他的寄存器+1，表示未使用的时间变长了。

```c
// 更新寄存器的使用间隔
void updateInterval(RegDes reg)
{
    for (int i = 8; i < 26; i++)
        regs[i]->interval++;
    reg->interval = 0;
}
```

分配寄存器时，不存在空闲寄存器的做法。

```c
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
        // 这里是个很隐蔽的错误，因为对编译器的翻译而言，寄存器中的变量变化是线性的
        // 而对于实际的机器执行而言，寄存器中的变量变化存在很多可能的分支，编译器仅能确保在一条语句的翻译过程中的变量正确
        // 所以这里并不能保存寄存器中的旧值，因为我们不知道在实际运行过程中到达这条语句的该寄存器中存放的是否还是那个变量
        // spillReg(regs[i], fp);
        // regs[i]->var->regNo = -1;
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
```

至今没搞懂handleOp的意义，对地址操作数，需要将寄存器存的地址指向的操作数存到寄存器？

将实际的操作数存入寄存器。

注意：getReg是不处理地址操作数的

加法指令模板

sw source, offset(base)是将source存储到base偏移offset后的内存地址里。

除法照抄

```c
        case PLUS_IR:
        {
            Operand left = curr->ops[0];
            Operand right1 = curr->ops[1];
            Operand right2 = curr->ops[2];
            int regRight1 = handleOp(right1, fp, 1);
            int regRight2 = handleOp(right2, fp, 1);
            if (left->kind == VARIABLE_OP || left->kind == TEMP_VAR_OP)
            {
                int regLeft = getReg(left, fp, 0);
                fprintf(fp, "  add %s, %s, %s\n", regs[regLeft]->name, regs[regRight1]->name, regs[regRight2]->name);
                spillReg(regs[regLeft], fp);
            }
            else if (left->kind == GET_VAL_OP)
            {
                int regLeft1 = getReg(left->opr, fp, 0);
                fprintf(fp, "  add %s, %s, %s\n", regs[regLeft1]->name, regs[regRight1]->name, regs[regRight2]->name);
                int regLeft2 = getReg(left->opr, fp, 1);
                fprintf(fp, "  sw %s, 0(%s)\n", regs[regLeft1]->name, regs[regLeft2]->name);
            }
            break;
        }
```

```c
        case MUL_IR:
        {
            Operand left = curr->ops[0];
            Operand right1 = curr->ops[1];
            Operand right2 = curr->ops[2];
            int regRight1 = handleOp(right1, fp, 1);
            int regRight2 = handleOp(right2, fp, 1);
            if (left->kind == VARIABLE_OP || left->kind == TEMP_VAR_OP)
            {
                int regLeft = getReg(left, fp, 0);
                fprintf(fp, "  mul %s, %s, %s\n", regs[regLeft]->name, regs[regRight1]->name, regs[regRight2]->name);
                spillReg(regs[regLeft], fp);
            }
            else if (left->kind == GET_VAL_OP)
            {
                int regLeft1 = getReg(left->opr, fp, 0);
                fprintf(fp, "  mul %s, %s, %s\n", regs[regLeft1]->name, regs[regRight1]->name, regs[regRight2]->name);
                int regLeft2 = getReg(left->opr, fp, 1);
                fprintf(fp, "  sw %s, 0(%s)\n", regs[regLeft1]->name, regs[regLeft2]->name);
            }
            break;
        }
```

