---
title: 【IntelCup】-07-06
mathjax: false
date: 2022-07-06 10:06:50
tags:
  - Python
categories:
  - InterlCup
---

## 函数修饰器@

[python函数修饰器(decorator) - 世有因果知因求果 - 博客园 (cnblogs.com)](https://www.cnblogs.com/kidsitcn/p/9413273.html#:~:text=python语言本身具有丰富的功能和表达语法，其中修饰器是一个非常有用的功能。 在设计模式中，decorator能够在无需直接使用子类的方式来动态地修正一个函数，类或者类的方法的功能。,当你希望在不修改函数本身的前提下扩展函数的功能时非常有用。 简单地说，decorator就像一个wrapper一样，在函数执行之前或者之后修改该函数的行为，而无需修改函数本身的代码，这也是修饰器名称的来由。)

函数修饰器是用来套函数的，从下至上依次调用：

```python
def p_decorate(func):
   def func_wrapper(name):
       return "<p>{0}</p>".format(func(name))
   return func_wrapper

def strong_decorate(func):
    def func_wrapper(name):
        return "<strong>{0}</strong>".format(func(name))
    return func_wrapper

def div_decorate(func):
    def func_wrapper(name):
        return "<div>{0}</div>".format(func(name))
    return func_wrapper

# 基础用法:
get_text = div_decorate(p_decorate(strong_decorate(get_text)))
#等价于:
@div_decorate
@p_decorate
@strong_decorate
def get_text(name):
   return "lorem ipsum, {0} dolor sit amet".format(name)

print get_text("John")

# Outputs <div><p><strong>lorem ipsum, John dolor sit amet</strong></p></div>
```

## QThread

设计到自定义信号的交互在这一篇文章中的末尾讲述的比较请创出：

[PyQt5（designer）入门教程 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/269273821)

## 写界面遇到的一些问题

已经实现了将图像显示在imshow窗口中，在移植程序的过程中，采用的方法是直接将变量和函数打包到一个类中，在主程序中调用。

