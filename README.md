# Compilers-Construction-Laboratory
A repo to store compilers construction lab's code.

## 遇到的各种问题

### 降低内核版本

[Ubuntu20.04 如何降低内核版本_ubuntu降低内核_JSYRD的博客-CSDN博客](https://blog.csdn.net/qq_49814035/article/details/116035670)

### 找不到liby.a

```
/usr/bin/ld: connot find -ly
```

[找不到-ly错误-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/ask/sof/110092092)

我的解决办法：

```
apt install libbison-dev
```

### 多电脑使用相同虚拟机

[VMware虚拟机从一台电脑复制到另一台电脑](https://zhuanlan.zhihu.com/p/603483636#:~:text=%E5%9C%A8%E4%B8%80%E5%8F%B0%E7%94%B5%E8%84%91%E4%B8%8A,%E7%94%B5%E8%84%91%E4%B8%8A%EF%BC%8C%E7%9C%81%E6%97%B6%E7%9C%81%E5%8A%9B%E3%80%82)

### 虚拟机迁移后遇到突然连不上网的问题

- 宿主windows中，settings -> Betwork & internet -> Advanced network settings，允许虚拟机的网络适配器

- 虚拟机中

  ```powershell
  sudo dhclient ens33
  ```

### vscode设置自动换行

linux/windows中 `ctrl + ,` 搜索word wrap，改为on



