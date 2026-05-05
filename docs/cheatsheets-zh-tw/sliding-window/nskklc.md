# Finding the Smallest Window Containing All Characters — 尋找包含所有字元的最小子字串

## 問題的本質

給定兩個字串 `s` 和 `t`。從 `s` 中找出包含 `t` 的所有字元（包括重複字元）的**最短子字串**並返回。如果不存在這樣的子字串，則返回空字串。

## 核心思路

向右擴展右指標來建立滿足條件的窗口，再收縮左指標來最小化窗口。透過一個變數管理「已滿足條件的字元種類數」，可以在 O(1) 時間內判定窗口的有效性。

## 思考過程

1. **預先計算所需字元的出現次數**: 將 `t` 中每個字元的出現次數記錄到 HashMap 中。這就是窗口必須滿足的條件。例如 `t = "ABC"` 時，記錄為 `{A:1, B:1, C:1}`
2. **向右擴展窗口以滿足條件**: 將右指標 `r` 逐步向右移動，將字元加入窗口，並用另一個 HashMap 管理窗口內字元的出現次數。每當窗口內某個字元的出現次數達到所需數量時，將計數器 `have` 遞增
3. **在 O(1) 時間內判定條件是否滿足**: 將 `need` 的大小（所需字元種類數）設為 `required`，當 `have == required` 成立時，窗口便包含了 `t` 的所有字元。透過以字元種類為單位進行管理，無需每次比較所有字元
4. **從左側收縮窗口以最小化**: 在 `have == required` 的期間，將左指標 `left` 向右移動以縮小窗口。每次縮小時將窗口長度與當前最小值進行比較，若更短則更新結果
5. **移除左端字元時的處理**: 將左端字元 `s.charAt(left)` 從窗口中移除時，如果該字元存在於 `need` 中且窗口內的出現次數低於所需數量，則將 `have` 遞減。這會導致 `while` 迴圈結束，回到右指標的擴展操作
6. **最終返回的結果**: 遍歷結束後，如果找到了最小窗口，則返回 `s.substring(resStart, resStart + resLen)`。如果未找到，則返回空字串

## 前置知識

### 什麼是 HashMap

HashMap 是一種儲存鍵值對的資料結構。可以透過指定鍵在 O(1) 時間內搜尋和取得值。在本問題中用於管理字元的出現次數。

```java
HashMap<Character, Integer> map = new HashMap<>();  // 建立空的 HashMap
map.put('A', 1);                    // 將值 1 儲存到鍵 'A'
map.getOrDefault('A', 0);           // 返回鍵 'A' 的值。若不存在則返回 0 → 1
map.containsKey('A');               // 以 boolean 返回鍵 'A' 是否存在 → true
map.get('A').equals(map.get('B'));  // Integer 物件之間的比較需使用 equals
```

### 什麼是 Sliding Window（滑動窗口）

滑動窗口是一種在陣列或字串上，使用兩個指標 `left` 和 `right` 管理連續範圍（窗口）的技巧。透過右指標擴展窗口、左指標收縮窗口，可以將檢查所有子字串的 O(n²) 處理優化為 O(n)。

```java
int left = 0;
for (int r = 0; r < s.length(); r++) {
    // 透過右指標擴展窗口的處理
    while (條件已滿足) {
        // 透過左指標收縮窗口的處理
        left++;
    }
}
```

### 什麼是 have / required 模式

這是一種在 O(1) 時間內判定窗口是否滿足條件的技巧。`required` 表示需要滿足的字元種類總數，`have` 表示目前已達到所需數量的字元種類數。當 `have == required` 時，窗口滿足所有條件。

```java
int required = need.size();  // 所需字元種類數（例: need={A:1,B:1,C:1} → 3）
int have = 0;                // 已滿足條件的字元種類數（初始值為 0）
// 當窗口內 'A' 的數量達到 need 中 'A' 的數量時 have++ → have==required 時所有條件皆滿足
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 右指標和左指標各自最多遍歷 `s` 一次 |
| Space | O(n) — HashMap `need` 和 `window` 最多儲存 `s` 和 `t` 的字元種類數量的元素 |

## 程式碼

```java
// 輸入: 字串 s 和字串 t
// 輸出: 以 String 返回 s 中包含 t 所有字元的最短子字串。若不存在則返回空字串
String minWindow(String s, String t) {
    // 若 s 比 t 短，則不可能存在包含所有字元的窗口
    if (s.length() < t.length())
        return "";

    // 記錄 t 中每個字元所需出現次數的 HashMap。這定義了窗口必須滿足的條件
    Map<Character, Integer> need = new HashMap<>();
    for (char c : t.toCharArray()) {
        need.put(c, need.getOrDefault(c, 0) + 1);
    }

    // 管理窗口內每個字元出現次數的 HashMap
    Map<Character, Integer> window = new HashMap<>();
    int have = 0;              // 已滿足條件的字元種類數
    int required = need.size(); // 需要滿足的字元種類總數（need 的鍵的數量）
    int resLen = Integer.MAX_VALUE; // 最小窗口的長度（表示尚未找到的初始值）
    int resStart = 0;          // 最小窗口的起始位置
    int left = 0;              // 左指標

    // 透過右指標向右擴展窗口
    for (int r = 0; r < s.length(); r++) {
        char c = s.charAt(r);
        // 將窗口內字元 c 的出現次數加 1（窗口向右擴展了一個字元）
        window.put(c, window.getOrDefault(c, 0) + 1);

        // 若字元 c 是 t 中所需的字元，且窗口內的出現次數恰好達到所需數量，則將 have 遞增
        // 注意: Integer 物件的比較需使用 equals 而非 ==
        if (need.containsKey(c)
            && window.get(c).equals(need.get(c))) {
            have++;
        }

        // 在窗口滿足所有條件的期間（have == required），從左側收縮以最小化窗口
        while (have == required) {
            int wLen = r - left + 1;
            // 若找到更短的窗口，則更新結果
            if (wLen < resLen) {
                resLen = wLen;
                resStart = left;
            }
            // 將左端字元從窗口中移除
            char lc = s.charAt(left);
            window.put(lc, window.get(lc) - 1);
            // 若移除後窗口內的出現次數低於所需數量，表示條件不再滿足，將 have 遞減
            if (need.containsKey(lc)
                && window.get(lc) < need.get(lc)) {
                have--;
            }
            // 將左指標向右移動以收縮窗口
            left++;
        }
    }

    // 若 resLen 仍為初始值，表示未找到滿足條件的窗口，返回空字串
    if (resLen == Integer.MAX_VALUE)
        return "";
    // 從最小窗口的起始位置擷取最小窗口長度的子字串並返回
    return s.substring(resStart, resStart + resLen);
}
```
