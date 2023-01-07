---
title: 为什么script 标签是一个宏任务
categories: JS
date: 2022-11-05
updated: 2022-11-05
tags: [JS, eventloop]
cover: https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201612%2F07%2F20161207212120_NJLCP.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673494031&t=952d53bd392fa152eb1c9f1a7c658539
---

> JS 是一门单线程的语言，因此，JS 在同一时间只能做一件事，单线程意味着，如果在同个时间有多个任务，这些任务就要排队，前一个任务执行完，才会执行下一个任务。

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670897426854-c1daf2d5-449d-48a3-9264-8fc0bca3f163.png#averageHue=%23f1eff2&clientId=u9fcda738-8167-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=477&id=u76ea3fa3&margin=%5Bobject%20Object%5D&name=image.png&originHeight=477&originWidth=763&originalType=binary&ratio=1&rotation=0&showTitle=false&size=138004&status=done&style=none&taskId=u6d065fa0-7f0c-4299-9eb1-d104661b4bd&title=&width=763)
举个栗子：

```javascript
<!-- 脚本 1 -->
<script>
	// 同步
	console.log('startA')
	// 异步宏
	setTimeout(() => console.log('A1'), 0)
	new Promise((resolve, reject) => {
		// 同步
		console.log('A2')
		resolve()
	}).then(() => {
		// 异步微
		console.log('A3')
	})
	// 同步
	console.log('A4')
</script>

<!-- 脚本 2 -->
<script>
	// 同步
	console.log('startB')
	// 异步宏
	setTimeout(() => console.log('B2'), 0)
	new Promise((resolve, reject) => {
		// 同步
		console.log('B2')
		resolve()
	}).then(() => {
		// 异步微
		console.log('B3')
	})
	// 同步
	console.log('end2')
</script>
```

结果：

```javascript
script A
A2
A4
A3
script B
B2
B4
B3
A1
B1
```

步骤：

1. 最开始，JS 引擎将这段代码解析成两个宏任务，一个是 脚本 1，一个是 脚本 2。会把这两个宏任务放到宏任务队列中去。正常情况下，JS 执行是先微后宏，此时微任务队列中没有队列任务，就跳过，去执行宏任务。

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670898463403-2dd88652-6c90-4975-9cd1-43bdb2f8db13.png#averageHue=%23f2e8e0&clientId=u9fcda738-8167-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=270&id=uc96b1a6c&margin=%5Bobject%20Object%5D&name=image.png&originHeight=270&originWidth=326&originalType=binary&ratio=1&rotation=0&showTitle=false&size=30416&status=done&style=none&taskId=u2bdc46ca-275d-42be-bb3a-9dcdb08290e&title=&width=326)

2. 因为 脚本 1 在上面，JS 会去先执行 脚本 1 ，然后就把 script A 压入 【调用栈】中。
   1. 由于第一行代码是同步代码，所以先执行。
   2. 将 timer1 压入 宏任务队列中

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670899077228-3c5733f6-f95e-4e2a-9970-a4be90412ec1.png#averageHue=%23f4f0ea&clientId=u9fcda738-8167-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=254&id=ua0c458ca&margin=%5Bobject%20Object%5D&name=image.png&originHeight=254&originWidth=405&originalType=binary&ratio=1&rotation=0&showTitle=false&size=27642&status=done&style=none&taskId=u852c97c0-9b65-4888-ad85-cf40f8a199c&title=&width=405)

3.  new Promise() 中 p1 是 同步任务，立即执行，出栈
4.  触发异步机制，进入 Promise.then() 中，触发回调，把 A3 加入微任务队列中去，等待执行

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670899089251-145264c4-b8bd-4736-874f-227312175e60.png#averageHue=%23f4e8e1&clientId=u9fcda738-8167-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=251&id=R6c2R&margin=%5Bobject%20Object%5D&name=image.png&originHeight=251&originWidth=384&originalType=binary&ratio=1&rotation=0&showTitle=false&size=26983&status=done&style=none&taskId=ub8561ed2-194e-44e9-ad21-535a0c2c240&title=&width=384)

