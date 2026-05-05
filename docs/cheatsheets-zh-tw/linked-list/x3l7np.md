# Designing a Least Recently Used Cache — 設計一個在容量超過時自動刪除最久未使用元素的快取

## 問題的本質

設計一個儲存整數鍵與值的快取。該快取需要支援 `get(key)` 和 `put(key, value)` 兩種操作，且兩者都必須以 O(1) 的時間複雜度運作。當快取超過容量 `capacity` 時，系統會自動刪除**最久未使用（Least Recently Used）的元素**，然後再插入新的元素。

## 核心概念

以存取順序模式建立 Java 的 LinkedHashMap，並覆寫 `removeEldestEntry` 方法，即可在每次 get/put 時自動更新存取順序，並在容量超過時自動刪除最舊的元素。LRU 快取的所有功能都能僅透過 LinkedHashMap 的內部機制來實現。

## 思考過程

1. **需要 O(1) 的 get/put**：要從鍵快速存取值，需要使用 HashMap。然而普通的 HashMap 不具備追蹤元素使用順序的功能
2. **需要追蹤使用順序**：LRU 需要識別「最久未使用的元素」。每當元素被存取時，該元素會移動到「最新」位置，而留在開頭的元素則成為「最舊」的元素，因此需要一個有序的資料結構
3. **LinkedHashMap 同時具備這兩項功能**：Java 的 LinkedHashMap 除了具有 HashMap 的功能外，內部還維護了一個雙向鏈結串列。在建構函式的第三個參數傳入 `true` 即可啟用存取順序模式，每次 get 或 put 時，該元素會自動移動到串列的末尾
4. **容量超過時的自動刪除**：覆寫 LinkedHashMap 的 `removeEldestEntry` 方法，使其在 `size() > capacity` 時回傳 `true`。LinkedHashMap 會在 put 新元素後立即呼叫此方法，若回傳 `true`，則自動刪除串列開頭（最舊的元素）
5. **get 時鍵不存在的情況**：根據題目規格，當鍵不存在時需要回傳 `-1`。使用 `getOrDefault(key, -1)` 即可在一次呼叫中完成存在檢查與值的取得
6. **最終結構**：只需在建構函式中以存取順序模式建立 LinkedHashMap 並覆寫 `removeEldestEntry`，get/put 兩個方法就只需單純地委派給 LinkedHashMap 即可

## 前提知識

### LinkedHashMap 是什麼

LinkedHashMap 是一種除了具備 HashMap 的所有功能之外，還透過內部的雙向鏈結串列維護元素順序的資料結構。在建構函式的第三個參數 `accessOrder` 傳入 `true`，每當元素被存取（get 或 put）時，該元素就會移動到串列的末尾。串列的開頭會保留最久未被存取的元素。

```java
// 第1個參數: 初始容量, 第2個參數: 負載因子, 第3個參數: true=存取順序模式
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(16, 0.75f, true);
map.put(1, 10);     // 將值10儲存到鍵1。串列: [1]
map.put(2, 20);     // 將值20儲存到鍵2。串列: [1, 2]
map.get(1);          // 存取鍵1。串列: [2, 1]（1移動到末尾）
map.put(3, 30);     // 將值30儲存到鍵3。串列: [2, 1, 3]
// 此時串列開頭的鍵2是「最久未使用的元素」
```

### removeEldestEntry 是什麼

removeEldestEntry 是 LinkedHashMap 在 put 新元素後自動呼叫的方法。當此方法回傳 `true` 時，LinkedHashMap 會自動刪除串列開頭最舊的元素。預設情況下此方法總是回傳 `false`，因此需要覆寫它來定義刪除條件。

```java
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(cap, 0.75f, true) {
    @Override
    protected boolean removeEldestEntry(Map.Entry<Integer, Integer> eldest) {
        return size() > cap;  // 當大小超過容量時回傳true，使其刪除最舊的元素
    }
};
```

### getOrDefault 是什麼

getOrDefault 是 Map 介面的方法。當鍵存在時回傳對應的值，不存在時回傳第二個參數指定的預設值。此方法可以將 `containsKey` 和 `get` 的兩次呼叫合併為一次。

```java
map.put(1, 10);
map.getOrDefault(1, -1);   // 鍵1存在，因此回傳值10
map.getOrDefault(99, -1);  // 鍵99不存在，因此回傳預設值-1
```

## 計算量

| | 值 |
|---|---|
| Time | O(1) — get/put 皆透過 HashMap 的存取與串列內的移動來運作，全部都是 O(1) |
| Space | O(n) — 在 LinkedHashMap 中儲存快取容量大小的元素（n 為 capacity） |

## 程式碼

```java
// 輸入: 建構函式接收整數 capacity（快取的最大容量），get 接收整數 key，put 接收整數 key 和整數 value
// 輸出: get 回傳鍵對應的值（鍵不存在時回傳 -1）。put 不回傳值
class LRUCache {
    LinkedHashMap<Integer, Integer> map;
    // 儲存容量的實例變數。在 removeEldestEntry 中用於刪除判定
    int cap;

    // 接收容量並初始化存取順序模式的 LinkedHashMap
    LRUCache(int capacity) {
        cap = capacity;
        // 第1個參數: 初始容量, 第2個參數: 預設負載因子, 第3個參數: true=存取順序模式
        // 透過存取順序模式，每次 get 或 put 時該元素會自動移動到串列末尾
        map = new LinkedHashMap<>(cap, 0.75f, true) {
            // LinkedHashMap 在每次 put 時自動呼叫的方法
            // 當 size() > cap 時回傳 true，使其自動刪除串列開頭最舊的元素
            // 藉此快取的大小始終維持在 cap 以下
            protected boolean removeEldestEntry(Map.Entry<Integer, Integer> e) {
                return size() > cap;
            }
        };
    }

    // 鍵存在時: 透過存取順序模式，該元素移動到串列末尾（記錄為最新），並回傳值
    // 鍵不存在時: 回傳預設值 -1
    int get(int key) {
        return map.getOrDefault(key, -1);
    }

    // 插入或更新鍵值對
    // 插入後 removeEldestEntry 會被自動呼叫，若 size() > cap 則刪除最舊的元素
    // 鍵已存在時，值會被覆寫，且該元素移動到串列末尾
    void put(int key, int value) {
        map.put(key, value);
    }
}
```
