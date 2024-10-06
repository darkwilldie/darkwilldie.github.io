---
title: 安装及学习curl
date: 2024-10-01 14:18:21
tags: curl
categories: curl
---

<meta name="referrer" content="no-referrer" />

Curl 是一个利用 URL 语法在命令行方式下工作的文件传输工具，支持多种协议，如 HTTP、HTTPS、FTP 等。我对 curl 的了解仅限于测试能否访问某个网站，能和 ping 一样用。但使用过程中发现还挺有用的，在 windows 安装上遇到了一些困难并解决了，所以记录一下。

# 前置知识

## ping 和 curl 的区别

### ping

1. **功能**：ping 是一个网络诊断工具，用于测试主机之间的连通性。
2. **工作原理**：通过发送 ICMP（Internet Control Message Protocol）回显请求（echo request）数据包，并等待回显应答（echo reply）来测量往返时间。
3. **用途**：主要用于检查网络连接是否正常，测量网络延迟和丢包率。
4. **代理支持**：ping 不支持通过代理服务器进行测试。

### curl

1. **功能**：curl 是一个用于传输数据的命令行工具，支持多种协议（如 HTTP、HTTPS、FTP 等）。
2. **工作原理**：通过指定的协议与服务器进行通信，可以发送请求并接收响应数据。
3. **用途**：主要用于测试和调试网络应用程序，下载文件，提交表单数据等。
4. **代理支持**：curl 支持通过代理服务器进行数据传输。

## 示例

- **ping** 示例：

  ```sh
  ping www.example.com
  ```

- **curl** 示例：

  ```sh
  curl -I www.example.com
  ```

  `-I`选项用于发送一个 HTTP HEAD 请求。与 GET 请求不同，HEAD 请求只会请求响应头部，而不会请求响应体。

  正确的输出类似：

  ```sh
    HTTP/1.1 200 OK
    Date: Mon, 01 Jan 2023 00:00:00 GMT
    Server: Apache/2.4.41 (Ubuntu)
    Content-Type: text/html; charset=UTF-8
  ```

  > 如果出现 HTTP/1.1 301 Moved Permanently，表示资源移动到新的 URL，只需要 curl 原输出中 location 一行给出的新网址即可。

## 总结

- **ping** 主要用于网络连通性测试，不支持代理。
- **curl** 主要用于数据传输和网络应用调试，支持多种协议和代理。

# 实操

## 设置代理

要在 curl 中设置代理，可以使用`-x`或`--proxy`选项。你可以指定 HTTP、HTTPS、SOCKS4 或 SOCKS5 代理。

示例
假设你有一个 HTTP 代理服务器，地址为 `http://proxy.example.com:8080`，你可以这样设置：

```sh
curl -x http://proxy.example.com:8080 http://www.example.com
```

## 撤销 powershell 设置的 curl 别名

Linux 服务器上好像不用安装就直接可以用。Windows 就很麻烦了，虽然本机上安装了 curl，但不知道为什么 powershell 自动把 curl 这个名字作为 Invoke-WebRequest 的别名，这两个命令虽然功能类似，但使用方式完全不一样。

所以我们需要先撤销 powershell 给 curl 设置的别名。以下内容参考[stackoverflow 回答](https://superuser.com/questions/883914/how-do-i-permanently-remove-a-default-powershell-alias)。

1. 先打印出 powershell 配置文件（profile）的路径：`echo $profile`。如果没有 profile 的话，用`New-Item $profile -force -itemtype file`新建一个。

2. 用编辑器（这里是记事本）打开 profile：`notepad $profile`

3. 加上撤销 curl 别名的一行命令：`remove-item alias:curl`，保存文件。

4. 用`. $profile`重新加载 profile（相当于 linux 的`source`命令）。
