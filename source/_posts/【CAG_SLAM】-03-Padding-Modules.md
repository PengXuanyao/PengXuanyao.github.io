---
title: 【CAG_SLAM】-03-Padding-Modules
date: 2022-02-28 16:24:45
tags: 
  - verilog
categories: 
  - 科研
  - 工作
---

## 功能描述

---

对输入的图像信号进行裁边和填充0的操作，裁边的具体操作为，保持裁边后的图像的可以被分成整数个24*24（像素为单位）的block，裁边选择的方向是上边和右边的部分；裁边完成后，将图像四周用0进行padding，宽度为21像素。

每次进行像素的输入是通过每次输入4个像素（4`*`8bit），一直输入完所有的像素，再进行裁边的操作。图像数据的大小可以提前知道，例如（1241`*`376，1242`*`375）两种情况。因此，可以等到所有数据输入完成再进行裁边，或者边输入，边裁边输出。

输入包括图像的大小（宽和高），fast_busy是否繁忙，若繁忙，则需要等待，还有一个有效的valid_i信号;

输出包括本模块的busy和valid，以及每次四个像素进行输出

![padding模块功能示意图](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220228163415745.png)
<!-- more -->
## 实现方法

---

知道了图像的长和宽，就可以统计输入理论上需要的周期，在这个周期中，就可以采取计数器的方法，对其当前的信号计数从而确定坐标的位置（可以分别进行行、列坐标的计数），同时，有两种方式进行输出，一种是通过用寄存器数组记录下所有的数据，然后，再将这些数据最后一起输出；另一种方式是，判断当前坐标是否应该出现再输出的信号中，如果出现在输出信号中，应该出现在哪一个位置，有计数器判断其输出的时刻，做到一边输入一边输出。

## 具体实现

---

通过两种方案，输入完成后再输出和一边输入一边输出。

![方案讨论](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220228173722893.png)

### 方案一实现

方法一实现过于简单粗暴，其会采用将会浪费大量的存储空间并且其效率也较低，会有大量的迟滞等待输入的时间，因此这里不予讨论。

### 方案二实现

方案二实现的效率和存储空间均有一定的改善，因此，这里进行详细的讨论。由于在输入端加入了控制读入的信号，因此，输出的逻辑变得简单了。

仅需要在输入信号中，pdg_busy_o为低电平、data_i输入为高电平，就按照clock输出当前输入的值即可，同时在输出也应该有输出有效的信号，需要在有效输出前先将其置高，然后再在输出无效时将其拉低。

方案二的实现中，涉及到使用一个触发器的问题，直接使用触发器会占用大量的资源。这里决定用多个周期计算，来减小资源的消耗。

#### 除法器

这里需要一个除以24的除法器，如果直接使用verilog自带的除法运算，在进行取余操作时，会花费大量的资源，即使做到了单个时钟周期的延时。这里为了减少资源的消耗，将单个周期的运算化为多个运算，运用类似逐次比较的方法，加上不同的权（weight）后，比较其数值大小，进而得到最后的答案。

在每次开始比较时，将当前位先置为1，然后比较后，如果发现比被除数小，再进行取反操作置零。操作结束的标志是。

##### DEBUG-01

第一次写的逻辑总体上是正确的，但是在最后一次比较出现了一点问题。代码如下：

```verilog
// 这里的weight是不同位上为1的数（可以看作是二进制数的不同位的权值），但是我一开始对其定义的就是比result低了一位开始，导致当result去比较最低位的时候，权值weight已经变成0了。因此，需要将weight从result相同的位开始，进行比较、移位和判断。
// the start, set the dividend and busy signal.
if(valid_i == 1'b1 && div_mod_busy_o == 1'b0)begin
    dividend <= dividend_i;
    div_mod_busy_o <= 1'b1;
    weight <= 1'b1<<(BW-2);	// here should not be like this, which can be replaced by weight <= 1'b1<<(BW-1).And some logical in processiong should be changed
    result_o <= 1'b1<<(BW-1);
    counter <= 4'd12;
end
......
// the processing, count and compare.
else begin
    if( dividend > (result_o * 24))begin
        result_o <= result_o + weight;    
    end
    else begin
        if(dividend < (result_o * 24))begin
            result_o <= (result_o & ~(weight<<1)) + weight;
        end
        else begin
            result_o <= result_o;
            counter <= 1'b0;
        end
    end
    weight <= weight >> 1'b1;
    // remainder's logic??
    remainder_o <= dividend - (result_o * 24);
    counter <= counter - 1'b1;
end
```

