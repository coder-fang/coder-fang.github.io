# Vite 和 Webpack 之对比

开发阶段：Vite 的速度远快于 Webpack
主要原因：**Webpack 是先打包再启动开发服务器，Vite 是直接启动开发服务器，然后按需编译依赖文件。**
详细过程：

1. webpack 先打包，再启动开发服务器，请求服务器时直接给予打包后的结果；
2. Vite 直接启动开发服务器，请求哪个模块再对哪个模块进行实时编译；
3. 由于现代浏览器本身就支持 ES Modules，会主动发起请求去获取所需文件。Vite 充分利用这一点，将开发环境下的模块文件，作为浏览器要执行的文件，而不是像 webpack 先打包，交给浏览器执行的文件是打包后的；
4. 由于 Vite 启动时无需打包，也就无需分析模块依赖、编译，所以启动速度非常快。当浏览器请求需要的模块时，再对模块进行编译，这种按需动态编译的模式，极大地缩短了编译时间，当项目越大，文件越多，Vite 的开发时优势越明显；
5. 在 HRM 方面，当某个模块内容改变时，让浏览器去重新请求该模块即可，而不是像 webpack 重新将该模块的所有依赖重新编译；
6. 当需要打包到生产环境时，Vite 使用传统的 rollup 进行打包，所以，vite 的优势体现在开发阶段，另外，由于 vite 使用的是 ES Module，所以代码中不可以使用 CommonJS。

# Vite 为什么“快”？

## 问题现状

### 1. ES 模块化支持的问题

- 以前的浏览器不支持 ES Module

```javascript
// index.js

import { add } from "./add.js";
import { sub } from "./sub.js";
console.log(add(1, 2));
console.log(sub(1, 2));

// add.js
export const add = (a, b) => a + b;

// sub.js
export const sub = (a, b) => a - b;
```

这样的一段代码放在浏览器不能直接运行。
解决方案：可以使用打包工具（如 Webpack、Rollup、Parcel），将 index.js、add.js、sub.js 这三个文件打包在一个 bundle.js 文件中，然后在项目`index.html`中直接引入`bundle.js`，从而达到代码效果。

### 2. 项目启动与代码更新的问题

- 项目启动：随着项目越来越大，启动一个项目可能需要几分钟
- 代码更新：随着项目越来越大，修改一小段代码，保存后都要等待几秒才更新

## 解决问题

### 1. 解决启动项目缓慢

Vite 在打包时，将模块分成两个区域`依赖`和`源码`：

-
