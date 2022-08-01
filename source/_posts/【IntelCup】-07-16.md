---
title: 【IntelCup】-07-16
mathjax: false
date: 2022-07-16 10:26:41
tags:
  - Python
categories:
  - InterlCup
---

## 部署yolov5

今天在自己的工程里面部署了yolov5，总体比较顺利。中间卡住的地方主要是：

1. cv2读取图片的时候要看一下是否读取图片成功，目前因为图片都是以缓存的形式保存在文件中，有注意有一边图片还没有写好，另一边就需要读取的情况，这时候需要做一个判断，防止出现读入图片无效，引发错误的情况发生。
   
   ```python
   img = cv2.imread(src_img)
               if img is None:
                   print("图片读取失败")
               else:
                   img_res, det_res = self.yolo_detector.detect(img, cls, thresh)
   ```
