# 调试/模拟 电路

想要调试和模拟已经编辑(导入)好的电路，需要软件内部有一套电路状态的更新算法。
算法设计有好几种思路，为了讨论方便，
这里暂且不讨论在具有模块机制的情况下算法的设计问题。

|            | 无延时门 | 有延时门 |
| ---------- | -------- | -------- |
| 无循环依赖 | 解释执行 | 事件驱动 |
| 有循环依赖 | 状态遍历 | (待定)   |

## 解释执行: 

如果电路里只有由简单逻辑门构成的DAG式的没有循环依赖的电路，
或者说，这是一个纯粹的组合逻辑电路，那么问题就非常简单，
整个电路可以看作是一个关于输入输出的纯函数，
我们只需要把整个电路当作一个函数进行一次 `eval` 就好。

算法的核心思路就是对电路进行解释执行。

```js
// 伪代码

// 根据电路结构和输入模拟输出
const simulate = (circuit, input) => 
  circuit.map(logate => {
    if (logate.type === 'input') { // 如果是电路输入
      const { index } = logate;
      return input[index]; // 直接查找对应的输入值
    } else {
      // 根据对应的逻辑门种类进行解释执行
      if (logate.type === 'and') {
        const [ a, b ] = simulate(logate.inputs, input);
        return a && b;
      } else if (logate.type === 'or') {
        const [ a, b ] = simulate(logate.inputs, input);
        return a || b;
      } else if (logate.type === 'not') {
        const [ a ] = simulate(logate.inputs, input);
        return !a;
      }
    }
  });

```

```haskell
-- 用Haskell写伪代码则更简单

-- logic gate 逻辑门
data Logate = And Logate Logate
  | Or Logate Logate
  | Not Logate
  | In Int

type Circuit = [ Logate ]

-- 电路模拟算法
simulate :: Circuit -> [Bool] -> [Bool]
simulate circuit input = ($ input) . fn <$> circuit where
  fn (And a b) = (&&) <$> fn a <*> fn b
  fn (Or a b)  = (||) <$> fn a <*> fn b
  fn (Not a) = not <$> fn a
  fn (In i) = (!! i)  -- 读取对应位置的输入

-- 模拟 full adder 在 A=1, B=1, C=0 下的输出
output = simulate fullAdder [ True, True, False ]
```

## 事件驱动

基于解释执行的模拟算法十分简单，但性能并不好，
在具有多扇出的电路的模拟中，由于解释执行并不能

## 循环依赖

诚如前文所说，解释执行的模拟算法只能求解组合逻辑电路，
不能模拟存在循环依赖的
