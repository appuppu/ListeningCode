# Deep Copying a Linked List With Random Pointers — ランダムポインタ付き連結リストの完全な複製を作る

## 問題の本質

各ノードが `next` ポインタに加えて、リスト内の任意のノード（または null）を指す `random` ポインタを持つ連結リストが与えられる。この連結リストの**ディープコピー**（完全に独立した複製）を作成して返す。コピー先のノードの `random` は、元のリストではなくコピー先リスト内の対応するノードを指す必要がある。

## 核心のアイデア

コピーしたノードを元のノードの直後に挿入（インターリーブ）すれば、元ノードの `random` の「次のノード」がコピー側の対応ノードになる。この構造的な関係を利用すると、HashMapなしでO(1)空間でランダムポインタを正しく設定できる。

## 思考プロセス

1. **難しいのはrandomポインタの対応付け**: `next` ポインタだけなら単純に順番にコピーすればよいが、`random` は任意のノードを指すため、元ノードとコピーノードの対応関係を知る手段が必要になる
2. **HashMapを使えばO(n)空間で解ける、しかしO(1)にできないか**: 元ノード→コピーノードの対応をHashMapに保存すれば解けるが、追加のデータ構造を使わずにリスト自体の構造で対応関係を表現できないかを考える
3. **コピーノードを元ノードの直後に挿入する**: 元ノード A の直後にコピー A' を挿入すると、`A → A' → B → B' → C → C'` というインターリーブ構造になる。こうすると、任意の元ノード `X` に対して `X.next` が必ずコピー `X'` になるという対応関係がリスト構造自体に埋め込まれる
4. **randomポインタをインターリーブ構造で設定する**: 元ノード `curr` の `random` が別の元ノード `R` を指しているとき、コピーノード `curr.next` の `random` は `R` のコピー、つまり `R.next` に設定すればよい。つまり `curr.next.random = curr.random.next` という式で一括設定できる
5. **2つのリストを分離する**: randomポインタの設定後、インターリーブされたリストから元のリストとコピーのリストを交互に取り出して分離する。元のリストも元通りに復元する必要がある
6. **3つのパスで完了する**: 第1パスでコピーノードを挿入、第2パスでrandomポインタを設定、第3パスでリストを分離する。各パスはO(n)で、追加のデータ構造を使わないのでSpace O(1)となる

## 前提知識

### 連結リストのノード構造（random付き）

通常の連結リストの `next` に加えて、リスト内の任意のノードを指す `random` ポインタを持つ特殊なノード。`random` は `null` の場合もある。

```java
class Node {
    int val;
    Node next;      // 次のノードを指す（通常の連結リスト）
    Node random;    // リスト内の任意のノードまたはnullを指す

    Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
```

### ディープコピーとは

元のオブジェクトと完全に独立した複製を作ること。コピー先のノードが元のリストのノードを参照してはならない。すべてのポインタ（`next` と `random`）がコピー先リスト内のノードだけを指す必要がある。

```java
// シャローコピー（NG）: copy.random が元のリストのノードを指してしまう
copy.random = original.random;

// ディープコピー（OK）: copy.random がコピー先の対応ノードを指す
copy.random = originalToCopyMapping(original.random);
```

### インターリーブ（交互配置）とは

2つの列の要素を交互に並べること。この問題では、元のリストのノード間にコピーノードを挿入し、`A → A' → B → B' → C → C'` という構造を作る。これにより、元ノード `X` のコピーは常に `X.next` でアクセスできる。

```java
// 元のリスト:        A → B → C → null
// インターリーブ後:   A → A' → B → B' → C → C' → null
// A のコピーは A.next、B のコピーは B.next でアクセス可能
```

## 計算量

| | 値 |
|---|---|
| Time | O(n) — リストを3回走査する。各パスはO(n)なので合計O(3n) = O(n) |
| Space | O(1) — 出力用のコピーノード以外に追加のデータ構造を使用しない |

## コード

```java
// 入力: random ポインタ付き連結リストの先頭ノード head
// 出力: 入力リストのディープコピーの先頭ノードを返す
public Node copyRandomList(Node head) {
    // 空のリストには何もコピーするものがない
    if (head == null) return null;

    // === 第1パス: 各元ノードの直後にコピーノードを挿入する ===
    // このパスが終わると A → A' → B → B' → C → C' というインターリーブ構造になる
    Node curr = head;
    while (curr != null) {
        // 元ノードと同じ値を持つ新しいコピーノードを作成する
        Node copy = new Node(curr.val);
        copy.next = curr.next;       // コピーの次を元の次に設定する
        curr.next = copy;            // 元の次をコピーに設定して、currの直後に挿入する
        curr = copy.next;            // copy.next は元の次のノード。次の元ノードに進む
    }

    // === 第2パス: インターリーブ構造を利用してrandomポインタを設定する ===
    curr = head;
    while (curr != null) {
        // curr.next はコピーノード、curr.random.next はrandom先のコピーノード
        // curr.random が null の場合はコピーの random も null のままにする
        curr.next.random =
            curr.random != null
            ? curr.random.next : null;
        curr = curr.next.next;       // コピーノードを飛ばして次の元ノードに進む
    }

    // === 第3パス: インターリーブされたリストを元のリストとコピーのリストに分離する ===
    // 元のリストも元通りに復元する必要がある
    curr = head;
    Node copyHead = head.next;       // コピーリストの先頭を保存する。これが最終的な返り値になる
    while (curr != null) {
        Node copy = curr.next;       // コピーノードを取得する
        curr.next = copy.next;       // 元のリストのnextを復元する（コピーを飛ばして元の次のノードへ）
        copy.next = copy.next != null
            ? copy.next.next : null;  // コピーリストのnextをつなげる（元ノードを飛ばしてコピーの次へ）
        curr = curr.next;            // 復元した元の次のノードに進む
    }

    // copyHead がディープコピーされたリストの先頭である
    return copyHead;
}
```
