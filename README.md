# 博客源码工程（Hexo 6.3 + Matery 主题）

线上站点：<https://bubber2018.github.io/>
本目录是**源码**，`public/` 是生成结果（不提交）。

分支约定（同一个仓库 `bubber2018/bubber2018.github.io`）：

| 分支 | 内容 | 谁写 |
|---|---|---|
| `main` | 本目录的源码（Hexo 工程） | 你手动改 / 网页改 |
| `master` | 生成出来的静态站点，GitHub Pages 从这里发布 | GitHub Actions 自动推 |

> 发布机制：任何 push 到 `main` 都会触发 `.github/workflows/deploy.yml`，
> 由 GitHub 跑 `hexo generate` 并 force-push 到 `master`。本地不需要装环境。

> 注意：Hexo 在**零文章**时不会生成首页与归档页（首页会 404）。
> 所以 `source/_posts/start.md` 是一篇占位文章，写下第一篇后删掉它再生成即可。

## 写一篇文章

### 方式一：网页写（推荐，任何电脑都一样）

1. 打开 <https://github.com/bubber2018/bubber2018.github.io/tree/main/source/_posts>
2. 右上角 **Add file → Create new file**
3. 文件名写 `my-first-post.md`（英文或拼音，它会成为 URL 的一部分）
4. 内容粘贴：

   ```markdown
   ---
   title: 我的第一篇
   date: 2026-10-17 20:00:00
   tags: [随笔]
   categories: [生活]
   ---

   正文从这里开始，正常写 Markdown 就行。
   ```

5. 拉到底点 **Commit changes**（提交到 `main`）
6. 约 1 分钟后自动上线：<https://bubber2018.github.io/>

想要更像编辑器的体验：在仓库页面按 **`.`** 键会打开 `github.dev`（浏览器里的 VSCode），
可以新建文件、拖拽上传图片，然后同样 commit 到 `main`。

> 图片放 `source/medias/images/`，正文按 `/medias/images/文件名.jpg` 引用。

### 方式二：本地写

```powershell
.\new-post.ps1 "文章标题"    # 建文件并尝试用 VSCode 打开
# 写正文……
.\preview.ps1                # 本地预览 http://localhost:4000
.\publish.ps1                # 构建校验 + 提交并推送 main（触发自动发布）
```

对应的原始命令：

```powershell
npx hexo new post "文章标题"     # 新建
npx hexo server                  # 预览 :4000
npx hexo clean; npx hexo generate; git add -A; git commit -m "..."; git push origin main
```

> 不要再手动 `hexo deploy`：那会绕过 Actions 直接 force-push `master`，
> 和 Actions 的 force-orphan 提交历史互相覆盖（内容不会坏，但会多出无谓的强推）。
> 统一走「push main → Actions 发布」这一条路。

## Front-matter 字段

```yaml
---
title: 文章标题
date: 2026-10-17 19:41:07   # 不填也行
tags: [标签1, 标签2]
categories: [分类名]
cover: /medias/featureimages/1.jpg   # 可选，文章头图
description: 列表页显示的摘要        # 可选，不填自动截取正文
---
```

## 目录结构

```
_config.yml              站点配置（标题、网址、部署目标）
scaffolds/post.md        hexo new 时的模板
source/_posts/           文章（Markdown）
source/about|friends|   独立页面（front-matter 里 layout 指定模板）
source/medias/           图片素材（banner、头像、文章配图）
themes/matery/           主题（已按需改过配置，见下）
public/                  生成结果，勿手改
```

## 这个工程里做过的非默认改动

1. `package.json` 里必须有 `"hexo": { "version": "6.3.0" }`，
   否则 `hexo-cli` 不认为这是博客工程（只认 help/init/version 三个命令）。
2. 主题配置 `themes/matery/_config.yml`：关闭 dream / music / reward /
   myProjects / mySkills / myGallery / githubLink / busuanzi，
   清空 socialLink，删掉 Contact 菜单，`time.year` 改为 2022。
3. 主题模板 `themes/matery/layout/_partial/footer.ejs`：
   删掉第 13 行重复渲染的 `<span id="year">`，否则页脚会显示
   `2022-2026 2022 bubber`。这是主题自带 bug，升级主题时注意别被覆盖回去。
4. `highlight.enable: false` + `prismjs.enable: true`，跟原站代码高亮一致。

## 环境

- Node v24.21.0 / npm 11.19.0
- hexo 6.3.0（钉在 package.json）
- 依赖已装在 `node_modules/`（不入库）；换机后 `npm install` 即可

## 排障

- **`hexo deploy` 报 `unable to auto-detect email address`**：
  `hexo deploy` 在 `.deploy_git/` 里自己新建一个仓库，读不到本工程的 git 身份。
  修一次即可：`cd .deploy_git; git config user.name "bubber2018"; git config user.email "bubber@163.com"; cd ..`
- **首页 404 / 只有 favicon**：文章数为 0 时 Hexo 不生成首页和归档页。
  保留一篇占位文章即可（现在的 `source/_posts/start.md`）。
- **页脚年份重复**：`themes/matery/layout/_partial/footer.ejs` 里不要留两个
  `<span id="year">`。
