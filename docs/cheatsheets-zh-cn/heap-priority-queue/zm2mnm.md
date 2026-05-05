# Finding the Kth Largest Element in an Array — 从未排序数组中找到第K大的元素

## 问题的本质

给定一个整数数组 `nums` 和一个整数 `k`。返回将数组排序后从大到小第 `k` 个位置的元素值。重复的值也分别独立计数（不是第K大的"不同值"）。

## 核心思路

即使不对整个数组排序，只要以枢轴为基准对数组进行分区，就能立即知道"枢轴是第几大的"。通过不断缩小搜索范围，使枢轴的位置达到 `k-1`，就能以平均O(n)的时间复杂度找到目标元素。

## 思考过程

1. **第K大的元素由排序后的索引决定**：如果将数组按降序排列，索引 `k-1` 处的元素就是答案。但完整排序需要O(n log n)的时间，所以需要考虑更高效的方法
2. **只需要确定第K个位置**：不需要知道整体的顺序，只需要确定"第K大的元素是哪个"。利用枢轴将数组分为"大于枢轴的组"和"小于等于枢轴的组"，就能通过枢轴的位置（索引）得知枢轴是第几大的
3. **根据枢轴的位置缩小搜索范围**：partition的结果是枢轴被放置在索引 `p` 处。如果 `p == k-1`，就找到了答案。如果 `p < k-1`，目标元素在枢轴的右侧（较小的一侧），所以将搜索范围缩小为 `p+1` 之后。如果 `p > k-1`，则缩小为左侧
4. **按降序进行partition**：通常QuickSort的partition是升序的，但为了求"第K大的元素"，需要按降序进行partition。也就是说，将大于枢轴的元素集中到左侧。这样，索引 `k-1` 就对应答案的位置
5. **用循环只处理包含答案的一侧**：QuickSort会递归处理两侧，但Quickselect只需处理包含答案的一侧。在 `l <= r` 的范围内用while循环反复执行partition，当 `p == k-1` 时返回该元素

## 前置知识

### 什么是 Quickselect

Quickselect是一种利用与QuickSort相同的partition操作，以平均O(n)的时间从数组中找到第K小（或第K大）元素的算法。与QuickSort递归处理两侧不同，Quickselect只处理一侧，因此平均时间复杂度为O(n)。

### 什么是 partition（分区）

从数组中选择一个枢轴，将大于枢轴的元素移到左侧，将小于等于枢轴的元素移到右侧的操作。操作完成后，枢轴被放置在最终的正确位置上。该位置（索引）表示枢轴的"排名"。

```java
// 降序partition：将大于枢轴的元素集中到左侧
// 返回值：枢轴被放置的索引
int pivot = nums[r];       // 选择最右端的元素作为枢轴
int store = l;             // 指向下一个交换位置的指针
// 如果 nums[i] > pivot，则将 nums[i] 交换到 store 位置并推进 store
// 最后将 pivot 放置到 store 位置 → store 就是枢轴的最终位置
```

### 什么是 swap（元素交换）

交换数组中两个元素位置的操作。通过使用临时变量 `temp` 保存值，防止被覆盖。

```java
int temp = nums[i];    // 将 nums[i] 的值保存到临时变量中
nums[i] = nums[store]; // 将 nums[store] 的值覆盖写入 nums[i]
nums[store] = temp;    // 将之前保存的原 nums[i] 的值写入 nums[store]
```

## 复杂度

| | 值 |
|---|---|
| Time | O(n) 平均 — 因为每次搜索范围平均缩小一半，n + n/2 + n/4 + ... ≈ 2n = O(n) |
| Space | O(1) — 在原数组上就地操作，不使用额外的数据结构 |

## 代码

```java
// 输入：整数数组 nums 和整数 k
// 输出：以 int 形式返回数组中第K大的元素值

// 降序partition：将大于枢轴的元素集中到左侧，返回枢轴的最终位置
private int partition(int[] nums, int l, int r) {
    // 选择搜索范围最右端的元素作为枢轴
    int pivot = nums[r];
    // store 指向"下一个应该放置大于枢轴元素的位置"
    int store = l;

    // 从 l 到 r-1 进行遍历，将大于枢轴的元素集中到左侧
    for (int i = l; i < r; i++) {
        // 如果当前元素大于枢轴，则交换到 store 位置以集中到左侧
        if (nums[i] > pivot) {
            int temp = nums[i];
            nums[i] = nums[store];
            nums[store] = temp;
            // 推进 store，更新下一个大元素的放置位置
            store++;
        }
    }

    // 将枢轴放置到 store 位置（枢轴的最终正确位置）
    // 此时，store 左侧是大于枢轴的元素，右侧是小于等于枢轴的元素
    int temp = nums[store];
    nums[store] = nums[r];
    nums[r] = temp;
    // store 即枢轴的最终位置 = 表示枢轴在降序中的排名
    return store;
}

public int findKthLargest(int[] nums, int k) {
    // 将搜索范围初始化为整个数组
    int l = 0, r = nums.length - 1;

    // 在搜索范围有效期间反复执行partition。每次循环搜索范围都会缩小
    while (l <= r) {
        // 在当前搜索范围内执行partition，获取枢轴的位置
        int p = partition(nums, l, r);

        if (p == k - 1) {
            // 枢轴正好在第K大的位置上，返回答案
            // 降序中从左数起索引 k-1 就是第K大元素的位置
            return nums[p];
        } else if (p < k - 1) {
            // 第K大的元素在枢轴右侧（较小的一侧），缩小搜索范围的左端
            l = p + 1;
        } else {
            // 第K大的元素在枢轴左侧（较大的一侧），缩小搜索范围的右端
            r = p - 1;
        }
    }
    // 根据问题的约束条件，给定的 k 一定有效，因此不会执行到此处
    return -1;
}
```
