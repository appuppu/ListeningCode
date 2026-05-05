# Traversing a Binary Tree Level by Level — 将二叉树的节点按层级分组并存入列表

## 问题的本质

给定一棵二叉树的 `root`。将树的节点按**层级（深度）**进行分组，每一层的节点值按从左到右的顺序存入 `List<Integer>`，然后将所有层级的列表按从上到下的顺序组成 `List<List<Integer>>` 返回。

## 核心思路

使用队列（Queue）可以按"广度优先"的方式从左到右处理节点。在每一层开始时记录队列的大小，然后取出该数量的节点，就能准确地管理层级的分界。

## 思考过程

1. **按层级处理适合使用广度优先搜索（BFS）**：深度优先搜索（DFS）会沿着一条分支深入遍历，因此难以按层级进行分组。BFS 按照从浅到深的顺序处理节点，天然适合按层级遍历
2. **实现 BFS 需要使用队列**：队列是先进先出（FIFO）的数据结构，能够实现"优先处理先添加的（较浅的）节点"这一 BFS 的行为
3. **如何判定层级的分界**：在开始处理每一层时，队列中的所有节点都属于同一层级。在此时将 `queue.size()` 记录到变量 `size` 中，然后取出 `size` 个节点，就能恰好处理完一层的节点
4. **将取出节点的子节点作为下一层添加到队列中**：取出每个节点时，将其左右子节点添加到队列中。这些子节点在当前层的处理过程中不会被取出（因为取出次数被 `size` 限制了）。它们会在下一次 while 循环的迭代中作为下一层被处理
5. **将每一层的结果收集到列表中并返回**：为每一层创建一个 `List<Integer>`，存入该层的节点值。一层处理完毕后，将该列表添加到最终结果 `List<List<Integer>>` 中
6. **队列为空时所有层级的处理完成**：当所有节点都被取出后，队列变为空，while 循环结束。此时结果列表中已按从上到下的顺序存入了所有层级的节点值

## 前置知识

### 什么是 Queue（队列）

先进先出（FIFO）的数据结构。最先添加的元素最先被取出。在 Java 中，使用 LinkedList 作为 Queue 接口的实现。

```java
Queue<TreeNode> queue = new LinkedList<>();  // 创建一个空队列
queue.offer(node);   // 将 node 添加到队列末尾
queue.poll();        // 取出并返回队列头部的元素（该元素从队列中移除）
queue.size();        // 返回队列中元素的数量 → int
queue.isEmpty();     // 返回队列是否为空的 boolean 值
```

### 什么是 BFS（广度优先搜索）

一种按"广度"方向探索图或树的算法。从距离起点近的节点开始依次处理。使用队列来实现。应用于树时，按层级 0 → 层级 1 → 层级 2…的顺序访问节点。

### TreeNode 的结构

表示二叉树中每个节点的类。具有值 `val`、左子节点 `left`、右子节点 `right` 三个字段。

```java
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
}
```

## 复杂度

| | 值 |
|---|---|
| Time | O(n) — 对树中的每个节点各处理一次 |
| Space | O(n) — 队列中最多存储树中最宽层级的节点数（最坏情况为 n/2） |

## 代码

```java
// 输入：二叉树的根节点 root
// 输出：返回将每一层的节点值汇总为列表的 List<List<Integer>>
List<List<Integer>> levelOrder(TreeNode root) {
    // 存储每一层节点值列表的最终结果
    List<List<Integer>> result = new ArrayList<>();

    // 如果 root 为 null，则树为空，直接返回空的 result
    if (root == null) return result;

    // 创建 BFS 用的队列，并将根节点添加进去
    // 此时队列中只有层级 0 的一个节点
    Queue<TreeNode> queue = new LinkedList<>();
    queue.offer(root);

    // 在队列不为空的情况下，按层级重复处理
    // 当队列为空时，所有节点的处理已完成
    while (!queue.isEmpty()) {
        // 注意：需要在循环之前将该值保存到变量中
        // 因为在 for 循环内会向队列添加子节点导致队列大小发生变化，
        // 如果直接将 queue.size() 用作 for 循环的条件，将无法正确划分层级
        int size = queue.size();
        // 用于存储当前层级节点值的列表
        List<Integer> level = new ArrayList<>();

        for (int i = 0; i < size; i++) {
            // 从队列头部取出节点
            TreeNode node = queue.poll();
            // 将节点的值添加到当前层级的列表中
            level.add(node.val);

            // 如果左子节点存在，则将其添加到队列中（在下一层中处理）
            if (node.left != null)
                queue.offer(node.left);
            // 如果右子节点存在，则将其添加到队列中
            // 通过按左→右的顺序添加子节点，下一层的节点也会按从左到右的顺序被处理
            if (node.right != null)
                queue.offer(node.right);
        }

        // 一层的处理已完成，将其添加到结果中
        result.add(level);
    }
    // 返回按从上到下的顺序存储了所有层级节点值的 result
    return result;
}
```
