---
title: 【CAG_SLAM】-01-控制信号
date: 2022-01-12 20:42:53
tags:
  - verilog
  - 踩坑
categories:
  - 科研
  - 工作
---

这里的控制信号主要是基于上一次的比较树的项目的增加的。

控制信号主要是包括对整个模块的一个启动、结束以及重置等状态的转移进行控制；

## 任务描述

---

在模块的输入中，再加入一个使能信号rst_n和valid信号。在加入rst_n信号后，所有的寄存器需要重置，（eg.本模块是要输入72次，但是在输入20次后，如果rst信号被拉低，然后再拉高后，这时需要重新输入72个数据，并且需要把相关的数据进行重置，例如：初始化寄存器）。

<!-- more -->

## 实现方法

---

目前的想法是按照学长的思路，利用if语句进行判断，但是这样加入的逻辑好像有一点问题。看了以下网上讲的控制方法[^1][^2]，好像也没讲的太深入。

目前的想法是不改动前面的比较树的模块，而是改动一下后面的记录下标的模块。比较树仍然是输出滞后了两个周期的最大值（历史所有输入）。

因此，前面**记录的最大值**应该在rst_n有效之后被**清零**，不能再保留历史最大值。**rst_n**至少要保持两个周期才能够清零所有最大值。因为输出会有一定周期的延迟。

然后，同时，在rst_n有效的时候，还应该**将下标**进行**初始化**，在rst_n无效、valid_i有效之后，立刻开启计数来记录下标。因此，前面的比较树模块只需要改变最大值赋值的问题。

![rst_n无效](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220115115507837.png)

![rst_n有效](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220115115631665.png)

![rst_n先无效，再有效](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220115115933918.png)

这里的信号有点问题，在rst_n无效之后，其不能够立马对当前的最大值的位置进行输出，因为前两个周期的最大值还会陆续输入进来，因此，需要做两个周期的延迟。这种方式感觉不太可靠，这里决定改变为，当rst_n有效时，输入的信号也全部置零，当rst_n置高后，这时候再去看valid信号，如果valid_i信号也是高电平，就将该组数据输入（如果valid_i不是高电平，我也选择不输入）。

对信号的位置坐标计数也是这样，如果当前valid_i无效，我也选择不不计数，而是等到rest_n无效、valid_i有效的时候再进行输入的操作。

![rst_n信号加入后的波形图](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220115150956196.png)

下面这个时序有点问题：问题是valid信号导致信号进来后只数了一下。这个问题是由于输入的需求不是连续输入导致的，如何记录当下输入的是第几组？？？

![image-20220115153648515](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220115153648515.png)

当输入了一组数据是，count就会加，记录当下是第几组数据，但是当时间有了两秒的延时之后，才会比较出最大值。但这个时候的count要么已经增加了，或者也没有增加（valid_i信号无效时，就不会增加）。因此，不能够简单地用当下的count来两个周期之前是输入了第几组数据。

max比较的时候始终都是两个周期之前的数据，能不能用一个寄存器保存一下两个周期前是输入的什么东西。进而解决这个问题呢？思路就是记录一下当前的值，然后延时两个周期输出。这里工作的初步想法就是，在valid_i信号有效的时候，count值会改变，同时给一个移位寄存器，移位寄存器会在延时两个周期之后输出count_delay，这个值便可以直接给求max的部分用来计算地址。

这样的话前面的count初始化工作就不再需要特殊处理了，只需要两个移位寄存器，分别记录当下的行列的count值即可。

> 一般来说，在小的模块中，需要申明一些寄存器，在大的的模块中，只需要将这些寄存器连接起来即可。例如在本次项目中用到的一些移位寄存器是由d_ff构成的。

> 在没有思路的时候，把想法打下来整理一下可能就有思路了。

![使用了移位寄存器之后的仿真波形](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220115201601412.png)

行坐标出现了问题，原因是在该前面的特殊初始化的时候，不小心把row_clk初值设置为0了。这个应该还是1，因为如果是0的话，马上就会产生上升延，导致row_count+1。

![改正后的正确时序](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220115203044290.png)

这里又遇到一个问题，是rst_n信号有效之后，并没有清零坐标和最大值，原因是在rst_n信号有效时，还有剩余的两个已经输入的坐标值和最大值没有比较出来，我想到的办法是手工延长这个rst_n信号两个周期，去强制清零。或者直接在前面的模块加入语句清零寄存器，就是忘记对第二层信号的清零。

上面的问题通过强制清零解决了，又有一个新的问题，就是在当rst之后，行坐标并没有清零。问题找到了，是因为row_count用了一个分频处理，因此，并没有清零（时间长度不够）。

![rst_n信号有问题的情况](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220115221830110.png)

把clk统一后解决问题，以后一个模块还是不要用多个clk，置位操作会出现问题（不能够即使清零分频之后的信号的情况（因为不能够恰好在其上升沿）。

![置位信号正确](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220115224622027.png)

现在的问题是flag还有一点小问题，10111111输出不正确。问题是利用flag判断赋值的情况有一点问题，目前想到的办法是用assign进行提前的赋值操作，比较方便的选择是通过assign d[i]=flag[i]?din[i]:1'b0。

![修改之后的功能验证，正确，din[6]被屏蔽](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220116101757686.png)

现在需要加入一个valid_o信号，想法是用一个寄存器计数，当输入次数达到72次之后，把valid_o信号放入移位寄存器输出。这里当valid_o有效应该用两个寄存器来保存值吗（一个得到相应的值，另一个用来）

<img src="https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220116122018936.png" alt="加入valid_o" style="zoom:33%;" />

[^1]: [verilog语法学习_2.时序控制（延时控制 & 时间控制）_这么神奇的博客-CSDN博客_verilog 时序](https://blog.csdn.net/weixin_47139649/article/details/115296476)
[^2]:[4.3 Verilog 时序控制 | 菜鸟教程 (runoob.com)](https://www.runoob.com/w3cnote/verilog-timing-control.html)
