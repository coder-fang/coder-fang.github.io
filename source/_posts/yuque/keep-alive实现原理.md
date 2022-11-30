---
title: keep-alive实现原理
categories: 框架
date: 2022-11-16
updated: 2022-11-16
tags: Vue
cover: https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic2.zhimg.com%2Fv2-86df8247745c62d526051662353c7739_r.jpg%3Fsource%3D1940ef5c&refer=http%3A%2F%2Fpic2.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1672407297&t=f7f5279caca9a3d4ceefbbd6876431b5
---

- 该组件内没有常规的`<template></template>`等标签，因为它不是一个常规的模板组件，取而代之的是，它内部多了一个 render 函数，它是一个函数式组件。执行`<keep-alive>`组件渲染时，就会执行这个`render`函数。
- keep-alive 缓存机制是根据 LRU 策略来设置缓存组件新鲜度，将很久未访问的组件从缓存中删除。

## 组件实现原理

```javascript
// 源码位置：src/core/components/keep-alive.js
export default {
  name: "keep-alive",
  abstract: true,
  props: {
    include: patternTypes,
    exclude: patternTypes,
    max: [String, Number],
  },
  created() {
    this.cache = Object.create(null);
    this.keys = [];
  },
  destroyed() {
    for (const key in this.cache) {
      pruneCacheEntry(this.cache, key, this.keys);
    }
  },
  mounted() {
    this.$watch("include", (val) => {
      pruneCache(this, (name) => matches(val, name));
    });
    this.$watch("exclude", (val) => {
      pruneCache(this, (name) => !matches(val, name));
    });
  },
  render() {
    const slot = this.$slots.default;
    const vnode: VNode = getFirstComponentChild(slot);
    const componentOptions: ?VNodeComponentOptions =
      vnode && vnode.componentOptions;
    if (componentOptions) {
      // check pattern
      const name: ?string = getComponentName(componentOptions);
      const { include, exclude } = this;
      if (
        // not included
        (include && (!name || !matches(include, name))) ||
        // excluded
        (exclude && name && matches(exclude, name))
      ) {
        return vnode;
      }

      const { cache, keys } = this;
      const key: ?string =
        vnode.key == null
          ? // same constructor may get registered as different local components
            // so cid alone is not enough (#3269)
            componentOptions.Ctor.cid +
            (componentOptions.tag ? `::${componentOptions.tag}` : "")
          : vnode.key;
      if (cache[key]) {
        vnode.componentInstance = cache[key].componentInstance;
        // make current key freshest
        remove(keys, key);
        keys.push(key);
      } else {
        cache[key] = vnode;
        keys.push(key);
        // prune oldest entry
        if (this.max && keys.length > parseInt(this.max)) {
          pruneCacheEntry(cache, keys[0], keys, this._vnode);
        }
      }
      vnode.data.keepAlive = true;
    }
    return vnode || (slot && slot[0]);
  },
};
```

keep-alive 实际上是一个抽象组件，只对包裹的组件做处理 ，并不会和子组件建立父子关系，也不会作为节点渲染到页面上。在组件开头就设置 abstract 为 true，代表该组件是一个抽象组件。

```javascript
// 源码位置：src/core/instance/lifecycle.js
export function initLifecycle(vm: Component) {
  const options = vm.$options;

  // locate first non-abstract parent
  let parent = options.parent;
  if (parent && !options.abstract) {
    while (parent.$options.abstract && parent.$parent) {
      parent = parent.$parent;
    }
    parent.$children.push(vm);
  }
  vm.$parent = parent;
  // ...
}
```

那么抽象组件是如何忽略这层关系的？在初始化阶段会调用 initLifecycle，里面判断父级是否为抽象组件，如果是抽象组件，就选取抽象组件中的上一级作为父级，忽略与抽象组件和子组件之间的层级关系。
keep-alive 组件没有编写 template 模板，而是由 render 函数决定是否渲染结果。

```javascript
const slot = this.$slots.default;
const vnode: VNode = getFirstComponentChild(slot);
```

如果 keep-alive 存在多个子元素，keep-alive 要求同时只有一个子元素被渲染。所以在开头会获取插槽内的子元素，调用 getFirstComponentChild 获取到第一个子元素的 VNode。

