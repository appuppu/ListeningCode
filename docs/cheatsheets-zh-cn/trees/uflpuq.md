# Checking if a Tree is a Subtree of Another — 判定一棵树是否作为另一棵树的子树

## 问题的本质

给定两棵二叉树 `root` 和 `subRoot`。返回一个 `boolean` 值，表示 `root` 中是否存在与 `subRoot` 在结构和值上完全一致的子树。子树是指以 `root` 的某个节点为根，从该节点往下的整棵树与 `subRoot` 完全相同。

## 核心思路

如果将树通过带null标记的前序遍历序列化为字符串，那么子树的判定问题就可以归结为"一个字符串是否包含另一个字符串"的字符串搜索问题。

## 思考过程

1. **子树的匹配判定是"对整棵树的形状和值进行比较"**: 要成为子树，某个节点以下的结构和所有节点的值必须完全一致。也就是说，需要一种在保存树的形状信息的基础上进行比较的方法
2. **如果能唯一地表示一棵树，比较就变得容易**: 在树结构的状态下进行比较，需要对每个节点进行递归遍历。如果将树序列化为字符串，结构和值的比较就变成了字符串的比较，可以高效地处理
3. **在前序遍历（preorder）中加入null标记以保证唯一性**: 仅靠前序遍历，不同的树可能会生成相同的字符串。通过在子节点为null的位置插入 `#` 等标记，可以唯一地编码树的结构
4. **在每个节点的值前面加上逗号分隔符**: 为了明确值的边界，在每个节点的值前面添加逗号 `,`。这样可以防止例如值 `2` 和 `12` 被混淆
5. **子树的判定可以归结为字符串的包含判定**: 如果 `root` 序列化后的字符串包含 `subRoot` 序列化后的字符串作为子串，则 `subRoot` 是 `root` 的子树。使用Java的 `String.contains()` 可以进行O(m+n)的判定

## 前置知识

### 二叉树的前序遍历（Preorder Traversal）

按照"根 → 左子节点 → 右子节点"的顺序访问树的节点的遍历方法。用递归实现时，首先处理当前节点，然后递归处理左子树，最后递归处理右子树。

```java
void preorder(TreeNode node) {
    if (node == null) return;
    System.out.println(node.val);  // 处理根节点
    preorder(node.left);           // 递归遍历左子树
    preorder(node.right);          // 递归遍历右子树
}
```

### StringBuilder

用于高效拼接字符串的类。`String` 的 `+` 运算符每次拼接都会生成新的对象，而 `StringBuilder` 通过向内部缓冲区追加内容，可以以O(1)的时间复杂度进行添加。

```java
StringBuilder sb = new StringBuilder();  // 创建一个空的StringBuilder
sb.append(",5");                         // 将字符串 ",5" 追加到缓冲区末尾
sb.append(",#");                         // 将字符串 ",#" 追加到缓冲区末尾
sb.toString();                           // 将缓冲区的内容转换为String类型 → ",5,#"
```

### String.contains()

返回一个 `boolean` 值，表示某个字符串是否包含另一个字符串作为子串的方法。

```java
String s = ",1,2,#,#,3,#,#";
s.contains(",2,#,#");    // 判定s是否包含 ",2,#,#" → true
s.contains(",4,#,#");    // 判定s是否包含 ",4,#,#" → false
```

### null标记

在树的序列化中，在子节点不存在（null）的位置插入的特殊符号。通常使用 `#`。如果没有null标记，不同结构的树会产生相同的遍历结果。例如，为了区分只有左子节点的树和只有右子节点的树，null标记是必要的。

## 计算复杂度

| | 值 |
|---|---|
| Time | O(m + n) — 分别对root（节点数m）和subRoot（节点数n）进行一次遍历并序列化，然后执行字符串的包含判定 |
| Space | O(m + n) — 将两棵树的序列化结果保存到StringBuilder中 |

## 代码

```java
// 输入: 二叉树的根节点 root 和 subRoot
// 输出: 如果 subRoot 是 root 的子树则返回 true，否则返回 false

// 通过前序遍历将树序列化为字符串的辅助方法
void serialize(TreeNode node, StringBuilder sb) {
    if (node == null) {
        // 添加null标记 ",#" 以明确表示子节点不存在
        // 这样可以区分只有左子节点的树和只有右子节点的树
        sb.append(",#");
        return;
    }
    // 在值前面加上逗号，以避免值 2 和 12 这样的数值边界产生歧义
    sb.append("," + node.val);
    // 递归序列化左子树
    serialize(node.left, sb);
    // 递归序列化右子树
    serialize(node.right, sb);
}

boolean isSubtree(TreeNode root, TreeNode subRoot) {
    // sb1 存储 root 的序列化结果，sb2 存储 subRoot 的序列化结果
    StringBuilder sb1 = new StringBuilder();
    StringBuilder sb2 = new StringBuilder();

    // 通过前序遍历将两棵树序列化为字符串
    serialize(root, sb1);
    serialize(subRoot, sb2);

    // 如果root的字符串包含subRoot的字符串作为子串，则subRoot是root的子树
    return sb1.toString().contains(sb2.toString());
}
```
