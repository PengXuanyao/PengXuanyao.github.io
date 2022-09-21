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

为什么不能够自动补全标题？？

最后是参考了资料2的内容，直接在.bashrc中添加了source



