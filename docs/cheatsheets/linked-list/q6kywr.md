# Merging K Sorted Linked Lists — K個のソート済み連結リストを1つに統合する

## 問題の本質

K個のソート済み連結リスト（Linked List）の配列が与えられる。これらすべてを**1つのソート済み連結リスト**に統合し、その先頭ノードを返す。各リストは個別にソート済みであり、統合後のリストも昇順を維持する必要がある。

## 核心のアイデア

K個のリストを一度に統合するのではなく、2つずつペアにしてマージを繰り返す。各ラウンドでリスト数が半分になるため、log k ラウンドで1つに収束し、全要素Nに対してO(N log k)の効率を達成できる。

## 思考プロセス

1. **基本操作は「2つのソート済みリストのマージ」**: K個のリストを統合する問題は、「2つのソート済みリストを1つにマージする」という基本操作の組み合わせに分解できる。2つのリストのマージは、先頭同士を比較して小さい方を選ぶことを繰り返せばO(n)で実行できる
2. **K個のリストにこの基本操作をどう適用するか**: 単純に1つ目と2つ目をマージし、その結果と3つ目をマージし…と順番に行うとO(Nk)になる。毎回マージ結果が長くなるため、後半のマージほどコストが高くなるからである
3. **ペアワイズにマージすればコストが均等になる**: リストを2つずつペアにしてマージすれば、各ラウンドで全要素を1回ずつ処理するだけで済む。リスト数は各ラウンドで半分になるため、ラウンド数はlog kとなり、全体でO(N log k)を達成できる
4. **配列のインデックスでペアを管理する**: `interval`変数を1, 2, 4, 8…と倍増させ、`lists[i]`と`lists[i + interval]`をマージして`lists[i]`に格納する。こうすることで追加の配列を使わずにin-placeでペアワイズマージを実現できる
5. **全ラウンド終了後、lists[0]が最終結果になる**: 各ラウンドでマージ結果は`lists[0]`, `lists[2]`, `lists[4]`…と偶数インデックスに集約されていき、最終的に`lists[0]`に全要素が統合される

## 前提知識

### ListNode（連結リストのノード）とは

連結リストの各要素を表すクラス。`val`に値を、`next`に次のノードへの参照を保持する。`next`が`null`のノードがリストの末尾である。

```java
class ListNode {
    int val;              // このノードが保持する値
    ListNode next;        // 次のノードへの参照（末尾ならnull）
    ListNode(int val) {   // コンストラクタ：値を指定してノードを作成
        this.val = val;
    }
}
```

### ダミーノード（Sentinel Node）とは

リスト構築を簡潔にするためのテクニック。値0のダミーノードを先頭に置き、その後ろに実際のノードを繋げていく。最後に`dummy.next`を返すことで、先頭ノードの特別扱いを不要にする。

```java
ListNode dummy = new ListNode(0);  // ダミーノードを作成
ListNode tail = dummy;             // tailは末尾を追跡するポインタ
tail.next = someNode;              // ダミーの後ろにノードを繋げる
tail = tail.next;                  // tailを末尾に進める
return dummy.next;                 // ダミーの次、つまり実際の先頭を返す
```

### 分割統治法（Divide and Conquer）とは

問題を小さなサブ問題に分割し、サブ問題を解いてから結果を統合する手法。マージソートが代表例で、配列を半分ずつに分割し、ソート済みの部分配列をマージする。本問題ではK個のリストを2つずつペアにして繰り返しマージする。

```java
// intervalが1, 2, 4, 8...と倍増し、ペアの間隔を広げていく
for (int interval = 1; interval < n; interval *= 2) {
    // 各ラウンドでペアを順にマージする
    for (int i = 0; i < n - interval; i += 2 * interval) {
        lists[i] = merge(lists[i], lists[i + interval]);
    }
}
```

## 計算量

| | 値 |
|---|---|
| Time | O(N log k) — 全要素N個を各ラウンドで1回ずつ処理し、ラウンド数はlog k回 |
| Space | O(log k) — 再帰を使わないが、マージのラウンド数に対応するループのスタック分 |

## コード

```java
// 入力: ソート済み連結リストの配列 ListNode[] lists（要素数K）
// 出力: 全リストを統合した1つのソート済み連結リストの先頭ノード ListNode を返す

// 2つのソート済みリストを1つにマージする補助メソッド
private ListNode mergeTwoLists(ListNode a, ListNode b) {
    // ダミーノードを作成し、マージ結果リストの先頭の目印とする（実際のデータはdummy.nextから始まる）
    ListNode dummy = new ListNode(0);
    // tailはマージ結果の末尾を常に追跡し、新しいノードを繋げる位置を示す
    ListNode tail = dummy;

    // 両方のリストにノードが残っている間、小さい方を選んで繋げる（ソート順を維持するため）
    while (a != null && b != null) {
        if (a.val <= b.val) {
            tail.next = a;  // aの現在ノードをマージ結果に繋げる
            a = a.next;     // aを次のノードに進める
        } else {
            tail.next = b;  // bの現在ノードをマージ結果に繋げる
            b = b.next;     // bを次のノードに進める
        }
        tail = tail.next;   // tailを末尾に進め、次のノードを繋げる準備をする
    }

    // whileループ終了後、aかbのどちらかに残りのノードがある。両方ソート済みなのでそのまま繋げて問題ない
    tail.next = (a != null) ? a : b;

    // dummy自体はダミーなので、その次のノードがマージ結果の実際の先頭である
    return dummy.next;
}

public ListNode mergeKLists(ListNode[] lists) {
    // 入力がnullまたは空の場合、統合するリストが存在しないためnullを返す
    if (lists == null || lists.length == 0) return null;

    // nにリストの数Kを保存する
    int n = lists.length;

    // intervalを1, 2, 4, 8...と倍増させる。intervalはマージするペア間の距離を表し、各ラウンドでリスト数が半分になる
    for (int interval = 1; interval < n; interval *= 2) {
        // i < n - interval という条件により、ペアの右側 lists[i + interval] が配列の範囲内に存在することを保証する
        for (int i = 0; i < n - interval; i += 2 * interval) {
            // ペアのマージ結果をlists[i]に格納する。右側のリストは以降使わないので左側に上書きして問題ない
            lists[i] = mergeTwoLists(lists[i], lists[i + interval]);
        }
    }

    // 全ラウンド終了後、全リストのマージ結果がlists[0]に集約されている
    return lists[0];
}
```
