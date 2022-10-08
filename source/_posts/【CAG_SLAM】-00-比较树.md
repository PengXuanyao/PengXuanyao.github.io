---
title: 【CAG_SLAM】-00-比较树
date: 2022-01-05 19:53:42
tags: 
  - verilog
  - 踩坑
  - SLAM
categories:
  - 科研
  - 工作
---

最近需要完成的一项任务是做一个比较的verilog模块，任务描述一下是这样的:

## 任务描述

---

输入信号是clk，score，flag，reset，data_valid，输出是valid，addr0，addr1。

输入信号中，首先reset信号置高后，状态机进入IDLE等待状态，这时候等待data_valid信号输入，当data_valid信号出现（上升沿or下一个时钟的上升沿）时，读取score。score是一个数组[8]，每次输入八个，每个的大小是八位。前四个和后面四个分别比较，得到分别的最大值的地址。一直进行输入，直到最后输入data_valid信号变低之后，停止输入，这时等待得到最后的最大的两个数的地址，将输出的valid变高。

## 实现方法

---

中间比较的部分使用比较树的方式，将8个数据分成两颗树，4→2→1。即两层的比较即可，两个周期的得到最大值，同时，使用流水线，在第二层的数据正在比较的时候，将新的第一层数据放入。

其中，需要用一个寄存器记录一下当前是第i次的输入信号，整体的矩阵是24*24的，因此，在最后一次输入时，需要得到addr = i×4+addr，再通过行坐标为 addr / 24，列坐标为 addr %24，得到输出的addr0和addr1。

![两层的比较树](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220105205237849.png)

## 参考文章

---

