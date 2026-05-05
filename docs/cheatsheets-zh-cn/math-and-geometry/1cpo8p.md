# Rotating a Matrix 90 Degrees — 不使用额外内存将n×n矩阵顺时针旋转90度

## 问题的本质

给定一个n×n的正方形矩阵，要求将该矩阵顺时针旋转90度。不分配新的矩阵，进行**in-place（原地）**变换。旋转后，原矩阵中的每个元素 `matrix[i][j]` 移动到 `matrix[j][n-1-i]` 的位置。

## 核心思路

90度旋转可以分解为"转置（交换行和列）"+"将每行左右翻转"这两个简单操作。通过这种分解，可以在不使用额外内存的情况下将每个元素移动到正确的位置。

## 思考过程

1. **观察旋转后的目标位置**：元素 `matrix[i][j]` 经过90度顺时针旋转后移动到 `matrix[j][n-1-i]`。如果直接逐个元素进行这种变换，则需要4个元素的循环置换，过程会变得复杂
2. **考虑能否将旋转分解为已知的操作**：转置操作将 `matrix[i][j]` 移动到 `matrix[j][i]`。转置后再将每行左右翻转，`matrix[j][i]` 就移动到 `matrix[j][n-1-i]`。这与原始的 `matrix[i][j]` → `matrix[j][n-1-i]` 即90度旋转一致
3. **如何原地实现转置**：以对角线（`i == j`）为界，交换上三角和下三角的元素。在 `j > i` 的范围内交换 `matrix[i][j]` 和 `matrix[j][i]`，即可确保每对元素只交换一次
4. **如何原地实现每行的翻转**：对每行设置左端和右端两个指针，向中央移动并交换元素。这个操作不需要额外内存
5. **按顺序执行两个操作**：先对整个矩阵进行转置，再翻转每一行。由于两个操作都可以原地完成，整体只需O(1)的额外内存即可完成90度旋转

## 前置知识

### 什么是转置（Transpose）

将矩阵的行和列互换的操作。交换元素 `matrix[i][j]` 和 `matrix[j][i]` 的位置。对于正方形矩阵，对角线上的元素不动，交换关于对角线对称位置的元素。

```java
// 3×3矩阵转置的示例
// 转置前:        转置后:
// [1, 2, 3]     [1, 4, 7]
// [4, 5, 6]  →  [2, 5, 8]
// [7, 8, 9]     [3, 6, 9]

// matrix[0][1]=2 和 matrix[1][0]=4 被交换
int temp = matrix[i][j];
matrix[i][j] = matrix[j][i];
matrix[j][i] = temp;
```

### 什么是数组翻转（Reverse）

将数组的元素左右对称地交换的操作。从左端和右端开始向中央移动指针并进行交换。

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

### 什么是in-place（原地）操作

不分配新的数据结构，直接修改输入数据本身的操作。使用临时变量（`temp`）的空间为O(1)，因此是允许的。由于题目要求"不分配新的矩阵"，所以需要使用原地方式来解题。

## 复杂度

| | 值 |
|---|---|
| Time | O(n²) — 转置进行n²/2次交换，翻转进行n²/2次交换 |
| Space | O(1) — 仅使用临时变量，不分配新的矩阵 |

## 代码

```java
// 输入: n×n的整数矩阵matrix（二维数组int[][]）。由于是正方形矩阵，行数和列数相同
// 输出: 无（void）。将参数matrix本身修改为顺时针旋转90度后的状态
public void rotate(int[][] matrix) {
    // 通过matrix.length获取矩阵的大小n
    int n = matrix.length;

    // 步骤1: 转置（以对角线为界交换元素，将行和列互换）
    for (int i = 0; i < n; i++) {
        // j从i+1开始的原因: 对角线上(i==j)不需要交换，j<i的范围已经交换过了
        for (int j = i + 1; j < n; j++) {
            // 使用临时变量交换matrix[i][j]和matrix[j][i]，将行和列互换
            int temp = matrix[i][j];
            matrix[i][j] = matrix[j][i];
            matrix[j][i] = temp;
        }
    }

    // 步骤2: 将每行左右翻转
    for (int i = 0; i < n; i++) {
        // 设置左端和右端两个指针，向中央移动并交换
        int left = 0, right = n - 1;
        while (left < right) {
            // 交换matrix[i][left]和matrix[i][right]来左右翻转该行
            int temp = matrix[i][left];
            matrix[i][left] = matrix[i][right];
            matrix[i][right] = temp;
            left++;
            right--;
        }
    }
    // 当所有行的翻转完成后，整个矩阵就处于顺时针旋转90度后的状态了
}
```
