# Checking if a Tree is a Subtree of Another — 別の木が部分木として含まれているかを判定する

## 問題の本質

2つの二分木 `root` と `subRoot` が与えられる。`root` の中に、`subRoot` と構造・値ともに完全に一致する部分木が存在するかを `boolean` で返す。部分木とは、`root` のあるノードを根としたときに、そこから下の木全体が `subRoot` と同一であることを意味する。

## 核心のアイデア

木をnullマーカー付きの前順走査で文字列にシリアライズすれば、部分木の判定は「ある文字列が別の文字列に含まれるか」という文字列検索の問題に帰着できる。

## 思考プロセス

1. **部分木の一致判定は「木全体の形と値の比較」である**: 部分木であるためには、あるノード以下の構造と全ノードの値が完全に一致する必要がある。つまり木の形状情報を保存した上で比較する方法が求められる
2. **木を一意に表現できれば比較が容易になる**: 木構造のままでは比較にノードごとの再帰的走査が必要になる。木を文字列にシリアライズすれば、構造と値の比較が文字列の比較に変わり、効率的に処理できる
3. **前順走査（preorder）にnullマーカーを加えて一意性を保証する**: 前順走査だけでは異なる木が同じ文字列になる場合がある。子がnullの位置に `#` などのマーカーを挿入することで、木の構造を一意にエンコードできる
4. **各ノードの値の前にカンマ区切りを付ける**: 値の境界を明確にするために、各ノードの値の前にカンマ `,` を付加する。これにより、例えば値 `2` と `12` が混同されることを防ぐ
5. **部分木の判定は文字列の包含判定に帰着する**: `root` をシリアライズした文字列に `subRoot` をシリアライズした文字列が部分文字列として含まれていれば、`subRoot` は `root` の部分木である。Javaの `String.contains()` でO(m+n)の判定ができる

## 前提知識

### 二分木の前順走査（Preorder Traversal）とは

木のノードを「根 → 左の子 → 右の子」の順番で訪問する走査方法。再帰で実装すると、まず現在のノードを処理し、次に左部分木、最後に右部分木を再帰的に処理する。

```java
void preorder(TreeNode node) {
    if (node == null) return;
    System.out.println(node.val);  // 根を処理する
    preorder(node.left);           // 左部分木を再帰的に走査する
    preorder(node.right);          // 右部分木を再帰的に走査する
}
```

### StringBuilder とは

文字列を効率的に連結するためのクラス。`String` の `+` 演算子は連結のたびに新しいオブジェクトを生成するが、`StringBuilder` は内部バッファに追記するためO(1)で追加できる。

```java
StringBuilder sb = new StringBuilder();  // 空のStringBuilderを作成
sb.append(",5");                         // 文字列 ",5" をバッファの末尾に追加する
sb.append(",#");                         // 文字列 ",#" をバッファの末尾に追加する
sb.toString();                           // バッファの内容をString型に変換する → ",5,#"
```

### String.contains() とは

ある文字列が別の文字列を部分文字列として含んでいるかを `boolean` で返すメソッド。

```java
String s = ",1,2,#,#,3,#,#";
s.contains(",2,#,#");    // sが ",2,#,#" を含むかを判定する → true
s.contains(",4,#,#");    // sが ",4,#,#" を含むかを判定する → false
```

### nullマーカーとは

木のシリアライズにおいて、子ノードが存在しない（null）位置に挿入する特殊な記号。`#` を使うことが多い。nullマーカーがないと、異なる構造の木が同じ走査結果になってしまう。例えば、左の子だけを持つ木と右の子だけを持つ木を区別するためにnullマーカーが必要である。

## 計算量

| | 値 |
|---|---|
| Time | O(m + n) — root（ノード数m）とsubRoot（ノード数n）をそれぞれ1回走査してシリアライズし、文字列の包含判定を行う |
| Space | O(m + n) — 2つの木のシリアライズ結果をStringBuilderに保存する |

## コード

```java
// 入力: 二分木の根ノード root と subRoot
// 出力: subRoot が root の部分木であれば true、そうでなければ false を返す

// 木を前順走査で文字列にシリアライズするヘルパーメソッド
void serialize(TreeNode node, StringBuilder sb) {
    if (node == null) {
        // nullマーカー ",#" を追加して子ノードが存在しないことを明示する
        // これにより左の子だけを持つ木と右の子だけを持つ木を区別できる
        sb.append(",#");
        return;
    }
    // 値の前にカンマを付けることで、値 2 と 12 のような数値の境界が曖昧にならないようにする
    sb.append("," + node.val);
    // 左部分木を再帰的にシリアライズする
    serialize(node.left, sb);
    // 右部分木を再帰的にシリアライズする
    serialize(node.right, sb);
}

boolean isSubtree(TreeNode root, TreeNode subRoot) {
    // sb1 は root のシリアライズ結果、sb2 は subRoot のシリアライズ結果を格納する
    StringBuilder sb1 = new StringBuilder();
    StringBuilder sb2 = new StringBuilder();

    // 両方の木を前順走査で文字列にシリアライズする
    serialize(root, sb1);
    serialize(subRoot, sb2);

    // rootの文字列がsubRootの文字列を部分文字列として含んでいれば部分木である
    return sb1.toString().contains(sb2.toString());
}
```
