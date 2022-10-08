---
title: 【Verilog学习】-04-程序
mathjax: false
date: 2022-01-16 21:02:43
tags:
  - verilog
categories:
  - 学习
---

这里的取题目名字程序其实不是特别好，这里应该主要是procedure，也就是always、initial等其他模块包含的那一段代码。

## always(组合电路)

---

always模块可以用来生成组合电路，其和块外面的assign有着相同的作用，主要是语法方面有着一定的区别。

在always块中使用组合逻辑，输出（也就是被驱动的等式的左边）需要用寄存器类型的变量。例如下面两种写法的功能是一样的。

<!--more-->

```verilog
module top_module(
    input a, 
    input b,
    output wire out_assign,
    output reg out_alwaysblock
);
	assign out_assign = a & b;
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule
```

这里的(*)是指的是敏感列表，如果是组合逻辑的话，需要用这样的写法，如果把所有的信号列出来会容易出错，十分不建议。

## always(时序电路（clocked）)

---

阻塞和非阻塞赋值（Blocking and Non-Blocking Assignment）

- **Continuous** assignments (`assign x = y;`). Can only be used when **not** inside a procedure ("always block").
- Procedural **blocking** assignment: (`x = y;`). Can only be used inside a procedure.
- Procedural **non-blocking** assignment: (`x <= y;`). Can only be used inside a procedure.

阻塞赋值和非阻塞赋值都是指的是procedure中的一部分，组合逻辑中用阻塞赋值，时序逻辑中用非阻塞赋值。

## if

---

在使用if语句的时候，要考虑到所有的情况。如果有情况没有考虑到，也就是else没有写，那么，在生成电路的时候，编译器就会默认将其保持不变，即会产生一个锁存器（Latche），因此，需要考虑这个锁存器的影响。

也就是说要写成下面这种完整的形式：

```verilog
if(flag)begin
end
else begin
    if(flag_1)begin
    end
    else begin
    end
end
```

## case

---

语法结构

```verilog
always @(*) begin     // This is a combinational circuit
    case (in)
      1'b1: begin 
               out = 1'b1;  // begin-end if >1 statement
            end
      1'b0: out = 1'b0;
      default: out = 1'bx;
    endcase
end
```

语法和C有点区别：没有switch，不用break，case可以有重复的情况

## casez

---

```verilog
always @(*) begin
    casez (in[3:0])
        4'bzzz1: out = 0;   // in[3:1] can be anything
        4'bzz1z: out = 1;
        4'bz1zz: out = 2;
        4'b1zzz: out = 3;
        default: out = 0;
    endcase
end
```

casez只关心某一位，并且逻辑上是顺序去判断（通过增加相应的电路）。

在写case语句的时候可以提前赋上初值，这样可以减少代码量：

```verilog
//直接考虑所有情况
always@(*)begin
    casez(scancode)
        16'he06b: begin up = 1'b0; down = 1'b0; left = 1'b1; right = 1'b0; end
        16'he072: begin up = 1'b0; down = 1'b1; left = 1'b0; right = 1'b0; end
        16'he074: begin up = 1'b0; down = 1'b0; left = 1'b0; right = 1'b1; end
        16'he075: begin up = 1'b1; down = 1'b0; left = 1'b0; right = 1'b0; end
        default:  begin up = 1'b0; down = 1'b0; left = 1'b0; right = 1'b0; end
    endcase
end
//赋“初值”后，只需要考虑变化的情况。
always@(*)
begin
    up = 1'b0; down = 1'b0; left = 1'b0; right = 1'b0;
    casez(scancode)
        16'he06b: left = 1'b1;
        16'he072: down = 1'b1;
        16'he074: right = 1'b1; 
        16'he075: up = 1'b1;
        default: begin
            up = 1'b0; down = 1'b0; left = 1'b0; right = 1'b0;
        end
    endcase
end
```

