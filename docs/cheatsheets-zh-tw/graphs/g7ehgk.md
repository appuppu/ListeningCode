# Finding the Shortest Word Transformation Sequence — 求最短單詞變換序列的長度

## 問題的本質

給定起始單詞 `beginWord`、目標單詞 `endWord`、以及有效單詞的字典 `wordList`。從起始單詞到目標單詞，**每一步只能更改一個字母**，且所有中間單詞都必須存在於字典中，求這樣的變換序列的**最短長度**。若變換序列不存在，則返回0。

## 核心思路

若將單詞之間的一個字母變換視為圖的邊，則最短變換序列就變成了最短路徑問題。從起點和終點同時執行 BFS，並始終擴展較小的前沿集合，就能大幅縮減搜索空間。

## 思考過程

1. **將問題建模為圖**：將每個單詞視為節點，將只差一個字母的單詞之間連接一條邊，構成一個圖。最短變換序列的長度等於該圖上從 beginWord 到 endWord 的最短路徑長度
2. **使用 BFS 求最短路徑**：由於這是無權圖的最短路徑問題，BFS（廣度優先搜索）是最適合的演算法。每一層對應一次變換步驟
3. **單向 BFS 的低效性**：若只從起點執行 BFS，每一層的候選單詞數量會呈指數增長。搜索空間會隨著深度的增加而爆炸式膨脹
4. **使用雙向 BFS 縮減搜索空間**：從起點和終點同時進行 BFS，當兩方相遇時即找到最短路徑。由於每一方的搜索深度只需 d/2，搜索空間得以大幅縮減
5. **優先擴展較小的前沿集合**：每一步比較起點側和終點側的前沿集合（當前層的單詞集合）大小，擴展較小的一方。這樣可以始終抑制前沿集合的膨脹
6. **鄰接單詞的生成方法**：不逐一與字典中的所有單詞進行比較，而是對單詞的每個位置嘗試 a～z 共26個字母來生成鄰接單詞。當單詞長度 m 遠小於字典大小 n 時，這種方法更為高效
7. **判斷是否與對方前沿集合匯合**：若生成的鄰接單詞存在於對方的前沿集合中，則表示雙方的搜索已匯合，此時返回當前層數+1

## 前置知識

### 什麼是 BFS（廣度優先搜索）

BFS 是一種從圖的起點開始，按照由近及遠的順序逐層探索節點的演算法。由於每一層的距離遞增1，因此首次到達某節點時的距離即為最短距離。BFS 用於解決無權圖的最短路徑問題。

### 什麼是 HashSet

HashSet 是一種用於保存元素集合的資料結構。元素的添加、查詢和刪除操作的時間複雜度均為 O(1)。HashSet 會自動排除重複元素。

```java
Set<String> set = new HashSet<>();   // 建立空的 HashSet
set.add("hot");                      // 添加元素
set.contains("hot");                 // 判斷元素是否存在，返回 boolean → true
set.size();                          // 返回元素數量 → 1
```

### 什麼是雙向 BFS

普通的 BFS 只從起點進行搜索，而雙向 BFS 則從起點和終點同時進行搜索。當雙方的前沿集合重疊時，即找到最短路徑。搜索空間從 O(b^d) 縮減為 O(b^(d/2))（其中 b 為分支因子，d 為最短距離）。

### 什麼是 toCharArray / String.valueOf

這是將 String 轉換為字元陣列，以便逐字元操作的方法組合。

```java
char[] ch = "hot".toCharArray();     // 將 String 轉換為 char[] → ['h','o','t']
ch[0] = 'b';                        // 直接替換一個字元 → ['b','o','t']
String next = String.valueOf(ch);    // 將 char[] 轉回 String → "bot"
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n × m) — n 為字典中的單詞數量，m 為單詞的長度。對每個單詞的每個位置嘗試26個字母 |
| Space | O(n × m) — 已訪問集合和前沿集合最多儲存 n 個單詞（每個長度為 m） |

## 程式碼

```java
// 輸入：起始單詞 beginWord、目標單詞 endWord、有效單詞的字典 wordList
// 輸出：返回最短變換序列的長度（int）。若變換序列不存在，則返回0
int ladderLength(String beginWord, String endWord, List<String> wordList) {
    // 將字典轉換為 HashSet，使單詞存在性判斷的時間複雜度為 O(1)
    Set<String> wordSet = new HashSet<>(wordList);
    // 若 endWord 不在字典中，則無法構成變換序列，返回0
    if (!wordSet.contains(endWord)) return 0;

    // 建立起點側前沿集合、終點側前沿集合、已訪問集合這三個 HashSet
    Set<String> start = new HashSet<>();
    Set<String> end = new HashSet<>();
    Set<String> visited = new HashSet<>();
    start.add(beginWord);
    end.add(endWord);
    // 將兩個前沿集合中的單詞預先標記為已訪問
    visited.add(beginWord);
    visited.add(endWord);
    // level 表示變換序列的長度（起點本身計為1）
    int level = 1;

    // 當任一前沿集合為空時，表示無法到達，跳出迴圈
    while (!start.isEmpty() && !end.isEmpty()) {
        // 始終擴展較小的前沿集合，以抑制搜索空間的膨脹
        if (start.size() > end.size()) {
            Set<String> temp = start;
            start = end;
            end = temp;
        }

        // 用於保存下一層候選單詞的集合
        Set<String> nextLevel = new HashSet<>();

        for (String word : start) {
            // 將單詞轉換為 char[]，逐個位置替換字元以生成鄰接單詞
            char[] ch = word.toCharArray();
            for (int j = 0; j < ch.length; j++) {
                // 保存原始字元，以便搜索後恢復
                char orig = ch[j];
                // 對每個位置嘗試 a～z 共26個字母以生成鄰接單詞
                for (char c = 'a'; c <= 'z'; c++) {
                    ch[j] = c;
                    String next = String.valueOf(ch);
                    // 若該單詞存在於對方的前沿集合中，則雙方搜索已匯合
                    if (end.contains(next)) return level + 1;
                    // 若該單詞在字典中且未被訪問過，則將其加入下一層前沿集合
                    // 將其加入 visited 以防止重複訪問同一單詞
                    if (wordSet.contains(next) && !visited.contains(next)) {
                        nextLevel.add(next);
                        visited.add(next);
                    }
                }
                // 恢復原始字元，為下一個位置的搜索做準備
                ch[j] = orig;
            }
        }
        // 將前沿集合替換為下一層，level 加1後進入下一次迭代
        start = nextLevel;
        level++;
    }
    // 若任一前沿集合為空，則變換序列不存在
    return 0;
}
```
