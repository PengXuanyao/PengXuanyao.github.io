---
title: 【IntelCup】-07-04
mathjax: false
date: 2022-07-04 09:14:01
tags:
  - Python
categories:	
  - IntelCup
---

## PyQT界面搭建

### 消息框

#### debug

- TypeError: Cannot create a consistent method resolution

  原因是同时继承了子类和父类

  [python报错——TypeError: Cannot create a consistent method resolution_张喵喵是小仙女的博客-CSDN博客](https://blog.csdn.net/miaomiao_zhang/article/details/100323458)

- PyCharm查看方法：

  [Pycharm中查看函数参数、用法等相关信息的方法_华墨1024的博客-CSDN博客_pycharm查看函数说明](https://blog.csdn.net/qq_40846862/article/details/119479567)

- 设置label长宽

  [Python PyQt Qlabel调整大小 | 码农家园 (codenong.com)](https://www.codenong.com/41296181/)

## 调用opencv函数没有定义

> - [在PyCharm中使用openCV函数时没有函数提示或没有函数引导_Qcecream的博客-CSDN博客_pycharm中opencv没有提示](https://blog.csdn.net/weixin_55274216/article/details/123695810)
> - [解决opencv / cv2 没有代码提示的问题_再游于北方知寒的博客-CSDN博客](https://blog.csdn.net/m0_57110410/article/details/125531873)

## 使用QImage需要注意长宽信息

```python
img_rgb = cv2.cvtColor(im0, cv2.COLOR_BGR2RGB)
                qt_img = QtGui.QImage(img_rgb.data, img_rgb.shape[1], img_rgb.shape[0], img_rgb.shape[1] * 3, QtGui.QImage.Format_RGB888) //这里*3很重要好吧
                qt_img.scaled(64, 64)
                window.img_label.setPixmap(QtGui.QPixmap.fromImage(qt_img))
```