5.  此时，按照“先微后宏“的顺序， 此时，微任务队列中有任务，就把 A3 放入调用栈中执行，输出 A3，出栈（A4 是同步代码，已经在 A3 之前执行输出）

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670899704352-7528d448-b4dc-420d-bdb3-1fb3407e8caa.png#averageHue=%23f4eae4&clientId=u9fcda738-8167-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=250&id=ud2893cfc&margin=%5Bobject%20Object%5D&name=image.png&originHeight=250&originWidth=372&originalType=binary&ratio=1&rotation=0&showTitle=false&size=29144&status=done&style=none&taskId=u9118bbad-f295-4397-a9aa-b1613dbc913&title=&width=372)
此时，微任务队列中没有任务了，事件循环会跳过微任务，去执行宏任务。会把 script B 调入调用栈中去（不是全部一下子调入调用栈中的，是按照代码先后顺序去逐行调入的）。
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670900133149-a369a583-4d6c-469c-9aa3-e37405606f13.png#averageHue=%23f4f1eb&clientId=u9fcda738-8167-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=256&id=u3fd88008&margin=%5Bobject%20Object%5D&name=image.png&originHeight=256&originWidth=369&originalType=binary&ratio=1&rotation=0&showTitle=false&size=27544&status=done&style=none&taskId=u3b91c160-41f3-40d9-8c39-c6a287ecbdb&title=&width=369)

3. 将 B1 这个宏任务加入到宏任务队列中去

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670900387253-a76291b9-45b6-4c70-a4d0-5834ec85fe36.png#averageHue=%23f3eae4&clientId=u9fcda738-8167-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=269&id=ua16f381a&margin=%5Bobject%20Object%5D&name=image.png&originHeight=269&originWidth=386&originalType=binary&ratio=1&rotation=0&showTitle=false&size=28521&status=done&style=none&taskId=u4fa9cd4e-a7b0-4776-9536-70d33baf4a2&title=&width=386)

4. B2 是同步代码，加入调用栈中，执行，输出， 出栈；输出 B4，scriptB 宏任务就结束了，调用栈清空。
5. 触发异步回调 Promise.then()，将 B3 加入到微任务队列中去。
6. 此时，如图 6，按照先微后宏的顺序，会依次把 B3、A1、B1 输出。

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670900756939-879e78a1-0df5-4020-8635-691925a5e40a.png#averageHue=%23f5f4f0&clientId=u9fcda738-8167-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=251&id=u3872b20d&margin=%5Bobject%20Object%5D&name=image.png&originHeight=251&originWidth=366&originalType=binary&ratio=1&rotation=0&showTitle=false&size=25361&status=done&style=none&taskId=u072a3081-7700-4e2e-9b97-1ad6333f86a&title=&width=366)

### 总结

`<script>` 标签是一个宏任务，因为这是一个代码段的入口，且必须要加载。

#### 为什么 JS 的微任务优先于宏任务？

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
        setTimeout(() => {
           console.log(1)
        }, 0);

        new Promise((rej)=>rej(2)).then((data)=>
            console.log(data)
        )
    </script>
</body>
</html>
```

实际上 JS 会先执行一个宏任务，再执行微任务，但是为什么微任务会先执行呢？
其实真正造成微任务优先级大于宏任务，是因为 script 本身就是一个宏任务，所以会先执行 script 这个宏任务，这个宏任务执行完又添加了一个宏任务（计时器），一个微任务（promise），但是执行完一个宏任务，该执行当前所有的微任务，所以先输出 2，执行完微任务，再去循环调用，再执行一个宏任务，也就是定时器，执行完，发现微任务为空，就暂停，等待任务的到来，这就是事件循环的原理 eventloop。
所以，在做一些面试题的过程中，我们只需要记住微任务优先级大于宏任务就可以得出真正的答案。
