---
title: Vue 响应式原理和双向绑定原理区分
categories: Vue
date: 2022-11-18
updated: 2022-11-18
tags: Vue
cover: https://cdn.jsdelivr.net/gh/coder-fang/myBlogImgRespository/img/20221208162638.png
---

# 数据响应式原理

通过**数据劫持结合发布-订阅者模式**的方式来实现的。
Vue 内部通过 Object.defineProperty() 监听对象属性的改变，它有对应的两个描述属性 get 和 set，当数据发生改变后，通过此方法对两个属性进行重写操作，从而通过发布-订阅者模式通知界面发生改变。
Vue2 是借助 Object.defineProperty() 实现的，而 Vue3 是借助 Proxy 实现的，通过 Proxy 对象创建一个对象的代理，并且 Proxy 的监听是深层次的，监听整个对象，而不是某个属性。
**发布-订阅者模式：**
![](https://raw.githubusercontent.com/coder-fang/myBlogImgRespository/master/img/20221208120909.png)

1. new Vue() 首先执行初始化，对 data 执行响应化处理，此过程发生在 Observer 中
2. compiler 对模板执行编译，找到其中动态绑定的数据，从 data 中获取并初始化视图
3. 由于 data 的某个 key 在一个视图中可能出现多次，所以每个 key 都需要一个管家 Dep 来管理多个 Watcher
4. 同时定义一个更新函数 update()和 Watcher，将来对应数据变化时 Watcher 会调用更新函数。
5. 一旦 data 中数据发生变化，会首先找到对应的 Dep，通知所有的 Watcher 执行更新函数，然后更新视图。

### Vue2 的实现：

```javascript
Object.defineProperty(obj, key, {
  enumerable: true,
  configurable: true,
  //拦截get，当我们访问data.key时会被这个方法拦截到
  get: function getter() {
    //我们在这里收集依赖
    return obj[key];
  },
  //拦截set，当我们为data.key赋值时会被这个方法拦截到
  set: function setter(newVal) {
    //当数据变更时，通知依赖项变更UI
  },
});
```

- 通过 Object.defineProperty() 为对象 obj 添加属性，可以设置对象属性的 getter 和 setter 函数。
- 之后我们每次通过点语法获取属性都会执行这里的 getter 函数，此函数中我们把调用此属性的依赖收集到一个集合中；
- 而在我们给属性赋值时（修改属性），会触发这里定义的 setter 函数，在此函数中会去通知集合中的依赖更新，做到数据驱动视图更新。

### Vue3 的实现：

Vue3 与 Vue2 的核心思想一致，不过数据的劫持使用的是 Proxy 而不是 Object.defineProperty() ，只不过 Proxy 相比 Object.defineProperty() 在处理数组和新增属性的响应式处理上更加方便。

```javascript
let nObj = new Proxy(obj, {
  //拦截get，当我们访问nObj.key时会被这个方法拦截到
  get: function (target, propKey, receiver) {
    console.log(`getting ${propKey}!`);
    return Reflect.get(target, propKey, receiver);
  },
  //拦截set，当我们为nObj.key赋值时会被这个方法拦截到
  set: function (target, propKey, value, receiver) {
    console.log(`setting ${propKey}!`);
    return Reflect.set(target, propKey, value, receiver);
  },
});
```

# 数据双向绑定原理

可以通过 v-model 和修饰符.sync 两种方式实现，像在组件中使用 v-model 就属于双向绑定。
v-model 本质是：

1. 将动态的 data 通过 value 属性传递给 input 显示
2. 给 input 标签绑定 input 监听，一旦输入改变，读取最新的值保存到 data 对应属性上

双向绑定由三个重要部分构成：

- 数据层（Model）：页面渲染所需要的数据
- 视图层（View）：所呈现出的页面
- 业务逻辑层（ViewModel）：框架封装的核心；重要职责：数据变化后更新视图，视图变化后更新数据。

### 使用 Object.defineProperty()实现双向绑定

```javascript
<body>
    hello,world
    <input type="text" id="model" oninput="handleChange()" />
    <p id="word"></p>
</body>
<script>
    // TODO  双向数据绑定：页面中输入框中用户输入变化时其它控件中内容也跟着变化
    let input = document.getElementById("model");
    let p = document.getElementById("word");
    let data = {};
    Object.defineProperty(data, "val", {
        set: function(newVal) {
            val = newVal;
            input.value = val;
            p.innerHTML = val;
        },
        get: function() {
            return val;
        },
    });

    function handleChange() {
        data.val = input.value; // 触发set
    }
</script>
```

效果：在输入内框内输入内容，下方数据会相应改变。
![](https://raw.githubusercontent.com/coder-fang/myBlogImgRespository/master/img/20221208124835.png)

### 使用 Proxy 实现响应式

```javascript
<button>click me</button>
<script>
    const btn = document.querySelector("button");

    const obj = {
        naisu: 233
    };
    const handler = {
        get: function(target, property, receiver) {
            return target[property];
        },
        set: function(target, property, value, receiver) {
            target[property] = value;
            btn.innerText = `Naisu is ${target[property]}.`; // 值在改变的同时更新视图
            return true;
        },
        // 注意target属性操作使用[]
    };
    const objProxy = new Proxy(obj, handler);

    btn.onclick = () => {
        objProxy.naisu = objProxy.naisu + 1; // 在真正操作时只要关系数据就行
    };
</script>
```

![](https://raw.githubusercontent.com/coder-fang/myBlogImgRespository/master/img/20221208125406.png)
好处：数据驱动视图，之后操作关心数据本身即可，无需因为数据改变去手动操作视图了。

### Proxy 实现数据双向绑定

```javascript
<body>
    hello,world
    <input type="text" id="model" oninput="inputHandler()" />
    <p id="word"></p>
</body>
<script>
    // TODO  ES6实现
    const input = document.getElementById("model");
    const p = document.getElementById("word");
    const obj = {
        naisu: 233,
    };
    const handler = {
        get: function(target, property, receiver) {
            return target[property];
        },
        set: function(target, property, value, receiver) {
            target[property] = value;
            p.innerHTML = `Naisu is ${target[property]}`;
            return true;
        },
    };
    const objProxy = new Proxy(obj, handler);

    function inputHandler() {
        objProxy.naisu = input.value; // 输入事件中改变代理对象属性值
    }
</script>
```

![](https://raw.githubusercontent.com/coder-fang/myBlogImgRespository/master/img/20221208125431.png)
