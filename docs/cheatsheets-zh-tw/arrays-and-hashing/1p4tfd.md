# Finding Duplicates in an Array — 判定陣列中是否存在重複值

## 問題的本質

給定一個整數陣列 `nums`。如果陣列中有相同的值出現兩次以上，則返回 `true`；如果所有元素都不同，則返回 `false`。

## 核心思路

在遍歷陣列的同時，將已經看過的元素記錄到 HashSet 中，就能以 O(1) 的時間判定每個元素是否已經出現過。一旦發現重複，即可立即返回 `true`。

## 思考過程

1. **判定重複 = 判定「之前是否看過相同的值」**：從頭開始遍歷陣列時，如果當前元素過去已經出現過，那就是重複。也就是說，只要能管理「到目前為止看過的元素集合」，就能檢測出重複
2. **需要快速搜尋過去看過的元素**：要對每個元素以 O(1) 判定「這個值是否已經看過？」，HashSet 是最適合的資料結構。HashSet 能以 O(1) 確認元素是否存在
3. **HashSet 中要保存什麼**：因為問題只需要返回布林值而非索引，所以只保存值本身就足夠了
4. **一邊遍歷一邊構建 HashSet**：從頭依序遍歷陣列，對每個元素判定「是否已經包含在 HashSet 中」。如果已包含則發現重複；如果未包含則將當前元素加入 HashSet 並繼續下一個
5. **透過提前返回提升效率**：一旦發現重複就立即返回 `true`。如果遍歷完整個陣列都沒有發現重複，則返回 `false`

## 前提知識

### HashSet 是什麼

HashSet 是一種管理不重複元素集合的資料結構。元素的添加和存在確認都能以 O(1) 完成。與 HashMap 不同，它不保存鍵值對，而是只保存值。它具有自動排除重複的特性。

```java
HashSet<Integer> set = new HashSet<>();  // 建立空的 HashSet
set.add(10);              // 添加元素 10
set.contains(10);         // 確認元素 10 是否存在，返回 boolean → true
set.contains(5);          // 確認元素 5 是否存在，返回 boolean → false
```

## 計算量

| | 值 |
|---|---|
| Time | O(n) — 只需遍歷陣列一次 |
| Space | O(n) — HashSet 最多保存 n 個元素 |

## 程式碼

```java
// 輸入: 整數陣列 nums
// 輸出: 如果存在重複值則返回 true，如果所有值都不同則返回 false
public boolean containsDuplicate(int[] nums) {
    // 記錄到目前為止已遍歷過的元素的 HashSet
    // 因為問題只要求布林值，所以只保存值就足夠了
    HashSet<Integer> seen = new HashSet<>();

    for (int num : nums) {
        // 如果當前元素已經存在於 HashSet 中，表示相同的值出現了兩次，確認為重複
        if (seen.contains(num)) {
            return true;  // 發現重複的瞬間立即返回（提前返回）
        }

        // 將當前元素加入 HashSet 並繼續下一個
        // 這個元素在之後的遍歷中會被當作「過去看過的元素」來參照
        seen.add(num);
    }
    // 如果迴圈結束後仍未發現重複，則確認所有元素都不同
    return false;
}
```
