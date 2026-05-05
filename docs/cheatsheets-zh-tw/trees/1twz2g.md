# Serializing and Deserializing a Binary Tree — 將二元樹轉換為字串，並還原為原始樹結構

## 問題的本質

設計一個演算法，將二元樹序列化為字串，並從該字串反序列化還原為原始的二元樹。往返轉換必須是無損的——還原後的樹必須與原始的樹完全一致。

## 核心思路

使用 Preorder（前序）走訪對樹進行序列化時，每個節點的「左子節點→右子節點」結構會被遞迴地記錄下來。只要將 null 作為哨兵值明確記錄，反序列化時只需從頭依序消耗 token，即可透過遞迴唯一地還原原始樹結構。

## 思考過程

1. **要唯一地還原樹結構需要什麼條件**：要唯一地確定二元樹的結構，需要知道每個節點的子節點是否存在的資訊。只要明確記錄 null 的位置，僅憑一種走訪順序就能唯一地重現樹結構
2. **Preorder 走訪適合的原因**：Preorder 按照「根節點→左子樹→右子樹」的順序訪問。由於根節點最先出現，反序列化時可以從頭消耗 token 並遞迴地生成節點。走訪順序與節點生成順序一致，因此實作上非常自然
3. **將 null 作為哨兵值記錄**：當節點為 null 時，記錄 `"null"` 這個字串。如此一來，反序列化時就能判定「子樹在此處結束」的邊界。若沒有哨兵值，就無法確定子樹的終端位置
4. **序列化的格式**：將每個節點的值用逗號連接。格式如 `"1,2,null,null,3,4,null,null,5,null,null"`。用逗號 split 即可得到 token 陣列
5. **反序列化透過遞迴消耗 token**：從 token 列表的頭部逐一 poll（取出）。若取出的值為 `"null"` 則回傳 null，否則生成節點並遞迴地建構左子節點和右子節點。使用 LinkedList 可以讓從頭部 poll 的操作為 O(1)
6. **遞迴的順序與 Preorder 一致**：序列化時的 Preorder 順序（根節點→左→右）與反序列化時的遞迴呼叫順序（生成節點→左子節點→右子節點）完全一致，因此只需依序消耗 token 即可正確還原樹結構

## 先備知識

### 什麼是 Preorder（前序）走訪

一種按照「根節點 → 左子樹 → 右子樹」的順序遞迴訪問二元樹的走訪方法。由於根節點最先被處理，序列化後的資料開頭必定是根節點。

```java
void preorder(TreeNode node) {
    if (node == null) return;
    visit(node);           // 首先處理根節點
    preorder(node.left);   // 接著遞迴處理左子樹
    preorder(node.right);  // 最後遞迴處理右子樹
}
```

### 什麼是 StringBuilder

一個用於高效連接字串的類別。使用 `+` 運算子連接字串時，每次都會產生新的 String 物件，因此時間複雜度為 O(n²)，而 StringBuilder 透過在內部緩衝區追加的方式，時間複雜度僅為 O(n)。

```java
StringBuilder sb = new StringBuilder();  // 建立空的 StringBuilder
sb.append("hello");                      // 在末尾追加字串
sb.append(",");                          // 追加逗號
sb.deleteCharAt(sb.length() - 1);        // 刪除末尾的一個字元
sb.toString();                           // 轉換為 String → "hello"
```

### LinkedList 與 poll 方法

LinkedList 是一種可以在列表的頭部和尾部以 O(1) 進行新增和刪除的資料結構。`poll()` 方法會取出並回傳列表的第一個元素（該元素會從列表中移除）。若列表為空則回傳 null。

```java
LinkedList<String> tokens = new LinkedList<>(Arrays.asList("1", "2", "null"));
tokens.poll();  // 回傳 "1" 並從列表中移除。剩餘: ["2", "null"]
tokens.poll();  // 回傳 "2" 並從列表中移除。剩餘: ["null"]
```

### 什麼是哨兵值

一種用於表示資料的終端或特殊狀態的特殊值。在本題中，使用字串 `"null"` 作為哨兵，表示「該位置不存在子節點」。有了哨兵值，反序列化時就能精確地判定子樹的邊界。

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 對全部 n 個節點各訪問一次 |
| Space | O(n) — 序列化字串和 token 列表佔用 n 個元素的空間。遞迴的呼叫堆疊在最壞情況下為 O(n)（偏斜樹的情況） |

## 程式碼

```java
// 輸入: 序列化 — 二元樹的根節點 root。反序列化 — 逗號分隔字串 data
// 輸出: 序列化 — 表示樹的逗號分隔字串。反序列化 — 原始二元樹的根節點

// 將二元樹序列化為字串
public String serialize(TreeNode root) {
    // 用於以逗號分隔累積樹中所有節點值的緩衝區
    StringBuilder sb = new StringBuilder();
    // 按照 Preorder 順序走訪樹，並將值追加到 StringBuilder
    serHelper(root, sb);
    // 刪除末尾多餘的逗號
    if (sb.length() > 0)
        sb.deleteCharAt(sb.length() - 1);
    return sb.toString();
}

// 按照 Preorder 順序走訪樹，並將每個節點的值追加到 StringBuilder
void serHelper(TreeNode node, StringBuilder sb) {
    // null 節點記錄為哨兵值 "null"（用於反序列化時判定子樹的終端）
    if (node == null) {
        sb.append("null,");
        return;
    }
    // 記錄當前節點的值（因為是 Preorder，所以最先處理根節點）
    // 每個值以逗號分隔的格式記錄
    sb.append(node.val).append(",");
    // 遞迴處理左子樹
    serHelper(node.left, sb);
    // 遞迴處理右子樹（根節點→左→右的順序實現了 Preorder）
    serHelper(node.right, sb);
}

// 從字串反序列化還原二元樹
public TreeNode deserialize(String data) {
    // 空字串表示空的樹
    if (data.isEmpty()) return null;
    // 用逗號分割並轉換為 LinkedList（因為需要從頭部以 O(1) 取出的 poll()）
    LinkedList<String> tokens =
        new LinkedList<>(Arrays.asList(data.split(",")));
    // 從頭部依序消耗 token，同時遞迴地生成節點
    return desHelper(tokens);
}

// 從頭部依序消耗 token，同時遞迴地生成節點
TreeNode desHelper(LinkedList<String> tokens) {
    // 取出頭部的 token（poll 會從列表中移除元素，因此下次遞迴時下一個 token 成為頭部）
    String val = tokens.poll();
    // 若為哨兵值則回傳 null 並結束遞迴（父節點的子節點被設為 null）
    if (val.equals("null")) return null;
    // 將 token 的值轉換為整數，並生成新節點
    TreeNode node = new TreeNode(Integer.parseInt(val));
    // 按照 Preorder 順序，先建構左子節點（與序列化時的順序一致，因此正確的 token 會對應上）
    node.left = desHelper(tokens);
    // 接著建構右子節點
    node.right = desHelper(tokens);
    // 回傳建構好的節點（第一次呼叫的回傳值即為根節點＝還原後的整棵樹）
    return node;
}
```
