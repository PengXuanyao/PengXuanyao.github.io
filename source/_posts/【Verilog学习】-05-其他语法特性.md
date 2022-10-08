---
title: 【Verilog学习】-05-其他语法特性
mathjax: false
date: 2022-01-19 10:19:22
tags:
  - verilog
  - 组合逻辑
categories:
  - 学习
---

## 三元运算符

---

与C一样，这是一些例子：
<!--more-->

```verilog
Examples:

(0 ? 3 : 5)     // This is 5 because the condition is false.
(sel ? b : a)   // A 2-to-1 multiplexer between a and b selected by sel.

always @(posedge clk)         // A T-flip-flop.
  q <= toggle ? ~q : q;

always @(*)                   // State transition logic for a one-input FSM
  case (state)
    A: next = w ? B : A;
    B: next = w ? A : B;
  endcase

assign out = ena ? q : 1'bz;  // A tri-state buffer

((sel[1:0] == 2'h0) ? a :     // A 3-to-1 mux
 (sel[1:0] == 2'h1) ? b :
                      c )
```

## 缩减运算符

---

单目运算，用来简化运算操作：

```verilog
& a[3:0]     // AND: a[3]&a[2]&a[1]&a[0]. Equivalent to (a[3:0] == 4'hf)
| b[3:0]     // OR:  b[3]|b[2]|b[1]|b[0]. Equivalent to (b[3:0] != 4'h0)
^ c[2:0]     // XOR: c[2]^c[1]^c[0]
~& d[2:0]	//  NAND : ~ (d[2]&d[1]&d[0])
```

## 组合逻辑中的for-loop

---

将输入输出顺序反向：

```verilog
module top_module (
	input [99:0] in,
	output reg [99:0] out
);
	
	always @(*) begin
		for (int i=0;i<$bits(out);i++)		// $bits() is a system function that returns the width of a signal.
			out[i] = in[$bits(out)-i-1];	// $bits(out) is 100 because out is 100 bits wide.
	end
	
endmodule
```

## population count

计算输入中1的个数

```verilog
module top_module (
	input [254:0] in,
	output reg [7:0] out
);

	always @(*) begin	// Combinational always block
		out = 0;
		for (int i=0;i<255;i++)
			out = out + in[i];
	end
	
endmodule
```

## 设计一百位的全加器

注意这里generate里面的loop要有label，否则会报错

```verilog
module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );
    generate
        genvar i;
        for(i = 0; i < 100 ; i= i+1)begin:adder_loop	//这里要有这个babel
            if(i == 0)begin
                full_adder full_adder_inst(a[i],b[i],cin,cout[i],sum[i]);
            end
            else begin
                full_adder full_adder_inst(a[i],b[i],cout[i-1],cout[i],sum[i]);
            end
        end
    endgenerate
endmodule

module full_adder( 
    input a, b, cin,
    output cout, sum );
	assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & a) | (b & cin);
endmodule
```

也可以使用实例数组的写法，下一道道题尝试使用。尝试失败，因为需要用到中间的变量cout

>  [Verilog实例数组 - NeverCode - 博客园 (cnblogs.com)](https://www.cnblogs.com/nevercode/p/15201279.html)

```verilog
module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );
    wire [99:0] intermediate_cout;
    assign cout = intermediate_cout[99];
    generate
        genvar i;
        for(i = 0;i < 100;i=i+1)begin:bcd_loop
            if(i == 0)begin
                bcd_fadd bcd_fadd(a[4*(i+1)-1:4*i],b[4*(i+1)-1:4*i],cin,intermediate_cout[i],sum[4*(i+1)-1:4*i]);// 这里的写法有问题，不符合语法详j
            end
            else begin
                bcd_fadd bcd_fadd(a[4*(i+1)-1:4*i],b[4*(i+1)-1:4*i],intermediate_cout[i-1],intermediate_cout[i],sum[4*(i+1)-1:4*i]);
            end
        end
    endgenerate
endmodule0
```

