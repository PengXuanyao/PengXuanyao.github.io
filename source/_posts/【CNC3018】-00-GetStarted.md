---
title: 【CNC3018】-00-GetStarted
mathjax: false
date: 2022-03-22 21:32:18
tags:
categories:
---

## PCB到G代码
---
PCB到G代码折腾了两晚上总算是可以用了，进行雕刻机的打板主要需要CAM(Computer Aided Manufacturing)软件和CAD(Computer Aided Design)软件。网络上找到了两款非常好用的软件，应该都是属于这个CAM的范畴，都非常地好用，解决了我的问题。一个是FlatCAM，其作用是将Gerber文件(pcb的eda软件生成的制造文件)转换成G代码(含有雕刻机的刀路等信息的制造文件)；第二个是Candle，对gbrl开源雕刻机框架基础上，开发的CNC上位机，可以简易地对CNC进行控制。


## Reference
---
1. [自动编程实现G代码](http://www.yujiangcnc.com/bethel/news/show_1923.html#:~:text=G%20%E4%BB%A3%E7%A0%81%E7%94%B1%E9%80%9A%E8%BF%87%E5%9B%BE%E7%BA%B8%E8%87%AA%E5%8A%A8%E7%BC%96%E7%A8%8B%E6%9D%A5%E7%94%9F%E6%88%90%E3%80%82%20%E6%89%80%E4%BB%A5%EF%BC%8C%E5%8F%AA%E9%9C%80%E8%A7%A3%E5%86%B3%E5%9B%BE%E7%BA%B8%E6%88%96%E8%80%85%E8%8E%B7%E5%BE%97%20G%20%E4%BB%A3%E7%A0%81%E5%B0%B1%E5%8F%AF%E4%BB%A5%E5%AE%9E%E7%8E%B0%20PCB%20%E6%9D%BF%E7%9A%84CNC%E5%8A%A0%E5%B7%A5%E3%80%82%20CAM350%E3%80%81Copper,Designer%20%E7%AD%89%20PCB%20%E8%AE%BE%E8%AE%A1%E8%BD%AF%E4%BB%B6%E7%94%9F%E6%88%90%E7%9A%84%20Gerber%20%E6%96%87%E4%BB%B6%EF%BC%88%E5%85%89%E5%88%BB%E6%96%87%E4%BB%B6%EF%BC%89%E7%94%9F%E6%88%90%20G%20%E4%BB%A3%E7%A0%81%E3%80%82)
2. [使用雕刻机雕刻PCB](http://www.liuwenhao.me/?p=567)
3. [CandleGetStarted](https://cncphilosophy.com/candle-grbl-software-tutorial/)