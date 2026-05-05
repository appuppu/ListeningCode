# Evaluating an Expression in Reverse Polish Notation — 計算逆波蘭記法的算術表達式

## 問題的本質

給定一個字串陣列 `tokens`，表示一個逆波蘭記法（RPN）的算術表達式。計算該表達式並以整數形式回傳結果。有效的運算子為 `+`、`-`、`*`、`/` 四種，每個運算元是整數或另一個子表達式。除法向零方向截斷。例如：`["2","1","+","3","*"]` → `((2+1)*3)` → `9`。

## 核心思路

在逆波蘭記法中，不需要處理運算子的優先順序或括號。只需從左到右掃描 token，將數值壓入堆疊，當遇到運算子時取出最上方的兩個數值進行計算並將結果放回堆疊，即可正確計算整個表達式。

## 思考過程

1. **理解 RPN 的性質**：在逆波蘭記法中，運算子作用於其前面的兩個運算元。也就是說，當運算子出現時，對應的兩個運算元已經確定。根據這個性質，「最後加入的元素最先取出」的 LIFO 資料結構——堆疊——是最合適的選擇
2. **根據 token 是數值還是運算子進行分支處理**：依序檢查每個 token，如果是數值就壓入堆疊，如果是運算子就執行計算。僅靠這兩種操作即可計算整個表達式
3. **處理運算子時注意運算元的順序**：從堆疊第一次 pop 的值是右運算元（`a`），第二次 pop 的值是左運算元（`b`）。計算按照 `b 運算子 a` 的順序進行。如果順序搞錯，減法和除法會產生錯誤的結果
4. **將計算結果放回堆疊**：將運算結果 push 回堆疊，使該結果可作為後續運算的運算元。這樣就能自然地處理巢狀的子表達式
5. **最終結果是堆疊中唯一剩餘的值**：如果是有效的 RPN 表達式，處理完所有 token 後堆疊中只會剩下一個計算結果。將該值 pop 出來回傳即可

## 前置知識

### 什麼是 Stack

Stack 是一種後進先出（LIFO）的資料結構。最後加入的元素會最先被取出。元素的加入（push）和取出（pop）操作的時間複雜度均為 O(1)。

```java
Stack<Integer> stack = new Stack<>();  // 建立空的堆疊
stack.push(5);     // 將 5 壓入堆疊頂部 → [5]
stack.push(3);     // 將 3 壓入堆疊頂部 → [5, 3]
stack.pop();       // 取出並回傳頂部元素 → 3，堆疊變為 [5]
stack.pop();       // 取出並回傳頂部元素 → 5，堆疊變為 []
```

### 什麼是逆波蘭記法（RPN）

逆波蘭記法是將運算子置於運算元之後的表示法。一般的中綴記法 `(2 + 1) * 3`，在 RPN 中表示為 `2 1 + 3 *`。不需要括號，只需從左到右依序處理即可正確計算。

```
中綴記法:  (2 + 1) * 3
RPN:       2 1 + 3 *
計算過程:  2 1 + → 3，接著 3 3 * → 9
```

### 什麼是 Integer.parseInt

Integer.parseInt 是 Java 的靜態方法，用於將字串轉換為整數。表示負數的字串（例如：`"-3"`）也能正確轉換。

```java
Integer.parseInt("42");    // → 42
Integer.parseInt("-3");    // → -3
```

## 複雜度

| | 值 |
|---|---|
| Time | O(n) — 只需掃描陣列中的 token 一次 |
| Space | O(n) — 堆疊最多儲存 n 個元素 |

## 程式碼

```java
// 輸入：表示逆波蘭記法算術表達式的字串陣列 tokens
// 輸出：以整數形式回傳表達式的計算結果
public int evalRPN(String[] tokens) {
    // 用於暫時保存數值運算元和中間計算結果的堆疊
    Stack<Integer> stack = new Stack<>();

    // 從頭到尾逐一掃描陣列 tokens
    for (String token : tokens) {
        // 判斷當前 token 是否為運算子（+、-、*、/ 之一）
        switch (token) {
            case "+": {
                int a = stack.pop();  // 第一次 pop → 右運算元
                int b = stack.pop();  // 第二次 pop → 左運算元
                // 將計算結果 push 回堆疊，使其可作為後續運算的運算元
                stack.push(b + a);
                break;
            }
            case "-": {
                int a = stack.pop();
                int b = stack.pop();
                // 注意：pop 的順序是相反的，因此必須按 b - a 的順序計算。若寫成 a - b 則結果會相反
                stack.push(b - a);
                break;
            }
            case "*": {
                int a = stack.pop();
                int b = stack.pop();
                stack.push(b * a);
                break;
            }
            case "/": {
                int a = stack.pop();
                int b = stack.pop();
                // Java 的整數除法會自動向零方向截斷，因此不需要特別處理
                // 注意：pop 的順序是相反的，因此必須按 b / a 的順序計算。若寫成 a / b 則結果會相反
                stack.push(b / a);
                break;
            }
            default: {
                // 將數值 token 轉換為整數並壓入堆疊
                // 負數（例如："-3"）也能被 parseInt 正確處理
                stack.push(Integer.parseInt(token));
            }
        }
    }

    // 如果是有效的 RPN 表達式，處理完所有 token 後堆疊中只會剩下一個結果
    return stack.pop();
}
```
