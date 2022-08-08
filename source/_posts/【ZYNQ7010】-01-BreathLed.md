---
title: 【ZYNQ7010】-01-BreathLed
mathjax: false
date: 2022-07-15 20:46:50
tags:
  - ZYNQ7010
categories:
  - 学习
---

## 概述

这个整一个简单的活，做一个呼吸灯。怎么实现呢？现在没有这个定时器的PWM辅助，就需要造出一个PWM来控制LED，本质上是一个PWM的实现。（这里默默地想到了第一次在TI的开发板上实现呼吸灯的方法，直接用两个for循环，很粗暴但是作为第一个自己写的程序，现在想起来还是蛮有意思的）

<!--more-->

## 实现思路

这里可以用一个简单的状态机来控制，一共有四个LED，每个LED循环呼吸，直观来看需要8个状态（3位的状态）。现在我们来梳理一下这个逻辑。

分析一下，可知需要1个计数控制PWM的占空比，4个时钟信号，一个主频率，另外三个分频得到控制PWM的频率，占空比信号变化的频率和控制完成一次呼吸的频率。

有了硬件，接下来描述一下逻辑，首先是使用分频得到稳定的呼吸频率（1Hz），PWM频率（100kHz)。在前半个呼吸周期中（0.5s），PWM占空比逐渐增大到100%，在后半个周期中，减小到0%，中途通过改变控制PWM占空比的计数器（先递增，后递减）来实现。

所以最关键的是这个占空比计数器应当如何变化：已知芯片的内部频率是50MHz，因此，这里占空比计数器应当从0变化到500（经过0.5s），再从500变化到0（再经过0.5s），可以推出，占空比计数器变化的频率应该是1kHz。

## 具体实现

经过上述描述：这里为每个时钟信号都分别定义了计数器，然后生成响应的时钟信号（clk时序逻辑中）。

1. 在duty_clk时序逻辑中，主要是改变duty_counter的大小实现占空比以1kHz递增；

2. 在~~pwm_clk~~(clk)（实际上PWM是以clk为基准的，虽然其变化频率是100kHz，但是需要通过一个pwm_counter去作比较得到PWM信号，不需要刻意单独生成pwm_clk）时序逻辑中，通过比较pwm_counter和duty_counter，生成pwm波形;

3. 在breath_clk时序逻辑中，主要是控制led以1Hz频率进行更换；

