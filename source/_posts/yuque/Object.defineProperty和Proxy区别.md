---
title: Object.defineProperty和Proxy区别
categories: Vue
date: 2022-11-18
updated: 2022-11-18
tags: Vue
cover: https://n.sinaimg.cn/sinacn20191110ac/25/w1000h625/20191110/82c7-iieqapt1512506.jpg
---

## 代理和反射

vue2 中的 Object.defineProperty()和 vue3 中的 Proxy()本质上的作用都是代理。
那么什么是代理和反射呢？

- 反射和代理就是**一种拦截并向基本操作嵌入额外行为的能力。**本质上属于数据劫持**。**
- 反射**Reflect** 是一个内建对象**，**可简化 Proxy 的创建。
- Reflect 对象使调用一些内部方法（[[Get]]、[[Set]]等）成为可能，它的方法是内部方法的最小包装。
  - Reflect 允许我们将操作符（new，delete 等）作为函数（`Reflect.construct`，`Reflect.deleteProperty`等）执行调用。
  - 对于每个可被`Proxy`捕获的内部方法，在`Reflect`中都有一个对应的方法，其名称和参数与 Proxy 捕捉器相同。所以，我们可以使用 Reflect 来将操作转发给原始对象。
  - Reflect 调用的命名与捕捉器的命名完全相同，并且接收相同的参数，因此，return Reflect ... 提供了一个安全的方式，可以轻松地转发操作，并确保我们不会忘记与此相关的任何内容。
- 代理是目标对象抽象，也就是说，它可以用做目标对象的替身，但又完全独立于目标对象。目标对象既可以直接被操作，也可以通过代理来操作。

来个简单的例子理解代理操作：

```javascript
const target = {
  id: "target",
}; // 目标对象
const handler = {}; // 代理对象
const proxy = new Proxy(target, handler);
console.log(target.id); // target
console.log(proxy.id); // target
```

> 显然，通过 Proxy 代理把目标对象上的属性映射到了代理对象身上。

## Object.defineProperty() 与 Proxy 的区别

### Object.defineProperty()

defineProperty() 捕获器会在 Object.defineProperty()中被调用。
Object.defineProperty()方法会直接在一个对象上定义一个新属性，或者修改也跟对象的现有属性，并返回此对象。
**defineProxy()捕获器处理程序参数**：

1. obj：要在其上定义属性的对象
2. prop：要定义或修改的属性的名称或 Symbol
3. descriptor：定义或修改的属性描述符

```javascript
Object.defineProperty(obj, prop, descriptor);
```

缺点：只能劫持对象的属性，无法监听新增属性和数组的变化（Vue）。

> 对象中目前存在的属性描述符有两种主要形式：数据（属性）描述符和存取描述符（访问器属性）。数据描述符是一个具有值的属性，该值是可写的，也可以是不可写的。存取描述符是由 getter 函数和 setter 函数所描述的属性。一个描述符只能是这两者其中之一，**不能同时是两者。**
> 属性描述符：
>
> - value：值
> - writable：如果为 true，则会被在循环中列出，否则不会被列出
> - emumerable：如果为 true，则会被在循环在列出，否则不会被列出。
> - configurable：如果为 true，则此属性可以被删除，这些特性也可以被修改，否则不可以。
>
> **访问器属性：**
>
> - get：一个没有参数的函数，在读取属性时工作
> - set：带有一个参数的函数，当属性被设置时调用
> - enumerate：与数据属性的相同
> - configurable：与数据属性的相同

### Proxy

> Proxy 主要用于改变对象的默认访问行为，实际上是在访问对象前增加一层拦截，在任何对对象的访问行为都会通过这层拦截。

Proxy 的参数为：

1. target：目标对象
2. handler：配置对象，用来定义拦截的行为
3. proxy：Proxy 构造器的实例

体现的功能有：

1.  拦截功能
2.  提供对象访问
3.  **可以重写属性或构造函数**

#### 好处

1. 能够代理任何对象包括数组和函数、对象
2. 比 Object.defineProperty()更多的语义的操作（get、set、delete）
3. 不用循环遍历对象，然后再使用 Object.defineProperty，Proxy 可以代理对象内的所有属性
4. Object.defineProperty() 只能劫持对象的属性（给对象新添加属性 vue 无法检测到）

