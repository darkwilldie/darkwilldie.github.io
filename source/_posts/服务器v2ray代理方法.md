---
title: 服务器v2ray代理方法
date: 2024-10-04 18:37:01
tags:
  - proxy
  - v2ray
categories: environment
---

<!-- toc -->

共享本机局域网代理参照{% post_link 远程主机代理方案%}

[这里](https://v2raya.org/docs/prologue/installation/debian/)是官方文档。其实就是按要求一步步操作就行，Ubuntu/Debian 的安装过程挺省心的。v2ray 有**网页 GUI**，在服务器上只需要把端口转发到本地，就可以用本地浏览器进行大部分操作。

v2ray 的 GUI 在 2017 端口上，我们通过 vscode 转发端口就可以打开本地浏览器看到服务器的 v2raya GUI。

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

# 更新

26.04.25在autodl服务器上配置v2raya的时候全程用的是终端环境，没用vscode，也遇到了不少坑，记录一下克服的过程。

## 1. APT 源签名过期

一开始添加 v2rayA APT 源后执行：

```bash
sudo apt update
```

报错：

```
EXPKEYSIG 354E516D494EF95F mzz2017 (apt) <mzz@tuta.io>
E: The repository 'https://apt.v2raya.org v2raya InRelease' is not signed.
```

原因

v2rayA 的 APT 仓库签名 key 过期了。APT 默认不允许从签名无效的仓库安装软件。

解决办法

没有继续强行用 APT 源，而是改成从 v2rayA GitHub releases 手动下载 .deb 文件安装

你的服务器架构是：

```
uname -m                  x86_64
dpkg --print-architecture amd64
```

选择 release 里的debian_x64的deb包。

## 2. 本地 deb 安装命令写法问题

通过deb包安装v2raya时执行：

```bash
sudo apt install installer_debian_x64_2.2.7.5.deb
```

报错：

```bash
E: Unable to locate package installer_debian_x64_2.2.7.5.deb
```

原因

APT 把它当成“包名”去远程仓库里找了，而不是当成本地文件。

解决办法

安装本地 .deb 文件时要加 `./` 或者用绝对路径：

```bash
sudo apt install ./installer_debian_x64_2.2.7.5.deb
```

## 3. 当前环境不能用 systemctl

启动 v2rayA / 设置 v2rayA 自动启动时执行：

```bash
sudo systemctl start v2raya.service
```

报错：

```
System has not been booted with systemd as init system (PID 1). Can't operate.
Failed to connect to bus: Host is down
```

原因

 AutoDL 的容器环境不是完整 systemd 启动的 Linux 主机。也就是说 PID 1 不是 systemd，所以 systemctl 不可用。

解决办法

不用 systemctl，直接手动启动 v2rayA：

```bash
nohup v2raya > /var/log/v2raya.log 2>&1 &
```

可以指定一个命令来启动，顺便指定内核，比如定义一个`v2raya_on`命令，在`~/.bashrc`中加一行：

```bash
alias v2raya_on="nohup env \
  V2RAYA_V2RAY_BIN=/usr/bin/v2ray \
  V2RAYA_V2RAY_ASSETSDIR=/usr/share/v2ray \
  V2RAYA_VERBOSE=true \
  v2raya > /var/log/v2raya.log 2>&1 &"
```

之后看日志：

```bash
tail -n 50 /var/log/v2raya.log
```

启动成功后看到：

```bash
v2rayA is listening at http://127.0.0.1:2017
v2rayA is listening at http://172.17.0.10:2017
```

说明 Web UI 已经起来了。

## 4. 远程服务器访问 v2rayA Web UI

v2rayA 监听 http://127.0.0.1:2017。

如果是在远程服务器上，本地浏览器不能直接访问服务器的 127.0.0.1。

解决办法

用 SSH 端口转发，所需信息在autodl中复制的ssh命令中有：

```bash
ssh -CNg -L 2017:127.0.0.1:2017 root@服务器地址 -p 端口
```

然后在本地浏览器打开：http://127.0.0.1:2017

这样不用把 v2rayA 管理页面暴露到公网，更安全。

## 5. v2rayA 装好了，但没有 Xray / V2Ray core

日志里出现：

```bash
V2Ray binary is
```

后面是空的，并且在Web UI中也有报错，进不了订阅界面。

原因

v2rayA 只是管理界面和控制器，真正负责代理连接的是：

v2ray core 或 xray core

只装了 v2rayA，还没有安装 core，或者 v2rayA 找不到 core 的路径。

解决办法

```bash
sudo apt install -y v2ray
```

或者类似的方法安装xray core。不过v2ray可以选多个节点自动负载均衡，所以我从xray切换到v2ray了。

## 6. v2ray版本过低

按照[5.](#5-v2raya-装好了但没有-xray--v2ray-core)的方法安装的是v2ray 4.x版本，v2raya会推荐降级。系统源的v2ray太老了。

解决办法

先停掉 v2rayA 和旧 core：

```bash
pkill v2raya
pkill v2ray 2>/dev/null || true
pkill xray 2>/dev/null || true
```

可以在`~/.bashrc`新建一个别名`v2raya_off`：

```bash
alias v2raya_off='pkill v2raya; pkill v2ray 2>/dev/null || true; pkill xray 2>/dev/null || true'
```

可选：卸载 apt 装的旧版，避免路径混乱：

```bash
sudo apt remove -y v2ray
```

下载新版 v2ray-core：

```bash
cd /tmp

wget -O v2ray-linux-64.zip \
  https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip

rm -rf /tmp/v2ray-core
mkdir -p /tmp/v2ray-core
unzip -o v2ray-linux-64.zip -d /tmp/v2ray-core
```

安装到标准路径：

我实际上是装在了`/usr/bin/v2ray`下，两个文件用的是[开源仓库v2ray-rules-dat](https://github.com/Loyalsoldier/v2ray-rules-dat)的releases，放在`usr/share/v2ray`下。

以下命令仅供参考。

```bash
sudo install -m 755 /tmp/v2ray-core/v2ray /usr/local/bin/v2ray

sudo mkdir -p /usr/local/share/v2ray
sudo install -m 644 /tmp/v2ray-core/geoip.dat /usr/local/share/v2ray/geoip.dat
sudo install -m 644 /tmp/v2ray-core/geosite.dat /usr/local/share/v2ray/geosite.dat
```

再用`v2ray version`检查版本应该能看到5.x.x

## 7. 启动服务时报 iptables-legacy 不存在

你点击启动服务后报错：

failed to start v2ray-core: ExecCommands: iptables-legacy -w 2 -N DROP_SPOOFING
sh: 1: iptables-legacy: not found
exit status 127
原因

v2rayA 试图配置透明代理相关的 iptables 规则，但容器里没有 iptables-legacy 命令。

这个和透明代理、防火墙规则、DNS 劫持有关。

解决思路

理论上可以装：

sudo apt install -y iptables

但你是在容器环境里，即使安装了 iptables，也可能因为缺少 NET_ADMIN 权限继续失败。

最终解决办法

在 v2rayA Web UI 中关闭：

透明代理 / Transparent Proxy

只使用普通端口代理：

HTTP  127.0.0.1:20171
SOCKS 127.0.0.1:20170

关闭透明代理后，服务可以正常启动。

这是你这次最关键的坑之一：在容器里不要优先用透明代理，Codex 只需要 HTTP 代理即可。

## 8. 启动和测试

要在web UI中启动，没启动状态下选择的节点是红色，点击左上角红色的`就绪/Ready`，切换到`正在运行`，这时连接的节点是蓝色。

```bash
export http_proxy=http://127.0.0.1:20171
export https_proxy=http://127.0.0.1:20171
export HTTP_PROXY=http://127.0.0.1:20171
export HTTPS_PROXY=http://127.0.0.1:20171
export NO_PROXY=localhost,127.0.0.1
echo "set proxy successfully!"
```

在设置当前bash进程使用的代理，同样也可以设置alias别名。

服务启动后，用 HTTP 代理端口测试：

```bash
curl -I https://www.google.com --proxy http://127.0.0.1:20171
curl -I https://api.openai.com --proxy http://127.0.0.1:20171
curl -I https://chatgpt.com --proxy http://127.0.0.1:20171
```

如果访问 api.openai.com 返回类似 HTTP/2 401

通常是正常的，说明网络通了，只是没有带 API key。

真正异常的是：

```
Connection refused
Connection timed out
Could not resolve host
SSL certificate problem
```






