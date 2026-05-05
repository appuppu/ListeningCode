# Finding the K Closest Points to the Origin — 找出距離原點最近的K個點

## 問題的本質

給定二維平面上的點陣列 `points` 和整數 `k`，返回距離原點 (0, 0) 的歐幾里得距離最近的 `k` 個點。距離以歐幾里得距離來測量。答案可以任意順序返回。

## 核心思路

求「k個最近的點」不需要完全排序。使用Quickselect演算法，只需用樞紐值分割陣列並找到第k個邊界，左側就會聚集k個最近鄰點。

## 思考過程

1. **完全排序是過度的**：只需返回k個最近鄰點，不要求順序。也就是說，只要能將資料分為「最近的k個」和「其餘的」即可。完全排序需要O(n log n)，但僅做分割可以更快完成
2. **用Quickselect尋找分割位置**：利用Quicksort的分區操作，樞紐值較小的元素會聚集在左側，較大的元素會聚集在右側。當樞紐值的最終位置恰好為k-1時，左側的k個元素就是答案
3. **簡化距離計算**：歐幾里得距離為 `√(x² + y²)`，但若只進行大小比較則不需要平方根，比較 `x² + y²` 即可。這樣可以避免浮點數運算
4. **分區操作的機制**：選擇最右端的元素作為樞紐值，用 `storeIdx` 管理「放置樞紐值以下元素的下一個位置」。掃描過程中若發現樞紐值以下的元素，就與 `storeIdx` 位置交換，並將 `storeIdx` 向前推進
5. **根據樞紐值的最終位置縮小搜尋範圍**：分區後，樞紐值位於 `storeIdx` 的位置。若此位置小於 `k-1`，表示左側元素不足，需搜尋右半部分；若大於等於 `k-1`，則搜尋左半部分。透過這種重複操作，平均以O(n)完成分割
6. **最終返回前k個元素**：迴圈結束時，陣列的前k個元素就是最近鄰點，使用 `Arrays.copyOfRange(points, 0, k)` 擷取並返回

## 前提知識

### Quickselect 是什麼

Quickselect是一種能以平均O(n)時間從陣列中找出第k小元素的演算法。透過僅對Quicksort的分區操作的一側進行遞迴應用，不需要完全排序就能確定目標位置。

```java
// 分區的基本結構
int pivotValue = arr[right];       // 選擇最右端作為樞紐值
int storeIdx = left;               // 放置樞紐值以下元素的位置
for (int i = left; i < right; i++) {
    if (arr[i] <= pivotValue) {    // 若小於等於樞紐值則集中到左側
        swap(arr, i, storeIdx);
        storeIdx++;
    }
}
swap(arr, storeIdx, right);        // 將樞紐值放到正確的位置
// storeIdx 為樞紐值的最終位置
```

### 歐幾里得距離的平方

從原點到某點的距離為 `√(x² + y²)`，但若只進行大小比較，可以省略平方根，直接用 `x² + y²` 來比較。因為平方根函數是單調遞增的，所以距離的大小關係在距離的平方中也會保持不變。

```java
private int dist(int[] point) {
    return point[0] * point[0] + point[1] * point[1];  // x² + y²
}
```

### Arrays.copyOfRange 是什麼

Arrays.copyOfRange是Java的工具方法，用於複製陣列的指定範圍並返回新的陣列。

```java
int[][] result = Arrays.copyOfRange(points, 0, k);  // 複製索引0到k-1的k個元素
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) 平均 — 因為分區僅應用於一側，平均經過 n + n/2 + n/4 + ... = 2n 次比較即可收斂 |
| Space | O(1) — 因為在原地重新排列輸入陣列，不使用額外的記憶體 |

## 程式碼

```java
// 輸入：二維座標陣列 points（每個元素為 [x, y]）和整數 k
// 輸出：返回包含距離原點最近的 k 個點的 int[][]

// 返回點到原點的歐幾里得距離的平方（因為大小比較不需要平方根，所以省略）
private int dist(int[] p) {
    return p[0] * p[0] + p[1] * p[1];
}

public int[][] kClosest(int[][] points, int k) {
    // 初始化搜尋範圍的左端和右端。在此範圍內重複進行分區，使前k個元素成為最近鄰點
    int left = 0;
    int right = points.length - 1;

    // 重複進行分區，直到前k個元素成為最近鄰點
    while (left < right) {
        // 選擇最右端的點作為樞紐值，並計算其歐幾里得距離的平方（x² + y²）
        int pivotDist = dist(points[right]);
        // storeIdx 管理「放置距離小於等於樞紐值的點的下一個位置」
        int storeIdx = left;

        // 將每個點的距離與樞紐值比較，將距離小於等於樞紐值的點集中到左側
        for (int i = left; i < right; i++) {
            if (dist(points[i]) <= pivotDist) {
                // 距離小於等於樞紐值，交換到 storeIdx 的位置以集中到左側
                int[] temp = points[i];
                points[i] = points[storeIdx];
                points[storeIdx] = temp;
                storeIdx++;
            }
        }

        // 將樞紐值放置到正確的最終位置 storeIdx。左側為距離小於等於樞紐值的點，右側為距離大於樞紐值的點
        int[] temp = points[storeIdx];
        points[storeIdx] = points[right];
        points[right] = temp;

        // 將樞紐值的最終位置與 k-1 比較，將搜尋範圍縮小一半
        if (storeIdx < k - 1) {
            // 左側元素不足k個，搜尋右側
            left = storeIdx + 1;
        } else {
            // 注意：當 storeIdx 恰好等於 k-1 時，也會縮小 right，使迴圈條件 left < right 變為假，迴圈結束
            right = storeIdx - 1;
        }
    }

    // 迴圈結束後，陣列的前k個元素就是距離原點最近的k個點
    return Arrays.copyOfRange(points, 0, k);
}
```
