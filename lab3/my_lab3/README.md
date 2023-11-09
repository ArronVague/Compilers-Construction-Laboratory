Pre-add read and write functions.  

function write() may has some mistakes

错怪了，write()函数没有任何问题。

测试用例test1.cmm跑不出来是因为单个变量作为左值的基本表达式翻译，以及关系表达式的翻译没有完成。