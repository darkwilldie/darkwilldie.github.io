---
title: 基于.NET的投票系统开发
date: 2026-03-30 09:52:17
tags:
  - .net
  - C#
categories: development
---
<!-- toc -->

综合考虑太久没写的JS，环境都配不明白的java，最后还是选择了.NET开发，用ASP.NET做熟悉的网页开发，前端用blazor。不过再想想，投票系统本来就是web应用比桌面应用更合适。

但我的.NET开发仍然说不上有什么基础，只能边学边开发，把学习过程遇到的问题/解决和知识点记在这里。

# 问题和解决
## 问题
### 前端相关
1. 无法从前端传值（前端输入提交后对应的值仍为空）

    没有开启交互式渲染。在该razor页面加上`@rendermode InteractiveServer`

2. 什么时候该用`@`
    string类型要加`@`，其他类型不加

    一般是用到内存中的对象就要用，比如`Model="@_model"`，但如果本来就是外来的属性，不加`@`才是最佳实践，比如`@bind-Value="_model.Username"`。

3. 循环问题

    for循环的i在每轮里要存一个临时变量，不然在循环内判断的时候i已经变成循环停止时的i了

4. 点击form表单内的button触发了提交

    没写 type="button"，HTML 默认会把按钮当成提交按钮。

# 知识点
## 1. 属性的写法
```csharp
public DbSet<User> Users => Set<User>();
```
关于这种写法，首先`DbSet<T>`是一个泛型的操作工具箱，而`DbContext.Set<T>`是一个继承自`DbContext`基类的一个方法，返回值是`DbSet<T>`类型。可以通过`Set<T>`取到该“工具箱”。

它是一种最佳实践的语法糖，完全等价于传统方法：

```csharp
public DbSet<User> Users = {
    get {
        return Set<User>();
    }
}
```

`get`在这里是它的构造函数，如果没有，会有一个提示说它没有构造函数赋值，属性可能为空（null）。因此诞生了另一种镇压提示的暴力的写法——手动保证对象不为空。

```csharp
public DbSet<User> Users = { get; set; } = null!
```

应用启动时EF Core会在底层调用 Set<User>() 把值塞给它们。所以运行时它绝对不会是 null。

那么这种写法对比最开始的`=>`写法有什么不同呢？

首先我们需要区分一下属性和字段。

在 C# 中，属性（Property，就是带 get/set 的东西）本质上只是两个方法（动作），它自己是不能保存数据的。真正能把数据存在内存里的，只有字段（Field，也就是普通变量）。

1. `=>`语法仅仅是一个动作，而`{get;set;}`语法会生成一个**隐式的私有字段**`<T>k__BackingField`（可以当成储存值的私有内部仓库），前者内存占用更优
2. `=>`启动时直接执行动作，而`{get;set;}`是通过EF Core的反射机制强行塞值，前者启动性能更优
3. `=>`比手动保证的`null!`好看，更优雅

总结：用`DbSet<T> X => Set<T>()`就完了。

## 2. 渲染模式

.net中遇到的传值传不进去/不更新，大概率是没有设置渲染模式为`@rendermode InteractiveServer`。默认为Static SSR，只会在初始化的时候渲染一次不会更新。

## 3. JWT(JSON Web Token)

手动控制鉴权，可以控制过期时间。

## 4. CancellationToken

CancellationToken（取消令牌）是 .NET 中一种标准的协作式取消机制。

1. 它是什么？
CancellationToken 是一个结构体，通常与 CancellationTokenSource 配套使用：

CancellationTokenSource (CTS): 信号发射器。由它来决定“何时取消”。

CancellationToken (Token): 信号接收器。它被传递给异步任务，任务内部不断检查它是否已被取消。

2. 什么时候需要它？

    - A. 用户刷单/重复操作（前端场景）
    用户连续点击了 10 次“投票”按钮。如果不做处理，后端可能会开启 10 个线程去跑逻辑。

    解决方案： 当第 2 次点击发生时，取消第 1 次的请求，节省服务器资源。

    - B. 用户关闭网页（后端 API 场景）
    用户发起了一个耗时 5 秒的统计请求，但在第 2 秒时直接关掉了浏览器。

    如果不使用： 服务器会傻傻地继续跑完剩下的 3 秒逻辑，甚至把数据写入数据库。

    如果使用： ASP.NET Core 会自动向你的 Controller 传递一个 CancellationToken。一旦用户断开连接，Token 就会变红，你可以立即停止数据库查询。

    - C. 超时强制停止
    某些操作（如调用第三方支付接口）不能无限期等待。

    解决方案： 设置一个 30 秒自动取消的 Token，防止程序卡死。

## sealed record

sealed封口不能继承，record创建后不能改变，可以用`=`比较不同record对象的值是否相等。

# 问题

- [x] 为什么_user.可以调用repository方法
   实际上是repository对象，为了不混淆改为_repo了
- [ ] payload是什么
- [x] `response.Content.ReadFromJsonAsync<LoginResponse>(cancellationToken: ct)`做了什么
    从body读出LoginResponse
- [ ] 为什么又username和userid两个字段
- [ ] ct在哪里发挥过作用
- [x] ApiException是不是可以内置LogLevel属性？
   ErrorResponse内置了，LogLevel要和message level分开
- [x] ErrorResponse只有message是不是可以不需要，添加别的属性或者直接删掉？
   现在有message type和ID了
- [ ] DDL可以通过EF Core命令打印出来，需要查看是否要改命名、类型长度
- [ ] 要不要加一个改密码的页面
- [x] !刷新就会返回login页面
- [ ] 测试还没做！！
- [ ] ViewModel改为Model或者把页面逻辑移动过去
- [ ] VotingApiClient现在在Blazor服务层，要不要拆分成多个Service
- [ ] bug多个相同选项报错是"少なくとも2つの選択肢が必要です。"
- [ ] chrome密码每次有弹窗提示没加密？

