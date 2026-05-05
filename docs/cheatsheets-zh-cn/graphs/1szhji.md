# Deep Copying a Graph — 将连通无向图的所有节点通过深拷贝进行复制

## 问题的本质

给定一个连通无向图中某个节点的引用。需要创建整个图的**深拷贝（克隆）**，并返回克隆图中对应的节点。每个节点包含一个整数值 `val` 和一个邻接节点列表 `neighbors`。要求构建一个完全独立的新图，不能引用原图中的任何节点。

## 核心思路

由于图中可能存在环，为了避免对同一个节点重复克隆，需要使用 HashMap 记录"原节点→克隆节点"的对应关系。如果节点未被访问过，则创建克隆并注册到 HashMap 中；如果已被访问过，则直接从 HashMap 中返回克隆节点。通过这种方式，既能防止无限循环，又能准确地复制所有节点。

## 思考过程

1. **需要遍历图**: 要复制整个图，必须从起始节点出发访问所有可达节点。使用 DFS（深度优先搜索）递归遍历是最自然的方式
2. **必须处理环**: 在无向图中，必然存在 A→B→A 这样的环。如果对已访问的节点再次进行克隆，会陷入无限循环，因此需要一种机制来判断"该节点是否已经被克隆"
3. **使用 HashMap 管理原节点与克隆节点的对应关系**: 准备一个 `HashMap<Node, Node>`，以"原节点"为键，以"其克隆节点"为值。这样就可以在 O(1) 时间内判断某个节点是否已被克隆，如果已克隆则可以在 O(1) 时间内获取其克隆节点
4. **每一步递归的操作**: 如果当前节点已存在于 HashMap 中，则返回其克隆节点（表示已访问过）。如果不存在，则创建一个新的 Node 并注册到 HashMap 中，然后对原节点的所有邻接节点递归调用克隆方法，并将返回的克隆节点添加到自身的 neighbors 中
5. **注册必须在递归之前进行**: 向 HashMap 注册必须在对邻接节点进行递归调用**之前**完成。如果不先注册，当遇到环回到自身时，HashMap 中找不到克隆节点，就会导致无限循环
6. **最终返回的内容**: 返回起始节点的克隆节点。从该克隆节点出发，所有克隆节点通过邻接列表相互连接

## 前置知识

### 什么是 Node 类

表示图中每个顶点的类。包含一个整数值 `val` 和一个邻接节点列表 `neighbors`。

```java
class Node {
    public int val;
    public List<Node> neighbors;

    public Node(int val) {        // 指定 val 来创建节点
        this.val = val;
        this.neighbors = new ArrayList<>();  // 邻接列表初始化为空
    }
}
```

### 什么是 HashMap

一种保存键值对的数据结构。可以通过指定键在 O(1) 时间内进行查找和获取值。在本题中，以"原节点"为键，以"其克隆节点"为值进行保存，同时兼顾已访问判断和克隆节点获取。

```java
HashMap<Node, Node> map = new HashMap<>();  // 创建一个空的 HashMap
map.put(original, clone);     // 将原节点作为键、克隆节点作为值进行存储
map.containsKey(original);    // 返回原节点是否已注册的 boolean 值 → true
map.get(original);            // 返回原节点对应的克隆节点 → clone
```

### 什么是 DFS（深度优先搜索）

一种图的遍历算法。沿一个方向尽可能深入前进，遇到死路后回溯并沿另一个方向继续前进。可以通过递归调用自然地实现。如果不进行已访问管理，遇到环时会陷入无限循环。

## 计算复杂度

| | 值 |
|---|---|
| Time | O(V + E) — 每个节点访问一次（V），每条边处理一次（E） |
| Space | O(V) — HashMap 中保存 V 个节点的对应关系，递归栈的深度最大为 V 层 |

## 代码

```java
// 输入: 连通无向图中的一个节点 node（Node 类型）。如果图为空则为 null
// 输出: 返回整个图的深拷贝中与输入节点对应的克隆节点（Node 类型）

// 保存 键=原节点、值=克隆节点 的 HashMap
// 放在类的字段中以便所有递归调用共享
Map<Node, Node> map = new HashMap<>();

public Node cloneGraph(Node node) {
    // 如果图为空（null），则返回 null 并结束
    if (node == null) return null;

    // 如果当前节点已经被克隆过，则返回其克隆节点
    // 这就是防止因环而导致无限循环的机制
    if (map.containsKey(node))
        return map.get(node);

    // 创建当前节点的克隆节点（此时 neighbors 为空）
    Node clone = new Node(node.val);

    // 注意: 注册必须在下面 for 循环的递归调用之前进行
    // 如果不先注册，当遇到环回到自身时 containsKey 无法检测到，会导致无限循环
    map.put(node, clone);

    // 递归克隆原节点的所有邻接节点，并将克隆节点添加到克隆节点的邻接列表中
    // 这样就在克隆侧构建了与原图相同的邻接关系
    for (Node nbr : node.neighbors) {
        clone.neighbors
            .add(cloneGraph(nbr));
    }

    // 第一次调用返回的 clone 就是克隆图整体的起始节点
    return clone;
}
```
