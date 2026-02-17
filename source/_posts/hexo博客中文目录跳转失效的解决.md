---
title: hexo博客中文目录跳转失效的解决
date: 2026-01-08 14:30:00
tags:
  - hexo
  - table-of-contents
categories: blog
---
<!-- toc -->

## 问题描述

博客里用`<!-- toc -->`生成目录后，中文标题的跳转链接全部失效了。检查发现目录中的中文都被转换成了`#---`这样的形式，点击后无法跳转到对应的标题位置。

比如标题是"基本概念"，生成的目录链接是`<a href="#----">基本概念</a>`，但实际的标题锚点ID是`id="基本概念"`，完全对不上。

## 原理分析

&lt;!-- toc --&gt;生成目录的机制：

1. **hexo-toc插件**：扫描markdown中的&lt;!-- toc --&gt;标记，提取所有标题
2. **hexo-renderer-marked**：将markdown标题转换为HTML锚点
3. **问题根源**：`hexo-renderer-marked`默认的slugify函数不支持中文，会将所有非ASCII字符替换为`-`

所以目录链接和实际标题的ID不匹配，导致跳转失效。

## 尝试过但无效的方法

### 方法一：修改marked配置（❌ 无效）

在`_config.yml`中修改`marked`的配置：

```yaml
marked:
  gfm: true
  pedantic: false
  sanitize: false
  tables: true
  breaks: false
  smartLists: true
  smartypants: false
  headerIds: true
  lazyload: false
  prependRoot: false
  postAsset: false
  modifyAnchors: 1  # 0=保持原样, 1=小写, 2=小写+替换非字母数字
  descriptionLists: true
```

设置`modifyAnchors: 1`后，标题的ID确实保留了中文（`id="基本概念"`），但`hexo-toc`插件生成的目录链接依然是`#----`，问题没有解决。

### 方法二：安装hexo-permalink-pinyin（❌ 无效）

```bash
npm install hexo-permalink-pinyin --save
```

这个插件主要用于转换URL中的中文，但对`hexo-toc`生成的目录锚点没有影响。

## 最终有效的解决方案

### 更换渲染器：hexo-renderer-markdown-it

**核心思路**：`hexo-renderer-marked`对中文支持不好，换成`hexo-renderer-markdown-it`，它对中文字符的处理更友好。

### 具体步骤

1. **卸载旧渲染器和toc插件**：

```bash
npm uninstall hexo-toc --save
npm uninstall hexo-renderer-marked --save
```

2. **安装新渲染器和toc插件**：

```bash
npm install hexo-renderer-markdown-it --save
npm install hexo-toc --save
npm install markdown-it-toc-done-right --save
```

3. **修改`_config.yml`配置**：

```yaml
theme: icarus

# hexo-toc配置
toc:
  maxdepth: 6
  class: toc
  slugify: encodeURI  # 关键：使用encodeURI处理中文
  anchor:
    position: before
    symbol: "¶ "
    style: header-anchor

# markdown-it配置
markdown:
  preset: 'default'
  render:
    html: true
    xhtmlOut: false
    breaks: false
    linkify: true
    typographer: true
  anchors:
    level: 2
    collisionSuffix: ''
    permalink: false
    permalinkClass: header-anchor
    permalinkSymbol: ¶
    permalinkBefore: false
```

**关键配置**：`slugify: encodeURI`，这告诉hexo-toc使用URL编码来处理中文，而不是替换成`-`。

4. **清理并重新生成**：

```bash
hexo clean
hexo generate
hexo server
```

5. **验证效果**：

访问包含中文标题的文章，检查生成的HTML：

```html
<!-- 目录链接 -->
<li><a href="#%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5">基本概念</a></li>

<!-- 标题锚点 -->
<h2 id="基本概念"><a href="#基本概念" class="headerlink" title="基本概念"></a>基本概念</h2>
```

虽然看起来编码不同（一个是URL编码`%E5%9F%BA...`，一个是原始中文`基本概念`），但浏览器会自动处理这种差异，点击目录可以正常跳转了！

## 总结

- **问题根本**：`hexo-renderer-marked` + `hexo-toc`组合对中文支持不好
- **解决方案**：换成`hexo-renderer-markdown-it` + `hexo-toc`（配置`slugify: encodeURI`）
- **关键点**：`slugify: encodeURI`让目录链接使用URL编码，而不是简单替换为`-`

这样中文目录就能正常跳转了，不用再担心中文标题的锚点问题。

