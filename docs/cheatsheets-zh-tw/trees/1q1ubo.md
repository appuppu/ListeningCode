# Constructing a Binary Tree From Traversal Orders — 從前序遍歷與中序遍歷還原二元樹

## 問題的本質

給定整數陣列 `preorder`（前序遍歷）與 `inorder`（中序遍歷）。根據這兩個遍歷結果，構建並返回原始的二元樹。前序遍歷的元素按「根→左→右」的順序排列，中序遍歷的元素按「左→根→右」的順序排列。

## 核心思路

前序遍歷的第一個元素必定是當前子樹的根節點，透過查看該根節點的值在中序遍歷中的位置，就能將中序遍歷分割為「左子樹的元素」與「右子樹的元素」。遞迴地重複這個分割過程，就能還原整棵樹。

## 思考過程

1. **前序遍歷的第一個元素是根節點**：前序遍歷按「根→左→右」的順序排列元素，因此陣列的第一個元素必定是整棵樹的根節點。這個性質對子樹也遞迴成立
2. **在中序遍歷中找到根的位置就能分割左右子樹**：中序遍歷按「左→根→右」的順序排列，因此當根的值位於中序遍歷的位置 `mid` 時，`mid` 左邊的所有元素屬於左子樹，`mid` 右邊的所有元素屬於右子樹
3. **希望快速找到根的位置**：如果每次都對中序遍歷進行線性搜尋，整體時間複雜度為 O(n²)。事先用 HashMap 記錄「值→中序遍歷中的索引」，就能以 O(1) 取得根的位置
4. **用索引邊界表示子樹範圍，而非複製陣列**：如果每次遞迴都複製陣列，需要 O(n²) 的空間。用 `inLeft` 和 `inRight` 兩個索引表示中序遍歷的範圍，就能在不複製陣列的情況下指定子樹的範圍
5. **以全域指標推進前序遍歷**：前序遍歷按「根→整個左子樹→整個右子樹」的順序排列，因此準備一個全域指標 `preIdx`，每取出一個根節點就遞增，當左子樹的遞迴結束時，指標自然指向右子樹的根節點
6. **先構建左子樹**：前序遍歷的順序是「根→左→右」，因此取出根節點後必須先遞迴構建左子樹，然後再構建右子樹。遵守這個順序才能使 `preIdx` 正確推進

## 前置知識

### 前序遍歷（Preorder Traversal）

以「根→左子樹→右子樹」的順序訪問二元樹的遍歷方法。陣列的第一個元素必定是根節點的值。

```
        3
       / \
      9   20
         / \
        15   7

前序遍歷: [3, 9, 20, 15, 7]  ← 開頭的 3 是根節點
```

### 中序遍歷（Inorder Traversal）

以「左子樹→根→右子樹」的順序訪問二元樹的遍歷方法。以根的值為基準，左側的元素屬於左子樹，右側的元素屬於右子樹。

```
中序遍歷: [9, 3, 15, 20, 7]  ← 3 左邊的 [9] 是左子樹，右邊的 [15,20,7] 是右子樹
```

### HashMap

儲存鍵值對的資料結構。透過指定鍵，可以在 O(1) 時間內搜尋和取得對應的值。

```java
HashMap<Integer, Integer> map = new HashMap<>();  // 建立空的 HashMap
map.put(3, 1);           // 將值 1 存入鍵 3
map.get(3);              // 返回鍵 3 對應的值 → 1
```

### TreeNode

表示二元樹中一個節點的類別。擁有值 `val`、左子節點 `left`、右子節點 `right`。

```java
TreeNode root = new TreeNode(3);    // 建立值為 3 的節點
root.left = new TreeNode(9);        // 將左子節點設定為值 9 的節點
root.right = new TreeNode(20);      // 將右子節點設定為值 20 的節點
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 每個節點只處理一次，透過 HashMap 的查詢為 O(1) |
| Space | O(n) — HashMap 中儲存 n 個元素，遞迴堆疊最差為 O(n)（樹偏斜的情況） |

## 程式碼

```java
// 輸入：整數陣列 preorder（前序遍歷）與整數陣列 inorder（中序遍歷）
// 輸出：返回還原後的二元樹根節點 TreeNode

// 鍵=中序遍歷的值，值=該值在中序遍歷中的索引，儲存於 HashMap 中
// 用於以 O(1) 從根的值取得其在中序遍歷中的位置
Map<Integer, Integer> map = new HashMap<>();
// 指向前序遍歷陣列中「下一個應取出的根節點位置」的全域指標
// 每次遞迴呼叫時遞增推進
int preIdx = 0;

public TreeNode buildTree(int[] preorder, int[] inorder) {
    // 將中序遍歷的每個值及其索引註冊到 HashMap 中
    // 這樣就能立即查出任意值在中序遍歷中的位置
    for (int i = 0; i < inorder.length; i++)
        map.put(inorder[i], i);

    // 指定整個陣列的範圍（inLeft=0, inRight=末尾）開始遞迴
    return helper(preorder, 0, inorder.length - 1);
}

// inLeft, inRight 表示中序遍歷陣列上當前子樹的範圍
TreeNode helper(int[] preorder, int inLeft, int inRight) {
    // 子樹的範圍為空（inLeft > inRight）時，子節點不存在
    if (inLeft > inRight) return null;

    // 從前序遍歷的當前位置取出根的值，並推進指標
    int rootVal = preorder[preIdx++];
    TreeNode root = new TreeNode(rootVal);

    // 透過 HashMap 取得根的值在中序遍歷中的位置
    // mid 表示中序遍歷中左子樹與右子樹的分界點
    int mid = map.get(rootVal);

    // 注意：前序遍歷按「根→左→右」的順序排列，因此必須先構建左子樹
    // 遵守這個順序才能使 preIdx 正確指向右子樹的根節點
    // 中序遍歷中從 inLeft 到 mid-1 的範圍是左子樹
    root.left = helper(preorder, inLeft, mid - 1);
    // 中序遍歷中從 mid+1 到 inRight 的範圍是右子樹
    root.right = helper(preorder, mid + 1, inRight);

    // 返回構建好的 root 節點。當所有遞迴完成時，返回整棵樹的根節點
    return root;
}
```
