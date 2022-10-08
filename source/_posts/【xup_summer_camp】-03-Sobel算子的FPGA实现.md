---
title: 【xup_summer_camp】-03-Sobel算子的FPGA实现
mathjax: false
date: 2022-08-09 10:56:01
tags:
    - pynq
    - hls
categories:
    - 学习
---

## 跑文档

### IP的问题

出问题了HLS生成的IP是空的，有一点小烦，不知道哪里有毛病。

现在目测是创建工程的时候，由于选择的顶层文件不正确导致的。

发现一个问题，没有按照文档选择正确的器件（创建hls工程的时候）：

![pic-1](https://s2.loli.net/2022/08/09/yDSR98PpMGn73me.png)

![pic-2](https://s2.loli.net/2022/08/09/P4VIYG3R5vQ2wdh.png)

改过来后，出现IP，正常了。

### BlockDesign的问题

开始连线不正确，AutoConnection有一个模块没有出现，检查后发现是忘记给ZYNQ Processing的IP进行配置了。

![pic-3](https://s2.loli.net/2022/08/09/MqzZWvbklj94tSX.png)

![pic-4](https://s2.loli.net/2022/08/09/T71B8mWlE4oiGda.png)

给ZYNQ加上这一个AXI端口后，正常。

顺利跑下来了，中间没什么事故。接下来就是进一步进行HLS的开发而不是仅仅用这个python来跑程序了。


