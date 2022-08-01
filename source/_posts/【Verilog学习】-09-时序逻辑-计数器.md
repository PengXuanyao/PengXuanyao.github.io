---
title: 【Verilog学习】-09-时序逻辑-计数器
mathjax: false
date: 2022-03-24 19:16:51
tags:
  - verilog
categories:
  - 学习
---
## 1 counter16

---

Build a 4-bit binary counter that counts from 0 through 15, inclusive, with a period of 16. The reset input is synchronous, and should reset the counter to 0.

```verilog
module top_module (
    input clk,
    input reset,      // Synchronous active-high reset
    output [3:0] q);
    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end
        else begin
            q <= q + 1;
        end
    end  
endmodule
```

## 2 Counter10

---

Build a decade counter that counts from 0 through 9, inclusive, with a period of 10. The reset input is synchronous, and should reset the counter to 0.

```verilog
module top_module (
    input clk,
    input reset,        // Synchronous active-high reset
    output [3:0] q);
    always @(posedge clk) begin
        if (reset || q == 4'd9) begin
            q <= 0;
        end
        else begin
            q <= q + 1;
        end
    end
endmodule
```

## 3 Counter10-1

---

Make a decade counter that counts 1 through 10, inclusive. The reset input is synchronous, and should reset the counter to 1.

```verilog
module top_module (
    input clk,
    input reset,
    output [3:0] q);
    always @(posedge clk) begin
        if (reset || q == 4'd10) begin
            q <= 1'b1;
        end
        else begin
            q <= q + 1'b1;
        end
    end
endmodule
```

## 4 CounterSlow

---

Build a decade counter that counts from 0 through 9, inclusive, with a period of 10. The reset input is synchronous, and should reset the counter to 0. We want to be able to pause the counter rather than always incrementing every clock cycle, so the slowena input indicates when the counter should increment.

```verilog
module top_module (
    input clk,
    input slowena,
    input reset,
    output [3:0] q);
    always @(posedge clk) begin
        // ··· and slowena means when q == 9 and slowena == 0, the result should be keeped instead of be added.
        if (reset || q == 4'd9 && slowena == 1) begin
            q <= 0;
        end
        else if (slowena == 1) begin
            q <= q + 1;
        end
        /*
        // here is a wiser solution as below
        always @(posedge clk) begin
            if (reset == 1'b1)
                q <= 4'd0;
            else if(slowena == 1'b1) begin
                if (q == 4'd9)
                    q <= 4'd0;
                else
                    q <= q + 1'b1;
            end
            else
                q <= q;  
        end
        */
    end
endmodule
```

## 5

---

Design a 1-12 counter with the following inputs and outputs:

* **Reset** Synchronous active-high reset that forces the counter to 1
* **Enable** Set high for the counter to run
* **Clk** Positive edge-triggered clock input
* **Q[3:0]** The output of the counter
* **c_enable, c_load, c_d[3:0]** Control signals going to the provided 4-bit counter, so correct operation can be verified.

You have the following components available:

* the 4-bit binary counter (**count4** ) below, which has Enable and synchronous parallel-load inputs (load has higher priority than enable). The **count4** module is provided to you. Instantiate it in your circuit.
* logic gates

```
module count4(
    input clk,
    input enable,
    input load,
    input [3:0] d,
    output reg [3:0] Q
);
```

The **c_enable** , **c_load** , and **c_d** outputs are the signals that go to the internal counter's **enable** , **load** , and **d** inputs, respectively. Their purpose is to allow these signals to be checked for correctness.

### Module Declaration

```
module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
); 
```

这一道题里面的c_enable,c_load,c_d开始有点迷惑，这些不应该是输入信号吗？怎么变成输出信号了？仔细一分析发现这里的c_开头的信号，应该是用作内部计数器的控制信号（也是输入信号），但是对于整个大模块来说，就不是这个输入信号了，而是内部信号，这里是相当于把内部信号印出来，作为观察和调试之用。

还有一个点比较迷惑的就是：

> the 4-bit binary counter (**count4** ) below, which has Enable and synchronous parallel-load inputs (load has higher priority than enable).

为什么load的优先级会比enable高呢？如何设置这个优先级呢？

暂时的理解是：load信号是将q进行装载，不管enable是否有效，都进行装载；enable是开始计数的控制信号，只是控制q++是否进行，count4模块内部就是这样定义的，只需要使用，不需要深究。

代码借鉴引用2

