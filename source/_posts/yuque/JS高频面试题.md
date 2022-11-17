---
title: JS高频面试题
categories: JS
date: 2022-11-13
updated: 2022-11-13
tags: JS
cover: https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fupload-images.jianshu.io%2Fupload_images%2F7275569-78f8b42bb54aec85.jpg&refer=http%3A%2F%2Fupload-images.jianshu.io&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1671266536&t=e242d8866a11e11ce85f7bd2674b4d7b
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

## map()和 foreach()的区别

### 简洁回答

都是⽤来遍历数组的，两者区别如下：

- forEach()⽅法会针对每⼀个元素执⾏提供的函数，对数据的操作会改变原数组，该⽅法没有返回

值；

- map()⽅法不会改变原数组的值，返回⼀个新数组，新数组中的值为原数组调⽤函数处理之后的

值；

### 相同点

1. 都是循环遍历数组的每一项
2. 都相当于封装好的单层 for 循环，三个值都相同
3. 每次执行匿名函数都支持三个参数，参数分别为 item（当前每一项）、index（索引值）、arr（原数组）
4. 匿名函数中的 this 都是指向 window
5. 只能遍历数组

### 不同点

- map()会分配内存空间存储新数组并有返回值，forEach()没有返回值
- forEach()允许 calllback 更改原始数组的元素，map()返回新的数组，map()不会对空数组进行检测
- forEach()遍历通常都是直接引入当前遍历数组的内存地址，生成的数组的值发生变化，当前遍历的数组对应的值也会发生变化。
- map 遍历后的数组通常会生成一个新的数组，新数组的值发生变化，当前遍历的数组值不会变化。
- map 的速度大于 forEach

### 使用场景

1. forEach()适用于你并不打算改变数据的时候
2. map()适用于你要改变数据的时候。不仅在于它更快，而且返回一个新数组。（因此可以使用复合（composition）（map(),filter(),reduce()等组合使用））

性能上来说，for>forEach>map。

## Symbol

1. 什么是 Symbol？

Symbol 是 ES6 新增的一种数据类型，被划分为**基本数据类型**。不能用 `new`。

- 基本数据类型：字符串、数值、布尔、undefined、null、Symbol。
- 引用数据类型：Object

2. 作用

用来表示一个独一无二的值。

3. 格式：`let xxx = Symbol('标识字符串')`
4. 为什么需要 Symbol？

为了避免第三方框框架的同名属性被覆盖。

> 在企业开发中，如果需要对一些第三方的插件、框架进行自定义时，可能会因为添加了同名的属性或方法，将框架中原有的属性或方法覆盖掉，为了避免这种情况的发生，框架的作者告诉我们就可以使用 Symbol 作为属性或方法的名称。

5. 如果区分 Symbol？

在通过 Symbol 生成一个独一无二的值时，可以设置一个标记
这个标记仅仅用于区分，没有其他任何意义。

6. 如果特殊情况需要读取这个标记，

- Symbol 类型可以转化为 boolean 或字符串，转化为字符串时前面会加上 Symbol(wxy)，不方便
- 可以直接通过 description 属性获取 Symbol 函数的字符串标识参数

7. 使用 Symbol 类型作为属性名
   > 对象的属性要么是字符串，要么是 Symbol 类型

- 默认是字符串，所以不加`""`也可以；如果需要类型为 Symbol，需要使用`[]`。
- 不能用`.`来访问，因为点运算符后面总是字符串。
- Symbol 值作为属性名时，该属性还是公开属性，不是私有属性。

8. 例子：

```javascript
//后面的括号可以给symbol做上标记便于识别
let name = Symbol("name");
let say = Symbol("say");
let obj = {
  //如果想 使用变量作为对象属性的名称，必须加上中括号，.运算符后面跟着的都是字符串
  [name]: "lnj",
  [say]: function () {
    console.log("say");
  },
  // name: "rose",
};
// obj.name = "it6661";
obj[Symbol("name")] = "it666";
console.log(obj);
console.log(Reflect.ownKeys(obj));
```

> {
> [Symbol(name)]: 'lnj',
> [Symbol(say)]: [Function: [say]],
> [Symbol(name)]: 'it666'
> }
> [ Symbol(name), Symbol(say), Symbol(name) ]

没有覆盖原来的 name，因为都是独一无二的，那么就默认创建一个 name 的属性。

### 注意点

1. Symbol 是基本数据类型，不能加 new
2. 后面括号可以传入一个字符串，只是一个标记，方便阅读，没有任何意义。
3. 类型转化的时候，不可转化为数值，只能转化为字符串和布尔值。

```javascript
console.log(String(name));
console.log(Boolean(name));
console.log(Number(name)); // Cannot convert a Symbol value to a number
```

4. 不能做任何运算

