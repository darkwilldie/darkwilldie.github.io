---
title: dotnet命令行指令
date: 2026-01-07 13:55:45
tags: .net
categories: coding
---
<!-- toc -->
# 0. 分清目录

项目目录树通常如下所示：

```
...\source\repos\BlazorApp\              <-- 解决方案目录
│
├── BlazorApp.sln                        <-- 解决方案文件 (dotnet build 能识别这个)
│
└── BlazorApp\                           <-- 项目文件夹 (真正的代码在这里)
    ├── BlazorApp.csproj                 <-- 项目文件 (dotnet run 需要这个)
    ├── Program.cs
    └── ...
```

记住这里的**解决方案目录**和**项目目录**两个同名目录~~，等会要考~~。
# 1. 编译/生成(build)： 

`dotnet build`

因为只是编译所有文件，在两层同名目录下都可以运行。

# 2. 启动

`dotnet run`

必须在 **项目目录** 下执行，要不然会找不到 `.csproj` 而报错，~~这也太蠢了~~。

`dotnet run --project ./BlazorApp/BlazorApp.csproj`

也可以用 `--project` 来指定项目文件路径。

## 用特定配置启动
### 指定配置

`dotnet run -lp "https"`

用 `--launch-profile` 或简写 `-lp` 后指定 `Properties/launchSettings.json` 中的配置key。

不指定的话默认会读取第一个定义为 `"commandName": "Project"` 的配置。

### 无配置文件启动

`dotnet run --no-launch-profile`

不读取配置文件启动。

## 热重载(Hot Reload)

`dotnet watch run`

用这个命令启动时，改动了文件（注意要保存）后会自动应用更改或重新编译并重启。在开发中**非常常用**。

# 3. 清理

`dotnet clean`

会删掉 `bin` 和 `obj` 目录

# 4. 发布

`dotnet publish -c Release -o ./publish`

- `-c Release`：表示以“发布模式”编译（会进行代码优化，去除调试信息，速度更快）。
- `-o ./publish`：指定路径。

# 5. 调试

CLI干不了这事，得用VS或者VSCode。不过可以先用`dotnet run`然后`调试 -> 附加到进程`把调试器挂载到该进程 ~~（好像没什么用）~~。