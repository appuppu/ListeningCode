# Generating All Unique Subsets With Duplicates — 從包含重複元素的陣列中生成所有唯一子集

## 問題的本質

給定一個可能包含重複值的整數陣列 `nums`，返回所有可能的唯一子集。結果中不能包含重複的子集，每個子集中元素的順序可以是任意的。

## 核心思路

只要事先對陣列進行排序，在同一遞迴層級中，當要選擇的元素與前一個元素的值相同時，跳過該元素即可從根本上防止生成重複的子集。

## 思考過程

1. **子集生成是回溯法的經典問題**：對每個元素遞迴地決定「選或不選」，即可列舉所有子集。在遞迴的每個階段將當前子集直接加入結果中，就能獲得所有子集
2. **找出重複的原因**：當陣列中存在多個相同值時，例如 `[1,2,2]` 中選擇第一個 2 和選擇第二個 2 會生成相同的子集。重複發生在「同一遞迴層級中多次選擇相同的值」的時候
3. **透過排序使重複元素相鄰**：對陣列進行排序後，相同值的元素會彼此相鄰。這使得「是否與前一個元素的值相同」可以透過簡單的比較來判定
4. **在同一遞迴層級中跳過重複**：在 for 迴圈中，當滿足 `i > start && nums[i] == nums[i-1]` 條件時，跳過該元素。`i > start` 條件表示「同一遞迴層級中第二個以後的選項」，因此在不同遞迴層級中仍可選擇相同的值（允許子集中包含多個相同的值）
5. **在遞迴的每個階段將結果加入**：在遞迴函式的開頭將當前子集 `curr` 加入結果列表。這樣從空集合到包含所有元素的集合，所有子集都會被包含在結果中
6. **透過回溯恢復原始狀態**：在遞迴呼叫之後刪除 `curr` 的末尾元素以恢復原狀，從而能正確探索下一個選項

## 前置知識

### 什麼是回溯法

回溯法是一種遞迴地構建候選解，當不滿足條件時撤銷上一步的選擇並嘗試其他選擇的搜索方法。常用於列舉子集、排列和組合。

```java
// 回溯法的基本結構
void backtrack(狀態, 選項列表) {
    將當前狀態加入結果;
    for (每個選項) {
        套用選擇;
        backtrack(下一個狀態, 剩餘的選項);
        撤銷選擇;  // ← 回溯
    }
}
```

### 什麼是 Arrays.sort

Arrays.sort 是將陣列按升序排序的方法。透過使重複元素相鄰，可以更容易地判定重複。

```java
int[] nums = {4, 1, 4, 2};
Arrays.sort(nums);  // nums 變為 {1, 2, 4, 4}
```

### 關於 ArrayList 的複製

`new ArrayList<>(list)` 會建立現有列表的淺拷貝。將子集加入結果時，如果加入的是引用而非拷貝，後續的回溯操作會改寫其內容。

```java
List<Integer> curr = new ArrayList<>();
curr.add(1);
curr.add(2);
List<Integer> copy = new ArrayList<>(curr);  // 建立 [1, 2] 的拷貝
curr.remove(curr.size() - 1);               // curr 恢復為 [1]，但 copy 仍為 [1, 2]
```

### List 的末尾刪除

`list.remove(list.size() - 1)` 會刪除列表的末尾元素。在回溯中用於撤銷上一步新增的元素。

```java
List<Integer> curr = new ArrayList<>();
curr.add(5);        // curr = [5]
curr.add(3);        // curr = [5, 3]
curr.remove(curr.size() - 1);  // curr 恢復為 [5]
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n × 2^n) — 最多存在 2^n 個子集，每個子集的複製最多需要 O(n) |
| Space | O(n) — 遞迴深度最大為 n，工作列表 `curr` 的長度最大也為 n（不含結果列表） |

## 程式碼

```java
// 輸入：可能包含重複值的整數陣列 nums
// 輸出：返回包含所有唯一子集的 List<List<Integer>>
void backtrack(int[] nums, int start, List<Integer> curr, List<List<Integer>> result) {
    // 將當前子集的拷貝加入結果
    // 使用 new ArrayList<>(curr) 建立拷貝的原因：curr 在後續遞迴中會改變內容，因此需要保存該時刻的狀態而非引用
    result.add(new ArrayList<>(curr));

    // 從 start 開始遍歷，避免選擇自身之前的元素，從而保持子集中的元素順序
    for (int i = start; i < nums.length; i++) {
        // 在同一遞迴層級中，若當前元素與前一個元素的值相同則跳過，以防止重複
        // i > start：不是該層級的第一個選項（在不同層級中可以選擇相同的值）
        // nums[i] == nums[i-1]：與前一個元素的值相同
        // 當這兩個條件同時成立時，代表在同一層級中第二次選擇相同的值，會產生重複的子集
        if (i > start && nums[i] == nums[i - 1]) continue;

        // 將當前元素加入子集，並進入下一層級
        curr.add(nums[i]);
        // 傳入 i + 1，使下一遞迴層級只能選擇當前元素之後的元素
        backtrack(nums, i + 1, curr, result);

        // 回溯：刪除末尾元素以恢復原始狀態，讓下一次迭代能選擇其他元素
        curr.remove(curr.size() - 1);
    }
}

public List<List<Integer>> subsetsWithDup(int[] nums) {
    // 排序使相同值的元素相鄰，這樣就能透過 nums[i] == nums[i-1] 的簡單比較來判定重複
    Arrays.sort(nums);
    List<List<Integer>> result = new ArrayList<>();
    // 0 表示「從陣列的開頭開始探索」
    backtrack(nums, 0, new ArrayList<>(), result);
    // 所有遞迴完成後，result 中已儲存所有唯一的子集
    return result;
}
```
