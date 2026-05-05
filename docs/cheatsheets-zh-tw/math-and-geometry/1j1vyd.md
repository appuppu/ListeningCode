# Multiplying Two Numbers Represented as Strings — 將以字串表示的兩個數相乘

## 問題的本質

給定兩個表示非負整數的字串 `num1` 和 `num2`，以字串形式返回兩個數的**乘積**。禁止使用內建的大整數函式庫，也禁止將輸入直接轉換為整數。

## 核心思路

直接模擬小學所學的直式乘法運算。關鍵在於：`num1` 的第 i 位與 `num2` 的第 j 位的乘積，會加到結果的第 `i + j` 位和第 `i + j + 1` 位，這個位置對應關係是解題的核心。

## 思考過程

1. **重現直式乘法運算**：由於無法轉換為整數，因此直接實作逐位相乘並累加結果的直式乘法演算法
2. **估算乘積的最大位數**：n 位數與 m 位數的乘積最多為 `n + m` 位（例如：99 × 99 = 9801，2 位 × 2 位 = 4 位）。因此準備一個大小為 `n + m` 的陣列 `pos`，用於儲存每一位的值
3. **確定每位乘積對應結果中的哪個位置**：`num1` 從右數第 i 位與 `num2` 從右數第 j 位的乘積，會影響結果從右數第 `i + j` 位和第 `i + j + 1` 位。以字串索引表示，`num1[i] * num2[j]` 的乘積會加到 `pos[i + j + 1]`（低位）和 `pos[i + j]`（高位）
4. **即時處理進位**：計算每對位數的乘積後，將其與 `pos[p2]` 中已累加的值相加，將除以 10 的餘數留在該位，將除以 10 的商加到高位 `pos[p1]`。如此便能即時處理進位
5. **去除前導零並構建字串**：陣列 `pos` 的開頭可能包含零（例如：3 位 × 2 位的乘積為 4 位時，5 位陣列的開頭會是 0）。在跳過前導零的同時，使用 `StringBuilder` 構建字串
6. **零的特殊處理**：如果任一輸入為 `"0"`，乘積必定為 `"0"`，因此提前返回 `"0"`

## 前置知識

### charAt 與字元轉數值

`String.charAt(i)` 以 `char` 型別返回字串中第 i 個字元。要將 `char` 型別的 `'0'`～`'9'` 轉換為整數 0～9，只需減去 `'0'` 的字元編碼。

```java
String s = "123";
char c = s.charAt(0);       // '1'（char 型別）
int digit = c - '0';        // 1（int 型別）。從 '1' 的編碼 49 減去 '0' 的編碼 48
```

### 直式乘法的位置對應關係

在 n 位 × m 位的直式乘法中，`num1[i]` 與 `num2[j]` 的乘積（最大為 81）可能為兩位數。這兩位分別對應結果的 `pos[i + j]`（高位）和 `pos[i + j + 1]`（低位）。

```
例："12" × "34"
  num1[0]=1, num2[0]=3 → 乘積 3  → 加到 pos[0], pos[1]
  num1[0]=1, num2[1]=4 → 乘積 4  → 加到 pos[1], pos[2]
  num1[1]=2, num2[0]=3 → 乘積 6  → 加到 pos[1], pos[2]
  num1[1]=2, num2[1]=4 → 乘積 8  → 加到 pos[2], pos[3]
```

### StringBuilder

用於高效構建可變長度字串的類別。使用 `append` 在末尾追加字元，最後使用 `toString` 轉換為 `String`。

```java
StringBuilder sb = new StringBuilder();  // 建立空的 StringBuilder
sb.append(4);                            // 末尾追加 "4"
sb.append(0);                            // 變為 "40"
sb.append(8);                            // 變為 "408"
sb.toString();                           // 返回 String 型別的 "408"
sb.length();                             // 返回目前的字元數 → 3
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n × m) — 對 num1 的每一位與 num2 的每一位的所有組合各執行一次乘法 |
| Space | O(n + m) — 儲存乘積各位數的陣列大小為 n + m |

## 程式碼

```java
// 輸入：表示非負整數的字串 num1 和 num2
// 輸出：返回表示兩個數乘積的字串
String multiply(String num1, String num2) {
    // 若任一方為 "0"，乘積必定為 0，因此提前返回 "0" 並結束
    if (num1.equals("0") || num2.equals("0"))
        return "0";

    int n = num1.length();
    int m = num2.length();
    // 儲存乘積各位數的陣列。n 位 × m 位的乘積最多為 n+m 位，因此此大小足夠
    int[] pos = new int[n + m];

    // 與直式乘法相同，從低位（末尾）向高位依序相乘
    for (int i = n - 1; i >= 0; i--) {
        for (int j = m - 1; j >= 0; j--) {
            // 將 charAt 取得的字元減去 '0'，將字元轉換為對應的整數後相乘
            int mul = (num1.charAt(i) - '0')
                * (num2.charAt(j) - '0');
            // 乘積加到的位置：p1 為高位，p2 為低位。此位置關係基於直式乘法中的位數對應
            int p1 = i + j;
            int p2 = i + j + 1;
            // 考慮先前迴圈中已加到相同位置的值，與已累加的值相加
            int sum = mul + pos[p2];
            // 在低位只留一位（除以 10 的餘數），將進位加到高位（除以 10 的商）
            pos[p2] = sum % 10;
            pos[p1] += sum / 10;
        }
    }

    // 跳過前導零並構建字串（例如：5 位陣列的開頭為 0 的情況）
    StringBuilder sb = new StringBuilder();
    for (int p : pos) {
        // 若 StringBuilder 仍為空且目前值為 0，則為前導零，予以跳過
        if (sb.length() == 0 && p == 0)
            continue;
        sb.append(p);
    }
    // 將 StringBuilder 轉換為 String 型別後返回
    return sb.toString();
}
```
