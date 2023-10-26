# Lab 2 - 语义分析

## 必做

### 错误类型1：变量在使用时未经定义。

维持一个符号表，在使用变量前查找符号表。

```c
        if (root->childNum == 1)
        {
            Entry sym = findSymbolAll(root->children[0]->strVal);
            // 使用不存在的变量
            if (sym == NULL)
            {
                printf("Error type 1 at line %d: Undefined variable \"%s\".\n", root->lineno, root->children[0]->strVal);
                return NULL;
            }
            return sym->type;
        }
```

### 错误类型2：函数在调用时未经定义。

样例2中使用了不存在的函数。维持符号表，在使用函数前会尝试`findSymbolFunc`，如果为空，继续尝试`findSymbolAll`，如果还是没找到，说明使用了不存在的函数。

```c
        // ID是一个函数名
        else
        {
            Entry sym = findSymbolFunc(root->children[0]->strVal);
            if (sym == NULL)
            {
                sym = findSymbolAll(root->children[0]->strVal);
                // 对普通变量使用()操作符
                if (sym != NULL)
                {
                    ...
                }
                // 使用不存在的函数
                else
                {
                    printf("Error type 2 at line %d: Undefined function \"%s\".\n", root->lineno, root->children[0]->strVal);
                    return NULL;
                }
            }
```

### 错误类型3：变量出现重复定义，或变量与前面定义过的结构体名字重复。

样例3为变量出现了重复定义。

查询符号表，若`findSymbolLayer`返回值不为空，说明变量出现了重复定义。

```c
        Entry sym = findSymbolLayer(root->children[0]->strVal);
        Entry symA = findSymbolAll(root->children[0]->strVal);
        // 域名/变量名重复定义或与结构体定义重复
        if (sym != NULL || (symA != NULL && symA->type->kind == ENUM_STRUCT_DEF))
        {
            ...
            if (class == ENUM_VAR)
                printf("Error type 3 at line %d: Redefined variable \"%s\".\n", root->lineno, root->children[0]->strVal);
            ...
        }
```

### 错误类型4：函数出现重复定义（即同样的函数名出现了不止一次定义）。

样例4是函数的重复定义。

在符号表中查询函数名`findSymbolFunc`，如果返回值`sym`不为空且已经定义过，同时当前节点是函数定义的语法结构，说明出现了函数重复定义。

```c
        Entry sym = findSymbolFunc(func->name);
        // 存在同名函数声明/定义
        if (sym != NULL)
        {
            // 是函数定义
            if (sym->type->func->hasDefined == 1)
            {
                // 重复定义
                if (strcmp(root->children[2]->name, "CompSt") == 0)
                    printf("Error type 4 at line %d: Redefined function \"%s\".\n", root->lineno, sym->name);
                ...
                return;
            }
             ...
        }
```

### 错误类型5：赋值号两边的表达式类型不匹配。

直接比较左表达式和右表达式的类型，如果`typeEqual`返回值为0，说明出现了赋值号两边的表达式类型不匹配。

```c
            if (leftType != NULL && rightType != NULL && !typeEqual(leftType, rightType))
            {
                printf("Error type 5 at line %d: Type mismatched for assignment.\n", root->lineno);
                return NULL;
            }
```

### 错误类型6：赋值号左边出现一个只有右值的表达式。

判断左值是否为三种情况

1. 变量

2. 域

3. 数组元素

如果三种都不是，说明赋值号左边出现了只有右值的表达式。

```c
        else if (strcmp(root->children[1]->name, "ASSIGNOP") == 0)
        {
            // 左值只有三种情况
            // 1、变量
            // 2、域
            // 3、数组元素
            Node *left = root->children[0];
            Node *right = root->children[2];
            Type leftType = NULL;
            Type rightType = Exp(right);
            if ((left->childNum == 1 && strcmp(left->children[0]->name, "ID") == 0) ||
                (left->childNum == 4 && strcmp(left->children[1]->name, "LB") == 0) ||
                (left->childNum == 3 && strcmp(left->children[1]->name, "DOT") == 0))
                leftType = Exp(left);
            else
            {
                printf("Error type 6 at line %d: The left-hand side of an assignment must be a variable.\n", root->lineno);
                return NULL;
            }
            ...
        }
```

