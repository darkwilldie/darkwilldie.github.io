---
title: 从协方差，特征向量到典型相关分析-CCA
date: 2024-09-12 21:10:05
tags:
  - math
  - linear algebra
categories: math
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

<div>$$r=Cor(x,y)=\frac{\mathrm{Cov}(x,y)}{\mathrm{SD}(x)\cdot\mathrm{SD}(y)}=\frac{\mathrm{Cov}(x,y)}{\sqrt{\mathrm{var}(x)}\cdot\sqrt{\mathrm{var}(y)}}$$</div>

注意区分 $Cor$ 是相关性，$Cov$ 是协方差。

$r$ 等于随机变量 x 和 y 的样本协方差，除以样本的标准差之积（或者说方差的平方根之积）。

## 计算协方差

上面用到了样本 x 和 y 的协方差，那么协方差怎么计算呢？

<div>$$\mathrm{Cov}(x,y)=\frac{\sum_{i=1}^n\Bigl(x_i-\overline{x}\Bigr)\Bigl(y_i-\overline{y}\Bigr)}{n-1}$$</div>

可以看出这个式子和方差很相似。确实，协方差和方差从名字到式子都很相似，它们的分母相同，都为 $n-1$ ，方差的分子是 x 的平方级，协方差的分子相当于把方差中的一个 $(x_i-\overline{x})$ 替换为了 $(y_i-\overline{y})$。

当计算的是 x 和 x 自身的协方差 $Cov(x, x)$ 时，式子就变成了 $\frac{\sum_{i=1}^n(x_i-\overline{x})^2}{n-1}$。

i.e.

<div>$$Cov(x, x)=var(x)$$</div>

## 标准化

马上会用到的一个名词，在这里指的是把样本变换到均值为 0，标准差为 1，具体的实现方法是减去当前均值，除以标准差。

<div>$$x'=\frac{x-\overline{x}}{SD(x)}$$</div>

## 协方差和相关性的联系和区别

> 相关性在这里是皮尔逊相关系数的简称

协方差的范围是 $(-\infty,\infty)$，相关性的范围是 $[-1,1]$，这两个值是正相关。

相关性和协方差的关系，在我理解就是，两个**标准化**的随机变量之间的协方差就是相关性（i.e. 皮尔逊相关系数），因为 $r=\frac{\mathrm{Cov}(x,y)}{\mathrm{SD}(x)\cdot\mathrm{SD}(y)}$，分母中的标准差 $\mathrm{SD}(x)\cdot\mathrm{SD}(y)=1$，所以 $r=\frac{\mathrm{Cov}(x,y)}{\mathrm{SD}(x)\cdot\mathrm{SD}(y)}=\mathrm{Cov}(x,y)$。

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

正如上面介绍的相关性的性质，两个变量之间的相关性是一个 $[-1,1]$ 之间的量。

矩阵是一个三角形而非矩形，因为相关性矩阵是完全对称的，所以一般只保留下三角，这也是由于**相关性由协方差除以两个变量的标准差计算而来，分母都为 $\mathrm{SD}(x)\cdot\mathrm{SD}(y)$，而协方差具有交换律 $Cov(x,y)=Cov(y,x)$，因此推得 $Cor(x,y)=Cor(y,x)$**

|        | SBP  | DBP  | Height | Weight |
| ------ | ---- | ---- | ------ | ------ |
| SBP    | 1    |      |        |        |
| DBP    | 0.79 | 1    |        |        |
| Height | 0.25 | 0.54 | 1      |        |
| Weight | 0.37 | 0.66 | 0.92   | 1      |

观察相关性矩阵，我们可以看到：DBP 和 SBP 拥有 0.79 的强相关性，而 Height 和 Weight 拥有 0.92 的强相关性。

协方差矩阵也是类似，只是把相关性替换成了协方差，范围变成了 $(-\infty,\infty)$ 。

# 典型相关分析

