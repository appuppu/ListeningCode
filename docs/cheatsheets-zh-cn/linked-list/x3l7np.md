# Designing a Least Recently Used Cache — 设计一个在容量超出时自动删除最久未使用元素的缓存

## 问题的本质

设计一个保存整数键和值的缓存。该缓存需要支持 `get(key)` 和 `put(key, value)` 两种操作，并且两者都必须以 O(1) 的时间复杂度运行。当缓存超出容量 `capacity` 时，**自动删除最久未使用（Least Recently Used）的元素**，然后再插入新元素。

## 核心思路

以访问顺序模式创建 Java 的 LinkedHashMap，并重写 `removeEldestEntry` 方法。这样每次执行 get/put 时访问顺序都会自动更新，容量超出时最旧的元素也会被自动删除。LRU 缓存的全部功能仅凭 LinkedHashMap 的内部机制即可实现。

## 思考过程

1. **需要 O(1) 的 get/put**：要实现从键到值的快速访问，需要使用 HashMap。但普通的 HashMap 不具备跟踪元素使用顺序的功能
2. **需要跟踪使用顺序**：LRU 需要识别出"最久未使用的元素"。每当元素被访问时，需要将其移动到"最新"位置，留在头部的元素即为"最旧"的元素，因此需要一种有序结构
3. **LinkedHashMap 兼具这两种功能**：Java 的 LinkedHashMap 在 HashMap 的功能基础上，内部维护了一个双向链表。将构造函数的第三个参数设为 `true` 即可启用访问顺序模式，每次执行 get 或 put 时，对应元素会自动移动到链表末尾
4. **容量超出时的自动删除**：重写 LinkedHashMap 的 `removeEldestEntry` 方法，使其在 `size() > capacity` 时返回 `true`。LinkedHashMap 在 put 新元素后会立即调用此方法，若返回 `true`，则自动删除链表头部（最旧的元素）
5. **get 时键不存在的情况**：根据题目要求，键不存在时需要返回 `-1`。使用 `getOrDefault(key, -1)` 可以在一次调用中完成存在性检查和值的获取
6. **最终结构**：在构造函数中以访问顺序模式创建 LinkedHashMap 并重写 `removeEldestEntry`，get/put 两个方法只需简单地委托给 LinkedHashMap 即可

## 前置知识

### LinkedHashMap 是什么

LinkedHashMap 是一种在 HashMap 的全部功能基础上，通过内部双向链表来维护元素顺序的数据结构。将构造函数的第三个参数 `accessOrder` 设为 `true` 时，每当元素被访问（get 或 put），该元素就会被移动到链表末尾。链表头部始终保留着最久未被访问的元素。

```java
// 第1个参数: 初始容量, 第2个参数: 负载因子, 第3个参数: true=访问顺序模式
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(16, 0.75f, true);
map.put(1, 10);     // 将值10存入键1。链表: [1]
map.put(2, 20);     // 将值20存入键2。链表: [1, 2]
map.get(1);          // 访问键1。链表: [2, 1]（1移动到末尾）
map.put(3, 30);     // 将值30存入键3。链表: [2, 1, 3]
// 此时链表头部的键2是"最久未使用的元素"
```

### removeEldestEntry 是什么

removeEldestEntry 是 LinkedHashMap 在 put 新元素后自动调用的方法。当此方法返回 `true` 时，LinkedHashMap 会自动删除链表头部最旧的元素。默认情况下该方法始终返回 `false`，因此需要通过重写来定义删除条件。

```java
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(cap, 0.75f, true) {
    @Override
    protected boolean removeEldestEntry(Map.Entry<Integer, Integer> eldest) {
        return size() > cap;  // 当大小超出容量时返回true，触发删除最旧的元素
    }
};
```

### getOrDefault 是什么

getOrDefault 是 Map 接口的方法。如果键存在则返回对应的值，如果不存在则返回第二个参数指定的默认值。该方法将 `containsKey` 和 `get` 的两次调用合并为一次。

```java
map.put(1, 10);
map.getOrDefault(1, -1);   // 键1存在，因此返回值10
map.getOrDefault(99, -1);  // 键99不存在，因此返回默认值-1
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(1) — get/put 的 HashMap 访问和链表内的移动操作均以 O(1) 运行 |
| Space | O(n) — 在 LinkedHashMap 中保存与缓存容量相当的元素（n 为 capacity） |

## 代码

```java
// 输入: 构造函数接收整数 capacity（缓存的最大容量），get 接收整数 key，put 接收整数 key 和整数 value
// 输出: get 返回键对应的值（键不存在时返回 -1）。put 不返回值
class LRUCache {
    LinkedHashMap<Integer, Integer> map;
    // 保存容量的实例变量。在 removeEldestEntry 中用于删除判定
    int cap;

    // 接收容量，并以访问顺序模式初始化 LinkedHashMap
    LRUCache(int capacity) {
        cap = capacity;
        // 第1个参数: 初始容量, 第2个参数: 默认负载因子, 第3个参数: true=访问顺序模式
        // 启用访问顺序模式后，每次执行 get 或 put 时对应元素会自动移动到链表末尾
        map = new LinkedHashMap<>(cap, 0.75f, true) {
            // LinkedHashMap 在每次 put 时自动调用的方法
            // 当 size() > cap 时返回 true，触发自动删除链表头部最旧的元素
            // 这样缓存的大小始终保持在 cap 以下
            protected boolean removeEldestEntry(Map.Entry<Integer, Integer> e) {
                return size() > cap;
            }
        };
    }

    // 键存在时: 由于访问顺序模式，对应元素会移动到链表末尾（被记录为最新），并返回其值
    // 键不存在时: 返回默认值 -1
    int get(int key) {
        return map.getOrDefault(key, -1);
    }

    // 插入或更新键值对
    // 插入后 removeEldestEntry 会被自动调用，若 size() > cap 则删除最旧的元素
    // 若键已存在，则值被覆盖，对应元素移动到链表末尾
    void put(int key, int value) {
        map.put(key, value);
    }
}
```
