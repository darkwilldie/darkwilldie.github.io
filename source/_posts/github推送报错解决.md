---
title: github推送报错解决
date: 2024-09-09 09:33:02
tags:
  - git
  - github
  - ssh
categories: environment
---

# 报错

因为租服务器实在太肉痛，所以还是迁移到 4090D 上，虽然大数据集根据上次经验应该跑不起来，但小数据集测试效果也够了。在过程中出现了 github 远程推送的问题，之前也经常出现网络问题，但尝试开/关魔法之后基本都能解决。 但是在这次遇到了新的问题“缺失或无效的凭据”。

```
Missing or invalid credentials.
Error: connect ECONNREFUSED /run/user/4714/vscode-git-b650b12c34.sock
    at PipeConnectWrap.afterConnect [as oncomplete] (net.js:1146:16) {
  errno: -111,
  code: 'ECONNREFUSED',
  syscall: 'connect',
  address: '/run/user/4714/vscode-git-b650b12c34.sock'
}
Missing or invalid credentials.
Error: connect ECONNREFUSED /run/user/4714/vscode-git-b650b12c34.sock
    at PipeConnectWrap.afterConnect [as oncomplete] (net.js:1146:16) {
  errno: -111,
  code: 'ECONNREFUSED',
  syscall: 'connect',
  address: '/run/user/4714/vscode-git-b650b12c34.sock'
}
remote: Repository not found.
fatal: Authentication failed for 'https://github.com/me/myrepo'
```

# 归因和解决

应该是因为之前设置的 Tokens(classic) 过期了。参考[StackOverflow 的回答](https://stackoverflow.com/questions/68193573/git-push-returns-missing-or-invalid-credentials-code-econnrefused-remote-r)，我更新了 Tokens(classic)（之所以强调 classic 是因为答主提到 Fine-Grained Tokens 不行），并解决了问题。

## Tokens(classic)

用 Tokens(classic)解决具体步骤如下：

1. Settings > Developer settings > Personal access tokens > Tokens(classic)，创建一个拥有 repo 权限的 Token
2. 返回远程终端，移除已有的 github 远程仓库，`git remote remove origin`
3. `git remote add origin https://<token>@<git_url>.git`
4. 进行一次 pull，`git pull https://<token>@<git_url>.git`

## SSH 密钥

我在用 Token 之前用了一次 SSH 密钥，但是仍然出现一样的报错，原因是没有把远程仓库的 url 更新成 SSH 的格式，即`git@github.com:username/reponame.git`。

设置 SSH 的步骤如下：

1. 生成 SSH 密钥：

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

如果使用的是旧版 SSH，可以使用 RSA（没有遇到过必须使用 RSA 的情况）：

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

2. 复制 SSH 公钥到剪贴板，`cat ~/.ssh/id_ed25519.pub`，将 SSH 公钥添加到 github。

3. 测试 SSH 连接：

```bash
ssh -T git@github.com
```

正确输出应为：

```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

更新远程仓库 url 的命令是：

```bash
git remote set-url <名称> <新的地址> [<旧的地址>]
```
