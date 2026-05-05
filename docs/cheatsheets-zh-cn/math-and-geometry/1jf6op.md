# Traversing a Matrix in Spiral Order — 按螺旋顺序获取矩阵的全部元素

## 问题的本质

给定一个m行n列的矩阵 `matrix`。从左上角开始，按照右→下→左→上的顺序沿外周遍历，然后向内层重复此过程，返回所有元素按**螺旋顺序**排列的数组。

## 核心思路

将矩阵的外周视为一个"层"，依次遍历上边、右边、下边、左边这4条边。一层遍历完成后，将4个边界指针向内收缩，即可自然过渡到下一层。

## 思考过程

1. **螺旋遍历是4个方向的重复过程**: 从外周向内层重复右→下→左→上4个方向的遍历，因此只要管理当前遍历范围的"上端、下端、左端、右端"，就能唯一确定每个方向的遍历范围
2. **用4个边界指针表示遍历范围**: 准备 `top`（上端行）、`bottom`（下端行）、`left`（左端列）、`right`（右端列）这4个变量。它们表示当前层的四条边的位置
3. **确定每条边的遍历顺序**: 上边从左到右（列递增）、右边从上到下（行递增）、下边从右到左（列递减）、左边从下到上（行递减）。通过这4个for循环完成一层的遍历
4. **每条边遍历后收缩边界**: 遍历上边后执行 `top++`（上端下移一行）、遍历右边后执行 `right--`（右端左移一列）、遍历下边后执行 `bottom--`、遍历左边后执行 `left++`。这样下一次循环就会遍历内一层
5. **遍历下边和左边时需要额外的条件判断**: 由于遍历上边后 `top` 已递增，遍历右边后 `right` 已递减，在遍历下边时 `top <= bottom` 可能已不成立。同样，在遍历左边时 `left <= right` 可能已不成立。如果不满足这些条件，就会重复读取已遍历过的行或列，因此需要进行条件检查
6. **终止条件是边界交叉**: 当 `top > bottom` 或 `left > right` 时，所有层的遍历已经完成。将while循环的条件设为 `top <= bottom && left <= right` 即可自然终止

## 前置知识

### 什么是 ArrayList

一种可变长度的数组。向末尾添加元素的 `add` 操作的时间复杂度为O(1)。用于构建螺旋顺序的结果数组。

```java
List<Integer> res = new ArrayList<>();  // 创建空的ArrayList
res.add(5);                             // 在末尾添加5 → [5]
res.add(3);                             // 在末尾添加3 → [5, 3]
res.size();                             // 返回元素个数 → 2
```

### 什么是边界指针（Boundary Pointers）

表示矩阵遍历范围的4个整数变量。`top` 和 `bottom` 表示行的范围，`left` 和 `right` 表示列的范围。每次遍历后修改其值，从而将范围向内收缩。

```java
int top = 0;                    // 上端行索引（初始值: 0）
int bottom = matrix.length - 1; // 下端行索引（初始值: 最后一行）
int left = 0;                   // 左端列索引（初始值: 0）
int right = matrix[0].length - 1; // 右端列索引（初始值: 最后一列）
top++;    // 将上端向下收缩一行
right--;  // 将右端向左收缩一列
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(m × n) — 对矩阵的每个元素恰好遍历一次 |
| Space | O(1) — 除输出列表外，仅使用4个边界指针 |

## 代码

```java
// 输入: m行n列的整数矩阵 matrix
// 输出: 返回所有元素按螺旋顺序存储的 List<Integer>
List<Integer> spiralOrder(int[][] matrix) {
    // 创建用于存储结果的可变长度列表
    List<Integer> res = new ArrayList<>();
    // 如果矩阵为空（行数为0），直接返回空列表
    if (matrix.length == 0) return res;

    // 初始化4个边界指针。它们表示当前应遍历的层的四条边的位置
    int top = 0;                      // 上端行（最上行）
    int bottom = matrix.length - 1;   // 下端行（最下行）
    int left = 0;                     // 左端列（最左列）
    int right = matrix[0].length - 1; // 右端列（最右列）

    // 在遍历范围存在的期间，逐层重复遍历。当边界交叉时，所有元素的遍历已完成
    while (top <= bottom && left <= right) {
        // 上边: 从左到右遍历
        for (int c = left; c <= right; c++)
            res.add(matrix[top][c]);
        // 上边遍历完成。将上端下移一行，避免在后续右边遍历时重复读取角上的元素
        top++;

        // 右边: 从上到下遍历（top已更新，因此不会重复读取角上的元素）
        for (int r = top; r <= bottom; r++)
            res.add(matrix[r][right]);
        // 右边遍历完成。将右端左移一列
        right--;

        // 下边: 从右到左遍历
        // 条件检查: 如果top++的结果导致 top > bottom（即只剩一行的情况），
        // 下边与上边是同一行且已遍历过，因此跳过
        if (top <= bottom) {
            for (int c = right; c >= left; c--)
                res.add(matrix[bottom][c]);
            // 将下端上移一行
            bottom--;
        }

        // 左边: 从下到上遍历
        // 条件检查: 如果right--的结果导致 left > right（即只剩一列的情况），
        // 左边与右边是同一列且已遍历过，因此跳过
        if (left <= right) {
            for (int r = bottom; r >= top; r--)
                res.add(matrix[r][left]);
            // 将左端右移一列
            left++;
        }
    }
    // 返回包含全部 m×n 个元素的螺旋顺序列表
    return res;
}
```
