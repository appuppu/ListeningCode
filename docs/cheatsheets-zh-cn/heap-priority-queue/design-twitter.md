# Designing a Simplified Twitter Feed — 设计一个从多个用户的推文中高效获取最新10条的系统

## 问题的本质

实现一个简易版Twitter系统的4种操作。通过`postTweet`发布推文，通过`getNewsFeed`从该用户及其关注用户的推文中获取**最新10条**，通过`follow`关注用户，通过`unfollow`取消关注。核心课题在于，将多个用户的推文列表**按时间顺序合并，并高效地提取前10条**。

## 核心思路

每个用户的推文列表已经按发布顺序（时间顺序）排好序。从多个已排序列表中取出前K条的问题，不需要对全部列表重新排序，而是通过**基于堆的K-way合并**，只比较各列表的头部元素，逐条取出，从而以最少的比较次数解决问题。

## 思考过程

1. **确定数据的存储方式**: 需要按时间顺序管理每个用户发布的推文。使用以用户ID为键、推文列表为值的HashMap，可以在O(1)时间内获取任意用户的推文列表。为每条推文分配一个全局时间戳来记录发布顺序
2. **确定关注关系的管理方式**: 关注和取消关注对应于用户ID集合的添加和删除操作。使用以用户ID为键、关注对象ID的Set为值的HashMap，可以在O(1)时间内完成关注添加、删除和列表获取
3. **洞察新闻推送获取的本质**: `getNewsFeed`是从自己和所有关注用户的推文中返回最新10条的操作。由于每个用户的推文列表已按发布顺序排好序，因此这可以归结为**从多个已排序列表中取出前K条的问题（K-way合并）**
4. **使用堆进行K-way合并**: 将每个用户推文列表的末尾元素（最新推文）放入Max-Heap中。从堆中取出时间戳最大的元素，然后将该用户的下一条较新推文添加到堆中。重复此操作10次即可获得最新10条
5. **确定堆中每个元素需要保存的信息**: 为了在从堆中取出元素后能添加同一用户的下一条推文，每个条目需要保存「时间戳」「推文ID」「用户ID」「列表内索引」这4项信息。将索引减1即可访问该用户的下一条较新推文
6. **获取10条后提前终止**: 当堆为空或结果列表达到10条时终止循环。不需要处理所有推文

## 前置知识

### PriorityQueue（优先队列 / 堆）

一种每次添加元素时自动按优先级排序的数据结构。可以在O(log N)时间内取出优先级最高的元素。Java的PriorityQueue默认为Min-Heap（最小值在头部），但可以通过指定Comparator将其改为Max-Heap（最大值在头部）。

```java
// 创建Max-Heap（时间戳越大=越新的元素排在头部）
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> b[0] - a[0]);
pq.offer(new int[]{5, 101});   // 添加 [时间戳, 推文ID]
pq.offer(new int[]{3, 102});   // 添加后，内部按时间戳降序排列
int[] top = pq.poll();         // 取出时间戳最大的元素 → [5, 101]
pq.isEmpty();                  // 以boolean返回堆是否为空 → false
```

### computeIfAbsent

仅当HashMap中不存在指定键时，通过指定的函数生成值并注册，然后返回该值的方法。当键已存在时，直接返回已有的值。可以将`get`、`null`检查、`put`这三个步骤合并为一行。

```java
Map<Integer, List<int[]>> tweets = new HashMap<>();
// 如果键1不存在，则创建新的ArrayList并注册，返回该列表
tweets.computeIfAbsent(1, k -> new ArrayList<>()).add(new int[]{0, 101});
// 键1已存在，返回已有的列表，并向其中添加元素
tweets.computeIfAbsent(1, k -> new ArrayList<>()).add(new int[]{1, 102});
```

### K-way合并

将K个已排序列表整合为一个已排序序列的方法。将各列表的头部元素放入堆中，每次取出最小值（或最大值）后，将被取出元素所属列表的下一个元素添加到堆中。相比将所有元素汇总后排序的O(N log N)，可以更高效地以O(N log K)完成整合。

## 计算复杂度

