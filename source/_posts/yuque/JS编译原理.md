---
title: JS编译原理
categories: 前端进阶
date: 2022-11-11
tags: [JS, 编译原理]
---

## JS 编译原理

```javascript
var name = "rose";
```

上面这行代码在 JS 中会这样呈现：

```javascript
var name; // 编译阶段处理
name = "rose"; // 执行阶段处理
```

JS 编译主要分为两个阶段：**编译阶段和执行阶段**。

### 编译阶段

此阶段主角为**编译器。**

- JS 找遍作用域，看是否存在 name 的变量
  - 如果已经存在，则什么都不做，直接忽略`var name`这个声明，继续编译下去；
  - 如果没有，则在当前作用域中新增一个`name`变量
- 编译器会为引擎生成运行时所需的代码，程序就进入了执行阶段。

### 执行阶段

此阶段主角为**JS 引擎。**

- **JS 引擎**在运行时，会先找遍当前作用域，看是否有一个叫`name`的变量。
  - 如果有，直接赋值
  - 如果没有，则为当前作用域没有。则去父级作用域看是否有，如果无，则去上一级作用域中查找。
  - 如果最终没有找到，则抛异常。
    > 作用域套作用域，即作用域链。

## 作用域

变量最基本的能力就是**能够存储变量中的值，并且允许我们对此变量进行访问和修改**，而对于变量存储，访问的**规则**是 **作用域**。

### 全局作用域

在任何函数外或代码块外的顶层作用域就是全局作用域，里面的变量就是全局变量。

```javascript
var name = "rose"; //全局作用域

function showName() {
  //函数作用域
  console.log(name);
}
{
  name = "test"; //块级作用域
}
showName(); //test
```

> 可以看到，全局变量在全局作用域、函数作用域、块级作用域中都可以正常访问。

### 函数作用域

在函数中的作用域就是函数作用域。

```javascript
function showName() {
  var name = "jack"; //函数作用域
}
showName(); //方法调用
{
  console.log(name); //块级作用域,Uncaught ReferenceError: name is not defined
}
console.log(name); //全局作用域,Uncaught ReferenceError: name is not defined
```

> 可以看到，函数内部变量，在全局作用域及块级作用域中，都无法访问，只有在函数内部，才能访问到，所以函数内部的变量也称为**局部变量**。

### 块级作用域

`ES6`中新出的`let` 和`const`关键字 自带作用域。
块级作用域相当于是只在这块代码块中生效，如果它被大括号`{}`包围，则大括号就是一段代码块，代码块中使用`const`声明的变量也被称为**局部变量。**

```javascript
 {
   let name='rose';
 }

 console.log(name);    //Uncaught ReferenceError: name is not defined

 function showName{
   console.log(name);
 }

 showName();    //Uncaught ReferenceError: name is not defined
```

> 可以看到，块级作用域中的变量，在代码块外面就访问不到了。

## 作用域链

**作用域和作用域的嵌套，就产生了作用域链。作用域链的查找，向外不向内。**

## 变量提升

```javascript
name = "rose";
console.log(name); //rose
var name;
```

可以发现，这段代码可以正常运行，并且不会报错。
在 JS 眼中代码实际上是这样的：

```javascript
var name;
name = "rose";
console.log(name); // rose
```

---

`let`和`const`代码：

```javascript
name = "rose";
console.log(name); //Uncaught ReferenceError: Cannot access 'name' before initialization
let name;
```

> let 、const **禁用变量提升。**const 声明后必赋值。

### let、const、var 的区别

1. **块级作用域**：块级作用域由`{}`包括，`let`和`const`具有块级作用域，`var`不存在块级作用域。

块级作用域解决了`ES5`中的两个问题：

- 内层变量可能覆盖外层变量
- 用来计数的循环变量泄漏为全局变量

2. **变量提升**：var 存在变量提升，let 和 const 不存在变量提升，即变量只能在声明后使用，否则会报错。
3. **给全局添加属性**：浏览器的全局对象是 window，Node 的全局变量是 global。var 声明的变量为全局变量，并且会将该变量添加为全局对象的属性，但是 let 和 const 不会。
4. **重复声明**：var 声明变量时，可以重复声明变量，后声明的变量会覆盖之前声明的变量。let 和 const 不允许在同一作用域下重复声明变量。
5. **暂时性死区：**在使用 let、const 关键字声明变量时，该变量是不可用的，这在语法上，成为**暂时性死区**。

使用 var 声明的变量不存在暂时性死区。

6. **初始值设置**：在变量声明时，var 和 let 可以不用设置初始值。而 const 声明变量必须设置初始值。
7. **指针指向**：let 和 const 都是 ES6 新增的用于创建变量的语法。let 创建的变量可以更改指针指向（可以重新赋值）。但 const 声明的变量不允许改变指针的指向（不允许重新赋值）。

## 暂时性死区

```javascript
var name = "rose";

{
  name = "bob";
  let name; //Uncaught ReferenceError: Cannot access 'name' before initialization
}
```

**如果区块中存在 let 和 const，这个区块对于这些关键字声明的变量，从一开始就形成了封闭作用域。**
因为 JS 清楚地感知到了 name 是用 let 声明在当前这个代码块内的，所以会给这个变量 name 加上了暂时性死区的限制，它就不往外探出头了。
因此，如果我们把上面的`let name;`去掉，程序也能正常运行，name 的值也能被成功修改为 blob，就是正常地按照**作用域链**的规则，向外探出头去了。
