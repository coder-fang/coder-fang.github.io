---
title: JS垃圾回收机制
categories: JS
date: 2022-11-19
updated: 2022-11-19
tags: [JS, 垃圾回收]
cover: https://img1.baidu.com/it/u=3556875364,2935983115&fm=253&fmt=auto&app=138&f=JPEG
---

**内存溢出**：程序运行出现的错误，就像水杯，满了之后再加水就溢出了。同理，内存溢出就是程序运行所需的内存大于可用内存，就出现内存溢出错误。

> 例子：写一个千万级别的循环，然后用浏览器打开，浏览器就会非常卡，甚至直接报错内存不足，崩溃了。不同浏览器有不同的表现。

**产生原因**：内存溢出一般是**内存泄漏**造成的，占用的内存不需要用到了，但是没有及时释放。内存泄漏积累的多了轻则会系统性能，重则直接引起内存溢出系统崩溃。

### 哪些场景会引发内存泄漏？

1. 全局变量引起的内存泄漏：

根据 JS 的垃圾回收机制，全局变量不会被回收，所以一些意外的、不需要的全局变量多了，没有释放，就造成了内存泄漏。

2. [闭包](https://blog.csdn.net/qq_45479404/article/details/124843856)：

内部的变量因为被闭包引用得不到释放，会造成内存泄漏。因此我们在开发过程中，尽量不要使用闭包。

3. 计时器、回调、监听等事件没有移除：

这些事件没有移除是一直存在的，一直存在没有被释放就会造成内存泄漏。

4. 给 DOM 添加属性或方法：

给 DOM 添加属性或方法等，也会造成变量引用得不到释放，造成内存泄漏。
最核心的：由于垃圾回收机制，全局变量或者是被全局变量引用，垃圾回收机制就无法回收。如果一些用完一次就不再使用的没有释放，那么积累的多了，就容易造成内存溢出。

### JS 内存管理

1. 分配给`使用者`所需的内存
2. `使用者`拿到这些内存，并使用内存
3. `使用者`不需要这些内存了，释放并归还给系统

变量就是`使用者`。

> JS 数据类型分为；基本数据类型 和 引用数据类型。
>
> - 基本数据类型：大小固定，值保存在`栈内存`中，可通过值直接访问。
> - 引用数据类型：大小不固定（∵ 可加属性），`栈内存`中存着指针，指向`堆内存`中的对象空间， 通过引用来访问。

![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670837158434-d02b829e-2ca6-4457-9178-7e528051eba5.png#averageHue=%23fcf9f8&clientId=u8f053162-afe4-4&from=paste&height=356&id=ua3796757&originHeight=356&originWidth=885&originalType=binary&ratio=1&rotation=0&showTitle=false&size=25990&status=done&style=none&taskId=uaadda59b-863b-401d-993c-56443f41c76&title=&width=885)

- 栈内存的内存都是`操作系统自动分配和释放回收的`（由于栈内存所存的基础数据类型大小是固定的）
- JS 堆内存需要 JS 引擎手动释放这些内存（由于堆内存所存大小不固定，系统无法自动释放回收）

### 为什么要进行垃圾回收？

在 Chrome 中，V8 被限制了内存的使用（64 位约 1.4G/1464MB，32 位约 0.7G/732MB）。
限制内存使用的原因：

- 表层：V8 最初为浏览器而设计，不太可能遇到用大量内存的场景
- 深层：V8 的垃圾回收机制的限制（如果清理大量的内存垃圾很耗时间，这样会引起 JS 线程暂时执行的时间，性能和应用直线下降）
  > 当我们的代码没有按照正确的写法时，会使得 JS 引擎的垃圾回收机制无法正确的对内存进行释放（内存泄漏），从而使得浏览器占用的内存不断增加，进而导致 JS 和应用、操作系统性能下降。

### V8 的垃圾回收算法

#### 分代回收

在 JS 中，对象存活周期分为两种情况：

- 存活周期很短：经过一次垃圾回收后，就被释放回收掉。
- 存活周期很长：经过多次垃圾回收后，还存在。

产生问题：对于存活周期长的，多次回收都回收不掉，明知回收不掉，却还不断地去回收，不是很消耗性能吗？
对于此问题，V8 做了**分代回收**的优化方法。即：**V8 将堆分为两个空间，一个叫新生代，一个叫老生代。新生代是存放存活周期短对象的地方，老生代是存放存活周期长对象的地方。**

> 新生代容量：1-8M。而老生代容量很大。对于这两块区域，V8 分别做了**不同的垃圾回收器和不同的垃圾回收算法**，以致于更高效地进行垃圾回收。
>
> - 副垃圾回收器 + Scavenge 算法：主要负责新生代的垃圾回收
> - 主垃圾回收器 + Mark-Sweep && Mark-Compact 算法

##### 新生代

在 JS 中，任何对象的声明分配到的内存，将会先放到新生代中，而因为大部分对象在内存中存活的周期很短，所以需要一个效率非常高的算法。在新生代中，主要使用 Scavenge 算法进行垃圾回收，Scavenge 算法是一个典型的牺牲空间换取时间的复制算法，在占用空间不大的场景上非常适用。
Scavange 算法将新生代堆分为两部分，分别叫 from-space 和 to-space，工作方式也很简单，就是将 from-space 中存活的活动对象复制到 to-space 中，并将这些对象的内存有序排列起来，然后将 from-space 中的非活动对象的内存进行释放，完成后，将 from space 和 to space 进行互换，这样可以使得新生代中的这两块区域可以重复利用。
具体步骤：

1. 标记活动对象和非活动对象
2. 复制 from-space 的活动对象到 to-space 中并进行排序
3. 清除 from-space 中的非活动对象
4. 将 from-space 和 to-space 进行角色互换，以便下一次的 Scavenge 算法垃圾回收
   > 垃圾回收器如何知道哪些是活动对象，哪些是非活动对象呢？
   >
   > - 从初始的根对象（window 或 global）的指针开始，向下搜索子节点，子节点就被搜索到了，说明该子节点的引用对象可达，并为其进行标记。
   > - 然后接着递归搜索，直到所有的子节点被遍历结束。
   > - 那么没有被遍历到的节点，就没有标记，也就会被当成没有被任何地方引用，就可以证明这是一个需要被释放内存的对象，可以被垃圾回收器回收。

💬 新生代中的对象什么时候变成老生代？
在新生代中，还进一步进行了细分。分为 nursery 子代 和 intermediate 子代 两个区域，一个对象第一次分配内存时会被分配到新生代中的 nursery 子代，如果经过下一次的垃圾回收这个对象还存在新生代中，这时，我们将此对象移动到 intermedidate 子代，在经过下一次垃圾回收，如果这个对象还在新生代中，副垃圾回收器 会将该对象移动到老生代中，这个移动的过程被称为**晋升**。

##### 老生代

老生代空间：新生代空间的对象，身经百战后，留下来的老对象，成功晋升到了老生代中。
由于这些对象都是经过多次回收过程但是没有被回收走的，都是一群生命力顽强、存活率高的对象，所以老生代中，回收算法不宜使用 Scavenge 算法。
原因：

- Scavenge 算法是复制算法，反复复制这些存活率高的对象，没有什么意义，效率极低。
- Scavenge 算法是以空间换时间的算法，老生代是内存很大的空间，如果使用 Scavenge 算法，空间资源非常浪费。

因此，老生代里使用了 Mark-Sweep 算法（标记清理）和 Mark-Compact 算法（标记整理）。
**Mark-Sweep（标记清理）**
Mark-Sweep 分为两个阶段，标记和清理阶段，之前的 Scavenge 算法 也有标记和清理，但是 Mark-Sweep 算法跟 Scavenge 算法的区别是，后者需要复制再清理，前者不需要，Mark-Sweep 直接标记活动对象和非活动对象之后，就直接执行清理了。

- 标记阶段：对老生代对象进行第一次扫描，对活动对象进行标记
- 清理阶段：对老生代对象进行第二次扫描，清除未标记的对象，即非活动对象。

**Mark-Compact（标记整理）**
Mark-Sweep 算法执行垃圾回收之后，留下了很多零零散散的空位。坏处：如果此时进来了一个大对象，需要对此对象分配一个大内存，先从零零散散的空位中找位置，找了一圈，发现没有适合自己大小的空位，只好拼在了最后，这个寻找空位的过程是耗性能的，这也是 Mark-Sweep 算法的一个缺点。
Mark-Compact 算法是 Mark-Sweep 算法的加强版，在 Mark-Sweep 算法的基础上，加上了`整理阶段`，每次清理完非活动对象，就会把剩下的活动对象，整理到内存的一侧，整理完成后，直接回收掉边界上的内存。

#### 全停顿（Stop-The-World）

JS 代码的运行要用到 JS 引擎，垃圾回收也要用到 JS 引擎，如果这两者同时进行了，发生冲突了，怎么办？答案：垃圾回收优先于代码执行，会先停止代码的执行，等到垃圾回收完毕，再执行 JS 代码。这个过程，成为全停顿。
由于新生代空间小，并且存活对象少，再配合 Scavenge 算法，停顿时间较短。但是老生代就不一样了，某些情况活动对象比较多时，停顿时间就会较长，使得页面出现了卡顿现象。

#### Orinoco 优化

orinoco 是 V8 的垃圾回收器的项目代号，为了提升用户体验，解决全停顿问题，它提出了增量标记、懒性清理、并发、并行的优化方法。

##### 增量标记（Incremental marking）

增量标记是在`标记`这个阶段进行了优化。
当垃圾少量时，不会做增量标记优化，但是当垃圾达到一定数量时，增量标记就会开启：标记一点，JS 代码运行一段，从而提高效率。

##### 惰性清理（Lazy sweeping）

惰性清理针对`清除`阶段。在增量标记后，要进行清理非活动对象时，垃圾回收器发现了其实就算是不清理，剩余的空间也足以让 JS 代码跑起来，所以就`延迟了清理`，让 JS 代码先执行，或者`只清理部分垃圾`，而不清理全部。这个优化就叫做`惰性清理`。
整理标记和惰性清理的出现，大大改善了`全停顿`的现象。但是产生了问题：增量`标记是标记一点，JS运行一段`。如果你前脚刚标记一个对象为活动对象，后脚 JS 代码就把此对象设置为非活动对象，或者反过来，前脚没有标记一个对象为活动对象，后脚 JS 代码就把此对象设置为活动对象。
总结一下就是：标记和代码执行的穿插，有可能造成`对象引用改变，标记错误`现象。这就需要使用`写屏障`技术来记录这些引用关系的变化。

##### 并发（Concurrent）

并发式 GC 允许在垃圾回收时不需要将主线程挂起，两者可以同时进行，只有在个别时候需要短暂下来让垃圾回收器做一些特殊的操作。但是这种方式也要面对增量回收的问题，就是在垃圾回收过程中，由于 JS 代码在执行，堆中的对象的引用关系随时可能会变化，所以也要进行`写屏障`操作。
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670851619218-0efd0aee-9227-4585-9745-d95f8bcacd7c.png#averageHue=%23b5e19a&clientId=u8f053162-afe4-4&from=paste&height=147&id=u0aee8473&originHeight=147&originWidth=718&originalType=binary&ratio=1&rotation=0&showTitle=false&size=56932&status=done&style=none&taskId=u19ceca22-5e5e-4460-bade-47f1ebaf8b4&title=&width=718)

##### 并行

并行式 GC 运行主线程和辅助线程同时执行同样的 GC 工作，这样可以让辅助线程来分担主线程的 GC 工作，使得垃圾回收所耗费的时间等于总时间除以参与的线程数量（加上一些同步开销）。
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670851771272-d5454f1b-90b5-4cbd-83bb-8d1805c9bce1.png#averageHue=%23f6f6f6&clientId=u8f053162-afe4-4&from=paste&height=139&id=ue342693c&originHeight=139&originWidth=608&originalType=binary&ratio=1&rotation=0&showTitle=false&size=52245&status=done&style=none&taskId=ucd478771-10dc-4006-83a3-1f89d520c4e&title=&width=608)

### V8 当前的垃圾回收机制

2011 年，V8 应用了增量标记机制。2018 年，Chrome64 和 Node.js V10 启动`并发（Concurrent）`，同时在并发基础上添加`并行（Parallel）技术`，使得垃圾回收时间大幅度缩短。

#### 副垃圾回收器

V8 在新生代垃圾回收中，使用并行（parallel）机制，在整理排序阶段，也就是将活动对象从 from-to 复制到`space-to`时，启用多个辅助线程，并行的进行整理。由于多个线程竞争一个新生代的堆的内存资源，可能出现有某个活动对象被多个线程进行复制操作的问题，为了解决这个问题，V8 在第一个线程对活动对象进行复制并且复制完成后，都必须去维护这个活动对象后的指针转发地址，以便于其他协助线程可以找到该活动对象后可以判断该活动对象是否已被复制。
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670852581283-0012ecbd-7021-4bfa-bf9b-64bd4ee61947.png#averageHue=%23f6f6f6&clientId=u8f053162-afe4-4&from=paste&height=142&id=u33593aab&originHeight=142&originWidth=614&originalType=binary&ratio=1&rotation=0&showTitle=false&size=52347&status=done&style=none&taskId=u46c50273-8903-4249-a83f-795e67d5c8a&title=&width=614)

#### 主垃圾回收器

V8 在老生代垃圾回收中，如果堆中的内存大小超过某个阈值后，会启用并发（Concurrent）标记任务。每个辅助线程都会去追踪每个标记到的对象的指针以及对这个对象的引用，而在 JS 代码执行时，并发标记也在后台的辅助进程中进行，当堆中的某个对象指针被 JS 代码修改时，`写屏障`技术在辅助线程在进行并发标记时进行追踪。
当并发标记完成或动态分配的内存达到极限时，主线程会执行最终的快速标记步骤，这时主线程会挂起，主线程会再一次的扫描根集以确保所有的对象都完成了标记，由于辅助线程已经标记过活动对象，主线程的本次扫描只是进行 check 操作，确认操作完成后，某些辅助线程会进行清理内存操作，某些辅助线程会进行内存整理操作，由于都是并发的，并不会影响主线程 JS 代码的执行。
![image.png](https://cdn.nlark.com/yuque/0/2022/png/2324645/1670891665363-ab526d91-530b-485d-a461-ebfd7da717ef.png#averageHue=%23eaf5dc&clientId=u8f053162-afe4-4&from=paste&height=160&id=u97b0bb01&originHeight=160&originWidth=680&originalType=binary&ratio=1&rotation=0&showTitle=false&size=66145&status=done&style=none&taskId=ua5f38ef3-e648-452a-bada-462d2332057&title=&width=680)

### 问题及解答

#### 浏览器怎么进行垃圾回收？

> 从三个点来回答什么是垃圾、如何捡垃圾、什么时候捡垃圾

什么是垃圾？

1. 不再需要，即为垃圾
2. 全局变量随时可能用到，所以一定不是垃圾

如何捡垃圾（遍历算法）？

1. 标记空间中「可达」值
   1. 从根节点（Root）出发，遍历所有的对象
   2. 可以遍历到的对象，是可达的（reachable）
   3. 没有遍历到的对象，不可达的（unreachable）
2. 回收「不可达」的值所占据的内存
3. 做内存整理

什么时候捡垃圾？

1. 前端有其特殊性，垃圾回收时会造成页面卡顿
2. 分代收集、增量收集、闲时收集

#### 浏览器中不同类型变量的内存都是何时释放？

JS 中类型：值类型、引用类型

- 引用类型
  - 在没有引用之后，通过 V8 自动回收
- 值类型
  - 如果处于闭包的情况下，要等闭包没有引用才会被 V8 回收
  - 非闭包的情况下，等待 V8 的新生代切换时回收

#### 哪些情况会导致内存泄漏？如何避免？

内存泄漏是指你「用不到」（访问不到）的变量，依然占据着内存空间，不能被再次利用起来。

> 以 Vue 为例，通常会有这些情况：
>
> - 监听在 window/body 等事件没有解绑
> - 绑在 EventBus 的事件没有解绑
> - Vuex 的$store，watch 了之后没有 unwatch
> - 使用第三方库创建，没有调用正确的销毁函数
>
> **解决办法：**
>
> - beforeDestory 中及时销毁
> - 绑定了 DOM/BOM 对象 addEventListener，removeEventListener。
> - 观察者模式 $on，$off 处理
> - 如果组件中使用了定时器，应销毁处理
> - 如果在 mouted/created 钩子中使用了第三方库初始化，对应的销毁
> - 使用弱引用 weakMap、weakSet。

闭包会导致内存泄漏吗？

> 不会。
> 内存泄漏是指你用不到的（访问不到）的变量，依然占据着空间，不能被再次利用起来。
> 闭包里面的变量就是我们需要的变量，不能说是内存泄漏。
> 只是由于 IE9 之前的版本对 JS 对象和 COM 对象使用不同的垃圾收集，从而导致内存无法回收。这是 IE 的问题，不是闭包的问题。

#### weakMap weakSet Map Set 有什么区别？

在 ES6 中为我们新增了两个数据结构 WeakMap、WeakSet ，就是为了解决内存泄漏问题。
它的键名所引用的对象都是弱引用，就是垃圾回收机制遍历的时候不考虑该引用。
只要所引用的对象的其他引用都被清除，垃圾回收机制就会释放该对象所占用的内存。
也就是说，一旦不再需要，WeakMap 里面的键名对象和所对应的键值对就就会自动侠消失，不用手动删除引用。

#### 简单了解浏览器的垃圾回收机制？

浏览器怎么进行垃圾回收？

- 思路：什么是垃圾、怎么收垃圾、什么时候收垃圾

浏览器中不同类型变量的内存都是何时释放？

- 思路：分为值类型、引用类型

[哪些情况会导致内存泄漏？如何避免？](https://www.cnblogs.com/crazycode2/p/14747974.html)

- 思路：内存泄漏是指你用不到（访问不到）的变量，依然占据着内存空间，不能被再次利用起来。

weakMap、weakSet、Set、Map 有什么区别？

- 思路：WeakMap、WeakSet 弱引用，解决了内存泄漏问题
