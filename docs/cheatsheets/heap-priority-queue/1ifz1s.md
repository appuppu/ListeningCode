# Finding the Median From a Data Stream — データストリームから中央値をリアルタイムに求める

## 問題の本質

データストリームから整数が次々と追加される状況で、2つの操作をサポートするデータ構造を設計する。`addNum(int num)` は整数を追加し、`findMedian()` はそれまでに追加された全整数の**中央値**を返す。要素数が奇数なら中央の値、偶数なら中央2つの平均値を返す。

## 核心のアイデア

全要素を「小さい方の半分」と「大きい方の半分」に分割し、それぞれをmax-heapとmin-heapで管理すれば、中央値は常に2つのヒープの先頭から O(1) で取得できる。

## 思考プロセス

1. **中央値は「真ん中」にある**: 中央値を求めるには全要素をソート済みの状態で保持し、真ん中の要素にアクセスする必要がある。しかし、要素追加のたびにソートすると O(n log n) かかる
2. **全要素のソート順は不要で、真ん中だけ分かればよい**: 全要素を「小さい方の半分（lower half）」と「大きい方の半分（upper half）」に二分割すれば、lower halfの最大値とupper halfの最小値が中央値の候補になる
3. **各半分の極値を高速に取得したい**: lower halfの最大値を O(1) で取得するにはmax-heapが、upper halfの最小値を O(1) で取得するにはmin-heapが適している。ヒープへの追加は O(log n) で済む
4. **2つのヒープのサイズバランスを保つ**: 中央値を正しく求めるには、2つのヒープのサイズ差を最大1に保つ必要がある。lo（max-heap）のサイズが hi（min-heap）のサイズ以上になるようにバランスを取る
5. **要素追加時のバランス調整手順**: 新しい要素をまず lo に追加し、lo の最大値を hi に移す。これにより lo の最大値 ≤ hi の最小値が常に保証される。その後、hi のサイズが lo より大きくなった場合は hi の最小値を lo に戻す
6. **中央値の取得**: lo のサイズが hi より大きければ要素数は奇数なので lo の先頭（最大値）が中央値。サイズが等しければ要素数は偶数なので lo の先頭と hi の先頭の平均が中央値

## 前提知識

### PriorityQueue（ヒープ）とは

要素を優先度順に管理するデータ構造。デフォルトではmin-heap（最小値が先頭）として動作する。先頭要素の取得は O(1)、要素の追加・削除は O(log n) で行える。

```java
// min-heap（デフォルト）: 最小値が先頭に来る
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.offer(5);       // 要素5を追加する
minHeap.offer(3);       // 要素3を追加する
minHeap.peek();          // 先頭の最小値を取得する → 3（削除しない）
minHeap.poll();          // 先頭の最小値を取り出す → 3（削除する）

// max-heap: 最大値が先頭に来る（Collections.reverseOrder()を指定）
PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
maxHeap.offer(5);       // 要素5を追加する
maxHeap.offer(3);       // 要素3を追加する
maxHeap.peek();          // 先頭の最大値を取得する → 5
```

### offer / poll / peek の違い

| メソッド | 動作 | 戻り値 |
|---|---|---|
| `offer(e)` | 要素 `e` をヒープに追加する | `boolean`（成功でtrue） |
| `poll()` | 先頭要素を取り出して**削除する** | 取り出した要素（空なら `null`） |
| `peek()` | 先頭要素を**削除せずに**参照する | 先頭の要素（空なら `null`） |

### 中央値（median）とは

ソート済みリストの真ん中の値。要素数が奇数なら中央の1つ、偶数なら中央2つの平均値。
例: `[1, 2, 3]` → 中央値は `2`。`[1, 2, 3, 4]` → 中央値は `(2 + 3) / 2.0 = 2.5`。

## 計算量

| | 値 |
|---|---|
| Time | O(log n) — `addNum` でヒープへの追加・取り出しが最大3回発生し、各操作は O(log n)。`findMedian` は O(1) |
| Space | O(n) — 2つのヒープで全要素を保持する |

## コード

```java
// 入力: addNum(int num) で整数が1つずつストリームとして渡される
// 出力: findMedian() がそれまでに追加された全整数の中央値を double で返す
class MedianFinder {
    // 小さい方の半分を管理するmax-heap（先頭が最大値）
    PriorityQueue<Integer> lo;
    // 大きい方の半分を管理するmin-heap（先頭が最小値）
    PriorityQueue<Integer> hi;

    MedianFinder() {
        // max-heapはCollections.reverseOrder()で大きい順にする
        lo = new PriorityQueue<>(Collections.reverseOrder());
        // min-heapはデフォルトのまま（小さい順）
        hi = new PriorityQueue<>();
    }

    void addNum(int num) {
        // どの要素も最初は小さい方の半分（lo）に入れる
        lo.offer(num);
        // loの最大値をhiに移すことで、loの全要素 ≤ hiの全要素 という大小関係を常に維持する
        hi.offer(lo.poll());

        // hiのサイズがloより大きくなったら、hiの最小値をloに戻してバランスを取る
        // この操作により、loのサイズは常にhiのサイズ以上になる（差は最大1）
        if (hi.size() > lo.size())
            lo.offer(hi.poll());
    }

    double findMedian() {
        // loのサイズが大きい = 全要素数が奇数 → loの先頭（小さい半分の最大値）が中央値
        if (lo.size() > hi.size())
            return lo.peek();

        // サイズが等しい = 全要素数が偶数 → 中央2つの平均を返す
        // 2.0で割ることで整数除算ではなく浮動小数点除算を行う
        return (lo.peek() + hi.peek()) / 2.0;
    }
}
```
