---
title: 【IntelCup】-07-01
mathjax: true
date: 2022-07-01 11:49:10
tags:
  - Python
categories:	
  - IntelCup
---

## 神经网络学习

> 《Python神经网络编程》

### 基本的神经网络

简单的神经网络就是通过一层一层（输入层、隐藏层、输出层）的矩阵运算，中间将加权后的输入用sigmoid函数$\frac{1}{1+e^{-x}}$（书中也称激活函数）映射，将得到的输出送入到下一层。

### 基本的反馈思想调节神经网络的链接权重

当输出值和期望值有误差时，将误差作为反馈，调节网络中的链接权重，并且权重越大应当调节的效果越大。

#### 使用矩阵乘法进行反向传播误差

这种方法是通过实际直观知道的输出误差，反向推导得到上一层（中间层或叫隐藏层的误差），尝试用矩阵的方式描述这一过程就成为**过程矢量化**。

首先，通过观察误差来源，列出方程，然后写成矩阵形式；接着，进行归一化处理，得到反向传播的误差举证是前面描述的**链接权重矩阵的转置**。

#### 使用梯度下降法确定调节链接权重矩阵系数的方向

构建误差函数（误差的2次方），使用梯度下降法（求一阶偏导数）得到调整系数方向，大梯度使用大步长调整，小梯度使用小步长调整，直到满足精度要求。

记住优化的方向是负梯度方向（下降）。

### 构建训练的数据需要注意的问题

- 激活函数的输出范围是0~1，因此，不应当设置一个大于1的目标值；
- 初始权重不应当过大，会导致网络饱和；也要避免0值导致的网络断联。
- 权重初始化也不应当设置为相同，会导致优化权重时，优化的权重会始终一样。

## Pycharm添加模板

> [pycharm自定义代码片段 - 安迪9468 - 博客园 (cnblogs.com)](https://www.cnblogs.com/andy9468/p/8988501.html)

添加模板的时候注意作用域的设置：

![img-1](https://s2.loli.net/2022/07/01/Cb8Eqzc2d3j9ZBQ.png)

![img-2](https://s2.loli.net/2022/07/01/FaClPw6iemZuYzL.png)

## QT学习

> 直接复制一行代码：Ctrl+D；
>
> 多行编辑：ctrl双击不松手+上下键.可以在同一列增加光标.
>
> [PyQt5中文网 - Python GUI图形界面开发视频教程](http://www.pyqt5.cn/)
>
> [PyQt5图形界面入门教程（第一篇） (xdbcb8.com)](https://www.xdbcb8.com/archives/98.html)（这个教程比较全面）
>
> [迷途小书童的Note的个人空间_哔哩哔哩_bilibili](https://space.bilibili.com/216221286)(这个阿婆是讲Yolo的)

第一章讲了里面的主要的类的属性和方法，以及如何之间的父子关系等基本内容。

### PYQT中的定时器

给定时器绑定一个触发时激活的函数，然后自动运行就可以，并在合适的时间进行终止操作。

### 事件

是属于PYQT内置的信号处理方法

### Others

#### raise

用来引发一个异常：

#### 基础UI设计，包括窗口图标等

[PyQt5的UI设计，包含了最基本的信号与槽函数调用， 还有Qt设计师关于信号与槽函数的联系 (xdbcb8.com)](https://www.xdbcb8.com/archives/137.html)

### 一个有意思的代码

```python
#coding=utf-8
import sys
from PyQt5.QtWidgets import (QApplication, QLabel, QWidget)
from PyQt5.QtGui import QPainter, QColor, QPen
from PyQt5.QtCore import Qt


class Example(QWidget):
    distance_from_center = 0
    def __init__(self):
        super().__init__()
        self.initUI()
        self.setMouseTracking(True)
        
    def initUI(self):
        self.setGeometry(200, 200, 1000, 500)
        self.setWindowTitle('学点编程吧')
        self.label = QLabel(self)
        self.label.resize(500, 40)
        self.show()
        self.pos = None
        
    def mouseMoveEvent(self, event):
        distance_from_center = round(((event.y() - 250)**2 + (event.x() - 500)**2)**0.5)
        self.label.setText('坐标: ( x: %d ,y: %d )' % (event.x(), event.y()) + " 离中心点距离: " + str(distance_from_center))
        self.pos = event.pos()
        # 这里的update会激活paintEvent
        self.update()
        
    def paintEvent(self, event):
        if self.pos:
            q = QPainter(self)
            q.drawLine(0, 0, self.pos.x(), self.pos.y())
            
            
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())
```

