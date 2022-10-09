---
title: 【RV_Security】-01-继续调研
mathjax: false
date: 2022-09-27 16:49:25
tags:
    - RV_Security
categories:
    - 调研
---

## Intel SGX

> [Intel SGX系列（一）了解Intel SGX - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/39976702)

数据在网络传输和磁盘存储中一般都会有加密的协议，但是在**内存**中，数据都是在**直接暴露**的状态。因此，Intel的SGX（Software Guard Extensions）针对这种情况，对内存的可执行区域进行保护。

其是一个硬件辅助的可行执行环境，Intel SGX提供17种新的Intel架构指令。应用程序能够为**代码和数据**设置保留的**私有区域**，也能阻止对**执行中代码**和**内存中的数据**进行的直接攻击。

- 典型应用场景：对于不信任的Component不能访问信任的Component。

  ![SGX_application](https://pic4.zhimg.com/80/v2-efab303cbf5bfadfed3bca1d0e9a81e7_720w.webp)

- SGX运行流程：
  
  ![SGX_Runing](https://pic3.zhimg.com/80/v2-388347e16ef518b6b3a82023c28caefe_720w.webp)
  
  图片流程表示：
  
  1. App由可信和不可信部分构成
  2. App运行和创建enclave，enclave放入到可信内存中。
  3. 可信函数被调用，执行会转换到enclave中。
  4. enclave可以访问所有进程数据，外部要访问encalve数据被禁止
  5. 可信函数返回enclave数据
  6. App进行执行不同代码

## eFuse运用

### ScureBoot

> 参考资料：
> 
> - [浅析安全启动（Secure Boot）附带EFUSE解析_那个苏轼回不来了丶的博客-CSDN博客_efuse工作原理](https://blog.csdn.net/qq_45763093/article/details/118081831#:~:text=%E6%89%80%E6%9C%89%E6%94%AF%E6%8C%81%20Secure%20Boot%20%E7%9A%84%20CPU%20%E9%83%BD%E4%BC%9A%E6%9C%89%E4%B8%80%E5%9D%97%E5%BE%88%E5%B0%8F%E7%9A%84%E4%B8%80%E6%AC%A1%E6%80%A7%E7%BC%96%E7%A8%8B%E5%82%A8%E5%AD%98%E6%A8%A1%E5%9D%97%EF%BC%8C%E6%88%91%E4%BB%AC%E7%A7%B0%E4%B9%8B%E4%B8%BA%20FUSE%20%E6%88%96%E8%80%85,eFUSE%EF%BC%8C%E5%9B%A0%E4%B8%BA%E5%AE%83%E7%9A%84%E5%B7%A5%E4%BD%9C%E5%8E%9F%E7%90%86%E8%B7%9F%E7%8E%B0%E5%AE%9E%E4%B8%AD%E7%9A%84%E4%BF%9D%E9%99%A9%E4%B8%9D%E7%B1%BB%E4%BC%BC%EF%BC%9ACPU%20%E5%9C%A8%E5%87%BA%E5%8E%82%E5%90%8E%EF%BC%8C%E8%BF%99%E5%9D%97%20eFUSE%20%E7%A9%BA%E9%97%B4%E5%86%85%E6%89%80%E6%9C%89%E7%9A%84%E6%AF%94%E7%89%B9%E9%83%BD%E6%98%AF%201%EF%BC%8C%E5%A6%82%E6%9E%9C%E5%90%91%E4%B8%80%E4%B8%AA%E6%AF%94%E7%89%B9%E7%83%A7%E5%86%99%200%EF%BC%8C%E5%B0%B1%E4%BC%9A%E5%BD%BB%E5%BA%95%E7%83%A7%E6%AD%BB%E8%BF%99%E4%B8%AA%E6%AF%94%E7%89%B9%EF%BC%8C%E5%86%8D%E4%B9%9F%E6%97%A0%E6%B3%95%E6%94%B9%E5%8F%98%E5%AE%83%E7%9A%84%E5%80%BC%EF%BC%8C%E4%B9%9F%E5%B0%B1%E6%98%AF%E5%86%8D%E4%B9%9F%E5%9B%9E%E4%B8%8D%E5%8E%BB%201%20%E4%BA%86%E3%80%82)
> 
> - [[加密]ESP32 -Secure Boot 安全方案_anxuan3201的博客-CSDN博客](https://blog.csdn.net/anxuan3201/article/details/101119944#:~:text=1%20%E7%A1%AC%E4%BB%B6%E4%BA%A7%E7%94%9F%E4%B8%80%E4%B8%AA%20secure%20boot%20key%EF%BC%8C%E5%B0%86%E8%BF%99%E4%B8%AA%20key%20%E4%BF%9D%E5%AD%98%E5%9C%A8%20efuse,bootloader%20%E9%80%9A%E8%BF%87%E7%83%A7%E5%86%99%20efuse%20%E4%B8%AD%E7%9A%84%20ABS_DONE_0%20%E6%B0%B8%E4%B9%85%E4%BD%BF%E8%83%BD%20secure%20boot)
> 
> - [浅析安全启动（Secure Boot） - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/540171344)
> 
> 最后一篇为深度文。

支持 Secure Boot 的 CPU 都会有一块eFUSE，大概在1KB左右。主要用来保存**根密钥**。

eFUSE的特点：

- 硬件一次性烧录，无法篡改

- 不易被访问，安全性高

- 如果某批次产品被某种手段获取，付出代价高（硬件版本需要迭代）。

### 攻击案例

#### 自顶向下

从最上层的程序一步步提权，慢慢渗透到目标的权限层。

[Breaking Samsung's ARM TrustZone](https://link.zhihu.com/?target=https%3A//www.youtube.com/watch%3Fv%3DuXH5LJGRwXI) （[PDF](https://link.zhihu.com/?target=https%3A//i.blackhat.com/USA-19/Thursday/us-19-Peterlin-Breaking-Samsungs-ARM-TrustZone.pdf) & [GitHub](https://link.zhihu.com/?target=https%3A//github.com/quarkslab/samsung-trustzone-research)）

#### 自底向上

利用特殊硬件方法读取底层硬件内容：通过在非常精确的时间点，执行微秒级的电压骤变使得 bootROM 在写那个可视性寄存器的时候出现错误，导致 bootROM 没有被不可视化，进而他们可以在一块开发板上用自己写的 FSBL 读取 bootROM 代码。

[Glitching the Switch](https://link.zhihu.com/?target=https%3A//media.ccc.de/v/c4.openchaos.2018.06.glitching-the-switch)