| | 值 |
|---|---|
| Time | O(K log K) — K为关注中的用户数。堆的初始插入需要O(K log K)，最多10次poll/offer需要O(10 log K) |
| Space | O(K) — 堆中同时最多存储K个元素 |

## 代码

```java
// 输入: postTweet(userId, tweetId)、follow(followerId, followeeId)、unfollow(followerId, followeeId)、getNewsFeed(userId) 的各操作调用
// 输出: getNewsFeed 从用户及其关注对象的推文中返回最新10条推文ID，以 List<Integer> 形式返回
class Twitter {
    // 全局时间戳。用于在所有用户的推文之间唯一标识发布顺序
    // 由于单调递增，因此即使是不同用户的推文之间也能正确进行时间顺序比较
    int time = 0;
    // 键=用户ID，值=该用户的推文列表（每个元素为[时间戳, 推文ID]）
    // 列表按发布顺序追加到末尾，因此末尾是最新的
    Map<Integer, List<int[]>> tweets;
    // 键=关注者的用户ID，值=关注对象用户ID的Set
    // 使用Set可以使关注添加、删除、去重都在O(1)时间内完成
    Map<Integer, Set<Integer>> follows;

    Twitter() {
        tweets = new HashMap<>();
        follows = new HashMap<>();
    }

    void postTweet(int userId, int tweetId) {
        // 获取用户的推文列表（如果不存在则创建），在末尾添加[时间戳, 推文ID]
        // 通过time++分配全局时间戳，记录发布顺序
        tweets.computeIfAbsent(userId, k -> new ArrayList<>())
            .add(new int[]{time++, tweetId});
    }

    void follow(int followerId, int followeeId) {
        // 向关注对象Set中添加followeeId（由于是Set，即使重复关注同一用户也不会重复）
        follows.computeIfAbsent(followerId, k -> new HashSet<>())
            .add(followeeId);
    }

    void unfollow(int followerId, int followeeId) {
        // 仅当关注关系存在时，从Set中删除followeeId
        // 对不存在的键调用get会导致NullPointerException，因此先用containsKey进行判断
        if (follows.containsKey(followerId))
            follows.get(followerId).remove(followeeId);
    }

    List<Integer> getNewsFeed(int userId) {
        // Max-Heap: 指定Comparator使时间戳较大（较新）的元素排在头部
        PriorityQueue<int[]> pq =
            new PriorityQueue<>((a, b) -> b[0] - a[0]);

        // 推送对象用户 = 自己 + 所有关注中的用户
        // 由于自己的推文也需要包含在推送中，因此不要忘记添加自己
        Set<Integer> users = new HashSet<>();
        users.add(userId);
        if (follows.containsKey(userId))
            users.addAll(follows.get(userId));

        // 将每个用户的最新推文（列表末尾）添加到堆中（K-way合并的初始化）
        for (int uid : users) {
            // 跳过没有推文的用户
            if (!tweets.containsKey(uid)) continue;
            List<int[]> t = tweets.get(uid);
            int idx = t.size() - 1;
            int[] tw = t.get(idx);
            // [时间戳, 推文ID, 用户ID, 列表内索引]
            // 包含用户ID和索引是为了在取出后能追溯到该用户的下一条推文
            pq.offer(new int[]{tw[0], tw[1], uid, idx});
        }

        // 从堆中取出最多10条（K-way合并的执行）
        List<Integer> res = new ArrayList<>();
        while (!pq.isEmpty() && res.size() < 10) {
            // 取出时间戳最大的元素
            int[] top = pq.poll();
            // 将取出的推文ID添加到结果中
            res.add(top[1]);
            int uid = top[2];
            // 将索引减1，指向该用户的下一条较新推文
            int idx = top[3] - 1;
            // 如果该用户还有更早的推文，则添加到堆中（索引为负表示已全部处理完毕）
            if (idx >= 0) {
                int[] tw = tweets.get(uid).get(idx);
                pq.offer(new int[]{tw[0], tw[1], uid, idx});
            }
        }
        // 最新10条（或推文总数不足10条时为全部）推文ID按时间戳降序存储
        return res;
    }
}
```
