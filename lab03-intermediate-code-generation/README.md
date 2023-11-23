# Lab 3 - 中间代码生成

## 实现的功能

### 加法操作

加法的优化与减法相差无几，但减法中被减数和减数有区别，只需关注减数为0的情况。而加法的两个操作数没有区别。因此，需要注意两个操作数分别为0的情况。

```c
InterCode optimizePLUSIR(Operand dest, Operand src1, Operand src2)
{
    // todo
    // 如果两个操作数都是常数，那么直接计算结果
    if (src1->kind == CONSTANT_OP && src2->kind == CONSTANT_OP)
    {
        operandCpy(dest, getValue(src1->value + src2->value));
        return getNullInterCode();
    }
    // 如果其中一个操作数是0，那么直接返回另一个操作数
    else if (src1->kind == CONSTANT_OP && src1->value == 0 &&
             src2->kind != GET_ADDR_OP && src2->kind != GET_VAL_OP)
    {
        operandCpy(dest, src2);
        return getNullInterCode();
    }
    else if (src2->kind == CONSTANT_OP && src2->value == 0 &&
             src1->kind != GET_ADDR_OP && src1->kind != GET_VAL_OP)
    {
        operandCpy(dest, src1);
        return getNullInterCode();
    }
    else
    {
        InterCode code1 = (InterCode)malloc(sizeof(InterCode_));
        code1->kind = PLUS_IR;
        code1->ops[0] = dest;
        code1->ops[1] = src1;
        code1->ops[2] = src2;
        return code1;
    }
}
```

### 乘法操作

同样地，乘法的优化与除法相差无几，但除法中被除数和除数有区别，只需关注被除数为0或除数为1的情况。而加法的两个操作数没有区别。因此，需要注意两个操作数分别为0或分别为1的情况。

```c
InterCode optimizeMULIR(Operand dest, Operand src1, Operand src2)
{
    // todo
    // 如果两个操作数都是常数，那么直接计算结果
    if (src1->kind == CONSTANT_OP && src2->kind == CONSTANT_OP)
    {
        operandCpy(dest, getValue(src1->value * src2->value));
        return getNullInterCode();
    }
    // 如果其中一个操作数是0，那么直接返回0
    else if ((src1->kind == CONSTANT_OP && src1->value == 0) || (src2->kind == CONSTANT_OP && src2->value == 0))
    {
        operandCpy(dest, getValue(0));
        return getNullInterCode();
    }
    // 如果其中一个操作数是1，那么直接返回另一个操作数
    else if (src1->kind == CONSTANT_OP && src1->value == 1 &&
             src2->kind != GET_ADDR_OP && src2->kind != GET_VAL_OP)
    {
        operandCpy(dest, src2);
        return getNullInterCode();
    }
    else if (src2->kind == CONSTANT_OP && src2->value == 1 &&
             src1->kind != GET_ADDR_OP && src1->kind != GET_VAL_OP)
    {
        operandCpy(dest, src1);
        return getNullInterCode();
    }
    else
    {
        InterCode code1 = (InterCode)malloc(sizeof(InterCode_));
        code1->kind = MUL_IR;
        code1->ops[0] = dest;
        code1->ops[1] = src1;
        code1->ops[2] = src2;
        return code1;
    }
}
```

### 左值单变量赋值表达式翻译

通过查表函数`findSymbolAll(char* name)`找到对应的变量。需要提一点的是，创建变量操作数时，`getVar(char* name)`应该传入1、2、3这样的整数生成v1、v2、v3类似这样的变量操作数名。但本次实验的假设提到：

> 在本次实验中，对C--语言做如下假设
>
> - ...
> - 假设4：没有全局变量的使用，并且所有变量均不重名。
> - ...

因此，直接使用变量自己的名字作为参数`getVar(leftOperand->name)`。

