# Counting the Number of Islands in a Grid — グリッド内の島の数を数える

## 問題の本質

`'1'`（陸地）と `'0'`（水）で構成される2Dグリッドが与えられる。水平方向または垂直方向に隣接する陸地セルの集まりを1つの「島」とみなし、グリッド内の島の**総数**を返す。

## 核心のアイデア

各陸地セルをノードとみなし、隣接する陸地セル同士をUnion-Findで結合していけば、最終的に残った独立したグループ（根）の数がそのまま島の数になる。

## 思考プロセス

1. **島は「連結成分」である**: 隣接する陸地セルの集まりが1つの島なので、この問題はグリッド上の連結成分の数を求める問題に帰着する
2. **連結成分の管理にはUnion-Findが適している**: Union-Findは「2つの要素を同じグループに統合する」「2つの要素が同じグループか判定する」操作をほぼO(1)で行える。グリッドの各陸地セルを要素として扱えば、隣接セル同士を順に統合するだけで連結成分が求まる
3. **2Dグリッドのセルを1Dのインデックスに変換する**: Union-Findの配列は1次元なので、セル `(i, j)` を `i * n + j`（nは列数）で1つの整数に変換する。こうすることで2Dグリッド上のセルをUnion-Findの要素として扱える
4. **初期化で陸地セルの数を数える**: 各陸地セルの `parent` を自分自身に設定し、`count`（島の数）を陸地セルの総数で初期化する。この時点では各陸地セルが独立した島である
5. **隣接セルとの結合で島の数を減らす**: グリッドを走査し、各陸地セルについて右方向と下方向の隣接セルが陸地であれば `union` を実行する。`union` が2つの異なるグループを統合するたびに `count` を1減らす。右と下だけを見れば、左と上は以前のセルの走査時にすでに処理されているため、全ての隣接関係を網羅できる
6. **最終的に残ったcountが答え**: すべての結合が完了した後の `count` が、独立した連結成分の数、すなわち島の数である

## 前提知識

### Union-Find（素集合データ構造）とは

複数の要素をグループに分けて管理するデータ構造。「2つの要素を同じグループに統合する（union）」と「ある要素がどのグループに属するかを調べる（find）」の2つの操作を提供する。`parent` 配列で各要素の親を管理し、木構造でグループを表現する。

```java
int[] parent = new int[n];   // parent[i] = 要素iの親
int[] rank = new int[n];     // rank[i] = 要素iを根とする木の高さの上限

// 初期化: 各要素の親を自分自身に設定する（各要素が独立したグループ）
for (int i = 0; i < n; i++)
    parent[i] = i;
```

### 経路圧縮（Path Compression）とは

`find` 操作の際に、探索経路上のすべてのノードの親を直接根に付け替える最適化手法。再帰的に根を見つけた後、`parent[x] = find(parent[x])` で親を根に更新する。これにより次回以降の `find` がO(1)に近づく。

```java
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);  // 親を根に付け替える
    return parent[x];
}
```

### ランクによる統合（Union by Rank）とは

`union` 操作の際に、木の高さ（rank）が低い方を高い方の下に接続する手法。木の高さの増加を抑え、`find` の探索効率を維持する。両方のrankが等しい場合のみ、統合後にrankを1増やす。

```java
void union(int x, int y) {
    int rx = find(x), ry = find(y);  // それぞれの根を見つける
    if (rx == ry) return;            // すでに同じグループなら何もしない
    if (rank[rx] < rank[ry])         // rankが低い方を高い方の下に接続する
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;                  // rankが等しい場合のみrankを増やす
    }
}
```

### 2Dインデックスから1Dインデックスへの変換

2Dグリッドのセル `(i, j)` を1次元配列のインデックスに変換する公式。列数を `n` とすると、`id = i * n + j` で一意の整数に変換できる。

```java
int m = 3, n = 4;          // 3行4列のグリッド
int id = i * n + j;        // セル(1, 2) → 1 * 4 + 2 = 6
```

## 計算量

| | 値 |
|---|---|
| Time | O(m × n × α(m × n)) — 全セルを走査し、各セルで最大2回のunion/find操作を行う。α はアッカーマン関数の逆関数で、実質的に定数とみなせる |
| Space | O(m × n) — parent配列とrank配列にそれぞれ m × n の要素を保存する |

## コード

```java
// 入力: '1'（陸地）と '0'（水）で構成される char[][] grid
// 出力: グリッド内の島の数を int で返す

int[] parent;
int[] rank;
int count;

// 経路圧縮付きのfind: 要素xの根を返し、経路上の全ノードの親を根に付け替える
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);
    return parent[x];
}

// ランクによる統合: 2つの要素を同じグループに統合し、成功したらcountを1減らす
void union(int x, int y) {
    int rx = find(x), ry = find(y);
    if (rx == ry) return;       // すでに同じグループなら何もしない
    if (rank[rx] < rank[ry])
        parent[rx] = ry;       // rankが低い方を高い方の下に接続する
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;             // rankが等しい場合のみrankを増やす
    }
    count--;                    // 2つのグループが1つに統合されたので島の数を1減らす
}

public int numIslandsUF(char[][] grid) {
    // グリッドの行数mと列数nを取得する
    int m = grid.length;
    int n = grid[0].length;
    // parent配列とrank配列をサイズ m * n で作成する
    parent = new int[m * n];
    rank = new int[m * n];
    // 島の数を0で初期化する（この後の走査で陸地セルの数を数える）
    count = 0;

    // 初期化: 各陸地セルの親を自分自身（i * n + j）に設定し、countを陸地セルの総数にする
    // この時点では各陸地セルがそれぞれ独立した島である
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            parent[i * n + j] = i * n + j;  // 2Dインデックスを1Dに変換して親を自分自身に設定
            count++;                          // 陸地セル1つにつきcountを1増やす
        }

    // 各陸地セルについて、右隣と下隣が陸地であれば統合する
    // 右と下の2方向だけを調べる理由: 左と上は以前のセルの走査時にすでに処理済みだから
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            int id = i * n + j;              // 現在のセルの1Dインデックスを計算
            if (j + 1 < n && grid[i][j + 1] == '1')
                union(id, id + 1);           // 右隣の陸地セルと統合する（id + 1 は右隣の1Dインデックス）
            if (i + 1 < m && grid[i + 1][j] == '1')
                union(id, id + n);           // 下隣の陸地セルと統合する（id + n は下隣の1Dインデックス）
        }

    // countは初期値（陸地セルの総数）からunionによる統合が成功するたびに1ずつ減少しており、最終値が島の数である
    return count;
}
```
