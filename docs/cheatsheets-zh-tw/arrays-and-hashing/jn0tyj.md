# Encoding and Decoding a List of Strings — 將字串列表編碼為一個字串並解碼還原

## 問題的本質

給定一個字串列表 `strs`。使用 `encode` 方法將列表轉換為一個字串，再使用 `decode` 方法將該字串還原為原始列表。編碼與解碼必須是無狀態的（不持有任何狀態），並且需要正確處理所有輸入，包括空字串、特殊字元、以及包含分隔符本身的字串。

## 核心思路

在每個字串前面附加「該字串的長度」，無論字串內容包含什麼字元，都能準確地擷取出來。只要已知長度，就從原理上不會發生與分隔符的衝突問題。

## 思考過程

1. **認識樸素分隔符方式的問題**：如果使用逗號或換行符等分隔符來串接列表，當字串本身包含該分隔符時，就無法正確解碼。即使引入跳脫處理，也需要對跳脫字元本身進行跳脫，導致邏輯變得複雜
2. **先傳達字串長度就不會發生衝突**：在每個字串前面記錄該字串的長度（字元數而非位元組數），解碼時就能事先知道「要讀取多少個字元」。由於擷取時完全不需要解析字串內容，因此無論包含什麼字元都不會有問題
3. **使用 `#` 作為長度與字串本體的分隔符**：由於長度是可變位數的整數，需要一個符號來標示長度部分的結尾。使用 `#` 作為分隔符，格式為 `長度#字串本體`。解碼時從第一個 `#` 的位置讀取長度部分，然後從其後方擷取指定字元數
4. **編碼**：對每個字串將 `字串長度 + "#" + 字串本體` 進行串接，構建成一個字串。例如 `["hello", "a#b"]` 會變成 `5#hello3#a#b`
5. **解碼**：從開頭尋找 `#` 並讀取長度，從 `#` 的下一個位置擷取對應長度的字元。將擷取結束的位置作為下一個起始位置，重複此過程。即使字串本體包含 `#`，由於已透過長度確定了準確的範圍，因此不會產生誤判
6. **最終回傳的結果**：`encode` 回傳串接後的一個 `String`，`decode` 回傳從該 `String` 還原的 `List<String>`

## 前置知識

### 什麼是 StringBuilder

StringBuilder 是一個用於高效串接字串的類別。使用 `String` 的 `+` 運算子進行串接時，每次都會產生新的 `String` 物件，而 `StringBuilder` 透過在內部緩衝區中追加內容，能以 O(1) 的時間複雜度完成串接。

```java
StringBuilder sb = new StringBuilder();  // 建立空的 StringBuilder
sb.append("hello");                      // 在末尾追加 "hello"
sb.append(5);                            // 在末尾將整數 5 作為字串追加
sb.toString();                           // 回傳結果字串 "hello5"
```

### 什麼是 String.indexOf(char, int)

此方法從指定的起始位置向前搜尋指定的字元，並回傳第一次找到的位置（索引）。如果未找到則回傳 -1。

```java
String str = "12#hello";
str.indexOf('#', 0);    // 從位置 0 開始搜尋 '#' → 回傳 2
str.indexOf('#', 3);    // 從位置 3 開始搜尋 '#' → 未找到則回傳 -1
```

### 什麼是 String.substring(int, int)

此方法用於擷取字串的指定範圍。第一個參數是起始位置（包含），第二個參數是結束位置（不包含）。

```java
String str = "5#hello";
str.substring(0, 1);    // 從位置 0 到位置 1 之前 → "5"
str.substring(2, 7);    // 從位置 2 到位置 7 之前 → "hello"
```

### 什麼是 Integer.parseInt(String)

此方法是將字串轉換為整數的靜態方法。用於將長度前綴的數值部分讀取為整數。

```java
Integer.parseInt("5");    // 將字串 "5" 轉換為整數 5
Integer.parseInt("123");  // 將字串 "123" 轉換為整數 123
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n × k) — n 為字串的個數，k 為字串的平均長度。對所有字串各處理一次 |
| Space | O(n × k) — 編碼結果或解碼結果需要使用所有字串總量的空間 |

## 程式碼

```java
// === encode ===
// 輸入：字串列表 strs（List<String>）
// 輸出：回傳將所有字串合併為一個的 String
public String encode(List<String> strs) {
    // 使用 StringBuilder 以在迴圈中高效地進行字串串接
    StringBuilder sb = new StringBuilder();
    // 從頭開始依序走訪列表中的每個字串
    for (String str : strs) {
        // 在每個字串前面附加「長度#」後進行串接
        // 先記錄長度，解碼時就能知道字串本體的準確範圍
        sb.append(str.length() + "#" + str);
    }
    // 將 StringBuilder 的內容以 String 形式回傳
    return sb.toString();
}

// === decode ===
// 輸入：編碼後的一個字串 str（String）
// 輸出：回傳還原後的字串列表 List<String>
public List<String> decode(String str) {
    List<String> result = new ArrayList<>();
    // 表示目前讀取位置的變數。從開頭開始
    int i = 0;
    while (i < str.length()) {
        // 從目前位置 i 開始搜尋第一個 '#'，確定長度部分與字串本體的分隔位置
        int separatorIndex = str.indexOf('#', i);
        // 將 '#' 之前的部分讀取為整數，取得字串本體的長度
        int textLength = Integer.parseInt(str.substring(i, separatorIndex));
        // '#' 的下一個位置即為字串本體的起始位置
        int textStart = separatorIndex + 1;
        // 從起始位置往後推進長度個字元即為結束位置。由於透過長度來決定範圍，即使字串本體包含 '#' 也能正確擷取
        int textEnd = textStart + textLength;
        // 擷取字串本體並加入結果列表中
        result.add(str.substring(textStart, textEnd));
        // 將讀取位置移動到下一個字串的長度部分的開頭
        i = textEnd;
    }
    return result;
}
```
