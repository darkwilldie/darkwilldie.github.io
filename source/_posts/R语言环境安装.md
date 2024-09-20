---
title: R语言环境安装
date: 2024-09-20 09:58:14
tags:
  - R
categories: environment
---

# R 安装

在 linux 下安装 R，只需要执行：

```bash
sudo apt install r-base
```

安装成功后就可以通过`R`命令进入 R 控制台，并且可以使用`Rscript filename`来执行 R 脚本。

那么如何安装 R 语言中的其他包呢？先输入`R`进入 R 控制台。

> 注意，如果我们需要把包安装在`/usr/local/lib/R/site-library`路径，我们需要用`sudo R`，否则只能安装在用户目录下。

我们这次从需要的包是`magick`和`EBImage`。我们先来安装`magick`：

# magick 安装

```r
install.packages("magick")
```

但是没有`pip install`那么顺利，我们很可能遇到这个错误：

```r
--------------------------- [ANTICONF] --------------------------------
Configuration failed because libcurl was not found. Try installing:
 * deb: libcurl4-openssl-dev (Debian, Ubuntu, etc)
 * rpm: libcurl-devel (Fedora, CentOS, RHEL)
If libcurl is already installed, check that 'pkg-config' is in your
PATH and PKG_CONFIG_PATH contains a libcurl.pc file. If pkg-config
is unavailable you can set INCLUDE_DIR and LIB_DIR manually via:
R CMD INSTALL --configure-vars='INCLUDE_DIR=... LIB_DIR=...'
-------------------------- [ERROR MESSAGE] ---------------------------
<stdin>:1:10: fatal error: curl/curl.h: No such file or directory
compilation terminated.
--------------------------------------------------------------------
ERROR: configuration failed for package ‘curl’
* removing ‘/usr/local/lib/R/site-library/curl’
ERROR: dependency ‘curl’ is not available for package ‘magick’
* removing ‘/usr/local/lib/R/site-library/magick’
```

直接看报错信息显示我们缺少了`curl`包，那么再执行`install.packages("curl")`，发现仍然报错。

我们重新来看看报错信息：

```r
--------------------------- [ANTICONF] --------------------------------
Configuration failed because libcurl was not found. Try installing:
 * deb: libcurl4-openssl-dev (Debian, Ubuntu, etc)
 * rpm: libcurl-devel (Fedora, CentOS, RHEL)
```

显然我们还缺少了别的东西。那么按照它的指示在终端去运行`sudo apt install libcurl4-openssl-dev`（如果这个步骤报错，可以试试`sudo apt update`）。

> 为什么知道是`sudo apt install`呢？
> 因为这个命令安装的就是 deb 格式的包，也就是.deb 文件。

然后再来`install.packages("curl")`，这时候已经可以成功安装了。

相信到这里，大家已经有了看报错信息安装缺少依赖的能力。比如接下来`install.packages("magick")`的时候还会报错。

```r
--------------------------- [ANTICONF] --------------------------------
Configuration failed to find the Magick++ library. Try installing:
 - deb: libmagick++-dev (Debian, Ubuntu)
 - rpm: ImageMagick-c++-devel (Fedora, CentOS, RHEL)
 - brew: imagemagick or imagemagick@6 (MacOS)
```

那么就应该是在终端输入`sudo apt install libmagick++-dev`，安装成功后再次`install.packages("magick")`，大功告成！手动放烟花 🎇

# EBImage 安装

再来第二个 boss。这个包不能直接通过`install.packages("EBImage")`安装，我们需要先安装包管理器`BiocManager`，再通过`BiocManager`安装`EBImage`~~（R 语言界需要秦始皇）~~：

```r
install.packages("BiocManager")
BiocManager::install("EBImage")
```

在我安装过程中又遇到了依赖`fftwtools`安装失败的问题，而且还不写明缺什么包！

询问 AI 后得知需要`sudo apt-get install libfftw3-dev`，安装后再`install.packages("fftwtools")`，最后重新`BiocManager::install("EBImage")`，大功告成（累了已经）！
