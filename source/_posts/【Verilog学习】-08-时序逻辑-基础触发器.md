---
title: 【Verilog学习】-08-时序逻辑-基础触发器
mathjax: false
date: 2022-03-15 11:36:28
tags:
  - verilog
categories:
  - 学习
---

## 1.DFF

---

Create a single D flip-flop.

```verilog
module top_module (
    input clk,    // Clocks are used in sequential circuits
    input d,
    output reg q );
    always @(posedge clk) begin
        q <= d;
    end
endmodule
```

<!--more-->

## 2.DFF8

---

Create 8 D flip-flops. All DFFs should be triggered by the positive edge of `clk`.

```verilog
module top_module (
    input clk,
    input [7:0] d,
    output [7:0] q
);
    always @(posedge clk) begin
        q[7:0] <= d[7:0];    // q <= d;
    end
endmodule
```

## 3.Dff8r

---

Create 8 D flip-flops with active high synchronous reset. All DFFs should be triggered by the positive edge of `clk`.

```verilog
module top_module (
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output [7:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 'b0;
        end
        else begin
            q <= d;
        end

endmodule
```

## 4.Dff8p

---

Create 8 D flip-flops with active high synchronous reset. The flip-flops must be reset to 0x34 rather than zero. All DFFs should be triggered by the **negative** edge of `clk`.

```verilog
module top_module (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    always @(negedge clk) begin
        if (reset) begin
            d <= 8'h34;
        end
        else begin
            d <= q;
        end
    end
endmodule
```

## 5.Dff8ar

---

Create 8 D flip-flops with active high asynchronous reset. All DFFs should be triggered by the positive edge of `clk`.[^1]

```verilog
module top_module (
    input clk,
    input areset,   // active high asynchronous reset
    input [7:0] d,
    output [7:0] q
);
    always @(posedge clk or posedge areset) begin // 这里加上or和后面的信号可以实现异步
        if (areset) begin
            q <= 'd0;
        end
        else begin
            q <= d;
        end
    end
endmodule
```

## 6.Dff16e

---

Create 16 D flip-flops. It's sometimes useful to only modify parts of a group of flip-flops. The byte-enable inputs control whether each byte of the 16 registers should be written to on that cycle. `byteena[1]` controls the upper byte `d[15:8]`, while `byteena[0]` controls the lower byte `d[7:0]`.

