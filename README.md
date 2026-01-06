# Hexo 博客维护指南

这份文档记录了本博客项目的环境搭建、日常写作及部署发布的常用命令。

## 🛠️ 1. 环境准备 (首次使用或换电脑)

如果在一个新的环境中（或重装系统后），需要先安装基础工具：

### 1.1 安装 Node.js & Git
确保系统已安装：
- **Node.js**: [下载地址](https://nodejs.org/) (建议使用 LTS 版本)
- **Git**: [下载地址](https://git-scm.com/)

### 1.2 安装 Hexo 全局脚手架
这是为了能使用 `hexo` 命令：
```bash
npm install -g hexo-cli

```

*Mac 用户如果报错权限不足，请加上 `sudo`。*

---

## 📦 2. 项目初始化 (重新接手项目)

当你从 Git 仓库拉取代码，或打开很久没用的本地目录时，**必须**执行此步骤来安装插件和依赖：

```bash
# 进入项目根目录
cd your-blog-folder

# 安装 package.json 中记录的所有依赖
npm install

```

> **注意**：如果安装报错，可能是 Node 版本太新导致不兼容旧插件。建议使用 `nvm` 切换到 Node v14 或 v16。

---

## ✍️ 3. 日常写作命令

### 新建文章

```bash
hexo new "文章标题"
# 简写: hexo n "文章标题"

```

执行后会在 `source/_posts/` 目录下生成对应的 `.md` 文件。

### 本地预览 (调试)

写完文章后，在本地查看效果：

```bash
# 1. 清除缓存 (建议每次都做，防止样式不更新)
hexo clean

# 2. 生成静态页面
hexo generate  # 简写: hexo g

# 3. 启动本地服务器
hexo server    # 简写: hexo s

```

启动后访问：`http://localhost:4000`

---

## 🚀 4. 部署发布

确认本地预览无误后，推送到远程仓库 (GitHub/Vercel 等)：

```bash
hexo deploy
# 简写: hexo d

```

### ⚡ 推荐：发布三连招

为了防止缓存导致的问题，建议养成使用组合命令的习惯：

```bash
hexo clean && hexo g && hexo d

```

*(解释：清除旧文件 -> 生成新文件 -> 部署上线)*

---

## 🌐 5. 域名绑定 (CNAME)

如果要绑定自定义域名（如 `www.example.com`）：

1. 确保在 `source/` 目录下有一个名为 `CNAME` 的文件（无后缀）。
2. 文件内容仅包含一行域名，例如：
```text
[www.example.com](https://www.example.com)

```


3. 执行部署命令，Hexo 会自动将其复制到发布目录。

---

## ❓ 常见问题排查

* **`hexo: command not found`**:
说明全局工具丢失，请重新执行 `npm install -g hexo-cli`。
* **`Deployer not found: git`**:
说明缺少 Git 部署插件，请执行 `npm install hexo-deployer-git --save`。
* **页面空白或样式错乱**:
通常是缓存问题，请务必执行 `hexo clean` 后再重新生成。