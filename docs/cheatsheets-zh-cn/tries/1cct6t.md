# Implementing a Prefix Tree — 设计一个数据结构，对给定字符串高效地执行插入、完全匹配搜索和前缀搜索

## 问题的本质

设计并实现一个名为 Trie（前缀树）的数据结构。该数据结构需要支持三种操作：(1) `insert(word)` 插入一个单词，(2) `search(word)` 判断是否存在完全匹配的单词，(3) `startsWith(prefix)` 判断已插入的单词中是否存在以指定前缀开头的单词。

## 核心思路

将字符串逐字符分解为节点并构建树结构，这样具有相同前缀的单词就能共享节点。在每个节点上设置一个标志，表示"是否有单词在此结束"，这样完全匹配搜索和前缀搜索的区别就仅在于遍历结束时是否检查该标志。

## 思考过程

1. **将字符串逐字符展开为树结构**：将要插入的单词逐字符表示为节点，通过父子关系表示字符的排列顺序。这样，像"apple"和"app"这样具有相同前缀的单词就能共享前3个节点（a→p→p）
2. **使用 HashMap 管理每个节点的子节点**：每个节点持有与下一个字符对应的子节点。子节点的管理使用 HashMap，键为"字符"，值为"子节点的引用"。这样就能以 O(1) 的时间复杂度完成到任意字符的转移
3. **需要区分单词终端的标志**：插入"apple"后搜索"app"时，a→p→p 这些节点是可以遍历到的。但由于"app"并未被插入，所以需要返回 false。通过在每个节点上设置 `isEnd` 标志，并在 `insert` 时将最后一个节点的 `isEnd` 设为 `true`，就能区分单词的终端
4. **三种操作的基础都是节点遍历**：`insert`、`search`、`startsWith` 都从根节点开始，逐字符遍历字符串并转移到对应节点。`insert` 在转移目标不存在时创建新节点。`search` 和 `startsWith` 在转移目标不存在时立即返回 false
5. **search 和 startsWith 的区别仅在于是否检查 isEnd**：`search` 在遍历完所有字符后检查 `node.isEnd` 是否为 true。`startsWith` 在遍历完所有字符后直接返回 true。遍历逻辑完全相同，仅最后的判定不同
6. **根节点是一个虚拟节点**：作为 Trie 起点的根节点被初始化为一个不持有字符的空节点。所有操作都从该根节点开始遍历

## 前置知识

### 什么是 Trie（字典树）

Trie 是一种用于高效存储和搜索字符串的树结构。每个节点对应一个字符，从根到叶的路径表示一个字符串。具有相同前缀的字符串会共享节点，因此 Trie 是一种擅长前缀搜索的数据结构。

```
例：插入 "app"、"apple"、"bat" 后的树结构

      root
      / \
     a   b
     |   |
     p   a
     |   |
     p*  t*
     |
     l
     |
     e*

* 表示 isEnd = true 的节点（单词的终端）
```

### 什么是 HashMap

HashMap 是一种保存键值对的数据结构。通过指定键，可以以 O(1) 的时间复杂度搜索和获取值。在 Trie 中，HashMap 用于管理每个节点的子节点。

```java
HashMap<Character, TrieNode> children = new HashMap<>();  // 创建空的HashMap
children.put('a', new TrieNode());      // 在键'a'处存储一个新节点
children.containsKey('a');              // 返回键'a'是否存在的boolean值 → true
children.get('a');                      // 返回键'a'对应的节点
children.putIfAbsent('a', new TrieNode());  // 仅在键'a'未注册时才存储
```

### 什么是 putIfAbsent

putIfAbsent 是 HashMap 的方法，仅在指定的键尚不存在时才存储值。如果键已存在，则不做任何操作。在 `insert` 操作中，该方法用于在不破坏现有路径的情况下仅添加新节点。

```java
map.putIfAbsent('a', new TrieNode());  // 如果'a'未注册，则注册一个新节点
map.putIfAbsent('a', new TrieNode());  // 'a'已注册，所以不做任何操作
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(m) — insert、search、startsWith 中的任何一个操作都只遍历一次，与字符串长度 m 成正比 |
| Space | O(n * m) — 存储 n 个单词（平均长度为 m）。由于共同前缀会共享节点，实际使用量会小于该值 |

## 代码

```java
// 输入：insert(word)接收字符串word，search(word)接收字符串word，startsWith(prefix)接收字符串prefix
// 输出：insert无返回值（将单词添加到Trie中），search返回boolean表示是否存在完全匹配的单词，startsWith返回boolean表示是否存在与前缀匹配的单词

// TrieNode类：表示Trie的每个节点
class TrieNode {
    // 到子节点的映射。键=字符，值=对应的子节点
    Map<Character, TrieNode> children;
    // 表示是否有单词在该节点结束的标志（初始值为false）
    // 通过该标志，search能够区分完全匹配和前缀匹配
    boolean isEnd;

    TrieNode() {
        children = new HashMap<>();
        isEnd = false;
    }
}

class Trie {
    // 所有操作的起点——根节点（不持有字符的空虚拟节点）
    private TrieNode root;

    // 在构造函数中创建一个空的TrieNode作为根节点
    public Trie() {
        root = new TrieNode();
    }

    public void insert(String word) {
        // node是表示当前遍历位置的指针。从根节点开始遍历
        TrieNode node = root;
        // 从字符串word的开头逐字符遍历
        for (char c : word.toCharArray()) {
            // 使用putIfAbsent，如果子节点不存在则新建，如果已存在则不做任何操作
            // 使用putIfAbsent可以避免覆盖现有路径（其他单词共享的节点）
            node.children.putIfAbsent(c, new TrieNode());
            // 将指针移动到字符c对应的子节点
            node = node.children.get(c);
        }
        // 在最后一个节点上设置单词终端标志
        // 通过该标志，search能够区分"apple"已插入而"app"未插入的情况
        node.isEnd = true;
    }

    public boolean search(String word) {
        // 从根节点开始遍历
        TrieNode node = root;
        // 从字符串word的开头逐字符遍历
        for (char c : word.toCharArray()) {
            // 如果对应的子节点不存在，说明Trie中没有该字符对应的路径，立即返回false
            if (!node.children.containsKey(c))
                return false;
            // 将指针移动到子节点
            node = node.children.get(c);
        }
        // 如果遍历完所有字符后到达的节点是单词终端则返回true，否则返回false
        // 这样，当"apple"已插入而"app"未插入时，search("app")能够正确返回false
        return node.isEnd;
    }

    public boolean startsWith(String prefix) {
        // 从根节点开始遍历
        TrieNode node = root;
        // 从字符串prefix的开头逐字符遍历
        for (char c : prefix.toCharArray()) {
            // 如果对应的子节点不存在，说明Trie中没有该前缀对应的路径，立即返回false
            if (!node.children.containsKey(c))
                return false;
            // 将指针移动到子节点
            node = node.children.get(c);
        }
        // 所有字符都遍历成功，说明Trie中存在以该前缀开头的单词
        // 与search的区别仅在于不检查isEnd
        return true;
    }
}
```
