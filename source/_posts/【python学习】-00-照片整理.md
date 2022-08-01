---
title: 【python学习】-00-照片整理
date: 2022-01-11 09:51:42
tags: 
  - 踩坑
  - python
categories:
  - 学习
---

这件事的起因是手机的内存已经爆炸了。想要找一个办法来把手机的内存清理一下，但是发现照片实在是太多了。桌面上的以前的照片也还没有清理干净，导致一团糟。想要去网上去学习一下用python写一个脚本自动帮我把照片按照月份放入响应的文件夹。其实也不难，但是还有一个问题是手机上的杂七杂八的缓存图像贼多，还得把这些不相干的照片做一个分类和清理。

先是在CSDN找到了一个相关的教程，但是和我的需求有一点小小的不同（文件夹的组织方式不太一样），但我想还是先按着这个写一个小的脚本，然后再改正。链接如下：

> [python照片按时间自动分类_进阶中的菜鸟的博客-CSDN博客](https://blog.csdn.net/weixin_38263568/article/details/104289603)
>
> [用python进行图片整理_SSSimonYang的博客-CSDN博客_python整理照片](https://blog.csdn.net/qq_24992725/article/details/107069631)

---

## 裂开，vscode插件崩了。

koroheaderfile无法生成头注释的问题，只能生成函数注释、不能生成头文件的注释，初步尝试了一下，应该是这个headerfile的设置有问题：

问题解决了，在settings里面添加一个来这个来设置一下，不知道是哪里出了问题，以前那好像记得也没这玩意儿，感觉像可能某次不小心删掉了。

```js
"fileheader.configObj": {
    "autoAdd": true, // 自动添加头部注释开启才能自动添加
    "autoAlready": true, // 默认开启
  }
```

---

通过这一篇博客可以看到如何去处理图片：

[python初学者：照按照时间分类整理片工具 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/55266474)

[基于Python快速整理微信视频与图片 - 简书 (jianshu.com)](https://www.jianshu.com/p/3b61923efdf1)

上面这是一个非常好的一个工具，能够自动地提取出图片中的日期等信息，但是不能够对视频做处理，因此还需要花时间去看一下相关的对视频处理的方法。

---

搞了一下午，这玩意儿说来应该逻辑上是不太难的，为何总是在实践中出篓子。太难了,我.

---

opts： 命令行的参数（选择的缩写）

如果使用getopt函数的时候，需要使用到参数的"h:d:o"，不能够使用hdo连续的字符串，例如：

```python
opts, args = getopt.getopt(sys.argv[1:],"h:d:o")
# opts, args = getopt.getopt(sys.argv[1:],"hdo")
for op,value in opts:
    if op == "-d":
        img_dir = value	# 如果使用注释中的写法，将得不到value值
    if op == "-o":
        out_dir = value
    if op == "-h":
        usage()
        sys.exit()
```

目前遇到的问题是如何用re.compile函数对字符串进行匹配，源代码是：

```python
date_re = re.compile(r'((\d+):(\d+):(\d+)) \d+:\d+:\d+)')
result = date_re.search(filedate)
```

其中的filedate的格式为

```cmd
2019:10:26 22:11:33
```

产生的问题是：

```cmd
re.error: unbalanced parenthesis at position 31
```

问题解决了，是上面的格式没有写对，多加了一个）：

```python
date_re = re.compile(r'((\d+):(\d+):(\d+) \d+:\d+:\d+)')
result = date_re.search(filedate)
```

