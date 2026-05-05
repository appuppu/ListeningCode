# Designing a Time-Based Key-Value Store — 设计一个带时间戳的键值存储

## 问题的本质

设计一个数据结构，通过 `set(key, value, timestamp)` 将键和值以带时间戳的方式保存，通过 `get(key, timestamp)` 返回指定时间戳**以下**的最大时间戳所对应的值。如果不存在符合条件的时间戳，则返回空字符串。

## 核心思路

如果对每个键以排序的方式保持时间戳，就能在对数时间内搜索"不超过指定值的最大键"。Java的TreeMap通过 `floorEntry` 方法内置提供了这一操作。

## 思考过程

1. **整理操作**: `set` 是向键添加时间戳和值的配对的操作，`get` 是返回"不超过指定时间戳的最大时间戳"所对应的值的操作。`get` 的本质是"查找不超过某个值的最大值"的搜索问题
2. **按键管理时间戳**: 不同的键彼此独立，因此用外层的HashMap按键进行分离，对每个键保持时间戳→值的对应结构
3. **选择能高效求"不超过某值的最大值"的数据结构**: 对排序后的数据求"不超过某值的最大值"需要二分搜索。TreeMap（基于红黑树的平衡二叉搜索树）按排序顺序保持键，通过 `floorEntry(key)` 以O(log n)返回"不超过指定键的最大条目"
4. **确定set的实现方式**: 如果外层HashMap中键未注册，则创建新的TreeMap，然后以时间戳为键、值为值对TreeMap执行 `put`。使用 `computeIfAbsent` 可以将存在性检查和创建用一行代码完成
5. **确定get的实现方式**: 首先确认HashMap中键是否存在，如果不存在则返回空字符串。如果存在则调用TreeMap的 `floorEntry(timestamp)`，结果不为null则返回其值，为null则返回空字符串
6. **处理边界情况**: 在以下两种情况下返回空字符串：键本身未注册的情况，以及键存在但所有时间戳都大于指定值的情况

## 前置知识

### 什么是 HashMap

HashMap是保存键值对的数据结构。通过指定键，可以以O(1)的时间复杂度搜索和获取值。

```java
HashMap<String, TreeMap<Integer, String>> map = new HashMap<>();  // 创建空的HashMap
map.containsKey("foo");    // 以boolean返回键"foo"是否存在
map.get("foo");            // 返回键"foo"对应的值
```

### 什么是 computeIfAbsent

computeIfAbsent是HashMap的方法。仅当键未注册时，通过Lambda表达式生成值并注册，然后返回该值。当键已存在时，返回已有的值。可以将存在性检查→创建→注册用一行代码完成。

```java
map.computeIfAbsent("foo", k -> new TreeMap<>());
// "foo"未注册 → 创建新的TreeMap并注册，返回该TreeMap
// "foo"已注册 → 返回已有的TreeMap
```

### 什么是 TreeMap

TreeMap是基于平衡二叉搜索树的Map，按键的排序顺序（升序）保持键。与普通的HashMap不同，TreeMap提供基于键的大小关系的搜索操作。`put` 和 `get` 以O(log n)运行。

```java
TreeMap<Integer, String> tree = new TreeMap<>();  // 创建空的TreeMap
tree.put(1, "one");        // 在时间戳1存储"one"
tree.put(3, "three");      // 在时间戳3存储"three"
tree.put(5, "five");       // 在时间戳5存储"five"
```

### 什么是 floorEntry

floorEntry是TreeMap的方法。返回不超过指定键的最大键所对应的条目（键值对）。如果不存在符合条件的条目，则返回null。由于内部执行二分搜索，因此以O(log n)运行。

```java
tree.floorEntry(4);   // 不超过键4的最大值 → 返回键3的条目 {3="three"}
tree.floorEntry(5);   // 不超过键5的最大值 → 返回键5的条目 {5="five"}
tree.floorEntry(0);   // 不存在不超过键0的条目 → 返回null

Map.Entry<Integer, String> entry = tree.floorEntry(4);
entry.getValue();     // 从条目中获取值 → "three"
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(log n) — set和get都是TreeMap的操作，为O(log n)（n是该键下保存的时间戳数量） |
| Space | O(n) — 存储所有set调用保存的条目（n是全部条目数量） |

## 代码

```java
// 输入: set(key, value, timestamp) — 字符串键、字符串值、整数时间戳 / get(key, timestamp) — 字符串键、整数时间戳
// 输出: set 无返回值 / get 返回对应值的字符串（无对应值则返回空字符串）
class TimeMap {
    // 保持 键 → (时间戳 → 值) 的TreeMap的HashMap
    // 外层HashMap按键分离，内层TreeMap按排序顺序保持时间戳
    Map<String, TreeMap<Integer, String>> map;

    public TimeMap() {
        // 创建HashMap作为外层数据结构
        map = new HashMap<>();
    }

    public void set(String key, String val, int ts) {
        // 使用computeIfAbsent，如果键未注册则自动创建并注册新的TreeMap，如果已存在则返回已有的TreeMap
        // TreeMap在插入时按排序顺序放置键，因此不需要显式的排序操作
        map.computeIfAbsent(key, k -> new TreeMap<>())
            .put(ts, val);
    }

    public String get(String key, int ts) {
        // 如果键本身不存在，说明set从未被调用过，返回空字符串
        if (!map.containsKey(key))
            return "";

        // 获取该键的TreeMap
        TreeMap<Integer, String> tree = map.get(key);

        // 搜索不超过指定时间戳的最大条目（TreeMap以O(log n)探索内部的二叉搜索树）
        Map.Entry<Integer, String> entry = tree.floorEntry(ts);

        // 如果找到条目则返回其值。如果为null，表示所有时间戳都大于指定值，返回空字符串
        return entry != null ? entry.getValue() : "";
    }
}
```
