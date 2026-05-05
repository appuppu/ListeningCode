# Constructing a Binary Tree From Traversal Orders — 根据前序遍历和中序遍历还原原始二叉树

## 问题的本质

给定整数数组 `preorder`（前序遍历）和 `inorder`（中序遍历）。要求根据这两个遍历结果构建并返回原始二叉树。前序遍历按照「根→左→右」的顺序排列元素，中序遍历按照「左→根→右」的顺序排列元素。

## 核心思路

前序遍历的首元素一定是当前子树的根节点，通过查找该根节点的值在中序遍历中的位置，可以将中序遍历分割为「左子树的元素」和「右子树的元素」。递归地重复这一分割过程，即可还原整棵树。

## 思考过程

1. **前序遍历的首元素是根节点**: 前序遍历按照「根→左→右」的顺序排列元素，因此数组的首元素一定是整棵树的根节点。这一性质对子树同样递归成立
2. **在中序遍历中找到根节点的位置即可分割左右子树**: 中序遍历按照「左→根→右」的顺序排列，因此当根节点的值位于中序遍历的位置 `mid` 时，`mid` 左侧的所有元素属于左子树，`mid` 右侧的所有元素属于右子树
3. **需要快速求出根节点的位置**: 如果每次都对中序遍历进行线性搜索，整体时间复杂度为O(n²)。预先用HashMap记录「值→中序遍历中的索引」，即可以O(1)的时间获取根节点的位置
4. **用索引边界表示子树范围，而非复制数组**: 如果每次递归都复制数组，则需要O(n²)的空间。用 `inLeft` 和 `inRight` 两个索引表示中序遍历的范围，即可在不复制数组的情况下指定子树的范围
5. **全局推进前序遍历的指针**: 前序遍历按照「根→左子树全体→右子树全体」的顺序排列，因此准备一个全局指针 `preIdx`，每取出一个根节点就将其递增，当左子树的递归完成时，指针自然指向右子树的根节点
6. **先构建左子树**: 前序遍历的顺序是「根→左→右」，因此取出根节点后必须先递归构建左子树，然后再构建右子树。遵守这一顺序才能保证 `preIdx` 正确推进

## 前置知识

### 前序遍历（Preorder Traversal）

前序遍历是按照「根→左子树→右子树」的顺序访问二叉树的遍历方法。数组的首元素一定是根节点的值。

```
        3
       / \
      9   20
         / \
        15   7

前序遍历: [3, 9, 20, 15, 7]  ← 首元素3是根节点
```

### 中序遍历（Inorder Traversal）

中序遍历是按照「左子树→根→右子树」的顺序访问二叉树的遍历方法。以根节点的值为基准，左侧的元素属于左子树，右侧的元素属于右子树。

```
中序遍历: [9, 3, 15, 20, 7]  ← 3左侧的[9]是左子树，右侧的[15,20,7]是右子树
```

### HashMap

HashMap是保存键值对的数据结构。通过指定键，可以以O(1)的时间搜索和获取对应的值。

```java
HashMap<Integer, Integer> map = new HashMap<>();  // 创建空的HashMap
map.put(3, 1);           // 将值1存储到键3中
map.get(3);              // 返回键3对应的值 → 1
```

### TreeNode

TreeNode是表示二叉树中一个节点的类。它包含值 `val`、左子节点 `left` 和右子节点 `right`。

```java
TreeNode root = new TreeNode(3);    // 创建值为3的节点
root.left = new TreeNode(9);        // 将值为9的节点设置为左子节点
root.right = new TreeNode(20);      // 将值为20的节点设置为右子节点
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n) — 每个节点只处理一次，HashMap的查找时间为O(1) |
| Space | O(n) — HashMap中保存n个元素，递归栈在最坏情况下为O(n)（退化树的情况） |

## 代码

```java
// 输入: 整数数组 preorder（前序遍历）和整数数组 inorder（中序遍历）
// 输出: 返回还原后的二叉树的根节点 TreeNode

// 键=中序遍历的值，值=该值在中序遍历中的索引，保存在HashMap中
// 用于以O(1)的时间从根节点的值获取其在中序遍历中的位置
Map<Integer, Integer> map = new HashMap<>();
// 指向前序遍历数组中「下一个要取出的根节点位置」的全局指针
// 每次递归调用时递增并向前推进
int preIdx = 0;

public TreeNode buildTree(int[] preorder, int[] inorder) {
    // 将中序遍历的每个值及其索引注册到HashMap中
    // 这样可以立即查询任意值在中序遍历中的位置
    for (int i = 0; i < inorder.length; i++)
        map.put(inorder[i], i);

    // 指定整个数组的范围（inLeft=0, inRight=末尾）并开始递归
    return helper(preorder, 0, inorder.length - 1);
}

// inLeft, inRight 表示当前子树在中序遍历数组上的范围
TreeNode helper(int[] preorder, int inLeft, int inRight) {
    // 如果子树的范围为空（inLeft > inRight），则子节点不存在
    if (inLeft > inRight) return null;

    // 从前序遍历的当前位置取出根节点的值，并推进指针
    int rootVal = preorder[preIdx++];
    TreeNode root = new TreeNode(rootVal);

    // 通过HashMap获取根节点的值在中序遍历中的位置
    // mid 表示中序遍历中左子树和右子树的分界点
    int mid = map.get(rootVal);

    // 注意: 前序遍历按照「根→左→右」的顺序排列，因此必须先构建左子树
    // 遵守这一顺序才能保证 preIdx 正确指向右子树的根节点
    // 中序遍历中从 inLeft 到 mid-1 的范围是左子树
    root.left = helper(preorder, inLeft, mid - 1);
    // 中序遍历中从 mid+1 到 inRight 的范围是右子树
    root.right = helper(preorder, mid + 1, inRight);

    // 返回构建好的 root 节点。当所有递归完成时，返回整棵树的根节点
    return root;
}
```
