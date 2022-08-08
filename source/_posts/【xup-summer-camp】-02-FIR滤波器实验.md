---
title: 【xup_summer_camp】-02-FIR滤波器实验
mathjax: false
date: 2022-08-07 09:27:54
tags:
categories:
---

完成FIR滤波器实验记录，主要是跑一下例程，对麻鹬和麻雀的声音（两者的频谱上是分开的，能够通过FIR滤波器进行滤除）。

使用的仓库地址（fork了一下原仓库）：[PengXuanyao/XilinxSummerSchool2022 (github.com)](https://github.com/PengXuanyao/XilinxSummerSchool2022)

### Vitis导出RTL有bug

按照教程顺序进行操作时，无法生成IP，出现报错：`ERROR: [IMPL 213-28] Failed to generate IP.`。

查阅了一下，是一个普遍的问题，可能是由于系统时间溢出导致的（？不太确定），通过打上官方的补丁即可修复。

问题解决，注意：**需要在Xilinx的根目录下运行补丁，而不是在\patch的目录下运行**

![在Xilinx目录下运行](https://s2.loli.net/2022/08/07/PFucTUOEKmBZnAL.png)

笔记本跑起来明显有一点卡顿。

按照官方的文档，顺利地跑下来整个工程，总结一下如何使用pynq进行开发和验证：

1. 实际生成硬件框架使用的是hls和vivado工具链，pynq是给与了一个调用和交互的接口，用户能够轻松地对硬件进行验证和可视化等操作。
2. 使用jupyterbook的时候，是相当于在芯片PS端上运行了python环境，然后调用了PS端的接口，整个流程图如下（摘自[这篇博客](https://zhuanlan.zhihu.com/p/52469205)）
      ![pynq](https://pic1.zhimg.com/80/v2-ad4971bc5d27a020cd94b7d4772a4d44_720w.jpg)


参考的资料包括：

1. [HLS ERROR: IMPL 213-28 Failed to generate IP._XS30的博客-CSDN博客](https://blog.csdn.net/u014798590/article/details/122312505)
2. [Export IP Invalid Argument / Revision Number Overflow Issue (Y2K22) (xilinx.com)](https://support.xilinx.com/s/article/76960?language=en_US)（解决方法）
3. [ERROR: IMPL 213-28 Failed to generate IP. (xilinx.com)](https://support.xilinx.com/s/question/0D52E00006uyTmwSAE/error-impl-21328-failed-to-generate-ip?language=en_US)