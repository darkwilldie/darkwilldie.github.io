# Hexo 博客维护指南

这份文档记录了本博客项目的环境搭建、日常写作及部署发布的常用命令。

## 🛠️ 1. 环境准备 (首次使用或换电脑)

如果在一个新的环境中（或重装系统后），需要先安装基础工具：

### 1.1 安装 Node.js & Git
确保系统已安装：
- **Node.js**: [下载地址](https://nodejs.org/) (建议使用 LTS 版本)
- **Git**: [下载地址](https://git-scm.com/)

### 1.2 启用 pnpm
```bash
corepack enable
corepack prepare pnpm@10.30.3 --activate
```

项目已迁移到 `pnpm`，后续依赖安装和脚本执行请统一使用 `pnpm`。

### 1.3 (可选) 安装 Hexo 全局脚手架
如果你习惯直接输入 `hexo` 命令，可以全局安装 `hexo-cli`：
```bash
pnpm add -g hexo-cli
# 如果提示全局命令不可用，先执行一次：
pnpm setup
```

安装后可直接使用：
```bash
hexo new "文章标题"
```

---

## 📦 2. 项目初始化 (重新接手项目)

当你从 Git 仓库拉取代码，或打开很久没用的本地目录时，**必须**执行此步骤来安装插件和依赖：

```bash
# 进入项目根目录
cd your-blog-folder

# 安装 package.json 中记录的所有依赖
pnpm install
```

> **注意**：如果安装报错，可能是 Node 版本太新导致不兼容旧插件。建议使用 `nvm` 切换到 Node v14 或 v16。

---

## ✍️ 3. 日常写作命令

### 新建文章

```bash
pnpm exec hexo new "文章标题"
# 简写: pnpm exec hexo n "文章标题"

```

如果已全局安装 `hexo-cli`，也可以直接使用 `hexo new "文章标题"`。

执行后会在 `source/_posts/` 目录下生成对应的 `.md` 文件。

### 本地预览 (调试)

写完文章后，在本地查看效果：

```bash
# 1. 清除缓存 (建议每次都做，防止样式不更新)
pnpm exec hexo clean

# 2. 生成静态页面
pnpm exec hexo generate  # 简写: pnpm exec hexo g

# 3. 启动本地服务器
pnpm exec hexo server    # 简写: pnpm exec hexo s

```

启动后访问：`http://localhost:4000`

---

## 🚀 4. 部署发布

确认本地预览无误后，推送到远程仓库 (GitHub/Vercel 等)：

```powershell
.\deploy.ps1    # 包含git commit，hexo clean 和 hexo deploy
```

---

## ❓ 常见问题排查

* **`hexo: command not found`**:
请改用 `pnpm exec hexo` 执行命令，或先运行 `pnpm add -g hexo-cli` 并执行 `pnpm setup` 后重开终端。
* **`Deployer not found: git`**:
说明缺少 Git 部署插件，请执行 `pnpm add hexo-deployer-git`。
* **页面空白或样式错乱**:
通常是缓存问题，请务必执行 `pnpm exec hexo clean` 后再重新生成。
