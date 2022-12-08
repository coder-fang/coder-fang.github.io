---
title: shadow dom
categories: HTML
date: 2022-11-18
updated: 2022-11-18
tags: HTML
cover: https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_bt%2F0%2F11452172135%2F1000&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto
---

## 问题引入：

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

### 如何创建 Shadow DOM？

- 首先，我们指定一个**宿主节点（shadow host）**，然后创建影子根（**shadow root**），为它添加一个文本节点，但结果宿主中的内容未被渲染。

```javascript
<div class="widget">Hello, world!</div>
<script>
    var host = document.querySelector(".widget");
    var root = host.attachShadow({
        mode: "open",
    });
    root.textContent = "我在你的 div 里！";
</script>
```

运行结果：
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670422798069-f562239f-89c6-4f2a-8d0f-aae3f8b6649e.png#averageHue=%23f7f5f2&clientId=uad761d21-c926-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=45&id=u2d957b6e&margin=%5Bobject%20Object%5D&name=image.png&originHeight=45&originWidth=165&originalType=binary&ratio=1&rotation=0&showTitle=false&size=1504&status=done&style=none&taskId=ub2c481b1-f2d9-4795-b052-03be1629b4f&title=&width=165)
那么如何渲染宿主节点中的内容？
可以使用`slot`标签。由于目前`content`标签已经弃用，可以使用`slot`标签代替。

```javascript
<div class="pokemon">大酱</div>
<template class="pokemon-template">
  <h1>你好，我是<slot></slot>，请多指教！</h1>
</template>
<script>
    var host = document.querySelector(".pokemon");
    var root = host.attachShadow({
        mode: "open",
    });
    var template = document.querySelector(".pokemon-template");
    console.log(template.content);
    root.appendChild(document.importNode(template.content, true));
</script>
```

显示结果：
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670461761397-6539319a-0082-40d0-baf6-0a4fcebd213c.png#averageHue=%23fcfcfc&clientId=uad761d21-c926-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=436&id=u5a2119b7&margin=%5Bobject%20Object%5D&name=image.png&originHeight=436&originWidth=1527&originalType=binary&ratio=1&rotation=0&showTitle=false&size=40541&status=done&style=none&taskId=u92268cff-b2b9-4206-bdc1-45ae22630b2&title=&width=1527)
`<slot>`标签创建了一个**插入点**将`.pokemon`里面的文本投影出来，多个内容匹配时可以使用`name`属性指定。

```javascript
<div class="host">
    <p>啦啦啦啦</p>
    <span slot="name">大酱呀</span>
</div>
<template class="root-template">
  <dl>
    <h1><dt>名字</dt></h1>
    <dd><slot name="name"></slot></dd>
    <p><slot name=""></slot></p>
  </dl>
</template>
<script>
    var host = document.querySelector(".host");
    var root = host.attachShadow({
        mode: "open",
    });
    var template = document.querySelector(".root-template");
    root.appendChild(document.importNode(template.content, true));
</script>
```

显示结果：
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670463834689-262852ec-d76f-47a7-9903-577fd8aff11d.png#averageHue=%23fefefd&clientId=uad761d21-c926-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=570&id=u435a022b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=570&originWidth=1630&originalType=binary&ratio=1&rotation=0&showTitle=false&size=41095&status=done&style=none&taskId=u0a1b5c5f-6eb8-496b-a7f6-c2bd4485332&title=&width=1630)

> 注意：
>
> 1. 只有封闭区域，才能作为 shadow Host
> 2. 当我们把一个标签设置成 shadow dom 时，里面的子元素将全部失效。
> 3. 当 mode 为 closed 时，禁止你使用的 shadow Root 属性从 root 外部访问 shadow root 元素

> 如何修改 shadow dom 的样式？
>
> 1. 在 shadow 块下面创建 style 标签，在里面添加样式。
> 2. mode 为 true 时，通过 shadow root 获取到指定元素修改样式。

### 样式渲染

```javascript
<style>
    button {
        font-size: 18px;
        font-family: "华文行楷";
    }
</style>
<button>普通按钮</button>
<div></div>
<script>
    var host = document.querySelector("div");
    var root = host.attachShadow({
        mode: "open",
    });
    root.innerHTML =
        "<style>button { font-size: 24px; color: blue; } </style>" +
        "<button>影子按钮</button>";
</script>
```

显示结果：
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670464937931-193bdb09-7043-4572-b2d6-365c57e08a36.png#averageHue=%23fefdfd&clientId=uad761d21-c926-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=545&id=u8c66ed9a&margin=%5Bobject%20Object%5D&name=image.png&originHeight=545&originWidth=1809&originalType=binary&ratio=1&rotation=0&showTitle=false&size=50929&status=done&style=none&taskId=u700c6088-7f12-480e-966e-b7832f65bc5&title=&width=1809)
在影子节点中存在边界使 shadow dom 样式和正常 DOM 流中的样式互不干扰，这是一种作用域化的体现，不用担心样式的相互冲突。
