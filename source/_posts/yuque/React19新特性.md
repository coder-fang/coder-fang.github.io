---
title: React19 新特性  
categories: React
date: 2025-3-3
updated: 2025-3-3
tags: React19
cover: https://cdn.jsdelivr.net/gh/coder-fang/myBlogImgRespository/img/20221211145840.png
---

# React19 新特性
## Actions
在 React 应用中，一个常见的用例是执行数据变更，然后响应更新状态。例如，当用户提交一个表单来更改他们的名字，你会发起一个API请求，然后处理响应。在过去，你需要手动处理待定状态、错误、乐观更新和顺序请求。

例如，你可以在useState中处理待定和错误状态：
```js
// 没有 Actions 之前
function UpdateName() {
    const [name, setName] = useState('');
    const [error,setError] = useState(null);
    const [isPending, setIsPending] = useState(false);
    const handleSubmit = async() => {
        setIsPending(true);
        const error = await updateName(name);
        setIsPending(false);
        if(error) {
            setError(error);
            return;
        }
        redirect('/path');
    };
    return (
        <div>
            <input value={name} onChange={(event) => setName(event.target.value)} />
            <button onClick={handleSubmit} disabled={isPending}>
                Update
            </button>
            {error && <p>{error}</p>}
        </div>
    )
}
```

在 React 19 中，正在添加在过渡中使用异步函数的支持，以自动处理待定状态、错误、表单和乐观更新。
例如，你可以使用`useTransition` 来为你处理待定状态。
```js
// 使用 Actions 中的待定状态
function UpdateName({}) {
  const [name, setName] = useState("");
  const [error, setError] = useState(null);
  const [isPending, startTransition] = useTransition();

  const handleSubmit = () => {
    startTransition(async () => {
      const error = await updateName(name);
      if (error) {
        setError(error);
        return;
      } 
      redirect("/path");
    })
  };

  return (
    <div>
      <input value={name} onChange={(event) => setName(event.target.value)} />
      <button onClick={handleSubmit} disabled={isPending}>
        Update
      </button>
      {error && <p>{error}</p>}
    </div>
  );
} 
```
> 异步过渡会立即将isPending 状态设置为true，发出异步请求，然后在任何过渡后将isPending切换为false。这使你能够在数据变化时保持当前UI的响应性和交互性。

```
📢注意：
    按照惯例，使用异步过渡的函数被称为“Actions”。
    Actions 自动为你管理数据提交：

    - 待定状态：Actions 提供一个待定状态，该状态在请求开始时启动，并在最终状态更新时自动重置。
    - 乐观更新：Actions 支持新的 `useOptimistic` Hook，因此你可以在请求提交时向用户显示及时反馈。
    - 错误处理：Actions 提供错误处理，因此当请求失败时，你可以显示错误边界，并自动将乐观更新恢复到原始值。
    - 表单：`<form>`元素现在支持将函数传递给action和formAction属性。将函数传递给action属性默认使用Actions，并在提交后自动重置表单。
```

## 新增Hooks
在 Actions的基础上，React 19 引入了 useOptimistic来管理乐观更新，以及一个新的 Hook `React.useActionState` 来处理Actions 的常见情况。

### useOptimistic
> 执行数据变更时，另一个常见UI模式是在异步请求时乐观地显示最终状态。在React19中，我们添加了一个名为`useOptimistic`的新Hook，来更容易地实现这一点。

🌰具体使用方式：
```js
function ChangeName({currentName, onUpdateName}) {
  const [optimisticName, setOptimisticName] = useOptimistic(currentName);

  const submitAction = async formData => {
    const newName = formData.get("name");
    setOptimisticName(newName);
    const updatedName = await updateName(newName);
    onUpdateName(updatedName);
  };

  return (
    <form action={submitAction}>
      <p>Your name is: {optimisticName}</p>
      <p>
        <label>Change Name:</label>
        <input
          type="text"
          name="name"
          disabled={currentName !== optimisticName}
        />
      </p>
    </form>
  );
}
```
`useOptimistic`Hook 会在`updateName`请求进行时立即渲染`optimistcName`。当更新完成或出错时，React 将自动切换回`currentName`值。
