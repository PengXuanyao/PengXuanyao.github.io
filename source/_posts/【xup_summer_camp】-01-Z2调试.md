---
title: 【xup_summer_camp】-01-Z2调试
mathjax: false
date: 2022-08-04 16:52:15
tags:
    - pynq
categories:
    - 学习
---

### 调试Z2板卡

第一次按照网上的教程烧录了V2.6的官方img文件，发现不能启动（只有电源灯亮起了，目测是烧录的时候出了问题）。下午听了xilinx的讲座，发现要用v2.7的img进行实验，故重新烧录测试。

第二次烧录成功使用的是V2.7的img，烧写时间大概为1至2分钟（在设备管理器中查看PYNQZ2的COM端口时突然正常）。

正常启动后，系统会亮起所有的按键上的LED。

<!--more-->

![Z2启动之后](https://s2.loli.net/2022/08/04/mJjf6TLy5kzd4vw.jpg)

### 在Z2跑例程

#### JupyterNotebook

1. 写好md之后，需要点击运行才会出现渲染之后的效果：

源代码（编辑模式）：

![渲染之前](https://s2.loli.net/2022/08/05/FiZvEGU5TsJ7218.png)

点击运行（或者使用快捷键Ctrl + Enter）：

![单击运行](https://s2.loli.net/2022/08/05/gTqujCrSbFyMNLh.png)

渲染之后的效果（命令模式）：

![渲染之后的效果](https://s2.loli.net/2022/08/05/Ic3D8lUnVziTFfj.png)

官方文档的说明：

![官方说明](https://s2.loli.net/2022/08/05/XZYQ5ujed76MPWa.png)

2. 快捷键：

在command模式下，有点类似vim的快捷键，使用Help-->Keyboard Shortcuts进行查看：

![快捷键](https://s2.loli.net/2022/08/05/RVD9dtG6Z7BmLxk.png)

参考资料：
1. [实验概述 \- 深度学习体系结构（2021秋季） | 哈工大（深圳） (gitee.io)](https://hitsz-cslab.gitee.io/dla/lab1/overview/)