---
title: zsh配置方案
date: 2024-09-25 21:03:57
tags:
  - zsh
categories: environment
---

<meta name="referrer" content="no-referrer" />

之前 wsl 也是这样配置的 zsh，linux 主机其实也可以。
参考[Windows Subsystem for Linux（WSL）的安装、美化和增强 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/340851697)

# 安装

```sh
sudo apt update
# 安装zsh
sudo apt install zsh
# 安装oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

oh-my-zsh 的安装和配置也可以参照[github 仓库](https://github.com/ohmyzsh/ohmyzsh/tree/master)

# 设置为 vscode 的默认 shell

把设置中的 `terminal.integrated.defaultProfile.linux` 改为 zsh（默认为 null）。

# 命令行美化

## 更改主题

在 `~/.zshrc` 中将 `ZSH_THEME="robbyrussell"` 改为 `ZSH_THEME="ys"`。我觉得这个主题还不错。

探索其他的主题可以访问[这里](https://github.com/ohmyzsh/ohmyzsh/wiki/External-themes)

## 命令高亮（显示红绿）

安装 zsh-syntax-highlighting。

我的建议是在 `~/.oh-my-zsh/plugins/` 目录下安装，免得占用 `~` 目录。

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
```

```bash
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

```bash
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

## 命令自动补全

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

```bash
sudo vim ~/.zshrc
```

在 zsh 处添加 `plugins=(zsh-autosuggestions)`

## 建议的插件

除了命令高亮和自动补全，我还用到了`git`,`sudo`和`z`。

- `git`: 默认开启，git 命令的各种别名，如`ga`->`git add`
- `sudo`: 敲击两次`esc`相当于输入`sudo`
- `z`: 用`cd`命令进入过的目录，可以用`z`命令省略路径，直接`z <目录名>`进入该目录

启用这些插件只需要修改`~/.zshrc`：

```~/.zshrc
plugins=(
        git
        z
        sudo
        common-aliases
        alias-finder
        aliases
        colored-man-pages
        cp
        zsh-autosuggestions
        vscode
)
```

