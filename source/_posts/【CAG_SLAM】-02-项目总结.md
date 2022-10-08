---
title: 【CAG-SLAM】-02-项目总结
date: 2022-01-17 16:03:53
tags:
  - verilog
  - 踩坑
categories:
  - 科研
  - 工作
---

给关于这个小项目，里面涉及到的内容其实并不复杂，但是也花费了我两周的时间去完成和整理，可能在和学长的其他模块进行组合的时候还会出现一些其他的问题。总之，并不是一次特别满意的开发经历，但是我也在过程中，学习了很多项目之外的东西。正如我正是为了这点醋，包的这顿饺子。

<!--more-->

以下是接口的定义，电路功能说明以及项目的源码：

## 接口定义

---

| 名称    | 方向 | 位宽 (bit) | 描述                                               |
| ------- | ---- | ---------- | -------------------------------------------------- |
| clk     | in   | 1          | 时钟信号                                           |
| din     | in   | 8×8        | 8个8位数据输入                                     |
| rst_n   | in   | 1          | 低有效复位信号（清零所有寄存器）                   |
| valid_i | in   | 1          | 表示当前时刻输入为有效信号                         |
| flag    | in   | 8          | 8位分别表示8个输入数据是否有效                     |
| addr_1  | out  | 10         | 第一层24×24个数据中的最大值的行列（分别占5位）坐标 |
| addr_2  | out  | 10         | 第二层24×24个数据中的最大值的行列（分别占5位）坐标 |
| valid_o | out  | 1          | 当前时刻输出的数据为有效数据                       |



## 电路功能描述

---

输入一共为24×24×2个数据，每次输入8个数据，串行输入144组后，两个clk延迟后，输出两层的最大值坐标信息（此时valid_o有效，持续一个周期）。

当rst_i低有效的时候（至少一个clk延迟），所有寄存器全部清零，处于置位状态。

当rst_i从有效变为无效时，此时电路处于等待输入的状态，当valid_i有效时，表明当前时刻的输入有效，将其输入；当valid_i无效时，表示当前的输入无效，忽略此时刻的输入。对于有效的输入数据中，如果其flag为0，也认为其是无效的，将其置零。当输入完成144组后，完成输入，两个clk延迟后，输出两层的最大值坐标信息。

## 源代码（verilog）

---

