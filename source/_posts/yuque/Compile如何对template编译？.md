---
title: Compile如何对template编译？
categories: 原理
date: 2022-12-04
updated: 2022-12-04
tags: [Vue, 模板编译]
cover: https://img1.baidu.com/it/u=153269378,1555242931&fm=253&fmt=auto&app=120&f=JPEG?w=1422&h=800
---

compile 编译可以分成 parse、optimize 与 generate 三个阶段，最终需要得到 render function。

### parse

parse 会用正则等方式将 template 模板中进行字符串解析，得到指令、class、style 等数据，形成 AST。
最终得到的 AST 通过一些特定的属性，能够比较清晰地描述出标签的属性以及依赖关系。

### 正则

接下来会用到的正则：

```js
const ncname = "[a-zA-Z_][\\w\\-\\.]*";
const singleAttrIdentifier = /([^\s"'<>/=]+)/;
const singleAttrAssign = /(?:=)/;
const singleAttrValues = [
  /"([^"]*)"+/.source,
  /'([^']*)'+/.source,
  /([^\s"'=<>`]+)/.source,
];
const attribute = new RegExp(
  "^\\s*" +
    singleAttrIdentifier.source +
    "(?:\\s*(" +
    singleAttrAssign.source +
    ")" +
    "\\s*(?:" +
    singleAttrValues.join("|") +
    "))?"
);

const qnameCapture = "((?:" + ncname + "\\:)?" + ncname + ")";
const startTagOpen = new RegExp("^<" + qnameCapture);
const startTagClose = /^\s*(\/?)>/;

const endTag = new RegExp("^<\\/" + qnameCapture + "[^>]*>");

const defaultTagRE = /\{\{((?:.|\n)+?)\}\}/g;

