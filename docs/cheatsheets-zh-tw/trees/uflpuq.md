# Checking if a Tree is a Subtree of Another — 判定一棵樹是否作為另一棵樹的子樹

## 問題的本質

給定兩棵二元樹 `root` 和 `subRoot`。以 `boolean` 回傳 `root` 中是否存在與 `subRoot` 在結構和值上完全一致的子樹。所謂子樹，是指以 `root` 的某個節點為根時，從該節點往下的整棵樹與 `subRoot` 完全相同。

## 核心思路

將樹透過帶有 null 標記的前序走訪序列化為字串，子樹的判定就能歸結為「某個字串是否包含在另一個字串中」這一字串搜尋問題。

## 思考過程

1. **子樹的匹配判定就是「整棵樹的形狀與值的比較」**：要成為子樹，某個節點以下的結構和所有節點的值必須完全一致。也就是說，需要一種在保存樹的形狀資訊的基礎上進行比較的方法
2. **如果能唯一表示一棵樹，比較就會變得容易**：以樹的結構直接比較，需要對每個節點進行遞迴走訪。將樹序列化為字串後，結構和值的比較就轉變為字串的比較，可以更高效地處理
3. **在前序走訪（preorder）中加入 null 標記以保證唯一性**：僅靠前序走訪，不同的樹可能會產生相同的字串。在子節點為 null 的位置插入 `#` 等標記，就能唯一地編碼樹的結構
4. **在每個節點的值前面加上逗號分隔符**：為了明確值的邊界，在每個節點的值前面加上逗號 `,`。這樣就能防止例如值 `2` 和 `12` 被混淆的情況
5. **子樹的判定歸結為字串的包含判定**：如果將 `root` 序列化後的字串包含了將 `subRoot` 序列化後的字串作為子字串，則 `subRoot` 就是 `root` 的子樹。使用 Java 的 `String.contains()` 可以進行 O(m+n) 的判定

## 前備知識

### 二元樹的前序走訪（Preorder Traversal）

前序走訪是按照「根 → 左子節點 → 右子節點」的順序訪問樹的節點的走訪方法。使用遞迴實作時，先處理當前節點，接著遞迴處理左子樹，最後遞迴處理右子樹。

```java
void preorder(TreeNode node) {
    if (node == null) return;
    System.out.println(node.val);  // 處理根節點
    preorder(node.left);           // 遞迴走訪左子樹
    preorder(node.right);          // 遞迴走訪右子樹
}
```

### StringBuilder

StringBuilder 是用於高效串接字串的類別。`String` 的 `+` 運算子每次串接都會生成新的物件，而 `StringBuilder` 是在內部緩衝區中追加，因此可以以 O(1) 的時間進行追加操作。

```java
StringBuilder sb = new StringBuilder();  // 建立空的 StringBuilder
sb.append(",5");                         // 將字串 ",5" 追加到緩衝區的末尾
sb.append(",#");                         // 將字串 ",#" 追加到緩衝區的末尾
sb.toString();                           // 將緩衝區的內容轉換為 String 型別 → ",5,#"
```

### String.contains()

String.contains() 是一個以 `boolean` 回傳某個字串是否包含另一個字串作為子字串的方法。

```java
String s = ",1,2,#,#,3,#,#";
s.contains(",2,#,#");    // 判定 s 是否包含 ",2,#,#" → true
s.contains(",4,#,#");    // 判定 s 是否包含 ",4,#,#" → false
```

### null 標記

null 標記是在樹的序列化過程中，在子節點不存在（null）的位置插入的特殊符號。通常使用 `#` 作為標記。如果沒有 null 標記，不同結構的樹會產生相同的走訪結果。例如，為了區分只有左子節點的樹和只有右子節點的樹，null 標記是必要的。

## 計算量

| | 值 |
|---|---|
| Time | O(m + n) — 分別對 root（節點數 m）和 subRoot（節點數 n）進行一次走訪並序列化，然後執行字串的包含判定 |
| Space | O(m + n) — 將兩棵樹的序列化結果儲存在 StringBuilder 中 |

## 程式碼

```java
// 輸入：二元樹的根節點 root 和 subRoot
// 輸出：如果 subRoot 是 root 的子樹則回傳 true，否則回傳 false

// 透過前序走訪將樹序列化為字串的輔助方法
void serialize(TreeNode node, StringBuilder sb) {
    if (node == null) {
        // 追加 null 標記 ",#" 以明確表示子節點不存在
        // 這樣就能區分只有左子節點的樹和只有右子節點的樹
        sb.append(",#");
        return;
    }
    // 在值前面加上逗號，以避免值 2 和 12 等數值的邊界變得模糊
    sb.append("," + node.val);
    // 遞迴序列化左子樹
    serialize(node.left, sb);
    // 遞迴序列化右子樹
    serialize(node.right, sb);
}

boolean isSubtree(TreeNode root, TreeNode subRoot) {
    // sb1 儲存 root 的序列化結果，sb2 儲存 subRoot 的序列化結果
    StringBuilder sb1 = new StringBuilder();
    StringBuilder sb2 = new StringBuilder();

    // 透過前序走訪將兩棵樹序列化為字串
    serialize(root, sb1);
    serialize(subRoot, sb2);

    // 如果 root 的字串包含 subRoot 的字串作為子字串，則為子樹
    return sb1.toString().contains(sb2.toString());
}
```
