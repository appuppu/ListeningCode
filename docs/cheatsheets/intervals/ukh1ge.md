# Inserting a New Interval Into a Sorted List — ソート済みの非重複区間リストに新しい区間を挿入しマージする

## 問題の本質

ソート済みで互いに重複しない区間のリスト `intervals` と、新しい区間 `newInterval` が与えられる。`newInterval` を正しい位置に挿入し、重複する区間があればすべてマージして、結果として非重複な区間のリストを返す。

## 核心のアイデア

ソート済みの区間リストを左から走査すると、各区間は「新しい区間より完全に前」「新しい区間と重複」「新しい区間より完全に後」の3グループに分かれる。この3フェーズを順に処理すれば、1回の走査で挿入とマージが完了する。

## 思考プロセス

1. **区間の位置関係は3パターンしかない**: ソート済みリストの各区間は、newIntervalと比較すると「完全に前にある」「重複している」「完全に後にある」のいずれかに分類できる。この分類を利用すれば、リストを1回走査するだけで処理できる
2. **「完全に前にある」の判定条件**: 既存区間の終端 `intervals[i][1]` が newInterval の始端 `newInterval[0]` より小さければ、その区間は newInterval と重複しない。この条件を満たす区間をそのまま結果に追加する
3. **「重複している」の判定条件**: 既存区間の始端 `intervals[i][0]` が newInterval の終端 `newInterval[1]` 以下であれば、その区間は newInterval と重複している。重複する区間が見つかるたびに、newInterval の始端と終端を更新してマージ範囲を拡大する
4. **マージの方法**: 重複する区間の始端と newInterval の始端の小さい方を新しい始端に、重複する区間の終端と newInterval の終端の大きい方を新しい終端にする。これにより、複数の重複区間を1つの区間にまとめられる
5. **マージ結果の追加タイミング**: 重複する区間がなくなった時点で、マージ済みの newInterval を結果に追加する。その後の区間はすべて newInterval より後にあるので、そのまま結果に追加する
6. **最終的に返すもの**: 3フェーズで構築した結果リストを `int[][]` に変換して返す

## 前提知識

### ArrayList とは

可変長の配列。要素の追加が `add()` でO(1)（償却）ででき、最終的に固定長配列に変換できる。結果のサイズが事前にわからない場合に使う。

```java
List<int[]> res = new ArrayList<>();   // 空のArrayListを作成
res.add(new int[]{1, 3});              // 要素を末尾に追加する
res.toArray(new int[0][]);             // int[][] 型の配列に変換する
```

### Math.min / Math.max とは

2つの値のうち小さい方・大きい方を返すメソッド。区間のマージで始端と終端を決定するときに使う。

```java
Math.min(1, 3);   // → 1（小さい方を返す）
Math.max(1, 3);   // → 3（大きい方を返す）
```

### 区間の重複判定

2つの区間 `[a, b]` と `[c, d]` が重複しているかは、`a <= d && c <= b` で判定できる。本問題ではソート済みのため、片方の条件だけで十分に判定できる。

```java
// 既存区間が newInterval より完全に前にある（重複しない）
intervals[i][1] < newInterval[0]   // 既存区間の終端 < 新区間の始端

// 既存区間が newInterval と重複している
intervals[i][0] <= newInterval[1]  // 既存区間の始端 <= 新区間の終端
```

## 計算量

| | 値 |
|---|---|
| Time | O(n) — 区間リストを1回走査するだけで済む |
| Space | O(n) — 結果リストに最大n+1個の区間を保存する |

## コード

```java
// 入力: ソート済みの非重複区間リスト intervals（int[][]）と新しい区間 newInterval（int[]）
// 出力: newInterval を挿入しマージした結果の非重複区間リストを int[][] で返す
public int[][] insert(int[][] intervals, int[] newInterval) {
    // 結果を格納するリスト。サイズが事前にわからないので ArrayList を使う
    List<int[]> res = new ArrayList<>();
    // 走査位置を追跡する変数
    int i = 0;
    // 区間の総数を変数に入れてループ条件で毎回 .length を参照しないようにする
    int n = intervals.length;

    // フェーズ1: newIntervalより完全に前にある区間をそのまま追加する
    // 判定条件: 既存区間の終端 < newIntervalの始端 なら重複しない
    while (i < n && intervals[i][1] < newInterval[0]) {
        res.add(intervals[i]);
        i++;
    }

    // フェーズ2: newIntervalと重複する区間をすべてマージする
    // 判定条件: 既存区間の始端 <= newIntervalの終端 なら重複している
    while (i < n && intervals[i][0] <= newInterval[1]) {
        // 始端は小さい方を取る（newIntervalの左端を重複区間の左端まで拡大する）
        newInterval[0] = Math.min(newInterval[0], intervals[i][0]);
        // 終端は大きい方を取る（newIntervalの右端を重複区間の右端まで拡大する）
        newInterval[1] = Math.max(newInterval[1], intervals[i][1]);
        i++;
    }
    // マージ済みのnewIntervalを結果に追加する（重複区間が0個でもそのまま追加される）
    res.add(newInterval);

    // フェーズ3: newIntervalより完全に後にある区間をそのまま追加する（マージ不要）
    while (i < n) {
        res.add(intervals[i]);
        i++;
    }

    // ArrayListをint[][]に変換して返す。new int[0][]は型情報を伝えるための空配列
    return res.toArray(new int[0][]);
}
```
