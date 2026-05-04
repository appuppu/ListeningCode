# Finding the K Closest Points to the Origin — 原点に最も近いK個の点を見つける

## 問題の本質

二次元平面上の点の配列 `points` と整数 `k` が与えられる。原点 (0, 0) からのユークリッド距離が最も近い `k` 個の点を返す。距離はユークリッド距離で測定する。答えは任意の順序で返してよい。

## 核心のアイデア

「k個の最も近い点」を求めるのに完全なソートは不要である。Quickselectアルゴリズムを使えば、配列をピボットで分割し、k番目の境界を見つけるだけで、左側にk個の最近傍点が集まる。

## 思考プロセス

1. **完全なソートは過剰である**: k個の最近傍点を返せばよく、順序は問わない。つまり「最も近いk個」と「それ以外」に分割できればよい。完全ソートはO(n log n)かかるが、分割だけならもっと速くできる
2. **Quickselectで分割位置を探す**: Quicksortのパーティション操作を利用すれば、ピボットより小さい要素が左側、大きい要素が右側に集まる。ピボットの最終位置がちょうどk-1になれば、左側のk個が答えである
3. **距離の計算を簡略化する**: ユークリッド距離は `√(x² + y²)` だが、大小比較だけなら平方根は不要で、`x² + y²` の比較で十分である。これにより浮動小数点演算を避けられる
4. **パーティション操作の仕組み**: 右端の要素をピボットとして選び、`storeIdx` で「ピボット以下の要素を置く次の位置」を管理する。走査中にピボット以下の要素が見つかったら `storeIdx` の位置と交換し、`storeIdx` を進める
5. **ピボットの最終位置で探索範囲を絞る**: パーティション後、ピボットは `storeIdx` の位置に入る。この位置が `k-1` より小さければ左側の要素が足りないので右半分を探索し、`k-1` 以上なら左半分を探索する。この繰り返しにより、平均O(n)で分割が完了する
6. **最終的に先頭k個を返す**: ループ終了時点で配列の先頭k個が最近傍点になっているので、`Arrays.copyOfRange(points, 0, k)` で切り出して返す

## 前提知識

### Quickselect とは

配列の中からk番目に小さい要素を平均O(n)で見つけるアルゴリズム。Quicksortのパーティション操作を片側だけに再帰的に適用することで、完全なソートを行わずに目的の位置を確定させる。

```java
// パーティションの基本構造
int pivotValue = arr[right];       // 右端をピボットとして選ぶ
int storeIdx = left;               // ピボット以下の要素を置く位置
for (int i = left; i < right; i++) {
    if (arr[i] <= pivotValue) {    // ピボット以下なら左に集める
        swap(arr, i, storeIdx);
        storeIdx++;
    }
}
swap(arr, storeIdx, right);        // ピボットを正しい位置に置く
// storeIdx がピボットの最終位置
```

### ユークリッド距離の二乗

原点からの距離は `√(x² + y²)` だが、大小比較のみなら平方根を省略し `x² + y²` で比較できる。平方根関数は単調増加なので、距離の大小関係は距離の二乗でも保たれる。

```java
private int dist(int[] point) {
    return point[0] * point[0] + point[1] * point[1];  // x² + y²
}
```

### Arrays.copyOfRange とは

配列の指定範囲をコピーして新しい配列として返すJavaのユーティリティメソッド。

```java
int[][] result = Arrays.copyOfRange(points, 0, k);  // インデックス0からk-1までのk個をコピー
```

## 計算量

| | 値 |
|---|---|
| Time | O(n) 平均 — パーティションを片側にのみ適用するため、平均して n + n/2 + n/4 + ... = 2n 回の比較で収束する |
| Space | O(1) — 入力配列をin-placeで並べ替えるため、追加のメモリを使用しない |

## コード

```java
// 入力: 二次元座標の配列 points (各要素は [x, y]) と整数 k
// 出力: 原点に最も近い k 個の点を格納した int[][] を返す

// 点の原点からのユークリッド距離の二乗を返す（平方根は大小比較に不要なため省略する）
private int dist(int[] p) {
    return p[0] * p[0] + p[1] * p[1];
}

public int[][] kClosest(int[][] points, int k) {
    // 探索範囲の左端と右端を初期化する。この範囲内でパーティションを繰り返して先頭k個が最近傍点になるよう並べ替える
    int left = 0;
    int right = points.length - 1;

    // 先頭k個が最近傍点になるまでパーティションを繰り返す
    while (left < right) {
        // 右端の点をピボットとして選び、そのユークリッド距離の二乗を計算する（x² + y²）
        int pivotDist = dist(points[right]);
        // storeIdx は「ピボット以下の距離を持つ点を置く次の位置」を管理する
        int storeIdx = left;

        // 各点の距離をピボットと比較し、ピボット以下の距離を持つ点を左側に集める
        for (int i = left; i < right; i++) {
            if (dist(points[i]) <= pivotDist) {
                // ピボット以下なので storeIdx の位置に交換して左側に集める
                int[] temp = points[i];
                points[i] = points[storeIdx];
                points[storeIdx] = temp;
                storeIdx++;
            }
        }

        // ピボットを正しい最終位置 storeIdx に配置する。左側にはピボット以下、右側にはピボットより大きい距離の点が並ぶ
        int[] temp = points[storeIdx];
        points[storeIdx] = points[right];
        points[right] = temp;

        // ピボットの最終位置を k-1 と比較して探索範囲を半分に絞る
        if (storeIdx < k - 1) {
            // 左側の要素がk個に満たないので、右側を探索する
            left = storeIdx + 1;
        } else {
            // 注意: storeIdx がちょうど k-1 の場合も right を縮めることで、ループ条件 left < right が偽になりループが終了する
            right = storeIdx - 1;
        }
    }

    // ループ終了後、配列の先頭k個が原点に最も近いk個の点になっている
    return Arrays.copyOfRange(points, 0, k);
}
```
