---
title: requestAnimationFrame 是宏任务还是微任务？
categories: JS
updated: 2022-11-02
tags: [JS, EventLoop]
cover: https://img.zcool.cn/community/01a454564ecc1b6ac7251c942be736.jpg@3000w_1l_2o_100sh.jpg
---

## 思考

需要搞懂几个问题：

- 浏览器在每一轮 Event Loop 事件循环中都会去渲染屏幕吗？
- requestAnimationFrame 在哪个阶段执行？在渲染前还是渲染后？在微任务执行前还是执行后？
- requestIdleCallback 在哪个阶段执行？在渲染前还是渲染后？在微任务执行前还是执行后？

## 任务的执行时机

1. 从 task 任务队列中取第一个 task（比如 setTimeout、setInterval 的回调，也可以将同一轮循环中的所有同步代码看做是一个宏任务），执行它。
2. 执行微任务队列中的所有微任务。
3. 浏览器判断是否更新渲染屏幕，如果需要重新绘制，则执行步骤 4-13，如果不需要重新绘制，则流程回到步骤 1，这样不断循环。
4. 触发 resize、scroll 事件，建立媒体查询（执行一个任务中如果生成了微任务，则执行完该任务后就会执行所有的微任务，然后再执行下一个任务）
5. 建立 css 动画（执行一个任务中如果生成了微任务，则执行完该任务后就会执行所有的微任务，然后再执行下一个任务）
6. 执行 requestAnimationFrame 回调（执行一个任务中如果生成了微任务，则执行完该任务后就会执行所有的微任务，然后再执行下一个任务）
7. 执行 IntersectionObserver 回调（执行一个任务如果生成了微任务，则执行完该任务后就会执行所有的微任务，然后再执行下一个任务）
8. 更新渲染屏幕
9. 浏览器判断当前帧是否还有空闲时间，如果有空闲时间，则执行步骤 10-12
10. 从 requestIdleCallback 回调函数队列中取第一个，执行它。
11. 执行微任务队列中的所有微任务
12. 流程回到步骤 9，直到 requestIdleCallback 回调函数队列清空或当前帧没有空闲时间。
13. 流程回到步骤 1，这样不断循环。

## 代码验证

```javascript
requestAnimationFrame(() => {
  console.log(111);
  setTimeout(() => {
    console.log(222);
  });
  Promise.resolve().then(() => {
    console.log(333);
  });
});

requestAnimationFrame(() => {
  console.log(444);
  Promise.resolve().then(() => {
    console.log(555);
  });
});
```

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1671672994069-2b015f55-6d24-42b0-b653-993f864eec6d.png#averageHue=%23fefdfc&clientId=u25a5a273-5a64-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=464&id=u6973afd5&margin=%5Bobject%20Object%5D&name=image.png&originHeight=464&originWidth=337&originalType=binary&ratio=1&rotation=0&showTitle=false&size=17131&status=done&style=none&taskId=u51a1ab91-4cfd-4fc5-af51-e147640df5d&title=&width=337)

```javascript
requestIdleCallback(() => {
  console.log(111);
  setTimeout(() => {
    console.log(222);
  });
  Promise.resolve().then(() => {
    console.log(333);
  });
});

requestIdleCallback(() => {
  console.log(444);
  Promise.resolve().then(() => {
    console.log(555);
  });
});
```

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1671673100584-2efbdfa9-c826-4fb6-a0a1-d8498bdfcede.png#averageHue=%23fefdfc&clientId=u25a5a273-5a64-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=446&id=u4b5427de&margin=%5Bobject%20Object%5D&name=image.png&originHeight=446&originWidth=322&originalType=binary&ratio=1&rotation=0&showTitle=false&size=16373&status=done&style=none&taskId=ua33a576c-1341-441b-8ca6-3fcc1e8d470&title=&width=322)

```javascript
Promise.resolve().then(() => {
  console.log(111);
  setTimeout(() => {
    console.log(222);
  });
  Promise.resolve().then(() => {
    console.log(333);
  });
});

Promise.resolve().then(() => {
  console.log(444);
  Promise.resolve().then(() => {
    console.log(555);
  });
});
```

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1671673156005-1a13fb44-cd87-4fd6-92a2-ea6ab2929074.png#averageHue=%23fefefd&clientId=u25a5a273-5a64-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=448&id=u28ce4348&margin=%5Bobject%20Object%5D&name=image.png&originHeight=448&originWidth=653&originalType=binary&ratio=1&rotation=0&showTitle=false&size=24535&status=done&style=none&taskId=u28207d99-d552-47d6-8655-309fedbee4d&title=&width=653)
<a name="ZFewK"></a>

## 结论

1. requestAnimationFrame 和 requestIdleCallback 是和宏任务一样性质的任务，只是它们的执行时机不同。
2. 浏览器在每一轮事件循环中不一定会去重新渲染屏幕，会根据浏览器刷新率以及页面性能或是否后台运行等因素判断，浏览器的每一帧是比较固定的，会尽量保持 60Hz 的刷新率运行，每一帧中间可能会进行多轮事件循环。
3. requestAnimationFrame 回调的执行与 task 和 microtask 无关，而与浏览器是否渲染相关。它是在浏览器**渲染前**，在微任务执行后执行。
4. requestIdleCallback 是在浏览器**渲染后**有空闲时间时执行，如果 requestIdleCallback 设置了第二个参数 timeout，则会在超时后的下一帧强制执行。