#### 局限性

1. 无法代理内部对象的内部插槽
   1. 许多内建对象，例如 Map、Set、Date、Promise 等，都使用了所谓的“内部插槽“。

例如：

```javascript
let map = new Map();
let proxy = new Proxy(map, {});
proxy.set("test", 1); // Error
```

解决方法：在 get 时将 get 要返回的值先绑定目标对象后返回。

```javascript
let map = new Map();

let proxy = new Proxy(map, {
  get(target, prop, receiver) {
    let value = Reflect.get(...arguments);
    return typeof value == "function" ? value.bind(target) : value;
  },
});

proxy.set("test", 1);
alert(proxy.get("test")); // 1（工作了！）
```

2. 无法代理私有字段（同上）
3. proxy != target 代理对象和目标对象是不===的。

#### 总结

- Proxy 是对象的包装器，将代理上的操作转发给对象，并可以选择捕获其中一些操作。
- 可以包含任何类型的对象，包括类和函数。
- Reflect 旨在补充 Proxy，对于任意 Proxy 捕捉器，都有一个带有相同参数的 Reflect 调用，我们应该使用它们将调用转发给目标对象。

### 区别

1. Proxy 是对整个对象的代理，而 Object.defineProperty()只能代理某个属性

```javascript
//Proxy
var target = {
  a: 1,
  b: {
    c: 2,
    d: { e: 3 },
  },
};
var handler = {
  //捕获器
  get: function (trapTarget, prop, receiver) {
    console.log("触发get:", prop);
    return Reflect.get(trapTarget, prop); // 反射API // 只要在代理上调用，所有捕获器都会拦截它们对应的反射API操作
  },
  set: function (trapTarget, key, value, receiver) {
    console.log("触发set:", key, value);
    return Reflect.set(trapTarget, key, value, receiver);
  },
};
const proxy = new Proxy(target, handler);
// 访问
proxy.b.c; // 触发get: b
proxy.b.d.e; // 触发get: b //说明都不能够遍历到深层次的地方，只能代理最外层属性
console.log(proxy); //{ a: 1, b: { c: 2, d: { e: 3 } } }

// Object.defineProperty
const obj = {};
Object.defineProperty(obj, "name", {
  value: "张三",
});
console.log(obj.name); // '张三'
obj.name = "李四"; // 给obj.name赋新值
console.log(obj.name); // 张三  //默认writable为false，即不可改
```

2. 对象上新增属性和数组新增修改，Proxy 可以监听到，Object.defineProperty()不能（Vue2 中）
3. 若对象内部属性要全部递归代理，Proxy 可以只在调用时递归，而 Object.defineProperty()需要一次性完成所有递归，性能比 Proxy 差。

假如对象嵌套层级比较深的话，每一次都需要循环遍历（采用递归代理）。

4. Proxy 只在现代浏览器采用，不兼容 IE，Object.defineProperty()不兼容 IE8 及以下
5. 如果 Object.defineProperty 遍历到对象不存在的属性时，它是检测不到变化的。

## Vue2 和 Vue3 代理基础架构对比

### Vue2 中的 defineProperty 基础架构

假如我们定义考了一个 defineProperty()函数来实现代理映射的效果，里面包含了 get 和 set 方法，如果触发了 get 方法，那么直接映射源数据 value；
如果触发了 set 方法，那么先判断新的数据是否等于原来的数据，这样做是为了避免无效更新视图层，减少性能损耗。
如果不等于源数据，那么就将 newValue 更新赋值给 value。
然后再更新视图层，这样就实现了最基本的响应式数据。

```javascript
const dinner = {
  meal: "tacos",
};

function defineReactive(target, key, value) {
  Object.defineProperty(target, key, {
    get() {
      return value;
    },
    set(newValue) {
      if (newValue !== value) {
        value = newValue;
        //更新视图层
      }
    },
  });
}

for (let key in dinner) {
  defineReactive(dinner, key, dinner[key]);
}

console.log("set之前", dinner.meal); //set之前 tacos

dinner.meal = "changed";

console.log("set之后", dinner.meal); //set之后 changed
```

### Vue3 中的 Proxy 基础架构

