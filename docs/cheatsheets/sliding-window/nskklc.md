# Finding the Smallest Window Containing All Characters — 全文字を含む最小の部分文字列を見つける

## 問題の本質

2つの文字列 `s` と `t` が与えられる。`s` の中から `t` の全文字（重複を含む）を含む**最短の部分文字列**を見つけて返す。そのような部分文字列が存在しない場合は空文字列を返す。

## 核心のアイデア

右ポインタを伸ばして条件を満たす窓を作り、左ポインタを縮めて最小化する。「条件を満たす文字種の数」を1つの変数で管理することで、窓の有効性をO(1)で判定できる。

## 思考プロセス

1. **必要な文字の出現回数を事前に数える**: `t` に含まれる各文字の出現回数をHashMapに記録する。これが窓が満たすべき条件となる。例えば `t = "ABC"` なら `{A:1, B:1, C:1}` となる
2. **窓を右に広げて条件を満たす**: 右ポインタ `r` を1つずつ進めて窓に文字を追加し、窓内の文字の出現回数を別のHashMapで管理する。窓内の出現回数が必要数に達した文字種が1つ増えるたびに、カウンタ `have` をインクリメントする
3. **条件の充足をO(1)で判定する**: `need` のサイズ（必要な文字種の数）を `required` とし、`have == required` が成立すれば窓は `t` の全文字を含んでいる。文字種単位で管理することで、毎回全文字を比較する必要がなくなる
4. **窓を左から縮めて最小化する**: `have == required` の間、左ポインタ `left` を右に進めて窓を縮小する。縮小のたびに窓の長さを現在の最小値と比較し、より短ければ更新する
5. **左端の文字を除外したときの処理**: 左端の文字 `s.charAt(left)` を窓から除外する際、その文字が `need` に含まれており、窓内の出現回数が必要数を下回ったら `have` をデクリメントする。これにより `while` ループが終了し、右ポインタの拡張に戻る
6. **最終的に返すもの**: 走査終了後、最小窓が見つかっていれば `s.substring(resStart, resStart + resLen)` を返す。見つかっていなければ空文字列を返す

## 前提知識

### HashMap とは

キーと値のペアを保存するデータ構造。キーを指定して値の検索・取得がO(1)でできる。この問題では文字の出現回数を管理するために使用する。

```java
HashMap<Character, Integer> map = new HashMap<>();  // 空のHashMapを作成
map.put('A', 1);                    // キー'A'に値1を格納する
map.getOrDefault('A', 0);           // キー'A'の値を返す。存在しなければ0を返す → 1
map.containsKey('A');               // キー'A'が存在するかをbooleanで返す → true
map.get('A').equals(map.get('B'));  // Integerオブジェクト同士の比較にはequalsを使う
```

### Sliding Window（スライディングウィンドウ）とは

配列や文字列上の連続する範囲（窓）を、2つのポインタ `left` と `right` で管理する手法。右ポインタで窓を広げ、左ポインタで窓を縮めることで、全ての部分文字列を調べるO(n²)の処理をO(n)に最適化できる。

```java
int left = 0;
for (int r = 0; r < s.length(); r++) {
    // 右ポインタで窓を広げる処理
    while (条件を満たしている) {
        // 左ポインタで窓を縮める処理
        left++;
    }
}
```

### have / required パターンとは

窓が条件を満たしているかをO(1)で判定するための手法。`required` は満たすべき文字種の総数、`have` は現時点で必要数に達した文字種の数を表す。`have == required` のとき窓は全条件を満たしている。

```java
int required = need.size();  // 必要な文字種の数（例: need={A:1,B:1,C:1} → 3）
int have = 0;                // 条件を満たした文字種の数（初期値0）
// 窓内の'A'の数がneedの'A'の数に達したら have++ → have==requiredで全条件充足
```

## 計算量

| | 値 |
|---|---|
| Time | O(n) — 右ポインタと左ポインタがそれぞれ `s` を最大1回ずつ走査する |
| Space | O(n) — HashMap `need` と `window` に最大で `s` と `t` の文字種数分の要素を保存する |

## コード

```java
// 入力: 文字列 s と文字列 t
// 出力: s の中で t の全文字を含む最短の部分文字列を String で返す。存在しなければ空文字列を返す
String minWindow(String s, String t) {
    // sがtより短ければ全文字を含む窓は存在しない
    if (s.length() < t.length())
        return "";

    // tの各文字の必要出現回数を記録するHashMap。これが窓が満たすべき条件を定義する
    Map<Character, Integer> need = new HashMap<>();
    for (char c : t.toCharArray()) {
        need.put(c, need.getOrDefault(c, 0) + 1);
    }

    // 窓内の各文字の出現回数を管理するHashMap
    Map<Character, Integer> window = new HashMap<>();
    int have = 0;              // 条件を満たした文字種の数
    int required = need.size(); // 満たすべき文字種の総数（need のキーの数）
    int resLen = Integer.MAX_VALUE; // 最小窓の長さ（未発見状態を表す初期値）
    int resStart = 0;          // 最小窓の開始位置
    int left = 0;              // 左ポインタ

    // 右ポインタで窓を右に広げていく
    for (int r = 0; r < s.length(); r++) {
        char c = s.charAt(r);
        // 窓内の文字cの出現回数を1増やす（窓が右に1文字拡張される）
        window.put(c, window.getOrDefault(c, 0) + 1);

        // 文字cがtに必要な文字であり、窓内の出現回数が必要数にちょうど達したらhaveを増やす
        // 注意: Integerオブジェクトの比較には == ではなく equals を使う
        if (need.containsKey(c)
            && window.get(c).equals(need.get(c))) {
            have++;
        }

        // 窓が全条件を満たしている間（have == required）、左から縮めて最小化する
        while (have == required) {
            int wLen = r - left + 1;
            // より短い窓が見つかれば結果を更新する
            if (wLen < resLen) {
                resLen = wLen;
                resStart = left;
            }
            // 左端の文字を窓から除外する
            char lc = s.charAt(left);
            window.put(lc, window.get(lc) - 1);
            // 除外により窓内の出現回数が必要数を下回ったら、条件が崩れたのでhaveを減らす
            if (need.containsKey(lc)
                && window.get(lc) < need.get(lc)) {
                have--;
            }
            // 左ポインタを右に進めて窓を縮める
            left++;
        }
    }

    // resLenが初期値のままなら条件を満たす窓が見つからなかったので空文字列を返す
    if (resLen == Integer.MAX_VALUE)
        return "";
    // 最小窓の開始位置から最小窓の長さ分を切り出して返す
    return s.substring(resStart, resStart + resLen);
}
```
