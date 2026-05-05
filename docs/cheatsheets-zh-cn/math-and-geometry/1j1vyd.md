# Multiplying Two Numbers Represented as Strings — 将两个字符串表示的数字相乘

## 问题的本质

给定两个表示非负整数的字符串 `num1` 和 `num2`，以字符串形式返回两个数的**乘积**。禁止使用内置的大整数库，也禁止将输入直接转换为整数。

## 核心思路

直接模拟小学学过的竖式乘法运算。关键在于以下位置关系：`num1` 的第 i 位与 `num2` 的第 j 位的乘积，会累加到结果的第 `i + j` 位和第 `i + j + 1` 位。

## 思考过程

1. **重现竖式乘法**：由于不能转换为整数，需要原样实现逐位相乘并累加结果的竖式乘法算法
2. **估算乘积的最大位数**：n 位数与 m 位数的乘积最多为 `n + m` 位（例如：99 × 99 = 9801，2 位 × 2 位 = 4 位）。因此，准备一个大小为 `n + m` 的数组 `pos`，用于存储各位的值
3. **确定每位乘积在结果中的对应位置**：`num1` 从右数第 i 位与 `num2` 从右数第 j 位的乘积，影响结果从右数第 `i + j` 位和第 `i + j + 1` 位。用字符串索引表示，`num1[i] * num2[j]` 的乘积累加到 `pos[i + j + 1]`（低位）和 `pos[i + j]`（高位）
4. **就地处理进位**：计算每对数位的乘积后，将其与 `pos[p2]` 中已累加的值相加，对 10 取余的结果留在该位，对 10 取商的结果加到高位 `pos[p1]`。这样进位就能立即得到处理
5. **去除前导零并构建字符串**：数组 `pos` 的开头可能包含零（例如：3 位 × 2 位的乘积为 4 位时，5 位数组的开头为 0）。在跳过前导零的同时，使用 `StringBuilder` 构建字符串
6. **零的特殊处理**：如果任一输入为 `"0"`，乘积必定为 `"0"`，因此提前返回 `"0"`

## 前置知识

### charAt 与字符到数值的转换

`String.charAt(i)` 以 `char` 类型返回字符串中第 i 个字符。要将 `char` 类型的 `'0'`～`'9'` 转换为整数 0～9，需要减去 `'0'` 的字符编码。

```java
String s = "123";
char c = s.charAt(0);       // '1'（char类型）
int digit = c - '0';        // 1（int类型）。用'1'的编码49减去'0'的编码48
```

### 竖式乘法的位置关系

在 n 位 × m 位的竖式乘法中，`num1[i]` 与 `num2[j]` 的乘积（最大为 81）可能是两位数。这两位数对应结果的 `pos[i + j]`（高位）和 `pos[i + j + 1]`（低位）。

```
例: "12" × "34"
  num1[0]=1, num2[0]=3 → 乘积3  → 累加到 pos[0], pos[1]
  num1[0]=1, num2[1]=4 → 乘积4  → 累加到 pos[1], pos[2]
  num1[1]=2, num2[0]=3 → 乘积6  → 累加到 pos[1], pos[2]
  num1[1]=2, num2[1]=4 → 乘积8  → 累加到 pos[2], pos[3]
```

### StringBuilder

StringBuilder 是用于高效构建可变长度字符串的类。通过 `append` 在末尾追加字符，最后通过 `toString` 转换为 `String`。

```java
StringBuilder sb = new StringBuilder();  // 创建空的StringBuilder
sb.append(4);                            // 末尾追加"4"
sb.append(0);                            // 变为"40"
sb.append(8);                            // 变为"408"
sb.toString();                           // 返回String类型的"408"
sb.length();                             // 返回当前字符数 → 3
```

## 复杂度

| | 值 |
|---|---|
| Time | O(n × m) — 对num1的每一位和num2的每一位的所有组合各执行一次乘法 |
| Space | O(n + m) — 存储乘积各位的数组大小为 n + m |

## 代码

```java
// 输入: 表示非负整数的字符串 num1 和 num2
// 输出: 返回表示两个数乘积的字符串
String multiply(String num1, String num2) {
    // 如果任一输入为"0"，乘积必定为0，提前返回"0"并结束
    if (num1.equals("0") || num2.equals("0"))
        return "0";

    int n = num1.length();
    int m = num2.length();
    // 存储乘积各位的数组。n位×m位的乘积最多为n+m位，因此该大小足够
    int[] pos = new int[n + m];

    // 与竖式乘法相同，从低位（末尾）向高位依次相乘
    for (int i = n - 1; i >= 0; i--) {
        for (int j = m - 1; j >= 0; j--) {
            // 通过charAt获取字符后减去'0'，将字符转换为对应的整数再相乘
            int mul = (num1.charAt(i) - '0')
                * (num2.charAt(j) - '0');
            // 乘积累加的位置: p1为高位，p2为低位。该位置关系基于竖式乘法中的位对应规则
            int p1 = i + j;
            int p2 = i + j + 1;
            // 考虑之前循环中在同一位置累加的值，与已累加的值相加
            int sum = mul + pos[p2];
            // 在低位只保留一位数（对10取余），将进位加到高位（对10取商）
            pos[p2] = sum % 10;
            pos[p1] += sum / 10;
        }
    }

    // 跳过前导零并构建字符串（例如: 5位数组的开头为0的情况）
    StringBuilder sb = new StringBuilder();
    for (int p : pos) {
        // 如果StringBuilder仍为空且当前值为0，则为前导零，跳过
        if (sb.length() == 0 && p == 0)
            continue;
        sb.append(p);
    }
    // 将StringBuilder转换为String类型并返回
    return sb.toString();
}
```
