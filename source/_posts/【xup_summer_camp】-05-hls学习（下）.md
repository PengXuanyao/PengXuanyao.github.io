<!--
 * @Author: Peng Xuanyao 793063685@qq.com
 * @Date: 2022-09-30 10:05:20
 * @LastEditors: Peng Xuanyao 793063685@qq.com
 * @LastEditTime: 2022-10-01 11:58:15
 * @FilePath: /_posts/【xup_summer_camp】-05-hls学习（下）.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
---
title: 【xup_summer_camp】-05-hls学习（下）
mathjax: false
date: 2022-09-30 10:05:20
tags:
categories:
---

## B站课程学习

> [24课：案例分析\_哔哩哔哩\_bilibili](https://www.bilibili.com/video/BV1bt41187RW?p=24&vd_source=293ffecc5040ce31ebf8b10de8372434)

一共25节课程，比较精简。主要讲HLS基本使用中关于变量类型、数组和函数等基础，同时重点讲了各种Directive的使用（有利于实现不同的设计指标等）。

目前已经看到24课，前面笔记记录在笔记本上，第24课讲了一个具体的HLS工程实例，此次笔记主要记录一下实现过程。

<!-- more -->

## Cordic算法实现

### 算法原理

cordic算法是一种通过简单运算（加、减、移位、查找表）进行迭代（旋转）实现复杂函数计算（三角函数、乘除法、双曲函数等）的算法，适用于没有浮点运算的系统（微控制器、FPGA等）。

> [CORDIC - Wikipedia](https://en.wikipedia.org/wiki/CORDIC)
> 
> CORDIC (for COordinate Rotation DIgital Computer), also known as Volder's algorithm, or: Digit-by-digit method Circular CORDIC (Jack E. Volder), Linear CORDIC, Hyperbolic CORDIC (John Stephen Walther), and Generalized Hyperbolic CORDIC (GH CORDIC) (Yuanyong Luo et al.), is a simple and efficient algorithm to calculate trigonometric functions, hyperbolic functions, square roots, multiplications, divisions, and exponentials and logarithms with arbitrary base, typically converging with one digit (or bit) per iteration. CORDIC is therefore also an example of digit-by-digit algorithms. CORDIC and closely related methods known as pseudo-multiplication and pseudo-division or factor combining are commonly used when no hardware multiplier is available (e.g. in simple microcontrollers and FPGAs), as the only operations it requires are additions, subtractions, bitshift and lookup tables. As such, they all belong to the class of shift-and-add algorithms. In computer science, CORDIC is often used to implement floating-point arithmetic when the target platform lacks hardware multiply for cost or space reasons.

对于三角函数来说，CORDIC算法原理就是首先找到一个初始的旋转起点$(x_0, y_0)$，然后由旋转公式:
$$
\begin{bmatrix} 
x \\ 
y 
\end{bmatrix} 
= 
\begin{bmatrix}
    cos{\theta} & -sin{\theta} \\
    sin{\theta} & cos{\theta}
\end{bmatrix}
\begin{bmatrix}
    x_0 \\
    y_0
\end{bmatrix}
$$
得到目标的$(x, y)$，其中的旋转可以看成是一系列小角度进行迭代旋转。

具体的推导公式可以参考：[CORDIC算法原理详解 - 知乎](https://zhuanlan.zhihu.com/p/384524393)

其他参考资料：[FPGA的算法解析4：CORDIC 算法解析 - 知乎](https://zhuanlan.zhihu.com/p/471677202)

### HLS代码编写

#### 遇到的一些问题

1. interval和lantency的区别，interval会考虑overhead？
   
   > Latency：第一个输入，到第一个输出，之间的延迟；表征的是处理时间;
   > Interval：第一个输入，到第二个输入，之间的间隔；表征的是吞吐能力。
   
2. 遇见一种奇怪的用法，应该是用于const数组的初始化操作：

    ```cpp
        const di_t myarctan[16] = {
        #include "myarctan.h"// 添加文件
        };
    ```
   目前暂时没有弄清楚myarctan.h长什么样子，先直接用数据替代了一下。

3. 目前主要问题是在tb中，没有ReadFileVec的定义。后续两种解决方案：一种是不用ReadFileVec直接安排好数据即可，第二个是找一下视频资料，隐约记得C++部分讲过这个。
