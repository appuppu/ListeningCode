# Encoding and Decoding a List of Strings — 将字符串列表编码为一个字符串并解码还原

## 问题的本质

给定一个字符串列表 `strs`。需要通过 `encode` 方法将列表转换为一个字符串，再通过 `decode` 方法将该字符串还原为原始列表。编码和解码必须是无状态的（不保存任何状态），并且需要正确处理所有输入，包括空字符串、特殊字符以及包含分隔符本身的字符串。

## 核心思路

在每个字符串前面附加"该字符串的长度"，这样无论字符串内容包含什么字符，都能准确地截取出来。只要已知长度，就从原理上不会发生与分隔符的冲突问题。

## 思考过程

1. **认识到朴素分隔符方式的问题**：如果使用逗号或换行符等分隔符来拼接列表，当字符串本身包含该分隔符时就无法正确解码。即使引入转义处理，也需要对转义字符本身进行转义，导致逻辑变得复杂
2. **先传递字符串的长度就不会发生冲突**：在每个字符串前面记录该字符串的长度（字符数而非字节数），解码时就能预先知道"需要读取多少个字符"。由于完全不需要解析字符串的内容就能截取，因此无论包含什么字符都不会出现问题
3. **使用 `#` 作为长度与字符串本体之间的分隔符**：由于长度是可变位数的整数，需要一个符号来标记长度部分的结束。使用 `#` 作为分隔符，采用 `长度#字符串本体` 的格式。解码时从 `#` 的位置读取长度部分，然后从其后方截取指定数量的字符
4. **编码**：对每个字符串，将 `字符串的长度 + "#" + 字符串本体` 拼接起来，构建一个完整的字符串。例如 `["hello", "a#b"]` 会被编码为 `5#hello3#a#b`
5. **解码**：从头部开始查找 `#` 并读取长度，然后从 `#` 的下一个位置截取相应长度的字符。将截取结束的位置作为下一次的起始位置，重复该过程。即使字符串本体中包含 `#`，由于已通过长度确定了准确的范围，因此不会发生误判
6. **最终返回值**：`encode` 返回拼接后的一个 `String`，`decode` 返回从该 `String` 还原的 `List<String>`

## 前置知识

### 什么是 StringBuilder

StringBuilder 是一个用于高效拼接字符串的类。通过 `String` 的 `+` 运算符进行拼接时，每次都会生成新的 `String` 对象，而 `StringBuilder` 通过向内部缓冲区追加内容，能够以 O(1) 的时间复杂度完成拼接。

```java
StringBuilder sb = new StringBuilder();  // 创建一个空的StringBuilder
sb.append("hello");                      // 在末尾追加 "hello"
sb.append(5);                            // 在末尾将整数5作为字符串追加
sb.toString();                           // 返回结果字符串 "hello5"
```

### 什么是 String.indexOf(char, int)

该方法从指定的起始位置开始向前搜索指定字符，并返回第一次找到该字符的位置（索引）。如果未找到则返回 -1。

```java
String str = "12#hello";
str.indexOf('#', 0);    // 从位置0开始查找 '#' → 返回 2
str.indexOf('#', 3);    // 从位置3开始查找 '#' → 未找到则返回 -1
```

### 什么是 String.substring(int, int)

该方法用于截取字符串的指定范围。第1个参数是起始位置（包含），第2个参数是结束位置（不包含）。

```java
String str = "5#hello";
str.substring(0, 1);    // 从位置0到位置1之前 → "5"
str.substring(2, 7);    // 从位置2到位置7之前 → "hello"
```

### 什么是 Integer.parseInt(String)

该方法是一个将字符串转换为整数的静态方法。用于将长度前缀的数值部分读取为整数。

```java
Integer.parseInt("5");    // 将字符串 "5" 转换为整数 5
Integer.parseInt("123");  // 将字符串 "123" 转换为整数 123
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n × k) — n 是字符串的个数，k 是字符串的平均长度。对所有字符串各处理一次 |
| Space | O(n × k) — 编码结果或解码结果需要使用所有字符串总量的空间 |

## 代码

```java
// === encode ===
// 输入: 字符串列表 strs（List<String>）
// 输出: 返回将所有字符串合并为一个的 String
public String encode(List<String> strs) {
    // 在循环中使用StringBuilder来高效地拼接字符串
    StringBuilder sb = new StringBuilder();
    // 从头开始依次遍历列表中的每个字符串
    for (String str : strs) {
        // 在每个字符串前面附加"长度#"并拼接
        // 通过预先记录长度，解码时就能确定字符串本体的准确范围
        sb.append(str.length() + "#" + str);
    }
    // 将StringBuilder的内容作为String返回
    return sb.toString();
}

// === decode ===
// 输入: 编码后的一个字符串 str（String）
// 输出: 返回还原后的字符串列表 List<String>
public List<String> decode(String str) {
    List<String> result = new ArrayList<>();
    // 表示当前读取位置的变量。从头部开始
    int i = 0;
    while (i < str.length()) {
        // 从当前位置 i 开始查找第一个 '#'，确定长度部分与字符串本体的分隔位置
        int separatorIndex = str.indexOf('#', i);
        // 将 '#' 之前的部分读取为整数，得到字符串本体的长度
        int textLength = Integer.parseInt(str.substring(i, separatorIndex));
        // '#' 的下一个位置就是字符串本体的起始位置
        int textStart = separatorIndex + 1;
        // 从起始位置向后偏移长度个字符就是结束位置。由于通过长度来确定范围，即使字符串本体中包含 '#' 也能正确截取
        int textEnd = textStart + textLength;
        // 截取字符串本体并添加到结果列表中
        result.add(str.substring(textStart, textEnd));
        // 将读取位置移动到下一个字符串的长度部分的开头
        i = textEnd;
    }
    return result;
}
```