### 错误类型7：操作数类型不匹配或操作数类型与操作符不匹配（例如整型变量与数组变量相加减，或数组（或结构体）变量与数组（或结构体）变量相加减）。

样例7是操作数类型不匹配。

与错误类型5：赋值号两边的表达式类型不匹配的思路类似，判断操作符两边的表达式类型是否一致，如果`typeEqual`返回值为0，说明操作数类型不匹配。

```c
        // 普通二元运算操作
        else
        {
            Type pre = Exp(root->children[0]);
            Type aft = Exp(root->children[2]);
            ...
            if (!typeEqual(pre, aft))
            {
                printf("Error type 7 at line %d: Type mismatched for operands.\n", root->lineno);
                return NULL;
            }
            ...
        }
```

### 错误类型8：return语句的返回类型与函数定义的返回类型不匹配。

如果出现了return语句，简单判断返回类型与函数定义的返回类型是否一致。

```c
    if (strcmp(root->children[0]->name, "RETURN") == 0)
    {
        Type type = Exp(root->children[1]);
        if (!typeEqual(reType, type))
            printf("Error type 8 at line %d: Type mismatched for return.\n", root->lineno);
    }
```

### 错误类型9：函数调用时实参与形参的数目或类型不匹配。

样例9是函数调用时实参与形参的数目不匹配。

关键是循环判断实参与形参是否相等之后，判断`args`和`realArgs`是否同时为空，如果不是，说明实参与形参的数目不匹配。

```c
            int flag = 1;
            while (args != NULL && realArgs != NULL)
            {
                if (!typeEqual(args->type, realArgs->type))
                {
                    flag = 0;
                    break;
                }
                args = args->next;
                realArgs = realArgs->next;
            }
            if (args != NULL || realArgs != NULL)
                flag = 0;
            if (flag == 0)
            {
                printf("Error type 9 at line %d: The method \"%s(", root->lineno, sym->name);
                printArgs(sym->type->func->head);
                printf(")\" is not applicable for the arguments \"(");
                printArgs(args_);
                printf(")\".\n");
            }
```

### 错误类型10：对非数组型变量使用“[…]”（数组访问）操作符。

