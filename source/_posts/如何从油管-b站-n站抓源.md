---
title: 如何从油管/b站/n站抓源
date: 2024-10-05 13:14:34
tags:
  - yt-dlp
  - minyami
  - nodejs
categories: Others
---

<meta name="referrer" content="no-referrer" />

由于本人也是一知半解，如有错误请不吝指正。

我们抓源主要使用 yt-dlp 和 minyami 两个工具，两个工具各有用处。

- yt-dlp 用来抓取油管/b 站/n 站的普通视频。
- minyami 用来抓取 nico 生放送的时光机（タイムシフト）、Abema TV、FRESH LIVE 等 HLS 视频（内容分为多个片段传输）。

yt-dlp 部分参考[ytdlp 的 github 仓库](https://github.com/yt-dlp/yt-dlp#readme)，minyami 部分参考[博客](https://blog.wsswms.dev/2020/04/19/Minyami-is-so-lovely/)，博客中提到的 kkr 工具我暂时还没遇到使用场景。

# 安装

## yt-dlp 安装

[github 仓库的 wiki](https://github.com/yt-dlp/yt-dlp/wiki/Installation)里给了详细的安装方法，建议查看。

以下为本人会用到的两种系统的安装方式，仅供参考。

## Windows 系统

由于我使用 windows 系统且熟悉包管理工具，因此用 winget 安装。用`winget search yt-dlp`之后，找到对应的包使用`winget install yt-dlp.yt-dlp`安装（使用 ID 指定），winget 的使用和换源参考{%post_link Windows包管理器总结%}。参照 wiki 内的其他安装方法也可以。

## Debian 系统

Linux 的基于 Debian 的系统可以用 APT 安装。

```sh
sudo add-apt-repository ppa:tomtomtom/yt-dlp    # Add ppa repo to apt
sudo apt update                                 # Update package list
sudo apt install yt-dlp                         # Install yt-dlp
```

## minyami 安装

`npm -g i minyami`

如何安装 npm（nodejs）详见{% post_link nvm-npm-nodejs%}。

# 抓源

## 设置代理

设置代理需要知道代理工具的使用的协议，端口号和主机号，比如 clash 默认的端口号为 7890，v2ray 默认为 20171，两者都使用 http 协议，由于是通过本机代理，主机号为本地主机`127.0.0.1`（或者用`localhost`，二者基本等价）。

~~什么？为什么本机是`127.0.0.1`？你记住就行了，除非你想学计网。~~

那么假设我们使用 clash，`--proxy`的参数就应该设置为`--proxy "http://127.0.0.1:7890"`或`--proxy "http://localhost:7890"`。

## 测试网络环境（可选）

> 注意：Windows 系统的 powershell 把 curl 命令作为 Invoke-WebRequest 的别名，需要另外学习 Invoke-WebRequest 的用法，或参考{%post_link 安装及学习curl%}取消别名，或尝试换个 shell。

在需要代理的网站上，可以先测试能否用 curl 正确响应。

正常情况下应该很快就会返回，如果长时间无返回，或者返回错误，建议检查代理配置是否正确。

```sh
# -x/--proxy配置代理，-I只返回响应头
curl -I example.com -x "http://127.0.0.1:7890"
```

## yt-dlp 使用方法

yt-dlp 可以用来下载油管/b 站/n 站的普通视频。

使用方法如下：

```sh
# --proxy设置代理服务器
# -f设置格式，不设置的话有时会下成.webm文件
# --cookies用于指定cookies文件，用于b站
yt-dlp example.com/video/id --proxy "http://127.0.0.1:7890" -f mp4 --cookies "path/to/your/bilibili cookies.txt"
```

### 各网站下载分辨率

- 油管可直接下载到 1080p
- b 站需要使用登陆的 cookies 下载 1080p，否则最高分辨率为 480p
- n 站可下载 720p，会员才能下载 1080p。

### 获取 cookies

我使用浏览器插件 Get cookies.txt LOCALLY 获取，只需要登陆网站，在页面上点击插件图标保存 cookies 即可。

## minyami 使用方法

minyami 用来下载 nico 生放送的时光机（タイムシフト）、Abema TV、FRESH LIVE 等 HLS 视频。

由于我只用到了 n 站生放送下载，就只介绍这个。

### nico 生放送下载

还要用到一个浏览器插件[Minyami](https://chromewebstore.google.com/detail/minyami/cgejkofhdaffiifhcohjdbbheldkiaed)解析生放送的网址，并给出对应的命令。

用法很简单，我们安装插件之后，在想要下载的 nico 生放送网站下点击，插件就会显示出命令。我们选择是否直播，然后复制命令即可。左上角的设置可以选择线程数量，可以选大点比如 16。

直播结束的生放送不要勾选直播。

<img src="https://gitee.com/dwd1201/image/raw/master/202410070012515.png"/>

复制下来的命令应该类似于：

```sh
minyami -d "example.com" --output <video name> --key <key>
```

当然复制的命令直接运行，多半会因为众所周知的原因超时。所以同样要设置代理，在复制的命令后加上`--proxy "http://127.0.0.1:7890"`（根据实际代理服务器可能不同）
