# Finding Cells That Drain to Both Oceans — 두 바다 모두로 물이 흐르는 셀을 모두 찾기

## 문제의 본질

m×n 높이 행렬이 주어진다. 태평양은 상변과 좌변에, 대서양은 하변과 우변에 접해 있다. 물은 현재 셀에서 인접 셀로, 인접 셀의 높이가 현재 셀 이하일 때 흐른다. 물이 태평양과 대서양 **모두**에 도달할 수 있는 셀을 모두 구한다.

## 핵심 아이디어

각 셀에서 바다로의 도달 판정을 순방향으로 수행하면 계산이 중복된다. 반대로, 바다의 경계 셀에서 내부로 「물이 거슬러 올라갈 수 있는 방향(높이가 같거나 높은 인접 셀)」으로 BFS를 수행하면, 각 바다에 도달 가능한 셀의 집합을 O(m*n)으로 구할 수 있고, 두 집합의 교집합이 답이 된다.

## 사고 과정

1. **순방향 탐색은 비효율적이다**: 각 셀(i,j)에서 바다로의 경로를 탐색하면 O(m*n)개의 셀 각각에 BFS/DFS가 필요하여, 전체적으로 O((m*n)²)이 된다. 셀별 독립 탐색은 중복이 많으므로 역방향 탐색을 고려한다
2. **역방향으로 발상을 전환한다**: 「셀에서 바다로 물이 흐른다」는 「바다에서 셀로 높이가 비감소인 경로가 존재한다」와 동치이다. 바다의 경계에서 역류 방향으로 BFS를 수행하면, 도달 가능한 셀의 집합을 한 번에 구할 수 있다
3. **두 바다를 독립적으로 처리한다**: 태평양의 경계 셀(상변+좌변)을 모두 큐에 넣고 BFS를 수행하여 도달 가능한 셀을 기록한다. 대서양의 경계 셀(하변+우변)에 대해서도 마찬가지로 BFS를 수행한다. 두 탐색은 서로 독립적이므로 동일한 로직을 재사용할 수 있다
4. **BFS의 전이 조건을 정한다**: 역류이므로, 인접 셀의 높이가 현재 셀 **이상**일 때 전이한다. 이것은 「물이 높은 곳에서 낮은 곳으로 흐른다」의 역이다
5. **교집합을 구한다**: 양쪽 BFS에서 도달 완료로 표시된 셀이 두 바다 모두로 물이 흐르는 셀이다. 모든 셀을 순회하여 양쪽 모두 true인 것을 결과 리스트에 추가한다

## 전제 지식

### Multi-source BFS(다중 시작점 BFS)란

일반적인 BFS는 하나의 시작점에서 출발하지만, 여러 시작점을 처음에 모두 큐에 넣고 BFS를 시작하는 기법이다. 각 시작점에서 동시에 탐색이 퍼지는 것과 같은 효과를 얻을 수 있으며, 모든 시작점으로부터의 도달 가능 셀을 1회의 BFS로 구할 수 있다.

```java
Queue<int[]> queue = new LinkedList<>();
// 여러 시작점을 모두 큐에 추가한다
queue.offer(new int[]{0, 0});
queue.offer(new int[]{0, 1});
queue.offer(new int[]{0, 2});
// 1회의 while 루프로 모든 시작점에서 동시에 탐색한다
while (!queue.isEmpty()) {
    int[] cell = queue.poll();
    // 인접 셀을 조건에 따라 탐색한다
}
```

### boolean[][]을 이용한 방문 여부 관리

2차원 boolean 배열을 사용하여 각 셀이 도달 완료인지 여부를 기록한다. 초기값은 false이며, 도달한 셀을 true로 설정한다. 같은 셀을 다시 처리하는 것을 방지한다.

```java
boolean[][] reach = new boolean[m][n];  // m×n의 false로 초기화된 배열
reach[r][c] = true;   // 셀(r,c)을 도달 완료로 설정한다
if (!reach[nr][nc])   // 셀(nr,nc)이 미도달인지 판정한다
```