```javascript
// check pattern
const name: ?string = getComponentName(componentOptions);
const { include, exclude } = this;
if (
  // not included
  (include && (!name || !matches(include, name))) ||
  // excluded
  (exclude && name && matches(exclude, name))
) {
  return vnode;
}

function matches(
  pattern: string | RegExp | Array<string>,
  name: string
): boolean {
  if (Array.isArray(pattern)) {
    return pattern.indexOf(name) > -1;
  } else if (typeof pattern === "string") {
    return pattern.split(",").indexOf(name) > -1;
  } else if (isRegExp(pattern)) {
    return pattern.test(name);
  }
  return false;
}
```

接着判断的当前组件是否符合缓存条件，组件名与 include 不匹配或与 exclude 匹配都会直接退出并返回 vnode，不走缓存机制。

```javascript
const { cache, keys } = this;
const key: ?string =
  vnode.key == null
    ? // same constructor may get registered as different local components
      // so cid alone is not enough (#3269)
      componentOptions.Ctor.cid +
      (componentOptions.tag ? `::${componentOptions.tag}` : "")
    : vnode.key;
if (cache[key]) {
  vnode.componentInstance = cache[key].componentInstance;
  // make current key freshest
  remove(keys, key);
  keys.push(key);
} else {
  cache[key] = vnode;
  keys.push(key);
  // prune oldest entry
  if (this.max && keys.length > parseInt(this.max)) {
    pruneCacheEntry(cache, keys[0], keys, this._vnode);
  }
}
vnode.data.keepAlive = true;
```

匹配条件通过会进入缓存机制的逻辑，如果命中缓存机制，从 cache 中获取缓存的实例设置到当前的组件上，并调整 key 的位置将其放到最后，如果没有命中缓存，将当前 vnode 缓存起来，并加入到当前组件的 key。如果缓存组件的数量不足，即缓存空间不足，则调用 pruneCacheEntry 将最旧的组件从缓存中删除，即 keys[0]的组件。之后将组件的 keepAlive 标记为 true，表示它是被缓存的组件。

```javascript
function pruneCacheEntry(
  cache: VNodeCache,
  key: string,
  keys: Array<string>,
  current?: VNode
) {
  const cached = cache[key];
  if (cached && (!current || cached.tag !== current.tag)) {
    cached.componentInstance.$destroy();
  }
  cache[key] = null;
  remove(keys, key);
}
```

pruneCacheEntry 负责将组件从缓存中删除，它会调用组件`$destory`方法销毁组件实例，缓存组件置空，并移除对应的 key。

```javascript
mounted () {
  this.$watch('include', val => {
    pruneCache(this, name => matches(val, name))
  })
  this.$watch('exclude', val => {
    pruneCache(this, name => !matches(val, name))
  })
}

function pruneCache (keepAliveInstance: any, filter: Function) {
  const { cache, keys, _vnode } = keepAliveInstance
  for (const key in cache) {
    const cachedNode: ?VNode = cache[key]
    if (cachedNode) {
      const name: ?string = getComponentName(cachedNode.componentOptions)
      if (name && !filter(name)) {
        pruneCacheEntry(cache, key, keys, _vnode)
      }
    }
  }
}
```

keep-alive 在 mounted 会监听 include 和 exclude 的变化，属性发生改变时，调整缓存和 keys 的顺序，最终调用的也是 pruneCacheEntry。

### 小结

cache 用于缓存组件，keys 存储组件的 key，根据 LRU 策略来调整缓存组件。keep-alive 的 render 中最后会返回组件的 vnode，因此：keep-alive 并非真的不会渲染，而是渲染的对象是包裹的子组件。

## 组件渲染流程

## props

在选项内接收传进来的三个属性：include、exclude、max。

```javascript
props: {
    include: [String, RegExp, Array],
    exclude: [String, RegExp, Array],
    max: [String, Number]
}
```

- `include`表示只有匹配的组件会被缓存
- `exclude`表示任何匹配到的组件都不会被缓存
- `max`表示缓存组件的数量，因为我们缓存的`vnode`对象，它也会持有 DOM，当我们缓存的组件很多时，会比较占内存，所以该配置允许我们指定缓存组件的数量。

## created

在`created`钩子函数中，定义并初始化了两个属性：`this.cache`、`this.keys`。

```javascript
created () {
    this.cache = Object.create(null)
    this.keys = []
}
```

- this.cache 是一个对象，用来存储需要缓存的组件，它以如下形式存储：

```javascript
this.cache = {
  key1: "组件1",
  key2: "组件2",
  // ...
};
```

- `this.keys`是一个数组，用来存储每个需要缓存的组件的 key，即对应的 this.cache 对象中的键值。

## destroyed

