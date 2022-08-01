---
title: 【Verilog学习】-06-组合电路
mathjax: false
date: 2022-01-20 09:18:00
tags: 
  - verilog
categories:
  - 学习
---

这一章主要对组合逻辑电路的设计做了一个复习，前面也有比较多的涉及，因此下面仅记录一些关键点。

## 硬件设计思路

---

这里与软件的涉及不同，硬件设计主要是逆向的思考，即由想要的输出决定输入(assign ringer = ··· )。

<!--more-->

> **Design hint:** When designing circuits, one often has to think of the problem "backwards", starting from the outputs then working backwards towards the inputs. This is often the opposite of how one would think about a (sequential, imperative) programming problem, where one would look at the inputs first then decide on an action (or output). For sequential programs, one would often think "If (inputs are ___ ) then (output should be ___ )". On the other hand, hardware designers often think "The (output should be ___ ) when (inputs are ___ )".
> 
> The above problem description is written in an imperative form suitable for software programming (*if ring then do this*), so you must convert it to a more declarative form suitable for hardware implementation (`*assign ringer = ___*`). Being able to think in, and translate between, both styles is one of the most important skills needed for hardware design.

**这道题比较有意思：**

> You are given a 100-bit input vector in[99:0]. We want to know some relationships between each bit and its neighbour:
> 
> - **out_both**: Each bit of this output vector should indicate whether *both* the corresponding input bit and its neighbour to the **left** are '1'. For example, `out_both[98]` should indicate if `in[98]` and `in[99]` are both 1. Since `in[99]` has no neighbour to the left, the answer is obvious so we don't need to know `out_both[99]`.
> - **out_any**: Each bit of this output vector should indicate whether *any* of the corresponding input bit and its neighbour to the **right** are '1'. For example, `out_any[2]` should indicate if either `in[2]` or `in[1]` are 1. Since `in[0]` has no neighbour to the right, the answer is obvious so we don't need to know `out_any[0]`.
> - **out_different**: Each bit of this output vector should indicate whether the corresponding input bit is different from its neighbour to the **left**. For example, `out_different[98]` should indicate if `in[98]` is different from `in[99]`. For this part, treat the vector as wrapping around, so `in[99]`'s neighbour to the left is `in[0]`.

**solution:**

```verilog
module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    // See gatesv for explanations.
    assign out_both = in & in[99:1];
    assign out_any = in[99:1] | in ;
    assign out_different = in ^ {in[0], in[99:1]};

endmodule
```

可以用向量操作，比循环更方便。

## 多路选择器

---

### assign方式

`assign out = sel ? b : a;`

`assign out[99:0] = sel ? b[99:0] , a[99:0];`

```verilog
module top_module( 
    input [255:0] in,
    input [7:0] sel,
    output out );
    assign out = in[sel];
endmodule
```

### case 方式（适用于较多的情况）

```verilog
always @(*) begin
        out = '1;     // '1 is a special literal syntax for a number with all bits set to 1.
                    // '0, 'x, and 'z are also valid.
                    // I prefer to assign a default value to 'out' instead of using a
                    // default case.
        case(sel)
            4'd0: out = a;
            4'd1: out = b;
            4'd2: out = c;
            4'd3: out = d;
            4'd4: out = e;
            4'd5: out = f;
            4'd6: out = g;
            4'd7: out = h;
            4'd8: out = i;
            //default:
            //    out = 16'hffff;
        endcase
    end
```

在写Verilog的时候比较好的习惯是写一个begin就写一个end，避免出现语法错误。

## 加法器

---

全加器的写法在05节中已经详细讨论过，这里也可以使用verilog自带的+法。

```verilog
module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    // This circuit is a 4-bit ripple-carry adder with carry-out.
    assign sum = x+y;    // Verilog addition automatically produces the carry-out bit.

    // Verilog quirk: Even though the value of (x+y) includes the carry-out, (x+y) is still considered to be a 4-bit number (The max width of the two operands).
    // This is correct:
    // assign sum = (x+y);
    // But this is incorrect:
    // assign sum = {x+y};    // Concatenation operator: This discards the carry-out
endmodule
```

### 补码加法及其溢出判断

通过比较输入输出的符号（--得+，++得-为溢出）：

```verilog
module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
); //

    // assign s = ...
    // assign overflow = ...
    assign s = a + b;
    assign overflow = (a[7] & b[7] & ~s[7]) | (~a[7] & ~b[7] & s[7]);
endmodule
```

通过比较最高两位的溢出：（因此要计算出所有的进位）

```verilog
module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
); 
    wire [7:0] cout;
    integer i;
    always @(*) begin
        for(i=0;i<8;i=i+1)begin
            if(i == 0)
            {cout[i],s[i]} = a[i] + b[i];
            else
            {cout[i],s[i]} = a[i] + b[i] + cout[i-1];
        end
    end
    assign overflow = cout[7] ^ cout[6];
endmodule
```

## 100位的全加器（使用+）

```verilog
module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );
    assign {cout, sum} = a + b + cin;
endmodule
```

05章节里里面的方法更为原始直接。

## BCD adder

```verilog
module top_module( 
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );
    assign sum = a + b;
    assign 
endmodule
```

### 再谈多路选择器

> Create a 4-bit wide, 256-to-1 multiplexer. The 256 4-bit inputs are all packed into a single 1024-bit input vector. sel=0 should select bits `in[3:0]`, sel=1 selects bits `in[7:4]`, sel=2 selects bits `in[11:8]`, etc.

这道题涉及到的问题是由于不能够直接使用`in[ sel * 4+3 : sel*  4 ]`，因为变量sel的宽度不确定。

博客中，给了更为紧凑的语法，就是Indexed vector part select（下标向量的部分选择）[^1]。

代码如下：

```verilog
module top_module( 
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out );
    assign out[3:0] = in[sel*4 :4];
endmodule

// 参考答案：
module top_module (
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // We can't part-select multiple bits without an error, but we can select one bit at a time,
    // four times, then concatenate them together.
    assign out = {in[sel*4+3], in[sel*4+2], in[sel*4+1], in[sel*4+0]};

    // Alternatively, "indexed vector part select" works better, but has an unfamiliar syntax:
    // assign out = in[sel*4 +: 4];        // Select starting at index "sel*4", then select a total width of 4 bits with increasing (+:) index number.
    // assign out = in[sel*4+3 -: 4];    // Select starting at index "sel*4+3", then select a total width of 4 bits with decreasing (-:) index number.
    // Note: The width (4 in this case) must be constant.

endmodule
```

题目分析如下，当输入有一个发生变化时（相邻的方格中可以看到），输出就会发生反转。就是输入异或的结果。

![image-20220209223151265](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220209223151265.png)

也可以通过化简SOP得到。

[^1]: [Verilog-2001的向量部分选择_LuchangLi 的专栏-CSDN博客_verilog 向量部分选择](https://blog.csdn.net/u013701860/article/details/52317614)
