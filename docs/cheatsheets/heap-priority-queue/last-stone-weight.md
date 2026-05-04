# Simulating a Last Stone Weight Game — 石を2つずつぶつけて最後に残る石の重さを求める

## 問題の本質

整数の配列 `stones` が与えられる。毎回**最も重い2つの石**を取り出してぶつける。2つの石の重さが等しければ両方とも消滅し、異なれば軽い方が消滅して重い方は差の重さに減る。この操作を石が1つ以下になるまで繰り返し、最後に残った石の重さを返す。石が残らなければ0を返す。

## 核心のアイデア

毎回「最も重い2つ」を効率的に取り出す必要がある。最大ヒープ（Max-Heap）を使えば、最大値の取り出しがO(log n)で行えるため、ソートし直す必要なく常に最重の2石を取得できる。

## 思考プロセス

1. **毎回の操作で必要なのは最大値2つ**: 石をぶつけるルールでは、常に最も重い2つの石を選ぶ。つまり「現在の集合から最大値を2回取り出す」操作を繰り返す問題である
2. **最大値の取り出しを高速に行いたい**: 配列を毎回ソートするとO(n log n)が毎ラウンドかかる。最大ヒープを使えば、最大値の取り出しがO(log n)で済み、要素の挿入もO(log n)で済む
3. **JavaのPriorityQueueをMax-Heapとして使う**: JavaのPriorityQueueはデフォルトでMin-Heap（最小値が先頭）である。`Collections.reverseOrder()` をコンパレータとして渡すことで、最大値が先頭に来るMax-Heapとして動作させる
4. **全ての石をヒープに投入する**: 配列 `stones` の全要素をPriorityQueueに追加する。これでヒープが最大値を管理する準備が整う
5. **石が2つ以上ある間、ぶつける操作を繰り返す**: ヒープから `poll()` で最大値を2回取り出し、差が0でなければ差をヒープに `add()` で戻す。差が0なら何も戻さない（両方消滅）
6. **最後の状態を判定して返す**: ループ終了後、ヒープが空なら全ての石が消滅したので0を返す。ヒープに1つ残っていれば、その石の重さを `poll()` で取り出して返す

## 前提知識

### PriorityQueue（優先度付きキュー）とは

要素を追加すると内部で自動的に順序が管理され、`poll()` で常に最も優先度の高い要素を取り出せるデータ構造。内部実装はヒープ（二分ヒープ）であり、追加・取り出しともにO(log n)で動作する。

```java
// デフォルトはMin-Heap（最小値が先頭）
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.add(5);       // 要素5を追加する
minHeap.add(2);       // 要素2を追加する
minHeap.poll();       // 最小値2を取り出して返す
minHeap.size();       // 現在の要素数を返す → 1
minHeap.isEmpty();    // キューが空かをbooleanで返す → false
```

### Collections.reverseOrder() とは

PriorityQueueのコンストラクタに渡すコンパレータで、デフォルトの昇順（Min-Heap）を降順（Max-Heap）に反転させる。これにより `poll()` が最大値を返すようになる。

```java
// Max-Heap（最大値が先頭）を作成する
PriorityQueue<Integer> maxHeap =
    new PriorityQueue<>(Collections.reverseOrder());
maxHeap.add(3);       // 要素3を追加する
maxHeap.add(7);       // 要素7を追加する
maxHeap.add(1);       // 要素1を追加する
maxHeap.poll();       // 最大値7を取り出して返す
maxHeap.poll();       // 次の最大値3を取り出して返す
```

### Max-Heap の動作イメージ

stones = [2, 7, 4, 1, 8, 1] の場合：
- ヒープに全要素を追加すると、内部で `[8, 7, 4, 1, 2, 1]` のように管理される
- `poll()` → 8を取り出す。ヒープは `[7, 4, 2, 1, 1]` に再構成される
- `poll()` → 7を取り出す。8 - 7 = 1 を `add()` でヒープに戻す

## 計算量

| | 値 |
|---|---|
| Time | O(n log n) — 最大n回のぶつける操作があり、各操作でヒープの取り出し・追加にO(log n)かかる |
| Space | O(n) — ヒープに最大n個の石を保存する |

## コード

```java
// 入力: 整数配列 stones（各要素は石の重さ）
// 出力: 最後に残った石の重さを int で返す。石が残らなければ0を返す
public int lastStoneWeight(int[] stones) {
    // Collections.reverseOrder() をコンパレータに指定し、poll() が最大値を返すMax-Heapを作成する
    PriorityQueue<Integer> pq =
        new PriorityQueue<>(Collections.reverseOrder());

    // 全ての石をヒープに追加する。完了するとヒープが最大値を先頭に管理する状態になる
    for (int s : stones) pq.add(s);

    // 石が2つ以上ある間、最も重い2つをぶつける操作を繰り返す
    while (pq.size() >= 2) {
        // poll() を2回呼び出し、最も重い石と次に重い石を取り出す
        // Max-Heapなので a >= b が常に成り立つ
        int a = pq.poll();
        int b = pq.poll();

        // 重さが異なれば差の石をヒープに戻す。等しければ両方消滅するので何も戻さない
        if (a != b) pq.add(a - b);
    }

    // ヒープが空なら全ての石が消滅したので0、残っていればその石の重さを返す
    return pq.isEmpty() ? 0 : pq.poll();
}
```
