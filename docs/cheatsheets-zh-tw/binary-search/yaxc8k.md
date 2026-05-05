# Designing a Time-Based Key-Value Store — 設計帶有時間戳的鍵值儲存

## 問題的本質

設計一個資料結構，透過 `set(key, value, timestamp)` 將鍵與值以附帶時間戳的方式儲存，並透過 `get(key, timestamp)` 回傳指定時間戳**以下**的最大時間戳所對應的值。若不存在符合條件的時間戳，則回傳空字串。

## 核心概念

若對每個鍵以排序狀態維護時間戳，就能在對數時間內搜尋「小於等於指定值的最大鍵」。Java 的 TreeMap 以 `floorEntry` 方法內建提供了這項操作。

## 思考過程

1. **整理操作內容**：`set` 是將時間戳與值的配對新增至鍵的操作，`get` 是回傳「小於等於指定時間戳的最大時間戳」所對應值的操作。`get` 的本質是「尋找小於等於某值的最大值」的搜尋問題
2. **按鍵管理時間戳**：不同的鍵彼此獨立，因此使用外層的 HashMap 按鍵分離，並為每個鍵維護時間戳→值的對應結構
3. **選擇能高效求出「小於等於的最大值」的資料結構**：要對已排序資料求出「小於等於某值的最大值」，需要使用二分搜尋。TreeMap（基於紅黑樹的平衡二元搜尋樹）以排序順序維護鍵，透過 `floorEntry(key)` 能以 O(log n) 回傳「小於等於指定鍵的最大條目」
4. **決定 set 的實作方式**：若外層 HashMap 中尚未註冊該鍵，則建立新的 TreeMap，再以時間戳作為鍵、值作為值呼叫 `put`。使用 `computeIfAbsent` 可將存在性檢查與建立合併為一行程式碼
5. **決定 get 的實作方式**：首先確認 HashMap 中是否存在該鍵，若不存在則回傳空字串。若存在則呼叫 TreeMap 的 `floorEntry(timestamp)`，結果不為 null 時回傳該值，為 null 時回傳空字串
6. **處理邊界情況**：鍵本身未註冊的情況，以及鍵存在但所有時間戳皆大於指定值的情況，這兩種情況都回傳空字串

## 前提知識

### 什麼是 HashMap

HashMap 是儲存鍵值配對的資料結構。指定鍵即可以 O(1) 搜尋與取得對應的值。

```java
HashMap<String, TreeMap<Integer, String>> map = new HashMap<>();  // 建立空的 HashMap
map.containsKey("foo");    // 以 boolean 回傳鍵 "foo" 是否存在
map.get("foo");            // 回傳鍵 "foo" 對應的值
```

### 什麼是 computeIfAbsent

computeIfAbsent 是 HashMap 的方法。僅當鍵未註冊時，透過 Lambda 表達式生成值並註冊，然後回傳該值。若鍵已存在，則回傳既有的值。能將存在性檢查→建立→註冊合併為一行程式碼。

```java
map.computeIfAbsent("foo", k -> new TreeMap<>());
// "foo" 未註冊 → 建立新的 TreeMap 並註冊，回傳該 TreeMap
// "foo" 已註冊 → 回傳既有的 TreeMap
```

### 什麼是 TreeMap

TreeMap 是基於平衡二元搜尋樹、以排序順序（升序）維護鍵的 Map。與一般的 HashMap 不同，TreeMap 提供基於鍵大小關係的搜尋操作。`put` 與 `get` 以 O(log n) 運作。

```java
TreeMap<Integer, String> tree = new TreeMap<>();  // 建立空的 TreeMap
tree.put(1, "one");        // 在時間戳 1 儲存 "one"
tree.put(3, "three");      // 在時間戳 3 儲存 "three"
tree.put(5, "five");       // 在時間戳 5 儲存 "five"
```

### 什麼是 floorEntry

floorEntry 是 TreeMap 的方法。回傳小於等於指定鍵的最大鍵所對應的條目（鍵值配對）。若不存在符合條件的條目，則回傳 null。由於內部執行二分搜尋，因此以 O(log n) 運作。

```java
tree.floorEntry(4);   // 小於等於鍵 4 的最大值 → 回傳鍵 3 的條目 {3="three"}
tree.floorEntry(5);   // 小於等於鍵 5 的最大值 → 回傳鍵 5 的條目 {5="five"}
tree.floorEntry(0);   // 不存在小於等於鍵 0 的條目 → 回傳 null

Map.Entry<Integer, String> entry = tree.floorEntry(4);
entry.getValue();     // 從條目取得值 → "three"
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(log n) — set 與 get 皆因 TreeMap 操作而為 O(log n)（n 為該鍵所儲存的時間戳數量） |
| Space | O(n) — 儲存所有 set 呼叫所保存的條目（n 為全部條目數量） |

## 程式碼

```java
// 輸入：set(key, value, timestamp) — 字串鍵、字串值、整數時間戳 / get(key, timestamp) — 字串鍵、整數時間戳
// 輸出：set 無回傳值 / get 回傳符合條件的值的字串（無符合條件者則回傳空字串）
class TimeMap {
    // 維護鍵 → (時間戳 → 值) 的 TreeMap 的 HashMap
    // 外層 HashMap 按鍵分離，內層 TreeMap 以排序順序維護時間戳
    Map<String, TreeMap<Integer, String>> map;

    public TimeMap() {
        // 建立外層資料結構 HashMap
        map = new HashMap<>();
    }

    public void set(String key, String val, int ts) {
        // 透過 computeIfAbsent，若鍵未註冊則自動建立並註冊新的 TreeMap，若已存在則回傳既有的 TreeMap
        // TreeMap 在插入時會將鍵配置於排序位置，因此不需要明確的排序操作
        map.computeIfAbsent(key, k -> new TreeMap<>())
            .put(ts, val);
    }

    public String get(String key, int ts) {
        // 若鍵本身不存在，表示從未呼叫過 set，因此回傳空字串
        if (!map.containsKey(key))
            return "";

        // 取得該鍵的 TreeMap
        TreeMap<Integer, String> tree = map.get(key);

        // 搜尋小於等於指定時間戳的最大條目（TreeMap 以 O(log n) 探索內部的二元搜尋樹）
        Map.Entry<Integer, String> entry = tree.floorEntry(ts);

        // 若找到條目則回傳其值。若為 null 表示所有時間戳皆大於指定值，因此回傳空字串
        return entry != null ? entry.getValue() : "";
    }
}
```