const forAliasRE = /(.*?)\s+(?:in|of)\s+(.*)/;
```

### advance

∵ 解析 template 采用循环进行字符串匹配的方式

∴ 每匹配解析完一段我们需要将已经匹配掉的去掉，头部的指针执行接下来需要匹配的部分。

```js
function advance(n) {
  index += n;
  html = html.substring(n);
}
```

例如，当我们把第一个 div 的头标签全部匹配完毕后，我们需要将这部分除去，也就是向右移动 43 个字符。
![](https://img.kancloud.cn/30/12/3012cf68fb6155a4d9ccf0490bcc85c8_1086x199.gif)

调用 advance 函数: advance(43)。

得到结果：![](https://img.kancloud.cn/84/89/84898f9a7959fa81cc4055869bd98c4f_1096x198.gif)

### parseHTML

需要定义一个 parseHTML 函数，在其中循环解析 template 字符串。

```js
function parseHTML() {
  while (html) {
    let textEnd = html.indexOf("<");
    if (textEnd === 0) {
      if (html.match(endTag)) {
        // ...process end tag
        continue;
      }
      if (html.match(startTagOpen)) {
        // ...process start tag
        continue;
      }
    } else {
      // ...process text
      continue;
    }
  }
}
```

parseHTML 会用 while 来循环解析 template，用正则在匹配到标签头、标签尾以及文本时分别进行不同的处理。直到整个 template 被解析完毕。

### parseStartTag

用来解析起始标签。

```js
function parseStartTag (){
    const start = html.match(startTagOpen)
    if(start){
        const match = {
            tagName: start[1],
            attrs: [],
            start: index
        }
        advance(start[0].length)
        let end,attr
        while(!(end = html.match(startTagClose) && (attr = html.match(attribute))){
            advance(attr[0].length);
            match.attr.push({
                name: attr[1],
                value: attr[3]
            });
        }
        if(end){
            match.unargSlash = end[1]
            advance(end[0].length);
            match.end = index;
            return match;
        }
    }
}
```

> 首先用 startTagOpen 正则得到标签的头部，可以得到 tagName（标签名称），同时我们需要一个数组 attrs 来存放标签内的属性。
> 接下来，使用 startTagClose 与 attribute 两个正则分别用来解析标签结束及标签内的属性。这段代码用 while 循环一直到匹配到 startTagClose 为止，解析内部所有的属性。

### stack

我们需要维护一个 stack 栈来保存已经解析好的标签头，这样我们可以根据在解析尾部标签的时候得到所属的层级关系以及父标签。同时定义一个 currentParent 变量来存放当前标签的父标签节点的引用，root 变量来指向根标签节点。

```js
const stack = [];
let currentParent, root;
```

![](https://img.kancloud.cn/40/28/4028cf3960616fca915c0f2ed4229427_709x451.gif)

我们来优化 parseHTML，在 startTagOpen 的 if 逻辑上加上新的处理。

```js
if(html.match(startTagOpen)){
    // ①
    const startTagMatch = parseStartTag()
    const element = {
        type: 1,
        tag: startTagMatch.tagName,
        lowerCasedTag: startTagMatch.tagName.toLowerCase(),
        attrsList: startTagMatch.attrs,
        attrsMap: makeAttrsMap(startTagMatch.attrs),
        parent: currentParent,
        children: []
    }
    // ②
    if(!root){
        root = element
    }
    // ③
    if(currentParent){
        currentParent.children.push(element)
    }
    // ④
    stack.push(element)
    currentParent = element
    continue;
}
```

> ① 我们将 `startTagMatch` 得到的结果首先封装成`element` ，即最终形成的 AST 节点，标签节点的`type` 为 1。<br>
> ② 然后让`root` 指向根节点的引用。 <br>
> ③ 接着，我们将当前节点的`element` 放入父节点 `currentParent` 的`children` 数组中。 <br>
> ④ 最后，将当前节点的 `element` 压入 stack 栈中，并将 `currentParent` 指向当前节点，因为接下来下一个解析如果还是头标签或文本，会成为当前节点的子节点，如果是尾标签，那么将会从栈中取出当前节点。 <br>
> 其中 makeAttrsMap 是将 attrs 转换成 map 格式的一个方法。

```js
function makeAttrsMap(attrs){
    const map = {}
    for(let i = 0; l = attrs.length;i < l;i++){
        map[attrs[i].name] = attrs[i].value;
    }
    return map;
}
```

### parseEndTag

同样，我们在 parseHTML 中加入对尾标签的解析函数。

```js
const endTagMatch = html.match(endTag)
if(endTagMatch){
    advance(endTagMatch[0].length)
    parseEndTag(endTagMatch[1])
    continue;
}
```

用`parseEndTag` 来解析尾标签，它会从 stack 栈中取出最近的和自己标签名一致的那个元素，将`currentParent` 指向的元素，并将该元素之前的元素从`stack` 中出栈。

```js
function parseEndTag(tagName) {
  let pos;
  for (pos = stack.length - 1; pos >= 0; pos--) {
    if (stack[pos].lowerCasedTag === tagName.toLowerCase()) {
      break;
    }
  }
  if (pos >= 0) {
    stack.length = pos;
    currentParent = stack[pos];
  }
}
```

### parseText

解析文本：只要将文本取出。有两种情况：<br>
① 普通文本，直接构建一个节点 push 进当前 currentParent 的 children 中即可。<br> ② 如`"{{item}}"` 这样的 Vue.js 的表达式，此时，我们需要用 parseText 来将表达式转为代码。

```js
text = html.substring(0,textEnd)
advance(textEnd)
if(expression = parseText(text)){
    currentParent.children.push({
        type: 2,
        text,
        expression
    })
}else {
    currentParent.children.push({
        type: 3,
        text
    })
}
continue;
```

会用到一个 parseText 函数。

```js
function parseText(text) {
  if (!defaultTagRE.test(text)) return;
  const tokens = [];
  let lastIndex = (defaultTagRE.lastIndex = 0);
  let match, index;
  while ((match = defaultTagRE.exec(text))) {
    index = match.index;
    if (index > lastIndex) {
      tokens.push(JSON.stringify(text.slice(lastIndex, index)));
      const exp = match[1].trim();
      tokens.push(`_s(${exp})`);
      lastIndex = index + match[0].length;
    }
  }
  if (lastIndex < text.length) {
    tokens.push(JSON.stringify(text.slice(lastIndex)));
  }
  return tokens.join("+");
}
```

> 使用一个 token 数组来存放解析结果，通过 defaultTagRE 来循环匹配该文本，如果是普通文本，直接 push 到 tokens 数组中去，如果是表达式（{{item}}），则转化为“\_s(${exp})”的形式。

例如：<br>
我们有这样的文本：

```html
<div>hello,{{name}}.</div>
```

最终得到 tokens:

```js
tokens = ["hello,", _s(name), "."];
```

最终通过 join 返回表达式。

```js
"hello" + _s(name) + ".";
```

### processIf 与 processFor
