# Finding the Longest Palindromic Substring — 在字串中找出最長的回文子字串

## 問題的本質

給定一個字串 `s`。從 `s` 中找出從前往後讀和從後往前讀都相同的**最長子字串（回文）**並返回。如果存在多個相同長度的回文，返回其中任意一個即可。

## 核心思路

回文必定擁有一個「中心」。以字串的每個位置作為中心向左右展開，只要字元匹配就持續擴展回文，這樣就能不遺漏地發現所有回文。中心需要嘗試「1個字元（奇數長度）」和「相鄰2個字元之間（偶數長度）」這兩種類型。

## 思考過程

1. **回文具有從中心對稱展開的結構**: 回文 `"racecar"` 從中心的 `e` 向左右對稱地展開為 `c→a→r`。利用這個性質，可以固定中心並向左右展開來檢測回文
2. **中心的候選有兩種類型**: 奇數長度的回文（例如: `"aba"`）以1個字元為中心，偶數長度的回文（例如: `"abba"`）以相鄰2個字元之間為中心。要不遺漏地檢測所有回文，需要嘗試這兩種中心
3. **確定展開的步驟**: 從中心放置左右指標 `left` 和 `right`，只要 `s.charAt(left) == s.charAt(right)` 成立，就將 `left` 向左、`right` 向右各移動一步。當字元不匹配或到達字串邊界時，結束展開
4. **從展開結果求出回文的長度**: 展開結束時，`left` 和 `right` 各超出回文範圍一個位置。因此，回文的長度可以用 `right - left - 1` 來計算
5. **記錄最長回文的起始和結束位置**: 當從各中心得到的回文長度超過目前的最長值時，更新起始位置 `start` 和結束位置 `end`。可以根據中心位置 `i` 和回文長度 `len`，用 `start = i - (len - 1) / 2`、`end = i + len / 2` 來計算
6. **最終返回子字串**: 嘗試完所有中心後，用 `s.substring(start, end + 1)` 擷取最長回文子字串並返回

## 前置知識

### 回文（Palindrome）

回文是指從前往後讀和從後往前讀都相同的字串。`"aba"`、`"abba"`、`"racecar"` 都是回文。單個字元的字串也是回文。

### 中心展開法（Expand Around Center）

中心展開法是固定回文的中心，逐步向左右各擴展一個字元來判定是否為回文的手法。由於是從中心向外側比較字元，因此能高效地檢測回文。

```java
// left=right 時檢測奇數長度的回文（1個字元中心）
// left=i, right=i+1 時檢測偶數長度的回文（2個字元中心）
expand(s, 2, 2);    // 以索引2為中心尋找奇數長度的回文
expand(s, 2, 3);    // 以索引2和3之間為中心尋找偶數長度的回文
```

### String.substring(int, int)

從字串中擷取子字串的方法。第1個參數是起始索引（包含），第2個參數是結束索引（不包含）。

```java
String s = "babad";
s.substring(0, 3);   // 返回 "bab"（索引0、1、2的字元）
s.substring(1, 4);   // 返回 "aba"（索引1、2、3的字元）
```

### String.charAt(int)

返回字串中指定索引處的字元的方法。

```java
String s = "babad";
s.charAt(0);   // 返回 'b'
s.charAt(2);   // 返回 'b'
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n²) — 以每個索引為中心進行最多 O(n) 的展開，共有 n 個中心 |
| Space | O(1) — 僅使用記錄指標和長度的變數，不需要額外的資料結構 |

## 程式碼

```java
// 輸入: 字串 s
// 輸出: 以 String 形式返回 s 中最長的回文子字串

// 從中心向左右展開，返回回文長度的輔助方法
private int expand(String s, int left, int right) {
    // 只要左右字元匹配且在字串範圍內，就持續展開
    while (left >= 0
            && right < s.length()
            && s.charAt(left)
            == s.charAt(right)) {
        left--;  // 向左擴展一步
        right++; // 向右擴展一步
    }
    // 展開結束時，left 和 right 各超出回文範圍一個位置
    // 因此回文的長度為 right - left - 1
    return right - left - 1;
}

public String longestPalindrome(String s) {
    // 記錄最長回文的起始和結束索引的變數
    // 初始值0對應的是至少第1個字元本身就是長度為1的回文
    int start = 0, end = 0;

    // 將每個索引 i 作為回文的中心候選進行掃描
    for (int i = 0; i < s.length(); i++) {
        // 展開奇數長度的回文（1個字元中心）並取得長度
        int odd = expand(s, i, i);
        // 展開偶數長度的回文（2個字元中心）並取得長度
        int even = expand(s, i, i + 1);
        // 取奇數長度和偶數長度中較大的一方
        int len = Math.max(odd, even);

        // 如果超過目前最長回文的長度 (end - start + 1)，則更新起始和結束位置
        if (len > end - start + 1) {
            // (len - 1) / 2 是從中心到左側的距離
            start = i - (len - 1) / 2;
            // len / 2 是從中心到右側的距離
            end = i + len / 2;
        }
    }
    // substring 的第2個參數是「不包含」的規範，因此指定 end + 1 以包含 end 位置的字元
    return s.substring(start, end + 1);
}
```
