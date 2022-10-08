---
title: 【IntelCup】-06-29
mathjax: false
date: 2022-06-29 16:52:35
tags:
  - python
  - pyqt
categories:
  - 学习
---

## 使用PYQT搭建一个简易登录界面

> [Python/PyQt5/Qtdesigner设计登录界面——包括登录和注册界面切换_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Li4y1m79p?spm_id_from=333.337.search-card.all.click&vd_source=293ffecc5040ce31ebf8b10de8372434)

### 使用QT desiger设计界面

详细参加视频，注意不要把登录框重叠

### 使用Pycharm开发

暂时未遇到无法解决的问题，但是有些功能没有完全实现。

<!--more-->

## 编写YOLO-V5目标检测主界面

### 安装YOLO-V5需要的环境（anaconda配置）

> [Anaconda-用conda创建python虚拟环境 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/94744929)

#### 遇到的问题

- 不知道如何在anaconda prompt中切换盘
  
  ​    [Anaconda prompt cd命令 盘之间切换_qq_41277534的博客-CSDN博客_anaconda cd命令](https://blog.csdn.net/qq_41277534/article/details/90759267)

- 出现warning:Ignore distutils configs in setup.cfg due to encoding errors
  
  ​    [【WARNING:Ignore distutils configs in setup.cfg due to encoding errors】完美解决_Youcai Zhang的博客-CSDN博客](https://blog.csdn.net/a1130061818/article/details/123811002)

- 项目要求中未列出包含模块XXX的软件包
  
  ​        依据PyCharm提示更改

### 编写主函数

```python
import sys
from PyQt5 import QtGui
from PyQt5.QtWidgets import QMainWindow, QFileDialog, QApplication
from my_window import Ui_main_window


class UiMain(QMainWindow, Ui_main_window):
    def __init__(self, parent=None):
        super(UiMain, self).__init__(parent)
        # 读取文件的名字
        self.file_name = None
        # 初始化Ui
        self.setupUi(self)
        # 链接导入图片的函数
        self.video_button.clicked.connect(self.load_image)

    def load_image(self):
        self.file_name, _ = QFileDialog.getOpenFileName(self, '请选择图片', '.', '图像文件(*.jpg,*.jpeg,*.png)')
        if self.file_name:
            print(self.file_name)
            self.result_label.setText("文件打开成功" + self.file_name)
            jpg = QtGui.QPixmap(self.file_name).scaled(self.img_label.width(), self.img_label.height())
            self.img_label.setPixmap(jpg)
        else:
            self.result_label.setText("无效文件，文件打开失败")


if __name__ == "__main__":
    # 初始化APP
    app = QApplication(sys.argv)
    # 初始化主窗口
    main = UiMain()
    # 显示
    main.show()
    # 主循环
    sys.exit(app.exec_())
```

### 总结

上面这种写法和一般的写法还有一些区别：就是说上面使用了一个类将实现了主窗口的编写，可以在此的基础上继承更多的类实现更多功能，一般的写法是：

```python
import login
import sys
from PyQt5.QtWidgets import QApplication, QMainWindow


def show_signin():
    loginUi.widget_3.hide()
    loginUi.widget_2.show()


def show_signup():
    loginUi.widget_2.hide()
    loginUi.widget_3.show()


if __name__ == '__main__':
    # 创建app
    app = QApplication(sys.argv)
    # 创建window对象
    win = QMainWindow()
    # 创建自定义的window对象
    loginUi = login.Ui_MainWindow()
    # 继承win？？不太确定
    loginUi.setupUi(win)
    # 显示
    win.show()
    # 主循环
    sys.exit(app.exec_())
```

还有就是这句话不是太理解：`super(UiMain, self).__init__(parent)`，是自己写的类UiMain中的语句。
