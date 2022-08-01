---
title: 【Verilog学习】-02-向量
date: 2022-01-13 14:30:42
tags:
  - verilog
categories:
  - 学习
mathjax: true
---

## 向量

verilog的向量和C的向量（数组）不太一样，其的位数是写在名称的前面的，例如

```verilog
wire [7:0] w;
assign out = w[7];
```

在对向量赋值的时候，如果向量的位宽是相同的，就可以不用标明位；如果位宽不相同，则需要指明是那些位在进行assign

<!-- more -->

```verilog
input wire [2:0] vec;
output wire [2:0] outv;		//这个和上面的vec都是3位宽
wire [3:0] w1;				//w1是4位的位宽
assign w1[2:0] = vec;
assign outv = w1[2:0];		//或者直接 assign outv = vec;
```

### 向量定义

```verilog
type [upper:lower] vector_name;

// examples
wire [7:0] w;         // 8-bit wire
reg  [4:1] x;         // 4-bit reg
output reg [0:0] y;   // 1-bit reg that is also an output port (this is still a vector)
input wire [3:-2] z;  // 6-bit wire input (negative ranges are allowed)
output [3:0] a;       // 4-bit output wire. Type is 'wire' unless specified otherwise.
wire [0:7] b;         // 8-bit wire where b[0] is the most-significant bit.
```

注意：大小端的定义和使用要保持一致：

> e.g., writing `vec[0:3]` when `vec` is declared `wire [3:0] vec;` is illegal.

### 隐式线网

线网类型的信号能够被**隐式**地在assign语句中或者在某个模块的输入中用了没有定义的端口定义。

```verilog
wire [2:0] a, c;   // Two vectors
assign a = 3'b101;  // a = 101
assign b = a;       // b =   1  implicitly-created wire
assign c = b;       // c = 001  <-- bug
my_module i1 (d,e); // d and e are implicitly one-bit wide if not declared.
                    // This could be a bug if the port was intended to be a vector.
```

### 未压缩和压缩阵列（Unpacked vs. Packed Arrays）

未压缩维度是定义在名字的后面，这是和前面的区别，很好区分。

```verilog
module packed_unpacked_data();

// packed array
bit [7:0] packed_array = 8'hAA; 
// unpacked array
reg unpacked_array [7:0] = '{0,0,0,0,0,0,0,1}; 

initial begin
  $display ("packed array[0]   = %b", packed_array[0]);
  $display ("unpacked array[0] = %b", unpacked_array[0]);
  $display ("packed array      = %b", packed_array);
  // Below one is wrong syntax
  //$display("unpacked array[0] = %b",unpacked_array);
   #1  $finish;
end

endmodule
```

output:

```
packed array[0] = 0
unpacked array[0] = 1
packed array = 10101010
```

### 部分选择（Accessing Vector Elements: Part-Select）

对应于上面定义的信号：

```verilog
w[3:0]      // Only the lower 4 bits of w
x[1]        // The lowest bit of x
x[1:1]      // ...also the lowest bit of x
z[-1:-2]    // Two lowest bits of z
b[3:0]      // Illegal. Vector part-select must match the direction of the declaration.
b[0:3]      // The *upper* 4 bits of b.
assign w[3:0] = b[0:3];    // Assign upper 4 bits of b to lower 4 bits of w. w[3]=b[0], w[2]=b[1], etc.
```

练习，大小端的转换：

在x86系统中时小端模式，而在IP（Internet protocols）协议中，一般定义的是大端模式。设计一个模块进行大小端的转换：

```verilog
module top_module( 
    input [31:0] in,
    output [31:0] out );//
    assign out[31:24] = in[7:0];
    assign out[23:16] = in[15:8];
    assign out[15:8] = in[23:16];
    assign out[7:0] = in[31:24];
endmodule
```

### 逻辑运算与按位运算

按位运算是每一位作逻辑运算，然后整体输出，如果说输出的位宽小于输入的位宽，是以最低位输出的：

```verilog
assign out = a | b; //这里的a、b是三位位宽，out是一位位宽，则输出是最低为位0相或的结果
```

逻辑运算是把整个输入（不管多少位），按逻辑值来处理（0或者非0），输出是一位。

```verilog
assign out_or_bitwise = a | b;
assign out_or_logical = a || b;
```

上述式子中的out_or_bitwise是三位宽，out_or_logical是一位宽度，a、b同上。

### 串联运算符（concatenation operator）

串联运算符是指的是将几个位宽较小的数合成为一个位宽较大的一个数：

```verilog
{3'b111, 3'b000} => 6'b111000
{1'b1, 1'b0, 3'b101} => 5'b10101
{4'ha, 4'd10} => 8'b10101010     // 4'ha and 4'd10 are both 4'b1010 in binary
```

串联运算需要知道每一位数的位宽，因此需要对其进行位的标注{1，2，3}是非法的。

串联运算符号在assign的两边都可以使用：

```verilog
input [15:0] in;
output [23:0] out;
assign {out[7:0], out[15:8]} = in;         // Swap two bytes. Right side and left side are both 16-bit vectors.
assign out[15:0] = {in[7:0], in[15:8]};    // This is the same thing.
assign out = {in[7:0], in[15:8]};       // This is different. The 16-bit vector on the right is extended to
                                        // match the 24-bit vector on the left, so out[23:16] are zero.
                                        // In the first two examples, out[23:16] are not assigned.
```

