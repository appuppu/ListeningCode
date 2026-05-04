# Serializing and Deserializing a Binary Tree — 二分木を文字列に変換し、元の木構造に復元する

## 問題の本質

二分木を文字列にシリアライズし、その文字列から元の二分木をデシリアライズするアルゴリズムを設計する。ラウンドトリップはロスレスでなければならない — 復元した木は元の木と完全に同一でなければならない。

## 核心のアイデア

Preorder（前順）走査で木をシリアライズすると、各ノードの「左の子→右の子」という構造が再帰的に記録される。null をセンチネル値として明示的に記録しておけば、デシリアライズ時にトークンを先頭から順番に消費するだけで、再帰的に元の木構造を一意に復元できる。

## 思考プロセス

1. **木構造を一意に復元するには何が必要か**: 二分木の構造を一意に決定するには、各ノードの子が存在するか否かの情報が必要である。null の位置を明示的に記録すれば、1つの走査順序だけで木構造を一意に再現できる
2. **Preorder走査が適している理由**: Preorderは「ルート→左部分木→右部分木」の順で訪問する。ルートが最初に来るため、デシリアライズ時にトークンを先頭から消費しながら再帰的にノードを生成できる。走査順序とノード生成順序が一致するので実装が自然になる
3. **null をセンチネル値として記録する**: ノードが null の場合に `"null"` という文字列を記録する。こうすることで、デシリアライズ時に「ここで部分木が終わる」という境界を判定できる。センチネルがなければ部分木の終端を特定できない
4. **シリアライズの形式**: 各ノードの値をカンマ区切りで連結する。形式は `"1,2,null,null,3,4,null,null,5,null,null"` のようになる。カンマで split すればトークンの配列が得られる
5. **デシリアライズは再帰でトークンを消費する**: トークンのリストを先頭から1つずつ poll（取り出し）する。取り出した値が `"null"` なら null を返し、それ以外ならノードを生成して左の子と右の子を再帰的に構築する。LinkedList を使えば先頭からのpollがO(1)でできる
6. **再帰の順序がPreorderと一致する**: シリアライズ時のPreorder順序（ルート→左→右）と、デシリアライズ時の再帰呼び出し順序（ノード生成→左の子→右の子）が完全に一致するため、トークンを順番に消費するだけで正しい木が復元される

## 前提知識

### Preorder（前順）走査とは

二分木を「ルート → 左部分木 → 右部分木」の順序で再帰的に訪問する走査方法。ルートが最初に処理されるため、シリアライズしたデータの先頭が常にルートノードになる。

```java
void preorder(TreeNode node) {
    if (node == null) return;
    visit(node);           // まずルートを処理する
    preorder(node.left);   // 次に左部分木を再帰的に処理する
    preorder(node.right);  // 最後に右部分木を再帰的に処理する
}
```

### StringBuilder とは

文字列を効率的に連結するためのクラス。`+` 演算子による文字列連結は毎回新しいStringオブジェクトを生成するためO(n²)になるが、StringBuilderは内部バッファに追記するのでO(n)で済む。

```java
StringBuilder sb = new StringBuilder();  // 空のStringBuilderを作成
sb.append("hello");                      // 末尾に文字列を追記する
sb.append(",");                          // カンマを追記する
sb.deleteCharAt(sb.length() - 1);        // 末尾の1文字を削除する
sb.toString();                           // Stringに変換する → "hello"
```

### LinkedList と poll メソッド

LinkedList はリストの先頭・末尾への追加・削除がO(1)でできるデータ構造。`poll()` メソッドはリストの先頭要素を取り出して返す（リストから削除される）。空の場合は null を返す。

```java
LinkedList<String> tokens = new LinkedList<>(Arrays.asList("1", "2", "null"));
tokens.poll();  // "1" を返し、リストから削除する。残り: ["2", "null"]
tokens.poll();  // "2" を返し、リストから削除する。残り: ["null"]
```

### センチネル値とは

データの終端や特殊な状態を示すために使用する特別な値。この問題では文字列 `"null"` をセンチネルとして使い、「この位置に子ノードが存在しない」ことを表現する。センチネルがあることで、デシリアライズ時に部分木の境界を正確に判定できる。

## 計算量

| | 値 |
|---|---|
| Time | O(n) — 全n個のノードを1回ずつ訪問する |
| Space | O(n) — シリアライズ文字列とトークンリストにn個分の領域を使用する。再帰のコールスタックは最悪O(n)（偏った木の場合） |

## コード

```java
// 入力: シリアライズ — 二分木のルートノード root。デシリアライズ — カンマ区切り文字列 data
// 出力: シリアライズ — 木を表現するカンマ区切り文字列。デシリアライズ — 元の二分木のルートノード

// 二分木を文字列にシリアライズする
public String serialize(TreeNode root) {
    // 木の全ノードの値をカンマ区切りで蓄積するバッファ
    StringBuilder sb = new StringBuilder();
    // Preorder順序で木を走査し、StringBuilderに値を追記していく
    serHelper(root, sb);
    // 末尾の余分なカンマを削除する
    if (sb.length() > 0)
        sb.deleteCharAt(sb.length() - 1);
    return sb.toString();
}

// Preorder順序で木を走査し、各ノードの値をStringBuilderに追記する
void serHelper(TreeNode node, StringBuilder sb) {
    // nullノードはセンチネル値"null"として記録する（デシリアライズ時に部分木の終端を判定するため）
    if (node == null) {
        sb.append("null,");
        return;
    }
    // 現在のノードの値を記録する（Preorderなのでルートを最初に処理する）
    // 各値はカンマで区切られた形式になる
    sb.append(node.val).append(",");
    // 左部分木を再帰的に処理する
    serHelper(node.left, sb);
    // 右部分木を再帰的に処理する（ルート→左→右の順序がPreorderを実現する）
    serHelper(node.right, sb);
}

// 文字列から二分木をデシリアライズする
public TreeNode deserialize(String data) {
    // 空文字列は空の木を表す
    if (data.isEmpty()) return null;
    // カンマで分割してLinkedListに変換する（先頭からO(1)で取り出すpoll()が必要なため）
    LinkedList<String> tokens =
        new LinkedList<>(Arrays.asList(data.split(",")));
    // トークンを先頭から順に消費しながらノードを再帰的に生成する
    return desHelper(tokens);
}

// トークンを先頭から順に消費しながらノードを再帰的に生成する
TreeNode desHelper(LinkedList<String> tokens) {
    // 先頭トークンを取り出す（pollはリストから要素を削除するため、次の再帰では次のトークンが先頭になる）
    String val = tokens.poll();
    // センチネル値ならnullを返して再帰を終了する（親ノードの子がnullに設定される）
    if (val.equals("null")) return null;
    // トークンの値を整数に変換し、新しいノードを生成する
    TreeNode node = new TreeNode(Integer.parseInt(val));
    // Preorder順序に従い、左の子を先に構築する（シリアライズ時の順序と一致するため正しいトークンが対応する）
    node.left = desHelper(tokens);
    // 次に右の子を構築する
    node.right = desHelper(tokens);
    // 構築したノードを返す（最初の呼び出しの戻り値がルートノード＝復元された木全体）
    return node;
}
```