### 4방향 이동 벡터

그리드 위에서 상하좌우로의 이동을 배열로 표현한다. 루프로 4방향을 순서대로 시도함으로써 각 방향에 대한 분기를 코드 중복 없이 작성할 수 있다.

```java
int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};  // 우, 좌, 하, 상
for (int[] d : dirs) {
    int nr = r + d[0];  // 새로운 행 인덱스
    int nc = c + d[1];  // 새로운 열 인덱스
}
```

## 계산량

| | 값 |
|---|---|
| Time | O(m×n) — 각 BFS가 모든 셀을 최대 1회씩 방문하며, BFS를 2회 실행한다 |
| Space | O(m×n) — 2개의 boolean 배열과 BFS 큐가 각각 최대 m×n개의 셀을 보유한다 |

## 코드

```java
// 입력: m×n 정수 행렬 heights (각 셀의 높이)
// 출력: 두 바다 모두로 물이 도달할 수 있는 셀의 좌표를 List<List<Integer>>로 반환한다

// 상하좌우 4방향으로의 이동 벡터
int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};

// 다중 시작점 BFS를 실행하고, 도달 가능한 셀을 boolean 배열로 반환한다
boolean[][] bfs(int[][] h, Queue<int[]> q) {
    int m = h.length, n = h[0].length;
    // 각 셀이 바다에서 역류로 도달 가능한지를 기록하는 배열
    boolean[][] reach = new boolean[m][n];

    // 큐 내의 모든 시작점을 도달 완료로 마킹한다 (경계 셀은 바다에 직접 접해 있기 때문)
    for (int[] c : q)
        reach[c[0]][c[1]] = true;

    while (!q.isEmpty()) {
        int[] cell = q.poll();
        int r = cell[0], c = cell[1];

        // 4방향의 인접 셀을 조사한다
        for (int[] d : dirs) {
            int nr = r + d[0];
            int nc = c + d[1];

            // 범위 내이고 미도달이며 높이가 현재 이상(역류 가능)이면 탐색을 확장한다
            // 높이가 현재 이상이라는 조건은 「물이 높은 곳에서 낮은 곳으로 흐른다」의 역을 표현한다
            if (nr >= 0 && nr < m
                && nc >= 0 && nc < n
                && !reach[nr][nc]
                && h[nr][nc] >= h[r][c]) {
                reach[nr][nc] = true;
                q.offer(new int[]{nr, nc});
            }
        }
    }
    return reach;
}

List<List<Integer>> pacificAtlantic(int[][] heights) {
    int m = heights.length;
    int n = heights[0].length;

    // 태평양용과 대서양용 큐를 생성한다 (Multi-source BFS의 시작점 집합)
    Queue<int[]> pQ = new LinkedList<>();
    Queue<int[]> aQ = new LinkedList<>();

    // 상변은 태평양에 직접 접해 있으므로 태평양의 시작점, 하변은 대서양에 직접 접해 있으므로 대서양의 시작점
    for (int j = 0; j < n; j++) {
        pQ.offer(new int[]{0, j});
        aQ.offer(new int[]{m - 1, j});
    }

    // 좌변은 태평양에 직접 접해 있으므로 태평양의 시작점, 우변은 대서양에 직접 접해 있으므로 대서양의 시작점
    for (int i = 0; i < m; i++) {
        pQ.offer(new int[]{i, 0});
        aQ.offer(new int[]{i, n - 1});
    }

    // 각 바다에서의 역류 BFS를 실행하여 도달 가능 셀의 집합을 얻는다
    boolean[][] pacReach = bfs(heights, pQ);
    boolean[][] atlReach = bfs(heights, aQ);

    // 두 바다 모두에 도달 가능한 셀을 결과 리스트에 추가한다
    // 양쪽 모두 true라는 것은, 해당 셀에서 태평양으로도 대서양으로도 물이 흐른다는 것을 의미한다
    List<List<Integer>> res = new ArrayList<>();
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (pacReach[i][j] && atlReach[i][j])
                res.add(Arrays.asList(i, j));

    return res;
}
```
