# Merging K Sorted Linked Lists — 將K個已排序鏈結串列合併為一個

## 問題的本質

給定一個包含K個已排序鏈結串列（Linked List）的陣列。需要將所有串列合併為**一個已排序的鏈結串列**，並回傳其頭節點。每個串列各自已排序完成，合併後的串列也必須維持升序排列。

## 核心概念

不是一次合併K個串列，而是每次將兩個串列配對進行合併。每一輪串列數量減半，因此經過 log k 輪即可收斂為一個串列，對全部N個元素可達成O(N log k)的效率。

## 思考過程

1. **基本操作是「合併兩個已排序串列」**：將K個串列合併的問題，可以分解為「將兩個已排序串列合併為一個」這個基本操作的組合。合併兩個串列時，只需反覆比較兩個串列的頭部並選擇較小的一方，即可在O(n)時間內完成
2. **如何將此基本操作應用於K個串列**：若單純地將第1個和第2個合併，再將結果與第3個合併……依序進行則時間複雜度為O(Nk)。因為每次合併結果會越來越長，後半段的合併成本越來越高
3. **成對合併可使成本均勻分配**：將串列兩兩配對合併，每一輪只需處理所有元素各一次。由於串列數量每輪減半，輪數為 log k，整體可達成O(N log k)
4. **使用陣列索引管理配對**：將`interval`變數以1, 2, 4, 8…倍增，將`lists[i]`與`lists[i + interval]`合併後存入`lists[i]`。如此無需額外陣列，即可原地實現成對合併
5. **所有輪次結束後，lists[0]即為最終結果**：每一輪的合併結果會集中到`lists[0]`、`lists[2]`、`lists[4]`…等偶數索引位置，最終所有元素都會被合併到`lists[0]`中

## 前置知識

### ListNode（鏈結串列的節點）

表示鏈結串列中各元素的類別。`val`儲存值，`next`儲存對下一個節點的參照。`next`為`null`的節點即為串列的末尾。

```java
class ListNode {
    int val;              // 此節點儲存的值
    ListNode next;        // 對下一個節點的參照（若為末尾則為null）
    ListNode(int val) {   // 建構子：指定值來建立節點
        this.val = val;
    }
}
```

### 虛擬節點（Sentinel Node）

一種簡化串列建構的技巧。在串列開頭放置一個值為0的虛擬節點，在其後方連接實際的節點。最後回傳`dummy.next`，即可省去對頭節點的特殊處理。

```java
ListNode dummy = new ListNode(0);  // 建立虛擬節點
ListNode tail = dummy;             // tail是追蹤末尾的指標
tail.next = someNode;              // 在虛擬節點後方連接節點
tail = tail.next;                  // 將tail推進到末尾
return dummy.next;                 // 回傳虛擬節點的下一個，即實際的頭節點
```

### 分治法（Divide and Conquer）

將問題分割為較小的子問題，解決子問題後再合併結果的方法。合併排序是其代表性範例，將陣列逐次對半分割，再合併已排序的子陣列。本問題中則是將K個串列兩兩配對反覆合併。

```java
// interval以1, 2, 4, 8...倍增，逐步擴大配對的間隔
for (int interval = 1; interval < n; interval *= 2) {
    // 每一輪依序合併各配對
    for (int i = 0; i < n - interval; i += 2 * interval) {
        lists[i] = merge(lists[i], lists[i + interval]);
    }
}
```

## 複雜度

| | 值 |
|---|---|
| Time | O(N log k) — 每一輪處理全部N個元素各一次，共進行 log k 輪 |
| Space | O(log k) — 不使用遞迴，但需要對應合併輪數的迴圈堆疊空間 |

## 程式碼

```java
// 輸入：已排序鏈結串列的陣列 ListNode[] lists（包含K個元素）
// 輸出：回傳將所有串列合併為一個已排序鏈結串列的頭節點 ListNode

// 將兩個已排序串列合併為一個的輔助方法
private ListNode mergeTwoLists(ListNode a, ListNode b) {
    // 建立虛擬節點，作為合併結果串列的頭部標記（實際資料從dummy.next開始）
    ListNode dummy = new ListNode(0);
    // tail始終追蹤合併結果的末尾，指示連接新節點的位置
    ListNode tail = dummy;

    // 當兩個串列都還有剩餘節點時，選擇較小的一方進行連接（以維持排序順序）
    while (a != null && b != null) {
        if (a.val <= b.val) {
            tail.next = a;  // 將a的當前節點連接到合併結果
            a = a.next;     // 將a推進到下一個節點
        } else {
            tail.next = b;  // 將b的當前節點連接到合併結果
            b = b.next;     // 將b推進到下一個節點
        }
        tail = tail.next;   // 將tail推進到末尾，準備連接下一個節點
    }

    // while迴圈結束後，a或b其中一方仍有剩餘節點。因為兩者都已排序，直接連接即可
    tail.next = (a != null) ? a : b;

    // dummy本身是虛擬節點，其下一個節點才是合併結果的實際頭節點
    return dummy.next;
}

public ListNode mergeKLists(ListNode[] lists) {
    // 輸入為null或空陣列時，不存在需要合併的串列，因此回傳null
    if (lists == null || lists.length == 0) return null;

    // 將串列數量K儲存到n中
    int n = lists.length;

    // 將interval以1, 2, 4, 8...倍增。interval表示合併配對之間的距離，每一輪串列數量減半
    for (int interval = 1; interval < n; interval *= 2) {
        // i < n - interval 此條件確保配對的右側 lists[i + interval] 在陣列範圍內
        for (int i = 0; i < n - interval; i += 2 * interval) {
            // 將配對的合併結果存入lists[i]。右側串列之後不再使用，因此覆寫到左側不會產生問題
            lists[i] = mergeTwoLists(lists[i], lists[i + interval]);
        }
    }

    // 所有輪次結束後，全部串列的合併結果已集中在lists[0]中
    return lists[0];
}
```
