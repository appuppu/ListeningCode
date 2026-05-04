# Finding the Shortest Word Transformation Sequence — 最短の単語変換列の長さを求める

## 問題の本質

開始単語 `beginWord`、終了単語 `endWord`、有効な単語の辞書 `wordList` が与えられる。開始単語から終了単語まで、**1ステップで1文字だけ変更**し、すべての中間単語が辞書に存在するような変換列のうち、**最短の長さ**を返す。変換列が存在しない場合は0を返す。

## 核心のアイデア

単語間の1文字変換をグラフの辺とみなせば、最短変換列は最短経路問題になる。BFSを始点と終点の両方から同時に実行し、常に小さい方のフロンティアを拡張することで、探索空間を劇的に削減できる。

## 思考プロセス

1. **グラフとして捉える**: 各単語をノード、1文字違いの単語同士を辺で結んだグラフを考える。最短変換列の長さは、このグラフ上のbeginWordからendWordへの最短経路の長さに相当する
2. **最短経路にはBFSを使う**: 重みなしグラフの最短経路問題なので、BFS（幅優先探索）が適している。各レベルが変換1ステップに対応する
3. **単方向BFSの非効率さ**: 始点からだけBFSを行うと、各レベルで候補が指数的に増える。探索空間は深さに応じて爆発する
4. **双方向BFSで探索空間を縮小する**: 始点と終点の両方からBFSを同時に進めると、両者が出会った時点で最短経路が見つかる。片方の探索深さがd/2で済むため、探索空間が大幅に縮小する
5. **小さい方のフロンティアを優先的に拡張する**: 毎ステップで、始点側と終点側のフロンティア（現在のレベルの単語集合）のサイズを比較し、小さい方を拡張する。こうすることで常にフロンティアの膨張を抑えられる
6. **隣接単語の生成方法**: 辞書内の全単語と比較する代わりに、単語の各位置に対してa〜zの26文字を試すことで隣接単語を生成する。単語長mが辞書サイズnより十分小さい場合、こちらが効率的である
7. **相手のフロンティアとの合流判定**: 生成した隣接単語が相手側のフロンティアに含まれていれば、両方の探索が合流したことを意味し、その時点でのレベル+1を返す

## 前提知識

### BFS（幅優先探索）とは

グラフの始点から近い順にノードを探索するアルゴリズム。各レベルで距離が1ずつ増えるため、最初に到達した時点の距離が最短距離となる。重みなしグラフの最短経路問題に使用する。

### HashSet とは

要素の集合を保持するデータ構造。要素の追加・検索・削除がO(1)でできる。重複を自動的に排除する。

```java
Set<String> set = new HashSet<>();   // 空のHashSetを作成
set.add("hot");                      // 要素を追加する
set.contains("hot");                 // 要素が存在するかをbooleanで返す → true
set.size();                          // 要素数を返す → 1
```

### 双方向BFS とは

通常のBFSが始点からのみ探索するのに対し、双方向BFSは始点と終点の両方から同時に探索を進める。両者のフロンティアが重なった時点で最短経路が見つかる。探索空間がO(b^d)からO(b^(d/2))に削減される（bは分岐因子、dは最短距離）。

### toCharArray / String.valueOf とは

Stringを文字配列に変換し、1文字ずつ操作するためのメソッド群。

```java
char[] ch = "hot".toCharArray();     // String → char[] に変換する → ['h','o','t']
ch[0] = 'b';                        // 1文字を直接書き換える → ['b','o','t']
String next = String.valueOf(ch);    // char[] → String に戻す → "bot"
```

## 計算量

| | 値 |
|---|---|
| Time | O(n × m) — nは辞書の単語数、mは単語の長さ。各単語の各位置に26文字を試す |
| Space | O(n × m) — 訪問済みセットとフロンティアに最大n個の単語（各長さm）を保存する |

## コード

```java
// 入力: 開始単語 beginWord、終了単語 endWord、有効な単語の辞書 wordList
// 出力: 最短変換列の長さを int で返す。変換列が存在しない場合は0を返す
int ladderLength(String beginWord, String endWord, List<String> wordList) {
    // 辞書をHashSetに変換し、単語の存在判定をO(1)にする
    Set<String> wordSet = new HashSet<>(wordList);
    // endWordが辞書にない場合、変換列は作れないため0を返す
    if (!wordSet.contains(endWord)) return 0;

    // 始点側フロンティア・終点側フロンティア・訪問済みセットの3つのHashSetを作成する
    Set<String> start = new HashSet<>();
    Set<String> end = new HashSet<>();
    Set<String> visited = new HashSet<>();
    start.add(beginWord);
    end.add(endWord);
    // 両方のフロンティアの単語を訪問済みに登録しておく
    visited.add(beginWord);
    visited.add(endWord);
    // levelは変換列の長さ（始点自身を1と数える）
    int level = 1;

    // どちらかのフロンティアが空になったら到達不可能なのでループを抜ける
    while (!start.isEmpty() && !end.isEmpty()) {
        // 常に小さい方のフロンティアを拡張し、探索空間の膨張を抑える
        if (start.size() > end.size()) {
            Set<String> temp = start;
            start = end;
            end = temp;
        }

        // 次のレベルの候補を保持するセット
        Set<String> nextLevel = new HashSet<>();

        for (String word : start) {
            // 単語をchar[]に変換し、各位置を1文字ずつ書き換えて隣接単語を生成する
            char[] ch = word.toCharArray();
            for (int j = 0; j < ch.length; j++) {
                // 元の文字を退避し、探索後に戻せるようにする
                char orig = ch[j];
                // 各位置にa〜zの26文字を試して隣接単語を生成する
                for (char c = 'a'; c <= 'z'; c++) {
                    ch[j] = c;
                    String next = String.valueOf(ch);
                    // 相手のフロンティアに含まれていれば両方の探索が合流した
                    if (end.contains(next)) return level + 1;
                    // 辞書にあり未訪問なら次のフロンティアに追加する
                    // visitedに追加することで同じ単語の再訪問を防ぐ
                    if (wordSet.contains(next) && !visited.contains(next)) {
                        nextLevel.add(next);
                        visited.add(next);
                    }
                }
                // 元の文字に戻して次の位置の探索に備える
                ch[j] = orig;
            }
        }
        // フロンティアを次のレベルに置き換え、levelを1増やして次のイテレーションへ
        start = nextLevel;
        level++;
    }
    // どちらかのフロンティアが空になったら変換列は存在しない
    return 0;
}
```
