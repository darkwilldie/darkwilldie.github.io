---
title: aliyun轻量服务器搭建openclaw
date: 2026-02-09 11:00:53
tags:
  - openclaw
  - vps
categories: environment
---
<!-- toc -->

vps的可玩性真的太高了，aliyun这个79一年的可选大马、印尼等外区，实测没什么网络问题。唯一的问题是2核2G有时候会爆内存(尤其是更新的时候，几乎必定死机一两次)，感觉还是openclaw优化的问题。

最开始的安装是参照的[这个Youtube视频](https://youtu.be/tnsrnsy_Lus?si=K5oNGFvLISLhoIZf)

设置tailscale之后无法访问域名（DNS问题）的解决办法是在`tailscale控制台-DNS-Nameservers`中添加global nameservers并勾选`override DNS server`

