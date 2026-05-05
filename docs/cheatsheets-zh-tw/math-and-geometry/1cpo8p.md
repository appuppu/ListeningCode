# Rotating a Matrix 90 Degrees — 不使用額外記憶體將 n×n 矩陣順時針旋轉 90 度

## 問題的本質

給定一個 n×n 的正方矩陣。將此矩陣順時針旋轉 90 度。不分配新的矩陣，進行 **in-place（原地）** 轉換。旋轉後，原矩陣的每個元素 `matrix[i][j]` 會移動到 `matrix[j][n-1-i]` 的位置。

## 核心思路

90 度旋轉可以分解為「轉置（交換行與列）」+「將每一行左右翻轉」這兩個簡單的操作。透過這種分解，可以不使用額外記憶體將每個元素移動到正確的位置。

## 思考過程

1. **觀察旋轉的移動目標**: 元素 `matrix[i][j]` 在順時針旋轉 90 度後會移動到 `matrix[j][n-1-i]`。若直接逐一對元素進行此轉換，則需要 4 個元素的循環置換，會變得很複雜
2. **思考能否將旋轉分解為已知的操作**: 轉置操作將 `matrix[i][j]` 移動到 `matrix[j][i]`。轉置後對每一行進行左右翻轉，`matrix[j][i]` 就會移動到 `matrix[j][n-1-i]`。這與原始的 `matrix[i][j]` → `matrix[j][n-1-i]` 即 90 度旋轉一致
3. **如何以 in-place 方式實現轉置**: 以對角線（`i == j`）為界，交換上三角和下三角的元素。在 `j > i` 的範圍內交換 `matrix[i][j]` 和 `matrix[j][i]`，即可確保每對元素只交換一次
4. **如何以 in-place 方式實現每一行的翻轉**: 對每一行準備左端和右端的指標，向中央方向逐步交換元素。此操作不需要額外記憶體
5. **依序套用這兩個操作**: 先對整個矩陣進行轉置，再對每一行進行翻轉。兩者都能以 in-place 方式進行，因此整體只需 O(1) 的額外記憶體即可完成 90 度旋轉

## 前置知識

### 轉置（Transpose）是什麼

將矩陣的行與列互換的操作。交換元素 `matrix[i][j]` 和 `matrix[j][i]` 的位置。對於正方矩陣，對角線上的元素不會移動，交換以對角線為軸對稱位置的元素。

```java
// 3×3 矩陣轉置的範例
// 轉置前:         轉置後:
// [1, 2, 3]     [1, 4, 7]
// [4, 5, 6]  →  [2, 5, 8]
// [7, 8, 9]     [3, 6, 9]

// matrix[0][1]=2 和 matrix[1][0]=4 被交換
int temp = matrix[i][j];
matrix[i][j] = matrix[j][i];
matrix[j][i] = temp;
```

### 陣列翻轉（Reverse）是什麼

將陣列的元素左右對稱地交換的操作。從左端和右端向中央推進指標，同時進行交換。

```java
// [1, 4, 7] → [7, 4, 1]
int left = 0, right = n - 1;
while (left < right) {
    int temp = array[left];
    array[left] = array[right];
    array[right] = temp;
    left++;
    right--;
}
```

### in-place（原地）操作是什麼

不分配新的資料結構，直接修改輸入資料本身的操作。使用暫存變數（`temp`）為 O(1)，因此是被允許的。因為題目指示「不要分配新的矩陣」，所以需要以 in-place 方式求解。

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n²) — 轉置進行 n²/2 次交換，翻轉進行 n²/2 次交換 |
| Space | O(1) — 僅使用暫存變數，不分配新的矩陣 |

## 程式碼

```java
// 輸入: n×n 的整數矩陣 matrix（二維陣列 int[][]）。因為是正方矩陣，所以行數和列數相同
// 輸出: 無（void）。將引數的 matrix 本身修改為順時針旋轉 90 度後的狀態
public void rotate(int[][] matrix) {
    // 透過 matrix.length 取得矩陣的大小 n
    int n = matrix.length;

    // 步驟 1: 轉置（以對角線為軸交換元素，將行與列互換）
    for (int i = 0; i < n; i++) {
        // j 從 i+1 開始的原因: 對角線上(i==j)不需要交換，j<i 的範圍已經交換完畢
        for (int j = i + 1; j < n; j++) {
            // 使用暫存變數交換 matrix[i][j] 和 matrix[j][i]，將行與列互換
            int temp = matrix[i][j];
            matrix[i][j] = matrix[j][i];
            matrix[j][i] = temp;
        }
    }

    // 步驟 2: 將每一行左右翻轉
    for (int i = 0; i < n; i++) {
        // 準備左端和右端兩個指標，向中央方向逐步交換
        int left = 0, right = n - 1;
        while (left < right) {
            // 交換 matrix[i][left] 和 matrix[i][right]，將該行左右翻轉
            int temp = matrix[i][left];
            matrix[i][left] = matrix[i][right];
            matrix[i][right] = temp;
            left++;
            right--;
        }
    }
    // 所有行的翻轉完成後，整個矩陣即處於順時針旋轉 90 度的狀態
}
```
