---
title: 【Hexo】-02-修改标题和主题
date: 2022-01-05 11:20:52
tags: 
  - hexo
categories:
  - 学习
---

主要参考资料：

[Hexo 修改博客站点标题_野猿新一-CSDN博客_hexo title](https://blog.csdn.net/mqdxiaoxiao/article/details/93255480)

主要是修改_config.yml中的配置。

- 出现报错及其原因

  这是是由于在改变文件时，没有用转义符，导致相关的字符未被识别：

  ```yml
  title: PengXuanyao
  
  subtitle: 'xuanyao's blog'
  
  description: '彭宣尧的博客'
  
  keywords: 
  
  author: PengXuanyao
  
  language: en
  
  timezone: ''
  ```

  上述代码是错的subtitle中的 ' 未使用正确，下面添加以下转义符试一试。

  ```yml
  title: PengXuanyao
  
  subtitle: "xuanyao's blog"
  
  description: '彭宣尧的博客'
  
  keywords: 
  
  author: PengXuanyao
  
  language: en
  
  timezone: ''
  ```

  

