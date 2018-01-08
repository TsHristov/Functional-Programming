data BinaryTree a =
  EmptyTree | Node { root :: a, left :: (BinaryTree a), right :: (BinaryTree a) } deriving (Show, Read, Eq)

makeTree :: (Eq a) => a -> a -> a -> BinaryTree a
makeTree root left right = (Node root (Node left EmptyTree EmptyTree)
                                      (Node right EmptyTree EmptyTree))

emptyTree :: BinaryTree a -> Bool
emptyTree EmptyTree = True
emptyTree         _ = False

makeLeaf :: (Eq a) => a -> BinaryTree a
makeLeaf root = (Node root EmptyTree EmptyTree)

leaf :: BinaryTree a -> Bool
leaf (Node root EmptyTree EmptyTree) = True
leaf _ = False

inorder :: BinaryTree a -> [a]
inorder EmptyTree = []
inorder (Node root EmptyTree EmptyTree) = [root]
inorder binaryTree    = traverseLeft ++ rootValue ++ traverseRight
  where traverseLeft  = inorder (left $ binaryTree)
        rootValue     = [root $ binaryTree]
        traverseRight = inorder (right $ binaryTree)

preorder :: BinaryTree a -> [a]
preorder EmptyTree = []
preorder (Node root EmptyTree EmptyTree) = [root]
preorder binaryTree   =  rootValue ++ traverseLeft ++ traverseRight
  where traverseLeft  = preorder (left $ binaryTree)
        rootValue     = [root $ binaryTree]
        traverseRight = preorder (right $ binaryTree)

postorder :: BinaryTree a -> [a]
postorder EmptyTree = []
postorder (Node root EmptyTree EmptyTree) = [root]
postorder binaryTree  = traverseLeft ++ traverseRight ++ rootValue
  where traverseLeft  = postorder (left $ binaryTree)
        rootValue     = [root $ binaryTree]
        traverseRight = postorder (right $ binaryTree)
        
--  All nodes at a given level:
allNodesAtLevel :: BinaryTree a -> Int -> [a]
allNodesAtLevel EmptyTree _ = []
allNodesAtLevel binaryTree 0 = [root $ binaryTree]
allNodesAtLevel binaryTree level = allNodesInLeft ++ allNodesInRight
  where allNodesInLeft  =  allNodesAtLevel (left $ binaryTree) (level-1)
        allNodesInRight =  allNodesAtLevel (right $ binaryTree) (level-1)

-- Make BinaryTree an instance of Functor so we can map over it:
instance Functor BinaryTree where
  fmap f EmptyTree = EmptyTree
  fmap f (Node root left right) = Node (f root) (fmap f left) (fmap f right)
  
-- Maps a function over the binary tree:
mapTree :: (a -> b) -> BinaryTree a -> BinaryTree b
mapTree _ EmptyTree = EmptyTree
mapTree function binaryTree = fmap function binaryTree

-- Check if a path in the tree exists:
pathExists :: (Eq a) => BinaryTree a -> [a] -> Bool
pathExists   EmptyTree [] = True
pathExists           _ [] = False
pathExists EmptyTree path = False
pathExists (Node root left right) (x:xs)
  | x == root = pathExists left xs || pathExists right xs
  | x /= root = False

-- Check if a binary tree is symmetric:
symmetric :: Eq a => BinaryTree a -> Bool
symmetric EmptyTree = True
symmetric tree = symmetricSubtrees (left tree) (right tree)
  where symmetricSubtrees (Node _ _ _) EmptyTree = False
        symmetricSubtrees EmptyTree (Node _ _ _) = False
        symmetricSubtrees EmptyTree EmptyTree    = True
        symmetricSubtrees leftTree rightTree
          | (root $ leftTree) == (root $ rightTree) = (symmetricSubtrees (left leftTree) (right rightTree)) &&
                                                      (symmetricSubtrees (right leftTree) (left rightTree))
          | otherwise                               = False

-- Sorted list to Binary Search Tree:
bstConstruct :: Ord a => [a] -> BinaryTree a
bstConstruct    [] = EmptyTree
bstConstruct  list = Node (list !! middle) (bstConstruct firstHalf) (bstConstruct secondHalf)
  where middle     = length list `div` 2
        firstHalf  = take middle list
        secondHalf = drop (middle + 1) list

bloom :: (Eq a) => BinaryTree a -> BinaryTree a
bloom EmptyTree = EmptyTree
bloom tree@(Node root left right)
  | leaf tree = makeTree root root root
  | otherwise = Node root (bloom left) (bloom right)

-- Removes all leaves in a Binary Tree:
prune :: Eq a => BinaryTree a -> BinaryTree a
prune EmptyTree = EmptyTree
prune tree@(Node root left right)
  | leaf tree = EmptyTree
  | otherwise = Node root (prune left) (prune right)

-- Make BinaryTree instance of typeclass Foldable so we can fold over it:
instance Foldable BinaryTree where
  foldr f z EmptyTree = z
  foldr f z (Node root left right) = foldr f (f root (foldr f z right)) left

-- Checks if a Binary Tree is a valid Binary Search Tree:
validBST :: (Eq a, Ord a) => BinaryTree a -> Bool
validBST EmptyTree = True
validBST (Node root left right) = all (<=root) left && all (>root) right
