# Designing a Simplified Twitter Feed — Design a system that efficiently retrieves the 10 most recent tweets from multiple users

## Problem

You implement four operations for a simplified Twitter system. `postTweet` posts a tweet, `getNewsFeed` retrieves the **10 most recent tweets** from the user and the users they follow, `follow` follows a user, and `unfollow` unfollows a user. The core challenge is to **merge tweet lists from multiple users in chronological order and efficiently extract only the top 10 tweets**.

## Key Insight

Each user's tweet list is already sorted in posting order (chronological order). The problem of extracting the top K items from multiple sorted lists can be solved not by re-sorting all lists, but by using a **K-way merge with a heap** that compares only the head of each list and extracts one item at a time, achieving the minimum number of comparisons necessary.

## Thought Process

1. **Decide how to store the data**: You need to manage each user's posted tweets in chronological order. A HashMap with user IDs as keys and tweet lists as values allows you to retrieve any user's tweet list in O(1). You assign a global timestamp to each tweet to record the posting order.
2. **Decide how to manage follow relationships**: Following and unfollowing correspond to adding and removing user IDs from a set. A HashMap with user IDs as keys and Sets of followed user IDs as values allows you to add, remove, and list follows all in O(1).
3. **Identify the essence of news feed retrieval**: `getNewsFeed` is an operation that returns the 10 most recent tweets from the user and all users they follow. Since each user's tweet list is already sorted in posting order, this reduces to **the problem of extracting the top K items from multiple sorted lists (K-way merge)**.
4. **Use a heap for K-way merge**: You insert the tail (most recent tweet) of each user's tweet list into a Max-Heap. You extract the element with the largest timestamp from the heap and add that user's next most recent tweet to the heap. Repeating this 10 times yields the 10 most recent tweets.
5. **Decide what information each heap element holds**: To add the next tweet from the same user after extraction, each entry holds four fields: "timestamp," "tweet ID," "user ID," and "index within the list." Decrementing the index by one gives you access to that user's next most recent tweet.
6. **Terminate early after retrieving 10 items**: You terminate the loop when the heap becomes empty or the result list reaches 10 items. You do not need to process all tweets.

## Prerequisites

### PriorityQueue (Priority Queue / Heap)

A PriorityQueue is a data structure that automatically reorders elements by priority each time you add an element. It can extract the highest-priority element in O(log N). Java's PriorityQueue is a Min-Heap (smallest value at the head) by default, but you can specify a Comparator to change it to a Max-Heap (largest value at the head).

```java
// Create a Max-Heap where the largest timestamp (most recent) is at the head
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> b[0] - a[0]);
pq.offer(new int[]{5, 101});   // Add [timestamp, tweetId]
pq.offer(new int[]{3, 102});   // After adding, elements are internally ordered by timestamp descending
int[] top = pq.poll();         // Extract the element with the largest timestamp → [5, 101]
pq.isEmpty();                  // Return whether the heap is empty as a boolean → false
```

### computeIfAbsent

`computeIfAbsent` is a method that generates and registers a value using a specified function only if the key does not exist in the HashMap, and returns that value. If the key already exists, the method returns the existing value as-is. It condenses the three steps of calling `get`, checking for `null`, and calling `put` into a single line.

```java
Map<Integer, List<int[]>> tweets = new HashMap<>();
// If key 1 does not exist, create a new ArrayList, register it, and return that list
tweets.computeIfAbsent(1, k -> new ArrayList<>()).add(new int[]{0, 101});
// Key 1 already exists, so return the existing list and add to it
tweets.computeIfAbsent(1, k -> new ArrayList<>()).add(new int[]{1, 102});
```

### K-way Merge

K-way merge is a technique for combining K sorted lists into a single sorted sequence. You insert only the head element of each list into a heap, and each time you extract the minimum (or maximum), you add the next element from the list that the extracted element belonged to. This achieves O(N log K) merging, which is more efficient than sorting all elements together at O(N log N).

## Complexity