```verilog
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/16 17:19:46
// Design Name: 
// Module Name: breath_led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module breath_led(
    input clk,
    input rstn,
    output [3:0] led
    );

// 分频系数设定
localparam MAX_PWM_COUNT = 9'd500, MAX_LED_COUNT = 3'd4,
             DUTY_DIV = 16'd25_000, BREATH_DIV = 26'd25_000_000;

// 占空比控制、LED控制、PWM频率、占空比变化频率、呼吸频率计数器
reg [8:0] duty_counter;
reg [2:0] led_counter;
reg [8:0] pwm_counter;
reg [15:0] duty_clk_counter;
reg [25:0] breath_clk_conter;

// 时钟信号
reg duty_clk, breath_clk;

// 控制信号
reg duty_flag, last_duty_flag;  // 控制duty变化方向
reg pwm;        // PWM信号

// 时钟信号发生，这里采用的方法是直接从主时钟产生，也可以选择一级一级由不同时钟产生
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        duty_clk_counter <= 0;
        duty_clk <= 0;
    end
    else begin
        if (duty_clk_counter == (DUTY_DIV - 1'b1)) begin
            duty_clk <= ~duty_clk;
            duty_clk_counter <= 0;
        end
        else begin
            duty_clk_counter <= duty_clk_counter + 1'b1;
        end
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        breath_clk_conter <=0;
        breath_clk <= 1;
    end
    else begin
        if (breath_clk_conter == (BREATH_DIV - 1'b1)) begin
            breath_clk <= ~breath_clk;
            breath_clk_conter <= 0;
        end
        else begin
            breath_clk_conter <= breath_clk_conter + 1'b1;
        end
    end
end
        
// 占空比信号控制
always @(posedge duty_clk or negedge rstn) begin
    if (!rstn) begin
        // reset
        duty_counter <= 0;
    end
    else begin
        // flag为0，表示在呼，占空比增加
        if (duty_flag == 0) begin
            duty_counter <= duty_counter + 1'b1;
        end
        // flag为1，表示在吸，占空比减少
        else if (duty_flag == 1) begin
            duty_counter <= duty_counter - 1'b1;
        end
        else begin
            duty_counter <= duty_counter;
        end
    end
end

always @(posedge duty_clk or negedge rstn) begin
    if (!rstn) begin
        // reset
        duty_flag <= 0;
        last_duty_flag <= 0;
    end
    else begin
        if (duty_counter == (MAX_PWM_COUNT - 1'b1) && last_duty_flag == 1'b0) begin
            duty_flag <= 1'b1;
            last_duty_flag <= duty_flag; 
        end
        else if (duty_counter == 1'b1 && last_duty_flag == 1'b1) begin
            duty_flag <= 1'b0;
            last_duty_flag <= duty_flag;
        end
        else begin
            last_duty_flag <= duty_flag;
            duty_flag <= duty_flag;
        end
    end
end
        
// 呼吸灯控制计数器，每加一就换一个LED
always @(posedge breath_clk or negedge rstn) begin
    if (!rstn) begin
        led_counter <= 0;
    end
    else begin
        if (led_counter == (MAX_LED_COUNT - 1'b1))
            led_counter <= 0;
        else begin
            led_counter <= led_counter + 1'b1;
        end
    end
end

// PWM信号产生
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pwm <= 0;
        pwm_counter <= 0;
    end
    else if (pwm_counter == (MAX_PWM_COUNT - 1'b1)) begin
        pwm_counter <= 0;
    end
    else if (pwm_counter <= duty_counter) begin
        pwm <= 1'b1;
        pwm_counter <= pwm_counter + 1'b1;
    end
    else begin
        pwm <= 1'b0;
        pwm_counter <= pwm_counter + 1'b1;
    end
end

// 传送PWM信号
assign led[0] = (led_counter == 0) ? pwm : 0;
assign led[1] = (led_counter == 1) ? pwm : 0;
assign led[2] = (led_counter == 2) ? pwm : 0;
assign led[3] = (led_counter == 3) ? pwm : 0;
endmodule
```

## Debug了一下

原来的程序主要是设定这个duty_counter和duty_flag有些问题，没有用last_duty_flag这个寄存器，导致其中进行非阻塞赋值的时候，出现了一些问题（判断语句中用了这个寄存器判断，然后又在后面将这个寄存器进行了赋值，好像是这样就出现了问题，现在在判断中使用的是上一个时刻的duty_flag也就是last_duty_flag这个寄存器，在赋值的时候是使用的duty_flag这个寄存器，现在就不存在这个问题了）。

图片展示一下效果：

![BreathLed](https://s2.loli.net/2022/08/08/4TL51rqHw3OkIEo.gif)

## 总结

1. verilog实现比较运算 (>, <, <=, >=) 的时候是通过什么电路结构来实现的？主要是通过LUT及其辅助电路进行实现（针对Xilinx的FPGA）[数据比较器在FPGA中的实现_lu-ming.xyz的博客-CSDN博客_fpga 比较器](https://blog.csdn.net/lum250/article/details/121072647)；基于比较后，还能够进行排序处理，全并行的排序方法如下：[读论文之《基于 FPGA 的并行全比较排序算法》_李锐博恩的博客-CSDN博客](https://blog.csdn.net/Reborn_Lee/article/details/80469391)，包括堆排序的方法[堆排序的Verilog实现 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/32166363)
2. 这是一篇实现双调排序比较好的文章：[FPGA排序模块与verilog实现 [ 含源码!!! ] - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/180001958)；
3. 实现组合逻辑可以分有哪些结构？LUT的结构是通过RAM加MUX进行实现的。[LUT是如何实现千万种逻辑结构的_一个早起的程序员的博客-CSDN博客_lut结构](https://blog.csdn.net/weiaipan1314/article/details/104317186)
4. [MyHDL](https://www.myhdl.org/)：一个把Python编程HDL的玩意儿