以下内容来自[典型相关分析的 wiki](https://zh.wikipedia.org/wiki/%E5%85%B8%E5%9E%8B%E7%9B%B8%E5%85%B3)，这条目里除了下面这句话我都看不懂~~（这段话其实也不是很懂）~~，因此学到的主要内容还是来自[ytb](https://www.youtube.com/watch?v=2tUuyWTtPqM)。

> 在统计学中，典型相关分析（英语：Canonical Correlation Analysis）是对互协方差矩阵的一种理解。如果我们有两个随机变量向量 X = (X1, ..., Xn) 和 Y = (Y1, ..., Ym) 并且它们是相关的，那么典型相关分析会找出 Xi 和 Yj 的相互相关最大的线性组合。

同样是上面的例子，现在我们需要求的是 BP（Blood Pressure，即 SBP 和 DBP）和 BS（Body Size，即 Height 和 Weight）两个组之间的相关性，应该怎么求呢？

<img src="https://gitee.com/dwd1201/image/raw/master/202409150955172.png"/>

看图上右边的两个等式，每一组的变量分别乘了对应的系数，得到了新的 BP 和 BS 两个变量。红框圈出的参数（即线性组合）可以进行优化，目的是使这两个新变量之间的相关性最大。

我们把通过等式计算出的 BP 和 BS 和其他变量放在一起（即表格黄色部分），计算这两个变量之间的相关性，可以得到 $Cor(BP,BS)=0.72$ 。

原始变量（SBP，DBP 和 Height，Weight）经过求出来的线性组合变换，得到了一个新的变量（BP，BS），新变量称作**典型变量**。

<img src="https://gitee.com/dwd1201/image/raw/master/202409152009905.png"/>

## 如何找到最优线性组合

### 计算协方差矩阵

把各个变量分别标识为 $x_1,x_2,y_1,y_2$，我们先计算各个变量之间的协方差矩阵。$R_{xx}$ 是 $x_1,x_2$ 与 $x_1,x_2$ 之间的协方差矩阵，$R_{xy}$ 是 $x_1,x_2$ 与 $y_1,y_2$ 之间的协方差矩阵，其余同理。

$R_{yx}$ 仅仅是 $R_{xy}$ 的转置。

<img src="https://gitee.com/dwd1201/image/raw/master/202409152026388.png"/>

### 计算协方差矩阵的乘积

上图的红框中展示了乘积 $R_x$ 的计算方法，即：

<div>$$R_x=R_{xx}^{-1}R_{xy}R_{yy}^{-1}R_{yx}$$</div>

### 计算乘积$R_x$的特征向量

<img src="https://gitee.com/dwd1201/image/raw/master/202409152036468.png"/>

求出 $R_x$ 的特征向量，作为列向量放入矩阵$v_x$，第一个列向量就是 BP 变量对应的线性组合（第二个列向量是第二组能使 BP 和 BS 相关性最大的**BP 的**线性组合）。

**再说一遍，乘积 $R_x$ 的特征向量的第一组，就是我们要找的，使 BP 和 BS 相关性最大的 BP 线性组合**

那么找到了 BS 的线性组合，就可以用同样的方法求出 BP 的线性组合。

<div>$$R_y=R_{yy}^{-1}R_{yx}R_{xx}^{-1}R_{xy}$$</div>

<img src="https://gitee.com/dwd1201/image/raw/master/202409152103965.png"/>

有特征向量，那么当然也有特征值。特征值代表着什么呢？

<div>$$r=\sqrt{\lambda_1}=\sqrt{0.519}=0.72$$</div>

特征值的平方根就是我们之前通过计算皮尔逊相关系数计算出的 $Cor(BP,BS)$。$\lambda$ 不只是 $R_x$ 矩阵的第一个特征值，同样也是 $R_y$ 的第一个特征值，等于相关性的平方 $r^2$。

## 标准化

找到了最优的线性组合，也找到了相关性最大的变量，我们得到了以下等式：

<div>$$\begin{aligned}&\mathrm{BP}=0.131\cdot\mathrm{SBP}+(-0.991)\cdot\mathrm{DBP}\\&\mathrm{BS}=0.426\cdot\mathrm{Height}+(-0.905)\cdot\mathrm{Weight}\end{aligned}\tag{1}\label{eq1}$$</div>

不过在统计工具中，这个权重常常需要重新调节以标准化。也就是把 BP 和 BS 两个变量变成标准化的变量 zBP 和 zBS。

<img src="https://gitee.com/dwd1201/image/raw/master/202409152116126.png"/>

我们直接在公式中 $\eqref{eq1}$ 进行标准化，在系数上体现为 $c'=\frac{c}{SD}$。

<div>$$\begin{aligned}&\mathrm{zBP}=0.042\cdot(\mathrm{SBP}-\overline{\mathrm{SBP}})+(-0.318)\cdot(\mathrm{DBP}-\overline{\mathrm{DBP}})\\&\mathrm{zBS}=0.059\cdot(\mathrm{Height}-\overline{\mathrm{Height}})+(-0.126)\cdot(\mathrm{Weight}-\overline{\mathrm{Weight}})\end{aligned}$$</div>

我们也可以先标准化 SBP，DBP，Height 和 Weight。这样等式右边用到的变量就变成了 zSBP，zDBP，zHeight 和 zWeight，导致了不同的系数。

<img src="https://gitee.com/dwd1201/image/raw/master/202409152139990.png"/>

<div>$$\begin{aligned}&\mathrm{zBP}=0.477\cdot z\mathrm{SBP}+(-1.331)\cdot z\mathrm{DBP}\\&\mathrm{zBS}=0.510\cdot z\mathrm{Height}+(-1.450)\cdot z\mathrm{Weight}\end{aligned}$$</div>

## 载荷（Loadings）

统计工具还常常会各个变量和求出的线性组合之间的相关性矩阵。

<img src="https://gitee.com/dwd1201/image/raw/master/202409152150730.png"/>

|        | zBP   | zBS   |
| ------ | ----- | ----- |
| SBP    | -0.57 | -0.41 |
| DBP    | -0.96 | -0.69 |
| Height | -0.59 | -0.82 |
| Weight | -0.71 | -0.98 |

无论进行标准化与否，都不影响矩阵中的相关性值（因为相关性本来就是标准化后的协方差）。

### 典型载荷

> 典型载荷（Canonical Loadings）：
> 典型载荷是指在典型相关分析中，每个变量在对应的典型变量（canonical variable）上的载荷。典型变量是原始变量的线性组合，它们最大化了两组变量之间的相关性。对于每一对典型变量，都会有一组典型载荷，这些载荷表明了原始变量如何贡献于构建这些典型变量。
>
> - 在第一组变量中的典型载荷表示了这些变量如何组合以最大化与第二组变量的典型变量的相关性。反过来同理。

<img src="https://gitee.com/dwd1201/image/raw/master/202409152157997.png"/>

说人话就是：原始变量和对应的典型变量之间的相关性。

### 交叉载荷

> 交叉载荷是指一个变量在非对应组的典型变量上的载荷。也就是说，它表示了一个变量如何贡献于构建另一组的典型变量。
>
> - 例如，如果第一组变量的某个变量在第二组变量的典型变量上有较高的载荷，那么这个载荷就是一个交叉载荷。
> - 交叉载荷有助于理解变量如何跨越两组变量，对两组变量的典型变量都有贡献。

<img src="https://gitee.com/dwd1201/image/raw/master/202409152205876.png"/>

说人话：原始变量和**不对应**的典型变量之间的关系。

## 典型相关分析

利用第一组线性组合，我们可以得到如下的相关性图。

<img src="https://gitee.com/dwd1201/image/raw/master/202409152213378.png"/>

可以看到，**SBP，DBP 与 BP**和**Height，Weight 与 BS**这两组典型载荷都是负相关，有点不符合直觉。实际上，CCA 只找出相关性最大的线性组合，不管这个组合是是正是负。

我们使用典型相关分析的主要目的是找出**两组变量的总相关性**，也就是图中的 0.72，是一个正相关。

如果我们想要分析单个变量两两之间的相关性，可以直接使用相关性矩阵。

|        | SBP  | DBP  | Height | Weight |
| ------ | ---- | ---- | ------ | ------ |
| SBP    | 1    | 0.79 | 0.25   | 0.37   |
| DBP    | 0.79 | 1    | 0.54   | 0.66   |
| Height | 0.25 | 0.54 | 1      | 0.92   |
| Weight | 0.37 | 0.66 | 0.92   | 1      |

## 如果使用第二组特征向量？

我们可以使用第二组特征变量来找到对应的线性组合，但是可能会导致低得多的相关性，因为第二组特征向量算是一种副产品。

<img src="https://gitee.com/dwd1201/image/raw/master/202409152222004.png"/>

在这个例子中，第二组线性组合显示，更大的体重和身高会导致更低的舒张压和收缩压，这显然是不可用的结果。

我们来看看这两组特征向量对应的特征值。（回忆一下，相关性 $r=\sqrt{\lambda}$）

<div>$$\lambda_1=0.52\quad\lambda_2=0.04$$</div>

显然，第一组特征向量的特征值远远大于第二组。

不过，这个例子中一组只含有两个变量，如果有很多变量，那么也有很多特征值和特征向量。在这种情况下，可能有两个或更多很大的特征值，我们可以利用这些大的特征值来完成和 PCA 类似的分析。
