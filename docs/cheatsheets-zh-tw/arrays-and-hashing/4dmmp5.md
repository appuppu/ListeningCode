# Validating a Sudoku Board — 判定 9×9 的 Sudoku 棋盤是否有效

## 問題的本質

給定一個以 9×9 二維字元陣列表示的 Sudoku 棋盤。若每一行、每一列、每個 3×3 的子網格中都不包含重複的數字，則判定該棋盤有效並回傳 `true`。空格以點號 `.` 表示。棋盤不需要已完成填寫，只需確認目前的配置是否違反規則。

## 核心思路

在一次遍歷整個棋盤的過程中，檢查每個格子的數字是否已經在「該行」「該列」「該 3×3 方格」中出現過，若是則判定為無效。任意格子 `(i, j)` 所屬的方格索引可透過公式 `(i/3) * 3 + j/3` 唯一對應到 0〜8。

## 思考過程

1. **整理需要驗證的條件**：Sudoku 的有效性由「每行無重複」「每列無重複」「每個 3×3 方格無重複」三個條件決定。若能同時驗證這三個條件，效率最高
2. **HashSet 適合用於偵測重複**：要以 O(1) 判斷某個數字是否已出現過，HashSet 最為合適。為每行準備 9 個、每列準備 9 個、每個方格準備 9 個，共 27 個 HashSet，即可同時檢查三個條件
3. **需要將格子對應到方格**：需要計算格子 `(i, j)` 屬於哪個方格。行方向以 `i/3`（整數除法）分為 0、1、2 三組，列方向以 `j/3` 分為 0、1、2 三組。將其轉換為一維索引的公式為 `(i/3) * 3 + j/3`，這樣 9 個方格便對應到 0〜8 的編號
4. **在一次遍歷中驗證所有條件**：使用雙重 for 迴圈遍歷整個棋盤，對每個格子分別在行、列、方格的三個 Set 中進行重複檢查與登錄。點號不是數字，因此跳過
5. **發現重複時立即回傳 false**：只要三個 Set 中任一個已包含相同數字，該棋盤即為無效，立即回傳 `false`
6. **遍歷完所有格子後回傳 true**：若從未發現重複，則該棋盤有效

## 前提知識

### 什麼是 HashSet

HashSet 是一種管理不重複元素集合的資料結構。新增元素與確認元素是否存在的操作皆為 O(1)。本題中用於快速判斷某個數字是否已經出現過。

```java
Set<Character> set = new HashSet<>();  // 建立空的 HashSet
set.add('5');            // 新增元素 '5'
set.contains('5');       // 檢查元素 '5' 是否存在，回傳 boolean → true
set.contains('3');       // 檢查元素 '3' 是否存在，回傳 boolean → false
```

### 建立 HashSet 陣列的方法

將 9 個 HashSet 以陣列形式統一管理。由於無法直接建立泛型陣列，因此先以 `new HashSet[9]` 建立原始型別的陣列，再透過迴圈逐一初始化每個元素。

```java
Set<Character>[] sets = new HashSet[9];  // 配置 9 個元素的陣列
for (int i = 0; i < 9; i++) {
    sets[i] = new HashSet<>();           // 將每個元素初始化為空的 HashSet
}
```

### 方格索引的計算公式

`boxIdx = (i/3) * 3 + j/3` 回傳格子 `(i, j)` 所屬的 3×3 方格編號（0〜8）。`i/3` 表示行方向的方格位置（0、1、2），`j/3` 表示列方向的方格位置（0、1、2）。將行方向的位置乘以 3 再加上列方向的位置，即可為 9 個方格指定唯一的編號。

```
方格編號的配置：
0 | 1 | 2
3 | 4 | 5
6 | 7 | 8

例：格子(4, 7) → (4/3)*3 + 7/3 = 1*3 + 2 = 5 → 屬於方格 5
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n²) — 遍歷整個 9×9 棋盤一次（n=9 為固定值，因此也可視為 O(81)=O(1)） |
| Space | O(n²) — 在 27 個 HashSet 中最多儲存 81 個元素 |

## 程式碼

```java
// 輸入：9×9 的二維字元陣列 board（數字 '1'〜'9' 或點號 '.'）
// 輸出：若棋盤有效則回傳 true，無效則回傳 false
public boolean isValidSudoku(char[][] board) {
    // 建立用於記錄每行、每列、每個方格中已出現數字的 HashSet 陣列
    // rowset[i] 記錄第 i 行、columnset[j] 記錄第 j 列、boxset[k] 記錄第 k 個方格中已出現的數字
    Set<Character>[] rowset = createSets();
    Set<Character>[] columnset = createSets();
    Set<Character>[] boxset = createSets();

    // 外層迴圈遍歷行，內層迴圈遍歷列，逐一訪問全部 81 個格子
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            // 取得目前格子的值
            char c = board[i][j];
            // 點號為空格（非數字），因此跳過
            if (c == '.') {
                continue;
            }

            // 計算格子 (i, j) 所屬的方格編號（唯一對應 0〜8）
            int boxIdx = (i / 3) * 3 + j / 3;

            // 若行、列、方格中任一個已包含相同數字，則為重複，立即回傳 false
            if (rowset[i].contains(c) || columnset[j].contains(c) || boxset[boxIdx].contains(c)) {
                return false;
            }

            // 若無重複，則將目前的數字登錄到三個 Set 中，以供後續的重複偵測使用
            rowset[i].add(c);
            columnset[j].add(c);
            boxset[boxIdx].add(c);
        }
    }
    // 遍歷完所有格子且從未發現重複，則該棋盤有效
    return true;
}

// 建立包含 9 個空 HashSet 的陣列的輔助方法
public Set<Character>[] createSets() {
    Set<Character>[] sets = new HashSet[9];
    for (int i = 0; i < 9; i++) {
        sets[i] = new HashSet<>();
    }
    return sets;
}
```
