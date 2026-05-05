# Traversing a Matrix in Spiral Order — 取得矩陣所有元素的螺旋順序排列

## 問題的本質

給定一個 m 行 n 列的矩陣 `matrix`。從左上角開始，按照右→下→左→上的順序沿外周描繪，並向內側重複此過程，將所有元素按**螺旋（Spiral）順序**排列後返回陣列。

## 核心思路

將矩陣的外周視為一個「層」，依序走訪上邊、右邊、下邊、左邊這4條邊。當一層的走訪完成後，將4個邊界指標向內側收縮，即可自然地過渡到下一層。

## 思考過程

1. **螺旋走訪是4個方向的重複操作**: 右→下→左→上這4個方向從外周向內側重複的結構，因此只要管理當前走訪範圍的「上端、下端、左端、右端」，每個方向的走訪範圍就能唯一確定
2. **用4個邊界指標表示走訪範圍**: 準備 `top`（上端的行）、`bottom`（下端的行）、`left`（左端的列）、`right`（右端的列）這4個變數。這些變數表示當前層的四邊位置
3. **決定每條邊的走訪順序**: 上邊從左到右（列遞增）、右邊從上到下（行遞增）、下邊從右到左（列遞減）、左邊從下到上（行遞減）。這4個 for 迴圈完成一層的走訪
4. **每條邊走訪後收縮邊界**: 走訪上邊後 `top++`（上端下移一行）、走訪右邊後 `right--`（右端左移一列）、走訪下邊後 `bottom--`、走訪左邊後 `left++`。這樣在下一次迴圈中就會走訪內側一層
5. **下邊和左邊的走訪需要額外條件判斷**: 由於走訪上邊後 `top` 遞增，走訪右邊後 `right` 遞減，在走訪下邊時 `top <= bottom` 可能已經不成立。同樣地，在走訪左邊時 `left <= right` 也可能已經不成立。如果不滿足這些條件，就會重複讀取已經走訪過的行或列，因此需要進行條件檢查
6. **終止條件是邊界的交叉**: 當 `top > bottom` 或 `left > right` 時，所有層的走訪已經完成。將 while 迴圈的條件設為 `top <= bottom && left <= right` 即可自然終止

## 前置知識

### 什麼是 ArrayList

ArrayList 是可變長度的陣列。在末尾添加元素的 `add` 操作時間複雜度為 O(1)。用於構建結果的螺旋順序陣列。

```java
List<Integer> res = new ArrayList<>();  // 建立空的 ArrayList
res.add(5);                             // 在末尾添加 5 → [5]
res.add(3);                             // 在末尾添加 3 → [5, 3]
res.size();                             // 返回元素數量 → 2
```

### 什麼是邊界指標（Boundary Pointers）

邊界指標是表示矩陣走訪範圍的4個整數變數。`top` 和 `bottom` 表示行的範圍，`left` 和 `right` 表示列的範圍。每次走訪後修改其值，從而將範圍向內側收縮。

```java
int top = 0;                    // 上端的行索引（初始值: 0）
int bottom = matrix.length - 1; // 下端的行索引（初始值: 最後一行）
int left = 0;                   // 左端的列索引（初始值: 0）
int right = matrix[0].length - 1; // 右端的列索引（初始值: 最後一列）
top++;    // 將上端向下收縮一行
right--;  // 將右端向左收縮一列
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(m × n) — 恰好走訪矩陣的每個元素一次 |
| Space | O(1) — 除了輸出用的列表外，僅使用4個邊界指標 |

## 程式碼

```java
// 輸入: m 行 n 列的整數矩陣 matrix
// 輸出: 返回將所有元素按螺旋順序儲存的 List<Integer>
List<Integer> spiralOrder(int[][] matrix) {
    // 建立用於儲存結果的可變長度列表
    List<Integer> res = new ArrayList<>();
    // 若矩陣為空（行數為 0），則直接返回空列表
    if (matrix.length == 0) return res;

    // 初始化4個邊界指標。這些指標表示當前應走訪的層的四邊位置
    int top = 0;                      // 上端的行（最上行）
    int bottom = matrix.length - 1;   // 下端的行（最下行）
    int left = 0;                     // 左端的列（最左列）
    int right = matrix[0].length - 1; // 右端的列（最右列）

    // 當走訪範圍存在時，逐層重複。邊界交叉時表示所有元素的走訪已完成
    while (top <= bottom && left <= right) {
        // 上邊: 從左到右走訪
        for (int c = left; c <= right; c++)
            res.add(matrix[top][c]);
        // 上邊走訪完成。將上端下移一行，以避免在下一次右邊走訪時重複讀取角落元素
        top++;

        // 右邊: 從上到下走訪（top 已更新，因此不會重複讀取角落元素）
        for (int r = top; r <= bottom; r++)
            res.add(matrix[r][right]);
        // 右邊走訪完成。將右端左移一列
        right--;

        // 下邊: 從右到左走訪
        // 條件檢查: 若 top++ 的結果導致 top > bottom（剩餘只有1行的情況），
        // 則下邊與上邊為同一行且已走訪完畢，因此跳過
        if (top <= bottom) {
            for (int c = right; c >= left; c--)
                res.add(matrix[bottom][c]);
            // 將下端上移一行
            bottom--;
        }

        // 左邊: 從下到上走訪
        // 條件檢查: 若 right-- 的結果導致 left > right（剩餘只有1列的情況），
        // 則左邊與右邊為同一列且已走訪完畢，因此跳過
        if (left <= right) {
            for (int r = bottom; r >= top; r--)
                res.add(matrix[r][left]);
            // 將左端右移一列
            left++;
        }
    }
    // 返回儲存了全部 m×n 個元素的螺旋順序列表
    return res;
}
```
