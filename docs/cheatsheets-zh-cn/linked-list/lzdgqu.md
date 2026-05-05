# Deep Copying a Linked List With Random Pointers — 创建带有随机指针的链表的完整副本

## 问题的本质

给定一个链表，其中每个节点除了 `next` 指针之外，还有一个 `random` 指针，该指针指向链表中的任意节点（或 null）。要求创建并返回该链表的**深拷贝**（完全独立的副本）。副本中节点的 `random` 指针必须指向副本链表中对应的节点，而不是原始链表中的节点。

## 核心思路

将复制的节点插入到原始节点的紧后方（交错排列），这样原始节点的 `random` 指向的节点的"下一个节点"就是副本中对应的节点。利用这种结构关系，无需 HashMap 即可在 O(1) 空间内正确设置随机指针。

## 思考过程

1. **难点在于 random 指针的对应关系**：如果只有 `next` 指针，按顺序逐个复制即可，但 `random` 指向任意节点，因此需要一种方法来获取原始节点与副本节点之间的对应关系
2. **使用 HashMap 可以在 O(n) 空间内解决，但能否做到 O(1)**：将原始节点→副本节点的对应关系保存在 HashMap 中即可解决，但需要考虑能否不使用额外的数据结构，而是利用链表本身的结构来表达对应关系
3. **将副本节点插入到原始节点的紧后方**：在原始节点 A 的紧后方插入副本 A'，形成 `A → A' → B → B' → C → C'` 的交错结构。这样，对于任意原始节点 `X`，`X.next` 必定是其副本 `X'`，对应关系被嵌入到了链表结构本身中
4. **利用交错结构设置 random 指针**：当原始节点 `curr` 的 `random` 指向另一个原始节点 `R` 时，副本节点 `curr.next` 的 `random` 应设置为 `R` 的副本，即 `R.next`。也就是说，可以通过 `curr.next.random = curr.random.next` 这个公式统一设置
5. **将两个链表分离**：设置完 random 指针后，从交错排列的链表中交替取出原始链表和副本链表并分离。同时需要将原始链表恢复原状
6. **通过三次遍历完成**：第1次遍历插入副本节点，第2次遍历设置 random 指针，第3次遍历分离链表。每次遍历为 O(n)，且不使用额外的数据结构，因此空间复杂度为 O(1)

## 前置知识

### 链表的节点结构（带 random 指针）

除了普通链表的 `next` 之外，还持有一个指向链表中任意节点的 `random` 指针的特殊节点。`random` 也可能为 `null`。

```java
class Node {
    int val;
    Node next;      // 指向下一个节点（普通链表）
    Node random;    // 指向链表中的任意节点或 null

    Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
```

### 什么是深拷贝

创建与原始对象完全独立的副本。副本中的节点不能引用原始链表中的节点。所有指针（`next` 和 `random`）都必须仅指向副本链表中的节点。

```java
// 浅拷贝（不正确）：copy.random 指向了原始链表中的节点
copy.random = original.random;

// 深拷贝（正确）：copy.random 指向副本中对应的节点
copy.random = originalToCopyMapping(original.random);
```

### 什么是交错排列

将两个序列的元素交替排列。在这道题中，将副本节点插入到原始链表的节点之间，形成 `A → A' → B → B' → C → C'` 的结构。这样，原始节点 `X` 的副本始终可以通过 `X.next` 访问。

```java
// 原始链表:       A → B → C → null
// 交错排列后:     A → A' → B → B' → C → C' → null
// A 的副本通过 A.next 访问，B 的副本通过 B.next 访问
```

## 复杂度

| | 值 |
|---|---|
| Time | O(n) — 遍历链表3次。每次遍历为 O(n)，因此总计 O(3n) = O(n) |
| Space | O(1) — 除了用于输出的副本节点之外，不使用额外的数据结构 |

## 代码

```java
// 输入：带有 random 指针的链表的头节点 head
// 输出：返回输入链表的深拷贝的头节点
public Node copyRandomList(Node head) {
    // 空链表没有需要复制的内容
    if (head == null) return null;

    // === 第1次遍历：在每个原始节点的紧后方插入副本节点 ===
    // 遍历结束后形成 A → A' → B → B' → C → C' 的交错结构
    Node curr = head;
    while (curr != null) {
        // 创建与原始节点具有相同值的新副本节点
        Node copy = new Node(curr.val);
        copy.next = curr.next;       // 将副本的 next 设置为原始节点的 next
        curr.next = copy;            // 将原始节点的 next 设置为副本，将副本插入到 curr 的紧后方
        curr = copy.next;            // copy.next 是原始的下一个节点。前进到下一个原始节点
    }

    // === 第2次遍历：利用交错结构设置 random 指针 ===
    curr = head;
    while (curr != null) {
        // curr.next 是副本节点，curr.random.next 是 random 目标的副本节点
        // 如果 curr.random 为 null，则副本的 random 也保持为 null
        curr.next.random =
            curr.random != null
            ? curr.random.next : null;
        curr = curr.next.next;       // 跳过副本节点，前进到下一个原始节点
    }

    // === 第3次遍历：将交错排列的链表分离为原始链表和副本链表 ===
    // 需要将原始链表恢复原状
    curr = head;
    Node copyHead = head.next;       // 保存副本链表的头节点。这将是最终的返回值
    while (curr != null) {
        Node copy = curr.next;       // 获取副本节点
        curr.next = copy.next;       // 恢复原始链表的 next（跳过副本，指向原始的下一个节点）
        copy.next = copy.next != null
            ? copy.next.next : null;  // 连接副本链表的 next（跳过原始节点，指向下一个副本）
        curr = curr.next;            // 前进到恢复后的原始的下一个节点
    }

    // copyHead 是深拷贝后的链表的头节点
    return copyHead;
}
```
