---
title: 【IntelCup】-07-12-AND-07-13 
mathjax: false
date: 2022-07-12 16:49:19
tags:
  - Python
categories:
  - InterlCup
---

## 多个窗口QTDesigner

- [PyQt5快速上手基础篇6-QStackedWidget实现导航布局_物联网客栈的博客-CSDN博客_qtdesigner stacked widget](https://blog.csdn.net/weixin_45006076/article/details/107854762)pyqt
- pyqt无法在顶层画画，原因找到了。实际上不是不能在顶层画画，而是事件的触发机制不正确，子控件默认是不会触发event的，应该给他安装事件过滤器，然后传递会父类进行处理。

>  实现代码如下

```python
import PyQt5.QtCore
from PyQt5.Qt import *
from main_gui import Ui_MainWindow
import sys

class Thread(QThread):
    move_point = pyqtSignal(int, int)
    def __init__(self):
        super(Thread, self).__init__()
        self.x = 0
        self.y = 0

    def run(self) -> None:
        self.x = (self.x + 1) % 10
        self.y = (self.y + 1) % 10
        self.move_point.emit(self.x, self.y)


class Window(QMainWindow, Ui_MainWindow):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        # 启动子控件的事件过滤器
        self.drawWidget.installEventFilter(self)

        self.thread = Thread()
        self.thread.move_point.connect(self.mypainterEvent)
        self.thread.start()

    def eventFilter(self, watched, event):
        # 判断是否式来自特定子控件的画图事件，如果是就开始特定子控件画图
        if event.type() == QEvent.Paint and watched == self.drawWidget:
            self.mypainterEvent()
        return super().eventFilter(watched, event)

    def mypainterEvent(self, x=10, y=10):
        painter = QPainter()
        painter.begin(self.drawWidget)
        painter.setPen(QPen(QColor(0, 0, 255), 7))
        painter.drawPoint(x, y)
        painter.end()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = Window()

    window.show()
    sys.exit(app.exec_())


```

但是由于不知道如何向事件里面传递线程里面的参数，最后用label来实现按算了。

> 最后实现代码如下

```python
from PyQt5.Qt import *
from main_gui import Ui_MainWindow
import sys

class Thread(QThread):
    move_point = pyqtSignal(int, int)
    def __init__(self):
        super(Thread, self).__init__()
        self.x = 0
        self.y = 0

    def run(self) -> None:
        while True:
            self.x = (self.x + 10) % 100
            self.y = (self.y + 10) % 100
            self.move_point.emit(self.x, self.y)
】、


class Window(QMainWindow, Ui_MainWindow):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        # 启动子控件的事件过滤器
        self.drawWidget.installEventFilter(self)

        self.thread = Thread()
        self.thread.move_point.connect(self.mypointEvent)
        self.thread.start()

    def mypointEvent(self, x=10, y=10):
        self.pointLabel.setGeometry(QRect(x, y, 31, 31))

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = Window()
    window.show()
    sys.exit(app.exec_())
```

> 原点坐标：（100，112）
>
> 半径：100

## Intel杯相关论文

> [【经典简读】知识蒸馏(Knowledge Distillation) 经典之作 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/102038521)
>
> [知识蒸馏（Knowledge Distillation）_Law-Yao的博客-CSDN博客_知识蒸馏](https://blog.csdn.net/nature553863/article/details/80568658)
