# Checking if a String is a Palindrome — 判断字符串是否为回文

## 问题的本质

给定一个字符串 `s`。仅考虑字母和数字字符，忽略大小写差异，判断该字符串是否为回文（从前往后读和从后往前读相同）。如果是回文则返回 `true`，否则返回 `false`。

## 核心思路

从字符串的两端分别放置两个指针向内移动，跳过非字母数字字符，逐字符进行比较，这样无需生成额外的字符串，即可在 O(1) 的空间内完成回文判断。

## 思考过程

1. **确认回文的定义**: 回文是指从前往后读和从后往前读都相同的字符串。也就是说，首尾字符相同，且其内部的字符也依次相同，则该字符串为回文
2. **从两端进行比较即可在一次遍历中完成判断**: 在首部放置指针 `left`，在尾部放置指针 `right`，两者向内移动直到相遇，边移动边比较，只需遍历所有字符一次即可完成判断
3. **需要跳过非字母数字字符**: 由于问题仅考虑字母和数字字符，当指针指向非字母数字字符时，需要跳过并移动到下一个位置。可以使用 `Character.isLetterOrDigit` 来判断字符是否为字母或数字
4. **统一大小写后再进行比较**: 由于问题不区分大小写，因此在比较前使用 `Character.toLowerCase` 将两个字符都转换为小写，然后再确认是否一致
5. **发现不匹配时立即返回 `false`**: 只要有一处不同，该字符串就不是回文，因此可以提前返回
6. **指针交叉前未发现不匹配则为回文**: 循环正常结束意味着所有对应的字符都匹配，因此返回 `true`

## 前置知识

### 什么是 Two Pointers（双指针法）

在数组或字符串的两端各放置一个指针，根据条件向内移动的方法。该方法适用于利用对称性的问题（回文判断、配对查找等）。由于只需一次遍历即可解决问题，因此可以实现时间 O(n)、空间 O(1) 的复杂度。

```java
int left = 0;                    // 指向首部的指针
int right = s.length() - 1;     // 指向尾部的指针
// 在 left 和 right 交叉之前持续循环
while (left < right) {
    // 执行比较或处理操作
    left++;    // 将左指针向右移动
    right--;   // 将右指针向左移动
}
```

### 什么是 Character.isLetterOrDigit

该方法用于判断一个字符是否为英文字母（a-z, A-Z）或数字（0-9）。当需要排除空格、符号等非字母数字字符时使用。

```java
Character.isLetterOrDigit('A');   // true（英文字母）
Character.isLetterOrDigit('3');   // true（数字）
Character.isLetterOrDigit(' ');   // false（空格）
Character.isLetterOrDigit(',');   // false（符号）
```

### 什么是 Character.toLowerCase

该方法用于将英文字母转换为小写。当需要在不区分大小写的情况下进行比较时使用。如果字符已经是小写或数字，则原样返回。

```java
Character.toLowerCase('A');   // 'a'
Character.toLowerCase('a');   // 'a'（无变化）
Character.toLowerCase('3');   // '3'（数字原样返回）
```

## 复杂度

| | 值 |
|---|---|
| Time | O(n) — 每个指针最多遍历字符串一次 |
| Space | O(1) — 仅使用两个指针，不使用额外的字符串或数据结构 |

## 代码

```java
// 输入: 字符串 s
// 输出: 如果 s 是回文则返回 true，否则返回 false
public boolean isPalindrome(String s) {
    // 在首部和尾部各放置一个指针。这两个指针从字符串的两端向内移动
    int left = 0;
    int right = s.length() - 1;

    // 重复执行直到两个指针交叉。交叉意味着所有比较已经完成
    while (left < right) {
        // 如果 left 指向的不是字母数字字符，则向右跳过
        // 注意: 跳过过程中也要维持 left < right 的条件，防止指针交叉
        while (left < right && !Character.isLetterOrDigit(s.charAt(left))) {
            left++;
        }
        // 如果 right 指向的不是字母数字字符，则向左跳过。同样维持 left < right 的条件
        while (left < right && !Character.isLetterOrDigit(s.charAt(right))) {
            right--;
        }
        // 将两个字符都转换为小写后再比较，以忽略大小写差异
        // 如果不匹配则不是回文。只要有一处不同就不满足回文条件，因此立即返回
        if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right))) {
            return false;
        }
        // 两个字符匹配，将两个指针都向内移动，继续比较下一对字符
        left++;
        right--;
    }
    // 循环正常结束（所有对应的字符对都匹配），因此该字符串是回文
    return true;
}
```
