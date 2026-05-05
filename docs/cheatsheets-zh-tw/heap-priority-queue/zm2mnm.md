# Finding the Kth Largest Element in an Array — 從未排序陣列中找出第K大的元素

## 問題的本質

給定一個整數陣列 `nums` 和一個整數 `k`。返回將陣列排序後從大到小數第 `k` 個元素的值。重複的值各自獨立計數（不是第K大的「不同值」）。

## 核心思路

即使不對整個陣列進行排序，只要以樞紐為基準將陣列分割，就能立即得知「樞紐是第幾大」。透過不斷縮小搜尋範圍到其中一側，直到樞紐的位置為 `k-1`，就能以平均O(n)的時間找到目標元素。

## 思考過程

1. **第K大的元素由排序後的索引決定**：將陣列降序排序後，索引 `k-1` 的元素即為答案。但完整排序需要O(n log n)，因此考慮更高效的方法
2. **只需要第K個位置**：不需要整體順序，只需知道「第K大的元素是哪一個」。利用樞紐將陣列分為「比樞紐大的群組」和「樞紐以下的群組」，就能從樞紐的位置（索引）得知它是第幾大
3. **根據樞紐位置縮小搜尋範圍**：partition的結果是樞紐被放在索引 `p` 的位置。若 `p == k-1` 則找到答案。若 `p < k-1` 則目標元素在樞紐右側（較小的一側），將搜尋範圍縮小到 `p+1` 以後。若 `p > k-1` 則縮小到左側
4. **以降序進行partition**：一般QuickSort的partition是升序的，但為了求「第K大」，改用降序partition。也就是將比樞紐大的元素集中到左側。這樣索引 `k-1` 就對應答案的位置
5. **用迴圈只重複處理一側**：QuickSort會遞迴處理兩側，但Quickselect只需處理包含答案的那一側。用while迴圈在 `l <= r` 的範圍內重複partition，當 `p == k-1` 時返回該元素

## 前置知識

### 什麼是 Quickselect

Quickselect是一種使用與QuickSort相同的partition操作，以平均O(n)的時間從陣列中找出第K小（或第K大）元素的演算法。QuickSort會遞迴處理兩側，而Quickselect只處理一側，因此平均時間複雜度為O(n)。

### 什麼是 partition（分割）

從陣列中選擇一個樞紐，將比樞紐大的元素移到左側，樞紐以下的元素移到右側的操作。操作完成後，樞紐會被放在最終的正確位置。這個位置（索引）代表樞紐的「排名」。

```java
// 降序partition：將比樞紐大的元素集中到左側
// 返回值：樞紐被放置的索引
int pivot = nums[r];       // 選擇最右邊的元素作為樞紐
int store = l;             // 指向下一個交換位置的指標
// 若 nums[i] > pivot，則將 nums[i] 交換到 store 位置並推進 store
// 最後將 pivot 放到 store 位置 → store 即為樞紐的最終位置
```

### 什麼是 swap（元素交換）

交換陣列中兩個元素位置的操作。使用暫存變數 `temp` 來保存值，以防止被覆蓋。

```java
int temp = nums[i];    // 將 nums[i] 的值保存到暫存變數
nums[i] = nums[store]; // 將 nums[store] 的值覆寫到 nums[i]
nums[store] = temp;    // 將先前保存的原始 nums[i] 值寫入 nums[store]
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) 平均 — 因為每次搜尋範圍平均縮小一半，n + n/2 + n/4 + ... ≈ 2n = O(n) |
| Space | O(1) — 在原地操作陣列，不使用額外的資料結構 |

## 程式碼

```java
// 輸入：整數陣列 nums 和整數 k
// 輸出：以 int 返回陣列中第K大元素的值

// 降序partition：將比樞紐大的元素集中到左側，返回樞紐的最終位置
private int partition(int[] nums, int l, int r) {
    // 選擇搜尋範圍最右邊的元素作為樞紐
    int pivot = nums[r];
    // store 指向「下一個應放置比樞紐大的元素的位置」
    int store = l;

    // 從 l 到 r-1 進行掃描，將比樞紐大的元素集中到左側
    for (int i = l; i < r; i++) {
        // 若當前元素大於樞紐，則交換到 store 位置以集中到左側
        if (nums[i] > pivot) {
            int temp = nums[i];
            nums[i] = nums[store];
            nums[store] = temp;
            // 推進 store 以更新下一個大元素的放置位置
            store++;
        }
    }

    // 將樞紐放置到 store 位置（樞紐最終的正確位置）
    // 此時，store 左側是比樞紐大的元素，右側是樞紐以下的元素
    int temp = nums[store];
    nums[store] = nums[r];
    nums[r] = temp;
    // store 即為樞紐的最終位置 = 代表樞紐在「降序中的排名」
    return store;
}

public int findKthLargest(int[] nums, int k) {
    // 將搜尋範圍初始化為整個陣列
    int l = 0, r = nums.length - 1;

    // 在搜尋範圍有效的期間重複執行partition。每次迴圈搜尋範圍都會縮小
    while (l <= r) {
        // 在當前搜尋範圍執行partition，取得樞紐的位置
        int p = partition(nums, l, r);

        if (p == k - 1) {
            // 樞紐位於第K大的位置，因此返回答案
            // 降序中從左數起索引 k-1 即為第K大元素的位置
            return nums[p];
        } else if (p < k - 1) {
            // 第K大在樞紐右側（較小的一側），因此縮小搜尋範圍的左端
            l = p + 1;
        } else {
            // 第K大在樞紐左側（較大的一側），因此縮小搜尋範圍的右端
            r = p - 1;
        }
    }
    // 根據題目約束，k 一定有效，因此不會到達這裡
    return -1;
}
```
