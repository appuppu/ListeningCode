# Finding the K Most Frequent Elements — 從陣列中返回出現頻率最高的K個元素

## 問題的本質

給定一個整數陣列 `nums` 和一個整數 `k`。從 `nums` 中選出出現次數最多的前 `k` 個元素，以陣列形式返回。返回的順序不限。題目保證答案是唯一的。

## 核心思路

在計算各元素的出現頻率之後，建立一個以頻率作為索引的桶陣列，就能在不使用排序（O(n log n)）的情況下，以O(n)的時間複雜度按頻率順序取出元素。由於頻率的最大值不會超過陣列長度 `n`，因此桶陣列的大小是有限的。

## 思考過程

1. **首先需要計算各元素的出現次數**: 要求出頻率最高的前K個元素，就需要知道每個元素出現了幾次。使用HashMap，以「數值」作為鍵、「出現次數」作為值來保存，就能在O(n)內統計所有元素的頻率
2. **想要按頻率排序，但排序需要O(n log n)**: 頻率映射表完成後，想要按頻率從高到低取出K個元素。如果用頻率排序，時間複雜度為O(n log n)，但存在更快的方法
3. **使用以頻率作為索引的桶陣列**: 當陣列長度為 `n` 時，任何元素的出現頻率最多為 `n`。因此，準備一個大小為 `n+1` 的陣列，在索引 `i` 的位置存放「出現頻率為 `i` 次的元素列表」。這就是桶排序的思路
4. **從桶陣列的末尾開始遍歷，收集K個元素**: 桶陣列的索引越大，代表出現頻率越高。從末尾（索引 `n`）向前遍歷，如果桶不為空，就將其中的元素加入結果列表。當結果列表的大小達到 `k` 時，將該列表轉換為陣列並返回

## 前置知識

### 什麼是 HashMap

HashMap是一種保存鍵值對的資料結構。指定鍵即可在O(1)時間內搜尋和取得值。在本題中，HashMap被用作計算各數值出現次數的計數器。

```java
HashMap<Integer, Integer> map = new HashMap<>();  // 建立空的HashMap
map.merge(1, 1, Integer::sum);  // 將鍵1的值加1（若鍵不存在則初始化為1）
map.entrySet();                 // 以Set形式返回所有鍵值對
entry.getKey();                 // 從鍵值對中取得鍵
entry.getValue();               // 從鍵值對中取得值
```

### 什麼是 merge 方法

`map.merge(key, value, remappingFunction)` 在鍵不存在時直接存入 `value`，在鍵已存在時使用 `remappingFunction` 將現有值與 `value` 合併。傳入 `Integer::sum` 時，會將 `value` 加到現有值上。merge方法是 `put` + `getOrDefault` 組合的便捷寫法，只需一行即可完成。

```java
map.merge(5, 1, Integer::sum);  // 若鍵5不存在則存入1，若存在則將現有值加1
// 上述程式碼等同於以下寫法
map.put(5, map.getOrDefault(5, 0) + 1);
```

### 什麼是桶排序

桶排序是一種將元素的值本身作為索引來分配到陣列中的排序方法。與基於比較的排序（O(n log n)）不同，只要值的範圍有限，就能在O(n)內完成處理。在本題中，出現頻率（最大為 `n`）被用作索引。

```java
List<Integer>[] buckets = new ArrayList[4];  // 建立索引0～3的桶陣列
buckets[2] = new ArrayList<>();              // 初始化索引2的桶
buckets[2].add(7);                           // 將7存入作為「頻率為2的元素」
// buckets = [null, null, [7], null]
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 構建頻率映射表需要O(n)，構建桶陣列需要O(n)，收集結果需要O(n)，整體為O(n) |
| Space | O(n) — 頻率映射表最多存放n個元素，桶陣列大小為n+1，整體為O(n) |

## 程式碼

```java
// 輸入: 整數陣列 nums 和整數 k
// 輸出: 返回包含出現頻率最高的前 k 個元素的 int[]
public int[] topKFrequent(int[] nums, int k) {
    // 步驟1: 使用HashMap統計各元素的出現頻率
    Map<Integer, Integer> freqMap = buildFrequencyMap(nums);
    // 步驟2: 構建以頻率作為索引的桶陣列
    List<Integer>[] buckets = buildBuckets(freqMap, nums.length);
    // 步驟3: 從桶陣列末尾開始遍歷，收集前K個元素
    return collectTopK(buckets, k);
}

// 使用HashMap統計各元素的出現次數並返回
// 鍵=數值，值=該數值的出現次數
public Map<Integer, Integer> buildFrequencyMap(int[] nums) {
    Map<Integer, Integer> freqMap = new HashMap<>();
    for (int num : nums) {
        // 透過merge方法，若鍵不存在則初始化為1，若存在則將現有值加1
        freqMap.merge(num, 1, Integer::sum);
    }
    // 遍歷完成後，HashMap中已存放所有元素的出現頻率
    return freqMap;
}

// 構建以頻率作為索引的桶陣列並返回
// buckets[i] 中存放出現頻率為i次的元素列表
public List<Integer>[] buildBuckets(Map<Integer, Integer> freqMap, int n) {
    // 大小為n+1是因為某個元素最多可能出現n次，需要使用索引0～n
    List<Integer>[] buckets = new ArrayList[n + 1];
    for (var entry : freqMap.entrySet()) {
        int num = entry.getKey();
        int freq = entry.getValue();
        // 若桶為null，則先建立新的ArrayList再進行添加
        if (buckets[freq] == null) {
            buckets[freq] = new ArrayList<>();
        }
        // 以出現頻率freq作為索引，將數值num添加到對應的桶中
        buckets[freq].add(num);
    }
    return buckets;
}

// 從桶陣列末尾開始遍歷，按頻率從高到低收集K個元素並返回
// 由於索引越大代表出現頻率越高，因此逆序遍歷即可按頻率從高到低取出元素
public int[] collectTopK(List<Integer>[] buckets, int k) {
    List<Integer> result = new ArrayList<>();
    // 從末尾（索引n）向前遍歷。索引0代表「出現頻率為0次」，因此排除在外
    for (int i = buckets.length - 1; i > 0; i--) {
        if (buckets[i] != null) {
            for (int num : buckets[i]) {
                result.add(num);
                // 收集到K個元素時，將列表轉換為陣列並返回
                if (result.size() == k) {
                    return result.stream().mapToInt(Integer::intValue).toArray();
                }
            }
        }
    }
    // 根據題目約束，答案必定存在，因此程式不會執行到此處
    return new int[0];
}
```
