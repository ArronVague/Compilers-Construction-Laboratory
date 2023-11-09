semantic.h定义了几种类型

```c
struct Type_d {
    Kind kind;
    union {
        // 基本类型
        int basic;
        // 数组类型包括元素类型与数组大小构成
        struct {
            Type elem;
            int size;
        } array;
        // 结构体类型是一个链表
        Structure structure;
        // 函数类型
        Function func;
    };
};
```

- 基本类型basic
  
  - INT
  
  - FLOAT

- 数组类型array（包括元素类型Type和数组大小）

- 结构体类型

- 函数类型

结构体类型和函数类型都是链表，其中均有成员变量FieldList head，这是结构体域链表节点。

- 符号表条目类型？（暂时不知道是什么东西）

```c
// 结构体域链表节点
struct FieldList_d {
    // 域的名字
    char name[32];
    // 域的类型
    Type type;
    // 指向下一个域的指针
    FieldList next;
};

// 结构体类型
struct Structure_d {
    char name[32];
    FieldList head;
};

// 函数类型
struct Function_d {
    char name[32];
    // 返回值类型
    Type returnType;
    // 参数个数
    int parmNum;
    // 参数链表头节点指针
    FieldList head;
    // 是否已经定义
    int hasDefined;
    // 所在行数
    int lineno;
};

// 符号表条目类型
struct Entry_d {
    char name[32];
    Type type;
    // 指向同一槽位的下一个条目
    Entry hashNext;
    // 指向同一层次的下一个条目
    Entry layerNext;
};
```

# lab2

本次实验使用**散列表**（即哈希）来实现符号表

semantic.c

Entry symbolTable[] 散列表

存储符号，不管符号的层次

layersHead负责管理符号的层次

类型等价判断函数中

int typeEqual(Type a, Type b)中，Type代码

```c
struct Type_d {
    Kind kind;
    union {
        // 基本类型
        int basic;
        // 数组类型包括元素类型与数组大小构成
        struct {
            Type elem;
            int size;
        } array;
        // 结构体类型是一个链表
        Structure structure;
        // 函数类型
        Function func;
    };
};
```

## 虚拟机迁移后遇到突然连不上网的问题

- 宿主windows中，settings -> Betwork & internet -> Advanced network settings，允许虚拟机的网络适配器

- 虚拟机中
  
  ```powershell
  sudo dhclient ens33
  ```

## 选择完成2.3

要求2.3：修改前面的C−−语言假设5，将结构体间的类型等价机制由名等价改为结构等价（Structural Equivalence）。例如，虽然名称不同，但两个结构体类型struct a { int x; float y; }和struct b { int y; float z; }仍然是等价的类型。注意，在结构等价时不要将数组展开来判断，例如struct A { int a; struct { float f; int i; } b[10]; }和struct B { struct { int i; float f; } b[10]; int b;}是不等价的。在新的假设5下，完成错误类型1至17的检查。

### 样例5

结构体赋值操作

```c
        // 赋值操作
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
            if (leftType != NULL && rightType != NULL && !typeEqual(leftType, rightType))
            {
                printf("Error type 5 at line %d: Type mismatched for assignment.\n", root->lineno);
                return NULL;
            }
            return leftType;
        }
```

第一个if-else保证了赋值操作的左值必须是一个变量。

能否赋值的关键是判断左右值`typeEqual()`的类型是否一致。

`typeEqual()`中判断结构体类型结构是否等价的代码

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

每个变量都会存储自己的kind类型，当变量的kind为结构体时，进入结构体判断

变量中的union存储实际的类型

分别获取左右值结构体的结构体域链表头

题目要求中

> struct A { int a; struct { float f; int i; } b[10]; }和struct B { struct { int i; float f; } b[10]; int b;}

可见，结构体是否等价，取决于结构体的变量是否相同，以及变量声明的顺序是否相同，并不关注变量的名字是否相同。因此，只需简单地对结构体域按链表顺序判断是否等价即可。

很简单地判断两条链表是否相等。只是相等的判断方式替换成了`typeEqual()`

判断失败的条件：

- 结构体中变量类型不同

- 变量声明顺序不同

- 变量个数不同

### 样例6

完成了上面的代码，样例5和6都可以直接通过。两个样例都是声明两个struct a, b，并尝试a = b;
