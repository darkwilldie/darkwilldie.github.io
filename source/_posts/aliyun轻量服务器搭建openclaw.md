---
title: aliyun轻量服务器搭建openclaw
date: 2026-02-09 11:00:53
tags:
  - openclaw
  - vps
categories: environment
---
<!-- toc -->

vps的可玩性真的太高了，aliyun这个79一年的可选大马、印尼等外区，实测没什么网络问题。

唯一的问题是2核2G（实际只有1600MB多点）有时候会爆内存，尤其是更新的时候，几乎必定死机一两次。感觉还是openclaw优化的问题。

# 安装

安装是参照的[这个Youtube视频](https://youtu.be/tnsrnsy_Lus?si=K5oNGFvLISLhoIZf)

其实我最开始用阿里云的教程配过一次也非常顺利，但是太傻瓜配置了导致openclaw给自己改挂了我连配置文件具体是哪个都不知道，完全不会修……

在烧掉四十多块钱qwen的token（可恶原来阿里在这等着我呢！）并且配置又挂了之后，我痛定思痛在youtube找了个教程开始一步步跟着配。

## 安装openclaw之前
Command List:
```sh
# 下载并安装tailscale
curl -fsSL https://tailscale.com/install.sh | sh
# 启动tailscale并启用ssh功能
sudo tailscale up --ssh
# 查看tailscale连接状态
tailscale status

# 编辑SSH配置文件
sudo nano /etc/ssh/sshd_config
# 配置SSH仅监听tailscale IP地址
   ListenAddress 100.x.x.x 
# 禁用密码认证，使用密钥认证
  PasswordAuthentication no
# 禁止root用户直接登录
  PermitRootLogin no

# 重启SSH服务使配置生效
sudo systemctl restart ssh

# 创建新用户tim
adduser tim
# 将tim用户添加到sudo用户组
usermod -aG sudo tim
# 切换到tim用户
su - tim
# 验证tim用户拥有sudo权限
sudo whoami
# 退出tim用户
logout
# 通过tailscale IP地址SSH连接到tim用户
ssh tim@tailscale-ip

# 本地端口转发，将本地18789端口转发到远程127.0.0.1:18789
ssh -N -L 18789:127.0.0.1:18789 tim@100.x.x.x
```

实测下来，由于阿里云轻量vps内存比较小，tailscale在后台占用又比较大（2.x%），最主要是死机之后就断联了连救援登录都不行，我最后没有采用tailscale连接，直接用的ssh key。

本地端口转发很好用，openclaw tui的内存占用很大（20+%），直接端口转发貌似只有gateway一个进程，相比之下不占内存。

## 安装openclaw

```sh
curl -fsSL https://openclaw.ai/install.sh | bash
```

没啥好说的安装和**更新**都是这个命令，但是就这个命令给我卡死机好几回，只能无奈强制重启。

# 配置

配置文件位置

• 主配置：~/.openclaw/openclaw.json(第三方api和模型都在这)
• Auth：~/.openclaw/agents/main/agent/auth-profiles.json(只配置了github-copilot的token)
• Channel 配置：主配置内的 channels 字段
• 工作区：~/.openclaw/workspace/


# 问题
## tailscale无法通过域名ssh连接
这是DNS的问题，解决办法是在`tailscale控制台-DNS-Nameservers`中添加`global nameservers`并勾选`override DNS server`

## tailscale总是需要重新登陆
在[tailscale控制台](https://login.tailscale.com/admin/machines)把用到的设备设置为`disable key expiry`

