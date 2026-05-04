# Designing a Simplified Twitter Feed — 複数ユーザーのツイートから最新10件を効率的に取得するシステムを設計する

## 問題の本質

簡易版Twitterシステムとして4つの操作を実装する。`postTweet`でツイートを投稿し、`getNewsFeed`でそのユーザーとフォロー中ユーザーのツイートから**最新10件**を取得し、`follow`でフォローし、`unfollow`でフォロー解除する。核心的な課題は、複数ユーザーのツイートリストを**時系列順にマージして上位10件だけを効率的に抽出する**ことにある。

## 核心のアイデア

各ユーザーのツイートリストはすでに投稿順（時系列順）にソートされている。複数のソート済みリストから上位K件を取り出す問題は、全リストをソートし直すのではなく、**ヒープを使ったK-wayマージ**で各リストの先頭だけを比較しながら1件ずつ取り出すことで、必要最小限の比較回数で解ける。

## 思考プロセス

1. **データの保持方法を決める**: 各ユーザーが投稿したツイートを時系列で管理する必要がある。ユーザーIDをキー、ツイートのリストをバリューとするHashMapを使えば、任意のユーザーのツイート一覧をO(1)で取得できる。各ツイートにはグローバルなタイムスタンプを付与して投稿順序を記録する
2. **フォロー関係の管理方法を決める**: フォロー・アンフォローはユーザーIDの集合の追加・削除に対応する。ユーザーIDをキー、フォロー先のIDのSetをバリューとするHashMapを使えば、フォロー追加・削除・一覧取得がすべてO(1)でできる
3. **ニュースフィード取得の本質を見抜く**: `getNewsFeed`は、自分とフォロー中の全ユーザーのツイートから最新10件を返す操作である。各ユーザーのツイートリストは投稿順にソート済みなので、これは**複数のソート済みリストから上位K件を取り出す問題（K-wayマージ）**に帰着する
4. **K-wayマージにヒープを使う**: 各ユーザーのツイートリストの末尾（最新ツイート）をMax-Heapに入れる。ヒープからタイムスタンプが最大の要素を取り出し、そのユーザーの次に新しいツイートをヒープに追加する。これを10回繰り返せば最新10件が得られる
5. **ヒープの各要素に持たせる情報を決める**: ヒープから取り出した後に同じユーザーの次のツイートを追加するため、各エントリには「タイムスタンプ」「ツイートID」「ユーザーID」「リスト内のインデックス」の4つを持たせる。インデックスを1つ減らせば、そのユーザーの次に新しいツイートにアクセスできる
6. **10件取得したら早期終了する**: ヒープが空になるか、結果リストが10件に達した時点でループを終了する。全ツイートを処理する必要はない

## 前提知識

### PriorityQueue（優先度キュー / ヒープ）とは

要素を追加するたびに優先度順に自動で並び替えるデータ構造。最も優先度の高い要素をO(log N)で取り出せる。JavaのPriorityQueueはデフォルトでMin-Heap（最小値が先頭）だが、Comparatorを指定してMax-Heap（最大値が先頭）に変更できる。

```java
// Max-Heap（タイムスタンプが大きい=新しいものが先頭）を作成する
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> b[0] - a[0]);
pq.offer(new int[]{5, 101});   // [タイムスタンプ, ツイートID] を追加する
pq.offer(new int[]{3, 102});   // 追加後、内部でタイムスタンプ降順に整列する
int[] top = pq.poll();         // 最大のタイムスタンプを持つ要素を取り出す → [5, 101]
pq.isEmpty();                  // ヒープが空かをbooleanで返す → false
```

### computeIfAbsent とは

HashMapのキーが存在しない場合にのみ、指定した関数でバリューを生成して登録し、そのバリューを返すメソッド。キーが存在する場合は既存のバリューをそのまま返す。`get`して`null`チェックして`put`する3ステップを1行にまとめられる。

```java
Map<Integer, List<int[]>> tweets = new HashMap<>();
// キー1が存在しなければ新しいArrayListを作成して登録し、そのリストを返す
tweets.computeIfAbsent(1, k -> new ArrayList<>()).add(new int[]{0, 101});
// キー1は既に存在するので、既存のリストを返し、そこに追加する
tweets.computeIfAbsent(1, k -> new ArrayList<>()).add(new int[]{1, 102});
```

### K-wayマージ とは

K個のソート済みリストを1つのソート済みシーケンスに統合する手法。各リストの先頭要素だけをヒープに入れ、最小（または最大）を取り出すたびに、取り出した要素が属するリストの次の要素をヒープに追加する。全要素をまとめてソートするO(N log N)より効率的に、O(N log K)で統合できる。

