# Serializing and Deserializing a Binary Tree — 将二叉树转换为字符串，并从字符串还原原始树结构

## 问题的本质

设计一个算法，将二叉树序列化为字符串，并从该字符串反序列化还原原始二叉树。往返转换必须是无损的——还原后的树必须与原始树完全相同。

## 核心思路

使用 Preorder（前序）遍历对树进行序列化时，每个节点的"左子节点→右子节点"结构会被递归地记录下来。只要将 null 作为哨兵值显式记录，反序列化时只需从头到尾依次消费各个标记，就能通过递归唯一地还原原始树结构。

## 思考过程

1. **唯一还原树结构需要什么条件**：要唯一确定二叉树的结构，需要知道每个节点的子节点是否存在。只要显式记录 null 的位置，仅凭一种遍历顺序就能唯一地再现树结构
2. **Preorder 遍历适合的原因**：Preorder 按照"根节点→左子树→右子树"的顺序访问节点。由于根节点最先出现，反序列化时可以从头开始消费标记，同时递归地生成节点。遍历顺序与节点生成顺序一致，因此实现起来非常自然
3. **将 null 作为哨兵值记录**：当节点为 null 时，记录字符串 `"null"`。这样在反序列化时就能判断"子树在此处结束"的边界。如果没有哨兵值，就无法确定子树的终点
4. **序列化的格式**：将每个节点的值用逗号连接。格式为 `"1,2,null,null,3,4,null,null,5,null,null"`。用逗号进行 split 即可得到标记数组
5. **反序列化通过递归消费标记**：从标记列表的头部逐个 poll（取出）标记。如果取出的值为 `"null"` 则返回 null，否则生成节点并递归构建左子节点和右子节点。使用 LinkedList 可以实现 O(1) 的头部 poll 操作
6. **递归顺序与 Preorder 一致**：序列化时的 Preorder 顺序（根→左→右）与反序列化时的递归调用顺序（生成节点→左子节点→右子节点）完全一致，因此只需按顺序消费标记就能正确还原树结构

## 前置知识

### 什么是 Preorder（前序）遍历

Preorder 是一种按照"根节点 → 左子树 → 右子树"的顺序递归访问二叉树的遍历方法。由于根节点最先被处理，序列化后数据的开头始终是根节点。

```java
void preorder(TreeNode node) {
    if (node == null) return;
    visit(node);           // 首先处理根节点
    preorder(node.left);   // 然后递归处理左子树
    preorder(node.right);  // 最后递归处理右子树
}
```

### 什么是 StringBuilder

StringBuilder 是一个用于高效拼接字符串的类。使用 `+` 运算符拼接字符串时，每次都会生成新的 String 对象，导致时间复杂度为 O(n²)；而 StringBuilder 通过向内部缓冲区追加内容，时间复杂度仅为 O(n)。

```java
StringBuilder sb = new StringBuilder();  // 创建空的 StringBuilder
sb.append("hello");                      // 在末尾追加字符串
sb.append(",");                          // 追加逗号
sb.deleteCharAt(sb.length() - 1);        // 删除末尾的一个字符
sb.toString();                           // 转换为 String → "hello"
```

### LinkedList 与 poll 方法

LinkedList 是一种在列表头部和尾部进行添加、删除操作均为 O(1) 的数据结构。`poll()` 方法取出并返回列表的头部元素（该元素会从列表中删除）。当列表为空时返回 null。

```java
LinkedList<String> tokens = new LinkedList<>(Arrays.asList("1", "2", "null"));
tokens.poll();  // 返回 "1" 并从列表中删除。剩余: ["2", "null"]
tokens.poll();  // 返回 "2" 并从列表中删除。剩余: ["null"]
```

### 什么是哨兵值

哨兵值是一种用于表示数据终点或特殊状态的特殊值。在本题中，使用字符串 `"null"` 作为哨兵，表示"该位置不存在子节点"。有了哨兵值，反序列化时就能准确判断子树的边界。

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n) — 对全部 n 个节点各访问一次 |
| Space | O(n) — 序列化字符串和标记列表占用 n 个元素的空间。递归调用栈在最坏情况下为 O(n)（退化树的情况） |

## 代码

```java
// 输入: 序列化 — 二叉树的根节点 root。反序列化 — 逗号分隔的字符串 data
// 输出: 序列化 — 表示树的逗号分隔字符串。反序列化 — 原始二叉树的根节点

// 将二叉树序列化为字符串
public String serialize(TreeNode root) {
    // 用于以逗号分隔的形式累积树中所有节点值的缓冲区
    StringBuilder sb = new StringBuilder();
    // 按 Preorder 顺序遍历树，将值追加到 StringBuilder 中
    serHelper(root, sb);
    // 删除末尾多余的逗号
    if (sb.length() > 0)
        sb.deleteCharAt(sb.length() - 1);
    return sb.toString();
}

// 按 Preorder 顺序遍历树，将每个节点的值追加到 StringBuilder 中
void serHelper(TreeNode node, StringBuilder sb) {
    // 将 null 节点记录为哨兵值 "null"（用于反序列化时判断子树的终点）
    if (node == null) {
        sb.append("null,");
        return;
    }
    // 记录当前节点的值（由于是 Preorder，根节点最先被处理）
    // 各值以逗号分隔的形式排列
    sb.append(node.val).append(",");
    // 递归处理左子树
    serHelper(node.left, sb);
    // 递归处理右子树（根→左→右的顺序实现了 Preorder 遍历）
    serHelper(node.right, sb);
}

// 从字符串反序列化还原二叉树
public TreeNode deserialize(String data) {
    // 空字符串表示空树
    if (data.isEmpty()) return null;
    // 按逗号分割并转换为 LinkedList（因为需要使用 poll() 从头部以 O(1) 取出元素）
    LinkedList<String> tokens =
        new LinkedList<>(Arrays.asList(data.split(",")));
    // 从头部依次消费标记，同时递归生成节点
    return desHelper(tokens);
}

// 从头部依次消费标记，同时递归生成节点
TreeNode desHelper(LinkedList<String> tokens) {
    // 取出头部标记（poll 会从列表中删除该元素，因此下次递归时下一个标记成为头部）
    String val = tokens.poll();
    // 如果是哨兵值则返回 null 并终止递归（父节点的子节点被设置为 null）
    if (val.equals("null")) return null;
    // 将标记的值转换为整数，并创建新节点
    TreeNode node = new TreeNode(Integer.parseInt(val));
    // 按照 Preorder 顺序，先构建左子节点（由于与序列化时的顺序一致，正确的标记会被对应消费）
    node.left = desHelper(tokens);
    // 然后构建右子节点
    node.right = desHelper(tokens);
    // 返回构建好的节点（第一次调用的返回值即为根节点，也就是还原后的整棵树）
    return node;
}
```
