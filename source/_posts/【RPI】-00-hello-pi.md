--- 
title: 【RPI】-00-Hello-Pi
date: 2022-10-08 16:52:18
tags:
    - RaspberryPi
    - 学习
    - 踩坑
---

## 安装系统镜像

安装RPI的镜像非常的顺畅，在完成安装后，主要遇到的问题是板载的wifi坏掉了（wifi模块表面肉眼可见有一个坑）。上次买台式机送了一个MW150UH的网卡，想着安装上去，没有找到wifi驱动，导致这两天的进度非常缓慢。

现在的解决办法是买一个免驱wifi模块的试一下。

<!-- more -->

## HelloPi

在树莓派上打印了一个HelloWorld，啥也不是。

遇见的问题：

1. Ubuntu上有线网连接不上树莓派，暂时不清楚原因（报错是：activation of network connection failed）
   终于连上了，根据这位大佬的博客（[树莓派网线直连Ubuntu\_栋次大次的博客-CSDN博客](https://blog.csdn.net/weixin_39529413/article/details/79222696)），更改了一下有线网络的设置：
   ![更改有线网络设置](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20221009194526.png)

2. 解决了一个小问题：刚刚不能google，以为是下午为了连树莓派装了arp-scan的原因；最后反应过来是下午调系统设置的network的时候不小心动了一下Network Proxy的设置导致的（设置成手动模式）：
![设置成手动模式](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20221009184552.png)

## Linux开发环境搭建

#### 为树莓派分配固定的IP地址

重启之后，通过网络设置找到本机ip：

![本机ip](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20221009200225.png)

然后通过nmap命令找到树莓派的地址，最后连接成功进入树莓派终端：

![树莓派地址和链接成功截图](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20221009200425.png)

接下来为树莓派分配固定的地址：参考博客[树莓派如何固定 IP 地址\_疯魔coding君的博客-CSDN博客\_树莓派固定ip](https://blog.csdn.net/qq_44214671/article/details/114165432)

这里没有和原博客一样对路由地址进行修改，只是取消了eth0两行的注释：

发现无法连接，于是按照博客内容进行了完全的修改，此事依旧无法正常连接树莓派。主机上的ip地址（10.42.0.1）没有变化，树莓派上已经改变为（192.168.0.10/24），此时nmap命令已经无法找到pi。

改为静态ip后无法连接，遂先改为原来的动态分配方式。目前想到的解决办法是：通过将静态ip设置为和动态ip一样，看能不能解决。



