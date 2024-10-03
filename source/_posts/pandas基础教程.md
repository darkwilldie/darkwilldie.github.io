---
title: pandas基础教程
date: 2024-09-26 16:02:00
tags:
  - python
  - pandas
categories: coding
---

<meta name="referrer" content="no-referrer" />

# 前言

我是 pandas 小白，写这篇博客也是想记录一下自己学习的过程，并且整理遇到的概念，希望能打下一个良好的基础，避免学了忘，忘了学的尴尬处境。本博客参考[pandas 官方文档](https://pandas.pydata.org/docs/getting_started/)

pandas 的安装和导入非常简单且符合直觉。在终端中`pip install pandas`就可以完成安装，导入只需要`import pandas as pd`。

下文中将 pandas 部分简称为 pd。

# 数据结构

pandas 使用两种数据结构，`pd.DataFrame`和`pd.Series`。前者可以看作表格，后者可以看作表格中的列。所有的方法都是在这两种数据结构上进行操作。

## DataFrame

### 创建

pandas 中的`DataFrame`，可以通过 python 内置类型`dict`来创建，`key`作为列名，`value`用列表类型，作为每一行的数据（列表元素有几个，`DataFrame`内就有几行）

```py
import pandas as pd

data = {
    'Name': ['Alice', 'Bob', 'Charlie'],
    'Age': [25, 30, 35],
    'City': ['New York', 'Los Angeles', 'Chicago']
}
df = pd.DataFrame(data)
print(df)
```

如果不同列的元素个数不一致，会抛出 `ValueError`。

### 访问列

#### 列名

可以用列名访问`DataFrame`的列，类似 python 字典，如：

```py
In [4]: df["Age"]
Out[4]:
0    22
1    35
2    58
Name: Age, dtype: int64
```

#### iloc

iloc 方法可以直接通过数字索引和切片来调用`DataFrame`的任意行和列。

如`df[1, 2]`代表取出`df`的第二行，第三列，`df[:4, 1:]`代表取出`df`的前四行，从第二列开始的所有列。

## Series

`Series`就像前文所述，基本就是表格的一列，我们可以通过 python 列表来创建，并给它一个名字。

```py
In [5]: ages = pd.Series([22, 35, 58], name="Age")

In [6]: ages
Out[6]:
0    22
1    35
2    58
Name: Age, dtype: int64
```

# 如何读写表格数据

<img src="https://gitee.com/dwd1201/image/raw/master/202409261706154.png"/>

如下图所示，pandas 支持多种文件格式和数据源，读取使用`read_*`，写入使用`to_*`（`*`代表支持的文件格式，如 csv，html 等）

比如我们读一个 csv 文件，并检查一下读入的数据：

```py
In [2]: titanic = pd.read_csv("data/titanic.csv")
In [3]: titanic
Out[3]:
     PassengerId  Survived  Pclass  ...     Fare Cabin  Embarked
0              1         0       3  ...   7.2500   NaN         S
1              2         1       1  ...  71.2833   C85         C
2              3         1       3  ...   7.9250   NaN         S
3              4         1       1  ...  53.1000  C123         S
4              5         0       3  ...   8.0500   NaN         S
..           ...       ...     ...  ...      ...   ...       ...
886          887         0       2  ...  13.0000   NaN         S
887          888         1       1  ...  30.0000   B42         S
888          889         0       3  ...  23.4500   NaN         S
889          890         1       1  ...  30.0000  C148         C
890          891         0       3  ...   7.7500   NaN         Q

[891 rows x 12 columns]
```

比如从 excel 中读取（即`.xlsx`文件）。由于`.xlsx`文件可能包含多个表格，因此需要指定表格名字`sheet_name`。

```py
In [7]: titanic = pd.read_excel("titanic.xlsx", sheet_name="passengers")
In [8]: titanic.head()
Out[8]:
   PassengerId  Survived  Pclass  ...     Fare Cabin  Embarked
0            1         0       3  ...   7.2500   NaN         S
1            2         1       1  ...  71.2833   C85         C
2            3         1       3  ...   7.9250   NaN         S
3            4         1       1  ...  53.1000  C123         S
4            5         0       3  ...   8.0500   NaN         S

[5 rows x 12 columns]
```

写入`.xlsx`也同样需要指定`sheet_name`，默认为`Sheet1`。

```py
In [6]: titanic.to_excel("titanic.xlsx", sheet_name="passengers", index=False)
```

## 检查表格

我们可以通过`head()`方法来看表格的前几条数据，用`tail()`方法来看后几条数据。

```py
In [4]: titanic.head(8)
Out[4]:
   PassengerId  Survived  Pclass  ...     Fare Cabin  Embarked
0            1         0       3  ...   7.2500   NaN         S
1            2         1       1  ...  71.2833   C85         C
2            3         1       3  ...   7.9250   NaN         S
3            4         1       1  ...  53.1000  C123         S
4            5         0       3  ...   8.0500   NaN         S
5            6         0       3  ...   8.4583   NaN         Q
6            7         0       1  ...  51.8625   E46         S
7            8         0       3  ...  21.0750   NaN         S

[8 rows x 12 columns]
```

可以用`dtypes`属性来查看每一列的数据类型。

```py
In [5]: titanic.dtypes
Out[5]:
PassengerId      int64
Survived         int64
Pclass           int64
Name            object
Sex             object
Age            float64
SibSp            int64
Parch            int64
Ticket          object
Fare           float64
Cabin           object
Embarked        object
dtype: object
```

用`info()`方法，可以查看表格的技术总结。包括表格类型，行数，列数，每列的非零条目数，数据类型，以及表格占用的内存。

```py
In [9]: titanic.info()
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 891 entries, 0 to 890
Data columns (total 12 columns):
 #   Column       Non-Null Count  Dtype
---  ------       --------------  -----
 0   PassengerId  891 non-null    int64
 1   Survived     891 non-null    int64
 2   Pclass       891 non-null    int64
 3   Name         891 non-null    object
 4   Sex          891 non-null    object
 5   Age          714 non-null    float64
 6   SibSp        891 non-null    int64
 7   Parch        891 non-null    int64
 8   Ticket       891 non-null    object
 9   Fare         891 non-null    float64
 10  Cabin        204 non-null    object
 11  Embarked     889 non-null    object
dtypes: float64(2), int64(5), object(5)
memory usage: 83.7+ KB
```

可以用`describe()`方法查看均值，最大值，等属性。
