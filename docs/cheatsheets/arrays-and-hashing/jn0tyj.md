# Encoding and Decoding a List of Strings — 文字列リストを1つの文字列にエンコード・デコードする

## 問題の本質

文字列のリスト `strs` が与えられる。`encode` メソッドでリストを1つの文字列に変換し、`decode` メソッドでその文字列を元のリストに復元する。エンコードとデコードはステートレス（状態を持たない）でなければならず、空文字列・特殊文字・区切り文字自体を含む文字列など、あらゆる入力を正しく処理する必要がある。

## 核心のアイデア

各文字列の前に「その文字列の長さ」を付与すれば、文字列の中身に何が含まれていても正確に切り出せる。長さが分かっていれば区切り文字との衝突問題は原理的に発生しない。

## 思考プロセス

1. **素朴な区切り文字方式の問題点を認識する**: カンマや改行などの区切り文字でリストを結合すると、文字列自体にその区切り文字が含まれている場合に正しくデコードできない。エスケープ処理を導入しても、エスケープ文字自体のエスケープが必要になり複雑化する
2. **文字列の長さを先に伝えれば衝突が起きない**: 各文字列の前にその文字列の長さ（バイト数ではなく文字数）を記録しておけば、デコード時に「何文字読むか」が事前に分かる。文字列の中身を一切解釈せずに切り出せるため、どんな文字が含まれていても問題ない
3. **長さと文字列本体の区切りに `#` を使う**: 長さは可変桁の整数なので、長さ部分の終わりを示す記号が必要になる。`#` を区切りに使い、`長さ#文字列本体` の形式にする。デコード時は最初の `#` の位置から長さ部分を読み取り、その後ろから指定文字数を切り出す
4. **エンコード**: 各文字列に対して `文字列の長さ + "#" + 文字列本体` を連結し、1つの文字列を構築する。例えば `["hello", "a#b"]` は `5#hello3#a#b` になる
5. **デコード**: 先頭から `#` を探して長さを読み取り、`#` の直後から長さ分の文字を切り出す。切り出し終了位置を次の開始位置として繰り返す。文字列本体に `#` が含まれていても、長さで正確な範囲が分かっているので誤認しない
6. **最終的に返すもの**: `encode` は連結された1つの `String` を返し、`decode` はその `String` から復元した `List<String>` を返す

## 前提知識

### StringBuilder とは

文字列を効率的に連結するためのクラス。`String` の `+` 演算子による連結は毎回新しい `String` オブジェクトを生成するが、`StringBuilder` は内部バッファに追記するためO(1)で連結できる。

```java
StringBuilder sb = new StringBuilder();  // 空のStringBuilderを作成
sb.append("hello");                      // 末尾に "hello" を追加する
sb.append(5);                            // 末尾に整数5を文字列として追加する
sb.toString();                           // 結果の文字列 "hello5" を返す
```

### String.indexOf(char, int) とは

指定した文字を、指定した開始位置から前方に検索し、最初に見つかった位置（インデックス）を返すメソッド。見つからなければ -1 を返す。

```java
String str = "12#hello";
str.indexOf('#', 0);    // 位置0から '#' を探す → 2 を返す
str.indexOf('#', 3);    // 位置3から '#' を探す → 見つからなければ -1
```

### String.substring(int, int) とは

文字列の指定範囲を切り出すメソッド。第1引数は開始位置（含む）、第2引数は終了位置（含まない）。

```java
String str = "5#hello";
str.substring(0, 1);    // 位置0から位置1の手前まで → "5"
str.substring(2, 7);    // 位置2から位置7の手前まで → "hello"
```

### Integer.parseInt(String) とは

文字列を整数に変換する静的メソッド。長さプレフィックスの数値部分を整数として読み取るために使用する。

```java
Integer.parseInt("5");    // 文字列 "5" を整数 5 に変換する
Integer.parseInt("123");  // 文字列 "123" を整数 123 に変換する
```

## 計算量

| | 値 |
|---|---|
| Time | O(n × k) — n は文字列の個数、k は文字列の平均長。全文字列を1回ずつ処理する |
| Space | O(n × k) — エンコード結果またはデコード結果として全文字列分の領域を使用する |

## コード

```java
// === encode ===
// 入力: 文字列のリスト strs（List<String>）
// 出力: すべての文字列を1つにまとめた String を返す
public String encode(List<String> strs) {
    // ループ内での文字列連結を効率的に行うためにStringBuilderを使用する
    StringBuilder sb = new StringBuilder();
    // リストの各文字列を先頭から順に走査する
    for (String str : strs) {
        // 各文字列の前に「長さ#」を付与して連結する
        // 長さを先に記録することで、デコード時に文字列本体の正確な範囲が分かる
        sb.append(str.length() + "#" + str);
    }
    // StringBuilder の内容を String として返す
    return sb.toString();
}

// === decode ===
// 入力: エンコードされた1つの文字列 str（String）
// 出力: 復元した文字列のリスト List<String> を返す
public List<String> decode(String str) {
    List<String> result = new ArrayList<>();
    // 現在の読み取り位置を示す変数。先頭から開始する
    int i = 0;
    while (i < str.length()) {
        // 現在位置 i から最初の '#' を探し、長さ部分と文字列本体の区切り位置を特定する
        int separatorIndex = str.indexOf('#', i);
        // '#' の手前までを整数として読み取り、文字列本体の長さを得る
        int textLength = Integer.parseInt(str.substring(i, separatorIndex));
        // '#' の直後が文字列本体の開始位置
        int textStart = separatorIndex + 1;
        // 開始位置から長さ分先が終了位置。長さで範囲を決定するため、文字列本体に '#' が含まれていても正しく切り出せる
        int textEnd = textStart + textLength;
        // 文字列本体を切り出して結果リストに追加する
        result.add(str.substring(textStart, textEnd));
        // 読み取り位置を次の文字列の長さ部分の先頭に移動する
        i = textEnd;
    }
    return result;
}
```