```javascript
const dinner = {
  meal: "tacos",
};

const handler = {
  //这里的key指的是访问的property
  get(target, key) {
    return target[key];
  },
  set(target, key, value) {
    target[key] = value;
  },
};

const proxy = new Proxy(dinner, handler);

console.log("set之前", proxy.meal); //set之前 tacos

proxy.meal = "changed";

console.log("set之后", proxy.meal); //set之后 changed
```

可以看到都能实现响应式数据变化。
但是，我们考虑到如果是多层嵌套或者数组时，更改一下 defineProperty 中的例子：
把原对象变为：

```javascript
const dinner = {
  meal: "tacos",
  a: {
    b: [1, 2, 3],
    c: {
      d: "",
      e: "",
    },
  },
};
```

那么在层级比较深并且包含数组的情况下，该如何实现响应式呢？
此时，我们需要一个 observer 来观测 value 的类型，再决定遍历的方式和次数。

```javascript
function observer(target) {
  if (typeof target !== "object" || target == null) {
    return target;
  }
  if (Array.isArray(target)) {
    //拦截数组，给数组的方法进行了重写
    Object.setPrototypeOf(target, proto);
    //target.__proto__ = proto
    for (let i = 0; i < target.length; i++) {}
    observer(target[i]);
  } else {
    //是对象的话，就进行层层递归
    for (let key in target) {
      defineReactive(target, key, target[key]);
    }
  }
}
function defineReactive(target, key, value) {
  //递归遍历，继续拦截对象
  observer(value);
  Object.defineProperty(
    (target,
    key,
    {
      get() {
        return value;
      },
      set(newValue) {
        if (newValue !== value) {
          observer(newValue);
          // updateView 更新视图的方法
          value = newValue;
        }
      },
    })
  );
}
```

> 这里可以看出 defineProperty 的缺点，在重写的 defineReactive 方法里，显然性能损耗基本上是在 observer 上。
> 而在 Vue3 中的 Proxy 可以很好的解决上面的问题。

## 总结

相同点：二者都可以对属性进行代理。
不同点：

1. 代理的粒度不同：defineProperty 只能代理对象的属性，Proxy 代理的是对象。

- 如果想代理对象的所有属性，defineProperty 需要遍历属性一个个加 setter 和 getter。
- 而 Proxy 只需要配置一个可以获取属性名参数的函数即可。
- 如果出现嵌套的函数，Proxy 也是要递归进行代理的，但可以做惰性代理（按需代理），即用到嵌套对象时再创建对应的 Proxy。

2. 是否破坏原对象。

**defineProperty 的代理行为是在破坏原对象的基础上实现的**，它通常会将原来的 value 变成了 setter 和 getter。
**Proxy 则不会破坏原对象**，只是在原对象上覆盖了一层。当新增属性时，希望属性被代理，defineProperty 需要显式调用该 API，而 Proxy 则可以直接用`obj.key = val`的形式。
Proxy 返回的是一个新的对象，我们可以只操作新的对象达到目的，而 Object.defineProperty 只能遍历对象属性直接修改。

3. 代理数组属性

defineProperty 只能代理常规对象，不适合监听数组属性，因为数组长度可能很大，比如几百万，一个个对索引使用 defineProperty 是无法接受的。

- 一种方法是重写数组的 API 方法（比如 splice），通过它们来实现代理，但它是有缺陷的：直接用 arr[1] = 100 无法触发代理。（Vue2 做法）
- 另外，我们无法对数组的 length 做代理。这暴露了 defineProperty 的一个缺陷：**设置了 configurable 为 false 的属性无法进行代理。**数组的 length 就是这种情况。

Proxy 则没有这个问题，它只需要设置一个 setter 和 getter，在属性变化时，能够在函数参数上拿到索引值。**它可以代理任何对象（函数、数组、类），不能代理内部对象的内部插槽。**

4. 代理范围：defineProperty 只能代理属性的 get 和 set。

Proxy 还能代理其他的行为，比如 delete 和 handler.getPropertypeOf()等方法。

5. 兼容性：Proxy 是 ES6 新增的特性，兼容性不如 defineProperty。

IE 不支持 Proxy。
且 Proxy 不能被[polyfill](https://blog.csdn.net/sujinchang939024/article/details/118498394)磨平，因为它是在编程语言层面上的修改。
Proxy 还有一些性能问题，但作为标准，浏览器会持续做重点性能优化。