练习，把输入串联之后，再给输出：

![Vector3](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/Vector3.png)

答案：

```verilog
module top_module (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z 
);//
    assign {w,x,y,z} = {a,b,c,d,e,f,2'b11};
endmodule
```

### 向量反转

#### 题目

将8位输入反转后输出。

#### 解法

这里可以直接像先前的方式对其进行直接的赋值，但是更好的方法是使用for循环。

怎么使用for循环呢？

这里原来的博主讲得太好了[Vectorr - HDLBits (01xz.net)](https://hdlbits.01xz.net/wiki/Vectorr)

```verilog
module top_module (
	input [7:0] in,
	output [7:0] out
);
	
	assign {out[0],out[1],out[2],out[3],out[4],out[5],out[6],out[7]} = in;
	
	/*
	// I know you're dying to know how to use a loop to do this:

	// Create a combinational always block. This creates combinational logic that computes the same result
	// as sequential code. for-loops describe circuit *behaviour*, not *structure*, so they can only be used 
	// inside procedural blocks (e.g., always block).
	// The circuit created (wires and gates) does NOT do any iteration: It only produces the same result
	// AS IF the iteration occurred. In reality, a logic synthesizer will do the iteration at compile time to
	// figure out what circuit to produce. (In contrast, a Verilog simulator will execute the loop sequentially
	// during simulation.)
	always @(*) begin	
		for (int i=0; i<8; i++)	// int is a SystemVerilog type. Use integer for pure Verilog.
			out[i] = in[8-i-1];
	end


	// It is also possible to do this with a generate-for loop. Generate loops look like procedural for loops,
	// but are quite different in concept, and not easy to understand. Generate loops are used to make instantiations
	// of "things" (Unlike procedural loops, it doesn't describe actions). These "things" are assign statements,
	// module instantiations, net/variable declarations, and procedural blocks (things you can create when NOT inside 
	// a procedure). Generate loops (and genvars) are evaluated entirely at compile time. You can think of generate
	// blocks as a form of preprocessing to generate more code, which is then run though the logic synthesizer.
	// In the example below, the generate-for loop first creates 8 assign statements at compile time, which is then
	// synthesized.
	// Note that because of its intended usage (generating code at compile time), there are some restrictions
	// on how you use them. Examples: 1. Quartus requires a generate-for loop to have a named begin-end block
	// attached (in this example, named "my_block_name"). 2. Inside the loop body, genvars are read only.
	generate
		genvar i;
		for (i=0; i<8; i = i+1) begin: my_block_name
			assign out[i] = in[8-i-1];
		end
	endgenerate
	*/
	
endmodule

```

这里主要介绍了两种for循环，一种是直接在时序模块中使用for循环，这种方式是相当于编译器帮你生成了相应的电路让它看起来就像是for循环在迭代（其实并没有迭代，而只是生成了相应的电路）；第二种方式是通过generate模块，这个模块的作用是相当于帮你循环生成了相应的代码，是在编译的时候，编译器帮你完成了代码的复用。

#### 程序报错

```cmd
Error (10644): Verilog HDL error at top_module.v(7): this block requires a name File: /home/h/work/hdlbits.3279882/top_module.v Line: 7
```

#### 原因

```verilog
module top_module( 
    input [7:0] in,
    output [7:0] out
);
generate
    genvar i;
    for(i = 0;i < 8;i = i + 1)begin:my_for_block	//这里忘记开始写模块的名称了，要加上:my_for_block
        assign out[i] = in[7 - i];					//小小提一嘴，assign是有方向的，只能够in->out
    end
endgenerate
endmodule
```

### 串联运算的复制操作

在串联运算中，可以对同一个元素重复，格式为{num{vector}}。

```verilog
{5{1'b1}}			// 5'b11111 (or 5'd31 or 5'h1f)
{2{a,b,c}}			// The same as {a,b,c,a,b,c}
{3'd5,{2{3'd6}}}	// 9'b101_110_110. It's a concatenation of 101 with
                    // the second vector, which is two copies of 3'b110.
```

> 最常见的重复操作是在符号位拓展的情况（保留符号位（sign-extending）），4'b**0**101->4'b**00000**101、4'b**1**101->4'b**111111**101

eg.保留符号位8->32位拓展：

```verilog
module top_module (
input [7:0] in,
output [31:0] out );//
    
    assign out = { {24{in[7]}} , in };

endmodule
```

eg.对五位的输入进行所有组合情况的比较，输出$C^{2}_{5}$种情况，如下所示：

![Vector5](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/Vector5.png)

```verilog
module top_module (
    input a, b, c, d, e,
    output [24:0] out );//

    assign out = ~{ {5{a}}, {5{b}}, {5{c}}, {5{d}}, {5{e}} } ^ { 5{a,b,c,d,e} };

endmodule
```

编译有一个warning：

```verilog
Warning (13024): Output pins are stuck at VCC or GND
```

这是因为在输出里面有一个值是永远不随输入变化的，在这里是由于存在像 assign a = a & a；这样的情况存在，在这个要求下是需要这样的，因此可以忽略这个warning。
