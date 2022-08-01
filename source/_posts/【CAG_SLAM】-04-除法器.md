---
title: 【CAG_SLAM】-04-除法器
mathjax: false
date: 2022-03-17 11:06:10
tags:
  - verilog
categories:
  - 学习
---

## 除法器基本思路

---

对于变量输入的除法中，使用最基础的除法器[^1]。

对于更加具体的除法器的设计可以采用更加灵活的方案：

例如：设计 X / 24 的除法器时，将其分解为 X / 8 * (1 / 4 +  1 / 16 + 1/64 + ···)的形式。，通过加法和移位操作进行处理[^2]。对于其他的被除数，都可以表示为1 / 2 ^ a 的形式进行处理。

跟多的除法器的原理参见一些Stanford的内容[^ 3]。

## 除法器的实现

---

关于除法器的设计过程，非常地不顺利，并且第一次设计出来的方案也并不好。这主要是由于读别人的代码少了，输入不够，导致自己的输出并没能达到老师的要求。最后，通过查阅StackOverflow等网站的文章，勉强搞定了设计。这里简单总结一下经验教训：

- 思考要谨慎，不要因为一时的得失而忘形或失意。
- 做事之前一定要有相关的输入，借鉴和思考别人的经验
- 时间安排要合理一些

### 最后方案

---

A / 24 = A / 8 / 3 = A / 8 * (1 / 4 + 1/ 16 + 1 / 64 + ··· ) = A >> 3 * ( A >> 2 + A >> 4 + A >> 6 ···) = A >> 5 + A >> 7 + A >> 9 ···

最后注意24的整数倍时存在一个舍入误差即可；verilog中的reg并不是一定是寄存器register，其只是一个存储单元，可以改变內部值，相当于是一个变量。

### 源代码

```verilog
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 19:46:06
// Design Name: 
// Module Name: div_24
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
module div_24#(
    parameter DW = 12,	// data width
	parameter RW = 5 	// remainder datawidth, independing on the divisor(eg.for 24 < 32 -> 5)
)(
    input clk_i,
    input rst_n_i,
    input valid_i,
    input [DW - 1 : 0] d_i,
    output reg div_busy_o,
    output reg valid_o,
    output [DW - 1 : 0] result_o,
    output [DW-1 : 0] remainder_o
    );
    // d and result is the extended of d_i and result, with DW with of the decimal
    reg [2*DW - 1 : 0] d = 0;
    reg [DW - 1:0] remainder_origin = 0;
    wire [DW - 1:0] remainder;
    wire [2*DW-1 : 0] result;
    // get the data
    always @(posedge clk_i) begin
        if (!rst_n_i) begin
            d <= 0;
            div_busy_o <= 0;
        end
        else if (valid_i && !div_busy_o) begin
				// add 1 used to offset the round-off error
            d[2*DW - 1 : DW] <= d_i + 1'b1;
            div_busy_o <= 1'b1;
        end
        else if (div_busy_o) begin
            div_busy_o <= 1'b0;
        end
    end
	// calculate the result
    assign result = ( d >> 5 ) + ( d >> 7 ) + ( d >> 9 ) + ( d >> 11 ) + ( d >> 13 ) + ( d >> 15 );
    // result for output
    assign result_o = result[2*DW-1 : DW];
    always @(*) begin
        // get result for calculate remainder
		  if (!rst_n_i) begin
			  remainder_origin = 0;
		  end
		  else begin
			  remainder_origin = result[2*DW-1 : DW];
		  end
    end
    // calculate remainder
	 // - A = + ~A + 1'B1 -> + ~ A = - A - 1'B1 ; -1'B1 TO OFFSET line51 +1'B1 
    assign remainder = d[2*DW-1:DW] - (remainder_origin << 3) + ~(remainder_origin << 4);
    // remainder for output
    assign remainder_o = remainder[DW - 1:0];
    // set valid_o
    always @(posedge clk_i) begin
        if (div_busy_o) begin
            valid_o <= 1'b1;
        end
        else begin
            valid_o <= 1'b0;
        end
    end
endmodule
```



## 参考文献

---

[^1]: [Division in Verilog | Project F - FPGA Development](https://projectf.io/posts/division-in-verilog/)
[^2]: [vhdl - Easy way of dividing an integer by 3 - Stack Overflow](https://stackoverflow.com/questions/33006842/easy-way-of-dividing-an-integer-by-3/33006927#33006927?newreg=ade5853a091141fda460a6d43d0cef97)
[^ 3]: [Bit Twiddling Hacks (stanford.edu)](http://graphics.stanford.edu/~seander/bithacks.html#ModulusDivisionEasy)
[^4]: [Is it possible to shift more than 1 bit per cycle in verilog? - Stack Overflow](https://stackoverflow.com/questions/36091140/is-it-possible-to-shift-more-than-1-bit-per-cycle-in-verilog)
