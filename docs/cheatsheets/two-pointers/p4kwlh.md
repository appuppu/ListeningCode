# Calculating Trapped Rainwater Between Bars — 棒の間に溜まる雨水の量を計算する

## 問題の本質

非負整数の配列 `height` が与えられる。各要素は幅1の棒の高さを表す高低差マップである。雨が降った後に棒と棒の間に溜まる**水の総量**を計算して返す。

## 核心のアイデア

ある位置に溜まる水の量は「左側の最大高さと右側の最大高さのうち小さい方」から「その位置の棒の高さ」を引いた値で決まる。左右からポインタを内側に動かしながら、それぞれの側の最大高さを更新していけば、追加の配列なしで各位置の水量を計算できる。

## 思考プロセス

1. **各位置の水量は左右の最大高さで決まる**: ある位置 `i` に溜まる水の量は `min(左側の最大高さ, 右側の最大高さ) - height[i]` である。水は左右の壁のうち低い方の高さまでしか溜まらないためである
2. **左右の最大高さを効率的に求めたい**: 各位置で左右の最大高さを毎回走査すると O(n²) かかる。配列を2つ用意して事前計算すれば O(n) になるが、Space O(n) が必要になる。Space O(1) で実現する方法を考える
3. **左右からポインタを内側に動かす**: 左端にポインタ `left`、右端にポインタ `right` を置き、内側に向かって動かす。各ポインタの側でこれまでに見た最大高さを変数 `maxLeftHeight` と `maxRightHeight` で追跡する
4. **小さい側のポインタを動かす**: `height[left] <= height[right]` のとき、左側の最大高さが右側の最大高さ以下であることが保証される。なぜなら、右側には少なくとも `height[right]` 以上の壁が存在するからである。このため、左側のポインタ位置では `maxLeftHeight` だけで水量を確定できる
5. **ポインタを動かした後に水量を加算する**: ポインタを1つ進めてから、その新しい位置で最大高さを更新し、`maxLeftHeight - height[left]`（または `maxRightHeight - height[right]`）を水量に加算する。最大高さは常に現在の棒の高さ以上なので、この差は必ず0以上になる
6. **両ポインタが出会ったら終了**: `left < right` の間ループを続け、全位置の水量を合算した `totalwater` を返す

## 前提知識

### Two Pointers（2ポインタ）とは

配列の両端または異なる位置に2つのポインタを置き、条件に応じてどちらかを動かしながら走査する手法。配列全体を1回の走査で処理でき、ソート済み配列や両端からの探索に有効である。

```java
int left = 0;                    // 左端のポインタ
int right = height.length - 1;   // 右端のポインタ
while (left < right) {           // 2つのポインタが出会うまでループ
    // 条件に応じて left++ または right-- でポインタを内側に動かす
}
```

### Math.max とは

2つの値のうち大きい方を返すJavaの静的メソッド。ここでは、ポインタが進むたびにこれまでの最大高さを更新するために使用する。

```java
int maxHeight = 3;
maxHeight = Math.max(maxHeight, 5);  // maxHeight は 5 に更新される
maxHeight = Math.max(maxHeight, 2);  // maxHeight は 5 のまま（2 < 5 なので）
```

### 水が溜まる条件

ある位置に水が溜まるには、その位置の左右両側に現在の棒より高い壁が必要である。溜まる水の量は「左右の壁のうち低い方の高さ」から「現在の棒の高さ」を引いた値である。

```
// height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]
// 位置2（高さ0）: 左の最大=1, 右の最大=3 → min(1,3) - 0 = 1 の水が溜まる
// 位置5（高さ0）: 左の最大=2, 右の最大=3 → min(2,3) - 0 = 2 の水が溜まる
```

## 計算量

| | 値 |
|---|---|
| Time | O(n) — 左右のポインタが合計でn回動いて配列を1回走査する |
| Space | O(1) — ポインタと最大高さの変数のみを使用し、追加の配列は不要 |

## コード

```java
// 入力: 非負整数の配列 height（各要素は棒の高さ）
// 出力: 棒の間に溜まる水の総量を int で返す
public int trap(int[] height) {
    // 溜まる水の総量を保持する変数を0で初期化する
    int totalwater = 0;

    // 左ポインタを配列の先頭、右ポインタを配列の末尾に設定する
    int left = 0;
    int right = height.length - 1;

    // 左右それぞれのこれまでの最大高さを初期化する
    // 両端の棒自体には水は溜まらないので、初期値として使用する
    int maxLeftHeight = height[left];
    int maxRightHeight = height[right];

    // 2つのポインタが出会うまでループする
    while (left < right) {
        // height[left] <= height[right] のとき、右側には少なくとも height[right] の壁が存在する
        // そのため左側の最大高さだけで水量を確定できる
        if (height[left] <= height[right]) {
            // ポインタを1つ右に進めてから水量を計算する
            left++;
            // これまでの左側最大高さを更新する
            maxLeftHeight = Math.max(maxLeftHeight, height[left]);
            // maxLeftHeight は常に height[left] 以上なので、加算値は必ず0以上になる
            totalwater += maxLeftHeight - height[left];
        } else {
            // height[left] > height[right] のとき、左側には少なくとも height[left] の壁が存在する
            // そのため右側の最大高さだけで水量を確定できる
            right--;
            // これまでの右側最大高さを更新する
            maxRightHeight = Math.max(maxRightHeight, height[right]);
            // maxRightHeight は常に height[right] 以上なので、加算値は必ず0以上になる
            totalwater += maxRightHeight - height[right];
        }
    }
    // ループ終了後、全位置の水量を合算した totalwater を返す
    return totalwater;
}
```