出现[时，判断`pre`的类型是否为数组，如果不是，说明对非数组型变量使用“[...]”操作符。

```c
       // 数组取地址操作
        else if (strcmp(root->children[1]->name, "LB") == 0)
        {
            Type pre = Exp(root->children[0]);
            if (pre != NULL)
            {
                if (pre->kind != ENUM_ARRAY)
                {
                    printf("Error type 10 at line %d: Expect an array before [...].\n", root->lineno);
                    return NULL;
                }
                ...
            }
            ...
        }
```

### 错误类型11：对普通变量使用“(…)”或“()”（函数调用）操作符。

在错误类型1的基础上完善，思路与错误类型10相似，多了一些步骤。先查询ID`findSymbolFunc`，是否作为函数出现过，如果没有出现过，可能是普通变量。再查询`findSymbolAll`，如果不为空，说明是普通变量，且对普通变量使用了“(…)”或“()”操作符。

```c
        // ID是一个函数名
        else
        {
            Entry sym = findSymbolFunc(root->children[0]->strVal);
            if (sym == NULL)
            {
                sym = findSymbolAll(root->children[0]->strVal);
                // 对普通变量使用()操作符
                if (sym != NULL)
                {
                    printf("Error type 11 at line %d: \"%s\" is not a function.\n", root->lineno, sym->name);
                    return NULL;
                }
            ...
        }
```

### 错误类型12：数组访问操作符“[…]”中出现非整数（例如a[1.5]）。

在错误类型10的基础上完善，在确认`pre`是数组型变量后，判断`index`的类型，如果不为整数类型，报错。

```c
        // 数组取地址操作
        else if (strcmp(root->children[1]->name, "LB") == 0)
        {
            Type pre = Exp(root->children[0]);
            if (pre != NULL)
            {
                ...
                Type index = Exp(root->children[2]);
                if (index == NULL || index->kind != ENUM_BASIC || index->basic != INT_TYPE)
                {
                    printf("Error type 12 at line %d: Expect an integer in [...].\n", root->lineno);
                    return NULL;
                }
                return pre->array.elem;
            }
            ...
        }
```

### 错误类型13：对非结构体型变量使用“.”操作符。

简单判断`res`的类型是否为结构体，如果不是，说明对非结构体型变量使用了“.”操作符。

```c
       // 对结构体使用.操作符
        if (strcmp(root->children[1]->name, "DOT") == 0)
        {
            Type res = Exp(root->children[0]);
            if (res != NULL)
            {
                if (res->kind != ENUM_STRUCT)
                {
                    printf("Error type 13 at line %d: Illegal use of \".\".\n", root->lineno);
                    return NULL;
                }
                ...
            }
            return res;
        }
```

### 错误类型14：访问结构体中未定义过的域。

遍历结构体`head`链表，如果没有出现同名的域，`ans`的值为空，说明访问了结构体中未定义的域。

```c
                // 检测域名是否有效
                FieldList head = res->structure->head;
                Type ans = NULL;
                while (head != NULL)
                {
                    if (strcmp(field, head->name) == 0)
                    {
                        ans = head->type;
                        break;
                    }
                    head = head->next;
                }
                // 域名不存在
                if (ans == NULL)
                {
                    printf("Error type 14 at line %d: Non-existed field \"%s\".\n", root->lineno, field);
                    return NULL;
                }
```

### 错误类型15：结构体中域名重复定义（指同一结构体中），或在定义时对域进行初始化（例如struct A { int a = 0; }）。

样例15是结构体中域名重复定义。

实现思路与错误类型4相同，仅是判断域名/变量名的不同。

### 错误类型16：结构体的名字与前面定义过的结构体或变量的名字重复。

简单的查询符号表，如果`findSymbolAll`返回值不为空，说明结构体的名字重复。

### 错误类型17：直接使用未定义过的结构体来定义变量。

同样是查询符号表，如果`findSymbolAll`返回值为空，或者返回值不为空，但类型不是结构体，说明结构体未定义。

## 选做

### 选择完成2.3

> 要求2.3：修改前面的C−−语言假设5，将结构体间的类型等价机制由名等价改为结构等价（Structural Equivalence）。例如，虽然名称不同，但两个结构体类型struct a { int x; float y; }和struct b { int y; float z; }仍然是等价的类型。注意，在结构等价时不要将数组展开来判断，例如struct A { int a; struct { float f; int i; } b[10]; }和struct B { struct { int i; float f; } b[10]; int b;}是不等价的。在新的假设5下，完成错误类型1至17的检查。

```c
    // 结构体类型结构等价
    else if (a->kind == ENUM_STRUCT)
    {
        FieldList aFields = a->structure->head;
        FieldList bFields = b->structure->head;
        int res = 1;
        while (aFields != NULL && bFields != NULL)
        {
            if (!typeEqual(aFields->type, bFields->type))
            {
                res = 0;
                break;
            }
            aFields = aFields->next;
            bFields = bFields->next;
        }
        if (aFields != NULL || bFields != NULL)
            res = 0;
        return res;
    }
```

每个变量都会存储自己的kind类型，当变量的kind为结构体时，进入结构体判断。

分别获取左右结构体的结构体域链表头。

题目要求中

> struct A { int a; struct { float f; int i; } b[10]; }和struct B { struct { int i; float f; } b[10]; int b;}

可见，结构体是否等价，取决于结构体的变量是否相同，以及变量声明的顺序是否相同，并不关注变量的名字是否相同。因此，只需简单地对结构体域按链表顺序判断是否等价即可。

很简单地判断两条链表是否相等。只是相等的判断方式替换成了`typeEqual`。

判断失败的条件：

- 结构体中变量类型不同

- 变量声明顺序不同

- 变量个数不同
