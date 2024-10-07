---
title: nvm-npm-nodejs
date: 2024-10-05 13:02:27
tags:
  - nodejs
categories: environment
---

<meta name="referrer" content="no-referrer" />

<!-- toc -->

# 介绍

- **nvm (Node Version Manager)**: 一个用于管理多个 Node.js 版本的工具。它允许你在同一台机器上安装和切换不同版本的 Node.js。

- **npm (Node Package Manager)**: Node.js 的包管理器，用于安装、管理和发布 Node.js 包。它是 Node.js 的默认包管理工具，通常与 Node.js 一起安装。

- **Node.js**: 一个基于 Chrome V8 引擎的 JavaScript 运行时，用于构建快速、可扩展的网络应用。Node.js 使用事件驱动、非阻塞 I/O 模型，使其非常轻量和高效。

# 安装

> 请注意以下贴出的命令可能过时，请优先查看给出的官方网页。

## Windows 安装

Windows 就没必要安装 nvm 了，直接安装 nodejs 即可，npm 会自动一起安装。下面的安装方法选其一即可，不熟悉包管理器的建议选择第一种方法安装。

### 使用installer或下载二进制文件

访问官网安装指引的[installer](https://nodejs.org/en/download/prebuilt-installer)和[二进制文件](https://nodejs.org/en/download/prebuilt-binaries)，选择正确的版本（一般选择 LTS 版本）和架构安装。

现在的电脑一般都是64位机，选`x64`即可，较老的机器可能必须选择32位的`x86`，而`ARM64`主要为移动设备和嵌入式系统。

### 使用包管理器

按照官网中[使用包管理器的安装指引](https://nodejs.org/en/download/package-manager)在终端用 choco 安装：

```sh
# NOTE:
# Chocolatey is not a Node.js package manager.
# Please ensure it is already installed on your system.
# Follow official instructions at https://chocolatey.org/
# Chocolatey is not officially maintained by the Node.js project and might not support the v20.18.0 version of Node.js

# download and install Node.js
choco install nodejs-lts --version="20.18.0"

# verifies the right Node.js version is in the environment
node -v # should print `20`

# verifies the right npm version is in the environment
npm -v # should print `10.8.2`
```

## Linux 安装

### nvm 安装

既然 nvm 负责控制 nodejs 的版本，那么显然 nvm 需要先安装。参照[nvm 仓库 readme](https://github.com/nvm-sh/nvm##installing-and-updating)，下载并运行脚本即可自动配置，下载卡着不动的话请参考{%post_link 安装及学习curl%}的设置代理一节。

```sh
## 下载并运行安装脚本，会自动将配置写入~/.zshrc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
## 加载到当前shell会话
source ~/.zshrc
```

顺利的话我们就可以使用 nvm 命令了。

### nodejs 安装

参考[nodejs 官网](https://nodejs.org/zh-cn/download/package-manager)，选择需要的版本（一般选择 LTS 版本），对应的系统（这里是 linux），并选择使用 nvm。运行给出的命令即可。

```sh
## installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

## download and install Node.js (you may need to restart the terminal)
nvm install 20

## verifies the right Node.js version is in the environment
node -v ## should print `v20.18.0`

## verifies the right npm version is in the environment
npm -v ## should print `10.8.2`
```

顺利的话我们可以通过`node --version`和`npm --version`查看 nodejs 和 npm 版本。

大功告成！