- [(AXI)握手协议（pvld/prdy或者valid-ready）中Valid及data打拍技巧 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/212338948)
- [How to find MAX or MIN in Verilog coding? - Stack Overflow](https://stackoverflow.com/questions/20599522/how-to-find-max-or-min-in-verilog-coding)
- [芯片设计进阶之路——Reset深入理解 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/110866597)
- [Verilog编程规范——reset_我要变强Wow-CSDN博客_verilog中reset](https://blog.csdn.net/sinat_31206523/article/details/106728442)
- [FPGA Verilog 并行全比较算法（大点数)_小李好好学-CSDN博客_verilog比较两个数大小](https://blog.csdn.net/qq_36375505/article/details/82143946)
- [各位知友，请问如何用Verilog实现在几十个数中快速找到最大值，谢谢啦？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/43534394#:~:text=各位知友，请问如何用Verilog实现在几十个数中快速找到最大值，谢谢啦？,如果题主只是考虑速度快，那有个简单直观的方法，就是将所有相邻的两个输入数进行比较，选出最大值 (MAX)输出作为下一级；而下一级仍然是将相邻两个数比较，选出最大值作为下一级；依此直到只输出一个数，这个数就是最大值。)
- [Verilog使用组合逻辑求最小值_贾小瑞的博客-CSDN博客](https://blog.csdn.net/weixin_44272923/article/details/109812229)
- [FPGA上如何求32个输入的最大值和次大值：分治 - 暗海风 - 博客园 (cnblogs.com)](https://www.cnblogs.com/sea-wind/p/8384596.html)
- [Github 上有哪些优秀的 Verilog/FPGA 项目？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/348990787)

总体看了这些文章博客，这里面的倒数第二个博客园里面的文章讲述的方法比较贴合这个题目的，但是他也是在求最大值啊和次大值，因此，还涉及到一些其他需要加进去的东西。

### 关于generate模块

由于在实现过程中频繁用到generate模块，这里先对其进行一个学习：

[Verilog中generate的使用 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/107047600)

---

裂开了---quartus仿真崩了，不知道怎么改回来，library找不到。。。有一点磨人，不知道问题出在哪里了，再搞十分钟，找不到就先放放吧。。。

这个问题是因为想要换成modelsim仿真导致的，重新按照网上的方法换回来了。[Unsupported ModelSim library format for work_星空之火的博客-CSDN博客](https://blog.csdn.net/qq_34244712/article/details/99769922)

调用modelsim出现找不到库的问题，具体原因没有找到。现在的解决办法是把tools->options->general->eda tool options->ModelSim的地址改成和ModelSim-Altera一样的凑活能用，接下来再想办法把ModelSim加上。

---

## 2020-01-07

---

首先，先解决数据的部分最后再加入控制的部分，今天主要把比较部分写好了。

数据部分写的时候出现了一点问题，主要是对verilog输入输出端口的定义没有掌握清楚。

下面是一些网上找到的博客，学习一下：

[[初学Verilog笔记\]模块输入输出_qq_34670678的博客-CSDN博客_verilog输入输出](https://blog.csdn.net/qq_34670678/article/details/106432116)

其总结了一下相关的规则，如果再端口定义的时候，没有说明，默认其是reg类型的。

输出出现是只有同时都输出第一个的最大值，对第二层的最大值不输出，应该是哪里没有分配对。

问题找到了，根据报错信息说我的s1_max没有被驱动或者赋值，仔细一看是下标写错了：

```verilog
//没改之前错误的代码，下标没对上，i不是从零开始的
reg [DW-1:0] s1_max2[DN/2-1:0];
generate
    for(i=DN/4;i<DN/2;i=i+1)begin:stage1_second_layer_loop_compare
        always @(posedge clk) begin
            if(d[2*i]>d[2*i+1])begin
                s1_max2[i] <= d[2*i];
            end
            else begin
                s1_max2[i] <= d[2*i+1];
            end
        end
    end
endgenerate
//改正之后的代码
reg [DW-1:0] s1_max2[DN/2-1:0];
generate
    for(i=DN/4;i<DN/2;i=i+1)begin:stage1_second_layer_loop_compare
        always @(posedge clk) begin
            if(d[2*i]>d[2*i+1])begin
                s1_max2[i-DN/4] <= d[2*i];
            end
            else begin
                s1_max2[i-DN/4] <= d[2*i+1];
            end
        end
    end
endgenerate
```

小工告成,下面是完整代码

```verilog
module my_get_max#(
parameter DW = 8,
parameter DN = 8
)(
input clk,
input [DN*DW-1 :0] din,
output reg [DW-1:0] max1,
output reg [DW-1:0] max2
);

wire [DW-1:0] d[DN-1:0];
generate
    genvar i;
    for(i=0;i<DN;i=i+1)begin:loop_assign
        assign d[i] = din[DW*i+DW-1:DW*i];
    end
endgenerate


reg [DW-1:0] s1_max1[DN/2-1:0];
reg [DW-1:0] s1_max2[DN/2-1:0];
// stage 1: first layer
generate
    for(i=0;i<DN/4;i=i+1)begin:stage1_first_layer_loop_compare
        always @(posedge clk) begin
            if(d[2*i]>d[2*i+1])begin
                s1_max1[i] <= d[2*i];
            end
            else begin
                s1_max1[i] <= d[2*i+1];
            end
        end
    end
endgenerate
// stage 1: second layer
generate
    for(i=DN/4;i<DN/2;i=i+1)begin:stage1_second_layer_loop_compare
        always @(posedge clk) begin
            if(d[2*i]>d[2*i+1])begin
                s1_max2[i-DN/4] <= d[2*i];
            end
            else begin
                s1_max2[i-DN/4] <= d[2*i+1];
            end
        end
    end
endgenerate

// stage 2: first layer
always @(posedge clk) begin
    if(s1_max1[0]>s1_max1[1])begin
        max1 <= s1_max1[0];
    end
    else begin
        max1 <= s1_max1[1];
    end
end
// stage 2: second layer
always @(posedge clk) begin
    if(s1_max2[0]>s1_max2[1])begin
        max2 <= s1_max2[0];
    end
    else begin
        max2 <= s1_max2[1];
    end
end
endmodule
```

要进行比较并记录下地址，一共要比较72次（24*24/8）次，比较的时候需要对相关的地址进行记录，这是找到的一些通过i去赋值的例子。

[Verilog for loop - genvar vs int - Electrical Engineering Stack Exchange](https://electronics.stackexchange.com/questions/520681/verilog-for-loop-genvar-vs-int)

能够获得一次的地址，取消了gererate，由于赋值地址的问题，今后再找解决办法，问题是这个：

![image-20220108231053688](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220108231053688.png)

地址没法复制，改后能运行的代码如下：

```verilog
module my_get_max#(
parameter DW = 8,
parameter DN = 8
)(
input clk,
input [DN*DW-1 :0] din,
output reg [DW-1:0] max1,
output reg [DW-1:0] max2,
output reg [DW-1:0] addr1,
output reg [DW-1:0] addr2
);

wire [DW-1:0] d[DN-1:0];
generate
    genvar i;
    for(i=0;i<DN;i=i+1)begin:loop_assign
        assign d[i] = din[DW*i+DW-1:DW*i];
    end
endgenerate


reg [DW-1:0] s1_max1[DN/2-1:0];
reg [DW-1:0] s1_max2[DN/2-1:0];
reg [1:0] s1_addr1[1:0];
reg [1:0] s1_addr2[1:0];
// stage 1: first layer
always @(posedge clk) begin
    if(d[0]>d[1])begin
        s1_max1[0] <= d[0];
        s1_addr1[0] <= 2'b0;
    end
    else begin
        s1_max1[0] <= d[1];
        s1_addr1[0] <= 2'b01;
    end
end
always @(posedge clk) begin
    if(d[2]>d[3])begin
        s1_max1[1] <= d[2];
        s1_addr1[1] <= 2'b10;
    end
    else begin
        s1_max1[1] <= d[3];
         s1_addr1[1] <= 2'b11;
    end
end
// stage 1: second layer
always @(posedge clk) begin
    if(d[4]>d[5])begin
        s1_max2[0] <= d[4];
        s1_addr2[0] <= 2'b00;
    end
    else begin
        s1_max2[0] <= d[5];
        s1_addr2[0] <= 2'b01;
    end
end
always @(posedge clk) begin
    if(d[6]>d[7])begin
        s1_max2[1] <= d[6];
        s1_addr2[1] <= 2'b10;
    end
    else begin
        s1_max2[1] <= d[7];
        s1_addr2[1] <= 2'b11;
    end
end

reg [DW-1:0] tmp_max1 = 8'b0;
reg [DW-1:0] tmp_max2 = 8'b0;
// stage 2: first layer
always @(posedge clk) begin
    if(s1_max1[0]>s1_max1[1])begin
        tmp_max1 <= s1_max1[0];
        addr1 <= s1_addr1[0];
    end
    else begin
        tmp_max1 <= s1_max1[1];
        addr1 <= s1_addr1[1];
    end
end
// stage 2: second layer
always @(posedge clk) begin
    if(s1_max2[0]>s1_max2[1])begin
        tmp_max2 <= s1_max2[0];
        addr2 <= s1_addr1[0];
    end
    else begin
        tmp_max2 <= s1_max2[1];
        addr2 <= s1_addr1[1];
    end
end

//reg [7:0] count=8'b0;
//after the last comapre
always @(posedge clk) begin
    if(tmp_max1>max1)begin
        max1 <= tmp_max1;
    end
    else begin
        max1 <= max1;
    end
end
always @(posedge clk) begin
    if(tmp_max2>max2)begin
        max2 <= tmp_max2;
    end
    else begin
        max2 <= max2;
    end
end


endmodule
```

---

2021-1-9

今天主要是要把坐标输出出来，初步想法是先把通过count clk ，对于行坐标，是按照时钟依次输入的，因此不需要分频，但是列向量是通过每次输入6组数据之后，再加1，因此需要做一个类似于分频率作为列坐标的行号。

---

2021-1-10

今天是出考试通知的时候，如果如期考试，这应该是近期的最后一次更行Verilog部分。

昨天晚上已经把最后的代码部分已经完善，相关的检测结果也已经基本满足要求。

关于本次的小项目，做一点小小的总结：

- 在查阅资料方面，做的还是不错，即查即用，效率还是可以。
- 在写代码的规范上面，还做的不是很好，很多数字还是没有参数化，信号的命名方面也并不是很规范，在下次完成项目的时候要记得查阅一下相关的命名规范的文档。
- 在整体的代码的逻辑上，还是比较简单，因此，这次这样一点一点写出来的问题还不大，但是等到要编写大量代码的时候，就必须需要先有一个框架再进行搭建了。无论是哪一种，都可以慢慢学习，但是要向第二种靠拢。

## 项目相关结果及说明

---

### 整体框架图

![get-max-module](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/SLAM-01-10-get-max-module.drawio.png)

### 仿真结果图

![get_max_simulation_output](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/get_max_simulation_output.png)

#### 仿真结果说明：

在仿真结果中的din为输入数据，分别为第一层和第二层的相关的数据输入；col_index和row_index为输出的最大值所在的行列坐标；max为保存的最大值；由于是两级的比较树，输出会有两个周期的延迟输出。

### 源代码

```verilog
module get_max#(
parameter DW = 8,   //data width
parameter DN = 8,   //data number
parameter AW = 5   //output addr width
)(
input clk,
input [DN*DW-1 :0] din,
output reg [DW-1:0] max1,
output reg [DW-1:0] max2,
output reg [9:0] addr1, //final output addr1， add the row_index and col_index to it
output reg [9:0] addr2, //final output addr2， add the row_index and col_index to it
output reg [AW-1:0] row_index1,
output reg [AW-1:0] row_index2,
output reg [AW-1:0] col_index1,
output reg [AW-1:0] col_index2
);

//generate assign the input signal
wire [DW-1:0] d[DN-1:0];
generate
    genvar i;
    for(i=0;i<DN;i=i+1)begin:loop_assign
        assign d[i] = din[DW*i+DW-1:DW*i];
    end
endgenerate

//first stage of the comparison tree
reg [DW-1:0] s1_max1[DN/2-1:0];
reg [DW-1:0] s1_max2[DN/2-1:0];
reg [1:0] s1_addr1[1:0];
reg [1:0] s1_addr2[1:0];
// stage 1: first layer
always @(posedge clk) begin
    if(d[0]>d[1])begin
        s1_max1[0] <= d[0];
        s1_addr1[0] <= 2'b0;
    end
    else begin
        s1_max1[0] <= d[1];
        s1_addr1[0] <= 2'b01;
    end
end
always @(posedge clk) begin
    if(d[2]>d[3])begin
        s1_max1[1] <= d[2];
        s1_addr1[1] <= 2'b10;
    end
    else begin
        s1_max1[1] <= d[3];
        s1_addr1[1] <= 2'b11;
    end
end
// stage 1: second layer
always @(posedge clk) begin
    if(d[4]>d[5])begin
        s1_max2[0] <= d[4];
        s1_addr2[0] <= 2'b00;
    end
    else begin
        s1_max2[0] <= d[5];
        s1_addr2[0] <= 2'b01;
    end
end
always @(posedge clk) begin
    if(d[6]>d[7])begin
        s1_max2[1] <= d[6];
        s1_addr2[1] <= 2'b10;
    end
    else begin
        s1_max2[1] <= d[7];
        s1_addr2[1] <= 2'b11;
    end
end

//second stage of the comparison tree
reg [DW-1:0] tmp_max1 = 8'b0;
reg [DW-1:0] tmp_max2 = 8'b0;
reg [1:0] tmp_addr1 = 2'b0;
reg [1:0] tmp_addr2 = 2'b0;
// stage 2: first layer
always @(posedge clk) begin
    if(s1_max1[0]>s1_max1[1])begin
        tmp_max1 <= s1_max1[0];
        tmp_addr1 <= s1_addr1[0];
    end
    else begin
        tmp_max1 <= s1_max1[1];
        tmp_addr1 <= s1_addr1[1];
    end
end
// stage 2: second layer
always @(posedge clk) begin
    if(s1_max2[0]>s1_max2[1])begin
        tmp_max2 <= s1_max2[0];
        tmp_addr2 <= s1_addr2[0];
    end
    else begin
        tmp_max2 <= s1_max2[1];
        tmp_addr2 <= s1_addr2[1];
    end
end

// 这个地方的赋值需要在每次使能后都进行一次，由于开始流水比较会有两个周期的延迟
// 因此要把相关记录下标的count信号并不是从1开始，要加上响应的延迟的影响
reg row_clk = 1'b0;  // row clk
reg [1:0] div = 1'b1; //div clk for row clk
reg [AW-1:0] row_count = 5'd23;  // row number
reg [AW-1:0] col_count = 3'd4;  // col number

// generate the col_count for col_index
always @(posedge clk) begin:counter
    if(col_count == 3'd5)begin
        col_count <= 1'b0;
    end
    else begin
        col_count <= col_count + 1'b1;
    end
    if(div == 2'd2)begin
        row_clk <= ~row_clk;    //divide the frequency to clk/6
        div <= 1'b0;
    end
    else begin
        div <= div + 1'b1;
    end
end
// generate the row_count for row_index
always @(posedge row_clk) begin
    if(row_count == 5'd23)begin
        row_count <= 1'b0;
    end
    else begin
        row_count <= row_count + 1'b1;
    end
end

//get the max of all, including the addr of max 
always @(posedge clk) begin
    if(tmp_max1>max1)begin
        max1 <= tmp_max1;
        row_index1 <= (col_count * 3'd4 + tmp_addr1);
        col_index1 <= row_count;
        addr1 <= {row_index1[4:0],col_index1[4:0]};
    end
    else begin
        max1 <= max1;
        addr1 <= addr1;
    end
end
always @(posedge clk) begin
    if(tmp_max2>max2)begin
        max2 <= tmp_max2;
        row_index2 <= (col_count * 3'd4 + tmp_addr2);
        col_index2 <= row_count;
        addr2 <= {row_index2[4:0],col_index2[4:0]};
    end
    else begin
        max2 <= max2;
        addr2 <= addr2;
    end
end
endmodule
```

