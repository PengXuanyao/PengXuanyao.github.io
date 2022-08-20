---
title: 【xup_summer_camp】-04-hls学习（上）
mathjax: false
date: 2022-08-13 17:24:18
tags:
categories:
---

> 本博客为Xilinx HLS课程笔记

## FPGA的单元

### 逻辑单元

基本的逻辑功能、加法功能（或者使用DSP48）

### 算术逻辑单元

DSP48

![算术逻辑单元](https://s2.loli.net/2022/08/13/n2JcPAv6SmZaolB.png)



![ALU能够实现的功能](https://s2.loli.net/2022/08/13/dLpZClxytaFnEYh.png)

### 存储单元

Block RAM（大块数据存储）、LUT in SLICEM（小容量 ≤ 1kb）

![BRAM配置](https://s2.loli.net/2022/08/13/Iow8blKhXn3mz6L.png)

![RAM配置模式](https://s2.loli.net/2022/08/13/Jd3r7OsY8QM6ieZ.png)

数组和BRAM之间进行映射

本课程关注点是：如何写高效率的HLS代码（C/C++）

## HLS的机制

硬件设计的重点和难点：时序和并行性分析。

C/C++关注算法本身。

### C → HDL 流程

Scheduling(调度) → Control Logic Extration(控制逻辑提取) → Binding(硬件映射)

简单，无控制逻辑的例子：

![例子](https://s2.loli.net/2022/08/13/HC8GJUD3V4gstQ5.png)

涉及到循环（有状态机），加入控制逻辑的例子：

![for. example](https://s2.loli.net/2022/08/13/ypjcsHJkxA5LhlU.png)

HLS 通过状态机来控制算法的进程。

