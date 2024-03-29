---
title: npm与pnpm之对比
categories: 知识
date: 2022-11-04
updated: 2022-11-04
tags: [前端工程化]
cover: https://img1.baidu.com/it/u=3855543578,1499410100&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=320
---

## pnpm 中的问题

- pnpm 的出现对于 npm 和 yarn 来说是一个比较彻底的改变，解决了很多 npm 安装依赖存在的问题，node_modules 过大、幽灵依赖。
- pnpm 目前存在的限制在于它修改了文件的相对位置，将包和其依赖放在同一个 node_modules 下，这让一些使用了绝对路径和幽灵依赖的包在使用 pnpm 安装时会存在问题，不过 pnpm 也在解决这个问题，即通过软链接的形式将所有非工程直接依赖的包放在 .pnpm/node_modules 下，这样就解决了找不到包的问题，项目在迁移 pnpm 的话尽量可能会发现 pnpm i 后还有未安装的包，这个时候就要考虑是否引用了幽灵依赖。

## 总结

pnpm 目前对于日常使用完全没问题，目前很多的类库还有框架都已经默认将 pnpm 作为安装工具，目前看来 pnpm 完全可以取代 npm。
