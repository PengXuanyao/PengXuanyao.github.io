---
title: 【xup_summer_camp】-00-PYNQ-Z2-Start
mathjax: false
date: 2022-08-03 19:28:42
tags:
    - pynq
categories:
    - 学习
---

今天开始搞Xilinx的暑期学校了，东西有点多，得先把板子摸一遍才行。

首先是看了一篇[入门的博文](https://blog.csdn.net/qq_34341423/article/details/102507665)，总结一下，需要准备的东西包括：
1. 一根网线
2. 一个Micro-USB数据线
3. 一个SD卡

### 如何在Zettlr里面上传图片

这个是个硬伤，以前用Typora用习惯了，上传图床实在是太方便了。

![tst](https://s2.loli.net/2022/08/03/1z9k3RQZXEdrIfM.png)

其实发现这样也不是很麻烦，直接手动通过Picgo上传吧（Ctrl + Shift + P），然后再把链接复制粘贴过来即可。

### 接着说PYNQ

照着[官网点店铺中的下载栏目](![](https://s2.loli.net/2022/08/03/1z9k3RQZXEdrIfM.png))的文档即可。

刚才过了一遍PYNQ-Z2的手册，里面有几个小地方需要注意一下：

1. 首先是电源供电的问题：

电源供电有两个模式，一个是USB直接给板子供5V的电压；还有一种是输入板载的电源模块输入5V到12V的电压。

两个模式通过一个跳线帽J9来选择：

![电源选择](https://s2.loli.net/2022/08/03/lwnK8VQu6tx1IDi.png)

2. 然后是Boot选择，到时候如果是从SD卡中启动的话，需要选择这里左边的SD卡。

![Boot选择](https://s2.loli.net/2022/08/03/t78WfxYbhPDdvie.png)