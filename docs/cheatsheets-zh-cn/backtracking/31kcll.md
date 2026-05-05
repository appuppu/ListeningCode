# Mapping Phone Number Digits to Letter Combinations — 根据电话号码数字生成所有字母组合

## 问题的本质

给定一个由数字2〜9组成的字符串 `digits`。每个数字映射到电话键盘上对应的字母（例如：2→"abc"，3→"def"）。从 `digits` 的每个数字中各选一个字母依次排列，返回所有可能的**字母组合**列表。

## 核心思路

每个数字位置可选的字母有3〜4个，需要枚举所有组合。逐个选择字母并追加到末尾，当所有位数的字母都选完后将结果记录下来，然后撤销上一次的选择并尝试其他字母。通过这种"回溯"方法，可以不遗漏地探索所有模式。

## 思考过程

1. **每个数字位置都有选择项**：每个数字对应3〜4个字母，在每个位置选择1个字母。所有位置的选择组合就是答案，因此需要系统地枚举所有模式
2. **用递归逐位处理**：从第一个数字开始依次选择一个字母，将下一个数字的处理交给递归调用。这样每层递归的深度对应一个数字位置，结构变得简洁
3. **终止条件是处理完所有位数**：当递归深度达到 `digits` 的长度时，当前正在构建的字符串就是一个完整的组合。将其添加到结果列表中
4. **通过回溯尝试其他选择项**：从递归返回后，从 `StringBuilder` 的末尾删除刚才添加的字母。这样就做好了尝试同一位置其他字母的准备
5. **使用映射数组将数字转换为字母**：准备一个索引为0〜9的字符串数组，通过 `digits.charAt(idx) - '0'` 将数字字符转换为整数并进行索引访问，即可以O(1)的时间获取对应的字母组
6. **处理空字符串输入**：当 `digits` 为空时不存在任何组合，直接返回空列表

## 前置知识

### 什么是回溯

回溯是一种逐步构建候选解，完成后记录结果，然后撤销上一次选择并尝试其他选择项的搜索方法。用于枚举所有组合和排列的问题。通过递归实现"选择→前进→撤销→尝试其他"的循环。

```java
// 回溯的基本模式
void backtrack(状态, 结果列表) {
    if (终止条件) {
        结果列表.add(当前状态);
        return;
    }
    for (选择项 : 当前选择项列表) {
        将选择项添加到状态;       // 选择
        backtrack(下一个状态, 结果列表); // 前进
        从状态中删除选择项;     // 撤销（回溯）
    }
}
```

### 什么是 StringBuilder

StringBuilder 是一个用于高效构建字符串的类。`String` 是不可变的（每次修改都会创建新对象），而 `StringBuilder` 直接修改内部缓冲区，因此字符的追加和删除都可以在O(1)时间内完成。适合在回溯过程中构建字符串。

```java
StringBuilder sb = new StringBuilder();  // 创建空的StringBuilder
sb.append('a');           // 在末尾追加字符'a' → "a"
sb.append('b');           // 在末尾追加字符'b' → "ab"
sb.deleteCharAt(sb.length() - 1);  // 删除末尾的字符 → "a"
sb.toString();            // 转换为String类型并返回 → "a"
```

### 电话键盘映射

用数组表示数字与字母的对应关系。数组的索引对应数字，值为该数字所分配的字母组。

```java
String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};
// phone[2] → "abc",  phone[7] → "pqrs",  phone[9] → "wxyz"
// 将字符'3'转换为整数3: '3' - '0' → 3
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(4^n) — 每个数字最多有4个字母选择项，枚举n位数的所有组合 |
| Space | O(n) — 递归深度最大为n，StringBuilder的长度也最大为n（不包括结果列表） |

## 代码

```java
// 输入：由数字2〜9组成的字符串 digits
// 输出：返回包含所有字母组合的 List<String>

// 通过回溯逐位选择字母，枚举所有组合
void backtrack(String digits, String[] phone, int idx, StringBuilder path, List<String> result) {
    // 终止条件：当idx等于digits的长度时，表示所有位数的字母已选择完毕
    // 将StringBuilder的内容转换为String并添加到结果中
    if (idx == digits.length()) {
        result.add(path.toString());
        return;
    }

    // 通过 digits.charAt(idx) - '0' 将数字字符转换为整数，从phone数组中获取对应的字母组
    String letters = phone[digits.charAt(idx) - '0'];

    // 逐个尝试当前数字对应的每个字母
    for (char c : letters.toCharArray()) {
        path.append(c);                            // 选择：选定字母并追加到末尾
        backtrack(digits, phone, idx + 1, path, result);  // 递归：进入下一位数的处理
        path.deleteCharAt(path.length() - 1);      // 恢复：删除末尾字母恢复原状（回溯）
    }
}

List<String> letterCombinations(String digits) {
    // 创建用于存储结果的空列表
    List<String> result = new ArrayList<>();

    // 如果是空字符串则不存在任何组合，返回空列表
    if (digits.isEmpty()) return result;

    // 定义索引对应数字的映射数组
    // 索引0和1在电话键盘上没有分配字母，因此设为空字符串
    String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    // 从位置0开始，以空的StringBuilder启动回溯
    backtrack(digits, phone, 0, new StringBuilder(), result);

    // 所有递归完成后，返回包含所有组合的result
    return result;
}
```
