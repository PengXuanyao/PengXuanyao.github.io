---
title: 【ZYNQ7010】-02-HDMI显示
mathjax: false
date: 2022-08-08 15:34:27
tags:
    - ZYNQ7010
categories:
    - 学习
---

## 做个实验

还是按照官方的教程搭建这个HDMI显示的

## 换成Linux环境开发

现在已经在linux环境下，安装好了Vitis套件，但是官方给出的启动方案（必须在制定的文件目录下，启动脚本运行才能够显示图形化界面）并不是很好用。

现在想要做的第一件事情是将这个命令添加到全局执行。

### Vitis系列软件设置为全局启动

> 参考资料：
> 1. [Linux下快速启动Xilinx Vivado方法](https://juejin.cn/post/6844903886415740936)
> 2. [Ubuntu启动Xilinx Vivado](https://blog.csdn.net/qsczxcedczx/article/details/114101741)

为什么粘贴链接时候不能够自动补全标题？换过编辑器（zettlr和vscode），这个问题还是存在，目前暂时认为是复制粘贴功能的问题

最后是参考了资料2的内容，直接在.bashrc中添加了source /tools/···

## 使用SDK固化FLASH代码固化

今天还是先做一个简单的SDK固话FLASH的项目，将上次完成呼吸灯项目固化到flash当中。

1. 报错

> [Common 17-69] Command failed: write_hw_platform is only supported for synthesized, implemented, or checkpoint designs

解决方法：关闭elaborated design即可，[当前项目不允许导出](https://www.cnblogs.com/YYFaGe/p/14362187.html)。

2. 找不到SDK入口

升级之后，使用vitis（不需要vivado_sdk），[vitis导入](https://blog.csdn.net/a2267542848/article/details/115976597)

3. 怎样使用vitis

新建platform project，然后导入硬件生成的xsa文件。[xsa文件导入](https://blog.csdn.net/qq_31253859/article/details/112243552)

4. 找不到elf文件

在zynq_fsbl中运行makefile文件，得到生成的fsbl.elf文件。

5. WARNING: Failed to connect to hw_server at TCP:127.0.0.1:3121
Attempting to launch hw_server at TCP:127.0.0.1:3121； ERROR: Unable to detect JTAG cable

怀疑是linux系统无法识别板卡的问题。







