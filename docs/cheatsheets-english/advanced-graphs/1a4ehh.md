# Finding the Cheapest Flight With Limited Stops

## Problem

Given `n` cities, a list of flights `[from, to, price]`, a source `src`, a destination `dst`, and a maximum number of stops `k`, return the cheapest total fare to reach the destination from the source with **at most k stops** (at most k intermediate cities). Return `-1` if no such route exists.

## Key Insight

Standard Dijkstra only tracks the minimum-cost path, but in this problem a path with a higher cost but fewer stops may ultimately lead to the cheapest route. By recording the minimum number of stops at which each city has been reached and only continuing exploration for paths that arrive with fewer stops, the algorithm considers both cost and stop count to find the optimal solution.

## Thought Process

1. **Dijkstra is the foundation for finding the cheapest route**: Since this is a shortest-path problem on a weighted graph, Dijkstra's algorithm with a priority queue is the basic approach. By extracting nodes in order of increasing cost, the first time the algorithm reaches the destination is guaranteed to be the cheapest.
2. **How to handle the stop-count constraint**: Standard Dijkstra never revisits a city once reached at minimum cost, but this problem has a stop-count constraint. A minimum-cost path that exceeds k stops is invalid, so a slightly more expensive path with fewer stops may be valid.
3. **Record the minimum number of stops to each city**: Maintain an array `stops[]` that records the minimum number of stops at which each city has been reached. If a path arrives at a city with more stops than previously recorded, it offers no improvement in either cost or stop count, so the algorithm can prune it.
4. **What to store in the priority queue**: Manage each state as a triple `[cost, city, stops]`. By extracting states in ascending order of cost, the first time the algorithm reaches the destination yields the cheapest answer.
5. **Organize the pruning conditions**: (a) If the current stop count is greater than or equal to the recorded minimum stops for that city, terminate exploration of this path. (b) If the stop count exceeds k, do not expand to neighboring cities.
6. **Expand to neighboring cities**: Only when a state passes the pruning checks, add `[current cost + fare, neighbor, stops + 1]` to the queue for each neighboring city.

## Prerequisites

### Adjacency List

An adjacency list is a data structure that stores, for each vertex in a graph, the list of directly reachable vertices along with edge weights. It is represented as a `HashMap<Integer, List<int[]>>` where the key is the departure city and the value is a list of `[destination city, fare]` pairs.

```java
Map<Integer, List<int[]>> adj = new HashMap<>();
// Add a flight from city 0 to city 1 with fare 100
adj.computeIfAbsent(0, x -> new ArrayList<>()).add(new int[]{1, 100});
// Get the adjacency list for city 0
List<int[]> neighbors = adj.get(0);  // → [[1, 100]]
```

### PriorityQueue

A priority queue is a data structure that automatically sorts elements upon insertion and always extracts the minimum (or maximum) element from the front. In Dijkstra's algorithm, it is used to efficiently extract the state with the minimum cost.

```java
// Priority queue sorted in ascending order by the 0th element (cost) of int[]
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{100, 1, 0});   // Add [cost=100, city=1, stops=0]
pq.offer(new int[]{50, 2, 1});    // Add [cost=50, city=2, stops=1]
int[] min = pq.poll();            // Extract the minimum-cost element [50, 2, 1]
pq.isEmpty();                      // Check if the queue is empty → false
```

### Pruning With the stops Array

In standard Dijkstra, a `visited` array manages which cities have been visited, but this problem requires distinguishing paths that reach the same city with different stop counts. The `stops[]` array records the minimum stop count to each city and terminates any path that arrives with an equal or greater stop count, eliminating unnecessary exploration.

```java
int[] stops = new int[n];
Arrays.fill(stops, k + 2);  // k+2 is a sufficiently large initial value meaning "not yet reached"
// City 2 reached with 1 stop
stops[2] = 1;
// Later, city 2 reached with 2 stops → 2 >= stops[2], so prune (skip)
```

## Complexity

| | Value |
|---|---|
| Time | O(E · log n) — Each flight (edge) incurs O(log n) cost for priority queue insertion and extraction |
| Space | O(n + E) — O(E) for the adjacency list, O(n) for the stops array, and at most O(E) states in the queue |

## Code

```java
// Input: number of cities n, flights array (each element is [from, to, price]), source src, destination dst, maximum stops k
// Output: return the cheapest fare from src to dst with at most k stops as an int. Return -1 if unreachable
public int findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
    // Build the adjacency list. Key = departure city, Value = list of [destination city, fare]
    // For each flight f, add [f[1], f[2]] to the key f[0] in adj
    Map<Integer, List<int[]>> adj = new HashMap<>();
    for (int[] f : flights)
        adj.computeIfAbsent(f[0], x -> new ArrayList<>())
            .add(new int[]{f[1], f[2]});

    // Priority queue sorted by ascending cost. Each state is [cost, city, stops]
    // By extracting the lowest-cost state first, the first arrival at the destination is the cheapest
    PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
    // Initial state: at the source with cost 0 and 0 stops
    pq.offer(new int[]{0, src, 0});

    // Array recording the minimum stops to reach each city
    // k+2 is an initial value sufficiently larger than the stop limit k, meaning "not yet reached"
    int[] stops = new int[n];
    Arrays.fill(stops, k + 2);

    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int cost = curr[0];
        int city = curr[1];
        int stop = curr[2];

        // If the destination is reached, this is the cheapest since extraction is in ascending cost order
        if (city == dst) return cost;

        // Prune if this city was previously reached with fewer (or equal) stops
        // Since extraction is in ascending cost order, the earlier arrival also had lower cost → no benefit in exploring
        if (stop >= stops[city]) continue;
        // Update the minimum stops to reach this city
        stops[city] = stop;

        // If the stop count exceeds the limit k, do not expand further from this city
        if (stop > k) continue;

        // Skip if no flights depart from this city
        if (!adj.containsKey(city)) continue;

        // For each neighboring city, add [accumulated cost, neighbor, stops + 1] to the queue
        for (int[] next : adj.get(city)) {
            pq.offer(new int[]{cost + next[1], next[0], stop + 1});
        }
    }

    // Return -1 if the destination was never reached after exhausting all paths
    return -1;
}
```
