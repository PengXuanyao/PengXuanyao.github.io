---
title: 【RV_Security】-00-调研
mathjax: false
date: 2022-09-24 13:55:02
tags:
    - RV_Security
categories:
    - 调研
---

## OpenTitan

![OpenTitan](https://raw.githubusercontent.com/PengXuanyao/opentitan/84f8e3b59f949ba611049450075bb14e3cea941f/doc/opentitan-logo.png)

> [Open source silicon root of trust (RoT) | OpenTitan](https://opentitan.org/)

### Features

1. Independently managed
   OpenTitan is stewarded by [lowRISC](https://www.lowrisc.org/), a not-for-profit company that uses collaborative engineering to develop and maintain open source silicon designs and tools for the long term.
2. Open source
   OpenTitan is an open source project with leading not-for-profit, academic, and commercial organizations committed to its development and expansion.
3. Security through transparency
   As an open source project, OpenTitan enables the larger community to proactively audit, evaluate, and improve the security properties of the design.
4. High-quality IP
   OpenTitan is developed by engineers and researchers from ETH Zürich, G+D Mobile Security, Google, lowRISC, Nuvoton Technology, and Western Digital. Our community brings ideas and expertise from a variety of perspectives.
5. Modern architecture
   OpenTitan is designed to serve as the system root of trust by actively mediating access to the first-stage boot firmware. It is built upon the quality constructs and security principles used to create Google's [Titan chips](https://security.googleblog.com/2019/11/opentitan-open-sourcing-transparent.html).
6. Vendor- and platform-agnostic
   Because it is not proprietary to a specific vendor or platform, OpenTitan can be integrated with data center servers, peripherals, storage devices, and other hardware, helping you reduce costs and reach more customers.

### OpenTitan's Blog

> [Google Online Security Blog: OpenTitan - open sourcing transparent, trustworthy, and secure silicon](https://security.googleblog.com/2019/11/opentitan-open-sourcing-transparent.html)

We are transparently building the logical design of a silicon RoT, including an open source microprocessor (the [lowRISC Ibex](https://github.com/lowRISC/ibex/), a RISC-V-based design), cryptographic coprocessors, a hardware random number generator, a sophisticated key hierarchy, memory hierarchies for volatile and non-volatile storage, defensive mechanisms, IO peripherals, secure boot, and more.

### OpenTitan's Github

> [lowRISC/opentitan: OpenTitan: Open source silicon root of trust](https://github.com/lowRISC/opentitan)

#### Get Started

1. 系统配置要求是18.04，本系统为22.04，可能会有一些问题。
   > Our continuous integration setup runs on Ubuntu 18.04 LTS, which gives us the most confidence that this distribution works out of the box. We do our best to support other distributions, but cannot guarantee they can be used "out of the box" and might require updates of packages. Please file a GitHub issue if you need help or would like to propose a change to increase compatibility with other distributions.
2. 检查gcc版本为11，大于要求的9
> [Ubuntu PPA 使用指南 - 知乎](https://zhuanlan.zhihu.com/p/55250294)
3. 安装python环境
   * 新建conda环境 open-titan
   * 安装：`pip3 install --user -r python-requirements.txt`([Anaconda-用conda创建python虚拟环境 - 知乎](https://zhuanlan.zhihu.com/p/94744929)) 
     * 过程中`git clone --filter=blob:none --quiet https://github.com/lowRISC/fusesoc.git /tmp/pip-req-build-jj_92m33`、`Running command git checkout -q cf222fa5c9351d09cec13cdaea4602905fa696d0`缓慢
     * 出现报错
     ```bash
     error: RPC failed; curl 16 Error in the HTTP2 framing layer
     fatal: error reading section header 'shallow-info'
     ```
     * 再次安装，出现不同报错
     * 出现报错`fatal: unable to access 'https://github.com/lowRISC/fusesoc.git/': GnuTLS recv error (-110): The TLS connection was non-properly terminated.`
     * 尝试解决方案：[fatal: 无法访问 ‘‘github.com/“:GnuTLS recv error (-110): The TLS connection was non-properly terminated.\_ZywOo777的博客-CSDN博客](https://blog.csdn.net/qq_41744950/article/details/124062974)
     * 未能解决问题
     * 使用`pip`安装尝试解决
     * 还是出现同样的症状
     * 待续，怀疑是pip版本问题
4. 

## SSITH

> [Defense Advanced Research Projects Agency](https://www.darpa.mil/)


### DARPA


## A Survey on RISC-V Security: Hardware and Architecture

### 笔记梳理

目前看完Intro、Overview和Architecture Security部分

#### Overview

1. 面临挑战：实现简洁和低功耗的硬件安全机制、RV的开放性是双刃剑
2. 本文结构：讨论安全需求-->安全机制
3. 边云之间的大数据交互造成风险，RoT和HSM是实现ESCDA和SHA的实现载体
4. 体系结构安全问题：
   * 优先级管理
      * 尤其是其中的内存管理有困难
      * 引出TEE
5. RoT和HSM
   * RoT保管秘钥，可以通过硬件方式(设计状态机)实现RoT，加以可定制电路实现更复杂功能
   * RoT保持独立性，避免收到攻击，同时提升CPU性能
   * RoT包含HSM(HSM时硬件不可被外部访问)
   * HSM构成：
     * OTP器件
     * Secure Memory

> 搭建Linux环境：
> 1. 配置Picgo过程中，发现上传出现问题，出现404报错，原因是仓库地址写错了，要写成这种格式：
> ![format](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220926102900.png)
> 2. 截一下壁纸：
> ![jelleyfish](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220926101749.png)






