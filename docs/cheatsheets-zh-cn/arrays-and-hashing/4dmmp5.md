# Validating a Sudoku Board — 判定9×9的Sudoku棋盘是否有效

## 问题的本质

给定一个用9×9的二维字符数组表示的Sudoku棋盘。如果每行、每列、每个3×3子网格中都不包含重复的数字，则判定该棋盘有效并返回 `true`。空单元格用点 `.` 表示。棋盘不需要是完成状态，只需确认当前的配置是否违反规则。

## 核心思路

在对整个棋盘进行一次遍历的过程中，如果某个单元格的数字在"该行"、"该列"或"该3×3方框"中已经出现过，则判定为无效。任意单元格 `(i, j)` 所属方框的索引可以通过公式 `(i/3) * 3 + j/3` 唯一映射到0〜8。

## 思考过程

1. **整理需要验证的条件**：Sudoku的有效性由"每行无重复"、"每列无重复"、"每个3×3方框无重复"这三个条件决定。如果能同时验证这三个条件，则效率最高
2. **HashSet适合用于检测重复**：要以O(1)的时间复杂度判断某个数字是否已经出现过，HashSet是最佳选择。为每行准备9个、每列准备9个、每个方框准备9个，共计27个HashSet，就可以同时检查三个条件
3. **需要从单元格映射到方框**：需要计算单元格 `(i, j)` 属于哪个方框。行方向通过 `i/3`（整数除法）分为0、1、2三组，列方向通过 `j/3` 分为0、1、2三组。要将其转换为一维索引，使用 `(i/3) * 3 + j/3`。这样9个方框就对应了0〜8的编号
4. **通过一次遍历验证所有条件**：用双重for循环遍历整个棋盘，对每个单元格在行、列、方框三个Set上执行重复检查和注册操作。点不是数字，因此跳过
5. **发现重复时立即返回false**：如果三个Set中的任意一个已经包含相同的数字，则该棋盘无效，立即返回 `false`
6. **遍历完所有单元格后返回true**：如果从未发现重复，则该棋盘有效

## 前置知识

### 什么是HashSet

HashSet是一种管理不重复元素集合的数据结构。添加元素和检查元素是否存在的操作都可以在O(1)时间内完成。本题中使用它来快速判断某个数字是否已经出现过。

```java
Set<Character> set = new HashSet<>();  // 创建一个空的HashSet
set.add('5');            // 添加元素'5'
set.contains('5');       // 检查元素'5'是否存在，返回boolean → true
set.contains('3');       // 检查元素'3'是否存在，返回boolean → false
```

### 创建HashSet数组的方法

将9个HashSet作为数组统一管理。由于无法直接创建泛型数组，因此通过 `new HashSet[9]` 创建原始类型的数组，然后在循环中逐个初始化每个元素。

```java
Set<Character>[] sets = new HashSet[9];  // 分配9个元素的数组
for (int i = 0; i < 9; i++) {
    sets[i] = new HashSet<>();           // 将每个元素初始化为空的HashSet
}
```

### 方框索引的计算公式

`boxIdx = (i/3) * 3 + j/3` 返回单元格 `(i, j)` 所属的3×3方框的编号（0〜8）。`i/3` 表示行方向的方框位置（0、1、2），`j/3` 表示列方向的方框位置（0、1、2）。将行方向的位置乘以3再加上列方向的位置，就可以为9个方框分配唯一的编号。

```
方框编号的排列:
0 | 1 | 2
3 | 4 | 5
6 | 7 | 8

例: 单元格(4, 7) → (4/3)*3 + 7/3 = 1*3 + 2 = 5 → 属于方框5
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n²) — 对9×9的整个棋盘进行一次遍历（n=9且固定，因此也可以说是O(81)=O(1)） |
| Space | O(n²) — 在27个HashSet中最多保存81个元素 |

## 代码

```java
// 输入: 9×9的二维字符数组 board（数字 '1'〜'9' 或点 '.'）
// 输出: 如果棋盘有效则返回 true，无效则返回 false
public boolean isValidSudoku(char[][] board) {
    // 创建用于记录每行、每列、每个方框中出现过的数字的HashSet数组
    // rowset[i] 记录第i行、columnset[j] 记录第j列、boxset[k] 记录第k个方框中出现过的数字
    Set<Character>[] rowset = createSets();
    Set<Character>[] columnset = createSets();
    Set<Character>[] boxset = createSets();

    // 外层循环遍历行，内层循环遍历列，对全部81个单元格各访问一次
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            // 获取当前单元格的值
            char c = board[i][j];
            // 点表示空单元格（不是数字），因此跳过
            if (c == '.') {
                continue;
            }

            // 计算单元格(i, j)所属方框的编号（唯一对应0〜8）
            int boxIdx = (i / 3) * 3 + j / 3;

            // 如果行、列、方框中的任意一个已包含相同数字，则存在重复，立即返回false
            if (rowset[i].contains(c) || columnset[j].contains(c) || boxset[boxIdx].contains(c)) {
                return false;
            }

            // 如果没有重复，则将当前数字注册到三个Set中，以便后续的重复检测
            rowset[i].add(c);
            columnset[j].add(c);
            boxset[boxIdx].add(c);
        }
    }
    // 遍历完所有单元格后未发现任何重复，则棋盘有效
    return true;
}

// 创建包含9个空HashSet的数组的辅助方法
public Set<Character>[] createSets() {
    Set<Character>[] sets = new HashSet[9];
    for (int i = 0; i < 9; i++) {
        sets[i] = new HashSet<>();
    }
    return sets;
}
```
