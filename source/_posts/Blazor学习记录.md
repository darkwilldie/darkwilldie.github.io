---
title: Blazor/.net Web API 学习记录
date: 2026-01-06 16:42:38
tags: 
 - Blazor
 - .net
categories: coding
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

# 2. 添加 Controller
## 注册服务和添加中间件

要加`Controller`需要在`Program.cs`里注册对应的服务，并加上中间件。此时该文件就变为：

```cs
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers(); // 注册服务

var app = builder.Build();
app.MapControllers(); // 添加中间件

app.MapGet("/", () => "Hello World!");
app.Run();
```

## 创建 Controller
接下来创建一个`Controllers/`目录，右键追加一个コントローラー`TestController.cs`。

> 实测这个目录和命名空间的名称改动对程序运行都没有影响，

```cs 
using Microsoft.AspNetCore.Mvc;

namespace BlazorPOC.Controllers {

    [Route("api/[Controller]")]
    [ApiController]
    public class TestController : ControllerBase { // 如果需要返回View（MVC架构）则继承Controller
        [HttpGet]
        public IActionResult Get() {
            return Ok(new string[] { "Hello", "This is a ", "Test" });
        }
    }
}
```

可以看到在**类**和**方法**上都写了带有方括号的**属性(Attribute)**，这里的公开、非静态方法称为`Action`，是外部网络请求（http request）能直接访问到的方法。

那么来讲解这些特性的作用吧。

1. `[ApiController]`：**API 专属增强补丁** 或者 **严格模式开关**
    - **自动参数绑定（Smart Binding）**：不用写`[frombody]`，自动简单类型从url找，复杂对象从body找
    - **自动模型验证（Automatic HTTP 400）**：进入方法前自动检查数据合法性，不合法返回`400 Bad Request`
    - **强制属性路由**：必须指定`[Route("...")]`，保证API路径清晰规范
2. `[Route("api/[Controller]")]`：指定路径，`[Controller]`表示从类名中去掉该后缀，则路径为`/api/test`
3. `[HttpGet]`：表示 **Http Get** 方法调用该Action（方法），如果不加则所有 **HTTP** 方法都调用该方法，实际上还是能访问

# 3. 构建 Blazor Server
## 经典模式

我们先构建一个.NET 6/7 (经典 Blazor Server) 风格的架构，这个架构的主页面是一个`Razor Page`，在该页面内调用`Razor Components`。

这种模式用全局 `WebSocket` 建立一个长连接，Blazor Server会计算界面差异，通过 `WebSocket` 发回给浏览器更新DOM，从而达到单页应用（SPA）的效果。

## NET 8 现代模式做法

`.AddRazorComponents()` 服务启用现代模式，新的`.razor`文件已经可以渲染html标签，因此不再需要`Razor Page`（`.cshtml`）作为启动器了。

而且 `WebSocket` 长连接也有了效率更高的替代品，注册 `.AddInteractiveServerComponents()`，.NET 8的默认是**静态的**(SSR - Server Side Rendering)，只有明确给某组件加上 `@rendermode InteractiveServer` 才会建立长连接。

现代模式如何构建我们后面再谈。

## 注册服务

```cs
// 之前注册的Web API控制器服务（不含View）
builder.Services.AddControllers();
// 注册 Razor Pages 服务。
// Blazor Server 虽然是 SPA，但它的入口通常是一个名为 _Host.cshtml 的 Razor Page。
builder.Services.AddRazorPages();
// 注册 Blazor Server 模式的核心服务。
// 包含维护 SignalR 电路 (Circuit)、DOM 差量更新算法等逻辑。
builder.Services.ServerSideBlazor();
```

新增了 `Razor Pages` 支持，注册 Blazor Server 模式。

## 添加中间件
```cs
// 2. 配置请求管道 (Middleware)
// 开启静态文件支持。
// 如果不加这行，浏览器请求 wwwroot 下的 style.css 或 logo.png 会报 404
app.UseStaticFiles();
// 路由中间件作用是“读懂”URL，决定将请求分发给 API、Blazor 还是 Razor Page。
app.UseRouting();
// 之前添加的映射控制器端点。
// 让系统知道：“如果有匹配 [Route] 规则的请求，交给 Controller 处理”。
app.MapControllers();
// 映射 Blazor 的 SignalR 枢纽 (Hub)。
// 这是 Blazor Server 的命脉，建立浏览器和服务器之间的 WebSocket 长连接。
app.MapBlazorHub();
// 配置 SPA (单页应用) 的“保底”路由。
// 意思：如果 URL 不是 API，也不是静态文件，也没匹配到别的，
// 那就统统把 "_Host" 页面返回给用户（从而启动 Blazor 客户端路由）。
app.MapFallBackToPage("_Host");
```

1. 开启静态文件支持
2. 开启路由
3. 映射控制器（`[Route]`规则）
4. 开启 Blazor Hub 长连接
5. 强制返回默认路由