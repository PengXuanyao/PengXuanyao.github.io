---
title: 【IntelCup】-07-15
mathjax: false
date: 2022-07-15 10:10:44
tags:
  - Python
categories:
  - InterlCup
---

## 增加YoLov5检测功能

目前能够识别人脸和情绪，在学习过程中，希望检测环境中的手机等电子设备的使用情况，来评估整体学习环境。

目前想法是将图片载入yolov5网络中进行识别，但是可能会存在一个检测到物品后的标记框颜色跳动的问题。暂时想到的解决办法是将标记的颜色设定为特定顺序，避免在持续跳动的问题（可能依然会存在识别物体发生变化时，颜色闪烁的情况）。

## 模型部署

### 模型导入debug

模型部署中，首先遇到的一个问题还是**python导入包**的问题，不太明白为什么有时候又检测不到包了。

实际的问题是这样的：有一个如下的文件的目录：

```
│  demo.py
│
├─models
│  │  common.py
│  │  experimental.py
│  │  yolo.py
│  │  yolov5l.yaml
│  │  yolov5m.yaml
│  │  yolov5s.yaml
│  │  yolov5x.yaml
│  │
│  └─__pycache__
│          common.cpython-37.pyc
│          experimental.cpython-37.pyc
│
├─samples
│  └─images
│          bus.jpg
│          dog.jpg
│          eagle.jpg
│          giraffe.jpg
│          horses.jpg
│          none.jpg
│          person.jpg
│          zidane.jpg
│
├─utils
│      activations.py
│      autoanchor.py
│      datasets.py
│      general.py
│      google_utils.py
│      metrics.py
│      plots.py
│      torch_utils.py
│
└─YoloV5Detector
    │  V5Detector.py
    │  __init__.py
    │
    └─__pycache__
            V5Detector.cpython-37.pyc
            __init__.cpython-37.pyc
```

然后是`models\common.py`需要导入`utils\datasets.py`，直接在最外层运行main.py会出现导入不了，报错的情况。

```python
# models.common.py 中进行导入
from utils.datasets import letterbox 
ModuleNotFoundError: No module named 'utils.datasets'
```

最后问题解决，有一点小小的离谱，这个utils和CV2里面的utils是冲突了，吧这个utils改成yolo_utils，游戏结束。

### 安装pyaudio出问题

错误提示为：` error: Microsoft Visual C++ 14.0 or greater is required. Get it with "Microsoft C++ Build Tools"`

但是根据其给的网站安装相关的工具，并且重启后还没有解决问题。

最后解决问题的办法是：上官网下载whl文件，安装后就好了。主要参考了这个博客：[Python中Pyaudio安装失败的解决办法_段云oO的博客-CSDN博客_pyaudio安装失败](https://blog.csdn.net/qq_43411654/article/details/111636206)

## 参考资料

- [YOLOv5-Lite：更轻更快易于部署的YOLOv5 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/400545131)
  - 这篇文章讲的会深入一些，如果只是运用，不探究原理可以掠过
- [超越YOLOv5！1.3M超轻量，又好又快！目标检测神器来了 - 腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1821880)
  - 轻量化的yolo算法，速度很快，暂时不知道检测的范围是否包括需要的手机等
- [[Yolo部署落地系列教程\]（2）Yolov5之Pytorch部署_是小晰瓜啊的博客-CSDN博客_yolov5部署](https://blog.csdn.net/weixin_42073654/article/details/119334572)
  - 该文章将yolov5封装成为了函数进行调用，可以试一试。
  - 暂时选取这个链接的方案，由于该方法直接封装好了Detect类，可以方便调用，目前来看应该是最快的方案
- [将Yolov5的detect.py修改为可以直接调用的函数_guluC的博客-CSDN博客_调用yolov5的detect](https://blog.csdn.net/guluC/article/details/122683269)
  - 同样是封装成为了函数，可能比上面封装好一些

## Tips

- 如果带有中文字符，会使OpenCV的cv2.imread()函数读取不了待检测图片或视频
