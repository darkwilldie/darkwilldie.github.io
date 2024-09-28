---
title: miniconda安装和pip/conda换源
date: 2024-09-25 21:36:22
tags:
  - pip
  - conda
categories: environment
---

<meta name="referrer" content="no-referrer" />

# conda

## 安装 miniconda

参考 [Miniconda — miniconda documentation](https://docs.conda.io/projects/miniconda/en/latest/)

```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
```

安装后进行初始化：

```bash
~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh
```

如果安装一切正常，但仍然没有 conda 环境显示，可以去 `~/.bashrc` 查看添加的 conda 环境变量是否正确，改过来即可显示 `(base)` 环境。

## conda 换源

参考[conda 换源 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/87123943)
修改 `~/.condarc`

```ini
channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
ssl_verify: true
```

博客中也提到了中科大，上交大的镜像。

# pip

## pip 换源

参考[修改 pip 源为国内源 - 掘金 (juejin.cn)](https://juejin.cn/post/7141566114412101662)

在 shell 输入

```shell
# 清华源
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# 阿里源
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
# 腾讯源
pip config set global.index-url http://mirrors.cloud.tencent.com/pypi/simple
# 豆瓣源
pip config set global.index-url http://pypi.douban.com/simple/
# 换回默认源
pip config unset global.index-url
```

或创建 `~/.pip/pip.conf` 配置文件。

```ini
[global]
index-url=http://pypi.douban.com/simple
[install]
trusted-host=pypi.douban.com
```