```verilog
module my_get_max#(
parameter DW = 8,   //data width
parameter DN = 8,   //data number
parameter AW = 5   //output addr width
)(
input clk,
input [DN*DW-1 :0] din,
input rst_n,
input valid_i,
input [DN-1:0] flag,
output valid_o,
output [9:0] addr1, //final output addr1锛add the row_index and col_index to it
output [9:0] addr2, //final output addr2锛add the row_index and col_index to it
//以下信号为观察波形方便调试，验证后可定义为内部寄存器（max1、max2可以不用，但是其余四个需要定义为内部寄存器）
output reg [DW-1:0] max1,
output reg [DW-1:0] max2,
output reg [AW-1:0] row_index1,
output reg [AW-1:0] row_index2,
output reg [AW-1:0] col_index1,
output reg [AW-1:0] col_index2
);

//generate assign the input signal
wire [DW-1:0] d[DN-1:0];
generate
    genvar i;
    for(i=0;i<DN;i=i+1)begin:loop_assign
        assign d[i] = flag[i]?din[DW*i+DW-1:DW*i]:1'b0;
    end
endgenerate

//first stage of the comparison tree
reg [DW-1:0] s1_max1[DN/2-1:0];
reg [DW-1:0] s1_max2[DN/2-1:0];
reg [1:0] s1_addr1[1:0];
reg [1:0] s1_addr2[1:0];
// stage 1: first layer
always @(posedge clk) begin
    if(rst_n && valid_i)begin   //when rst_n not valid and valid_i is ok, the circuit work
        if(d[0]>d[1])begin//flag有效才输入数据
            s1_max1[0] <= d[0];
            s1_addr1[0] <= 2'b0;
        end
        else begin
            if(d[1]>d[0]) begin 
                s1_max1[0] <= d[1];
                s1_addr1[0] <= 2'b01;
            end
        end
    end
    else begin
        s1_max1[0]  <= 1'b0;
        s1_addr1[0] <= 2'b0;
    end
end
always @(posedge clk) begin
    if(rst_n && valid_i)begin
        if(d[2]>d[3])begin
            s1_max1[1] <= d[2];
            s1_addr1[1] <= 2'b10;
        end
        else begin
            if(d[3]>d[2])begin
                s1_max1[1] <= d[3];
                s1_addr1[1] <= 2'b11;
            end
        end
    end
    else begin
        s1_max1[1]  <= 1'b0;
        s1_addr1[1] <= 2'b0;
    end
end
// stage 1: second layer
always @(posedge clk) begin
    if(rst_n && valid_i)begin
        if(d[4]>d[5])begin
            s1_max2[0] <= d[4];
            s1_addr2[0] <= 2'b00;
        end
        else begin
            if(d[5]>d[4]) begin
                s1_max2[0] <= d[5];
                s1_addr2[0] <= 2'b01;
            end
        end 
    end
    else begin
        s1_max2[0]  <= 1'b0;
        s1_addr2[0] <= 2'b0;
    end
end
always @(posedge clk) begin
    if(rst_n && valid_i)begin
        if(d[6]>d[7])begin
            s1_max2[1] <= d[6];
            s1_addr2[1] <= 2'b10;
        end
        else begin 
            if(d[7]>d[6])begin
                s1_max2[1] <= d[7];
                s1_addr2[1] <= 2'b11;
            end
        end
    end
    else begin
        s1_max2[1] <= 1'b0;
        s1_addr2[1] <= 2'b0;
    end 
end

//second stage of the comparison tree
reg [DW-1:0] tmp_max1 = 8'b0;
reg [DW-1:0] tmp_max2 = 8'b0;
reg [1:0] tmp_addr1 = 2'b0;
reg [1:0] tmp_addr2 = 2'b0;
// stage 2: first layer
always @(posedge clk) begin
    if(!rst_n)begin
        tmp_max1 <= 1'b0;
        tmp_addr1 <= 1'b0;
    end
    else begin
        if(s1_max1[0]>s1_max1[1])begin
            tmp_max1 <= s1_max1[0];
            tmp_addr1 <= s1_addr1[0];
        end 
        else begin
            tmp_max1 <= s1_max1[1];
            tmp_addr1 <= s1_addr1[1];
        end
    end 
end
// stage 2: second layer
always @(posedge clk) begin
    if(!rst_n)begin
        tmp_max2 <= 1'b0;
        tmp_addr2 <= 1'b0;
    end
    else begin
        if(s1_max2[0]>s1_max2[1])begin
            tmp_max2 <= s1_max2[0];
            tmp_addr2 <= s1_addr2[0];
        end
        else begin
            tmp_max2 <= s1_max2[1];
            tmp_addr2 <= s1_addr2[1];
        end
    end 
end

// reg [1:0] row_count_base = 1'b0; // row base counter
reg [AW-1:0] row_count = 1'd0;  // row number
reg [AW-1:0] col_count = 1'd0;  // col number
reg [7:0] count_vo = 1'b0; //count when the data output(valid_o) is ok
reg reg_vo = 1'b0;
//valid_o output
always @(posedge clk) begin
    if(!rst_n)begin
        count_vo <= 1'b0;
        reg_vo <= 1'b0; 
    end
    else begin
        if(valid_i)begin
            count_vo <= count_vo + 1'b1;
        end
        if(count_vo == 8'd143)begin
            count_vo <= 1'b0;
            reg_vo <= 1'b1; 
        end
        if(count_vo == 8'd0)begin
            reg_vo <= 1'b0; 
        end
    end
end
shift_reg_1 vo_s_reg(reg_vo,clk,rst_n,valid_o);
// generate the col_count for col_index
always @(posedge clk) begin
    if(!rst_n)begin
        col_count <= 1'b0;
        row_count <= 1'b0;
    end
    else begin
        if(valid_i)begin
            if(col_count == 3'd5)begin  //counter mod 6
                if(row_count == 5'd23)begin
                    row_count <= 1'b0;
                end
                else begin
                    row_count <= row_count + 1'b1;
                end
                col_count <= 1'b0;
            end
            else begin
                col_count <= col_count + 1'b1;
            end
        end
    end
end

//push the col and row count into the shift_reg
wire [AW-1:0] col_count_d;
wire [AW-1:0] row_count_d;
shift_reg_5 s_reg1(row_count,clk,rst_n,row_count_d);
shift_reg_5 s_reg2(col_count,clk,rst_n,col_count_d);

//get the max of all, including the addr of max 
always @(posedge clk) begin
    if (!rst_n) begin
        max1  <= 1'b0;
        row_index1 <= 1'b0;
        col_index1 <= 1'b0;
    end
    else begin
        if(tmp_max1 > max1 && rst_n)begin
            max1 <= tmp_max1;
            row_index1 <= row_count_d ;
            col_index1 <= (col_count_d * 3'd4 + tmp_addr1) ;
        end
        else begin
            max1  <= max1;
        end
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        max2 <= 1'b0;
        row_index2 <= 1'b0;
        col_index2 <= 1'b0;
    end
    else begin
        if(tmp_max2>max2)begin
            max2 <= tmp_max2;
            row_index2 <= row_count_d;
            col_index2 <= (col_count_d * 3'd4 + tmp_addr2); 
        end
        else begin
            max2 <= max2;
        end
    end
end

// 最后输出的地址
assign addr1 = {row_index1[4:0],col_index1[4:0]};
assign addr2 = {row_index2[4:0],col_index2[4:0]};
endmodule

//shift module for addr
module d_ff_5 (
    input [4:0]  d,     //[AW-1:0]=4
    input clk,
    input rst_n,
    output reg [4:0] q   
);
always @(posedge clk) begin
    if(!rst_n)begin
        q <= 1'b0;
    end
    else begin
        q <= d;
    end
end
endmodule

module shift_reg_5 (
    input [4:0] d,
    input clk,
    input rst_n,
    output [4:0] q
);
wire [4:0] w1;
d_ff_5 d_ff1(d,clk,rst_n,w1);
d_ff_5 d_ff2(w1,clk,rst_n,q);
endmodule

//shift_module for valid_o
module d_ff_1 (
    input  d,     //[AW-1:0]=4
    input clk,
    input rst_n,
    output reg q   
);
always @(posedge clk) begin
    if(!rst_n)begin
        q <= 1'b0;
    end
    else begin
        q <= d;
    end
end
endmodule

module shift_reg_1 (
    input d,
    input clk,
    input rst_n,
    output q
);
wire w1;
d_ff_1 d_ff1(d,clk,rst_n,w1);
d_ff_1 d_ff2(w1,clk,rst_n,q);
endmodule
```



