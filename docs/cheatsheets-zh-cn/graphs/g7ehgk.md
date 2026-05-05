# Finding the Shortest Word Transformation Sequence — 求最短单词变换序列的长度

## 问题的本质

给定起始单词 `beginWord`、目标单词 `endWord` 和有效单词字典 `wordList`。从起始单词到目标单词，**每一步只能更改一个字符**，并且所有中间单词都必须存在于字典中，求满足条件的变换序列的**最短长度**。如果不存在这样的变换序列，则返回0。

## 核心思路

如果将单词之间的单字符变换视为图的边，那么最短变换序列就转化为最短路径问题。从起点和终点同时执行BFS，每次优先扩展较小的前沿集合，可以大幅缩减搜索空间。

## 思考过程

1. **建模为图**：将每个单词视为节点，将只差一个字符的单词之间连边，构成一个图。最短变换序列的长度等价于该图上从beginWord到endWord的最短路径长度
2. **使用BFS求最短路径**：由于是无权图的最短路径问题，因此适合使用BFS（广度优先搜索）。每一层对应一步变换
3. **单向BFS的低效性**：如果只从起点执行BFS，每一层的候选单词会指数级增长。搜索空间随深度急剧膨胀
4. **双向BFS缩减搜索空间**：从起点和终点同时执行BFS，当两个方向的搜索相遇时即找到最短路径。由于每一方只需搜索d/2的深度，搜索空间大幅缩减
5. **优先扩展较小的前沿集合**：每一步比较起点侧和终点侧的前沿集合（当前层的单词集合）的大小，优先扩展较小的一方。这样可以始终抑制前沿集合的膨胀
6. **邻接单词的生成方法**：不逐一与字典中所有单词比较，而是对单词的每个位置尝试a～z共26个字符来生成邻接单词。当单词长度m远小于字典大小n时，这种方法更高效
7. **判断与对方前沿集合的汇合**：如果生成的邻接单词存在于对方的前沿集合中，说明两个方向的搜索已经汇合，此时返回当前层数+1

## 前置知识

### BFS（广度优先搜索）

BFS是一种从图的起点开始按距离由近到远逐层探索节点的算法。由于每一层的距离递增1，因此第一次到达某节点时的距离即为最短距离。BFS适用于无权图的最短路径问题。

### HashSet

HashSet是一种保存元素集合的数据结构。元素的添加、查找和删除操作的时间复杂度均为O(1)。HashSet会自动排除重复元素。

```java
Set<String> set = new HashSet<>();   // 创建空的HashSet
set.add("hot");                      // 添加元素
set.contains("hot");                 // 判断元素是否存在，返回boolean → true
set.size();                          // 返回元素数量 → 1
```

### 双向BFS

与普通BFS只从起点进行搜索不同，双向BFS从起点和终点同时进行搜索。当两个方向的前沿集合重叠时即找到最短路径。搜索空间从O(b^d)缩减为O(b^(d/2))（b为分支因子，d为最短距离）。

### toCharArray / String.valueOf

这些方法用于将String转换为字符数组，以便逐字符进行操作。

```java
char[] ch = "hot".toCharArray();     // 将String转换为char[] → ['h','o','t']
ch[0] = 'b';                        // 直接替换单个字符 → ['b','o','t']
String next = String.valueOf(ch);    // 将char[]转换回String → "bot"
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n × m) — n为字典中的单词数，m为单词长度。对每个单词的每个位置尝试26个字符 |
| Space | O(n × m) — 已访问集合和前沿集合最多保存n个单词（每个长度为m） |

## 代码

```java
// 输入：起始单词 beginWord、目标单词 endWord、有效单词字典 wordList
// 输出：返回最短变换序列的长度（int类型）。如果不存在变换序列则返回0
int ladderLength(String beginWord, String endWord, List<String> wordList) {
    // 将字典转换为HashSet，使单词存在性判断的时间复杂度为O(1)
    Set<String> wordSet = new HashSet<>(wordList);
    // 如果endWord不在字典中，则无法构造变换序列，返回0
    if (!wordSet.contains(endWord)) return 0;

    // 创建起点侧前沿集合、终点侧前沿集合和已访问集合这三个HashSet
    Set<String> start = new HashSet<>();
    Set<String> end = new HashSet<>();
    Set<String> visited = new HashSet<>();
    start.add(beginWord);
    end.add(endWord);
    // 将两个前沿集合中的单词注册为已访问
    visited.add(beginWord);
    visited.add(endWord);
    // level表示变换序列的长度（起始单词本身计为1）
    int level = 1;

    // 当任一前沿集合为空时，说明无法到达目标，退出循环
    while (!start.isEmpty() && !end.isEmpty()) {
        // 始终扩展较小的前沿集合，以抑制搜索空间的膨胀
        if (start.size() > end.size()) {
            Set<String> temp = start;
            start = end;
            end = temp;
        }

        // 用于保存下一层候选单词的集合
        Set<String> nextLevel = new HashSet<>();

        for (String word : start) {
            // 将单词转换为char[]，逐个位置替换字符以生成邻接单词
            char[] ch = word.toCharArray();
            for (int j = 0; j < ch.length; j++) {
                // 保存原始字符，以便搜索后恢复
                char orig = ch[j];
                // 对每个位置尝试a～z共26个字符以生成邻接单词
                for (char c = 'a'; c <= 'z'; c++) {
                    ch[j] = c;
                    String next = String.valueOf(ch);
                    // 如果该单词存在于对方的前沿集合中，说明两个方向的搜索已汇合
                    if (end.contains(next)) return level + 1;
                    // 如果该单词在字典中且未被访问过，则将其加入下一层的前沿集合
                    // 同时加入visited以防止重复访问同一单词
                    if (wordSet.contains(next) && !visited.contains(next)) {
                        nextLevel.add(next);
                        visited.add(next);
                    }
                }
                // 恢复原始字符，为下一个位置的搜索做准备
                ch[j] = orig;
            }
        }
        // 将前沿集合替换为下一层，level加1后进入下一次迭代
        start = nextLevel;
        level++;
    }
    // 当任一前沿集合为空时，说明不存在变换序列
    return 0;
}
```