| | Value |
|---|---|
| Time | O(K log K) — K is the number of followed users. The initial insertion into the heap costs O(K log K), and up to 10 poll/offer operations cost O(10 log K). |
| Space | O(K) — The heap holds at most K elements simultaneously. |

## Code

```java
// Input: operation calls of postTweet(userId, tweetId), follow(followerId, followeeId), unfollow(followerId, followeeId), getNewsFeed(userId)
// Output: getNewsFeed returns a List<Integer> of the 10 most recent tweet IDs from the user and their followed users
class Twitter {
    // Global timestamp that uniquely identifies posting order across all users' tweets
    // Because it monotonically increases, tweets from different users can be correctly compared chronologically
    int time = 0;
    // Key = user ID, Value = that user's tweet list (each element is [timestamp, tweetId])
    // Tweets are appended to the tail in posting order, so the tail is the most recent
    Map<Integer, List<int[]>> tweets;
    // Key = follower's user ID, Value = Set of followed user IDs
    // Using a Set ensures that follow addition, removal, and deduplication are all O(1)
    Map<Integer, Set<Integer>> follows;

    Twitter() {
        tweets = new HashMap<>();
        follows = new HashMap<>();
    }

    void postTweet(int userId, int tweetId) {
        // Retrieve the user's tweet list (create one if it does not exist) and append [timestamp, tweetId] to the tail
        // Assign a global timestamp via time++ to record the posting order
        tweets.computeIfAbsent(userId, k -> new ArrayList<>())
            .add(new int[]{time++, tweetId});
    }

    void follow(int followerId, int followeeId) {
        // Add followeeId to the follow Set (the Set prevents duplicates even if the same user is followed twice)
        follows.computeIfAbsent(followerId, k -> new HashSet<>())
            .add(followeeId);
    }

    void unfollow(int followerId, int followeeId) {
        // Remove followeeId from the Set only if the follow relationship exists
        // Calling get on a nonexistent key would cause a NullPointerException, so check with containsKey first
        if (follows.containsKey(followerId))
            follows.get(followerId).remove(followeeId);
    }

    List<Integer> getNewsFeed(int userId) {
        // Max-Heap: specify a Comparator so that the largest (most recent) timestamp comes first
        PriorityQueue<int[]> pq =
            new PriorityQueue<>((a, b) -> b[0] - a[0]);

        // Feed target users = self + all followed users
        // Include the user's own tweets in the feed, so do not forget to add the user themselves
        Set<Integer> users = new HashSet<>();
        users.add(userId);
        if (follows.containsKey(userId))
            users.addAll(follows.get(userId));

        // Add each user's most recent tweet (tail of the list) to the heap (K-way merge initialization)
        for (int uid : users) {
            // Skip users who have no tweets
            if (!tweets.containsKey(uid)) continue;
            List<int[]> t = tweets.get(uid);
            int idx = t.size() - 1;
            int[] tw = t.get(idx);
            // [timestamp, tweetId, userId, index within the list]
            // Include userId and index so that after extraction you can traverse to that user's next tweet
            pq.offer(new int[]{tw[0], tw[1], uid, idx});
        }

        // Extract up to 10 items from the heap (K-way merge execution)
        List<Integer> res = new ArrayList<>();
        while (!pq.isEmpty() && res.size() < 10) {
            // Extract the element with the largest timestamp
            int[] top = pq.poll();
            // Add the extracted tweet ID to the result
            res.add(top[1]);
            int uid = top[2];
            // Decrement the index by one to point to that user's next most recent tweet
            int idx = top[3] - 1;
            // If that user still has older tweets, add them to the heap (a negative index means all tweets have been processed)
            if (idx >= 0) {
                int[] tw = tweets.get(uid).get(idx);
                pq.offer(new int[]{tw[0], tw[1], uid, idx});
            }
        }
        // The result contains the 10 most recent tweet IDs (or all tweet IDs if fewer than 10 exist) in descending timestamp order
        return res;
    }
}
```