```verilog
module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
); //
    always @(*) begin
        c_enable = enable;
        c_load = (Q == 4'd12 & c_enable) | reset;
        c_d = 1'b1;
    end
    count4 the_counter (clk, c_enable, c_load, c_d, Q);
endmodule
```

这个题有点迷，有一点像74LS163的应用吧，主要这里的c_load还得受到c_enable的控制（当c_enable无效时，c_load是不能有效的，可能就是题目强调c_load的优先级高于c_enable的原因？）

## 6

---

From a 1000 Hz clock, derive a 1 Hz signal, called **OneHertz** , that could be used to drive an Enable signal for a set of hour/minute/second counters to create a digital wall clock. Since we want the clock to count once per second, the **OneHertz** signal must be asserted for exactly one cycle each second. Build the frequency divider using modulo-10 (BCD) counters and as few other gates as possible. Also output the enable signals from each of the BCD counters you use (c_enable[0] for the fastest counter, c_enable[2] for the slowest).

The following BCD counter is provided for you. **Enable** must be high for the counter to run. **Reset** is synchronous and set high to force the counter to zero. All counters in your circuit must directly use the same 1000 Hz signal.

```
module bcdcount (
    input clk,
    input reset,
    input enable,
    output reg [3:0] Q
);
```

### Module Declaration

```
module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); 
```

### Solution

这道题卡的有点就，其实就是一个1000分频器。卡住的原因是没有弄清楚enable之间的联系，这里enable是级联三个BCD计数器进行分频的信号。

```verilog
module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //
    reg [3:0] q1;
    reg [3:0] q2;
    reg [3:0] q3;
    always @(*) begin
        if ( reset ) begin
            c_enable = 4'b0;
        end
        else begin
            c_enable[0] = 1'b1;
            if ( q1 == 4'd9 ) begin
                c_enable[1] = 1'b1;
            end
            else begin
                c_enable[1] = 1'b0;
            end
            if ( q1 == 4'd9 && q2 == 4'd9 ) begin    // 这里需要注意一下，是在前两个都是9的时候才能置高
                c_enable[2] = 1'b1;
            end
            else begin
                c_enable[2] = 1'b0;
            end
        end
        OneHertz = (q1 == 4'd9 & q2 == 4'd9 & q3 == 4'd9) ? 1 : 0;
    end
    bcdcount counter0 (clk, reset, c_enable[0], q1);
    bcdcount counter1 (clk, reset, c_enable[1], q2);
    bcdcount counter2 (clk, reset, c_enable[2], q3);
endmodule
```

### Module Declaration

```
module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); 
```

## 7 CounterBCD

Build a 4-digit BCD (binary-coded decimal) counter. Each decimal digit is encoded using 4 bits: q[3:0] is the ones digit, q[7:4] is the tens digit, etc. For digits [3:1], also output an enable signal indicating when each of the upper three digits should be incremented.

