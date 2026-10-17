# 博客源码工程（Hexo 6.3 + Matery 主题）

线上站点：<https://bubber2018.github.io/>
本目录是**源码**，`public/` 是生成结果（不提交）。

分支约定（同一个仓库 `bubber2018/bubber2018.github.io`）：

| 分支 | 内容 | 谁写 |
|---|---|---|
| `main` | 本目录的源码（Hexo 工程） | 手动 commit / push |
| `master` | 生成出来的静态站点，GitHub Pages 从这里发布 | `hexo deploy` 自动推 |

> 注意：Hexo 在**零文章**时不会生成首页与归档页（首页会 404）。
> 所以 `source/_posts/start.md` 是一篇占位文章，写下第一篇后删掉它再生成即可。

## 写一篇文章

```powershell
# 1. 新建（自动带 front-matter）
npx hexo new post "文章标题"

# 2. 用编辑器打开 source/_posts/文章标题.md，写 Markdown 正文

# 3. 本地预览（改完保存会自动刷新）
npx hexo server          # 打开 http://localhost:4000

# 4. 发布（生成 + 推送到仓库 master 分支）
npx hexo clean; npx hexo generate; npx hexo deploy

# 5. 提交源码（main 分支）
git add -A; git commit -m "新文章：我的第一篇"; git push origin main
```

`npx hexo deploy` 会把 `public/` 推到 `bubber2018/bubber2018.github.io` 的 `master` 分支，
GitHub Pages 随后自动更新。首次部署需要 Git 凭据（凭证管理器会弹一次授权）。

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
