---
title: Windows包管理器总结
date: 2024-10-01 16:34:49
tags:
  - package-manager
  - winget
  - chocolatey
  - scoop
categories: environment
---

<meta name="referrer" content="no-referrer" />

这篇[日文 note](https://note.com/woinary/n/n2b4ef236f2ba)关于包管理器是什么，为什么要用 Windows 包管理器，包管理器的比较以及选择，都讲得很详细。我稍微总结一下。

# 包管理器是什么

如果用过 linux 就应该没这个疑问。linux 的不同发行版都有官方的包管理器，像 Debian 是 APT，对应`apt`和`apt-get`命令，Fedora, CentOS, RHEL (Red Hat Enterprise Linux), openSUSE 是 DNF（新），YUM（旧）。

Windows 用户一般都是从官网下载`.msi`, `.exe`，或者 installer，压缩包之类的各种方式，虽然大部分都能根据指示顺利安装，但总归安装形式多种多样，不免有些麻烦。更麻烦的是更新的时候可能还得再去官网下载一趟。

包管理器就可以用一两行命令解决所有的安装和更新问题。并且使用包管理器可以让自己更熟悉命令行环境（CLI）。

Windows 也有专用的包管理器，比较常用的御三家是 winget，scoop 和 choco（全称是 chocolatey）。

# 包管理器的比较以及选择

- choco：最老，应用最全，非官方，需要管理员权限。近年来使用人数在三者中较少，没有什么特别选择它的原因。

- scoop：较新，应用较全，非官方，不需要管理员权限。使用人数多。

- winget：最新，应用不全但有大厂独家，官方自带，需要管理员权限，甚至可以更新不是用 winget 安装的应用（但可能会出错所以微妙）。使用人数较多。

简单地选择用 winget，没有的包用 scoop 就行。

# winget

参考[这篇文章](https://www.sysgeek.cn/windows-winget/)。

注意 winget 通常需要管理员模式操作。

## 换源

在中国大陆逃脱不掉的换源。

```sh
# 删除官方源
winget source remove winget
# 添加中科大源
winget source add winget https://mirrors.ustc.edu.cn/winget-source
```

换完使用`winget source list`来检验，会打印出网址。

恢复官方源：

```sh
winget source reset winget
```

## 安装应用程序

先搜索应用名称，`-e`或`--exact`选项用于精确匹配：

```sh
winget search <AppName>
```

会显示出相关的结果。

<img src="https://gitee.com/dwd1201/image/raw/master/202410011947940.png"/>

我们根据 id 来安装，比如要安装 yt-dlp。

```sh
winget install yt-dlp.yt-dlp
```

## 更新应用程序

查看可更新的程序列表：

```sh
winget update
# 或者
winget upgrade
```

更新命令

```sh
# 更新指定程序
winget update <ID>
# 更新所有程序
winget update --all
```

## 卸载应用程序

先查看当前安装的应用列表：

```sh
winget list
```

再根据 id 卸载。

```sh
winget uninstall <id>
```

