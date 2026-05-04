# Designing a Time-Based Key-Value Store — タイムスタンプ付きキーバリューストアを設計する

## 問題の本質

`set(key, value, timestamp)` でキーと値をタイムスタンプ付きで保存し、`get(key, timestamp)` で指定タイムスタンプ**以下**の最大タイムスタンプに対応する値を返すデータ構造を設計する。該当するタイムスタンプが存在しない場合は空文字列を返す。

## 核心のアイデア

各キーに対してタイムスタンプをソート済みで保持すれば、「指定値以下の最大のキー」を対数時間で検索できる。JavaのTreeMapはこの操作を `floorEntry` メソッドとして組み込みで提供している。

## 思考プロセス

1. **操作を整理する**: `set` はキーにタイムスタンプと値のペアを追加する操作、`get` は「指定タイムスタンプ以下で最大のタイムスタンプ」に対応する値を返す操作である。`get` の本質は「ある値以下の最大値を探す」検索問題である
2. **キーごとにタイムスタンプを管理する**: 異なるキーは互いに独立なので、外側のHashMapでキーごとに分離し、各キーに対してタイムスタンプ→値の対応を保持する構造にする
3. **「以下の最大値」を効率的に求めるデータ構造を選ぶ**: ソート済みデータに対して「ある値以下の最大」を求めるには二分探索が必要である。TreeMap（赤黒木ベースの平衡二分探索木）はキーをソート順で保持し、`floorEntry(key)` で「指定キー以下の最大エントリ」をO(log n)で返す
4. **setの実装を決める**: 外側のHashMapにキーが未登録なら新しいTreeMapを作成し、TreeMapにタイムスタンプをキー・値をバリューとして `put` する。`computeIfAbsent` を使えば存在確認と作成を1行で書ける
5. **getの実装を決める**: まずHashMapにキーが存在するか確認し、存在しなければ空文字列を返す。存在すればTreeMapの `floorEntry(timestamp)` を呼び出し、結果がnullでなければその値を、nullなら空文字列を返す
6. **エッジケースを処理する**: キー自体が未登録の場合と、キーは存在するがタイムスタンプが全て指定値より大きい場合の2つで空文字列を返す

## 前提知識

### HashMap とは

キーと値のペアを保存するデータ構造。キーを指定して値の検索・取得がO(1)でできる。

```java
HashMap<String, TreeMap<Integer, String>> map = new HashMap<>();  // 空のHashMapを作成
map.containsKey("foo");    // キー"foo"が存在するかをbooleanで返す
map.get("foo");            // キー"foo"に対応する値を返す
```

### computeIfAbsent とは

HashMapのメソッド。キーが未登録の場合のみ、ラムダ式で値を生成して登録し、その値を返す。キーが既に存在する場合は既存の値を返す。存在確認→作成→登録を1行で書ける。

```java
map.computeIfAbsent("foo", k -> new TreeMap<>());
// "foo"が未登録 → 新しいTreeMapを作成して登録し、そのTreeMapを返す
// "foo"が登録済み → 既存のTreeMapを返す
```

### TreeMap とは

キーをソート順（昇順）で保持する平衡二分探索木ベースのMap。通常のHashMapと異なり、キーの大小関係に基づく検索操作を提供する。`put` と `get` はO(log n)で動作する。

```java
TreeMap<Integer, String> tree = new TreeMap<>();  // 空のTreeMapを作成
tree.put(1, "one");        // タイムスタンプ1に"one"を格納
tree.put(3, "three");      // タイムスタンプ3に"three"を格納
tree.put(5, "five");       // タイムスタンプ5に"five"を格納
```

### floorEntry とは

TreeMapのメソッド。指定したキー**以下**の最大のキーに対応するエントリ（キーと値のペア）を返す。該当するエントリが存在しない場合はnullを返す。内部で二分探索を行うためO(log n)で動作する。

```java
tree.floorEntry(4);   // キー4以下の最大 → キー3のエントリ {3="three"} を返す
tree.floorEntry(5);   // キー5以下の最大 → キー5のエントリ {5="five"} を返す
tree.floorEntry(0);   // キー0以下のエントリは存在しない → null を返す

Map.Entry<Integer, String> entry = tree.floorEntry(4);
entry.getValue();     // エントリから値を取得 → "three"
```

## 計算量

| | 値 |
|---|---|
| Time | O(log n) — set・getともにTreeMapの操作がO(log n)（nはそのキーに保存されたタイムスタンプの数） |
| Space | O(n) — 全てのset呼び出しで保存されたエントリを格納する（nは全エントリ数） |

## コード

```java
// 入力: set(key, value, timestamp) — 文字列キー、文字列値、整数タイムスタンプ / get(key, timestamp) — 文字列キー、整数タイムスタンプ
// 出力: set は戻り値なし / get は該当する値の文字列を返す（該当なしなら空文字列）
class TimeMap {
    // キー → (タイムスタンプ → 値) のTreeMapを保持するHashMap
    // 外側のHashMapでキーごとに分離し、内側のTreeMapでタイムスタンプをソート順に保持する
    Map<String, TreeMap<Integer, String>> map;

    public TimeMap() {
        // 外側のデータ構造としてHashMapを作成する
        map = new HashMap<>();
    }

    public void set(String key, String val, int ts) {
        // computeIfAbsentでキーが未登録なら新しいTreeMapを自動作成・登録し、既存なら既存のTreeMapを返す
        // TreeMapは挿入時にキーをソート順で配置するため、明示的なソート操作は不要
        map.computeIfAbsent(key, k -> new TreeMap<>())
            .put(ts, val);
    }

    public String get(String key, int ts) {
        // キー自体が存在しなければ、一度もsetが呼ばれていないので空文字列を返す
        if (!map.containsKey(key))
            return "";

        // そのキーのTreeMapを取得する
        TreeMap<Integer, String> tree = map.get(key);

        // 指定タイムスタンプ以下の最大エントリを検索する（TreeMapが内部の二分探索木をO(log n)で探索する）
        Map.Entry<Integer, String> entry = tree.floorEntry(ts);

        // エントリが見つかれば値を返す。nullの場合は全タイムスタンプが指定値より大きいことを意味するので空文字列を返す
        return entry != null ? entry.getValue() : "";
    }
}
```
