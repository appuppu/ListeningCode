# Checking if Two Binary Trees Are Identical — 判断两棵二叉树的结构和值是否完全相同

## 问题的本质

给定两棵二叉树 `p` 和 `q`。两棵树"相同"意味着结构完全一致，且所有对应节点的值都相等。如果相同则返回 `true`，否则返回 `false`。

## 核心思路

将两棵树的对应节点作为"配对"放入队列中，按层级顺序逐对取出并进行比较。如果所有配对的结构和值都一致，则两棵树相同；只要有一对不一致，就可以立即判定两棵树不同。

## 思考过程

1. **只需比较对应位置的节点**: 要判断两棵树是否相同，只需逐对比较树中相同位置的节点。如果所有配对的值都一致，且结构（子节点的有无）也一致，则两棵树相同
2. **如何管理配对**: 需要按顺序管理待比较的节点配对。使用队列（FIFO）可以按广度优先的方式逐层取出配对进行比较。队列中存储 `TreeNode[]` 数组（包含2个元素），`pair[0]` 表示树p的节点，`pair[1]` 表示树q的节点
3. **取出配对时需要判断什么**: 对取出的配对依次判断三种情况。（a）如果两者都为null，说明结构一致，继续处理下一个配对；（b）如果只有一方为null，说明结构不同，返回 `false`；（c）如果两者都非null但值不同，返回 `false`
4. **通过判断后将子节点配对加入队列**: 当前配对一致时，接下来需要比较的是左子节点配对和右子节点配对。将 `{n1.left, n2.left}` 和 `{n1.right, n2.right}` 两组配对加入队列。即使子节点为null也可以直接加入（步骤3的null判断会正确处理）
5. **队列为空则表示所有配对都一致**: 比较完所有配对后未发现不一致，说明两棵树相同，返回 `true`

## 前置知识

### Queue（队列）

队列是一种先进先出（FIFO）的数据结构。最先添加的元素最先被取出。在广度优先搜索中用于按层级顺序处理节点。在Java中通过 `LinkedList` 实现 `Queue` 接口。

```java
Queue<TreeNode[]> queue = new LinkedList<>();  // 创建一个存储TreeNode数组的队列
queue.add(new TreeNode[]{p, q});               // 将配对（包含2个元素的数组）添加到队列末尾
TreeNode[] pair = queue.poll();                 // 从队列头部取出并返回配对（队列为空时返回null）
queue.isEmpty();                               // 返回队列是否为空的boolean值 → true/false
```

### TreeNode（二叉树的节点）

TreeNode是表示二叉树中每个节点的类。`val` 字段存储节点的值，`left` 和 `right` 字段分别存储对左子节点和右子节点的引用。当子节点不存在时为 `null`。

```java
TreeNode node = new TreeNode(5);   // 创建一个值为5的节点
node.val;                          // 获取节点的值 → 5
node.left;                         // 获取左子节点（不存在时为null）
node.right;                        // 获取右子节点（不存在时为null）
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n) — 对两棵树的节点最多各比较n个，每个比较一次 |
| Space | O(n) — 队列中最多保持与节点数成正比的配对数 |

## 代码

```java
// 输入: 两棵二叉树的根节点 p 和 q
// 输出: 如果两棵树的结构和值完全相同则返回 true，否则返回 false
public boolean isSameTree(TreeNode p, TreeNode q) {
    // 创建一个队列来管理待比较的节点配对
    // 配对以包含2个元素的 TreeNode[] 数组形式存储，pair[0] 表示树p的节点，pair[1] 表示树q的节点
    Queue<TreeNode[]> queue = new LinkedList<>();
    // 作为初始状态，将两棵树的根节点配对加入队列（这是第一个需要比较的配对）
    queue.add(new TreeNode[]{p, q});

    // 当队列不为空时，逐对取出并进行比较
    while (!queue.isEmpty()) {
        // 从队列头部取出一个配对
        TreeNode[] pair = queue.poll();
        TreeNode n1 = pair[0];
        TreeNode n2 = pair[1];

        // 如果两者都为null，说明在该位置两棵树都没有子节点，结构一致。继续处理下一个配对
        if (n1 == null && n2 == null)
            continue;
        // 如果只有一方为null，说明一棵树存在节点而另一棵不存在，结构不同
        if (n1 == null || n2 == null)
            return false;
        // 如果值不同，说明对应节点的值不一致，返回false
        if (n1.val != n2.val)
            return false;

        // 当前配对一致，将接下来需要比较的子节点配对加入队列
        // 即使子节点为null也直接加入（上面的null判断会正确处理）
        queue.add(new TreeNode[]{n1.left, n2.left});
        queue.add(new TreeNode[]{n1.right, n2.right});
    }
    // 所有配对的结构和值都一致，返回true
    return true;
}
```
