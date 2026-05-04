# Checking if a String is a Palindrome — 文字列が回文かどうかを判定する

## 問題の本質

文字列 `s` が与えられる。英数字のみを対象とし、大文字・小文字の違いを無視して、その文字列が回文（前から読んでも後ろから読んでも同じ）かどうかを判定する。回文なら `true`、そうでなければ `false` を返す。

## 核心のアイデア

文字列の両端から2つのポインタを内側に向かって進め、英数字以外をスキップしながら1文字ずつ比較すれば、余分な文字列を生成せずにO(1)の空間で回文判定ができる。

## 思考プロセス

1. **回文の定義を確認する**: 回文とは、前から読んでも後ろから読んでも同じ文字列のこと。つまり、先頭と末尾の文字が一致し、その内側も同様に一致していれば回文である
2. **両端から比較すれば1回の走査で判定できる**: 先頭にポインタ `left`、末尾にポインタ `right` を置き、両者が出会うまで内側に進めながら比較すれば、全文字を1回ずつ見るだけで判定が完了する
3. **英数字以外の文字をスキップする必要がある**: 問題は英数字のみを対象とするので、各ポインタが英数字でない文字を指している場合はスキップして次に進める。`Character.isLetterOrDigit` で英数字かどうかを判定できる
4. **大文字・小文字を統一してから比較する**: 問題は大小文字を区別しないので、比較の前に `Character.toLowerCase` で両方の文字を小文字に変換してから一致を確認する
5. **不一致を発見した時点で即座に `false` を返す**: 1箇所でも異なれば回文ではないので、早期リターンできる
6. **ポインタが交差するまで不一致がなければ回文である**: ループが正常に終了した場合、すべての対応する文字が一致したことを意味するので `true` を返す

## 前提知識

### Two Pointers（2ポインタ法）とは

配列や文字列の両端にポインタを置き、条件に応じて内側に動かしていく手法。対称性を利用する問題（回文判定、ペア探索など）に有効。1回の走査で問題を解けるため、時間O(n)・空間O(1)を実現できる。

```java
int left = 0;                    // 先頭を指すポインタ
int right = s.length() - 1;     // 末尾を指すポインタ
// leftとrightが交差するまでループを続ける
while (left < right) {
    // 比較や処理を行う
    left++;    // 左ポインタを右に進める
    right--;   // 右ポインタを左に進める
}
```

### Character.isLetterOrDigit とは

文字が英字（a-z, A-Z）または数字（0-9）であるかを判定するメソッド。スペースや記号などの英数字以外の文字を除外したい場合に使う。

```java
Character.isLetterOrDigit('A');   // true（英字）
Character.isLetterOrDigit('3');   // true（数字）
Character.isLetterOrDigit(' ');   // false（スペース）
Character.isLetterOrDigit(',');   // false（記号）
```

### Character.toLowerCase とは

英字を小文字に変換するメソッド。大文字・小文字を区別せずに比較したいときに使う。既に小文字や数字の場合はそのまま返す。

```java
Character.toLowerCase('A');   // 'a'
Character.toLowerCase('a');   // 'a'（変化なし）
Character.toLowerCase('3');   // '3'（数字はそのまま）
```

## 計算量

| | 値 |
|---|---|
| Time | O(n) — 各ポインタが文字列を最大1回走査する |
| Space | O(1) — ポインタ2つのみで追加の文字列やデータ構造を使わない |

## コード

```java
// 入力: 文字列 s
// 出力: s が回文なら true、そうでなければ false を返す
public boolean isPalindrome(String s) {
    // 先頭と末尾にポインタを配置する。この2つが文字列の両端から内側に向かって進む
    int left = 0;
    int right = s.length() - 1;

    // 2つのポインタが交差するまで繰り返す。交差したらすべての比較が完了したことを意味する
    while (left < right) {
        // leftが英数字でなければ右にスキップする
        // 注意: スキップ中も left < right の条件を維持し、ポインタが交差しないようにする
        while (left < right && !Character.isLetterOrDigit(s.charAt(left))) {
            left++;
        }
        // rightが英数字でなければ左にスキップする。同様に left < right の条件を維持する
        while (left < right && !Character.isLetterOrDigit(s.charAt(right))) {
            right--;
        }
        // 両方の文字を小文字に変換してから比較することで、大小文字の違いを無視する
        // 不一致なら回文ではない。1箇所でも異なれば回文の条件を満たさないので即座に返す
        if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right))) {
            return false;
        }
        // 2つの文字が一致したので、両ポインタを内側に進めて次の文字ペアの比較に移る
        left++;
        right--;
    }
    // ループが正常に終了した（すべての対応する文字ペアが一致した）ので回文である
    return true;
}
```
