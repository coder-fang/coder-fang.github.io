---
title: input 中为什么能输入内容
categories: HTML
date: 2022-11-18
updated: 2022-11-18
tags: HTML
cover: https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_bt%2F0%2F11452172135%2F1000&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto
---

## 问题描述：

input 为什么能输入内容？

## 思路：

1. 以 Chrome 为例，F12 打开 Chrome 浏览器控制台，点击设置，开启 Element 下的 Show user agent shadow DOM 选项，可以看见一些隐藏的结构：

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670411600005-e67a8576-4926-4c9f-a693-0dae1476a22c.png#averageHue=%23fdfcfc&clientId=ub72215d0-37c7-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=251&id=uc383f482&margin=%5Bobject%20Object%5D&name=image.png&originHeight=251&originWidth=1773&originalType=binary&ratio=1&rotation=0&showTitle=false&size=30458&status=done&style=none&taskId=u15f3b7d1-1863-4e10-9d77-0a364b87f3a&title=&width=1773)

> 可以看到 input 标签下有一个 shadow-dom，点开 shadow-dom 可以看到里面的内容。这其中的内容就是具体的实现。

## Shadow DOM

### 什么是 Shadow DOM？

Shadow DOM 是”DOM 中的 DOM“，是独立的 DOM，具有自己的元素和样式，与原始 DOM 完全隔离，是我们无法控制操作的 DOM。
相当于一个作用域的概念，使其不被外部所影响。可以看做是一颗单独的 DOM 树，这样就不会有 css 的命名冲突或样式的意外泄漏的情况。

### 为什么需要 Shadow DOM？

- shadow dom 是游离于 DOM 树之外的节点树，但其创建是基于普通的 DOM 元素（非 document），并且创建的节点可以直接从界面上直观的看到
- shadow dom 有良好的密封性（浏览器提供的一种“封装”功能，提供了一种强大的技术去隐藏一些实现细节。）

如何创建 shadow dom？

- 首先，需要一个 shadow root，shadow root 是 shadow 树中最顶层的节点，是在创建 shadow dom 时被附加到常规 DOM 节点的内容，具有与之关联的 shadow root 的节点称为 shadow host。

> 注意：
>
> 1. 只有封闭区域，才能作为 shadow Host
> 2. 当我们把一个标签设置成 shadow dom 时，里面的子元素将全部失效。
> 3. 当 mode 为 closed 时，禁止你使用的 shadow Root 属性从 root 外部访问 shadow root 元素
>
> 如何修改 shadow dom 的样式？
>
> 1. 在 shadow 块下面创建 style 标签，在里面添加样式。
> 2. mode 为 true 时，通过 shadow root 获取到指定元素修改样式。
> 3.
