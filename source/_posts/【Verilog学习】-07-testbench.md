---
title: 【Verilog学习】-07-testbench
mathjax: false
date: 2022-02-12 21:05:35
tags:
  - verilog
categories:
  - 学习
---

## testbench

textbench的写法中，主要就是对信号进行初始化（时钟，输入数据等），时钟信号的生成。这里这介绍一些基础的用法。在后面，要结合python写一下脚本对结果进行一些比对等。

## 基础写法

### #

这个是延时的符号，表示延时多久才进行操作，只能在仿真中使用，没有对应实际的电路。

### 产生时钟[^1]

### 方法1

```verilog
module top_module ( );
    parameter clk_period = 10;
    reg clk;
    initial begin
        clk = 0;
        forever
            #(clk_period/2) clk = ~clk;
    end
    dut dut_inst1(clk);
endmodule
```

### 方法2

```verilog
module top_module ( );
    parameter clk_period = 10;
    reg clk;
    initial begin
        clk = 0;
    end
    always #(clk_period/2) clk = ~clk;
    dut dut_inst1(clk);
endmodule
```

### 编写激励[^2]

基础的部分还是通过延时来解决。

```verilog
module top_module ( output reg A, output reg B );//
	parameter A_period_1 = 10;
    parameter A_period_2 = 10;
    parameter B_period_1 = 15;
    parameter B_period_2 = 25;
    // generate input patterns here
    initial begin
		A = 0;
        #A_period_1;
        A = 1;
        #A_period_2;
        A = 0;
    end
	initial begin
		B = 0;
        #B_period_1;
        B = 1;
        #B_period_2;
        B = 0;
    end
endmodule
```

### 一个简单的testbench

```verilog
module top_module();
    parameter clk_period = 10;
    reg in;
    reg clk;
    reg [2:0] s;
    reg [2:0] qs [7:0];	//最开始这里搞错了，应该是7：0才有8个数
    reg [2:0] i = 3'd1;
    reg out;
	initial begin
        clk = 0;
        qs[0] = 3'd2;
        qs[1] = 3'd6;
        qs[2] = 3'd2;
        qs[3] = 3'd7;
        qs[4] = 3'd0;
        s = qs[0];
        forever
            #(clk_period/2) clk = ~clk;
    end
    initial begin
    	in = 0;
        #(2*clk_period);
        in = 1;
        #(clk_period);
        in = 0;
        #(clk_period);
        in = 1;
        #(3*clk_period);
        in = 0;
    end
    always @(negedge clk) begin
        if(i<3'd4)begin
            s <= qs[i];
            i <= i + 3'd1;
        end
        else begin
            s <= qs[4];
        end
    end
    q7 inst(
    clk,
    in,
    s,
    out
	);
endmodule
```



## 参考资料

[^1]: [Verilog仿真时钟产生方法学习_flomingo1的专栏-CSDN博客_verilog时钟信号怎么产生](https://blog.csdn.net/flomingo1/article/details/102676669)
[^2]: [Verilog testbench总结(一)_坚持-CSDN博客_testbench怎么写](https://blog.csdn.net/wordwarwordwar/article/details/53885209)
