# 逻辑层的电路表示

## 无延时门的组合逻辑电路

数据结构设计

``` Haskell
-- logical gate ( 逻辑门 ) 的缩写
data Logate = Add Logate Logate
  | Or Logate Logate
-- 其他二输入的逻辑门
-- | OtherLogicGate Logate Logate
  | Not Logate
  | In Integer

type Circuit = [ Logate ];
```

__Example:__

以一个全加器为例：

```
// HDL 伪代码
IN : A , B , Ci
Out : S , Co

wire X := xor(A, B)

S := xor(X, Ci)
Co := or(and(A, B), and(X, C))
```

``` Haskell
-- 则对应的数据结构为
fullAdder = [
  Xor (Xor (In 0) (In 1)) (In 2),
  Or (And (In 0) (In 1)) (And (Xor (In 0) (In 1)) (In 2))
]
```

``` Haskell
-- 电路模拟算法
simulate :: Circuit -> [Bool] -> [Bool]
simulate circuit input = fmap (($ input) . fn) circuit where
  fn (And a b) = (&&) <$> fn a <*> fn b
  fn (Or a b)  = (||) <$> fn a <*> fn b
  fn (Not a) = not <$> fn a
  fn (In i) = (!! i)

-- 模拟 full adder 在 A=1, B=1, C=0 下的输出
output = simulate fullAdder [ True, True, False ]
```

