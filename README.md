# Compilers-Construction-Laboratory
A repo to store compilers construction lab's code.

## 遇到的各种问题

### 降低内核版本

实验环境内核5.13.0-44-generic

[Ubuntu20.04 如何降低内核版本_ubuntu降低内核_JSYRD的博客-CSDN博客](https://blog.csdn.net/qq_49814035/article/details/116035670)

### 找不到liby.a

```
/usr/bin/ld: connot find -ly
```

[找不到-ly错误-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/ask/sof/110092092)

我的解决办法：

```
sudo apt install libbison-dev
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

### Ubuntu 18.04/20.04默认全局缩放修改

[Ubuntu 20.04默认全局缩放修改，简单五步即可实现](https://blog.csdn.net/Pthumeru/article/details/119304019)

### win11使用wsl

#### 方法一

直接下载，会自动安装最新的ubuntu

```bash
wsl -l
```

#### 方法二

##### 导入

```bash
wsl --import <Distribution Name> <InstallLocation> <FileName>
```

例如

```bash
wsl --import compilers D://Software/SoftwareData/compilers D://Software/SoftwareData/compilers/compilers.tar
```

##### 运行

```bash
wsl -d <Distribution Name>
```

##### 设置用户账户

```bash
NEW_USER=<USERNAME> // <USERNAME>替换成你的用户名
useradd -m -G sudo -s /bin/bash "$NEW_USER"
passwd "$NEW_USER"
```

##### 设定默认用户

```bash
tee /etc/wsl.conf <<_EOF
[user]
default=${NEW_USER}
_EOF
```

##### 问题

```bash
wsl: A localhost proxy configuration was detected but not mirrored into WSL. WSL in NAT mode does not support localhost proxies.
```

###### 方法一

把clash或其他代理客户端开TUN MODE。

###### 方法二

[WSL2配置代理](https://www.cnblogs.com/tuilk/p/16287472.html)