```javascript
let name = Symbol("name");
console.log(name + 111);
console.log(name + "ccc");
//全部报错 Cannot convert a Symbol value to a number
```

5. Symbol 生成的值作为属性或方法的时候，一定要保存下来，否则后续无法使用。

```javascript
let name = Symbol("name");
let obj = {
  // name:'lnj',
  [Symbol("name")]: "lbj",
};
console.log(obj.name); //访问不到，因为  [Symbol('name')]又是一个新的值，和上面的name不是同一个
```

应该改为如下：

```javascript
let name = Symbol("name");
let obj = {
  [name]: "lnj1",
  // [Symbol("name")]: "lbj",
};
// console.log(obj.name); //访问不到，因为  [Symbol('name')]又是一个新的值，和上面的name不是同一个
console.log(Reflect.ownKeys(obj));
console.log(obj[name]);
```

> [ Symbol(name) ]
> lnj1

6. for 循环遍历对象时无法遍历出 Symbol 的属性和方法

```javascript
let name = Symbol("name");
let obj = {
  [name]: "lnj",
  age: 12,
  teacher: "wyx",
};
for (let key in obj) {
  console.log(key); //只能打印出age和teacher
}
//这个方法可以单独取出Symbol(name)
console.log(Object.getOwnPropertySymbols(obj));
```

### Symbol 的应用

1. 在企业开发中，如果需要对一些第三方的插件、框架进行自定义时，可能会因为添加了同名的属性或方法，将框架中原有的属性或方法覆盖掉，为了避免这种情况的发生，框架的作者告诉我们就可以使用 Symbol 作为属性或方法的名称。
2. 消除魔术字符串
   > 魔术字符串：在代码中多次出现，与代码形成强耦合的某一个具体的字符串或数值。风格良好的代码应该尽量消除魔术字符串，改由含义清晰的变量代替。‘

```javascript
const gender = {
  //这样就说明man就是一个独一无二的值，不用再man:'man'
  man: Symbol(),
  woman: Symbol(),
};
function isMan(gender) {
  switch (gender) {
    case gender.man:
      console.log("男性");
      break;
    case gender.woman:
      console.log("女性");
      break;
  }
}
isMan(gender.man); //男性
```

3. 为对象定义一些非私有的、但又希望只用于内部的方法。
   > 由于以 Symbol 值作为键名，不会被常规方法遍历得到。我们可以利用这个特性，为对象定义一些非私有的、但又希望只用于内部的方法。
   > 注意：Symbol 并不能实现真正的私有变量的效果，只是不能通过常规的遍历方法拿到 Symbol 类型的属性而已。

**对象的遍历方法**：

- for(let xx in obj)：i 代表 key
- for(let xx of obj)：不是自带的
- Object.keys(obj)：返回包含的 key 的数组
- Object.values(obj)：返回包含 value 的数组
- Object.getOwnPropertyNames()：返回包含 key 的数组

上述的所有方法都遍历不到 Symbol 类型的（注意：是遍历时取不到 Symbol，并不是我们访问不到对象的 Symbol 类型）
**可以遍历到 Symbol 的方法：**

- **Object.getOwnPropertySymbols()**：返回对象中只包含 Symbol 类型 key 的数组
- **Reflect.ownKeys()**：返回对象中所有类型 key 的数组（包含 Symbol）

```javascript
let _password = Symbol("password");
const obj = {
  name: "小明",
  gender: "male",
  [_password]: "11038",
};
for (let item in obj) {
  console.log(item);
}
console.log(Object.keys(obj));
console.log(Object.values(obj));
console.log(Object.getOwnPropertyNames(obj));
console.log(Object.getOwnPropertySymbols(obj));
console.log(Reflect.ownKeys(obj));
// 输出11038，所以还是可以直接访问到symbol类型的属性，所以symbol并不能真正实现私有变量的设定，所以一般只用于定义一些非私有的、但又希望只用于内部的方法
console.log(obj[_password]);
```

输出如下：
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1668653745915-fc9503cf-b3b8-4973-b078-26b09f69ba22.png#averageHue=%23212121&clientId=u2b09cbdb-2331-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=116&id=u196ca470&margin=%5Bobject%20Object%5D&name=image.png&originHeight=245&originWidth=583&originalType=binary&ratio=1&rotation=0&showTitle=false&size=46307&status=done&style=none&taskId=uda6b3e15-79e2-4aa7-982d-49fe7eb8eb8&title=&width=275)

### Symbol 自带的方法

#### 1. `Symbol.for()`

重新使用同一个 Symbol 值。
接收一个字符串作为参数，搜索是否有以该参数作为名称的 Symbol 值，如果有，就返回这个 Symbol 值，否则就新建一个以该字符串为名称的 Symbol 值，并将其注册到全局。

