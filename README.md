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

WSL2配置代理

新建脚本proxy.sh

```
#!/bin/sh
hostip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
wslip=$(hostname -I | awk '{print $1}')
port=7890
 
PROXY_HTTP="http://${hostip}:${port}"
 
set_proxy(){
  export http_proxy="${PROXY_HTTP}"
  export HTTP_PROXY="${PROXY_HTTP}"
 
  export https_proxy="${PROXY_HTTP}"
  export HTTPS_proxy="${PROXY_HTTP}"
 
  export ALL_PROXY="${PROXY_SOCKS5}"
  export all_proxy=${PROXY_SOCKS5}
 
  git config --global http.proxy ${PROXY_HTTP}
  git config --global https.proxy ${PROXY_HTTP}
 
  echo "Proxy has been opened."
}
 
unset_proxy(){
  unset http_proxy
  unset HTTP_PROXY
  unset https_proxy
  unset HTTPS_PROXY
  unset ALL_PROXY
  unset all_proxy
  git config --global --unset http.https://github.com.proxy
  git config --global --unset https.https://github.com.proxy
 
  echo "Proxy has been closed."
}
 
test_setting(){
  echo "Host IP:" ${hostip}
  echo "WSL IP:" ${wslip}
  echo "Try to connect to Google..."
  resp=$(curl -I -s --connect-timeout 5 -m 5 -w "%{http_code}" -o /dev/null www.google.com)
  if [ ${resp} = 200 ]; then
    echo "Proxy setup succeeded!"
  else
    echo "Proxy setup failed!"
  fi
}
 
if [ "$1" = "set" ]
then
  set_proxy
 
elif [ "$1" = "unset" ]
then
  unset_proxy
 
elif [ "$1" = "test" ]
then
  test_setting
else
  echo "Unsupported arguments."
fi
```

注意：其中第4行的``更换为自己的代理端口号。

- `source ./proxy.sh set`：开启代理
- `source ./proxy.sh unset`：关闭代理
- `source ./proxy.sh test`：查看代理状态

任意路径下开启代理

可以在`~/.bashrc`中添加如下内容，并将其中的路径修改为上述脚本的路径：

```bash
alias proxy="source /path/to/proxy.sh"
```

然后输入如下命令：

```bash
source ~/.bashrc
```

那么可以直接在任何路径下使用如下命令：

- `proxy set`：开启代理
- `proxy unset`：关闭代理
- `proxy test`：查看代理状态

自动设置代理

也可以添加如下内容，即在每次shell启动时自动设置代理，同样的，更改其中的路径为自己的脚本路径：

```bash
. /path/to/proxy.sh set
```

使用`curl`即可验证代理是否成功，如果有返回值则说明代理成功。

```shell
curl www.google.com
```

[WSL2配置代理](https://www.cnblogs.com/tuilk/p/16287472.html)