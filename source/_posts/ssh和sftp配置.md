---
title: ssh和sftp配置
date: 2024-09-19 21:10:46
tags:
  - ssh
  - sftp
categories: environment
---

# SSH

关于怎么配置 github 的 ssh 密钥，我在{% post_link github推送报错解决 %}中已经记录过，故不赘述。

这次主要是解决一个小问题，用校园网无法通过 ssh 连接 github。我再{% post_link 20240912 %}中提到校园网 ban 了 22 端口，但今天发现不是这样。参考[这篇博客](https://www.alonetech.com/2024/01/19/2586.html)，修改`~/.ssh`（在 windows 环境为`C:\Users\Username\.ssh`）目录下的`config`文件，如果没有就新建。

```config ~/.ssh/config
Host github.com
  HostName ssh.github.com
```

也就是把`github.com`作为`ssh.github.com`的别名。设置之后就可以正常连接 ssh 了。

# SFTP

## 设置别名

sftp 是用来在服务器和本机之间传输文件的，只要能连上服务器，sftp 几乎不需要配置。参考[师兄的 notion](https://rylynn.notion.site/SFTP-f6d6bb9bdbeb45fab80fe1d8a53bef07)。

首先可以在本地的`~/.ssh/config`文件中设置服务器 ip 的别名，如：

```config ~/.ssh/config
Host adana
  HostName 127.0.0.1
  User yamada
  Port 22
```

设置完之后，`yamada@adana`就相当于`yamada@127.0.0.1`的效果。服务器密码该输还得输，没有任何变化，这一步仅仅只是为了简化每次要输入 ip 地址的一长串。

## 连接

然后使用 sftp 代替 ssh 命令来连接。

```bash
# 不指定端口（使用22端口）
sftp yamada@adana
# 指定端口（也可以事先在~/.ssh/config设置好Port
sftp -oPort=custom_port yamada@adana
# 连接成功后会进入
sftp>
```

## 基本命令

连接上之后，可以互传文件。使用`help`或 `?` 来访问 sftp 的命令帮助。

需要注意的是：

1. 服务器相关命令没有变化，但无法使用 `~` 来访问`/home/username`路径。
2. 本地的命令需要在前面加 `l`，如`cd`->`lcd`, `pwd`->`lpwd`, `ls`->`lls`。

## 下载

从服务器下载到本地，使用`get`命令。

```bash
# 直接下载
sftp> get remoteFile
Fetching /home/demouser/remoteFile to remoteFile
/home/demouser/remoteFile                       100%   37KB  36.8KB/s   00:01
# 指定下载文件名字（和服务器上的名字不同）
sftp> get remoteFile localFile
# 递归地下载目录
sftp> get -r someDirectory
```

## 上传

使用`put`命令，方法和`get`相同。

```bash
sftp> put localFile
sftp> put -r localDirectory
```
