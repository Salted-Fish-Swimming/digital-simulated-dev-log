-- ghc --run ./main.hs

data Logate = And Logate Logate
  | Or Logate Logate
  | Xor Logate Logate
  | Not Logate
  | In Int
  deriving (Show)

type Circuit = [ Logate ]

xor :: Bool -> Bool -> Bool
xor a b = (a && not b) || (not a && b)

simulate :: Circuit -> [Bool] -> [Bool]
simulate circuit input = ($ input) . fn <$> circuit where
  fn (And a b) = (&&) <$> fn a <*> fn b
  fn (Or a b)  = (||) <$> fn a <*> fn b
  fn (Xor a b) = xor <$> fn a <*> fn b
  fn (Not a) = not <$> fn a
  fn (In i) = (!! i)

fullAdder = [
  Xor (Xor (In 0) (In 1)) (In 2),
  Or (And (In 0) (In 1)) (And (Xor (In 0) (In 1)) (In 2)) ]

main = print $ simulate fullAdder [ True, True, False ]
