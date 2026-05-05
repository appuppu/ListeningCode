# Viewing a Binary Tree From the Right Side — 返回從右側觀察二元樹時可見的節點值

## 問題的本質

給定一棵二元樹的 `root`。從右側觀察這棵樹時，每個深度只能看到最右邊的節點。請將這些節點的值從上（root）到下依序排列，返回一個 `List<Integer>`。

## 核心思路

若在 DFS 中優先訪問右子節點，則在每個深度最先到達的節點必定是「從右側可見的節點」。只需比較深度與結果列表的大小，即可判定該節點是否為該深度的首次訪問。

## 思考過程

1. **什麼是從右側可見的節點**：在每個深度中位於最右邊的節點就是「從右側可見的節點」。也就是說，這個問題可以歸結為在每個深度各選取一個節點
2. **考慮優先訪問右子節點的 DFS**：在 DFS 走訪樹時，若將右子節點的遞迴呼叫排在左子節點之前，則在每個深度會最先到達最右邊的節點。利用這個性質，只需記錄每個深度首次訪問的節點即可
3. **如何判定「該深度的首次訪問」**：結果列表 `result` 的大小代表「目前已記錄的深度數量」。若當前的 `depth` 等於 `result.size()`，表示該深度的節點尚未被記錄。只有在此條件成立時才執行 `result.add(node.val)`
4. **遞迴的結構**：在每個節點依序執行「若深度為新則記錄值」→「遞迴處理右子節點」→「遞迴處理左子節點」。由於優先訪問右子節點，右側的節點會在每個深度中被優先記錄
5. **基礎情況**：當節點為 `null` 時，直接 `return` 不做任何處理。這使得超過葉節點的遞迴能自然終止
6. **最終返回的內容**：DFS 完成後，`result` 列表中按深度 0 起依序儲存了從右側可見的節點值。直接返回此列表即可

## 先備知識

### DFS（深度優先搜尋）是什麼

DFS 是走訪樹或圖的演算法之一。從某個節點出發，盡可能深入地前進，然後回溯（backtrack）。使用遞迴可以自然地實現。

```java
void dfs(TreeNode node) {
    if (node == null) return;  // 基礎情況：若為 null 則不做任何處理
    // 在此處對 node 進行處理
    dfs(node.left);   // 遞迴走訪左子節點
    dfs(node.right);  // 遞迴走訪右子節點
}
```

### List 的 size() 與 add()

`List` 是可變長度的陣列。`size()` 返回當前的元素數量，`add()` 將元素新增到末尾。元素按新增順序以索引 0, 1, 2... 排列。

```java
List<Integer> list = new ArrayList<>();  // 建立空的列表
list.size();      // 返回當前的元素數量 → 0
list.add(5);      // 將 5 新增到末尾 → [5]
list.add(3);      // 將 3 新增到末尾 → [5, 3]
list.size();      // → 2
```

### depth（深度）是什麼

深度是從樹的根節點到該節點的邊數。根節點的深度為 0，根節點的子節點深度為 1，孫節點的深度為 2。在遞迴呼叫時傳遞 `depth + 1`，即可追蹤每個節點的深度。

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 每個節點恰好訪問一次 |
| Space | O(h) — 遞迴的呼叫堆疊需要樹的高度的空間（h 為樹的高度） |

## 程式碼

```java
// 輸入：二元樹的根節點 root
// 輸出：將從右側可見的節點值從上到下依序儲存的 List<Integer>
List<Integer> rightSideView(TreeNode root) {
    // 儲存每個深度最右邊節點值的列表
    // 列表的索引對應深度（index 0 = depth 0）
    List<Integer> result = new ArrayList<>();
    dfs(root, 0, result);
    // DFS 完成後，result 中按深度 0 起依序儲存了從右側可見的節點值
    return result;
}

void dfs(TreeNode node, int depth,
         List<Integer> result) {
    // 基礎情況：若為 null 則不做任何處理（對葉節點之後不存在的子節點的遞迴在此終止）
    if (node == null) return;

    // 若 depth == result.size()，表示該深度的節點尚未被記錄
    // result.size() 代表「目前已記錄的深度數量」
    if (depth == result.size()) {
        // 由於 DFS 優先訪問右子節點，每個深度最先到達的節點必定是最右邊的節點
        result.add(node.val);
    }

    // 優先訪問右子節點，使每個深度的最右邊節點最先被記錄
    // 這是此演算法的核心：按右→左的順序訪問
    dfs(node.right, depth + 1, result);
    // 在右子節點不存在的深度，左子節點會成為「該深度首次被訪問的節點」，因此能被正確記錄
    dfs(node.left, depth + 1, result);
}
```
