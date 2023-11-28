# Compilers-Construction-Laboratory
A repo to store compilers construction lab's code.

必备工具

```bash
sudo apt install make
sudo apt-get install flex
sudo apt-get install bison
```

## 遇到的各种问题

### 降低内核版本

实验环境内核5.13.0-44-generic

[Ubuntu20.04 如何降低内核版本_ubuntu降低内核_JSYRD的博客-CSDN博客](https://blog.csdn.net/qq_49814035/article/details/116035670)

### 找不到liby.a

```bash
/usr/bin/ld: connot find -ly
```

[找不到-ly错误-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/ask/sof/110092092)

我的解决办法（直接用这个）

```bash
sudo apt install libbison-dev
```

