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
>
> t2 := #0

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