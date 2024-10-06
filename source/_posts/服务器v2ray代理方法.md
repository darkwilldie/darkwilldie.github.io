---
title: 服务器v2ray代理方法
date: 2024-10-04 18:37:01
tags:
  - proxy
  - v2ray
categories: environment
---

<meta name="referrer" content="no-referrer" />

共享本机局域网代理参照{% post_link 远程主机代理方案%}

[这里](https://v2raya.org/docs/prologue/installation/debian/)是官方文档。其实就是按要求一步步操作就行，Ubuntu/Debian 的安装过程挺省心的。v2ray 有**网页 GUI**，在服务器上只需要把端口转发到本地，就可以用本地浏览器进行大部分操作。

v2ray 的 GUI 在 2017 端口上，我们通过 vscode 转发端口就可以打开本地浏览器看到服务器的 v2ray GUI。

<img src="https://gitee.com/dwd1201/image/raw/master/202410041847832.png"/>

配置好后我修改了我的`.proxy_on`脚本，以便能够一行命令设置系统代理（在开启 v2ray 之后还需要设置`$http_proxy`和`$https_proxy`）。

```bash
# v2ray 代理
sudo systemctl start v2raya.service
export http_proxy="http://127.0.0.1:20171"
export https_proxy="http://127.0.0.1:20171"
echo "set proxy successfully!"
```

用`alias proxy_on="source ~/.proxy"`设置成shell命令，可写入`~/.zshrc`。