`resetn` is a synchronous(同步的，不要和异步高反了, active-low reset.

All DFFs should be triggered by the positive edge of `clk`.

```verilog
module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);
    always @(posedge clk) begin
        if (!resetn) begin
            q <= 'd0;
        end
        else begin
            q[15:8] <= byteena[1] ? d[15:8] : q[15:8];
            q[7:0] <= byteena[0] ? d[7:0] : q[7:0];
        end
    end
endmodule
```

## 7.D Latch

---

Implement the following circuit:

[![Exams m2014q4a.png](https://hdlbits.01xz.net/mw/images/0/03/Exams_m2014q4a.png)](https://hdlbits.01xz.net/wiki/File:Exams_m2014q4a.png)

Note that this is a latch, so a Quartus warning about having inferred a latch is expected.

```verilog
module top_module (
    input d, 
    input ena,
    output q);
    always @(*) begin
        if (ena) begin
            d <= q;
        end
    end
endmodule
```

## 8.DFF with gate

---

Implement the following circuit:

[![Exams m2014q4d.png](https://hdlbits.01xz.net/mw/images/f/f2/Exams_m2014q4d.png)](https://hdlbits.01xz.net/wiki/File:Exams_m2014q4d.png)

```verilog
module top_module (
    input clk,
    input in, 
    output out);
    wire d;
    reg q;
    assign d = in ^ out;
    assign out = q;
    always @(posedge clk) begin
        q <= d;
    end
endmodule
```

## 9.DFF + MUX - 0

---

Taken from ECE253 2015 midterm question 5

Consider the sequential circuit below:

[![Mt2015 muxdff.png](https://hdlbits.01xz.net/mw/thumb.php?f=Mt2015_muxdff.png&width=800)](https://hdlbits.01xz.net/wiki/File:Mt2015_muxdff.png)

Assume that you want to implement hierarchical Verilog code for this circuit, using three instantiations of a submodule that has a flip-flop and multiplexer in it. Write a Verilog module (containing one flip-flop and multiplexer) named `top_module` for this submodule.

```verilog
module top_module (
    input clk,
    input L,
    input r_in,
    input q_in,
    output reg Q);
    wire d;
    assign d = L ? r_in : q_in;
    always @(posedge clk) begin
        Q <= d;
    end
endmodule
```

## 10.DFF + MUX - 1

Consider the *n*-bit shift register circuit shown below:

[![Exams 2014q4.png](https://hdlbits.01xz.net/mw/thumb.php?f=Exams_2014q4.png&width=900)](https://hdlbits.01xz.net/wiki/File:Exams_2014q4.png)

Write a Verilog module named top_module for one stage of this circuit, including both the flip-flop and multiplexers.

```verilog
module top_module (
    input clk,
    input w, R, E, L,
    output Q
);
    wire x,d;
    assign x = E ? W : Q;
    assign d = L ? R : x;
    always @(posedge clk) begin
        Q <= d;
    end
endmodule
```

## 11.DFF + GATES

---

Given the finite state machine circuit as shown, assume that the D flip-flops are initially reset to zero before the machine begins.

Build this circuit.

Hint: Be careful with the reset state. Ensure that each D flip-flop's Q output is really the inverse of its Q output, even before the first clock edge of the simulation.

![Ece241 2014 q4.png](https://hdlbits.01xz.net/mw/images/d/d6/Ece241_2014_q4.png)

```verilog
module top_module (
    input clk,
    input x,
    output z
); 
    reg q0 = 'b0,q1 = 'b0, q2 = 'b0;
    wire q0_n,q1_n,q2_n,d0,d1,d2;
    assign q0_n = ~q0;
    assign q1_n = ~q1;
    assign q2_n = ~q2;
    assign d0 = x ^ q0;
    assign d1 = x & q1_n;
    assign d2 = x | q2_n;
    assign z = ~(q0 | q1 | q2);
    always @(posedge clk) begin
        q0 <= d0;
        q1 <= d1;
        q2 <= d2;
    end
endmodule
```

## 12.JK-FF[^2]

---

A JK flip-flop has the below truth table. Implement a JK flip-flop with only a D-type flip-flop and gates. Note: Qold is the output of the D flip-flop before the positive clock edge.

| J   | K   | Q     |
|:--- |:--- |:----- |
| 0   | 0   | Qold  |
| 0   | 1   | 0     |
| 1   | 0   | 1     |
| 1   | 1   | ~Qold |

```verilog
module top_module (
    input clk,
    input j,
    input k,
    output Q); 
    reg q;
    assign Q = q;
    // 真值表方式
    always @(posedge clk) begin
        case ({j,k})
            2'b00: q <= q;
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= ~q;
        endcase
    end
    // 公式
    // always @(posedge Clk) begin
    //    Q <= (J&(~Q))|((~K)&Q);
    // end
endmodule
```

## 13.Edge Detect

---

For each bit in an 8-bit vector, detect when the input signal changes from 0 in one clock cycle to 1 the next (similar to positive edge detection). The output bit should be set the cycle after a 0 to 1 transition occurs.

Here are some examples. For clarity, in[1] and pedge[1] are shown separately.

![Edge Detect](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220315145934275.png)

```verilog
module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
    reg [7:0] last_in;
    always @ (posedge clk)
        begin
            last_in <= in;
            pedge <= in & ~last_in;
        end
endmodule
```

## 14.EdgeDetect2

---

For each bit in an 8-bit vector, detect when the input signal changes from one clock cycle to the next (detect any edge). The output bit should be set the cycle after a 0 to 1 transition occurs.

Here are some examples. For clarity, in[1] and anyedge[1] are shown separately.

![in双边沿检测](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220317090850624.png)

```verilog
module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    reg [7:0] in_last;
    always @(posedge clk)
        begin
            in_last <= in;
            anyedge <= in_last ^ in;
        end
endmodule
```

## 15.EdgeCapture

---

For each bit in a 32-bit vector, capture when the input signal changes from 1 in one clock cycle to 0 the next. "Capture" means that the output will remain 1 until the register is reset (synchronous reset).

Each output bit behaves like a SR flip-flop: The output bit should be set (to 1) the cycle after a 1 to 0 transition occurs. The output bit should be reset (to 0) at the positive clock edge when reset is high. If both of the above events occur at the same time, reset has precedence. In the last 4 cycles of the example waveform below, the 'reset' event occurs one cycle earlier than the 'set' event, so there is no conflict here.

In the example waveform below, reset, in[1] and out[1] are shown again separately for clarity.

（注意这里的题意是捕捉下降沿）

![下降沿捕捉波形图](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220317092415643.png)

```verilog
module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);
    reg [31:0] in_last;
    always @(posedge clk) begin
        in_last <= in;
    end
    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin:my_gen
            always @ (posedge clk) begin
                if (reset) begin
                    out[i] <= 0;
                end
                else if (in_last[i] & ~in[i]) begin
                    out[i] <= 1'b1;
                end
                else
                    out[i] <= out[i];
            end
        end
    endgenerate
endmodule
```

## 16.Dualedge

---

You're familiar with flip-flops that are triggered on the positive edge of the clock, or negative edge of the clock. A dual-edge triggered flip-flop is triggered on both edges of the clock. However, FPGAs don't have dual-edge triggered flip-flops, and `always @(posedge clk or negedge clk)` is not accepted as a legal sensitivity list.

Build a circuit that functionally behaves like a dual-edge triggered flip-flop:

![waveform](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220317094907414.png)

```verilog
module top_module (
    input clk,
    input d,
    output q
);
    reg n,p;
    always @(posedge clk) begin
        n <= d;
    end
    always @(negedge clk) begin
        p <= d;
    end
    assign q = clk ? n : p;
endmodule
```

标答：

```verilog
module top_module(
    input clk,
    input d,
    output q);

    reg p, n;

    // A positive-edge triggered flip-flop
    always @(posedge clk)
        p <= d ^ n;

    // A negative-edge triggered flip-flop
    always @(negedge clk)
        n <= d ^ p;

    // Why does this work? 
    // After posedge clk, p changes to d^n. Thus q = (p^n) = (d^n^n) = d.
    // After negedge clk, n changes to p^n. Thus q = (p^n) = (p^p^n) = d.
    // At each (positive or negative) clock edge, p and n FFs alternately
    // load a value that will cancel out the other and cause the new value of d to remain.
    assign q = p ^ n;


    // Can't synthesize this.
    /*always @(posedge clk, negedge clk) begin
        q <= d;
    end*/

endmodule
```

## 总结

---

从13题开始，解题出现了困难。

13、14题的结题思路是一致的，关键点是明白要进行边沿检测，就应该将前一时刻和当前时刻的输入作比较，如果两个输入不同则是出现了边沿。

15题主要是理解题意的问题，要进行下边沿的捕捉，因此需要边沿的检测和锁存，检测的思路和13、14相同，而锁存的方式是通过if语句。

16题是双边沿检测的问题，这里是涉及到一个双边沿检测电路的代码综合的问题[^3]。注意具体的实现方法。

## 参考资料

[^1]: [Verilog寄存器电路描述（异步复位、异步置位等）_cjx_csdn的博客-CSDN博客_verilog寄存器](https://blog.csdn.net/cjx_csdn/article/details/105203494)

[^2]: [通过仿真和综合认识JK触发器（Verilog HDL语言描述JK触发器）_Reborn Lee-CSDN博客_jk触发器verilog代码](https://blog.csdn.net/reborn_lee/article/details/81331395)
[^3]: [verilog实现双边沿触发器Dual-edge triggered flip-flop_城外南风起的博客-CSDN博客_verilog 双边沿](https://blog.csdn.net/qq_38305370/article/details/111396429)
