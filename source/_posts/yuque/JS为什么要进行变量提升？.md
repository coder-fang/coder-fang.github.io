---
title: JS为什么要进行变量提升？
categories: JS
date: 2022-11-15
updated: 2022-11-15
tags: JS
cover: https://img2.baidu.com/it/u=101925709,3442706391&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500
---

## 1.变量提升如何体现？

变量提升通常发生在 var 声明的变量里，使用 var 声明一个变量时，该变量会被提升到作用域的顶端，但是赋值的部分并不会被提升。
**原理：**

1. JS 引擎工作方式：先解析代码，获取所有被声明的变量
2. 然后再运行。

## 2.为什么要进行变量提升？

首先，我们知道 JS 拿到一个变量时会进行解析和执行。

- 在解析阶段，JS 会检查语法，并对函数进行预编译。解析时会先创建一个全局执行上下文环境，先把代码中即将执行的变量、函数声明都拿出来，变量先赋值为 undefined，函数先声明好可使用。在一个函数执行之前，也会创建一个函数执行上下文环境，跟全局上下文环境类似，不过函数上下文会多出 this、arguments 和函数的参数。
  - 全局上下文：变量定义、函数声明
  - 函数执行上下文：变量定义、函数声明、this、arguments
- 在执行阶段，按照代码的顺序依次执行

为什么会进行变量提升？

- 提高性能
- 容错性更好

### （1）提高性能

- JS 代码执行之前，会进行**语法检查和预编译**，并且这一操作只进行一次。

这样做是为了提高性能，如果没有这一步，那么每次执行代码前都必须重新编译一遍该变量（函数），而这是没有必要的，因为变量（函数）的代码并不会改变，解析一遍就够了。

- 在**解析**的过程中，还会为函数**生成预编译代码**。在预编译时，会统计声明了哪些变量、创建了哪些函数，并对函数的代码进行压缩，取出注释、不必要的空白等。好处：每次执行函数时都可以直接为该函数分配栈空间（不需要再解析一遍去获取代码中声明了哪些变量、创建了哪些函数），并且因为代码压缩的原因，代码执行也更快了。

### （2）容错性更好

变量提升可以在一定程度上提高 JS 的容错性。

```javascript
a = 1;
var a;
console.log(a);
```

如果没有变量提升，这两行代码就会报错，但是因为有了变量提升，这段代码就可以正常执行。
虽然，我们可以在开发过程中，可以完全避免这样写，但是有时候很复杂时，可能因为疏忽而先使用后定义了，这样也不会影响正常使用。由于变量提升的存在，而会正常运行。

### 总结：

- **解析和预编译过程中的声明提升可以提高性能，让函数可以在执行时预先为变量分配栈空间。**
- **声明提升还可以提高 JS 代码的容错性，使得一些不规范的代码也可以正常运行。**

## 3.变量提升导致的问题

变量提升虽然有一些优点，但是也会造成一些问题，在 ES6 中提出了 let、const 来定义变量，它们就没有变量提升的机制。
变量提升会导致的问题：

```javascript
var tmp = new Date();
function fn() {
  console.log(tmp);
  if (false) {
    var tmp = "hello world";
  }
}
fn(); //  undefined
```

在这个函数中，原本是要打印出外层的 tmp 变量，但是因为变量提升的问题，内层定义的 tmp 被提到哈函数内部的最顶部，相当于覆盖了最外层的 tmp，所以打印结果为 undefined。

```javascript
var tmp = "hello world";
for (var i = 0; i < tmp.length; i++) {
  console.log(tmp[i]);
}
console.log(i); // 11
```

由于遍历时定义的 i 会变量提升为一个全局变量，在函数结束后，不会被销毁，所以打印出来 11.
