---
title: 快速傅里叶变换(FFT)
date: 2024-10-23 08:49:55
tags: fft
categories: math
---

<!-- toc -->

# 概念解释

- 时域: 函数的多项式表示, 即系数表示法 $f(x)=a_0+a_1x+a_2x^2\dots a_{n-1}x^{n-1}$
- 频域: 函数的点值表示, 即用 n 个点表示一个 n-1 次函数 $f(x)=\{(x_0, f(x_0)),(x_1, f(x_1)),\dots(x_{n-1},f(x_{n-1}))\}$

**傅里叶变换**就是把函数**从时域变换到频域**的变换, **从频域到时域**的变换称为**逆傅里叶变换**.

# 为什么需要傅里叶变换

通常我们计算多项式乘法 $C(x)=A(x)\cdot B(x)$ 时, 如果使用多项式表示, 需要 $O(n^2)$ 级别复杂度 (n 是多项式的度, A 的 n 项中的每一项需要乘以 B 的 n 项).

如何降低复杂度呢? 答案就是使用点值表示法. 取 n 个点 $\{x_0,x_1,\dots,x_{n-1}\}$, 带入两个已知的函数得到:

- A 的点值表示法为 $A(x)=\{(x_0, A(x_0)),(x_1, A(x_1)),\dots(x_{n-1},A(x_{n-1}))\}$
- B 的点值表示法为 $B(x)=\{(x_0, B(x_0)),(x_1, B(x_1)),\dots(x_{n-1},B(x_{n-1}))\}$

这样, $C(x)=A(x)\cdot B(x)$ 就可以表示为 $C(x)=\{(x_0, A(x_0)\cdot B(x_0)),(x_1, A(x_1)\cdot B(x_1)),\dots(x_{n-1},A(x_{n-1})\cdot A(x_{n-1}))\}$, 这个过程的时间复杂度仅为 $O(n)$.

这个从多项式表示转换到点值的变换, 就是傅里叶变换.

## 快速傅里叶变换的思路

傅里叶变换是把多项式表示转化为点值表示的变换. 实际上我们任意取 n 个不同的点, 并一一代入原函数也可以完成任务. 但这样做的开销达到了 $O(n^2)$ (因为每一次代入需要计算 n 项, 总共要带入 n 个 x 值).

复杂度还是 $O(n^2)$, 这样我们费工夫从时域转换到频域不就没意义了吗?

### 从 FT 到 FFT

那么如何减小这个开销? 我们想到的是利用函数的对称性, 通过更少的计算得到更多的点. 比如在偶函数中, 我们计算出 $f(x)$, 就得到了 $f(-x)=f(x)$, 这就是快速傅里叶变换的思路.

FFT 的处理过程如下:

$$
\begin{align*}
f(x)&=a_0+a_1x+a_2x^2+a_3x^3+a_4x^4+a_5x^5+a_6x^6\\
&=\big((a_0+a_2x^2+a_4x^4+a_6x^6)+x\cdot(a_1+a_3x^2+a_5x^4)\big)\\
&=G(x)+x\cdot H(x)
\end{align*}
$$

容易看出 $G(x),H(x)$ 都是偶函数. 也就是说, 通过计算 $G(x),H(x)$, 我们可以得到:

$$
f(-x)=G(x)-x\cdot H(x)
$$

再来看 $G(x)$, 如果让 $k=x^2$, 我们可以得到关于 $k$ 的函数 $G(k)=a_0+a_2k+a_4k^2+a_6k^3$, 我们得到了一个新的多项式!

很容易可以想到尝试递归地利用 $f(k)$ 得到 $f(-k)$. 然而这里有一个问题 $k=x^2\geq 0$. 也就是说 **$-k<0$ 不在定义域范围内!**

### 引入复数

通过引入复数, $x^2<0$ 也可以成立, 因此可以完成递归.

欧拉公式给出了复数的指数表示:

$$
e^{i\theta}=\sin(\theta)+i\cos(\theta)
$$

也就是说我们把时间函数 $f(t)$ 分解成正弦波和余弦波.

