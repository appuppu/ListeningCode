# 模拟最后一块石头的重量游戏 — 每次取出两块石头碰撞，求最后剩余石头的重量

## 问题的本质

给定一个整数数组 `stones`。每次取出**最重的两块石头**进行碰撞。如果两块石头的重量相等，则两块石头都被完全粉碎；如果重量不同，则较轻的石头被完全粉碎，较重的石头的重量减少为两者的差值。重复此操作直到剩余石头不超过一块，返回最后剩余石头的重量。如果没有石头剩余，则返回0。

## 核心思路

每次需要高效地取出"最重的两块石头"。使用最大堆（Max-Heap），取出最大值的时间复杂度为O(log n)，因此无需重新排序即可始终获取最重的两块石头。

## 思考过程

1. **每次操作需要取出两个最大值**: 石头碰撞的规则要求每次选择最重的两块石头。也就是说，这是一个反复执行"从当前集合中取出最大值两次"操作的问题
2. **希望高效地取出最大值**: 如果每次都对数组排序，每轮需要O(n log n)的时间。使用最大堆，取出最大值只需O(log n)，插入元素也只需O(log n)
3. **将Java的PriorityQueue用作Max-Heap**: Java的PriorityQueue默认是Min-Heap（最小值在队首）。通过传入 `Collections.reverseOrder()` 作为比较器，可以使其作为最大值在队首的Max-Heap运行
4. **将所有石头放入堆中**: 将数组 `stones` 的所有元素添加到PriorityQueue中。这样堆就准备好管理最大值了
5. **在石头数量不少于两块时，重复碰撞操作**: 通过 `poll()` 从堆中取出两次最大值，如果差值不为0，则用 `add()` 将差值放回堆中。如果差值为0，则不放回任何值（两块石头都被粉碎）
6. **判断最终状态并返回结果**: 循环结束后，如果堆为空，说明所有石头都已被粉碎，返回0。如果堆中还剩一块石头，则用 `poll()` 取出该石头的重量并返回

## 前置知识

### 什么是PriorityQueue（优先队列）

PriorityQueue是一种数据结构，添加元素后内部会自动维护顺序，通过 `poll()` 始终可以取出优先级最高的元素。其内部实现是堆（二叉堆），添加和取出操作的时间复杂度均为O(log n)。

```java
// 默认是Min-Heap（最小值在队首）
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.add(5);       // 添加元素5
minHeap.add(2);       // 添加元素2
minHeap.poll();       // 取出并返回最小值2
minHeap.size();       // 返回当前元素个数 → 1
minHeap.isEmpty();    // 返回队列是否为空的boolean值 → false
```

### 什么是Collections.reverseOrder()

Collections.reverseOrder()是传递给PriorityQueue构造函数的比较器，它将默认的升序（Min-Heap）反转为降序（Max-Heap）。这样 `poll()` 就会返回最大值。

```java
// 创建Max-Heap（最大值在队首）
PriorityQueue<Integer> maxHeap =
    new PriorityQueue<>(Collections.reverseOrder());
maxHeap.add(3);       // 添加元素3
maxHeap.add(7);       // 添加元素7
maxHeap.add(1);       // 添加元素1
maxHeap.poll();       // 取出并返回最大值7
maxHeap.poll();       // 取出并返回下一个最大值3
```

### Max-Heap的运行示意

stones = [2, 7, 4, 1, 8, 1] 的情况：
- 将所有元素添加到堆中后，内部以 `[8, 7, 4, 1, 2, 1]` 的形式进行管理
- `poll()` → 取出8。堆重新调整为 `[7, 4, 2, 1, 1]`
- `poll()` → 取出7。将 8 - 7 = 1 通过 `add()` 放回堆中

## 复杂度

| | 值 |
|---|---|
| Time | O(n log n) — 最多进行n次碰撞操作，每次操作中堆的取出和添加需要O(log n) |
| Space | O(n) — 堆中最多存储n块石头 |

## 代码

```java
// 输入: 整数数组 stones（每个元素表示石头的重量）
// 输出: 以 int 形式返回最后剩余石头的重量。如果没有石头剩余则返回0
public int lastStoneWeight(int[] stones) {
    // 指定 Collections.reverseOrder() 作为比较器，创建 poll() 返回最大值的Max-Heap
    PriorityQueue<Integer> pq =
        new PriorityQueue<>(Collections.reverseOrder());

    // 将所有石头添加到堆中。完成后堆处于将最大值维护在队首的状态
    for (int s : stones) pq.add(s);

    // 在石头数量不少于两块时，重复取出最重的两块进行碰撞的操作
    while (pq.size() >= 2) {
        // 调用两次 poll()，取出最重的石头和第二重的石头
        // 因为是Max-Heap，所以 a >= b 始终成立
        int a = pq.poll();
        int b = pq.poll();

        // 如果重量不同，将差值石头放回堆中。如果相同，两块石头都被粉碎，不放回任何值
        if (a != b) pq.add(a - b);
    }

    // 如果堆为空，说明所有石头都已被粉碎，返回0；如果还有剩余，返回该石头的重量
    return pq.isEmpty() ? 0 : pq.poll();
}
```
