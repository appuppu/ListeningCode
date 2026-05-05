# Finding the Smallest Window Containing All Characters — 查找包含所有字符的最小子字符串

## 问题的本质

给定两个字符串 `s` 和 `t`。从 `s` 中找到包含 `t` 的所有字符（包括重复字符）的**最短子字符串**并返回。如果不存在这样的子字符串，则返回空字符串。

## 核心思路

通过向右扩展右指针来创建满足条件的窗口，然后通过收缩左指针来使窗口最小化。通过用一个变量管理"满足条件的字符种类数"，可以在O(1)时间内判定窗口的有效性。

## 思考过程

1. **预先统计所需字符的出现次数**: 将 `t` 中每个字符的出现次数记录到HashMap中。这将作为窗口需要满足的条件。例如 `t = "ABC"` 时，记录为 `{A:1, B:1, C:1}`
2. **向右扩展窗口以满足条件**: 将右指针 `r` 逐步向右移动，向窗口中添加字符，并用另一个HashMap管理窗口内字符的出现次数。每当窗口内某个字符的出现次数达到所需数量时，将计数器 `have` 递增
3. **在O(1)时间内判定条件是否满足**: 将 `need` 的大小（所需字符种类数）设为 `required`，当 `have == required` 成立时，窗口包含了 `t` 的所有字符。通过按字符种类进行管理，无需每次比较所有字符
4. **从左侧收缩窗口以最小化**: 在 `have == required` 期间，将左指针 `left` 向右移动以收缩窗口。每次收缩时将窗口长度与当前最小值进行比较，如果更短则更新结果
5. **移除左端字符时的处理**: 从窗口中移除左端字符 `s.charAt(left)` 时，如果该字符包含在 `need` 中，且窗口内的出现次数低于所需数量，则将 `have` 递减。这将导致 `while` 循环终止，重新回到右指针的扩展过程
6. **最终返回值**: 遍历结束后，如果找到了最小窗口，则返回 `s.substring(resStart, resStart + resLen)`。如果未找到，则返回空字符串

## 前置知识

### 什么是 HashMap

HashMap是一种保存键值对的数据结构。通过指定键可以在O(1)时间内搜索和获取值。在本题中用于管理字符的出现次数。

```java
HashMap<Character, Integer> map = new HashMap<>();  // 创建空的HashMap
map.put('A', 1);                    // 将值1存储到键'A'中
map.getOrDefault('A', 0);           // 返回键'A'的值。如果不存在则返回0 → 1
map.containsKey('A');               // 以boolean返回键'A'是否存在 → true
map.get('A').equals(map.get('B'));  // Integer对象之间的比较需要使用equals
```

### 什么是 Sliding Window（滑动窗口）

滑动窗口是一种使用两个指针 `left` 和 `right` 管理数组或字符串上连续范围（窗口）的方法。通过右指针扩展窗口、左指针收缩窗口，可以将检查所有子字符串的O(n²)处理优化为O(n)。

```java
int left = 0;
for (int r = 0; r < s.length(); r++) {
    // 通过右指针扩展窗口的处理
    while (条件满足) {
        // 通过左指针收缩窗口的处理
        left++;
    }
}
```

### 什么是 have / required 模式

这是一种在O(1)时间内判定窗口是否满足条件的方法。`required` 表示需要满足的字符种类总数，`have` 表示当前已达到所需数量的字符种类数。当 `have == required` 时，窗口满足所有条件。

```java
int required = need.size();  // 所需字符种类数（例: need={A:1,B:1,C:1} → 3）
int have = 0;                // 满足条件的字符种类数（初始值为0）
// 当窗口内'A'的数量达到need中'A'的数量时 have++ → have==required时所有条件满足
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n) — 右指针和左指针分别最多遍历 `s` 一次 |
| Space | O(n) — HashMap `need` 和 `window` 最多保存 `s` 和 `t` 的字符种类数量的元素 |

## 代码

```java
// 输入: 字符串 s 和字符串 t
// 输出: 以 String 返回 s 中包含 t 的所有字符的最短子字符串。如果不存在则返回空字符串
String minWindow(String s, String t) {
    // 如果s比t短，则不存在包含所有字符的窗口
    if (s.length() < t.length())
        return "";

    // 记录t中每个字符所需出现次数的HashMap。这定义了窗口需要满足的条件
    Map<Character, Integer> need = new HashMap<>();
    for (char c : t.toCharArray()) {
        need.put(c, need.getOrDefault(c, 0) + 1);
    }

    // 管理窗口内每个字符出现次数的HashMap
    Map<Character, Integer> window = new HashMap<>();
    int have = 0;              // 满足条件的字符种类数
    int required = need.size(); // 需要满足的字符种类总数（need的键的数量）
    int resLen = Integer.MAX_VALUE; // 最小窗口的长度（表示未找到状态的初始值）
    int resStart = 0;          // 最小窗口的起始位置
    int left = 0;              // 左指针

    // 通过右指针向右扩展窗口
    for (int r = 0; r < s.length(); r++) {
        char c = s.charAt(r);
        // 将窗口内字符c的出现次数加1（窗口向右扩展了1个字符）
        window.put(c, window.getOrDefault(c, 0) + 1);

        // 如果字符c是t中所需的字符，且窗口内的出现次数恰好达到所需数量，则增加have
        // 注意: Integer对象的比较需要使用equals而不是==
        if (need.containsKey(c)
            && window.get(c).equals(need.get(c))) {
            have++;
        }

        // 在窗口满足所有条件期间（have == required），从左侧收缩以最小化窗口
        while (have == required) {
            int wLen = r - left + 1;
            // 如果找到更短的窗口，则更新结果
            if (wLen < resLen) {
                resLen = wLen;
                resStart = left;
            }
            // 从窗口中移除左端字符
            char lc = s.charAt(left);
            window.put(lc, window.get(lc) - 1);
            // 如果移除后窗口内的出现次数低于所需数量，则条件不再满足，减少have
            if (need.containsKey(lc)
                && window.get(lc) < need.get(lc)) {
                have--;
            }
            // 将左指针向右移动以收缩窗口
            left++;
        }
    }

    // 如果resLen仍为初始值，则未找到满足条件的窗口，返回空字符串
    if (resLen == Integer.MAX_VALUE)
        return "";
    // 从最小窗口的起始位置截取最小窗口长度的子字符串并返回
    return s.substring(resStart, resStart + resLen);
}
```
