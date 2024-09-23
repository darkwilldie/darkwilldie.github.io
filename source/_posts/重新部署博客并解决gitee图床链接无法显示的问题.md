---
title: 重新部署博客并解决gitee图床链接无法显示的问题
date: 2024-09-15 11:16:02
tags:
  - debug
  - blog
  - image
categories: environment
---

<meta name="referrer" content="no-referrer" />

~~说实话我也不知道算不算解决了，但部署上去好像能显示。~~
<img src="https://gitee.com/dwd1201/image/raw/master/202409120811764.jpg" height=200 width=300/>

# 重新部署博客

## 起因

更新：我搞错了，之前上传的不是`public/`目录，而是`.deploy_git`，这是完全没问题的一键部署，不过换都换了就这样吧，更换部署方式虽然麻烦一些（需要手动`git add`,`git commit`和`git push`），但好处是可以自己写提交 messege，并且上传的博客内容是纯文本。

~~我重新部署了项目，之前在远程仓库上传的是`public/`目录，因为主目录有.gitignore 文件，并且里面确实有`public/`，我认为这表明`public/`目录不该被提交到远程仓库。~~

## 部署步骤

参考[在 GitHub Pages 上部署 Hexo](https://hexo.io/zh-cn/docs/github-pages)，重新将主目录提交之后，按照指示操作，最后用`hexo d`进行部署。步骤总结为：

1. 建立名为 username.github.io 的储存库。 若之前已将 Hexo 上传至其他储存库，将该储存库重命名即可。
2. 将 Hexo 文件夹中的文件 push 到储存库的默认分支。 默认分支通常名为 main，旧一点的储存库可能名为 master。默认情况下`public/`不会被上传(也不该被上传)，确保 .gitignore 文件中包含一行`public/`。 整体文件夹结构应该与[示例储存库](https://github.com/hexojs/hexo-starter)大致相似。`git push -u origin main`
3. 使用 node --version 指令检查你电脑上的 Node.js 版本。 记下主要版本（例如，v20.y.z）
4. 在**储存库**中前往`Settings > Pages > Source`（注意是**仓库**的 Settings，而非个人！）。 将 source 更改为 GitHub Actions，然后保存。
5. 在储存库中建立`.github/workflows/pages.yml`，并填入以下内容 (将`node version`中的 20 替换为上个步骤中记下的版本,去掉字母`v`)：

   ```yml .github/workflows/pages.yml
    name: Pages

    on:
    push:
        branches:
        - main # default branch

    jobs:
    build:
        runs-on: ubuntu-latest
        steps:
        - uses: actions/checkout@v4
            with:
            token: ${{ secrets.GITHUB_TOKEN }}
            # If your repository depends on submodule, please see: https://github.com/actions/checkout
            submodules: recursive
        - name: Use Node.js 20
            uses: actions/setup-node@v4
            with:
            # Examples: 20, 18.19, >=16.20.2, lts/Iron, lts/Hydrogen, *, latest, current, node
            # Ref: https://github.com/actions/setup-node#supported-version-syntax
            # You should replace 20 with your own node version
            node-version: "20"
        - name: Cache NPM dependencies
            uses: actions/cache@v4
            with:
            path: node_modules
            key: ${{ runner.OS }}-npm-cache
            restore-keys: |
                ${{ runner.OS }}-npm-cache
        - name: Install Dependencies
            run: npm install
        - name: Build
            run: npm run build
        - name: Upload Pages artifact
            uses: actions/upload-pages-artifact@v3
            with:
            path: ./public
    deploy:
        needs: build
        permissions:
        pages: write
        id-token: write
        environment:
        name: github-pages
        url: ${{ steps.deployment.outputs.page_url }}
        runs-on: ubuntu-latest
        steps:
        - name: Deploy to GitHub Pages
            id: deployment
            uses: actions/deploy-pages@v4
   ```

## 一键部署

一键部署，也就是原来的部署方式也记录一下。参考[这篇博文](https://gist.github.com/btfak/18938572f5df000ebe06fbd1872e4e39)，主要就是在`_config.yml`里添加以下内容：

```yml _config.yml
~~~~~~~~~~~~~~~~~~ _config.yml ~~~~~~~~~~~~~~~~~~
# Deployment
## Docs: http://hexo.io/docs/deployment.html
deploy:
  type: git
  repo: git@github.com:username/username.github.io.git
  branch: main
```

用 ssh 连接，因此 repo 连接是`git@github.com:<username>/<repo-name>`的格式，较新的仓库默认分支一般是 main，比较旧的可能是 master。

# 图床链接问题

重新部署导致了一个新问题，部署上去的项目目录不包含`public/`，也就不包含`public/img`，于是我的头像在部署之后失效了！

失效之后很容易想到的解决办法是用图片的网络链接，这也是图床的用处所在。

但是！我这个博客之前无论是本地预览还是部署到 github pages 都无法显示 gitee 链接的图片，因此我又重新着手解决 gitee 图床链接无法显示的问题。参考了其他博客都没有解决问题，最后参考[解决 hexo 博客不能显示图床图片问题](https://cuiyuhao.com/posts/9d5b9135/)，在文章前面加上`<meta name="referrer" content="no-referrer" />`，成功解决了问题。

同时头像也能正确显示了，有一说一我其实没有想通这一点，按理说文章内部加一行 html 标签应该不会影响到头像显示吧……但就是莫名其妙好了，能正常显示 gitee 图片链接了，那就算解决了吧！
