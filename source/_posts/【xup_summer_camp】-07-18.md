---
title: 【xup_summer_camp】-07-18
mathjax: false
date: 2022-07-18 19:39:58
tags:
    - xilinx
    - vivado
    - hls
categories:
    - 学习
---

## HLS相关知识

### 进程和线程：

这个博客描述了这两个基本概念之间的区别和联系：一个进程可以包含一个或者多个线程（轻量级进程）[进程和线程的区别(超详细)_ThinkWon的博客-CSDN博客_进程和线程的区别](https://blog.csdn.net/ThinkWon/article/details/102021274)

还有一个协程：[面试必考 | 进程和线程的区别 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/114453309)

![](https://s2.loli.net/2022/07/18/D24HRgoEyYtbGkO.png)

### 如何进行算法优化：

作为硬件加速的基本方法，就是要知道那些地方可以做并行计算，那些地方有数据关联，只能做串行计算。

将顺序程序运用转换成生产者消费者模式（Producer - Consumer Paradigm），中间加入Buffer缓冲，保持两者之间的吞吐量一致。

pics

Stream（流）的定义是指无界和连续更新

流水线

调度是指分析算法的流程，绑定指的是将变量映射到寄存器等硬件资源

控制逻辑提取需要在有循环的状态下产生
