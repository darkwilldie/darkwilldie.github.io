---
title: 给hexo博客添加目录
date: 2024-10-07 11:05:06
tags:
categories:
---
<meta name="referrer" content="no-referrer" />

参考[csdn博客](https://blog.csdn.net/qq_46527915/article/details/105466439)。

1. 安装hexo-toc：`npm install hexo-toc --save`，安装慢记得代理或换源。
2. 在`_config.yml`添加：
  ```DTS
  toc:
    maxdepth: 6
    class: toc
    slugify: transliteration
    decodeEntities: false
    anchor:
      position: before
      symbol: "#"
      style: header-anchor
  ```
3. 在需要展示目录前添加：
  ```xml
  <!-- toc -->
  ```