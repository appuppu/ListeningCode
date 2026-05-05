# Traversing a Binary Tree Level by Level — 將二分樹的節點按層級分組並存入列表

## 問題的本質

給定一棵二分樹的 `root`。將樹的節點按**層級（深度）**分組，每個層級的節點值按從左到右的順序存入 `List<Integer>`，再將所有層級的列表按從上到下的順序組成 `List<List<Integer>>` 返回。

## 核心思路

使用佇列（Queue）可以按「廣度優先」的方式從左到右處理節點。在每個層級開始時記錄佇列的大小，只取出該數量的節點，就能精確地管理層級的分界。

## 思考過程

1. **按層級處理適合使用廣度優先搜尋（BFS）**：深度優先搜尋（DFS）會沿著一條分支深入遍歷，因此難以按層級分組。BFS 按照深度由淺到深的順序處理節點，自然對應層級遍歷
2. **使用佇列實現 BFS**：佇列是 FIFO（先進先出）的資料結構，能夠實現「先加入的（較淺的）節點先處理」這一 BFS 的行為
3. **如何判定層級的分界**：在開始處理每個層級時，佇列中的所有節點都屬於同一層級。此時將 `queue.size()` 記錄到變數 `size` 中，取出 `size` 次節點，就能恰好處理一個層級的所有節點
4. **將取出節點的子節點作為下一層級加入佇列**：取出每個節點時，將其左右子節點加入佇列。這些子節點在當前層級的處理過程中不會被取出（因為已用 `size` 限制了次數）。它們會在下一次 while 迴圈的迭代中作為下一層級被處理
5. **將每個層級的結果收集到列表中返回**：為每個層級建立一個 `List<Integer>`，存入該層級的節點值。一個層級處理完成後，將此列表加入最終結果的 `List<List<Integer>>` 中
6. **佇列為空時表示所有層級處理完畢**：當所有節點都被取出後，佇列變為空，while 迴圈結束。此時結果列表中已按從上到下的順序存入了所有層級的節點值

## 前置知識

### Queue（佇列）是什麼

先進先出（FIFO）的資料結構。最先加入的元素最先被取出。在 Java 中使用 LinkedList 作為 Queue 介面的實作。

```java
Queue<TreeNode> queue = new LinkedList<>();  // 建立空的佇列
queue.offer(node);   // 將 node 加入佇列的末尾
queue.poll();        // 從佇列的前端取出並返回元素（該元素從佇列中移除）
queue.size();        // 返回佇列中元素的數量 → int
queue.isEmpty();     // 返回佇列是否為空的 boolean 值
```

### BFS（廣度優先搜尋）是什麼

沿「廣度」方向探索圖或樹的演算法。從離起點近的節點開始依序處理。使用佇列來實作。應用於樹時，會按照層級 0 → 層級 1 → 層級 2… 的順序訪問節點。

### TreeNode 的結構

表示二分樹中每個節點的類別。具有值 `val`、左子節點 `left`、右子節點 `right` 三個欄位。

```java
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
}
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 對樹中所有節點各處理一次 |
| Space | O(n) — 佇列中最多存放樹中最寬層級的節點數（最壞情況為 n/2） |

## 程式碼

```java
// 輸入：二分樹的根節點 root
// 輸出：返回將每個層級的節點值組成列表的 List<List<Integer>>
List<List<Integer>> levelOrder(TreeNode root) {
    // 存放每個層級節點值列表的最終結果
    List<List<Integer>> result = new ArrayList<>();

    // 若 root 為 null 表示樹為空，直接返回空的 result
    if (root == null) return result;

    // 建立 BFS 用的佇列，並加入根節點
    // 此時佇列中只有一個層級 0 的節點
    Queue<TreeNode> queue = new LinkedList<>();
    queue.offer(root);

    // 在佇列為空之前，逐層級重複處理
    // 當佇列為空時，表示所有節點的處理已完成
    while (!queue.isEmpty()) {
        // 注意：必須在迴圈之前將此值保存到變數中
        // 因為在 for 迴圈內會將子節點加入佇列導致佇列大小改變，
        // 若直接將 queue.size() 用作 for 迴圈的條件，將無法正確劃分層級
        int size = queue.size();
        // 存放當前層級節點值的列表
        List<Integer> level = new ArrayList<>();

        for (int i = 0; i < size; i++) {
            // 從佇列前端取出節點
            TreeNode node = queue.poll();
            // 將節點的值加入當前層級的列表
            level.add(node.val);

            // 若左子節點存在則加入佇列（將在下一層級中處理）
            if (node.left != null)
                queue.offer(node.left);
            // 若右子節點存在則加入佇列
            // 透過按左→右的順序加入子節點，下一層級的節點也會按從左到右的順序被處理
            if (node.right != null)
                queue.offer(node.right);
        }

        // 一個層級的處理已完成，將結果加入最終列表
        result.add(level);
    }
    // 返回按從上到下順序存放所有層級節點值的 result
    return result;
}
```
