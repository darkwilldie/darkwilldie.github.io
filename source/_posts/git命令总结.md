---
title: git命令总结
date: 2026-01-08 11:43:09
tags: git
categories: tools
---
<!-- toc -->

# 0. 总结什么？
`clone, add, commit, pull, push`这些基础就不赘述了。

本文主要总结的是`merge/rebase（合并/变基）, reset/revert（重置/撤销）, stash（暂存）, PR/git flow（提交流程），cherry-pick, reflog`这些进阶用法，不仅可以提高开发效率，一些操作更是团队协作开发所必须了解的。

具体内容可以复习这篇[Gemini问答](https://gemini.google.com/share/d75643b0a66e)

> 关于GitHub的远程ssh连接怎么配置，参考{% post_link github推送报错解决 %}的`SSH 密钥`一节

这是一个整理好的 Git 进阶实战手册，涵盖了从获取代码、团队协作到灾难恢复的全流程。

# Git 进阶实战手册：从协作到救灾

本手册旨在解决团队开发中常见的疑惑，特别是容易混淆的概念（如 Merge/Rebase, Reset/Revert）以及高频实战场景。

---

## 1. 入门：获取代码的方式
在开始开发前，需要明确你与目标仓库的关系。

### 核心概念对比

| 方式             | 描述                                  | 适用场景                                         |
| :--------------- | :------------------------------------ | :----------------------------------------------- |
| **Download ZIP** | 纯文件下载，无版本历史，无法更新。    | 仅用于**阅读**代码或一次性运行。                 |
| **Git Clone**    | 下载完整仓库（含历史），可直接 Push。 | **你有权限**的仓库（如公司内部项目、个人项目）。 |
| **Fork**         | 在云端复制一份镜像到你的账号下。      | **开源项目**或**你无写入权限**的大型项目。       |

### 场景演示
* **场景 1：开源贡献**
    1.  在 GitHub 网页上点击 **Fork**。
    2.  `git clone https://github.com/YOUR_NAME/repo.git` (克隆你 Fork 的仓库)。
* **场景 2：公司内部开发**
    1.  直接 `git clone https://github.com/COMPANY/repo.git`。

---

## 2. 协作：Pull Request (PR) 与同步
PR 是代码审查和合并的标准化流程。

### 标准工作流
1.  **新建分支**：`git checkout -b feature/login` (永远不要直接在 main 改代码)。
2.  **提交修改**：`git commit -m "Add login page"`。
3.  **推送分支**：`git push origin feature/login`。
4.  **发起 PR**：在 GitHub 页面点击 "Compare & pull request"，请求合并进 `main` 或 `develop`。

### 进阶：同步上游代码 (Sync Fork)
当你 Fork 了项目，原作者更新了代码，你需要手动同步。

```bash
# 1. 配置上游仓库 (仅需一次)
git remote add upstream [https://github.com/original-owner/repo.git](https://github.com/original-owner/repo.git)

# 2. 拉取上游更新
git fetch upstream

# 3. 合并到本地主分支
git checkout main
git merge upstream/main
```

---

## 3. 合并策略：Merge vs Rebase

这两个命令都用于整合代码，但对待“历史”的态度完全不同。

### 对比解析

| 特性          | **Merge (合并)**                     | **Rebase (变基)**                            |
| ------------- | ------------------------------------ | -------------------------------------------- |
| **历史形态**  | **真实**。保留分叉和汇合的网状结构。 | **整洁**。重写历史，变成一条直线。           |
| **Commit ID** | 保留原 ID，生成新的 Merge Commit。   | **修改**原 ID (原来的提交被废弃，生成新的)。 |
| **黄金法则**  | 公共分支合并必用。                   | **严禁在公共分支使用**，仅限个人私有分支。   |

### 场景演示

#### 场景 1：合并功能到主干 (使用 Merge)

**背景**：`feature` 开发完成，要合入 `develop` 供团队测试。
**操作**：

```bash
git checkout develop
# --no-ff 强制生成合并节点，在历史中留下痕迹
git merge --no-ff feature/xxx
```

#### 场景 2：同步主干代码到个人分支 (使用 Rebase)

**背景**：你在 `feature` 分支开发，同事向 `main` 推送了新代码。你想跟进更新，但不想产生无意义的 Merge 节点。
**操作**：

```bash
git checkout feature/xxx
git rebase main
# 此时你的提交会被“搬运”到 main 的最新提交之后
```

#### 场景 3：想 pick 或 drop 特定 commit

用交互式rebase

```bash
git rebase -i HEAD~n 
```
`rebase`到想drop的提交的前一个提交，比如drop倒数第二个提交时要到倒数第三个提交，此时n=2

命令输入后会弹出一个编辑窗口（比如vim），里面会显示你选择范围内的所有提交，默认是pick状态（保留）

```
pick 1a2b2d
pick 2e3f4g
pick 3h4i5j # 不需要该提交的代码的话就把pick改成drop!
```

---

## 4. 撤销机制：Reset vs Revert

“我写错了”或者“我不想要了”，根据代码是否已推送到远程，选择不同的药方。

如果遇到冲突不想修了，用`git reset --merge`

### 对比解析

| 特性       | **Reset (重置)**                 | **Revert (撤销)**                            |
| ---------- | -------------------------------- | -------------------------------------------- |
| **行为**   | **时光倒流**。物理删除提交记录。 | **以退为进**。新增一个“反向”提交来抵消错误。 |
| **适用性** | **本地代码** (未 Push)。         | **远程代码** (已 Push)。                     |
| **安全性** | 危险 (修改历史)。                | 安全 (保留历史)。                            |

### 场景演示

#### 场景 1：本地提交后悔了 (使用 Reset)

**背景**：刚 Commit 完，发现代码逻辑全是错的，或者不想提交了。代码还在本地。
**操作**：

```bash
# 彻底回退到上一个版本（丢弃修改）
git reset --hard HEAD^

# 或者：只撤销 Commit 动作，保留代码在暂存区（用于重新修改）
git reset --soft HEAD^
```

#### 场景 2：线上代码出 Bug (使用 Revert)

**背景**：昨天的提交 `a1b2c3d` 导致生产环境崩溃，必须马上回滚。
**操作**：

```bash
# 生成一个新的提交，内容是删除 a1b2c3d 的修改
git revert a1b2c3d
git push origin main
```

---

## 5. 临时储物柜：Git Stash

不想提交半成品，但又必须切换分支时使用。

如果遇到冲突不想修了，想撤销本次pop，用`git reset --merge`（有没有觉得眼熟，眼熟就对了），此时stash还在堆栈不会丢。

### 场景演示

#### 场景 1：突发 Bug 修复

**背景**：正在 `feature` 分支写代码，老板要求立刻修一个 `hotfix`。
**操作**：

```bash
# 1. 将当前工作现场（含未追踪文件）存入堆栈
git stash -u

# 2. 切换分支去修 Bug
git checkout main
# ... fix bug ...

# 3. 回到原来的分支，恢复现场
git checkout feature
git stash pop
```

#### 场景 2：同步拉取避免冲突

**背景**：`git pull` 时提示本地有修改，无法拉取。
**操作**：

```bash
git stash       # 暂存
git pull        # 拉取
git stash pop   # 还原（如有冲突需手动解决）
```

---

## 6. 精准拣选：Cherry-pick

不需要合并整个分支，只想要某个特定的 Commit。

### 场景演示

#### 场景 1：紧急修复补丁

**背景**：在 `develop` 分支修了一个 Bug (Commit: `e5f6g7`)，`main` 分支也急需这个修复，但不能把 `develop` 上其他未测试的功能合过去。
**操作**：

```bash
git checkout main
git cherry-pick e5f6g7
# 此时 main 分支单独应用了该 Bug 修复
```

---

## 7. 终极救援：Reflog

Git 的黑匣子，只要你不删 `.git` 目录，它就能救你。

### 场景演示

#### 场景 1：误删分支或 Reset 过头

**背景**：手滑执行了 `git reset --hard`，导致几天的工作全丢了，`git log` 里也查不到记录。
**操作**：

```bash
# 1. 查看操作日志（包含被删除的记录）
git reflog
# 输出示例：
# e4b2f1 HEAD@{0}: reset: moving to HEAD~1
# 9a8b7c HEAD@{1}: commit: 完成了关键功能 <-- 找到这个丢失的 ID

# 2. 复活代码（将指针指回丢失的 ID）
git reset --hard 9a8b7c
# 或者直接基于该 ID 重建分支（更安全）
git checkout -b recover-branch 9a8b7c
```