当`<keep-alive>`组件被销毁时，此时会调用`destroyed`钩子函数，在该钩子函数里会遍历`this.cache`对象，然后将那些被缓存并当前没有处于被渲染状态是组件都销毁掉。

```javascript
destroyed () {
    for (const key in this.cache) {
        pruneCacheEntry(this.cache, key, this.keys)
    }
}

// pruneCacheEntry函数
function pruneCacheEntry (
  cache: VNodeCache,
  key: string,
  keys: Array<string>,
  current?: VNode
) {
  const cached = cache[key]
  /* 判断当前没有处于被渲染状态的组件，将其销毁*/
  if (cached && (!current || cached.tag !== current.tag)) {
    cached.componentInstance.$destroy()
  }
  cache[key] = null
  remove(keys, key)
}
```

## mounted

在 mounted 钩子函数中观测`include`和`exclude`的变化，如下：

```javascript
mounted () {
    this.$watch('include', val => {
        pruneCache(this, name => matches(val, name))
    })
    this.$watch('exclude', val => {
        pruneCache(this, name => !matches(val, name))
    })
}
```

如果 include 和 exclude 发生了变化，即表示定义需要缓存的组件的规则或不需要缓存的组件的规则发生了变化，则执行 pruneCache 函数，如下：

```javascript
function pruneCache(keepAliveInstance, filter) {
  const { cache, keys, _vnode } = keepAliveInstance;
  for (const key in cache) {
    const cachedNode = cache[key];
    if (cachedNode) {
      const name = getComponentName(cachedNode.componentOptions);
      if (name && !filter(name)) {
        pruneCacheEntry(cache, key, keys, _vnode);
      }
    }
  }
}
```

在该函数内对 this.cache 对象进行遍历，取出每一项的 name 值，用其与新的缓存规则进行匹配，如果匹配不上，则表示在新的缓存规则下该组件已经不需要被缓存，则调用 `pruneCacheEntry`将其从`this.cache`对象剔除即可。

## render

在 render 函数中首先获取第一个子组件节点的 vnode：

```javascript
/* 获取默认插槽中的第一个组件节点 */
const slot = this.$slots.default;
const vnode = getFirstComponentChild(slot);
```

由于我们也是在`<keep-alive>`标签内部写 DOM，所以可以先获取到默认插槽，然后再获取到它的第一个子节点。
`<keep-alive>`只处理第一个子元素，所以一般和它搭配使用的有 `component`动态组件或者是 `router-view`。
接下来，获取该组件节点的名称：

```javascript
/* 获取该组件节点的名称 */
const name = getComponentName(componentOptions);

/* 优先获取组件的name字段，如果name不存在则获取组件的tag */
function getComponentName(opts: ?VNodeComponentOptions): ?string {
  return opts && (opts.Ctor.options.name || opts.tag);
}
```

然后用组件名称跟 include、exclude 中的匹配规则去匹配。

```javascript
const { include, exclude } = this;
/* 如果name与include规则不匹配或者与exclude规则匹配则表示不缓存，直接返回vnode */
if (
  (include && (!name || !matches(include, name))) ||
  // excluded
  (exclude && name && matches(exclude, name))
) {
  return vnode;
}
```

如果组件名称与 include 规则不匹配或者与 exclude 规则匹配，则表示不缓存该组件，直接返回这个组件的 vnode，否则，走下一步缓存。

```javascript
const { cache, keys } = this;
/* 获取组件的key */
const key =
  vnode.key == null
    ? componentOptions.Ctor.cid +
      (componentOptions.tag ? `::${componentOptions.tag}` : "")
    : vnode.key;

/* 如果命中缓存，则直接从缓存中拿 vnode 的组件实例 */
if (cache[key]) {
  vnode.componentInstance = cache[key].componentInstance;
  /* 调整该组件key的顺序，将其从原来的地方删掉并重新放在最后一个 */
  remove(keys, key);
  keys.push(key);
} else {
/* 如果没有命中缓存，则将其设置进缓存 */
  cache[key] = vnode;
  keys.push(key);
  /* 如果配置了max并且缓存的长度超过了this.max，则从缓存中删除第一个 */
  if (this.max && keys.length > parseInt(this.max)) {
    pruneCacheEntry(cache, keys[0], keys, this._vnode);
  }
}
/* 最后设置keepAlive标记位 */
vnode.data.keepAlive = true;
```

- 首先获取组件的 key 值：

```javascript
const key =
  vnode.key == null
    ? componentOptions.Ctor.cid +
      (componentOptions.tag ? `::${componentOptions.tag}` : "")
    : vnode.key;
```

