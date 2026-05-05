# Merging K Sorted Linked Lists — 将K个已排序链表合并为一个

## 问题的本质

给定一个包含K个已排序链表（Linked List）的数组。需要将所有链表合并为**一个已排序的链表**，并返回其头节点。每个链表各自已排序，合并后的链表也需要保持升序。

## 核心思路

不是一次性合并K个链表，而是将链表两两配对反复进行合并。每一轮链表数量减半，因此经过 log k 轮即可收敛为一个链表，对全部N个元素可达到O(N log k)的效率。

## 思考过程

1. **基本操作是"合并两个已排序链表"**：将K个链表合并的问题，可以分解为"将两个已排序链表合并为一个"这一基本操作的组合。合并两个链表时，反复比较两个链表的头部并选择较小的一方，即可在O(n)内完成
2. **如何将这一基本操作应用于K个链表**：如果简单地将第1个和第2个合并，再将结果与第3个合并……依次进行则时间复杂度为O(Nk)。因为每次合并结果都会变长，后半部分的合并成本会越来越高
3. **两两配对合并可使成本均匀分摊**：将链表两两配对进行合并，每一轮只需将全部元素各处理一次。链表数量每轮减半，因此轮数为 log k，整体可达到O(N log k)
4. **使用数组索引管理配对**：将`interval`变量按1, 2, 4, 8…倍增，将`lists[i]`与`lists[i + interval]`合并后存入`lists[i]`。这样无需额外数组，即可原地实现两两配对合并
5. **所有轮次结束后，lists[0]即为最终结果**：每一轮的合并结果依次汇聚到`lists[0]`、`lists[2]`、`lists[4]`……等偶数索引位置，最终所有元素都合并到`lists[0]`中

## 前置知识

### ListNode（链表节点）

ListNode是表示链表中每个元素的类。`val`保存节点的值，`next`保存对下一个节点的引用。`next`为`null`的节点即为链表的末尾。

```java
class ListNode {
    int val;              // 该节点保存的值
    ListNode next;        // 对下一个节点的引用（末尾则为null）
    ListNode(int val) {   // 构造函数：指定值来创建节点
        this.val = val;
    }
}
```

### 哑节点（Sentinel Node）

哑节点是一种简化链表构建的技巧。在链表头部放置一个值为0的哑节点，在其后面依次连接实际的节点。最后返回`dummy.next`，从而无需对头节点进行特殊处理。

```java
ListNode dummy = new ListNode(0);  // 创建哑节点
ListNode tail = dummy;             // tail是追踪末尾位置的指针
tail.next = someNode;              // 在哑节点后面连接节点
tail = tail.next;                  // 将tail移动到末尾
return dummy.next;                 // 返回哑节点的下一个节点，即实际的头节点
```

### 分治法（Divide and Conquer）

分治法是将问题拆分为更小的子问题，分别求解后再合并结果的方法。归并排序是典型的例子，它将数组不断对半拆分，再将已排序的子数组进行合并。本题中将K个链表两两配对进行反复合并。

```java
// interval按1, 2, 4, 8...倍增，逐步扩大配对的间隔
for (int interval = 1; interval < n; interval *= 2) {
    // 每一轮依次合并各对链表
    for (int i = 0; i < n - interval; i += 2 * interval) {
        lists[i] = merge(lists[i], lists[i + interval]);
    }
}
```

## 复杂度

| | 值 |
|---|---|
| Time | O(N log k) — 每轮处理全部N个元素一次，共进行 log k 轮 |
| Space | O(log k) — 不使用递归，但需要与合并轮数对应的循环栈空间 |

## 代码

```java
// 输入：已排序链表的数组 ListNode[] lists（包含K个元素）
// 输出：返回将所有链表合并后的一个已排序链表的头节点 ListNode

// 将两个已排序链表合并为一个的辅助方法
private ListNode mergeTwoLists(ListNode a, ListNode b) {
    // 创建哑节点，作为合并结果链表的头部标记（实际数据从dummy.next开始）
    ListNode dummy = new ListNode(0);
    // tail始终追踪合并结果的末尾，指示连接新节点的位置
    ListNode tail = dummy;

    // 当两个链表都还有剩余节点时，选择较小的一方进行连接（以维持排序顺序）
    while (a != null && b != null) {
        if (a.val <= b.val) {
            tail.next = a;  // 将a的当前节点连接到合并结果中
            a = a.next;     // 将a移动到下一个节点
        } else {
            tail.next = b;  // 将b的当前节点连接到合并结果中
            b = b.next;     // 将b移动到下一个节点
        }
        tail = tail.next;   // 将tail移动到末尾，为连接下一个节点做准备
    }

    // while循环结束后，a或b中的某一方还有剩余节点。由于两者都已排序，直接连接即可
    tail.next = (a != null) ? a : b;

    // dummy本身是哑节点，其下一个节点才是合并结果的实际头节点
    return dummy.next;
}

public ListNode mergeKLists(ListNode[] lists) {
    // 如果输入为null或为空，则不存在需要合并的链表，返回null
    if (lists == null || lists.length == 0) return null;

    // 将链表数量K保存到n中
    int n = lists.length;

    // 将interval按1, 2, 4, 8...倍增。interval表示合并配对之间的距离，每一轮链表数量减半
    for (int interval = 1; interval < n; interval *= 2) {
        // i < n - interval 这一条件确保配对的右侧 lists[i + interval] 在数组范围内
        for (int i = 0; i < n - interval; i += 2 * interval) {
            // 将配对的合并结果存入lists[i]。右侧链表之后不再使用，因此覆盖到左侧没有问题
            lists[i] = mergeTwoLists(lists[i], lists[i + interval]);
        }
    }

    // 所有轮次结束后，全部链表的合并结果已汇聚到lists[0]中
    return lists[0];
}
```