##### case 详细讨论

这里的case情况的条件需要现在来进一步不详细分类讨论以确保完备和正确。

输入信号

| valid_i | dividend_i |
| ------- | ---------- |

输出信号

| result_o | remainder_o | valid_o | div_mod_busy_o |
| -------- | ----------- | ------- | -------------- |

- 开始条件，当前输入信号有效（valid_i）且当前模块不忙(div_mod_busy_o)
- 开始操作，将输入信号（dividend_i）放入内部寄存器保存，模块忙信号置位(div_mod_busy_o)
- 结束计算条件，当前已经到达最低位的比较（counter_i == 0），输出信号无效（valid_o），且模块忙（div_mod_busy_o == 1'b1）
- 结束计算操作，计算余数（remainder）的值，将输出（valid_o）置为有效。
- 完成条件，当前的输出有效（valid_o），且模块忙（div_mod_busy_o == 1'b1）说明达到完成条件。
- 完成操作，valid_o置零，div_mode_busy_o置零。
- 进入计算条件，div_mode_busy_o为1，当前的counter不为零
- 进入计算操作，比较当前结果与输入值之间的大小，如果大，就置0；如果小，就置1（保持不变，加上下一个weight即可）。
- IDLE锁存，无变化。

##### 完整代码

```verilog
module div_mod_n#(
    parameter N = 24, // Set the divisor
    parameter BW = 12 // max bit width of the input
)(
    input clk_i,
    input rst_n_i,
    input valid_i,
    input [BW-1:0] dividend_i,
    output reg [BW-1:0] result_o,
    output reg [BW-1:0] remainder_o,
    output reg valid_o,
    output reg div_mod_busy_o,
    output wire [7:0] counter_o
);
    // process
    reg [BW-1:0] dividend;
    reg [BW-1:0] weight;
    reg [7:0] counter = 4'd12;  // this is a counter for the finish signal
    assign counter_o = counter;
    always @(posedge clk_i)begin
        // reset
        if(!rst_n_i)begin
            div_mod_busy_o <= 1'b0;
            result_o <= 1'b0;
            remainder_o <= 1'b0;
            valid_o <= 1'b0;
        end
        else begin
            // the start, set the dividend and busy signal.
            if(valid_i == 1'b1 && div_mod_busy_o == 1'b0)begin
                dividend <= dividend_i;
                div_mod_busy_o <= 1'b1;
                weight <= 1'b1<<(BW-1);
                result_o <= 1'b1<<(BW-1);
                counter <= 4'd12;
            end
            // finish calculate, set the valid_o signal.
            else if(counter == 1'b0 && valid_o == 1'b0 &&  div_mod_busy_o == 1'b1)begin
                valid_o <= 1'b1;
                remainder_o <= dividend - (result_o * 24);
            end
            // the end, reset the valid and other regs.
            else if(valid_o == 1'b1 &&  div_mod_busy_o == 1'b1)begin
                valid_o <= 1'b0;
                div_mod_busy_o <= 1'b0;
            end
            // the processing, count and compare.
            else if(counter != 1'b0 && div_mod_busy_o == 1'b1)begin
                if( dividend > (result_o * 24))begin
                    result_o <= result_o + (weight >> 1);    
                end
                else begin
                    if(dividend < (result_o * 24))begin
                        result_o <= (result_o & ~weight) + (weight >> 1);
                    end
                    else begin
                        result_o <= result_o;
                        counter <= 1'b0;
                    end
                end
                weight <= weight >> 1'b1;
                remainder_o <= dividend - (result_o * 24);
                counter <= counter - 1'b1;
            end
        end
    end
endmodule

```

