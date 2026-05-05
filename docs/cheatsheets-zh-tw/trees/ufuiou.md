# Checking if Two Binary Trees Are Identical — 判斷兩棵二元樹的結構與值是否完全相同

## 問題的本質

給定兩棵二元樹 `p` 與 `q`。兩棵樹「相同」意味著結構完全一致，且所有對應節點的值都相等。若相同則回傳 `true`，否則回傳 `false`。

## 核心思路

將兩棵樹的對應節點作為「配對」放入佇列中，按層級順序逐對取出並比較。若所有配對的結構與值都一致，則兩棵樹相同；只要有一對不一致，即可立即判定為不相同。

## 思考過程

1. **只需比較對應位置的節點**: 要判斷兩棵樹是否相同，只需逐對比較樹中相同位置的節點。若所有配對的值都一致，且結構（子節點的有無）也一致，則兩棵樹相同
2. **如何管理配對**: 需要按順序管理待比較的節點配對。使用佇列（FIFO）可以按廣度優先的方式逐層取出配對進行比較。佇列中儲存 `TreeNode[]` 陣列（元素數為2），`pair[0]` 代表樹p的節點，`pair[1]` 代表樹q的節點
3. **取出配對時需要判斷什麼**: 對取出的配對依序判斷三種情況。（a）若兩者皆為null，表示結構一致，繼續處理下一對；（b）若只有一方為null，表示結構不同，回傳 `false`；（c）若兩者皆非null但值不同，回傳 `false`
4. **通過判斷後將子節點的配對加入佇列**: 若當前配對一致，接下來需要比較的是左子節點配對與右子節點配對。將 `{n1.left, n2.left}` 與 `{n1.right, n2.right}` 兩組加入佇列。即使子節點為null也可以加入（步驟3的null判斷會正確處理）
5. **佇列為空表示所有配對都一致**: 若比較完所有配對都未發現不一致，則兩棵樹相同，回傳 `true`

## 前置知識

### Queue（佇列）是什麼

先進先出（FIFO）的資料結構。最先加入的元素會最先被取出。在廣度優先搜尋中用於按層級順序處理節點。在Java中使用 `LinkedList` 來實作 `Queue` 介面。

```java
Queue<TreeNode[]> queue = new LinkedList<>();  // 建立儲存 TreeNode 陣列的佇列
queue.add(new TreeNode[]{p, q});               // 將配對（含2個元素的陣列）加入佇列末尾
TreeNode[] pair = queue.poll();                 // 從佇列前端取出配對並回傳（佇列為空時回傳null）
queue.isEmpty();                               // 以boolean回傳佇列是否為空 → true/false
```

### TreeNode（二元樹的節點）是什麼

表示二元樹各節點的類別。`val` 欄位儲存節點的值，`left` 與 `right` 欄位分別儲存左子節點與右子節點的參照。若子節點不存在則為 `null`。

```java
TreeNode node = new TreeNode(5);   // 建立值為5的節點
node.val;                          // 取得節點的值 → 5
node.left;                         // 取得左子節點（若不存在則為null）
node.right;                        // 取得右子節點（若不存在則為null）
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 兩棵樹的節點最多各比較n個，每個比較一次 |
| Space | O(n) — 佇列中最多保存與節點數成正比的配對 |

## 程式碼

```java
// 輸入: 兩棵二元樹的根節點 p 與 q
// 輸出: 若兩棵樹的結構與值皆相同則回傳 true，否則回傳 false
public boolean isSameTree(TreeNode p, TreeNode q) {
    // 建立管理待比較節點配對的佇列
    // 配對以元素數為2的 TreeNode[] 陣列儲存，pair[0] 代表樹p的節點，pair[1] 代表樹q的節點
    Queue<TreeNode[]> queue = new LinkedList<>();
    // 將兩棵樹的根節點配對作為初始狀態加入佇列（這是最先需要比較的配對）
    queue.add(new TreeNode[]{p, q});

    // 當佇列不為空時，逐對取出並比較
    while (!queue.isEmpty()) {
        // 從佇列前端取出配對
        TreeNode[] pair = queue.poll();
        TreeNode n1 = pair[0];
        TreeNode n2 = pair[1];

        // 若兩者皆為null，表示在此位置兩棵樹都沒有子節點，結構一致。繼續處理下一對
        if (n1 == null && n2 == null)
            continue;
        // 若只有一方為null，表示一棵樹有節點而另一棵沒有，結構不同
        if (n1 == null || n2 == null)
            return false;
        // 若值不同，表示對應節點的值不一致，回傳false
        if (n1.val != n2.val)
            return false;

        // 當前配對一致，將接下來需要比較的子節點配對加入佇列
        // 即使子節點為null也直接加入（上方的null判斷會正確處理）
        queue.add(new TreeNode[]{n1.left, n2.left});
        queue.add(new TreeNode[]{n1.right, n2.right});
    }
    // 所有配對的結構與值皆一致，回傳true
    return true;
}
```
