# Counting Ways to Assign Signs to Reach a Target Sum — 符号の割り当てでターゲット合計を作る方法の数を求める

## 問題の本質

整数の配列 `nums` と整数 `target` が与えられる。`nums` の各要素に `+` または `-` の符号を割り当てて、全要素の合計が `target` と等しくなる組み合わせが何通りあるかを返す。

## 核心のアイデア

各要素に `+` か `-` を割り当てる問題は、配列を「正の符号グループ(P)」と「負の符号グループ(N)」に分割する問題と同じである。P - N = target かつ P + N = totalSum から P = (target + totalSum) / 2 が導かれるため、問題は「合計が P になる部分集合の数を数える」という部分和問題に変換できる。

## 思考プロセス

1. **符号の割り当てを集合の分割として捉える**: 各要素に `+` を付けた要素の合計を P、`-` を付けた要素の合計を N とすると、P - N = target が成り立つ。同時に P + N = totalSum（全要素の合計）も成り立つ。この2つの式を連立すると P = (target + totalSum) / 2 が得られる
2. **解が存在しない条件を先に排除する**: P = (target + totalSum) / 2 が整数にならない場合（つまり `(target + totalSum)` が奇数の場合）、有効な分割は存在しない。また `|target|` が `totalSum` を超える場合も解は存在しない。これらの条件を最初にチェックして 0 を返す
3. **部分和問題としてDPで解く**: 「配列 `nums` から要素を選んで合計が `subsetSum`（= P）になる組み合わせの数」は、典型的な部分和カウント問題である。DP配列 `dp[j]` を「合計が j になる部分集合の数」と定義し、各要素について更新していく
4. **1次元DP配列で空間を最適化する**: 2次元の表を使う代わりに、1次元の配列 `dp[0..subsetSum]` を用意し、各要素 `num` について `j` を `subsetSum` から `num` まで逆順に走査して `dp[j] += dp[j - num]` と更新する。逆順に走査する理由は、同じ要素を複数回使うことを防ぐためである
5. **初期条件を設定する**: `dp[0] = 1` と設定する。これは「何も選ばずに合計 0 を作る方法が 1 通りある」ことを意味する
6. **最終的に返すもの**: 全要素を処理した後の `dp[subsetSum]` が、合計が `subsetSum` になる部分集合の数、すなわち元の問題の答えである

## 前提知識

### 部分和問題（Subset Sum Problem）とは

与えられた集合から要素を選び、その合計が特定の値になる組み合わせを求める問題。ナップサック問題の一種であり、DPで効率的に解ける。

### 1次元DP配列による部分和カウント

`dp[j]` は「合計が j になる部分集合の数」を表す。各要素 `num` について、`dp[j] += dp[j - num]` で更新する。

```java
int[] dp = new int[targetSum + 1]; // dp[j] = 合計がjになる組み合わせの数
dp[0] = 1;                         // 合計0を作る方法は1通り（何も選ばない）
dp[j] += dp[j - num];              // numを使ってjを作る = numを使わずにj-numを作る方法の数を加算
```

### 逆順ループの理由

内側のループを `subsetSum` から `num` へ逆順に回す。順方向に回すと、同じ要素 `num` を同じイテレーション内で複数回加算してしまう。逆順にすることで、各要素を「選ぶか選ばないか」の0-1ナップサック制約を満たす。

```java
// 逆順ループ: 各要素を最大1回だけ使う（0-1ナップサック）
for (int j = subsetSum; j >= num; j--) {
    dp[j] += dp[j - num];
}
```

## 計算量

| | 値 |
|---|---|
| Time | O(n × subsetSum) — 各要素についてDP配列を1回走査する |
| Space | O(subsetSum) — 1次元DP配列のみを使用する |

## コード

```java
// 入力: 整数配列 nums と整数 target
// 出力: 各要素に +/- を割り当てて合計が target になる組み合わせの数を int で返す
public int findTargetSumWays(int[] nums, int target) {
    // 配列 nums の全要素の合計を計算し、変数 totalSum に代入する
    int totalSum = 0;
    for (int num : nums) {
        totalSum += num;
    }

    // 解が存在しない条件をチェックする
    // (target + totalSum)が奇数の場合、P = (target + totalSum) / 2 が整数にならず、
    // 整数個の要素で構成される部分集合では達成できないため 0 を返す
    // |target| が totalSum を超える場合も、どう符号を割り当てても target に届かないため 0 を返す
    if ((target + totalSum) % 2 != 0
        || Math.abs(target) > totalSum)
        return 0;

    // +符号グループの合計値を求める。これ以降の処理で求めるべきターゲットとなる
    int subsetSum = (target + totalSum) / 2;

    // dp[j] = nums の要素を選んで合計が j になる組み合わせの数
    int[] dp = new int[subsetSum + 1];
    // 基底ケース: 何も選ばずに合計 0 を作る方法は 1 通り
    dp[0] = 1;

    // 外側ループ: 配列 nums の各要素を先頭から末尾まで順に走査する
    for (int num : nums) {
        // 内側ループ: subsetSum から num まで逆順に走査する
        // 逆順にする理由: 同じ num を同一イテレーション内で複数回使用することを防ぐ（0-1ナップサック制約）
        for (int j = subsetSum; j >= num; j--) {
            // num を使わずに合計 j - num を作る方法の数を、num を使って合計 j を作る方法の数に加算する
            dp[j] += dp[j - num];
        }
    }

    // dp[subsetSum] が合計が subsetSum になる部分集合の数、すなわち元の問題における符号の割り当て方の総数
    return dp[subsetSum];
}
```