```javascript
let s1 = Symbol.for("foo");
let s2 = Symbol.for("foo");

s1 === s2; // true
```

#### 2. `Symbol.keyFor()`

返回一个已登记的 Symbol 类型值的`key`。
由于`Symbol()`写法没有登记机制，所以每次调用都会返回一个不同的值。

```javascript
let s1 = Symbol.for("foo");
Symbol.keyFor(s1); // "foo"

let s2 = Symbol("foo");
Symbol.keyFor(s2); // undefined
```

## Map 和 Object 区别

|          | Map                                                                               | Object                                                                |
| -------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| 意外的键 | Map 默认情况不包含任何键，只包含显式插入的键                                      | Object 有一个原型，原型链上的键名有可能和自己在对象上设置的键名有冲突 |
| 键的类型 | Map 的键可以是**任意值**，包括函数、对象或任意基本类型                            | Object 的键必须是**String 或 Symbol**                                 |
| 键的顺序 | Map 中的**key**是**有序**的。因此，当迭代的时候，Map 对象以**插入的顺序**返回键值 | Object 的键是**无序**的                                               |
| Size     | Map 的键值对个数可以轻易地通过**size**属性获取                                    | Object 建值对个数只能**手动计算**                                     |
| 迭代     | Map 是 iterable 的，所以可以**直接被迭代**                                        | 迭代 Object 需要以某种方式**获取它的键然后才能迭代**                  |
| 性能     | 在频繁增删键值对的场景下表现更好                                                  | 在频繁添加和删除键值对的场景下**未做出优化**                          |

## Map 和 WeakMap 区别

### Map

map 本质上是键值对的集合，但是普通 Object 的中的键值只能是字符串或 Symbol。而 ES6 提供的 Map 数据结构类似于对象，但是它的键不限制范围，可以是任意类型，是一种更加完善的 Hash 结构。如果 Map 的键是一个原始数据类型，只要两个键严格相同，就视为是同一个键。
实际上 Map 是一个数组，它的每一个数据也都是一个数组，其形式如下：

```javascript
const map = [
  ["name", "张三"],
  ["age", 18],
];
```

Map 数据结构有以下操作方法：

- size：`map.size()`返回 Map 结构的成员总数
- set(key,value)：设置键名 key 对应的键值 value，然后返回整个 Map 结构，如果 key 已经有值，则键值会被更新，否则就生成该键。（因为返回的是当前 Map 对象，所以可以链式调用）
- get(key)：该方法读取 key 对应的键值，如果找不到 key，返回 undefined
- has(key)：该方法返回一个布尔值，表示某个键是否在当前 Map 对象中。
- delete(key)：该方法删除某个 key，返回 true，如果删除失败，返回 false。
- clear()：map.clear() 清除所有成员，没有返回值

Map 结构原生提供是三个遍历器生成函数和一个遍历方法

- keys()：返回键名的遍历器
- values()：返回键值的遍历器
- entries()：返回所有成员的遍历器
- forEach()：遍历 Map 的所有成员

```javascript
const map = new Map([
  ["foo", 1],
  ["bar", 2],
]);
for (let key of map.keys()) {
  console.log(key); // foo bar
}
for (let value of map.values()) {
  console.log(value); // 1 2
}
for (let items of map.entries()) {
  console.log(items); // ["foo",1] ["bar",2]
}
map.forEach((value, key, map) => {
  console.log(key, value); // foo 1 bar 2
});
```

### WeakMap

WeakMap 对象也是一组键值对的集合，其中的键是**弱引用**。**其键必须是对象，**原始数据类型不能作为 key 值，而值可以是任意的。
该对象也有以下几种方法：

- **set(key,value)**：设置键名 key 对应的键值 value，然后返回整个 Map 结构，如果 key 已经有值，则键值会被更新，否则就新生成该键。（因为返回的是当前 Map 对象，所以可以链式调用）
- **get(key)**：读取 key 对应的键值，如果找不到 key，返回 undefined。
- **has(key)**：返回一个布尔值，表示某个键是否在当前 Map 对象中。
- **delete(key)**：删除某个键，返回 true，如果删除失败，返回 false。

其 clear() 方法已经被弃用，所以可以通过创建一个空的 WeakMap 并替换原对象来实现清除。
**WeakMap 的设计目的**：

- 有时想在某个对象上存放一些数据，但是这会形成对于这个对象的引用。一旦不需要这两个对象，就必须手动删除这个引用，否则垃圾回收机制就不会释放对象占用的内存。
- 而 WeakMap 的**键名所引用的对象都是弱引用**， 即**垃圾回收机制不将该引用考虑在内。**因此，只要所引用的对象的其他引用都被清除，垃圾回收机制就会释放该对象所占用的内存。即一旦不再需要，WeakMap 里面的键名对象和所对应的键值对会自动消失，**不用手动删除引用**。

