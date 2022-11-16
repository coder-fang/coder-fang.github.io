---
title: JS高频面试题
categories:  JS
tags:  JS
---

## apply、call、bind 的区别

- 三者都可以改变函数的 this 对象指向
- 三者第一个参数都是 this 要指向的对象，如果如果没有这个参数或参数为 undefined 或 null，则默认指向全局 window
- 三者都可以传参，但是 apply 是数组，而 call 是参数列表，且 apply 和 call 是一次性传入参数，而 bind 可以分为多次传入
- bind 是返回绑定 this 之后的函数，需要手动执行函数，apply、call 则是立即执行

## new 操作符的实现原理

new 操作符的执⾏过程：
（1）⾸先创建了⼀个新的空对象
（2）设置原型，将对象的原型设置为函数的 prototype 对象。
（3）让函数的 this 指向这个对象，执⾏构造函数的代码（为这个新对象添加属性）
（4）判断函数的返回值类型，如果是值类型，返回创建的对象。如果是引⽤类型，就返回这个引⽤类
型的对象。

```javascript
function objectFactory() {
  let newObject = null;
  let constructor = Array.prototype.shift.call(arguments);
  let result = null;
  // 判断参数是否是⼀个函数
  if (typeof constructor !== "function") {
    console.error("type error");
    return;
  }
  // 新建⼀个空对象，对象的原型为构造函数的 prototype 对象
  newObject = Object.create(constructor.prototype);
  // 将 this 指向新建对象，并执⾏函数
  result = constructor.apply(newObject, arguments);
  // 判断返回对象
  let flag =
    result && (typeof result === "object" || typeof result === "function");
  // 判断返回结果
  return flag ? result : newObject;
}
// 使⽤⽅法
objectFactory(构造函数, 初始化参数);
```
