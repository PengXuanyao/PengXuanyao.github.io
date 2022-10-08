---
title: 【Verilog学习】-01-组合逻辑
date: 2022-01-12 22:06:51
tags:
  - 组合逻辑
  - verilog
categories:
  - 学习
---



今天，温习了一下，verilog的组合逻辑的知识，下面是一些新的理解和总结：

- 要把~、|、^、&这些符号看成是一个门，特别是以此作为assign的赋值的时候，其实就是生成了一个门，例如;

  ```verilog
  assign out = a|b;
  ```

- wire类型的信号只能被一个信号驱动（例如，一个门的输出），但是可以同时给多个信号赋值。（只能做一次右端）

  ```verilog
  wire a,b,c,out,out_n；
  assign out = a | b;			//被一个信号（与门的输出驱动）
  assign out_n = ~out;		//可以去驱动多个信号
  assign c = ~out | a;		//驱动第二个信号
  ```

