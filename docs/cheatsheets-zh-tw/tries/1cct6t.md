# Implementing a Prefix Tree — 設計一個資料結構，能夠高效地對給定字串執行插入、完全匹配搜尋和前綴搜尋

## 問題的本質

設計並實作一個稱為 Trie（前綴樹）的資料結構。這個資料結構需要支援三種操作：(1) `insert(word)` 插入一個單詞，(2) `search(word)` 判斷是否存在完全匹配的單詞，(3) `startsWith(prefix)` 判斷已插入的單詞中是否有以指定前綴開頭的單詞。

## 核心思路

如果將字串逐字元分解為節點並組成樹狀結構，那麼擁有共同前綴的單詞之間就會共享節點。透過在每個節點中設置一個「單詞是否在此結束」的旗標，完全匹配搜尋和前綴搜尋的差異就僅在於：走訪結束時是否檢查該旗標。

## 思考過程

1. **將字串逐字元展開為樹狀結構**：將要插入的單詞逐字元表示為節點，用父子關係表示字元的排列順序。這樣一來，像「apple」和「app」這樣擁有共同前綴的單詞，就能共享前面的3個節點（a→p→p）
2. **使用 HashMap 管理每個節點的子節點**：每個節點擁有對應下一個字元的子節點。子節點的管理使用 HashMap，鍵為「字元」，值為「子節點的參照」。這樣就能以 O(1) 的時間複雜度轉移到任意字元
3. **需要一個旗標來區分單詞的結尾**：插入「apple」之後搜尋「app」時，a→p→p 的節點是可以走訪到的。但由於「app」並未被插入，所以需要回傳 false。透過在每個節點中設置 `isEnd` 旗標，並在 `insert` 時將最後一個節點的 `isEnd` 設為 `true`，就能區分單詞的結尾
4. **三種操作的基礎都是節點的走訪**：`insert`、`search`、`startsWith` 都從根節點開始，逐字元走訪並轉移節點。`insert` 在轉移目標不存在時建立新節點。`search` 和 `startsWith` 在轉移目標不存在時立即回傳 false
5. **search 和 startsWith 的差異僅在於是否檢查 isEnd**：`search` 在走訪完所有字元後，確認 `node.isEnd` 是否為 true。`startsWith` 在走訪完所有字元後直接回傳 true。走訪的邏輯完全相同，只有最後的判定不同
6. **根節點是一個虛擬節點**：作為 Trie 起點的根節點，初始化為一個不含字元的空節點。所有操作都從這個根節點開始走訪

## 前提知識

### 什麼是 Trie（字典樹）

Trie 是一種用於高效儲存和搜尋字串的樹狀結構。每個節點對應一個字元，從根節點到葉節點的路徑表示一個字串。擁有共同前綴的字串會共享節點，因此 Trie 是一種擅長前綴搜尋的資料結構。

```
範例：插入 "app"、"apple"、"bat" 後的樹狀結構

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

* 表示 isEnd = true 的節點（單詞的結尾）
```

### 什麼是 HashMap

HashMap 是一種儲存鍵值對的資料結構。透過指定鍵，能以 O(1) 的時間複雜度搜尋和取得值。在 Trie 中，HashMap 用於管理每個節點的子節點。

```java
HashMap<Character, TrieNode> children = new HashMap<>();  // 建立空的 HashMap
children.put('a', new TrieNode());      // 將新節點儲存到鍵 'a'
children.containsKey('a');              // 以 boolean 回傳鍵 'a' 是否存在 → true
children.get('a');                      // 回傳鍵 'a' 對應的節點
children.putIfAbsent('a', new TrieNode());  // 僅在鍵 'a' 尚未註冊時才儲存
```

### 什麼是 putIfAbsent

putIfAbsent 是 HashMap 的方法，僅在指定的鍵尚不存在時才儲存值。如果鍵已存在，則不執行任何操作。在 `insert` 操作中，putIfAbsent 用於在不破壞既有路徑的情況下僅新增新節點。

```java
map.putIfAbsent('a', new TrieNode());  // 若 'a' 尚未註冊，則註冊新節點
map.putIfAbsent('a', new TrieNode());  // 'a' 已註冊，因此不執行任何操作
```

## 計算量

| | 值 |
|---|---|
| Time | O(m) — insert、search、startsWith 中的任何一個操作都只走訪一次，與字串長度 m 成正比 |
| Space | O(n * m) — 儲存 n 個單詞（平均長度為 m）。由於共同前綴會共享節點，實際使用量會少於此值 |

## 程式碼

```java
// 輸入：insert(word) 接收字串 word，search(word) 接收字串 word，startsWith(prefix) 接收字串 prefix
// 輸出：insert 無回傳值（將單詞新增到 Trie），search 以 boolean 回傳是否存在完全匹配的單詞，startsWith 以 boolean 回傳是否存在匹配前綴的單詞

// TrieNode 類別：表示 Trie 的每個節點
class TrieNode {
    // 子節點的映射。鍵=字元，值=對應的子節點
    Map<Character, TrieNode> children;
    // 表示單詞是否在此節點結束的旗標（初始值為 false）
    // 有了此旗標，search 就能區分完全匹配和前綴匹配
    boolean isEnd;

    TrieNode() {
        children = new HashMap<>();
        isEnd = false;
    }
}

class Trie {
    // 所有操作的起點——根節點（不含字元的空虛擬節點）
    private TrieNode root;

    // 在建構子中建立一個空的 TrieNode 作為根節點
    public Trie() {
        root = new TrieNode();
    }

    public void insert(String word) {
        // node 是表示當前走訪位置的指標。從根節點開始走訪
        TrieNode node = root;
        // 從字串 word 的開頭逐字元走訪
        for (char c : word.toCharArray()) {
            // 使用 putIfAbsent，若子節點不存在則新建，若已存在則不執行任何操作
            // 使用 putIfAbsent 可以避免覆蓋既有路徑（其他單詞共享的節點）
            node.children.putIfAbsent(c, new TrieNode());
            // 將指標移動到字元 c 對應的子節點
            node = node.children.get(c);
        }
        // 在最後一個節點設定單詞結尾旗標
        // 透過此旗標，search 能夠區分「apple」已插入而「app」未插入的情況
        node.isEnd = true;
    }

    public boolean search(String word) {
        // 從根節點開始走訪
        TrieNode node = root;
        // 從字串 word 的開頭逐字元走訪
        for (char c : word.toCharArray()) {
            // 若對應的子節點不存在，表示 Trie 中沒有此字元對應的路徑，立即回傳 false
            if (!node.children.containsKey(c))
                return false;
            // 將指標移動到子節點
            node = node.children.get(c);
        }
        // 若走訪完所有字元後到達的節點是單詞的結尾則回傳 true，否則回傳 false
        // 因此，當「apple」已插入而「app」未插入時，search("app") 能正確回傳 false
        return node.isEnd;
    }

    public boolean startsWith(String prefix) {
        // 從根節點開始走訪
        TrieNode node = root;
        // 從字串 prefix 的開頭逐字元走訪
        for (char c : prefix.toCharArray()) {
            // 若對應的子節點不存在，表示 Trie 中沒有此前綴對應的路徑，立即回傳 false
            if (!node.children.containsKey(c))
                return false;
            // 將指標移動到子節點
            node = node.children.get(c);
        }
        // 所有字元都能走訪完成，表示 Trie 中存在以此前綴開頭的單詞
        // 與 search 的差異僅在於不檢查 isEnd
        return true;
    }
}
```
