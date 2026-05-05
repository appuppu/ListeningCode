# Determining if a String Can Be Segmented Into Dictionary Words — 判斷字串是否能被分割為字典中的單字

## 問題的本質

給定一個字串 `s` 和一個字典單字列表 `wordDict`。判斷 `s` 是否能被分割為字典中單字的連接，並以 **boolean** 回傳結果。字典中的每個單字可以重複使用任意次數。

## 核心思路

從字串的開頭開始，針對每個位置 `i` 記錄「到該位置為止的子字串是否可分割」，這樣位置 `i` 的判斷就可以歸結為：「是否存在某個分割點 `j`，使得前 `j` 個字元可分割」且「從 `j` 到 `i` 的子字串存在於字典中」。

## 思考過程

1. **可以分解為子問題**：要判斷字串 `s` 的前 `i` 個字元是否可分割，只需在某個位置 `j` 將其分成兩部分，確認「前 `j` 個字元可分割」且「從 `j` 到 `i` 的部分是字典中的單字」即可。這種結構適合使用動態規劃
2. **定義 DP 的含義**：將 `dp[i]` 定義為「字串 `s` 的前 `i` 個字元是否能僅用字典中的單字來分割」的 boolean 值。最終 `dp[n]`（`n` 為字串長度）就是答案
3. **設定基底條件**：空字串總是可分割的，因此設定 `dp[0] = true`。有了這個基底條件，才能偵測到從字串開頭開始的字典單字
4. **思考轉移方程式**：`dp[i]` 為 `true` 的條件是，在 `0 ≤ j < i` 的某個 `j` 上，「`dp[j]` 為 `true`」且「`s.substring(j, i)` 存在於字典中」同時成立。嘗試所有的 `j` 即可完成判斷
5. **加速字典查詢**：將單字列表預先轉換為 HashSet，這樣就能用 `contains` 以 O(1) 判斷子字串是否存在於字典中。這比在列表中進行線性搜尋更有效率
6. **透過提前終止減少不必要的計算**：當某個 `j` 確定了 `dp[i] = true` 後，就不需要再嘗試其他的 `j`。使用 `break` 跳出內層迴圈，繼續處理下一個 `i`

## 前置知識

### 什麼是 HashSet

HashSet 是一種不儲存重複元素的資料結構。判斷某個元素是否存在的時間複雜度為 O(1)。用於快速搜尋字典的單字列表。

```java
Set<String> set = new HashSet<>();       // 建立空的 HashSet
set.add("apple");                        // 新增元素
set.contains("apple");                   // 以 boolean 回傳元素是否存在 → true
```

### 透過建構子將 List 轉換為 Set

將 List 傳入 `HashSet` 的建構子，即可將 List 的所有元素轉換為 Set。用於一行將字典轉換為 HashSet。

```java
List<String> list = Arrays.asList("a", "b", "c");
Set<String> set = new HashSet<>(list);   // 將 List 的所有元素轉換為 Set
```

### 什麼是 substring

substring 是擷取字串一部分的方法。`s.substring(j, i)` 會回傳從索引 `j` 到 `i - 1` 的字元。在 DP 的轉移中用於取得「從位置 `j` 到位置 `i` 的子字串」。

```java
String s = "leetcode";
s.substring(0, 4);                       // 回傳 "leet"（索引 0〜3）
s.substring(4, 8);                       // 回傳 "code"（索引 4〜7）
```

### 什麼是 DP 陣列（boolean 陣列）

DP 陣列是在動態規劃中儲存子問題結果的陣列。使用 `boolean[] dp = new boolean[n + 1]` 建立時，所有元素會被初始化為 `false`。透過將 `dp[i]` 設為 `true`，來記錄「前 `i` 個字元可分割」的結果。

```java
boolean[] dp = new boolean[5];           // 以 [false, false, false, false, false] 初始化
dp[0] = true;                           // 設定基底條件
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n^2) — 外層迴圈執行 n 次，內層迴圈最多執行 n 次，若每步生成 substring 需要 O(n)，嚴格來說是 O(n^3)，但平均情況下視為 O(n^2) |
| Space | O(n) — 大小為 n+1 的 DP 陣列，加上 HashSet 中儲存字典的單字 |

## 程式碼

```java
// 輸入：字串 s 和字典的單字列表 wordDict
// 輸出：若 s 能僅用字典中的單字分割則回傳 true，否則回傳 false
public boolean wordBreak(String s, List<String> wordDict) {
    // 將字典的單字列表轉換為 HashSet，使搜尋達到 O(1)
    Set<String> set = new HashSet<>(wordDict);
    // 將字串的長度儲存到變數中
    int n = s.length();

    // dp[i] = 前 i 個字元是否能僅用字典中的單字來分割
    // 大小為 n+1 是因為 dp[n] 代表整個字串的可分割性
    boolean[] dp = new boolean[n + 1];

    // 空字串總是可分割的（基底條件）
    // 若沒有這個設定，就無法偵測到從字串開頭開始的字典單字
    dp[0] = true;

    // 外層迴圈：i 代表「考慮前幾個字元」
    for (int i = 1; i <= n; i++) {
        // 內層迴圈：j 是分割點的候選位置。將字串分為「前 j 個字元」和「從 j 到 i 的子字串」
        for (int j = 0; j < i; j++) {
            // 若前 j 個字元可分割，且從 j 到 i 的部分是字典中的單字，則前 i 個字元可分割
            // 兩個條件同時成立 = 可以分為「可分割的部分 + 字典的單字」
            if (dp[j] && set.contains(s.substring(j, i))) {
                dp[i] = true;
                break;  // 已確認可分割，不需要再嘗試其他的 j
            }
        }
    }

    // dp[n] 代表整個字串 s 是否可分割
    return dp[n];
}
```