## 計算量

| | 値 |
|---|---|
| Time | O(K log K) — Kはフォロー中のユーザー数。ヒープへの初期挿入にO(K log K)、最大10回のpoll/offerにO(10 log K)がかかる |
| Space | O(K) — ヒープには最大K個の要素が同時に格納される |

## コード

```java
// 入力: postTweet(userId, tweetId)、follow(followerId, followeeId)、unfollow(followerId, followeeId)、getNewsFeed(userId) の各操作呼び出し
// 出力: getNewsFeed はユーザーとそのフォロー先のツイートから最新10件のツイートIDを List<Integer> で返す
class Twitter {
    // グローバルなタイムスタンプ。すべてのユーザーのツイート間で投稿順序を一意に識別する
    // 単調増加するため、異なるユーザーのツイート同士でも正しく時系列比較できる
    int time = 0;
    // キー=ユーザーID、バリュー=そのユーザーのツイートリスト（各要素は[タイムスタンプ, ツイートID]）
    // リストは投稿順に末尾へ追加されるため、末尾が最新になる
    Map<Integer, List<int[]>> tweets;
    // キー=フォローする側のユーザーID、バリュー=フォロー先ユーザーIDのSet
    // Setを使うことでフォロー追加・削除・重複排除がすべてO(1)でできる
    Map<Integer, Set<Integer>> follows;

    Twitter() {
        tweets = new HashMap<>();
        follows = new HashMap<>();
    }

    void postTweet(int userId, int tweetId) {
        // ユーザーのツイートリストを取得し（なければ作成し）、末尾に[タイムスタンプ, ツイートID]を追加する
        // time++でグローバルタイムスタンプを付与し、投稿順序を記録する
        tweets.computeIfAbsent(userId, k -> new ArrayList<>())
            .add(new int[]{time++, tweetId});
    }

    void follow(int followerId, int followeeId) {
        // フォロー先SetにfolloweeIdを追加する（Setなので同じユーザーを二重にフォローしても重複しない）
        follows.computeIfAbsent(followerId, k -> new HashSet<>())
            .add(followeeId);
    }

    void unfollow(int followerId, int followeeId) {
        // フォロー関係が存在する場合のみ、followeeIdをSetから削除する
        // 存在しないキーに対してgetすると NullPointerException になるので containsKey で先に判定する
        if (follows.containsKey(followerId))
            follows.get(followerId).remove(followeeId);
    }

    List<Integer> getNewsFeed(int userId) {
        // Max-Heap: タイムスタンプが大きい（新しい）ものが先頭に来るようComparatorを指定する
        PriorityQueue<int[]> pq =
            new PriorityQueue<>((a, b) -> b[0] - a[0]);

        // フィード対象ユーザー = 自分 + フォロー中の全ユーザー
        // 自分のツイートもフィードに含める必要があるため、自分自身を忘れずに追加する
        Set<Integer> users = new HashSet<>();
        users.add(userId);
        if (follows.containsKey(userId))
            users.addAll(follows.get(userId));

        // 各ユーザーの最新ツイート（リスト末尾）をヒープに追加する（K-wayマージの初期化）
        for (int uid : users) {
            // ツイートが存在しないユーザーはスキップする
            if (!tweets.containsKey(uid)) continue;
            List<int[]> t = tweets.get(uid);
            int idx = t.size() - 1;
            int[] tw = t.get(idx);
            // [タイムスタンプ, ツイートID, ユーザーID, リスト内インデックス]
            // ユーザーIDとインデックスを含めるのは、取り出した後にそのユーザーの次のツイートを辿るため
            pq.offer(new int[]{tw[0], tw[1], uid, idx});
        }

        // ヒープから最大10件を取り出す（K-wayマージの実行）
        List<Integer> res = new ArrayList<>();
        while (!pq.isEmpty() && res.size() < 10) {
            // タイムスタンプが最大の要素を取り出す
            int[] top = pq.poll();
            // 取り出したツイートIDを結果に追加する
            res.add(top[1]);
            int uid = top[2];
            // インデックスを1つ減らして、そのユーザーの次に新しいツイートを指す
            int idx = top[3] - 1;
            // そのユーザーにまだ古いツイートがあればヒープに追加する（インデックスが負なら全て処理済み）
            if (idx >= 0) {
                int[] tw = tweets.get(uid).get(idx);
                pq.offer(new int[]{tw[0], tw[1], uid, idx});
            }
        }
        // 最新10件（またはツイート総数が10未満の場合は全件）のツイートIDがタイムスタンプ降順で格納されている
        return res;
    }
}
```
