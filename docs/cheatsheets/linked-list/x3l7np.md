# Designing a Least Recently Used Cache — 容量超過時に最も古く使われた要素を自動削除するキャッシュを設計する

## 問題の本質

整数のキーと値を保存するキャッシュを設計する。`get(key)` と `put(key, value)` の2つの操作をサポートし、両方ともO(1)で動作する必要がある。キャッシュが容量 `capacity` を超えた場合、**最も長い間使われていない（Least Recently Used）要素**を自動的に削除してから新しい要素を挿入する。

## 核心のアイデア

JavaのLinkedHashMapをアクセス順序モードで生成し、`removeEldestEntry` をオーバーライドすれば、get/putのたびにアクセス順序が自動更新され、容量超過時には最古の要素が自動削除される。LRUキャッシュの全機能がLinkedHashMapの内部機構だけで実現できる。

## 思考プロセス

1. **O(1)のget/putが必要**: キーから値への高速なアクセスにはHashMapが必要である。しかし通常のHashMapには要素の使用順序を追跡する機能がない
2. **使用順序の追跡が必要**: LRUでは「最も古く使われた要素」を特定する必要がある。要素がアクセスされるたびに「最新」に移動し、先頭に残った要素が「最古」となる順序付きの構造が必要である
3. **LinkedHashMapがこの2つを兼ね備える**: JavaのLinkedHashMapはHashMapの機能に加え、内部で双方向連結リストを持っている。コンストラクタの第3引数に `true` を渡すとアクセス順序モードになり、getやputのたびに該当要素がリストの末尾に自動で移動する
4. **容量超過時の自動削除**: LinkedHashMapの `removeEldestEntry` メソッドをオーバーライドし、`size() > capacity` のときに `true` を返すようにする。LinkedHashMapは新しい要素をputした直後にこのメソッドを呼び出し、`true` が返された場合にリストの先頭（最古の要素）を自動で削除する
5. **getで存在しないキーの場合**: 問題の仕様ではキーが存在しない場合に `-1` を返す必要がある。`getOrDefault(key, -1)` を使えば、存在チェックと値の取得を1回の呼び出しで行える
6. **最終的な構造**: コンストラクタでLinkedHashMapをアクセス順序モードで生成し、`removeEldestEntry` をオーバーライドするだけで、get/putの両メソッドはLinkedHashMapへの単純な委譲で済む

## 前提知識

### LinkedHashMap とは

HashMapの全機能に加えて、要素の順序を内部の双方向連結リストで保持するデータ構造。コンストラクタの第3引数 `accessOrder` に `true` を渡すと、要素がアクセス（getまたはput）されるたびに、その要素がリストの末尾に移動する。リストの先頭には最も長い間アクセスされていない要素が残る。

```java
// 第1引数: 初期容量, 第2引数: 負荷係数, 第3引数: true=アクセス順序モード
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(16, 0.75f, true);
map.put(1, 10);     // キー1に値10を格納する。リスト: [1]
map.put(2, 20);     // キー2に値20を格納する。リスト: [1, 2]
map.get(1);          // キー1にアクセスする。リスト: [2, 1]（1が末尾に移動）
map.put(3, 30);     // キー3に値30を格納する。リスト: [2, 1, 3]
// この時点でリスト先頭のキー2が「最も古く使われた要素」
```

### removeEldestEntry とは

LinkedHashMapが新しい要素をputした直後に自動で呼び出すメソッド。このメソッドが `true` を返すと、LinkedHashMapはリストの先頭にある最古の要素を自動で削除する。デフォルトでは常に `false` を返すので、オーバーライドして削除条件を定義する。

```java
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(cap, 0.75f, true) {
    @Override
    protected boolean removeEldestEntry(Map.Entry<Integer, Integer> eldest) {
        return size() > cap;  // サイズが容量を超えたらtrueを返し、最古の要素を削除させる
    }
};
```

### getOrDefault とは

Mapインターフェースのメソッド。キーが存在すればその値を返し、存在しなければ第2引数に指定したデフォルト値を返す。`containsKey` と `get` の2回の呼び出しを1回にまとめられる。

```java
map.put(1, 10);
map.getOrDefault(1, -1);   // キー1は存在するので値10を返す
map.getOrDefault(99, -1);  // キー99は存在しないのでデフォルト値-1を返す
```

## 計算量

| | 値 |
|---|---|
| Time | O(1) — get/putともにHashMapのアクセスとリスト内の移動はすべてO(1)で動作する |
| Space | O(n) — キャッシュの容量分の要素をLinkedHashMap内に保存する（nはcapacity） |

## コード

```java
// 入力: コンストラクタに整数 capacity（キャッシュの最大容量）、get に整数 key、put に整数 key と整数 value
// 出力: get はキーに対応する値を返す（キーが存在しない場合は -1）。put は値を返さない
class LRUCache {
    LinkedHashMap<Integer, Integer> map;
    // 容量を保存するインスタンス変数。removeEldestEntry 内で削除判定に使用する
    int cap;

    // 容量を受け取り、アクセス順序モードのLinkedHashMapを初期化する
    LRUCache(int capacity) {
        cap = capacity;
        // 第1引数: 初期容量, 第2引数: デフォルトの負荷係数, 第3引数: true=アクセス順序モード
        // アクセス順序モードにより、getやputのたびに該当要素がリスト末尾に自動移動する
        map = new LinkedHashMap<>(cap, 0.75f, true) {
            // putのたびにLinkedHashMapが自動で呼び出すメソッド
            // size() > cap のとき true を返し、リスト先頭の最古の要素を自動削除させる
            // これによりキャッシュのサイズは常に cap 以下に保たれる
            protected boolean removeEldestEntry(Map.Entry<Integer, Integer> e) {
                return size() > cap;
            }
        };
    }

    // キーが存在する場合: アクセス順序モードにより該当要素がリスト末尾に移動し（最新として記録され）、値が返される
    // キーが存在しない場合: デフォルト値 -1 が返される
    int get(int key) {
        return map.getOrDefault(key, -1);
    }

    // キーと値のペアを挿入または更新する
    // 挿入後に removeEldestEntry が自動で呼ばれ、size() > cap であれば最古の要素が削除される
    // キーが既に存在する場合は値が上書きされ、該当要素がリスト末尾に移動する
    void put(int key, int value) {
        map.put(key, value);
    }
}
```
