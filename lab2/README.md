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
