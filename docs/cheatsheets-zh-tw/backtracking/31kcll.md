# Mapping Phone Number Digits to Letter Combinations — 將電話號碼的數字映射為所有字母組合

## 問題的本質

給定一個由數字 2～9 組成的字串 `digits`。每個數字對應電話鍵盤上的字母（例如：2→"abc"、3→"def"）。從 `digits` 的每個數字中各選一個字母依序排列，將所有可能的**字母組合**以列表形式返回。

## 核心思路

每個數字位置可選擇的字母有 3～4 個，需要列舉所有組合。逐一選擇字母並追加到末尾，當所有位數的字母都選完後將結果記錄下來，然後撤銷上一次的選擇並嘗試其他字母——透過這種「回溯法」，可以不遺漏地探索所有模式。

## 思考過程

1. **每個數字位置都有選項**：每個數字對應 3～4 個字母，在每個位置選擇一個字母。所有位置的選擇組合就是答案，因此需要系統性地列舉所有模式
2. **使用遞迴逐位處理**：從第一個數字開始依序選擇一個字母，將下一個數字的處理交給遞迴呼叫。這樣每層遞迴的深度對應一個數字位置，使結構更加簡潔
3. **終止條件是處理完所有位數**：當遞迴深度達到 `digits` 的長度時，當前正在構建的字串就是一個完整的組合。將其添加到結果列表中
4. **透過回溯嘗試其他選項**：從遞迴返回後，從 `StringBuilder` 的末尾刪除上一次追加的字母。這樣就為嘗試同一位置的其他字母做好了準備
5. **使用映射陣列將數字轉換為字母**：準備一個索引 0～9 的字串陣列，透過 `digits.charAt(idx) - '0'` 將數字轉換為整數並以索引存取，即可以 O(1) 的時間取得對應的字母群
6. **處理空字串輸入**：當 `digits` 為空時不存在任何組合，直接返回空列表

## 前置知識

### 什麼是回溯法

回溯法是一種逐步構建候選解，完成後記錄結果，然後撤銷上一次的選擇並嘗試其他選項的探索方法。用於列舉所有組合與排列的問題。透過遞迴實現「選擇→前進→還原→嘗試其他」的循環。

```java
// 回溯法的基本模式
void backtrack(狀態, 結果列表) {
    if (終止條件) {
        結果列表.add(當前狀態);
        return;
    }
    for (選項 : 當前選項列表) {
        將選項添加到狀態;       // 選擇
        backtrack(下一個狀態, 結果列表); // 前進
        從狀態中移除選項;     // 還原（回溯）
    }
}
```

### 什麼是 StringBuilder

StringBuilder 是一個用於高效組合字串的類別。`String` 是不可變的（每次修改都會建立新的物件），而 `StringBuilder` 直接修改內部緩衝區，因此字元的追加與刪除可以在 O(1) 時間內完成。適合在回溯法中組合字串時使用。

```java
StringBuilder sb = new StringBuilder();  // 建立空的 StringBuilder
sb.append('a');           // 在末尾追加字元 'a' → "a"
sb.append('b');           // 在末尾追加字元 'b' → "ab"
sb.deleteCharAt(sb.length() - 1);  // 刪除末尾的字元 → "a"
sb.toString();            // 轉換為 String 型別並返回 → "a"
```

### 電話鍵盤的映射

使用陣列表示數字與字母的對應關係。陣列的索引對應數字，值為該數字所分配的字母群。

```java
String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};
// phone[2] → "abc",  phone[7] → "pqrs",  phone[9] → "wxyz"
// 將字元 '3' 轉換為整數 3：'3' - '0' → 3
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(4^n) — 每個數字最多有 4 個字母選項，列舉 n 位數的所有組合 |
| Space | O(n) — 遞迴深度最大為 n，StringBuilder 的長度也最大為 n（不含結果列表） |

## 程式碼

```java
// 輸入：由數字 2～9 組成的字串 digits
// 輸出：返回包含所有字母組合的 List<String>

// 透過回溯法逐位選擇字母，列舉所有組合
void backtrack(String digits, String[] phone, int idx, StringBuilder path, List<String> result) {
    // 終止條件：當 idx 等於 digits 的長度時，表示所有位數的字母都已選完
    // 將 StringBuilder 的內容轉換為 String 並添加到結果中
    if (idx == digits.length()) {
        result.add(path.toString());
        return;
    }

    // 透過 digits.charAt(idx) - '0' 將字元數字轉換為整數，從 phone 陣列中取得對應的字母群
    String letters = phone[digits.charAt(idx) - '0'];

    // 逐一嘗試當前數字對應的每個字母
    for (char c : letters.toCharArray()) {
        path.append(c);                            // 選擇：選定字母並追加到末尾
        backtrack(digits, phone, idx + 1, path, result);  // 遞迴：前進到下一位數的處理
        path.deleteCharAt(path.length() - 1);      // 還原：刪除末尾的字母恢復原狀（回溯）
    }
}

List<String> letterCombinations(String digits) {
    // 建立用於儲存結果的空列表
    List<String> result = new ArrayList<>();

    // 如果輸入為空字串，則不存在任何組合，返回空列表
    if (digits.isEmpty()) return result;

    // 定義索引對應數字的映射陣列
    // 索引 0 和 1 在電話鍵盤上沒有分配字母，因此設為空字串
    String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    // 從位置 0 開始，以空的 StringBuilder 啟動回溯
    backtrack(digits, phone, 0, new StringBuilder(), result);

    // 所有遞迴完成後，返回包含所有組合的 result
    return result;
}
```
