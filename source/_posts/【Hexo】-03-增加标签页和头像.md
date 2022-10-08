---
title: 【Hexo】-03-增加标签页和头像
date: 2022-01-12 23:03:26
tags:
  - hexo
  - 踩坑
categories:
  - 学习
---

今天，鼓捣一下，把页面的头像和标签页都加上了。

## 页面头像

头像主要是在next主题中的_config.yml（不是最外层的yml中）将以下的链接添加为自己的头像：

```yaml
# Sidebar Avatar
avatar:
  # Replace the default image and set the url here.
  url: /images/avatar.png #/images/avatar.gif
  # If true, the avatar will be displayed in circle.
  rounded: true
  # If true, the avatar will be rotated with the cursor.
  rotated: true
```

页面头像可以用插件：[頭像 照片 Avatar Maker - Chrome 网上应用店 (google.com)](https://chrome.google.com/webstore/detail/avatar-maker/ofknlbikfofijlcjkfcihomkedmchfbn)生成，比较随性。

## 标签页生成

这里有一点小坑，我一直发现tags点不开，原来发现是这里没有添加tags页面(page)，首先要使用命令，添加响应的页面：

```cmd
$ cd hexo文件目录
$ hexo new page "tags"
$ hexo new page "categories"
```

然后再在yaml（同页面头像那里）进行相关的设置，相当于打开这个功能：

```yaml
menu:
  home: / || fa fa-home
  #about: /about/ || fa fa-user
  tags: /tags/ || fa fa-tags
  categories: /categories/ || fa fa-th
  archives: /archives/ || fa fa-archive
  #schedule: /schedule/ || fa fa-calendar
  #sitemap: /sitemap.xml || fa fa-sitemap
  #commonweal: /404/ || fa fa-heartbeat
```

最后，在新生成的tags和categories页面中，添加一行：

```yaml
---
title: tags
date: 2018-01-23 17:14:51
type: "tags"     #新添加的
---
```

```yaml
---
title: categories
date: 2018-01-23 17:14:51
type: "categories"   #新添加的
---
```

最后终于大功告成。

## 参考资料

- [Hexo next 主题配置右侧栏的分类和标签打开的是空白 - 简书 (jianshu.com)](https://www.jianshu.com/p/f138032e7539)
- [Next主题美化_蜗牛非牛的博客-CSDN博客_next主题美化](https://blog.csdn.net/qq_34003239/article/details/100883213)
