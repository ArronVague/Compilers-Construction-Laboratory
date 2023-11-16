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

由于四个测试用例test1.cmm、test2.cmm、test_o1.cmm、test_o2.cmm中没有条件表达式和短路的代码。因此，自行写了一个测试用例。

观察到基本表达式翻译模式中Exp1 RELOP Exp2及相关部分，code0 = [place := #0]以及code2 = [LABEL label1] + [place := #1]，条件表达式的最终结果都是int类型的0或1，没有隐式转换，因此不能用bool，用int flag效果一样。bool实际上也就是0或1？

```
int main() {
    int n = 1;
    int flag;
    flag = (n > 0 && n > 1);
    return 0;
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

