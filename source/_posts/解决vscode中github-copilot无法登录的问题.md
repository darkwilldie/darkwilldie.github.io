---
title: 解决vscode中github copilot无法登录的问题
date: 2024-09-26 17:19:22
tags:
  - vscode
  - github-copilot
  - troubleshooting
categories: environment
---

<meta name="referrer" content="no-referrer" />

github copilot 作为可白嫖的 GPT4（chat 是经过微调的 GPT4，补全是微调的 GPT3.5），在很多时候还是很好用的。

但是我本地出现了一个问题，chat 页面无法进行 Sign In，点击没反应，查看`GitHub Copilot Chat`的 output，显示了这样的错误。

```
2024-09-26 15:58:38.942 [error] GitHub Copilot could not connect to server. Extension activation failed: "Unexpected token 'o', "[object Rea"... is not valid JSON"
```

这个问题我看了 github issue，但是没有找到答案。最后的解决方式也很简单粗暴——根据报错显示的 json 路径，直接删除对应的插件目录。

我删除了所有 github copilot 相关的目录，还是没管用，最后删除了`nicepkg.aide-pro-1.19`这个目录（也在报错路径中），重新安装 copilot 之后，就可以使用了。

