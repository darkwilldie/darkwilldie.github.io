---
title: 解决vscode终端下显示两遍conda环境的问题
date: 2024-09-20 16:07:17
tags:
  - vscode
  - conda
  - troubleshooting
categories: environment
---

# 问题

电脑自己打开的终端是正常的 自带的终端：

```bash
(base) ➜  ~
```

vscode 终端：

```bash
(base) (base) ➜  ~
```

# 解决

参考[网络资料](https://v2ex.com/t/1017004)，在vscode中设置

```json
在 settings.json 加一行：
"terminal.integrated.shellIntegration.enabled": false,
```

