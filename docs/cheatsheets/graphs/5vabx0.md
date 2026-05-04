# Finding Cells That Drain to Both Oceans — 両方の海に水が流れるセルをすべて見つける

## 問題の本質

m×n の高さ行列が与えられる。太平洋は上辺と左辺に、大西洋は下辺と右辺に接している。水は現在のセルから隣接セルへ、隣接セルの高さが現在のセル以下のときに流れる。水が太平洋と大西洋の**両方**に到達できるセルをすべて求める。

## 核心のアイデア

各セルから海への到達判定を順方向で行うと計算が重複する。逆に、海の境界セルから内側へ「水が遡れる方向（高さが同じか高い隣接セル）」にBFSを行えば、各海に到達可能なセルの集合がO(m*n)で求まり、2つの集合の交差が答えになる。

## 思考プロセス

1. **順方向の探索は非効率**: 各セル(i,j)から海への経路を探索するとO(m*n)個のセルそれぞれにBFS/DFSが必要で、全体でO((m*n)²)になる。セルごとの独立探索は重複だらけなので、逆方向の探索を考える
2. **逆方向に発想を転換する**: 「セルから海へ水が流れる」は「海からセルへ高さが非減少の経路がある」と同値である。海の境界から逆流方向にBFSすれば、到達可能なセルの集合を一度に求められる
3. **2つの海を独立に処理する**: 太平洋の境界セル（上辺+左辺）をすべてキューに入れてBFSし、到達可能なセルを記録する。大西洋の境界セル（下辺+右辺）についても同様にBFSする。2つの探索は互いに独立なので、同じロジックを使い回せる
4. **BFSの遷移条件を定める**: 逆流なので、隣接セルの高さが現在のセル**以上**のときに遷移する。これは「水が高い所から低い所へ流れる」の逆である
5. **交差を取る**: 両方のBFSで到達済みとマークされたセルが、両方の海に水が流れるセルである。全セルを走査して両方trueのものを結果リストに追加する

## 前提知識

### Multi-source BFS（複数始点BFS）とは

通常のBFSは1つの始点からスタートするが、複数の始点を最初にすべてキューに入れてからBFSを開始する手法。各始点から同時に探索が広がるのと同じ効果が得られ、全始点からの到達可能セルを1回のBFSで求められる。

```java
Queue<int[]> queue = new LinkedList<>();
// 複数の始点をすべてキューに追加する
queue.offer(new int[]{0, 0});
queue.offer(new int[]{0, 1});
queue.offer(new int[]{0, 2});
// 1回のwhileループで全始点から同時に探索する
while (!queue.isEmpty()) {
    int[] cell = queue.poll();
    // 隣接セルを条件に基づいて探索する
}
```

### boolean[][] による訪問済み管理

2次元boolean配列を使い、各セルが到達済みかどうかを記録する。初期値はfalseで、到達したセルをtrueにする。同じセルを再度処理することを防ぐ。

```java
boolean[][] reach = new boolean[m][n];  // m×nのfalseで初期化された配列
reach[r][c] = true;   // セル(r,c)を到達済みにする
if (!reach[nr][nc])   // セル(nr,nc)が未到達かを判定する
```

### 4方向の移動ベクトル

グリッド上の上下左右への移動を配列で表現する。ループで4方向を順に試すことで、各方向への分岐をコードの重複なく書ける。

```java
int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};  // 右、左、下、上
for (int[] d : dirs) {
    int nr = r + d[0];  // 新しい行インデックス
    int nc = c + d[1];  // 新しい列インデックス
}
```

## 計算量

| | 値 |
|---|---|
| Time | O(m×n) — 各BFSが全セルを最大1回ずつ訪問し、BFSを2回実行する |
| Space | O(m×n) — 2つのboolean配列とBFSキューがそれぞれ最大m×n個のセルを保持する |

## コード

```java
// 入力: m×n の整数行列 heights（各セルの高さ）
// 出力: 両方の海に水が到達できるセルの座標を List<List<Integer>> で返す

// 上下左右の4方向への移動ベクトル
int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};

// 複数始点BFSを実行し、到達可能なセルをboolean配列で返す
boolean[][] bfs(int[][] h, Queue<int[]> q) {
    int m = h.length, n = h[0].length;
    // 各セルが海から逆流で到達可能かを記録する配列
    boolean[][] reach = new boolean[m][n];

    // キュー内の全始点を到達済みにマークする（境界セルは海に直接接しているため）
    for (int[] c : q)
        reach[c[0]][c[1]] = true;

    while (!q.isEmpty()) {
        int[] cell = q.poll();
        int r = cell[0], c = cell[1];

        // 4方向の隣接セルを調べる
        for (int[] d : dirs) {
            int nr = r + d[0];
            int nc = c + d[1];

            // 範囲内かつ未到達かつ高さが現在以上（逆流可能）なら探索を広げる
            // 高さが現在以上という条件は「水が高い所から低い所へ流れる」の逆を表現している
            if (nr >= 0 && nr < m
                && nc >= 0 && nc < n
                && !reach[nr][nc]
                && h[nr][nc] >= h[r][c]) {
                reach[nr][nc] = true;
                q.offer(new int[]{nr, nc});
            }
        }
    }
    return reach;
}

List<List<Integer>> pacificAtlantic(int[][] heights) {
    int m = heights.length;
    int n = heights[0].length;

    // 太平洋用と大西洋用のキューを作成する（Multi-source BFSの始点集合）
    Queue<int[]> pQ = new LinkedList<>();
    Queue<int[]> aQ = new LinkedList<>();

    // 上辺は太平洋に直接接しているので太平洋の始点、下辺は大西洋に直接接しているので大西洋の始点
    for (int j = 0; j < n; j++) {
        pQ.offer(new int[]{0, j});
        aQ.offer(new int[]{m - 1, j});
    }

    // 左辺は太平洋に直接接しているので太平洋の始点、右辺は大西洋に直接接しているので大西洋の始点
    for (int i = 0; i < m; i++) {
        pQ.offer(new int[]{i, 0});
        aQ.offer(new int[]{i, n - 1});
    }

    // 各海からの逆流BFSを実行し、到達可能セルの集合を得る
    boolean[][] pacReach = bfs(heights, pQ);
    boolean[][] atlReach = bfs(heights, aQ);

    // 両方の海に到達可能なセルを結果リストに追加する
    // 両方trueであることは、そのセルから太平洋にも大西洋にも水が流れることを意味する
    List<List<Integer>> res = new ArrayList<>();
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (pacReach[i][j] && atlReach[i][j])
                res.add(Arrays.asList(i, j));

    return res;
}
```
