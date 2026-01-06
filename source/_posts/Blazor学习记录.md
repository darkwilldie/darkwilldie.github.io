---
title: Blazor/.net Web API 学习记录
date: 2026-01-06 16:42:38
tags:
categories:
---
<!-- toc -->

# What, Why, How
- What: Blazor是一种基于.net框架，允许开发者使用C#和Razor语法来构建交互式、高性能的客户端和服务端Web UI的开源框架。使用 Blazor 和 Web API 是构建全栈 .NET 应用的现代经典组合，它能让你用 C# 同时搞定前端和后端。
- Why: 简单来说公司现在的项目要用，复杂来说我的目标是web全栈，我也想学。
- How: 用Gemini的学习辅导模式从头构建一个最小概念验证（POC），用VS跟着敲跟着运行

# 1. 从ASP.NET Core（空）开始
环境配置没什么好说的，Visual Studio勾选.net相关的配置安装就行。

首先创建一个ASP.NET Core（空）项目，会发现里面除了配置文件，就只有一个`Program.cs`~~（总算能看懂了）~~。

配置文件中`appsettings.json`负责存储DB连接字符串、日志级别、允许的Hosts等杂项，`Properties/launchSettings`则负责管理启动配置，如http/https分别用什么端口。

`Program.cs`长这样：
```cs Program.cs
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hello World!");

app.Run();
```

其中，builder注册服务，app管理中间件以及顺序（这些函数名字都长得要死，真不知道怎么记）。

倒数第二句给`"/"`定义了`Get`方法，直接运行项目可以在浏览器看到输出的`Hello World!`。

# 2. 加一个Controller
要加`Controller`需要在`Program.cs`里注册对应的服务，并加上中间件。此时该文件就变为：

```cs
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers(); // 注册服务

var app = builder.Build();
app.MapControllers(); // 添加中间件

app.MapGet("/", () => "Hello World!");
app.Run();
```

接下来创建一个`Controllers/`目录（实测这个目录和命名空间的名称改动对程序运行都没有影响），右键追加一个コントローラー`TestController.cs`。