![测试1：正常结果输出](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220312164744430.png)

![测试2：第二次正常输入](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220312165033589.png)

![测试3：正常数据输入以及rst_n信号测试](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220312165415183.png)

#### padding模块

发现直接用mod 模块的耗费和我设计的其实是差不多的。。。这里直接使用取余运算罢。

padding 模块的主要问题是每次不是一个像素、一个像素地输入。因此，在进行了裁边操作之后，如何提取有效像素是一个需要思考的问题。这里要提取有效像素，一个是需要确定开始输入时候的操作（处理掉前几行被裁减的部分），第二个是处理掉开始有效输入之后中的无效数据（每行被裁减的列的像素）。解决这两个问题需要用到两个存储单元（每个存放四个像素），一个用来记录当前应该输出的四个像素，一个用来存放下一个时刻应该输出的像素（不到4个，是上一次输入剩下来的部分，在下一次输入时，这部分被移入第一个存储单元中）。

在对第一个问题的方案的思考中，我们应该在输入的开始时进行计数，但记录到（cropped_row_num * col_num / 4（左移））时，说明下一个时刻的输入中，有第一个有效数据；为了提取出这里的第一个有数据时，需要知道上一行式子除法之后的余数是多少，这里刚好是对4作除法，因此，可以直接提取低两位作为这里的余数（mod_4)，第一个有效数据就是下一个输入的（mod_4：4）的数据，将其放入第一个存储单元中，下一个开始全部都是有效数据，需要进行的处理是将前（0：mod_4-1）的数据放入第一个存储单元中，将后（mod_4：4）放入第二个存储单元中，至此第一个数据就可以进行输出了。

![输入输出情况](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/image-20220314165734968.png)

（从上图中可以看到，输入和输出之间会有一个周期的延迟，黑色是当下的输入，红色是下一次的输入）

但是这里的输出会遇到这样一个问题，输出也不是按4的整数倍开始的，有两种情况，第一种对应着奇数的行，例如对第一行有效数据的输出时，第一次输出的是0XXX这样的一组四个像素，在这一行有效输出结束的时候是输出的是X000的一组四个像素（其余都是zero-padding的部分了），最前后的两个像素合起来就是一个完整的一组四个像素，第二种对应着偶数行，和前面类似的情况，但这里第一次是000X，最后一次是XXX0。分别考虑这两种情况，我们也需要用到两个基本存储单元（每个存放4个像素，一个用于存放当前输出，一个存放下一次的输出）。



## 参考资料

[verilog if后必须要有else吗_【逻辑】verilog中阻塞赋值和非阻塞赋值的区别_weixin_39877166的博客-CSDN博客](https://blog.csdn.net/weixin_39877166/article/details/111332496)

[Verilog if-else-if (chipverify.com)](https://www.chipverify.com/verilog/verilog-if-else-if)

[Verilog语法之三：变量 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/72012739#:~:text= reg型数据可以赋正值，也可以赋负值。,但当一个reg型数据是一个表达式中的操作数时，它的值被当作是无符号值，即正值。 例如：当一个四位的寄存器用作表达式中的操作数时，如果开始寄存器被赋以值-1%2C则在表达式中进行运算时，其值被认为是%2B15。)[Verilog语法之三：变量 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/72012739#:~:text= reg型数据可以赋正值，也可以赋负值。,但当一个reg型数据是一个表达式中的操作数时，它的值被当作是无符号值，即正值。 例如：当一个四位的寄存器用作表达式中的操作数时，如果开始寄存器被赋以值-1%2C则在表达式中进行运算时，其值被认为是%2B15。)

[sobel图像边缘检测算法的Python及Verilog验证_whustxsk的博客-CSDN博客](https://blog.csdn.net/qq_40230112/article/details/108037875)