```c
        // 单个变量作为左值
        if (root->children[0]->childNum == 1 &&
            strcmp(root->children[0]->children[0]->name, "ID") == 0)
        {
            // todo
            // 通过查表找到ID对应的变量
            Entry leftOperand = findSymbolAll(root->children[0]->children[0]->strVal);
            // 然后对Exp2进行翻译（运算结果储存在临时变量t1中）
            Operand tmp1 = newTemp();
            InterCode code1 = translateExp(root->children[2], tmp1);

            // 再将t1中的值赋于ID所对应的变量
            InterCode code2 = (InterCode)malloc(sizeof(InterCode_));
            code2->kind = ASSIGN_IR;
            code2->ops[0] = getVar(leftOperand->name);
            code2->ops[1] = tmp1;

            // 并将结果再存回place
            if (place != NULL)
            {
                operandCpy(place, getVal(tmp1));
            }
            // 最后把刚翻译好的这两段代码合并随后返回即可
            insertInterCode(code2, code1);

            return code1;
        }
```

#### 结果

test1.cmm稍作修改

```
int main()
{
    int n;
    n = read();
    return 0;
}
```

```
FUNCTION main :
READ t1
vn := t1
RETURN #0
```

vn表示n。

### translateCond

在完成条件表达式之前，先完成translateCond。实际上就是照抄翻译模式。我的做法是先获取op，root->childNum<2时，op不会赋值，就是一个“no matter”字符串，下面的所有条件都不会满足，最终执行else里面的代码。root->childNum==2的情况，也就是NOT表达式，获取op以及翻译时，都要进行特殊处理。

```c
InterCode translateCond(Node *root, Operand labelTrue, Operand labelFalse)
{
    // todo

    // get op
    char *op = "no matter";
    if (root->childNum == 2)
    {
        op = root->children[0]->name;
    }
    else if (root->childNum > 2)
    {
        op = root->children[1]->name;
    }

    if (strcmp(op, "RELOP") == 0)
    {
        Operand t1 = newTemp();

        Operand t2 = newTemp();

        InterCode code1 = translateExp(root->children[0], t1);

        InterCode code2 = translateExp(root->children[2], t2);

        InterCode code3 = (InterCode)malloc(sizeof(InterCode_));
        code3->kind = IF_GOTO_IR;
        code3->ops[0] = t1;
        code3->ops[1] = t2;
        code3->ops[2] = labelTrue;
        strcpy(code3->relop, root->children[1]->strVal);

        InterCode code4 = (InterCode)malloc(sizeof(InterCode_));
        code4->kind = GOTO_IR;
        code4->ops[0] = labelFalse;
        insertInterCode(code3, code2);
        insertInterCode(code4, code2);
        return code2;
    }
    else if (strcmp(op, "NOT") == 0)
    {
        return translateCond(root->children[1], labelFalse, labelTrue);
    }
    else if (strcmp(op, "AND") == 0)
    {
        Operand label1 = newLabel();

        InterCode code1 = translateCond(root->children[0], label1, labelFalse);

        InterCode code2 = translateCond(root->children[2], labelTrue, labelFalse);

        InterCode code3 = (InterCode)malloc(sizeof(InterCode_));
        code3->kind = LABEL_IR;
        code3->ops[0] = label1;
        insertInterCode(code3, code1);
        insertInterCode(code2, code1);
        return code1;
    }
    else if (strcmp(op, "OR") == 0)
    {
        Operand label1 = newLabel();

        InterCode code1 = translateCond(root->children[0], labelTrue, label1);

        InterCode code2 = translateCond(root->children[2], labelTrue, labelFalse);

        InterCode code3 = (InterCode)malloc(sizeof(InterCode_));
        code3->kind = LABEL_IR;
        code3->ops[0] = label1;
        insertInterCode(code3, code1);
        insertInterCode(code2, code1);
        return code1;
    }
    else
    {
        Operand t1 = newTemp();

        InterCode code1 = translateExp(root, t1);

        InterCode code2 = (InterCode)malloc(sizeof(InterCode_));
        code2->kind = IF_GOTO_IR;
        code2->ops[0] = t1;
        code2->ops[1] = getValue(0);
        code2->ops[2] = labelTrue;
        strcpy(code2->relop, "!=");

        InterCode code3 = (InterCode)malloc(sizeof(InterCode_));
        code3->kind = GOTO_IR;
        code3->ops[0] = labelFalse;
        insertInterCode(code2, code1);
        insertInterCode(code3, code1);
        return code1;
    }
}
```

