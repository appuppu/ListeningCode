# Two Sum — 找出兩個數的總和等於目標值的配對

## 問題的本質

給定一個整數陣列 `nums` 和一個整數 `target`。從 `nums` 中找出總和等於 `target` 的兩個元素，並以陣列形式返回它們的**索引**。解答必定只有一個，且不能重複使用同一個元素。

## 核心思路

在遍歷陣列時，對於每個元素 `nums[i]`，「配對的另一方（target - nums[i]）」是唯一確定的。只要將之前遍歷過的元素記錄在 HashMap 中，就能以 O(1) 的時間確認另一方是否存在，從而在一次遍歷中找到答案。

## 思考過程

1. **配對的另一方可以透過計算求得**：由於要尋找總和等於 `target` 的配對，對於當前元素 `nums[i]`，另一方的值 `complement = target - nums[i]` 是唯一確定的
2. **需要快速判斷另一方是否已經出現過**：在遍歷陣列的同時，將已經遍歷過的數值記錄下來，就能以 O(1) 判斷 complement 是否已被記錄。HashMap 適合用於這種記錄
3. **HashMap 中應該保存什麼**：由於問題要求返回索引，因此將 HashMap 的鍵設為「數值」，值設為「該數值的索引」。這樣就能同時完成另一方的存在確認與索引取得
4. **一邊遍歷一邊建構 HashMap**：從陣列的開頭依序遍歷，對每個元素判斷「complement 是否存在於 HashMap 中」。如果存在則找到配對，如果不存在則將當前元素註冊到 HashMap 中並繼續下一個
5. **註冊必須在判斷之後進行**：如果在判斷之前就將元素註冊到 HashMap，`nums[i]` 本身就會作為 complement 被匹配到。因此必須遵守先判斷、後註冊的順序
6. **最終返回的內容**：當在 HashMap 中找到 complement 時，將 `map.get(complement)`（另一方的索引）和 `i`（當前的索引）以 `int[]` 形式返回

## 前置知識

### 什麼是 HashMap

HashMap 是一種保存鍵值配對的資料結構。透過指定鍵，可以在 O(1) 的時間內搜尋和取得值。它如同一本字典，能以與陣列索引存取相同的速度，透過任意鍵來存取資料。

```java
HashMap<Integer, Integer> map = new HashMap<>();  // 建立空的 HashMap
map.put(10, 0);           // 將值 0 儲存到鍵 10
map.containsKey(10);      // 以 boolean 返回鍵 10 是否存在 → true
map.get(10);              // 返回鍵 10 對應的值 → 0
```

### 什麼是 complement（補數）

complement 是從 `target` 減去當前元素後得到的值，即配對的另一方。透過 `complement = target - nums[i]` 來計算。
例如：當 target=9、nums[i]=2 時，complement=7。如果陣列中存在 7，則配對成立。

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 只需遍歷陣列一次即可完成 |
| Space | O(n) — HashMap 最多保存 n 個元素 |

## 程式碼

```java
// 輸入：整數陣列 nums 和整數 target
// 輸出：以 int[] 返回總和等於 target 的兩個元素的索引
public int[] twoSum(int[] nums, int target) {
    // 鍵=數值、值=該數值的索引 的 HashMap
    // 由於問題要求的是索引而非數值，因此將索引保存在值中
    HashMap<Integer, Integer> map = new HashMap<>();

    for (int i = 0; i < nums.length; i++) {
        // 計算配對的另一方，並存入變數以便在 containsKey 和 get 中重複使用
        int complement = target - nums[i];

        // 如果 complement 已經註冊在 HashMap 中，則找到配對
        if (map.containsKey(complement)) {
            // map.get(complement) 是另一方的索引，i 是當前的索引
            return new int[]{map.get(complement), i};
        }

        // 注意：註冊必須在判斷之後進行。如果先註冊，nums[i] 本身會被匹配到
        map.put(nums[i], i);
    }
    // 根據問題的限制條件，解答必定存在，因此不會執行到這裡
    return new int[]{};
}
```