### 总结

- Map 数据结构，类似于对象，也是键值对的集合，但是“键”的范围**不限于**字符串，各种类型的值（包括对象）都可以作为键。
- WeakMap 结构与 Map 结构类似，也是用于生成键值对的集合。但是 WeakMap**只接受对象作为键名**（null 除外），不接受其他类型的值作为键名。**而且 WeakMap 的键名所指向的对象是弱引用，不计入垃圾回收机制。**

## JS 内置对象

全局的对象（global objects）或称标准内置对象。即全局作用域中的对象，全局作用域中的其他对象可以由用户的脚本创建或由宿主程序提供。

### 标准内置对象的分类

1. 值属性：这些全局属性返回一个简单值，这些值没有自己的属性和方法。

如：Infinity、NaN、undefined、null 字面量。

2. 函数属性：全局属性可以直接调用，不需要再调用时指定所属对象，执行结束后会将结果直接返回给调用者。

如：eval()、parseFloat()、parseInt()等。

3. 基本对象：是定义或使用其他对象的基础。包括一般对象、函数对象和错误对象。

如：Object、Function、Boolean、Symbol、Error 等。

4. 数字和日期对象：用来表示数字、日期和执行数学计算的对象。

如：Number、Math、Date。

5. 字符串：用来表示和操作字符串的对象。

如：String、RegExp

6. 可索引的集合对象，这些对象表示按照索引值来排序的数据集合，包括数组和类型数组，以及类数组结构的对象。

如：Array。

7. 使用键的集合对象：这些集合对象在存储时会使用到键，支持按照插入顺序来迭代元素。

如：Map、Set、WeakMap、WeakSet。

8. 矢量集合：SIMD 矢量集合中的数据会被组织为一个数据序列。

如：SIMD 等。

9. 结构化数据：这些对象用来表示和操作结构化的缓冲区数据，或使用 JSON 编码的数据。

如：JSON 数据。

10. 控制抽象对象。如：Promise、Generator 等。
11. 反射。如：Reflect、Proxy。
12. 国际化：为了支持多语言处理而加入的 ECMAScript 的对象。

如：Intl、Intl.Collator 等。

13. WebAssembly
14. 其他。如 arguments

### 总结

1. JS 中的内置对象主要指的是在程序执行前存在全局作用域中的由 JS 定义的一些全局值属性、函数和用来实例化其他对象的构造函数对象。
2. 一般经常用到的如 全局变量值 NaN、undefined，全局函数如 parseInt()、parseFloat() 用来实例化对象的构造函数 如 Date、Object 等，还有提供数学计算的单体内置对象如 Math 对象等。

## JS 脚本延迟加载的方式

- defer：异步加载，延迟执行（html 加载完再执行）
- async：异步加载，加载完立即执行（会阻塞 html 页面解析）
- 动态创建 DOM 方式：对文档加载事件进行监听，当文档加载完后，再动态创建 script 标签来引入 JS 脚本。
- setTimeout 延迟方法：设置一个定时器来延迟加载 JS 脚本文件
- 让 JS 最后加载：将 JS 脚本文件放在文档底部，来使 JS 脚本尽可能最后加载执行。

## JS 类数组对象

JS 类数组对象：一个拥有 length 属性和若干索引属性的对象。
和数组类似，但不能调用数组的方法。
常见的类数组对象有：

- argument 和 DOM 方法的返回结果
- 函数（因为含有 length 属性值，代表可接收的参数个数）

类数组转换为数组的方法：

1. 通过 call 调用数组的 slice 方法来实现转换

```javascript
Array.prototype.slice.call(arrayLike);
```

2. 通过 call 调用数组的 splice 方法来实现转换

```javascript
Array.prototype.splice.call(arrayLike, 0);
```

3. 通过 apply 调用数组的 concat 方法来实现转换

```javascript
Array.prototype.concat.apply([], arrayLike);
```

4. 通过 Array.from() 实现转换

```javascript
Array.from(arrayLike);
```

## 数组有哪些原生方法

- 数组和字符串的转换方法：toString()、toLocalString()、join()，其中 join()可以指定转换为字符串时的分隔符
- 数组尾部操作的方法：pop()和 push()，push() 方法可以传入多个参数
- 数组首部操作的方法：shift() 删除和 unshift() 添加
- 重排序的方法：reverse() 和 sort()，sort() 可传入一个函数进行比较，传入前后两个值，如果返回值为正数，则交换两个参数的位置
- 数组连接：concat() 返回拼接好的数组，不影响原数组。
- 数组截取：splice()
- 影响原数组特定项的索引的方法，indexOf()和 lastIndexOf()
- 迭代方法：every()、some()、filter()、map()、forEach()方法
- 数组归并方法：reduce()、reduceRight()方法
