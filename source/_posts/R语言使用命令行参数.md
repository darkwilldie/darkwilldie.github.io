---
title: R语言使用命令行参数
date: 2024-09-18 08:46:29
tags: R
categories: coding
---

因为用同一个文件对不同数据集画图的时候，每次都改文件内容有点麻烦，而且容易忘，所以有使用命令行参数的需求。

由于我对 R 语言不熟悉，导致这个更新拖延了很久，实际去做的时候发现非常简单。

参考[CSDN](https://blog.csdn.net/u011596455/article/details/79753788)。

读取命令行参数：

```R
args <- commandArgs(T)
```

这里的 T 是过滤掉了默认参数（不是用户输入的参数）

调用：

```R
print(args[1])
print(args[2])
print(args[3])
print(args[4])
...
```

> 注意参数列表从 1 开始，而非常见的 0

`args[1]`就是输入的第一个参数，以此类推，有多少个参数就能通过`args[i]`调用几个。

那么不带`T`的参数调用呢？

```R
args <- commandArgs()
```

实践是检验真理的唯一标准。我们先写一个输出参数 0~9 的测试文件`test.R`：

```R test.R
Args <- commandArgs()
cat("Args[0] =", Args[0], "\n")
cat("Args[1] =", Args[1], "\n")
cat("Args[2] =", Args[2], "\n")
cat("Args[3] =", Args[3], "\n")
cat("Args[4] =", Args[4], "\n")
cat("Args[5] =", Args[5], "\n")
cat("Args[6] =", Args[6], "\n")
cat("Args[7] =", Args[7], "\n")
cat("Args[8] =", Args[8], "\n")
cat("Args[9] =", Args[9], "\n")
```

终端运行`test.R`进行测试：

```bash
> Rscript.exe .\beifen\R_plot\test.R a b c d
Args[0] =
Args[1] = D:\R-4.4.1\bin\x64\Rterm.exe
Args[2] = --no-echo
Args[3] = --no-restore
Args[4] = --file=.\beifen\R_plot\test.R
Args[5] = --args
Args[6] = a
Args[7] = b
Args[8] = c
Args[9] = d
```

可见用户输入参数是从第六个开始的。
