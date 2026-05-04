# Implementing a Prefix Tree — 与えられた文字列の挿入・完全一致検索・接頭辞検索を効率的に行うデータ構造を設計する

## 問題の本質

Trie（接頭辞木）と呼ばれるデータ構造を設計・実装する。このデータ構造は3つの操作をサポートする必要がある：(1) `insert(word)` で単語を挿入する、(2) `search(word)` で完全一致する単語が存在するかを判定する、(3) `startsWith(prefix)` で挿入済みの単語の中に指定された接頭辞で始まるものがあるかを判定する。

## 核心のアイデア

文字列を1文字ずつノードとして木構造に分解すれば、共通の接頭辞を持つ単語同士がノードを共有する。各ノードに「ここで単語が終わるか」を示すフラグを持たせることで、完全一致検索と接頭辞検索の違いは、探索終了時にそのフラグを確認するかしないかだけになる。

## 思考プロセス

1. **文字列を1文字ずつ木構造に展開する**: 挿入する単語を1文字ずつノードとして表現し、親子関係で文字の並び順を表す。こうすれば「apple」と「app」のように共通の接頭辞を持つ単語は、先頭の3ノード（a→p→p）を共有できる
2. **各ノードの子ノードをHashMapで管理する**: 各ノードは次に来る文字に対応する子ノードを持つ。子ノードの管理にはHashMapを使い、キーに「文字」、バリューに「子ノードへの参照」を保存する。こうすれば任意の文字への遷移がO(1)で行える
3. **単語の終端を区別するフラグが必要**: 「apple」を挿入した後、「app」を検索すると、a→p→pとノードは辿れてしまう。しかし「app」は挿入されていないので、falseを返す必要がある。各ノードに `isEnd` フラグを持たせ、`insert` 時に最後のノードで `isEnd = true` にすることで、単語の終端を区別できる
4. **3つの操作はすべてノードの走査が基本**: `insert`・`search`・`startsWith` はいずれもルートから開始し、文字列を1文字ずつ辿ってノードを遷移する。`insert` は遷移先が存在しなければ新しいノードを作成する。`search` と `startsWith` は遷移先が存在しなければ即座にfalseを返す
5. **searchとstartsWithの違いはisEndの確認だけ**: `search` はすべての文字を辿り終えた後に `node.isEnd` がtrueかを確認する。`startsWith` はすべての文字を辿り終えればtrueを返す。走査のロジックは同一で、最後の判定だけが異なる
6. **ルートノードはダミーノード**: Trieの起点となるルートノードは、文字を持たない空のノードとして初期化する。すべての操作はこのルートノードから走査を開始する

## 前提知識

### Trie（トライ）とは

文字列を効率的に格納・検索するための木構造。各ノードが1つの文字に対応し、ルートから葉へのパスが1つの文字列を表す。共通の接頭辞を持つ文字列はノードを共有するため、接頭辞検索が得意なデータ構造である。

```
例: "app", "apple", "bat" を挿入した場合の木構造

      root
      / \
     a   b
     |   |
     p   a
     |   |
     p*  t*
     |
     l
     |
     e*

* は isEnd = true のノード（単語の終端）
```

### HashMap とは

キーと値のペアを保存するデータ構造。キーを指定して値の検索・取得がO(1)でできる。Trieでは、各ノードの子ノードを管理するために使用する。

```java
HashMap<Character, TrieNode> children = new HashMap<>();  // 空のHashMapを作成
children.put('a', new TrieNode());      // キー'a'に新しいノードを格納する
children.containsKey('a');              // キー'a'が存在するかをbooleanで返す → true
children.get('a');                      // キー'a'に対応するノードを返す
children.putIfAbsent('a', new TrieNode());  // キー'a'が未登録の場合のみ格納する
```

### putIfAbsent とは

HashMapのメソッドで、指定したキーがまだ存在しない場合にのみ値を格納する。キーが既に存在する場合は何もしない。`insert` 操作で、既存の経路を壊さずに新しいノードだけを追加するために使用する。

```java
map.putIfAbsent('a', new TrieNode());  // 'a'が未登録なら新しいノードを登録する
map.putIfAbsent('a', new TrieNode());  // 'a'は既に登録済みなので何もしない
```

## 計算量

| | 値 |
|---|---|
| Time | O(m) — insert・search・startsWithのいずれも、文字列の長さmに比例して1回だけ走査する |
| Space | O(n * m) — n個の単語（平均長さm）を格納する。共通接頭辞がノードを共有するため、実際の使用量はこれより少なくなる |

## コード

```java
// 入力: insert(word)は文字列word、search(word)は文字列word、startsWith(prefix)は文字列prefix
// 出力: insertは戻り値なし（Trieに単語を追加する）、searchは完全一致する単語が存在するかをbooleanで返す、startsWithは接頭辞に一致する単語が存在するかをbooleanで返す

// TrieNodeクラス: Trieの各ノードを表す
class TrieNode {
    // 子ノードへのマッピング。キー=文字、バリュー=対応する子ノード
    Map<Character, TrieNode> children;
    // このノードで単語が終わるかを示すフラグ（初期値はfalse）
    // このフラグがあることで、searchが完全一致と接頭辞一致を区別できる
    boolean isEnd;

    TrieNode() {
        children = new HashMap<>();
        isEnd = false;
    }
}

class Trie {
    // すべての操作の起点となるルートノード（文字を持たない空のダミーノード）
    private TrieNode root;

    // コンストラクタで空のTrieNodeをルートとして作成する
    public Trie() {
        root = new TrieNode();
    }

    public void insert(String word) {
        // nodeは現在の走査位置を表すポインタ。ルートから走査を開始する
        TrieNode node = root;
        // 文字列wordを先頭から1文字ずつ走査する
        for (char c : word.toCharArray()) {
            // putIfAbsentで、子ノードが存在しなければ新規作成し、既存なら何もしない
            // putIfAbsentを使うことで、既存の経路（他の単語が共有しているノード）を上書きせずに済む
            node.children.putIfAbsent(c, new TrieNode());
            // ポインタを文字cに対応する子ノードに進める
            node = node.children.get(c);
        }
        // 最後のノードに単語の終端フラグを設定する
        // このフラグにより、searchで「apple」挿入済み・「app」未挿入を区別できる
        node.isEnd = true;
    }

    public boolean search(String word) {
        // ルートから走査を開始する
        TrieNode node = root;
        // 文字列wordを先頭から1文字ずつ走査する
        for (char c : word.toCharArray()) {
            // 対応する子ノードが存在しなければ、この文字に対応する経路がTrieにないので即座にfalse
            if (!node.children.containsKey(c))
                return false;
            // ポインタを子ノードに進める
            node = node.children.get(c);
        }
        // すべての文字を辿り終えたノードが単語の終端であればtrue、そうでなければfalse
        // これにより「apple」が挿入済みで「app」が未挿入のとき、search("app")はfalseを正しく返す
        return node.isEnd;
    }

    public boolean startsWith(String prefix) {
        // ルートから走査を開始する
        TrieNode node = root;
        // 文字列prefixを先頭から1文字ずつ走査する
        for (char c : prefix.toCharArray()) {
            // 対応する子ノードが存在しなければ、この接頭辞に対応する経路がTrieにないので即座にfalse
            if (!node.children.containsKey(c))
                return false;
            // ポインタを子ノードに進める
            node = node.children.get(c);
        }
        // すべての文字を辿れたので、この接頭辞で始まる単語がTrieに存在する
        // searchとの違いはisEndを確認しない点だけ
        return true;
    }
}
```
