---
title: 【Verilog学习】-03-模块
date: 2022-01-14 15:40:04
tags:
  - verilog
categories:
  - 学习
---

## verilog模块的实例化

### 模块的信号连接

模块的信号的连接有两种方式：一种是通过位置（顺序）来进行连接，另一种是通过名称来进行连接。顺序连接的方式和C语言的函数的用法类似，直接按顺序写，例如：

<!--more-->

#### 按顺序位置

```verilog
module mod_a ( input in1, input in2, output out );
    // Module body
endmodule

mod_a instance1 ( wa, wb, wc );
```

即是通过顺序输入来进行（wa->in1，wb->in2，wc->out）。

#### 按名称

```verilog
mod_a instance2 ( .out(wc), .in1(wa), .in2(wb) );
```

按名称的例化不需要按顺序对其进行赋值，直接通过名称的依次对应来完成。

>```cmd
>Error (10267): Verilog HDL Module Instantiation error at top_module.v(9): cannot connect instance ports both by order and by name File: /home/h/work/hdlbits.3288734/top_module.v Line: 9
>```
>
>出现这个报错的原因：
>
>```verilog
>mod_a instance2(.out1(out1), .out2(out2), .in1(a), .in2(b), .in3(c), in4(d));
>```
>
>上面的最后一个in忘记了前面的一个点
>
>```verilog
>mod_a instance2(.out1(out1), .out2(out2), .in1(a), .in2(b), .in3(c), .in4(d));
>```

> tips：在verilog中，向量的赋值不需要严格的匹配，但是会导致有0填充没有匹配的位或者编译器去欺骗向量的现象，不太建议

> ```verilog
> wire [7:0] q1,q2,q3;
> ```
>
> 这样是定义了三个8位的线网类型的变量。

> assign不能定义在always模块中
>
> 作选择可以用assign sum[31:16] = carry?sum1:sum0;或者就写在always块中用case

> ```verilog
> module top_module(
>     input [31:0] a,
>     input [31:0] b,
>     input sub,
>     output [31:0] sum
> );
>     wire carry;
>     wire [31:0] b_n;
>     assign b_n = b^{32{sub}};	//取反操作
>     add16 ins_add_0(a[15:0],b_n[15:0],sub,sum[15:0],carry);		//sub是减法标志：
>     												//如果sub是0：做加法a+b+0
>     												//如果sub是1：做减法a+(~b)+1
>     add16 ins_add_1(a[31:16],b_n[31:16],carry,sum[31:16]);
> endmodule
> ```
>
> 这是减法器（补码减法，等于变补加法），注意最低位有进位sub。