You may want to instantiate or modify some one-digit [decade counters](https://hdlbits.01xz.net/wiki/Count10).

![bcd-waveform](https://s2.loli.net/2022/05/17/OHoDBz56UMgVuNv.png)

### Module Declaration

```verilog
module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
```

### solution

```verilog
// version - 0.0 - This version is based ont the idea on this site : https://blog.csdn.net/anbncn1234/article/details/106115746
module bcd_counter(
    input clk,
    input rst,
    input ena,
    output [3:0]  q
);
always @(posedge clk) begin
    if (rst) begin
        q <= 0;
    end
    else if (ena == 1'b1) begin
        // back to 0
        if (q == 4'd9) begin
            q <= 0;
        end
        // output carryflag
        else if ( q == 4'd8) begin
            q <= q + 1'b1;
        end 
        // +1 count
        else begin
            q <= q + 1'b1;
        end
    end
end
endmodule
module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q
);
bcd_counter bcd_counter_inst_unit(.clk(clk),.rst(reset),.ena(1'b1),.q(q[3:0]));
bcd_counter bcd_counter_inst_decade(.clk(clk),.rst(reset),.ena(q[3:0] == 4'd9),.q(q[7:4]));
bcd_counter bcd_counter_inst_hundred(.clk(clk),.rst(reset),.ena(q[3:0] == 4'd9 & q[7:4] == 4'd9),.q(q[11:8]));
bcd_counter bcd_counter_inst_thousand(.clk(clk),.rst(reset),.ena(q[3:0] == 4'd9 & q[7:4] == 4'd9 & q[11:8] == 4'd9),.q(q[15:12]));
assign ena = {(q[3:0] == 4'd9 & q[7:4] == 4'd9 & q[11:8] == 4'd9),(q[3:0] == 4'd9 & q[7:4] == 4'd9),q[3:0] == 4'd9};
endmodule

// version - 0.1 - wrong verion bug comes from the ena_next signal, which is logical wrong. Can't find a solution now. 
module bcd_counter(
    input clk,
    input rst,
    input ena,
    output [3:0]  q,
    output ena_next
);
always @(posedge clk) begin
    if (rst) begin
        q <= 0;
        ena_next <= 0;
    end
    else if (ena == 1'b1) begin
        // back to 0
        if (q == 4'd9) begin
            q <= 0;
            ena_next <= 0;
        end
        // output carryflag
        else if ( q == 4'd8) begin
            ena_next <= 1'b1;
            q <= q + 1'b1;
        end 
        // +1 count
        else begin
            q <= q + 1'b1;
        end
    end
end
endmodule
module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q
);
bcd_counter bcd_counter_inst_unit(.clk(clk),.rst(reset),.ena(1'b1),.q(q[3:0]),.ena_next(ena[1]));
bcd_counter bcd_counter_inst_decade(.clk(clk),.rst(reset),.ena(ena[1]),.q(q[7:4]),.ena_next(ena[2]));
bcd_counter bcd_counter_inst_hundred(.clk(clk),.rst(reset),.ena(ena[2]),.q(q[11:8]),.ena_next(ena[3]));
bcd_counter bcd_counter_inst_thousand(.clk(clk),.rst(reset),.ena(ena[3]),.q(q[15:12]));
endmodule
```

### Debug

- 注意定义的时候，是 q [3:0] 还是 [3:0]q。否则可能会出现bug，`q has an aggregate value`
- 这个ena信号，需要在q值为9（低位都为9）的时候，进行置高。

## 8Count clock

Create a set of counters suitable for use as a 12-hour clock (with am/pm indicator). Your counters are clocked by a fast-running `clk`, with a pulse on `ena` whenever your clock should increment (i.e., once per second).

`reset` resets the clock to 12:00 AM. `pm` is 0 for AM and 1 for PM. `hh`, `mm`, and `ss` are two **BCD** (Binary-Coded Decimal) digits each for hours (01-12), minutes (00-59), and seconds (00-59). Reset has higher priority than enable, and can occur even when not enabled.

The following timing diagram shows the rollover behaviour from `11:59:59 AM` to `12:00:00 PM` and the synchronous reset and enable behaviour.

```verilog
// version - 0.0 - wrong bcd!!!
module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    sec_counter sec_counter_inst(.clk(clk),.reset(reset),.ena(ena),.ss(ss));
    min_counter min_counter_inst(.clk(clk),.reset(reset),.ss(ss),.ena(ena),.mm(mm));
    hour_counter hour_counter_inst(.clk(clk),.reset(reset),.ss(ss),.mm(mm),.ena(ena),.hh(hh));
    pm_counter pm_counter_inst(.clk(clk),.reset(reset),.ss(ss),.mm(mm),.hh(hh),.ena(ena),.pm(pm));
endmodule

module sec_counter(
    input clk,
    input reset,
    input ena,
    output [7:0] ss
);
always @(posedge clk) begin
    if (reset) begin
        ss <= 0;
    end
    else begin
        if (ena == 1'b1) begin
            if (ss == 8'd59) begin
                ss <= 0;
            end
            else    
                ss <= ss + 1'b1;
        end
        else begin
            ss <= ss;
        end
    end
end
endmodule

module min_counter(
    input clk,
    input reset,
    input ss,
    input ena,
    output [7:0] mm
);
always @(posedge clk) begin
    if (reset) begin
        mm <= 0;
    end
    else begin
        if (ena == 1'b1 && ss == 8'd59) begin
            if (mm == 5'd59) begin
                mm <= 0;
            end
            else 
                mm <= mm + 1'b1; 
        end
        else 
            mm <= mm;
    end
end
endmodule

module hour_counter(
    input clk,
    input reset,
    input ss,
    input mm,
    input ena,
    output [7:0] hh
);
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'd12;
    end
    else begin
        if (ena == 1'b1 && ss == 8'd59 && mm == 8'd59) begin
            if (hh == 8'd12) begin
                hh <= 1'b1;
            end
            else 
                hh <= hh + 1'b1; 
        end
        else 
            hh <= hh;
    end
end
endmodule

module pm_counter(
    input clk,
    input reset,
    input ss,
    input mm,
    input hh,
    input ena,
    output pm
);
always @(posedge clk) begin
    if (reset) begin
        pm <= 0;
    end  
    else begin
        if (hh == 8'd11 && mm == 8'd59 && ss == 8'd59) begin
            pm <= ~pm;    
        end
        else
            pm <= pm;
    end
end
endmodule

// version - 0.1 - AC
module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    bcd_counter bcd_counter_inst_1(.clk(clk),.reset(reset),.ena(ena),.q(ss[3:0]));
    bcd_counter_mod_6 bcd_counter_mod_6_inst_1(.clk(clk),.reset(reset),.ena(ena & (ss[3:0] == 4'd9)),.q(ss[7:4]));
    bcd_counter bcd_counter_inst_2(.clk(clk),.reset(reset),.ena(ena & (ss[3:0] == 4'd9) & (ss[7:4] == 4'd5)),.q(mm[3:0]));
    bcd_counter_mod_6 bcd_counter_mod_6_inst_2(.clk(clk),.reset(reset),.ena(ena & (ss[3:0] == 4'd9) & (ss[7:4] == 4'd5) & (mm[3:0] == 4'd9)),.q(mm[7:4]));
    bcd_counter_mod_12 bcd_counter_inst_3(.clk(clk),.reset(reset),.ena(ena & (ss[3:0] == 4'd9) & (ss[7:4] == 4'd5) & (mm[3:0] == 4'd9) & (mm[7:4] == 4'd5)),.q(hh[7:0]));
    bcd_counter_pm bcd_counter_pm_inst_1(.clk(clk),.reset(reset),.ena(ena & (ss[3:0] == 4'd9) & (ss[7:4] == 4'd5) & (mm[3:0] == 4'd9) & (mm[7:4] == 4'd5) & (hh[7:0] == 8'h11)),.q(pm));// 这里以前有个bug：hh[7:0] == 4'h11；位宽没对上
endmodule

module bcd_counter(
    input clk,
    input reset,
    input ena,
    output [3:0] q
);
always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end
    else begin
        if (ena == 1'b1) begin
            if (q == 4'd9) begin
                q <= 0;
            end
            else begin
                q <= q + 1'b1;
            end
        end
        else begin
            q <= q;
        end
    end
end
endmodule

module bcd_counter_mod_6(
    input clk,
    input reset,
    input ena,
    output [3:0] q
);
always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end
    else begin
        if (ena == 1'b1) begin
            if (q == 4'd5) begin
                q <= 0;
            end
            else begin
                q <= q + 1'b1;
            end
        end
        else begin
            q <= q;
        end
    end
end
endmodule

module bcd_counter_mod_12(
    input clk,
    input reset,
    input ena,
    output [7:0] q
);
always @(posedge clk) begin
    if (reset) begin
        q <= 8'h12;
    end
    else begin
        if (ena == 1'b1) begin
            if (q == 8'h12) begin
                q <= 8'h01;
            end
            else if (q == 8'h09) begin
                q <= 8'h10;
            end
            else begin
                q <= q + 1'b1;
            end
        end
        else begin
            q <= q;
        end
    end
end
endmodule

module bcd_counter_pm(
    input clk,
    input reset,
    input ena,
    output q
);
always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end
    else begin
        if (ena == 1'b1) begin
           q <= ~q; 
        end
        else begin
            q <= q;
        end
    end
end
endmodule
```

### Debug

- 例化模块时，需要在信号前面加上`.`，否则出现报错`cannot connect instance ports both by order and by name`。
- 定义模块是，结尾加**分号**。
- `truncated literal to match 4 bits File`；数值的位宽没有对上

### Summary

这道题卡了很久，也算是最后独立完成了，主要要注意的点就是：

- 位宽对上，细节问题，也是最后一个bug
- 模块复用的意识要到位
- 中间遇到的主要的问题是模12的BCD计数器的设计，这个暂时是这样写了，不知道有没有更好的办法
- 前面的思路是错误的，忘记了他是bcd计数。

关于BCD计数的问题，网上看了一下，应该大多数都是这样做的，分成不同的位，进行计数。对于不是模10的倍数的BCD计数器，我这里是进行了单独的设计，网上的也是这样，只不过其是单独设计了模60和模12的计数器，我这里是设计的了模10、模6、模12的计数器。可以后面再看有没有更好的方式罢了。

## Reference

1. [HDLBits (01xz.net)](https://hdlbits.01xz.net/wiki/Main_Page)
2. [HDLBits 系列（16）Something about Counter-云社区-华为云 (huaweicloud.com)](https://bbs.huaweicloud.com/blogs/detail/283302)
