---
title: 【ZYNQ7010】-02-HDMI显示
mathjax: false
date: 2022-08-08 15:34:27
tags:
    - ZYNQ7010
categories:
    - 学习
---

## 想做HDMI实验

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

### debug流

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

怀疑是linux系统无法识别板卡的问题，在win环境下已经验证是没有问题的。

尝试使用vivado进行程序烧录,还是发现问题存在。

已经找到根源，是因为没有装驱动;

> 按照官方教程装驱动即可：https://support.xilinx.com/s/article/54381?language=en_US
> 其他参考资料：
> * [Unable to connect to hardware target in Vivado](https://support.xilinx.com/s/question/0D52E00006iI3y1SAC/unable-to-connect-to-hardware-target-in-vivado?language=en_US)

安装驱动重启后，问题解决。

### 搞定

最后使用vitis进行程序烧写，烧录完成之后，断电将boot模式选为10（QSPI模式），最后程序已经固化在芯片上，能够正常启动。

## Picgo使用

想在vscode上写博客的时候上传一下图片，于是安装了一下picgo。

### snap应用安装

非官方商店的snap安装时，会出现以下的报错：

> error: cannot find signatures with metadata for snap "picgo_2.3.0_amd64.snap"

解决方法就是：加一个dangerous标志

> [参考博客](https://itsfoss.com/snap-metadata-signature-error/)

安装完成之后打开是黑屏，有大问题！

### 使用AppImage版本

不用snap版本了，上次snap版本的firefox也经常出小毛病。

换成appImage版本试一下。

AppImage版本是正确的，但是得先安装以下FUSE（参照教程：[FUSE_WIKI](https://github.com/AppImage/AppImageKit/wiki/FUSE)）

启动picgo成功

[AppImage使用](https://ubunlog.com/zh-CN/%E4%BB%80%E4%B9%88%E6%98%AFappimage%E4%BB%A5%E5%8F%8A%E5%A6%82%E4%BD%95%E5%9C%A8ubuntu%E4%B8%AD%E5%AE%89%E8%A3%85%E5%AE%83%E4%BB%AC/)

如何复制
将AppImage添加到应用界面：
 
### 设置上传方式

注意上传的路径是：用户名/仓库，而不是整个url






















