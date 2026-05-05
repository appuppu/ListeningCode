# Finding the Kth Largest Element in an Array — 從未排序陣列中找出第K大的元素

## 問題的本質

給定一個整數陣列 `nums` 和一個整數 `k`。返回將陣列排序後從大到小數第 `k` 個位置的元素值。重複的值各自獨立計算（不是第K大的「不同值」）。

## 核心思路

即使不對整個陣列進行排序，只要以樞軸為基準將陣列分割，就能立即知道「樞軸是第幾大的元素」。透過不斷將搜尋範圍縮小到其中一側，直到樞軸的位置變成 `k-1`，就能以平均O(n)的時間複雜度找到目標元素。

## 思考過程

1. **第K大的元素由排序後的索引決定**: 若將陣列降序排序，索引 `k-1` 的元素就是答案。但完整排序需要O(n log n)，所以我們考慮更有效率的方法
2. **我們只需要第K個位置**: 不需要知道全體的順序，只需要知道「第K大的元素是哪一個」。使用樞軸將陣列分割成「比樞軸大的群組」和「樞軸以下的群組」，就能從樞軸的位置（索引）得知它是第幾大的元素
3. **根據樞軸的位置縮小搜尋範圍**: partition的結果將樞軸放在索引 `p` 的位置。若 `p == k-1` 則找到答案。若 `p < k-1` 則目標元素在樞軸的右側（較小的一側），將搜尋範圍縮小到 `p+1` 之後。若 `p > k-1` 則縮小到左側
4. **以降序進行partition**: 一般QuickSort的partition是升序的，但為了求「第K大」，我們以降序進行partition。也就是將比樞軸大的元素集中到左側。這樣索引 `k-1` 就對應到答案的位置
5. **用迴圈重複處理其中一側**: QuickSort會遞迴處理兩側，但Quickselect只需要處理包含答案的那一側。用while迴圈在 `l <= r` 的期間重複執行partition，當 `p == k-1` 時返回該元素

## 前提知識

### Quickselect 是什麼

Quickselect是一種使用與QuickSort相同的partition操作，從陣列中以平均O(n)的時間找出第K小（或第K大）元素的演算法。與QuickSort遞迴處理兩側不同，Quickselect只處理其中一側，因此平均時間複雜度為O(n)。

### partition（分割）是什麼

從陣列中選擇一個樞軸，將比樞軸大的元素移到左側，將樞軸以下的元素移到右側的操作。操作完成後，樞軸會被放在最終的正確位置。這個位置（索引）代表樞軸的「排名」。

```java
// 降序partition: 將比樞軸大的元素集中到左側
// 返回值: 樞軸被放置的索引
int pivot = nums[r];       // 選擇最右端的元素作為樞軸
int store = l;             // 指向下一個交換位置的指標
// 若 nums[i] > pivot，將 nums[i] 交換到 store 位置並將 store 前進
// 最後將 pivot 放到 store 位置 → store 就是樞軸的最終位置
```

### swap（元素交換）是什麼

交換陣列中兩個元素位置的操作。使用臨時變數 `temp` 來暫存值，以防止被覆蓋。

```java
int temp = nums[i];    // 將 nums[i] 的值暫存到臨時變數
nums[i] = nums[store]; // 將 nums[store] 的值覆寫到 nums[i]
nums[store] = temp;    // 將先前暫存的原 nums[i] 的值寫入 nums[store]
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) 平均 — 每次搜尋範圍平均縮小一半，因此 n + n/2 + n/4 + ... ≈ 2n = O(n) |
| Space | O(1) — 在原地操作陣列，不使用額外的資料結構 |

## 程式碼

```java
// 輸入: 整數陣列 nums 和整數 k
// 輸出: 以 int 返回陣列中第K大的元素值

// 降序partition: 將比樞軸大的元素集中到左側，返回樞軸的最終位置
private int partition(int[] nums, int l, int r) {
    // 選擇搜尋範圍最右端的元素作為樞軸
    int pivot = nums[r];
    // store 指向「下一個應該放置比樞軸大的元素的位置」
    int store = l;

    // 從 l 到 r-1 進行掃描，將比樞軸大的元素集中到左側
    for (int i = l; i < r; i++) {
        // 若當前元素比樞軸大，則交換到 store 位置以集中到左側
        if (nums[i] > pivot) {
            int temp = nums[i];
            nums[i] = nums[store];
            nums[store] = temp;
            // 將 store 前進一位，更新下一個交換目標位置
            store++;
        }
    }

    // 將樞軸放到 store 位置（樞軸最終的正確位置）
    // 此時，store 左側都是比樞軸大的元素，右側都是樞軸以下的元素
    int temp = nums[store];
    nums[store] = nums[r];
    nums[r] = temp;
    // store 是樞軸的最終位置，代表降序中的「排名」
    return store;
}

public int findKthLargest(int[] nums, int k) {
    // 初始化搜尋範圍的左端和右端。起初整個陣列都是搜尋範圍
    int l = 0, r = nums.length - 1;

    // 每次迴圈迭代都會縮小搜尋範圍
    while (l <= r) {
        // 在當前搜尋範圍 [l, r] 中執行 partition，取得樞軸的位置
        int p = partition(nums, l, r);

        if (p == k - 1) {
            // 樞軸位於第K大的位置。降序中索引 k-1 就是第K大元素的位置
            return nums[p];
        } else if (p < k - 1) {
            // 第K大的元素在樞軸的右側（較小的一側）
            l = p + 1;
        } else {
            // 第K大的元素在樞軸的左側（較大的一側）
            r = p - 1;
        }
    }
    // 根據問題的限制條件，會給定有效的 k，因此不會到達這裡
    return -1;
}
```