由于四个测试用例test1.cmm、test2.cmm、test_o1.cmm、test_o2.cmm中没有条件表达式和短路的代码。因此，自行写了一个测试用例。

观察到基本表达式翻译模式中Exp1 RELOP Exp2及相关部分，code0 = [place := #0]以及code2 = [LABEL label1] + [place := #1]，条件表达式的最终结果都是int类型的0或1，没有隐式转换，因此不能用bool，用int flag效果一样。bool实际上也就是0或1？

这个测试用例囊括了几乎条件表达式的所有情况。

```
int main() {
    int n = 1;
    int flag;
    flag = !(n > 0 && (n || n == 0));
    return 0;
}
```

#### 结果

```
FUNCTION main :
vn := #1
t2 := #0
t4 := #0
IF vn > #0 GOTO label5
GOTO label4
LABEL label5 :
t8 := #0
IF vn != #0 GOTO label6
GOTO label8
LABEL label8 :
IF vn == #0 GOTO label6
GOTO label7
LABEL label6 :
t8 := #1
LABEL label7 :
IF t8 != #0 GOTO label3
GOTO label4
LABEL label3 :
t4 := #1
LABEL label4 :
IF t4 != #0 GOTO label2
GOTO label1
LABEL label1 :
t2 := #1
LABEL label2 :
vflag := t2
RETURN #0

```

### 条件表达式

实际上还是照抄翻译模式。注意运用上面完成的translateCond。

```c
    else if (root->childNum >= 2 && (strcmp(root->children[0]->name, "NOT") == 0 ||
                                     strcmp(root->children[1]->name, "RELOP") == 0 ||
                                     strcmp(root->children[1]->name, "AND") == 0 ||
                                     strcmp(root->children[1]->name, "OR") == 0))
    {
        // todo
        Operand label1 = newLabel();

        Operand label2 = newLabel();

        InterCode code0 = (InterCode)malloc(sizeof(InterCode_));
        code0->kind = ASSIGN_IR;
        code0->ops[0] = place;
        code0->ops[1] = getValue(0);
        code0->ops[2] = NULL;

        InterCode code1 = translateCond(root, label1, label2);

        InterCode code2 = (InterCode)malloc(sizeof(InterCode_));
        code2->kind = LABEL_IR;
        code2->ops[0] = label1;
        code2->ops[1] = NULL;
        InterCode code3 = (InterCode)malloc(sizeof(InterCode_));
        code3->kind = ASSIGN_IR;
        code3->ops[0] = place;
        code3->ops[1] = getValue(1);
        code3->ops[2] = NULL;

        InterCode code4 = (InterCode)malloc(sizeof(InterCode_));
        code4->kind = LABEL_IR;
        code4->ops[0] = label2;
        code4->ops[1] = NULL;
        insertInterCode(code1, code0);
        insertInterCode(code2, code0);
        insertInterCode(code3, code0);
        insertInterCode(code4, code0);
        return code0;
    }
```

## 编译

在Makefile文件添加了运行命令。

```makefile
# 定义的一些伪目标
.PHONY: clean test
test: parser_
	./parser ../Test/test1.cmm ../result/test_case1.ir
	./parser ../Test/test2.cmm ../result/test_case2.ir
	./parser ../Test/test_o1.cmm ../result/test_case_o1.ir
	./parser ../Test/test_o2.cmm ../result/test_case_o2.ir
```

### 编译并测试

在Makefile所在目录，即Code/下，执行

```bash
make test
```

