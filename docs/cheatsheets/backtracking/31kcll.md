# Mapping Phone Number Digits to Letter Combinations — 電話番号の数字から文字の全組み合わせを生成する

## 問題の本質

数字2〜9からなる文字列 `digits` が与えられる。各数字は電話のキーパッドに対応する文字（例: 2→"abc", 3→"def"）にマッピングされる。`digits` の各数字から1文字ずつ選んで並べたとき、あり得る**全ての文字の組み合わせ**をリストで返す。

## 核心のアイデア

各数字の位置で選べる文字は3〜4個あり、全ての組み合わせを列挙する必要がある。1文字ずつ選んで末尾に追加し、全桁分選び終えたら結果に記録し、直前の選択を取り消して別の文字を試す「バックトラッキング」で、全パターンを漏れなく探索できる。

## 思考プロセス

1. **各数字の位置で選択肢がある**: 数字ごとに対応する文字が3〜4個あり、各位置で1文字を選ぶ。全位置の選択の組み合わせが答えになるので、全パターンを体系的に列挙する必要がある
2. **再帰で1桁ずつ処理する**: 最初の数字から順に1文字を選び、次の数字の処理を再帰呼び出しに任せる。こうすれば、各再帰の深さが1つの数字の位置に対応し、構造がシンプルになる
3. **終了条件は全桁を処理し終えたとき**: 再帰の深さが `digits` の長さに達したとき、現在構築中の文字列が1つの完成した組み合わせになる。これを結果リストに追加する
4. **バックトラッキングで別の選択肢を試す**: 再帰から戻ったら、直前に追加した文字を `StringBuilder` の末尾から削除する。こうすることで、同じ位置の別の文字を試す準備ができる
5. **数字から文字への変換にはマッピング配列を使う**: インデックス0〜9の文字列配列を用意し、`digits.charAt(idx) - '0'` で数字を整数に変換してインデックスアクセスすれば、対応する文字群をO(1)で取得できる
6. **空文字列の入力を処理する**: `digits` が空の場合は組み合わせが存在しないので、空のリストをそのまま返す

## 前提知識

### バックトラッキングとは

解の候補を1つずつ構築し、完成したら記録し、直前の選択を取り消して別の選択肢を試す探索手法。全ての組み合わせ・順列を列挙する問題で使われる。「選ぶ→進む→戻す→別を試す」のサイクルを再帰で実現する。

```java
// バックトラッキングの基本パターン
void backtrack(状態, 結果リスト) {
    if (終了条件) {
        結果リスト.add(現在の状態);
        return;
    }
    for (選択肢 : 現在の選択肢一覧) {
        状態に選択肢を追加;       // 選ぶ
        backtrack(次の状態, 結果リスト); // 進む
        状態から選択肢を削除;     // 戻す（バックトラック）
    }
}
```

### StringBuilder とは

文字列を効率的に組み立てるためのクラス。`String` は不変（変更するたびに新しいオブジェクトが作られる）だが、`StringBuilder` は内部バッファを直接変更するので、文字の追加・削除がO(1)でできる。バックトラッキングで文字列を組み立てる際に適している。

```java
StringBuilder sb = new StringBuilder();  // 空のStringBuilderを作成
sb.append('a');           // 末尾に文字'a'を追加 → "a"
sb.append('b');           // 末尾に文字'b'を追加 → "ab"
sb.deleteCharAt(sb.length() - 1);  // 末尾の文字を削除 → "a"
sb.toString();            // String型に変換して返す → "a"
```

### 電話キーパッドのマッピング

数字と文字の対応を配列で表現する。配列のインデックスが数字に対応し、値がその数字に割り当てられた文字群である。

```java
String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};
// phone[2] → "abc",  phone[7] → "pqrs",  phone[9] → "wxyz"
// 文字'3'から整数3への変換: '3' - '0' → 3
```

## 計算量

| | 値 |
|---|---|
| Time | O(4^n) — 各数字に最大4文字の選択肢があり、n桁分の全組み合わせを列挙する |
| Space | O(n) — 再帰の深さが最大n、StringBuilderの長さも最大n（結果リストを除く） |

## コード

```java
// 入力: 数字2〜9からなる文字列 digits
// 出力: 全ての文字の組み合わせを格納した List<String> を返す

// バックトラックで1桁ずつ文字を選び、全組み合わせを列挙する
void backtrack(String digits, String[] phone, int idx, StringBuilder path, List<String> result) {
    // 終了条件: idxがdigitsの長さに等しければ全桁の文字を選び終えた
    // StringBuilderの内容をStringに変換して結果に追加する
    if (idx == digits.length()) {
        result.add(path.toString());
        return;
    }

    // digits.charAt(idx) - '0' で文字の数字を整数に変換し、phone配列から対応する文字群を取得する
    String letters = phone[digits.charAt(idx) - '0'];

    // 現在の数字に対応する各文字を1つずつ試す
    for (char c : letters.toCharArray()) {
        path.append(c);                            // 選択: 文字を選んで末尾に追加する
        backtrack(digits, phone, idx + 1, path, result);  // 再帰: 次の桁の処理に進む
        path.deleteCharAt(path.length() - 1);      // 復元: 末尾の文字を削除して元に戻す（バックトラック）
    }
}

List<String> letterCombinations(String digits) {
    // 結果を格納する空のリストを作成する
    List<String> result = new ArrayList<>();

    // 空文字列の場合は組み合わせが存在しないので空リストを返す
    if (digits.isEmpty()) return result;

    // インデックスが数字に対応するマッピング配列を定義する
    // インデックス0と1は電話キーパッドで文字が割り当てられていないので空文字列にする
    String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    // 位置0から空のStringBuilderでバックトラックを開始する
    backtrack(digits, phone, 0, new StringBuilder(), result);

    // 全ての再帰が完了し、全組み合わせが格納されたresultを返す
    return result;
}
```
