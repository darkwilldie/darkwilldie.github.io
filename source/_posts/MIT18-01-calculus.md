---
title: MIT18.01 calculus
date: 2024-10-28 20:12:25
tags: calculus
categories: math
---

<!-- toc -->

一些导数推导可以看{% post_link 如何求任意函数的导数 %}. 但原理都是一样的, 先求 $\Delta f(x)$, 然后除以 $\Delta x$, 想办法把 $\Delta x$ 消掉, 最后取极限 $\lim_{\Delta x\rightarrow 0}\frac{\Delta f(x)}{\Delta x}=\frac{df(x)}{dx}$ 得到导数.

## 求导规则

- $(Cu)'=Cu'(C为常数)$
- $(u+v)'=u'+v'$
- $(uv)'=u'v+uv'$
- $\frac{u}{v}'=\frac{u'v-uv'}{v^2}$
- $\frac{1}{u}'=\frac{-u'}{u^2}$
- $(f(t))'=f'(t(x))t'(x)$

### 证明

求导规则可以用上述同样的方法证明.

乘法求导规则:

$$
\begin{align*}
\Delta (uv)&=u(x+\Delta x)\cdot v(x+\Delta x)-u(x)v(x)\\
&=(u(x+\Delta x)-u(x))\cdot(v(x+\Delta x)-v(x))+u(x)\cdot v(x+\Delta x)+v(x)u(x+\Delta x)-2u(x)v(x)\\
&=\Delta{u}\cdot\Delta{v}+u(x)\cdot(v(x+\Delta x)-v(x))+v(x)\cdot(u(x+\Delta x)-u(x))\\
&=\Delta{u}\Delta{v}+u\Delta{v}+v\Delta{u}\\
\frac{\Delta (uv)}{\Delta x}&=\frac{\Delta{u}\Delta{v}+u\Delta{v}+v\Delta{u}}{\Delta x}\\
(uv)'&=\frac{d(uv)}{dx}=\lim_{\Delta x\rightarrow 0}\frac{\Delta{u}\Delta{v}+u\Delta{v}+v\Delta{u}}{\Delta x}=uv'+vu'
\end{align*}
$$

除法求导规则:

$$
\begin{align*}
\Delta\frac{u}{v}&=\frac{u(x+\Delta{x})}{v(x+\Delta{x})}-\frac{u}{v}\\
&=\frac{u(x+\Delta{x})v(x)-u(x)v(x+\Delta x)}{v(x+\Delta{x})v(x)}\\
&=\frac{(u(x+\Delta{x})-u(x))\cdot v(x)+u(x)v(x)-u(x)v(x+\Delta x)}{v(x+\Delta{x})v(x)}\\
&=\frac{v(x)\cdot(u(x+\Delta{x})-u(x))-u(x)\cdot(v(x+\Delta x)-v(x))}{v(x+\Delta{x})v(x)}\\
&=\frac{v\cdot\Delta{u}-u\cdot\Delta{v}}{v(x+\Delta{x})v(x)}\\
\frac{\Delta(\frac{u}{v})}{\Delta{x}}&=\frac{v\cdot\frac{\Delta{u}}{\Delta{x}}-u\cdot\frac{\Delta{v}}{\Delta{x}}}{v(x+\Delta{x})v(x)}\\
\frac{u}{v}'&=\lim_{\Delta{x}\rightarrow{0}}\frac{v\cdot\frac{\Delta{u}}{\Delta{x}}-u\cdot\frac{\Delta{v}}{\Delta{x}}}{v(x+\Delta{x})v(x)}=\frac{vu'+uv'}{v^2}
\end{align*}
$$

链式法则:

$$
\begin{align*}
(f(t))'=\frac{df}{dt}\cdot\frac{dt}{dx}=f'(t(x))t'(x)
\end{align*}
$$
