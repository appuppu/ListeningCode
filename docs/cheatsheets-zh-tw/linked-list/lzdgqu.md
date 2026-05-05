# Deep Copying a Linked List With Random Pointers — 建立帶有隨機指標的鏈結串列的完整複製

## 問題的本質

給定一個鏈結串列，其中每個節點除了 `next` 指標之外，還擁有一個指向串列中任意節點（或 null）的 `random` 指標。需要建立並回傳該鏈結串列的**深層複製**（完全獨立的複製品）。複製後的節點的 `random` 必須指向複製串列中對應的節點，而非原始串列中的節點。

## 核心概念

將複製的節點插入到原始節點的正後方（交錯排列），這樣原始節點的 `random` 的「下一個節點」就會成為複製側的對應節點。利用這種結構性的關係，就能在不使用 HashMap 的情況下，以 O(1) 空間正確設定隨機指標。

## 思考過程

1. **困難之處在於 random 指標的對應關係**：如果只有 `next` 指標，只需按順序逐一複製即可，但 `random` 指向任意節點，因此需要一種手段來得知原始節點與複製節點之間的對應關係
2. **使用 HashMap 可以用 O(n) 空間解決，但能否達到 O(1)**：雖然將原始節點→複製節點的對應關係儲存在 HashMap 中即可解決，但需要思考是否能不使用額外的資料結構，而是利用串列本身的結構來表達對應關係
3. **將複製節點插入到原始節點的正後方**：將複製 A' 插入到原始節點 A 的正後方，就會形成 `A → A' → B → B' → C → C'` 的交錯結構。如此一來，對於任意原始節點 `X`，`X.next` 必定是其複製 `X'`，這種對應關係就被嵌入到串列結構本身中
4. **利用交錯結構設定 random 指標**：當原始節點 `curr` 的 `random` 指向另一個原始節點 `R` 時，複製節點 `curr.next` 的 `random` 應設定為 `R` 的複製，即 `R.next`。換言之，可以用 `curr.next.random = curr.random.next` 這個公式統一設定
5. **將兩個串列分離**：設定完 random 指標後，從交錯排列的串列中交替取出原始串列和複製串列並加以分離。原始串列也必須恢復原狀
6. **透過三次遍歷完成**：第一次遍歷插入複製節點，第二次遍歷設定 random 指標，第三次遍歷分離串列。每次遍歷為 O(n)，且不使用額外的資料結構，因此空間複雜度為 O(1)

## 前置知識

### 鏈結串列的節點結構（含 random）

除了一般鏈結串列的 `next` 之外，還擁有一個指向串列中任意節點的 `random` 指標的特殊節點。`random` 也可能為 `null`。

```java
class Node {
    int val;
    Node next;      // 指向下一個節點（一般的鏈結串列）
    Node random;    // 指向串列中的任意節點或 null

    Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
```

### 何謂深層複製

建立與原始物件完全獨立的複製品。複製後的節點不得引用原始串列的節點。所有指標（`next` 和 `random`）都必須僅指向複製串列中的節點。

```java
// 淺層複製（不正確）：copy.random 指向了原始串列的節點
copy.random = original.random;

// 深層複製（正確）：copy.random 指向複製串列中的對應節點
copy.random = originalToCopyMapping(original.random);
```

### 何謂交錯排列

將兩個序列的元素交替排列。在此問題中，將複製節點插入到原始串列的節點之間，建立 `A → A' → B → B' → C → C'` 的結構。藉此，原始節點 `X` 的複製始終可以透過 `X.next` 存取。

```java
// 原始串列：        A → B → C → null
// 交錯排列後：      A → A' → B → B' → C → C' → null
// A 的複製可透過 A.next 存取，B 的複製可透過 B.next 存取
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 遍歷串列三次。每次遍歷為 O(n)，因此總計 O(3n) = O(n) |
| Space | O(1) — 除了輸出用的複製節點之外，不使用額外的資料結構 |

## 程式碼

```java
// 輸入：帶有 random 指標的鏈結串列的頭節點 head
// 輸出：回傳輸入串列的深層複製的頭節點
public Node copyRandomList(Node head) {
    // 空串列沒有任何需要複製的內容
    if (head == null) return null;

    // === 第一次遍歷：在每個原始節點的正後方插入複製節點 ===
    // 此遍歷結束後會形成 A → A' → B → B' → C → C' 的交錯結構
    Node curr = head;
    while (curr != null) {
        // 建立一個與原始節點具有相同值的新複製節點
        Node copy = new Node(curr.val);
        copy.next = curr.next;       // 將複製的 next 設定為原始的 next
        curr.next = copy;            // 將原始的 next 設定為複製，插入到 curr 的正後方
        curr = copy.next;            // copy.next 是原始的下一個節點。前進到下一個原始節點
    }

    // === 第二次遍歷：利用交錯結構設定 random 指標 ===
    curr = head;
    while (curr != null) {
        // curr.next 是複製節點，curr.random.next 是 random 目標的複製節點
        // 若 curr.random 為 null，則複製的 random 也維持為 null
        curr.next.random =
            curr.random != null
            ? curr.random.next : null;
        curr = curr.next.next;       // 跳過複製節點，前進到下一個原始節點
    }

    // === 第三次遍歷：將交錯排列的串列分離為原始串列和複製串列 ===
    // 原始串列也必須恢復原狀
    curr = head;
    Node copyHead = head.next;       // 儲存複製串列的頭節點。這將成為最終的回傳值
    while (curr != null) {
        Node copy = curr.next;       // 取得複製節點
        curr.next = copy.next;       // 恢復原始串列的 next（跳過複製，指向原始的下一個節點）
        copy.next = copy.next != null
            ? copy.next.next : null;  // 連接複製串列的 next（跳過原始節點，指向下一個複製）
        curr = curr.next;            // 前進到已恢復的原始下一個節點
    }

    // copyHead 是深層複製後的串列的頭節點
    return copyHead;
}
```
