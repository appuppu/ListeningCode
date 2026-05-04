# Two Sum — 2つの数の合計がターゲットになるペアを見つける

## 問題の本質

整数の配列 `nums` と整数 `target` が与えられる。`nums` の中から合計が `target` になる2つの要素を見つけ、その**インデックス**を配列で返す。解は必ず1つだけ存在し、同じ要素を2回使うことはできない。

## 核心のアイデア

配列を走査するとき、各要素 `nums[i]` に対して「ペアの相手（target - nums[i]）」は一意に決まる。過去に見た要素をHashMapに記録しておけば、相手が存在するかをO(1)で確認でき、1回の走査で答えが見つかる。

## 思考プロセス

1. **ペアの相手は計算で求まる**: 合計が `target` になるペアを探すので、現在の要素 `nums[i]` に対して、もう片方の値は `complement = target - nums[i]` で一意に決まる
2. **相手が過去に出現したかを高速に判定したい**: 配列を走査しながら、これまでに見た数値を記録しておけば、complementが記録済みかをO(1)で判定できる。この記録にはHashMapが適している
3. **HashMapに何を保存するか**: 問題はインデックスを返す必要があるので、HashMapのキーに「数値」、バリューに「その数値のインデックス」を保存する。こうすれば相手の存在確認とインデックス取得が同時にできる
4. **走査しながらHashMapを構築する**: 配列を先頭から順に走査し、各要素について「complementがHashMapにあるか」を判定する。あればペア発見、なければ現在の要素をHashMapに登録して次へ進む
5. **登録は判定の後に行う**: HashMapへの登録を判定より先に行うと、`nums[i]` 自身がcomplementとしてマッチしてしまう。そのため、判定→登録の順番を守る
6. **最終的に返すもの**: complementがHashMapに見つかった時点で、`map.get(complement)`（相手のインデックス）と `i`（現在のインデックス）の2つを `int[]` で返す

## 前提知識

### HashMap とは

キーと値のペアを保存するデータ構造。キーを指定して値の検索・取得がO(1)でできる。配列のインデックスアクセスと同じ速度で、任意のキーでアクセスできる辞書のようなもの。

```java
HashMap<Integer, Integer> map = new HashMap<>();  // 空のHashMapを作成
map.put(10, 0);           // キー10に値0を格納する
map.containsKey(10);      // キー10が存在するかをbooleanで返す → true
map.get(10);              // キー10に対応する値を返す → 0
```

### complement（補数）とは

`target` から現在の要素を引いた値。ペアの相手にあたる数。`complement = target - nums[i]` で計算する。
例: target=9, nums[i]=2 のとき、complement=7。配列の中に7があればペアが成立する。

## 計算量

| | 値 |
|---|---|
| Time | O(n) — 配列を1回走査するだけで済む |
| Space | O(n) — HashMapに最大n個の要素を保存する |

## コード

```java
// 入力: 整数配列 nums と整数 target
// 出力: 合計が target になる2要素のインデックスを int[] で返す
public int[] twoSum(int[] nums, int target) {
    // キー=数値、バリュー=その数値のインデックス を保存するHashMap
    // 問題が求めるのは値ではなくインデックスなので、バリューにインデックスを保存する
    HashMap<Integer, Integer> map = new HashMap<>();

    for (int i = 0; i < nums.length; i++) {
        // ペアの相手を計算し、変数に入れて containsKey と get で再利用する
        int complement = target - nums[i];

        // complementが既にHashMapに登録されていればペア発見
        if (map.containsKey(complement)) {
            // map.get(complement) が相手のインデックス、i が現在のインデックス
            return new int[]{map.get(complement), i};
        }

        // 注意: 登録は判定の後に行う。先に登録すると nums[i] 自身がマッチしてしまう
        map.put(nums[i], i);
    }
    // 問題の制約上、解は必ず存在するのでここには到達しない
    return new int[]{};
}
```