<img src="https://gitee.com/dwd1201/image/raw/master/202410231423927.png"/>

如上图所示, $e^{i\theta}$ 的周期为 $2\pi$, 且 $e^{i\theta}$ 的值一定在图中的单位圆上, $\omega$ 相当于 $x$ 值. ($\sin(\theta)$ 和 $\cos(\theta)$ 的周期都是 $2\pi$, 且$\sin(\theta)^2+\cos(\theta)^2=1$)

我们把单位圆均分成 $n$ 份 ($2^n>2^{d+1}$, d 是最高项指数), 每一份是 $\frac{2\pi}{n}$, 此时 $\{x_0,x_1,x_2\dots,x_n\}$ 变为 $\{e^{0},e^{\frac{2\pi}{n}\cdot i},e^{2\cdot \frac{2\pi}{n}\cdot i},\dots,e^{(n-1)\frac{2\pi}{n}\cdot i}\}$, 简记为 $\{\omega_n^0,\omega_n^1,\omega_n^2,\dots,\omega_n^{n-1}\}$

# FFT 代码

```C++
#include <cmath>
#include <complex>

using Comp = std::complex<double>;  // STL complex

constexpr Comp I(0, 1);  // i
constexpr int MAX_N = 1 << 20;

Comp tmp[MAX_N];

// rev=1,DFT; rev=-1,IDFT
void DFT(Comp* f, int n, int rev) {
  if (n == 1) return;
  for (int i = 0; i < n; ++i) tmp[i] = f[i];
  // 偶数放左边，奇数放右边
  for (int i = 0; i < n; ++i) {
    if (i & 1)
      f[n / 2 + i / 2] = tmp[i];
    else
      f[i / 2] = tmp[i];
  }
  Comp *g = f, *h = f + n / 2;
  // 递归 DFT
  DFT(g, n / 2, rev), DFT(h, n / 2, rev);
  // cur 是当前单位复根，对于 k = 0 而言，它对应的单位复根 omega^0_n = 1。
  // step 是两个单位复根的差，即满足 omega^k_n = step*omega^{k-1}_n，
  // 定义等价于 exp(I*(2*M_PI/n*rev))
  Comp cur(1, 0), step(cos(2 * M_PI / n), sin(2 * M_PI * rev / n));
  for (int k = 0; k < n / 2; ++k) {
    // 把 f(k) 放在位置 k, f(-k) 放在位置 k+n/2
    tmp[k] = g[k] + cur * h[k];
    tmp[k + n / 2] = g[k] - cur * h[k];
    cur *= step;
  }
  for (int i = 0; i < n; ++i) f[i] = tmp[i];
}
```

$step=e^{i\cdot{\frac{2\pi}{n}}}$, 通过乘以 `step` 更新到下一个单位根 $\omega^k=step\cdot\omega^{k-1}=e^{i\cdot{\frac{2\pi}{n}}}\cdot e^{i\cdot{(k-1)\frac{2\pi}{n}}}=e^{i\cdot{\frac{2k\pi}{n}}}$.

# 未完待续

> 以下内容写得很零碎, 也不知道对不对, 等以后学明白了再补充

为什么最后是一个 0 到 n/2 的循环呢? 我们不需要管分治后的小问题, 只看 $f(x)=\{a_0+a_2x^2+\dots\}+x\cdot \{a_1+a_3x^2+\dots\}$, 我们把偶次项在左, 奇次项在右的多项式设为 $A=\{a_0,a_2,\dots,a_1,a_3\}$, 代入一个具体的值 $x_k$ 有:

$$
f(x_k)=A_k+x_k\cdot A_{k+\frac{n}{2}},\\
f(x_{k+\frac{n}{2}})=f(-x_k)=A_k-x_k\cdot A_{k+\frac{n}{2}}
$$

注意这里的 $x_k$ 指的是具体的一个 $x$ 值, 跟 $f(x)$ 中的 $a_0,a_1\dots$ 没关系.

$f(x)=\{(x_0, f(x_0)),(x_1, f(x_1)),\dots(x_{n-1},f(x_{n-1}))\}$
