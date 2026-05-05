# Designing a Simplified Twitter Feed — 設計一個從多個使用者的推文中高效取得最新10則的系統

## 問題的本質

實作一個簡易版Twitter系統的4種操作。使用`postTweet`發布推文，使用`getNewsFeed`從該使用者及其追蹤的使用者的推文中取得**最新10則**，使用`follow`追蹤使用者，使用`unfollow`取消追蹤。核心課題在於，將多個使用者的推文列表**按時間順序合併，並高效地提取前10則**。

## 核心思路

每個使用者的推文列表已經按發布順序（時間順序）排序。從多個已排序列表中取出前K則的問題，不需要對所有列表重新排序，而是透過**使用堆積的K-way合併**，僅比較各列表的開頭元素並逐一取出，就能以最少的比較次數解決。

## 思考過程

1. **決定資料的儲存方式**：需要按時間順序管理每個使用者發布的推文。使用以使用者ID為鍵、推文列表為值的HashMap，就能以O(1)取得任意使用者的推文列表。為每則推文附加全域時間戳以記錄發布順序
2. **決定追蹤關係的管理方式**：追蹤與取消追蹤對應於使用者ID集合的新增與刪除。使用以使用者ID為鍵、追蹤對象ID的Set為值的HashMap，就能以O(1)完成追蹤新增、刪除及列表取得
3. **看透新聞動態取得的本質**：`getNewsFeed`是從自己及所有追蹤中使用者的推文中回傳最新10則的操作。由於每個使用者的推文列表已按發布順序排序，因此可歸結為**從多個已排序列表中取出前K則的問題（K-way合併）**
4. **使用堆積進行K-way合併**：將每個使用者推文列表的末尾（最新推文）放入Max-Heap。從堆積中取出時間戳最大的元素，並將該使用者的下一則較新推文加入堆積。重複此操作10次即可取得最新10則
5. **決定堆積中每個元素需攜帶的資訊**：為了在從堆積取出後能新增同一使用者的下一則推文，每個項目需持有「時間戳」「推文ID」「使用者ID」「列表中的索引」共4項資訊。將索引減1即可存取該使用者的下一則較新推文
6. **取得10則後提前結束**：當堆積變空或結果列表達到10則時終止迴圈。不需要處理所有推文

## 前置知識

### PriorityQueue（優先佇列 / 堆積）

每次新增元素時會自動按優先順序排列的資料結構。能以O(log N)取出優先度最高的元素。Java的PriorityQueue預設為Min-Heap（最小值在開頭），但可透過指定Comparator變更為Max-Heap（最大值在開頭）。

```java
// 建立Max-Heap（時間戳較大=較新的元素排在開頭）
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> b[0] - a[0]);
pq.offer(new int[]{5, 101});   // 新增 [時間戳, 推文ID]
pq.offer(new int[]{3, 102});   // 新增後，內部按時間戳降序排列
int[] top = pq.poll();         // 取出時間戳最大的元素 → [5, 101]
pq.isEmpty();                  // 以boolean回傳堆積是否為空 → false
```

### computeIfAbsent

當HashMap的鍵不存在時，才使用指定的函數生成值並註冊，然後回傳該值的方法。當鍵已存在時，直接回傳現有的值。能將`get`、`null`檢查、`put`三個步驟合併為一行。

```java
Map<Integer, List<int[]>> tweets = new HashMap<>();
// 若鍵1不存在，則建立新的ArrayList並註冊，回傳該列表
tweets.computeIfAbsent(1, k -> new ArrayList<>()).add(new int[]{0, 101});
// 鍵1已存在，因此回傳現有列表並向其中新增元素
tweets.computeIfAbsent(1, k -> new ArrayList<>()).add(new int[]{1, 102});
```

### K-way合併

將K個已排序列表統合為一個已排序序列的手法。僅將各列表的開頭元素放入堆積，每次取出最小（或最大）元素時，將該元素所屬列表的下一個元素加入堆積。比起將所有元素彙總排序的O(N log N)，能更高效地以O(N log K)完成統合。

## 計算量

