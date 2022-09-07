---
title: 【ZYNQ7010】-00-使用FIFO读写ILA进行在线调试
mathjax: false
date: 2022-04-14 20:01:00
tags:
  - ZYNQ7010
categories:
  - 学习
---

> 本文整理自小熊猫学堂教学文档

## 简介

本文档实现采用在线调试FPGA的IP核ILA，在FPGA运行的时候抓取逻辑信号波形做分析。本例程可同时学习FIFO的IP核使用，FIFO在读写操作的时序和逻辑，以及在线调试ILA模块IP的使用方法 ， VIVADO的在线调试FPGA开发流程。工程新建方法请参考文档（2、VIVADO简介及软件下建立 ZYNQ工程模板教程.pdf）。

<!--more-->

## 实验步骤

参见原文档这个内容有亿点点多。

## 问题记录

1. 输出的信号的名称是ila的序号而不是对应的信号名称
   
   问题暂未解决，应该是代码部分有问题，暂时在文末附上正确的和我写的代码，日后做分析比较。
   
   将原有代码复制粘贴过来，问题仍然没有解决。应该是工程设置的问题，日后分析吧。
   
   ![我的IP设置_1](https://s2.loli.net/2022/04/18/6ApUl7McY5qLDEs.png)
   
   ![我的IP设置_2](https://s2.loli.net/2022/04/18/hIC6vMJ9mUnrbZe.png)
   
   ![我的IP设置](https://s2.loli.net/2022/04/18/WuMFhoqVJprvOLf.png "我的IP设置")

> 2022-09-05更新

名称出错也有可能是版本问题。

网上的一些做法是直接将原始信号连接到ila上面，名称未变。我这里是人为添加了一个wire包装一遍（显示的是wire的名称）。

还是不行，等到需要用ILA调试的时候再来看这个该怎么弄吧。感觉和版本以及IP的设置有关系。

## 附录

```verilog
// 问题记录1的正确代码
module fifo_ila_debug(
    input wire clk,
    input wire rstn
    );
    parameter STATE_IDLE='d0;
    parameter STATE_WRITE='d1;
    parameter STATE_READ='d2;

    parameter CLK_FREQ=50000000;//input clk 50m

    reg [31:0]counter_reg;
    reg [3:0]system_state_reg;
    reg [9:0]state_timeout_reg;

    reg [7:0]write_data_reg;
    wire[7:0] read_data;
    wire [7:0]write_data;
    reg read_en_reg;
    reg write_en_reg;
    wire is_write_read_flag;
    wire fifo_full;
    wire fifo_empty;

    wire [24:0]ila_probe0;
    wire read_en;
    wire write_en;
    wire [3:0]system_state;

    assign read_en=read_en_reg;
    assign write_en=write_en_reg;
    assign system_state=system_state_reg;
    assign write_data[7:0]=write_data_reg[7:0];
    assign is_write_read_flag=(system_state[3:0]==STATE_IDLE)?'b0:'b1;

    assign  ila_probe0[0]=is_write_read_flag;
    assign  ila_probe0[1]=write_en;
    assign  ila_probe0[2]=read_en;
    assign  ila_probe0[3]=fifo_full;
    assign  ila_probe0[4]=fifo_empty;   
    assign  ila_probe0[12:5]=write_data[7:0];
    assign  ila_probe0[20:13]=read_data[7:0];
    assign  ila_probe0[24:21]=system_state[3:0];
    //always block ,1s triger onece to read write
    always@(posedge clk or negedge rstn)begin
        if(rstn=='b0)begin
            counter_reg<='b0;
        end
        else begin
            if(counter_reg<(CLK_FREQ-'b1))counter_reg<=counter_reg+'b1;
            else counter_reg<='b0; 
        end
    end
   //state machine
    always@(posedge clk or negedge rstn)begin
        if(rstn=='b0)begin
            system_state_reg<='b0;
            state_timeout_reg<='b0;
        end
        else begin
           if(counter_reg==(CLK_FREQ-'b1))begin
                system_state_reg<=STATE_WRITE;
                state_timeout_reg<='b0;
           end
           else begin
                if(system_state_reg==STATE_WRITE)begin//write fifo state
                    if(state_timeout_reg<'d256)state_timeout_reg<=state_timeout_reg+'b1;
                    else begin
                         state_timeout_reg<='b0;
                         system_state_reg<=STATE_READ;
                    end
                end
                else  if(system_state_reg==STATE_READ)begin//read fifo state
                    if(state_timeout_reg<'d256)state_timeout_reg<=state_timeout_reg+'b1;
                    else begin
                         state_timeout_reg<='b0;
                         system_state_reg<=STATE_IDLE;
                    end
                end
           end
        end
    end   
   //write read logic generate
    always@(posedge clk or negedge rstn)begin
        if(rstn=='b0)begin
            write_data_reg<='b0;
        end
        else begin
            if(system_state_reg==STATE_WRITE)begin
                write_data_reg<=write_data_reg+'b1;
                read_en_reg='b0;
                write_en_reg<='b1;
            end
            else  if(system_state_reg==STATE_READ)begin
                write_data_reg<='b0;
                read_en_reg='b1;
                write_en_reg='b0;
            end
            else if(system_state_reg==STATE_IDLE)begin
                write_data_reg<='b0;
                read_en_reg='b0;
                write_en_reg='b0;
            end
        end
    end

    fifo_generator_0 fifo_generator_0_inst
    (
    .clk(clk),
    .srst(~rstn),
    .din(write_data),
    .wr_en(write_en),
    .rd_en(read_en),
    .dout(read_data),
    .full(fifo_full),
    .empty(fifo_empty)
    );

    ila_0 ila_0_inst
    (
    .clk(clk),
    .probe0(ila_probe0)
    );
endmodule
// 有问题的代码
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/14 20:14:13
// Design Name: 
// Module Name: fifo_ila_debug
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


module fifo_ila_debug(
    input wire  clk,
    input wire rstn
    );

parameter [2:0]     STATE_IDLE = 'd0,
                    STATE_WRITE = 'd1,
                    STATE_READ = 'd2;
parameter CLK_FREQ = 50000000; // input clk's frequency

reg [31:0] counter_reg;
reg [3:0] current_state;
reg [3:0] next_state;
reg [9:0] state_timeout_reg;

reg [7:0] write_data_reg;
wire [7:0] read_data;
wire [7:0] write_data;

reg read_en_reg;
reg write_en_reg;
wire read_en;
wire write_en;

wire is_write_read_flag;
wire fifo_full;
wire fifo_empty;

wire [24:0] ila_probe0;
wire [3:0] system_state;

assign read_en = read_en_reg;
assign write_en = write_en_reg;
assign system_state = current_state;
assign write_data[7:0] = write_data_reg[7:0];
assign is_write_read_flag = (system_state[3:0]==STATE_IDLE)?'b0:'b1;

assign ila_probe0[0] = is_write_read_flag;
assign ila_probe0[1] = write_en;
assign ila_probe0[2] = read_en;
assign ila_probe0[3]= fifo_full;
assign ila_probe0[4]= fifo_empty;
assign ila_probe0[12:5] = write_data[7:0];
assign ila_probe0[20:13] = read_data[7:0];
assign ila_probe0[24:21] = system_state[3:0];

// 1s triger once to read write
always @(posedge clk or negedge rstn) begin
    if ( !rstn ) begin
        counter_reg <= 0;
    end
    else begin
        if ( counter_reg < (CLK_FREQ - 1'b1)) 
            counter_reg <= counter_reg + 1'b1;
        else
            counter_reg <= 'b0;
    end
end
// state machine
always @(posedge clk or negedge rstn) begin
    if ( !rstn ) 
        current_state <= STATE_IDLE;
    else 
        current_state <= next_state;
end

always @(*) begin
    case ( current_state ) 
        STATE_IDLE:
            if (counter_reg == (CLK_FREQ - 1'b1))
                next_state = STATE_WRITE;
            else 
                next_state = STATE_IDLE;
        STATE_WRITE:
            if (state_timeout_reg == 'd256) 
                next_state = STATE_READ;
            else 
                next_state = STATE_WRITE;
        STATE_READ:
            if (state_timeout_reg == 'd256)
                next_state = STATE_IDLE;
            else
                next_state = STATE_READ;
        default:
            next_state = STATE_IDLE;
    endcase    
end

always @(*) begin  
    if (!rstn) begin
        read_en_reg = 'b0;
        write_en_reg = 'b0;
    end
    else begin
        case (current_state)
            STATE_WRITE:
                begin
                    read_en_reg = 'b0;
                    write_en_reg = 'b1;
                end
            STATE_READ:
                begin
                    read_en_reg = 'b1;
                    write_en_reg = 'b0;
                end
            STATE_IDLE:
                begin
                    read_en_reg = 'b0;
                    write_en_reg = 'b0;
                end
            default:
                begin
                    read_en_reg = 'b0;
                    write_en_reg = 'b0;
                end
        endcase
    end
end

always @(posedge clk or negedge rstn) begin  
    if (!rstn) begin
        write_data_reg <= 'b0;
    end
    else begin
        case (current_state)
            STATE_WRITE:
                write_data_reg <= write_data_reg + 'b1;
            STATE_READ:
                write_data_reg <= 'b0;
            STATE_IDLE:
                write_data_reg <= 'b0;
            default:
                write_data_reg <= 'b0;
        endcase
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        state_timeout_reg <= 0;
    end
    else begin
        case(current_state)
            STATE_WRITE:
                if (state_timeout_reg < 'd256) 
                    state_timeout_reg <= state_timeout_reg + 'b1;
                else
                    state_timeout_reg <= 'b0;
            STATE_READ:
                if (state_timeout_reg < 'd256) 
                    state_timeout_reg <= state_timeout_reg + 'b1;
                else
                    state_timeout_reg <= 'b0;
            default:
                state_timeout_reg <= 'b0;
        endcase 
    end
end

fifo_generator_0 fifo_generator_0_inst(
    .clk(clk),
    .srst(~rstn),
    .din(write_data),
    .wr_en(write_en),
    .rd_en(read_en),
    .dout(read_data),
    .full(fifo_full),
    .empty(fifo_empty)
);

ila_0 ila_0_inst
(
.clk(clk),
.probe0(ila_probe0)
);

endmodule
```