- 拿到 key 值后去 this.cache 对象中去寻找是否有该值，如果有则表示该组件有缓存，即命中缓存。

```javascript
/* 如果命中缓存，则直接从缓存中拿 vnode 的组件实例 */
if (cache[key]) {
  vnode.componentInstance = cache[key].componentInstance;
  /* 调整该组件key的顺序，将其从原来的地方删掉并重新放在最后一个 */
  remove(keys, key);
  keys.push(key);
}
```

- 直接从缓存中拿`vnode`的组件实例，此时重新调整该组件 key 的顺序，将其从原来的地方删除掉并重新放在 this.keys 中最后一个。
- 如果 this.cache 对象中没有该 key 值：

```javascript
/* 如果没有命中缓存，则将其设置进缓存 */
else {
    cache[key] = vnode
    keys.push(key)
    /* 如果配置了max并且缓存的长度超过了this.max，则从缓存中删除第一个 */
    if (this.max && keys.length > parseInt(this.max)) {
        pruneCacheEntry(cache, keys[0], keys, this._vnode)
    }
}
```

表明该组件还没有被缓存过，则以该组件的 key 为例，组件 vnode 为值，将其存入 this.cache 中，并且把 key 存入 this.keys 中。此时，再判断 this.keys 中缓存组件的数量是否超过了设置的最大缓存数量值 this.max，如果超过了，则把第一个缓存组件删除。

> 问题：为什么要删除第一个缓存组件并为什么命中缓存了还要调整组件 key 的顺序？

> 答：这其实应用了一个缓存淘汰策略 LRU。

### LRU 算法

LRU（最近最少使用）算法根据数据的历史访问记录来进行淘汰数据，其核心思想是“如果数据最近被访问过 ，那么将来被访问的几率也更高”。
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1669539855977-f44fffe7-d88d-4394-9221-e3ddcd65fec3.png#averageHue=%23f3f3f3&clientId=ubef7bb93-9c10-4&crop=0&crop=0&crop=1&crop=1&from=paste&id=ueca676fc&margin=%5Bobject%20Object%5D&name=image.png&originHeight=438&originWidth=1202&originalType=url&ratio=1&rotation=0&showTitle=false&size=32668&status=done&style=none&taskId=uc61d75db-aac1-4286-bf09-c689a4bfffd&title=)

1. 将新数据从尾部插入到 this.keys 中；
2. 每当缓存命中（即缓存数据被访问），则将数据移到 this.keys 的尾部。
3. 当 this.keys 满时，将头部的数据丢弃

LRU 核心：如果数据最近被访问过，那么将来被访问的几率也更高，所以我们将命中缓存的组件 key 重新插入到 this.keys 的尾部，这样一来，`this.keys`中越往头部的数据即将被访问几率越低，所以当缓存数量达到最大值时，我们就删除将来被访问几率最低的数据，即 this.keys 中第一个缓存的组件。 这也是 **已缓存组件中最久没有被访问的实例**会被销毁的原因。

以上工作做完后，设置`vnode.data.keepAlive = true`，最后将`vnode`返回。

## 生命周期钩子

组件一旦被`<keep-alive>`缓存，那么再次渲染时，就不会执行 created、mounted 等钩子函数，但我们很多业务场景都是希望被缓存的组件再次被渲染时做一些事情。
Vue 提供了这两个钩子函数： `activated` 和`deactivated`。它的执行时机是：`<keep-alive>`包裹的组件激活时调用和停用时调用。

```javascript
let A = {
  template: '<div class="a">' + "<p>A Comp</p>" + "</div>",
  name: "A",
  mounted() {
    console.log("Comp A mounted");
  },
  activated() {
    console.log("Comp A activated");
  },
  deactivated() {
    console.log("Comp A deactivated");
  },
};

let B = {
  template: '<div class="b">' + "<p>B Comp</p>" + "</div>",
  name: "B",
  mounted() {
    console.log("Comp B mounted");
  },
  activated() {
    console.log("Comp B activated");
  },
  deactivated() {
    console.log("Comp B deactivated");
  },
};

let vm = new Vue({
  el: "#app",
  template:
    "<div>" +
    "<keep-alive>" +
    '<component :is="currentComp">' +
    "</component>" +
    "</keep-alive>" +
    '<button @click="change">switch</button>' +
    "</div>",
  data: {
    currentComp: "A",
  },
  methods: {
    change() {
      this.currentComp = this.currentComp === "A" ? "B" : "A";
    },
  },
  components: {
    A,
    B,
  },
});
```
