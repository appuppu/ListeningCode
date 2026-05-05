# Checking if a String is a Palindrome — 判斷字串是否為回文

## 問題的本質

給定一個字串 `s`。僅針對英數字元，忽略大小寫的差異，判斷該字串是否為回文（從前往後讀和從後往前讀都相同）。如果是回文則回傳 `true`，否則回傳 `false`。

## 核心概念

從字串的兩端各放置一個指標向內側推進，跳過非英數字元並逐一比較字元，這樣就能在不產生額外字串的情況下，以 O(1) 的空間完成回文判斷。

## 思考過程

1. **確認回文的定義**: 回文是指從前往後讀和從後往前讀都相同的字串。也就是說，首尾的字元相同，且其內側的字元也同樣相同，則該字串為回文
2. **從兩端進行比較即可在一次掃描中完成判斷**: 在開頭放置指標 `left`，在末尾放置指標 `right`，兩者向內側推進並比較，只需遍歷每個字元一次即可完成判斷
3. **需要跳過非英數字元**: 由於問題僅針對英數字元，因此當指標指向非英數字元時，需要跳過並前進到下一個位置。可以使用 `Character.isLetterOrDigit` 來判斷字元是否為英數字元
4. **統一大小寫後再進行比較**: 由於問題不區分大小寫，因此在比較前使用 `Character.toLowerCase` 將兩個字元都轉換為小寫，然後再確認是否相同
5. **發現不一致時立即回傳 `false`**: 只要有一處不同就不是回文，因此可以提前回傳
6. **指標交叉前都沒有不一致則為回文**: 迴圈正常結束表示所有對應的字元都相同，因此回傳 `true`

## 前置知識

### Two Pointers（雙指標法）是什麼

在陣列或字串的兩端放置指標，根據條件向內側移動的技巧。適用於利用對稱性的問題（回文判斷、配對搜尋等）。由於只需一次掃描即可解決問題，因此可以實現時間 O(n)、空間 O(1)。

```java
int left = 0;                    // 指向開頭的指標
int right = s.length() - 1;     // 指向末尾的指標
// 持續迴圈直到 left 和 right 交叉為止
while (left < right) {
    // 執行比較或處理
    left++;    // 將左指標向右推進
    right--;   // 將右指標向左推進
}
```

### Character.isLetterOrDigit 是什麼

判斷字元是否為英文字母（a-z, A-Z）或數字（0-9）的方法。用於排除空格或符號等非英數字元。

```java
Character.isLetterOrDigit('A');   // true（英文字母）
Character.isLetterOrDigit('3');   // true（數字）
Character.isLetterOrDigit(' ');   // false（空格）
Character.isLetterOrDigit(',');   // false（符號）
```

### Character.toLowerCase 是什麼

將英文字母轉換為小寫的方法。用於不區分大小寫進行比較的情況。如果已經是小寫或數字，則直接回傳原值。

```java
Character.toLowerCase('A');   // 'a'
Character.toLowerCase('a');   // 'a'（無變化）
Character.toLowerCase('3');   // '3'（數字維持不變）
```

## 複雜度

| | 值 |
|---|---|
| Time | O(n) — 每個指標最多掃描字串一次 |
| Space | O(1) — 僅使用兩個指標，不使用額外的字串或資料結構 |

## 程式碼

```java
// 輸入: 字串 s
// 輸出: 若 s 為回文則回傳 true，否則回傳 false
public boolean isPalindrome(String s) {
    // 在開頭和末尾放置指標。這兩個指標從字串的兩端向內側推進
    int left = 0;
    int right = s.length() - 1;

    // 重複執行直到兩個指標交叉為止。交叉表示所有比較已完成
    while (left < right) {
        // 若 left 指向的字元不是英數字元，則向右跳過
        // 注意: 跳過過程中也要維持 left < right 的條件，防止指標交叉
        while (left < right && !Character.isLetterOrDigit(s.charAt(left))) {
            left++;
        }
        // 若 right 指向的字元不是英數字元，則向左跳過。同樣維持 left < right 的條件
        while (left < right && !Character.isLetterOrDigit(s.charAt(right))) {
            right--;
        }
        // 將兩個字元都轉換為小寫後再比較，以忽略大小寫的差異
        // 若不一致則不是回文。只要有一處不同就不滿足回文條件，因此立即回傳
        if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right))) {
            return false;
        }
        // 兩個字元相同，因此將兩個指標向內側推進，移至下一對字元的比較
        left++;
        right--;
    }
    // 迴圈正常結束（所有對應的字元對都相同），因此為回文
    return true;
}
```
