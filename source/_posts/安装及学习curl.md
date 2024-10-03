---
title: 安装及学习curl
date: 2024-10-01 14:18:21
tags: curl
categories: curl
---

<meta name="referrer" content="no-referrer" />

Curl 是一个利用 URL 语法在命令行方式下工作的文件传输工具，支持多种协议，如 HTTP、HTTPS、FTP 等。我对 curl 的了解仅限于测试能否访问某个网站，能和 ping 一样用。但使用过程中发现还挺有用的，在 windows 安装上遇到了一些困难并解决了，所以记录一下。

# 撤销 powershell 设置的 curl 别名

Linux 服务器上好像不用安装就直接可以用。Windows 就很麻烦了，虽然本机上安装了 curl，但不知道为什么 powershell 自动把 curl 这个名字作为 Invoke-WebRequest 的别名，这两个命令虽然功能类似，但使用方式完全不一样。

所以我们需要先撤销 powershell 给 curl 设置的别名。以下内容参考[stackoverflow 回答](https://superuser.com/questions/883914/how-do-i-permanently-remove-a-default-powershell-alias)。

1. 先打印出 powershell 配置文件（profile）的路径：`echo $profile`。如果没有 profile 的话，用`New-Item $profile -force -itemtype file`新建一个。

2. 用编辑器（这里是记事本）打开 profile：`notepad $profile`

3. 加上撤销 curl 别名的一行命令：`remove-item alias:curl`，保存文件。

4. 用`. $profile`重新加载 profile（相当于 linux 的`source`命令）。

