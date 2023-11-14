vscode设置自动换行

linux `ctrl + ,` 搜索word wrap，改为on



Pre-add read and write functions.  

function write() may has some mistakes

错怪了，write()函数没有任何问题。

测试用例test1.cmm跑不出来是因为单个变量作为左值的基本表达式翻译，以及关系表达式的翻译没有完成。

目标

> FUNCTION main :
>
> READ t1 
>
> v1 := t1

错误：

assignCode是右值赋给临时变量t1

t2 := t1

assignIDcode是什么？右值赋给一个空？

 := t2

expCode是READ t1(这个没有问题)

expCode接assignCode

第一次实现：

insertInterCode(expCode, assignCode);
            insertInterCode(assignCode, assignIDcoe);

结果

FUNCTION main :
t2 := t1
READ t1
 := t2
RETURN #0

正确：

> FUNCTION main :
> READ t1
> vn := t1
> RETURN #0

```c
	if (root->children[0]->childNum == 1 &&
            strcmp(root->children[0]->children[0]->name, "ID") == 0)
        {
            // todo
            // 通过查表找到ID对应的变量
            Entry leftOperand = findSymbolAll(root->children[0]->children[0]->strVal);

            // Entry leftOperand = findSymbolAll(root->children[0]->children[0]->strVal);
            // 然后对Exp2进行翻译（运算结果储存在临时变量t1中）
            Operand tmp1 = newTemp();
            InterCode expCode = translateExp(root->children[2], tmp1);

            // 将t1中的值赋于ID所对应的变量
            InterCode code1 = (InterCode)malloc(sizeof(InterCode_));
            code1->kind = ASSIGN_IR;

            
            code1->ops[0] = getVar(leftOperand->name);
            code1->ops[1] = tmp1;

            if (place != NULL)
            {
                operandCpy(place, getVal(tmp1));
            }
            
            insertInterCode(code1, expCode);

            return expCode;
        }
```



READ t1由translateExp产生

t1的1怎么来的？

newTemp()中会自动记录生成的临时变量数，自增

而getVar会用变量名生成变量操作数，前缀v

表达式翻译

目标

> t2 := #0
>
> IF v1 >t2 GOTO label1
>
> GOTO label2
>
> LABEL label1 :
>
> t3 := #1
>
> WRITE t3

错误的实现

n > 0，需要一个临时变量t2赋值为0，然后v1与之比较

FUNCTION main :
vn := #1
READ t2
vn := t2
LABEL null :
LABEL label1 :
WRITE #1
LABEL label2 :？

            printf("translateExp: ID\n");
            Entry leftOperand = findSymbolAll(root->children[0]->children[0]->strVal);
    
            // Entry leftOperand = findSymbolAll(root->children[0]->children[0]->strVal);
            // 然后对Exp2进行翻译（运算结果储存在临时变量t1中）
            Operand tmp1 = newTemp();
            InterCode expCode = translateExp(root->children[2], tmp1);
    
            // 将t1中的值赋于ID所对应的变量
            InterCode code1 = (InterCode)malloc(sizeof(InterCode_));
            code1->kind = ASSIGN_IR;


​            
​            code1->ops[0] = getVar(leftOperand->name);
​            code1->ops[1] = tmp1;

if (root->children[0]->childNum == 1 &&
            strcmp(root->children[0]->children[0]->name, "ID") == 0)
       判断是否为一个变量

完整目标

> FUNCTION main :
>
> READ t1
>
> v1 := t1
>
> t2 := #0
>
> IF v1 > t2 GOTO label1
>
> GOTO label2（还没实现）
>
> LABEL label1 :
> WRITE #1
> GOTO label3
> LABEL label2 :
> t4 := #0
> IF vn < t4 GOTO label4
> LABEL label4 :
> WRITE #-1
> GOTO label3
> LABEL label5 :
> WRITE #0
> LABEL label3 :
> RETURN #0