| | 值 |
|---|---|
| Time | O(K log K) — K為追蹤中的使用者數。堆積的初始插入需O(K log K)，最多10次的poll/offer需O(10 log K) |
| Space | O(K) — 堆積中最多同時儲存K個元素 |

## 程式碼

```java
// 輸入：postTweet(userId, tweetId)、follow(followerId, followeeId)、unfollow(followerId, followeeId)、getNewsFeed(userId) 的各操作呼叫
// 輸出：getNewsFeed 從使用者及其追蹤對象的推文中回傳最新10則推文ID，以 List<Integer> 形式回傳
class Twitter {
    // 全域時間戳。用於在所有使用者的推文間唯一識別發布順序
    // 由於單調遞增，即使是不同使用者的推文也能正確進行時間順序比較
    int time = 0;
    // 鍵=使用者ID，值=該使用者的推文列表（每個元素為[時間戳, 推文ID]）
    // 列表按發布順序新增至末尾，因此末尾為最新
    Map<Integer, List<int[]>> tweets;
    // 鍵=追蹤者的使用者ID，值=追蹤對象使用者ID的Set
    // 使用Set使得追蹤新增、刪除、去重皆為O(1)
    Map<Integer, Set<Integer>> follows;

    Twitter() {
        tweets = new HashMap<>();
        follows = new HashMap<>();
    }

    void postTweet(int userId, int tweetId) {
        // 取得使用者的推文列表（若不存在則建立），在末尾新增[時間戳, 推文ID]
        // 透過time++附加全域時間戳，記錄發布順序
        tweets.computeIfAbsent(userId, k -> new ArrayList<>())
            .add(new int[]{time++, tweetId});
    }

    void follow(int followerId, int followeeId) {
        // 將followeeId新增至追蹤對象Set（由於使用Set，重複追蹤同一使用者也不會產生重複）
        follows.computeIfAbsent(followerId, k -> new HashSet<>())
            .add(followeeId);
    }

    void unfollow(int followerId, int followeeId) {
        // 僅在追蹤關係存在時，從Set中移除followeeId
        // 對不存在的鍵呼叫get會導致NullPointerException，因此先用containsKey判定
        if (follows.containsKey(followerId))
            follows.get(followerId).remove(followeeId);
    }

    List<Integer> getNewsFeed(int userId) {
        // Max-Heap：指定Comparator使時間戳較大（較新）的元素排在開頭
        PriorityQueue<int[]> pq =
            new PriorityQueue<>((a, b) -> b[0] - a[0]);

        // 動態來源使用者 = 自己 + 所有追蹤中的使用者
        // 由於自己的推文也需包含在動態中，不要忘記新增自己
        Set<Integer> users = new HashSet<>();
        users.add(userId);
        if (follows.containsKey(userId))
            users.addAll(follows.get(userId));

        // 將每個使用者的最新推文（列表末尾）加入堆積（K-way合併的初始化）
        for (int uid : users) {
            // 跳過沒有推文的使用者
            if (!tweets.containsKey(uid)) continue;
            List<int[]> t = tweets.get(uid);
            int idx = t.size() - 1;
            int[] tw = t.get(idx);
            // [時間戳, 推文ID, 使用者ID, 列表內索引]
            // 包含使用者ID和索引是為了在取出後能追溯該使用者的下一則推文
            pq.offer(new int[]{tw[0], tw[1], uid, idx});
        }

        // 從堆積中取出最多10則（K-way合併的執行）
        List<Integer> res = new ArrayList<>();
        while (!pq.isEmpty() && res.size() < 10) {
            // 取出時間戳最大的元素
            int[] top = pq.poll();
            // 將取出的推文ID新增至結果
            res.add(top[1]);
            int uid = top[2];
            // 將索引減1，指向該使用者的下一則較新推文
            int idx = top[3] - 1;
            // 若該使用者還有更早的推文則加入堆積（索引為負表示已全部處理完畢）
            if (idx >= 0) {
                int[] tw = tweets.get(uid).get(idx);
                pq.offer(new int[]{tw[0], tw[1], uid, idx});
            }
        }
        // 最新10則（或推文總數少於10則時為全部）的推文ID已按時間戳降序儲存
        return res;
    }
}
```
