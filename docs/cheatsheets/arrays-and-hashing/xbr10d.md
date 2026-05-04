# Finding the K Most Frequent Elements — 配列から出現頻度が最も高いK個の要素を返す

## 問題の本質

整数の配列 `nums` と整数 `k` が与えられる。`nums` の中から出現回数が最も多い要素を上位 `k` 個選び、配列で返す。返す順番は問わない。答えは一意であることが保証されている。

## 核心のアイデア

各要素の出現頻度を数えた後、頻度をインデックスとするバケット配列を作れば、ソート（O(n log n)）を使わずにO(n)で頻度順に要素を取り出せる。頻度の最大値は配列の長さ `n` 以下なので、バケット配列のサイズは有限である。

## 思考プロセス

1. **まず各要素の出現回数を数える必要がある**: 頻度上位K個を求めるには、各要素が何回出現するかを知る必要がある。HashMapを使えば、キーに「数値」、バリューに「出現回数」を保存し、O(n)で全要素の頻度を集計できる
2. **頻度順に並べたいが、ソートはO(n log n)かかる**: 頻度マップが完成したら、頻度が高い順にK個を取り出したい。頻度でソートするとO(n log n)になるが、もっと速い方法がある
3. **頻度をインデックスにしたバケット配列を使う**: 配列の長さが `n` のとき、どの要素の出現頻度も最大 `n` である。そこで、サイズ `n+1` の配列を用意し、インデックス `i` の位置に「出現頻度が `i` 回の要素のリスト」を格納する。これがバケットソートの考え方である
4. **バケット配列を末尾から走査してK個を集める**: バケット配列のインデックスが大きいほど出現頻度が高い。末尾（インデックス `n`）から先頭に向かって走査し、バケットが空でなければその中の要素を結果リストに追加する。結果リストのサイズが `k` に達した時点で、そのリストを配列に変換して返す

## 前提知識

### HashMap とは

キーと値のペアを保存するデータ構造。キーを指定して値の検索・取得がO(1)でできる。この問題では、各数値の出現回数を数えるカウンターとして使用する。

```java
HashMap<Integer, Integer> map = new HashMap<>();  // 空のHashMapを作成
map.merge(1, 1, Integer::sum);  // キー1の値に1を加算する（キーが存在しなければ1で初期化）
map.entrySet();                 // 全てのキーと値のペアをSetで返す
entry.getKey();                 // ペアからキーを取得する
entry.getValue();               // ペアから値を取得する
```

### merge メソッドとは

`map.merge(key, value, remappingFunction)` は、キーが存在しなければ `value` をそのまま格納し、キーが既に存在すれば `remappingFunction` で既存の値と `value` を結合する。`Integer::sum` を渡すと、既存の値に `value` を加算する。`put` + `getOrDefault` の組み合わせを1行で書ける便利メソッドである。

```java
map.merge(5, 1, Integer::sum);  // キー5が無ければ1を格納、あれば既存値+1を格納
// 上記は以下と同じ意味
map.put(5, map.getOrDefault(5, 0) + 1);
```

### バケットソートとは

要素の値そのものをインデックスとして配列に振り分けるソート手法。比較ベースのソート（O(n log n)）と異なり、値の範囲が有限であればO(n)で処理できる。この問題では、出現頻度（最大 `n`）をインデックスとして使う。

```java
List<Integer>[] buckets = new ArrayList[4];  // インデックス0〜3のバケット配列を作成
buckets[2] = new ArrayList<>();              // インデックス2のバケットを初期化
buckets[2].add(7);                           // 「頻度2の要素」として7を格納
// buckets = [null, null, [7], null]
```

## 計算量

| | 値 |
|---|---|
| Time | O(n) — 頻度マップの構築にO(n)、バケット配列の構築にO(n)、結果の収集にO(n)で、全体でO(n) |
| Space | O(n) — 頻度マップに最大n個、バケット配列のサイズがn+1で、全体でO(n) |

## コード

```java
// 入力: 整数配列 nums と整数 k
// 出力: 出現頻度が最も高い上位 k 個の要素を格納した int[] を返す
public int[] topKFrequent(int[] nums, int k) {
    // ステップ1: 各要素の出現頻度をHashMapで集計する
    Map<Integer, Integer> freqMap = buildFrequencyMap(nums);
    // ステップ2: 頻度をインデックスとするバケット配列を構築する
    List<Integer>[] buckets = buildBuckets(freqMap, nums.length);
    // ステップ3: バケット配列を末尾から走査して上位K個を収集する
    return collectTopK(buckets, k);
}

// 各要素の出現回数をHashMapで集計して返す
// キー=数値、バリュー=その数値の出現回数
public Map<Integer, Integer> buildFrequencyMap(int[] nums) {
    Map<Integer, Integer> freqMap = new HashMap<>();
    for (int num : nums) {
        // mergeにより、キーが無ければ1で初期化、あれば既存値に1を加算する
        freqMap.merge(num, 1, Integer::sum);
    }
    // 走査完了後、HashMapには全要素の出現頻度が格納されている
    return freqMap;
}

// 頻度をインデックスとするバケット配列を構築して返す
// buckets[i] には出現頻度がi回の要素のリストが入る
public List<Integer>[] buildBuckets(Map<Integer, Integer> freqMap, int n) {
    // サイズn+1なのは、ある要素が最大n回出現する可能性があり、インデックス0〜nを使うため
    List<Integer>[] buckets = new ArrayList[n + 1];
    for (var entry : freqMap.entrySet()) {
        int num = entry.getKey();
        int freq = entry.getValue();
        // バケットがnullの場合は新しいArrayListを作成してから追加する
        if (buckets[freq] == null) {
            buckets[freq] = new ArrayList<>();
        }
        // 出現頻度freqをインデックスとして、そのバケットに数値numを追加する
        buckets[freq].add(num);
    }
    return buckets;
}

// バケット配列を末尾から走査し、頻度が高い順にK個の要素を収集して返す
// インデックスが大きいほど出現頻度が高いため、逆順に走査することで頻度の高い要素から順に取り出せる
public int[] collectTopK(List<Integer>[] buckets, int k) {
    List<Integer> result = new ArrayList<>();
    // 末尾（インデックスn）から先頭に向かって走査する。インデックス0は「出現頻度0回」なので除外する
    for (int i = buckets.length - 1; i > 0; i--) {
        if (buckets[i] != null) {
            for (int num : buckets[i]) {
                result.add(num);
                // K個集まった時点で配列に変換して返す
                if (result.size() == k) {
                    return result.stream().mapToInt(Integer::intValue).toArray();
                }
            }
        }
    }
    // 問題の制約上、答えは必ず存在するのでここには到達しない
    return new int[0];
}
```
