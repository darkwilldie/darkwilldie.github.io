---
title: 从协方差，特征向量到典型相关分析-CCA
date: 2024-09-12 21:10:05
tags:
  - math
  - linear algebra
---

<meta name="referrer" content="no-referrer" />

开始看[CCA 的 wiki](https://zh.wikipedia.org/wiki/%E5%85%B8%E5%9E%8B%E7%9B%B8%E5%85%B3)的时候————这是中文吗？

于是从协方差开始补（这玩意概统学了吗？没学吗？(っ °Д °;)っ果然出来混都是要还的……）。不幸的是，[协方差的 wiki](https://zh.wikipedia.org/wiki/%E5%8D%8F%E6%96%B9%E5%B7%AE)我仍然看不懂……

于是求助万能的 ytb，看了[非常细致的教程](https://www.youtube.com/watch?v=2bcmklvrXTQ)终于懂了协方差是个什么玩意，太感人了。那么赶紧写一下协方差的博客，~~过一天估计就忘了~~。

# 协方差

> 在概率论与统计学中，协方差（英语：Covariance）用于衡量随机变量间的相关程度。

## 方差和标准差

要理解协方差，首先要理解方差（英语：Variance）：

<div>$$\operatorname{var}(x)=\frac{\sum_{i=1}^n(x_i-\overline{x})^2}{n-1}$$</div>

这个公式大家应该不陌生，可能有点陌生的是分母的 n-1。样本方差为了更好地估计实际的方差，分母需要从 n 变为 n-1。

然后是标准差（英语：Standard Deviation），等于方差的平方根。

<div>$$\mathrm{SD}(x)=\sqrt{\mathrm{var}(x)}$$</div>

## 皮尔逊相关系数

Pearson correlation coefficient 用于度量两组数据的变量 X 和 Y 之间的线性相关的程度。以下是用样本来估计的皮尔逊相关系数 $r$ 的计算方法：

<div>$$r=\frac{\mathrm{Cov}(x,y)}{\mathrm{SD}(x)\cdot\mathrm{SD}(y)}=\frac{\mathrm{Cov}(x,y)}{\sqrt{\mathrm{var}(x)}\cdot\sqrt{\mathrm{var}(y)}}$$</div>

$r$ 等于随机变量 x 和 y 的样本协方差，除以样本的标准差之积。

## 计算协方差

上面用到了样本 x 和 y 的协方差，那么协方差怎么计算呢？

<div>$$\mathrm{Cov}(x,y)=\frac{\sum_{i=1}^n\Bigl(x_i-\overline{x}\Bigr)\Bigl(y_i-\overline{y}\Bigr)}{n-1}$$</div>

可以看出这个式子和方差很相似。确实，协方差和方差从名字到式子都很相似，它们的分母相同，都为 $n-1$ ，方差的分子是 x 的平方级，协方差的分子相当于把方差中的一个 $(x_i-\overline{x})$ 替换为了 $(y_i-\overline{y})$。

当计算的是 x 和 x 自身的协方差 $Cov(x, x)$ 时，式子就变成了 $\frac{\sum_{i=1}^n(x_i-\overline{x})^2}{n-1}$。

i.e.

<div>$$Cov(x, x)=var(x)$$</div>

## 标准化

马上会用到的一个名词，在这里指的是把样本变换到均值为 0，标准差为 1，具体的实现方法是减去当前均值，除以标准差。

## 协方差和相关性的联系和区别

> 相关性在这里是皮尔逊相关系数的简称

协方差的范围是 $(-\infty,\infty)$，相关性的范围是 $[-1,1]$，这两个变量是正相关。

相关性和协方差的关系，在我理解就是，两个标准化的随机变量之间的协方差就是相关性（i.e. 皮尔逊相关系数），因为 $\frac{\mathrm{Cov}(x,y)}{\mathrm{SD}(x)\cdot\mathrm{SD}(y)}$ 分母中的标准差都为 1，所以 $r=\frac{\mathrm{Cov}(x,y)}{\mathrm{SD}(x)\cdot\mathrm{SD}(y)}=\mathrm{Cov}(x,y)$。

## 相关性矩阵

以下是一些病人的病历数据，我们需要计算出不同项（收缩压、舒张压、身高、体重）之间的相关程度，需要用到相关性矩阵。

|     | SBP | DBP | Height (cm) | Weight (kg) |
| --- | --- | --- | ----------- | ----------- |
| 1   | 120 | 76  | 165         | 60          |
| 2   | 109 | 80  | 180         | 80          |
| 3   | 130 | 82  | 170         | 70          |
| 4   | 121 | 78  | 185         | 85          |
| 5   | 135 | 85  | 180         | 90          |
| 6   | 140 | 87  | 187         | 87          |

正如上面介绍的相关性的性质，两个变量之间的相关性是一个 $[-1,1]$ 之间的量。矩阵是一个三角形而非矩形，因为相关性矩阵是完全对称的，所以一般只保留下三角，这也是由于**相关性由协方差计算而来，而协方差具有交换律 $Cov(x,y)=Cov(y,x)$**

|        | SBP  | DBP  | Height | Weight |
| ------ | ---- | ---- | ------ | ------ |
| SBP    | 1    |      |        |        |
| DBP    | 0.79 | 1    |        |        |
| Height | 0.25 | 0.54 | 1      |        |
| Weight | 0.37 | 0.66 | 0.92   | 1      |

观察相关性矩阵，我们可以看到：DBP 和 SBP 拥有 0.79 的强相关性，而 Height 和 Weight 拥有 0.92 的强相关性。

协方差矩阵也是类似，只是把相关性替换成了协方差，范围变成了 $(-\infty,\infty)$ 。

# 典型相关分析

以下内容来自[典型相关分析的 wiki](https://zh.wikipedia.org/wiki/%E5%85%B8%E5%9E%8B%E7%9B%B8%E5%85%B3)，这条目里除了下面这句话我都看不懂，因此学到的主要内容还是来自[ytb](https://www.youtube.com/watch?v=2tUuyWTtPqM)。

> 在统计学中，典型相关分析（英语：Canonical Correlation Analysis）是对互协方差矩阵的一种理解。如果我们有两个随机变量向量 X = (X1, ..., Xn) 和 Y = (Y1, ..., Ym) 并且它们是相关的，那么典型相关分析会找出 Xi 和 Yj 的相互相关最大的线性组合。

![图片](https://gitee.com/dwd1201/image/raw/master/202409150955172.png)
