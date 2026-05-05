# Counting the Number of Islands in a Grid — 그리드 내 섬의 개수를 세기

## 문제의 본질

`'1'`(육지)과 `'0'`(물)으로 구성된 2D 그리드가 주어진다. 수평 방향 또는 수직 방향으로 인접한 육지 셀의 모음을 하나의 "섬"으로 간주하고, 그리드 내 섬의 **총 개수**를 반환한다.

## 핵심 아이디어

각 육지 셀을 노드로 간주하고, 인접한 육지 셀끼리 Union-Find로 결합해 나가면, 최종적으로 남은 독립된 그룹(루트)의 수가 곧 섬의 개수가 된다.

## 사고 프로세스

1. **섬은 "연결 요소"이다**: 인접한 육지 셀의 모음이 하나의 섬이므로, 이 문제는 그리드 위의 연결 요소의 개수를 구하는 문제로 귀결된다
2. **연결 요소의 관리에는 Union-Find가 적합하다**: Union-Find는 "두 요소를 같은 그룹으로 통합하기"와 "두 요소가 같은 그룹인지 판별하기" 연산을 거의 O(1)로 수행할 수 있다. 그리드의 각 육지 셀을 요소로 취급하면, 인접 셀끼리 순서대로 통합하는 것만으로 연결 요소를 구할 수 있다
3. **2D 그리드의 셀을 1D 인덱스로 변환한다**: Union-Find의 배열은 1차원이므로, 셀 `(i, j)`를 `i * n + j`(n은 열 수)로 하나의 정수로 변환한다. 이렇게 하면 2D 그리드 위의 셀을 Union-Find의 요소로 취급할 수 있다
4. **초기화에서 육지 셀의 수를 센다**: 각 육지 셀의 `parent`를 자기 자신으로 설정하고, `count`(섬의 수)를 육지 셀의 총 수로 초기화한다. 이 시점에서는 각 육지 셀이 독립된 섬이다
5. **인접 셀과의 결합으로 섬의 수를 줄인다**: 그리드를 순회하며, 각 육지 셀에 대해 오른쪽 방향과 아래쪽 방향의 인접 셀이 육지이면 `union`을 실행한다. `union`이 두 개의 서로 다른 그룹을 통합할 때마다 `count`를 1 줄인다. 오른쪽과 아래쪽만 확인하면, 왼쪽과 위쪽은 이전 셀의 순회 시에 이미 처리되었으므로 모든 인접 관계를 빠짐없이 다룰 수 있다
6. **최종적으로 남은 count가 답이다**: 모든 결합이 완료된 후의 `count`가 독립된 연결 요소의 수, 즉 섬의 개수이다

## 사전 지식

### Union-Find(서로소 집합 자료구조)란

여러 요소를 그룹으로 나누어 관리하는 자료구조이다. "두 요소를 같은 그룹으로 통합하기(union)"와 "어떤 요소가 어느 그룹에 속하는지 조회하기(find)"의 두 가지 연산을 제공한다. `parent` 배열로 각 요소의 부모를 관리하며, 트리 구조로 그룹을 표현한다.

```java
int[] parent = new int[n];   // parent[i] = 요소 i의 부모
int[] rank = new int[n];     // rank[i] = 요소 i를 루트로 하는 트리 높이의 상한

// 초기화: 각 요소의 부모를 자기 자신으로 설정한다 (각 요소가 독립된 그룹)
for (int i = 0; i < n; i++)
    parent[i] = i;
```

### 경로 압축(Path Compression)이란

`find` 연산 시에, 탐색 경로 위의 모든 노드의 부모를 직접 루트로 연결하는 최적화 기법이다. 재귀적으로 루트를 찾은 후, `parent[x] = find(parent[x])`로 부모를 루트로 갱신한다. 이를 통해 이후의 `find`가 O(1)에 가까워진다.

```java
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);  // 부모를 루트로 연결한다
    return parent[x];
}
```

### 랭크 기반 통합(Union by Rank)이란

`union` 연산 시에, 트리의 높이(rank)가 낮은 쪽을 높은 쪽 아래에 연결하는 기법이다. 트리 높이의 증가를 억제하여, `find`의 탐색 효율을 유지한다. 양쪽의 rank가 같은 경우에만, 통합 후 rank를 1 증가시킨다.

```java
void union(int x, int y) {
    int rx = find(x), ry = find(y);  // 각각의 루트를 찾는다
    if (rx == ry) return;            // 이미 같은 그룹이면 아무것도 하지 않는다
    if (rank[rx] < rank[ry])         // rank가 낮은 쪽을 높은 쪽 아래에 연결한다
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;                  // rank가 같은 경우에만 rank를 증가시킨다
    }
}
```

### 2D 인덱스에서 1D 인덱스로의 변환

2D 그리드의 셀 `(i, j)`를 1차원 배열의 인덱스로 변환하는 공식이다. 열 수를 `n`이라 하면, `id = i * n + j`로 고유한 정수로 변환할 수 있다.

```java
int m = 3, n = 4;          // 3행 4열의 그리드
int id = i * n + j;        // 셀(1, 2) → 1 * 4 + 2 = 6
```

## 계산량

| | 값 |
|---|---|
| Time | O(m × n × α(m × n)) — 모든 셀을 순회하며, 각 셀에서 최대 2회의 union/find 연산을 수행한다. α는 아커만 함수의 역함수로, 실질적으로 상수로 간주할 수 있다 |
| Space | O(m × n) — parent 배열과 rank 배열에 각각 m × n개의 요소를 저장한다 |

## 코드

```java
// 입력: '1'(육지)과 '0'(물)으로 구성된 char[][] grid
// 출력: 그리드 내 섬의 개수를 int로 반환한다

int[] parent;
int[] rank;
int count;

// 경로 압축이 적용된 find: 요소 x의 루트를 반환하고, 경로 위의 모든 노드의 부모를 루트로 연결한다
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);
    return parent[x];
}

// 랭크 기반 통합: 두 요소를 같은 그룹으로 통합하고, 성공하면 count를 1 줄인다
void union(int x, int y) {
    int rx = find(x), ry = find(y);
    if (rx == ry) return;       // 이미 같은 그룹이면 아무것도 하지 않는다
    if (rank[rx] < rank[ry])
        parent[rx] = ry;       // rank가 낮은 쪽을 높은 쪽 아래에 연결한다
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;             // rank가 같은 경우에만 rank를 증가시킨다
    }
    count--;                    // 두 그룹이 하나로 통합되었으므로 섬의 수를 1 줄인다
}

public int numIslandsUF(char[][] grid) {
    // 그리드의 행 수 m과 열 수 n을 가져온다
    int m = grid.length;
    int n = grid[0].length;
    // parent 배열과 rank 배열을 크기 m * n으로 생성한다
    parent = new int[m * n];
    rank = new int[m * n];
    // 섬의 수를 0으로 초기화한다 (이후 순회에서 육지 셀의 수를 센다)
    count = 0;

    // 초기화: 각 육지 셀의 부모를 자기 자신(i * n + j)으로 설정하고, count를 육지 셀의 총 수로 만든다
    // 이 시점에서는 각 육지 셀이 각각 독립된 섬이다
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            parent[i * n + j] = i * n + j;  // 2D 인덱스를 1D로 변환하여 부모를 자기 자신으로 설정한다
            count++;                          // 육지 셀 하나당 count를 1 증가시킨다
        }

    // 각 육지 셀에 대해, 오른쪽 이웃과 아래쪽 이웃이 육지이면 통합한다
    // 오른쪽과 아래쪽의 2방향만 확인하는 이유: 왼쪽과 위쪽은 이전 셀의 순회 시에 이미 처리되었기 때문이다
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            int id = i * n + j;              // 현재 셀의 1D 인덱스를 계산한다
            if (j + 1 < n && grid[i][j + 1] == '1')
                union(id, id + 1);           // 오른쪽 이웃 육지 셀과 통합한다 (id + 1은 오른쪽 이웃의 1D 인덱스)
            if (i + 1 < m && grid[i + 1][j] == '1')
                union(id, id + n);           // 아래쪽 이웃 육지 셀과 통합한다 (id + n은 아래쪽 이웃의 1D 인덱스)
        }

    // count는 초기값(육지 셀의 총 수)에서 union에 의한 통합이 성공할 때마다 1씩 감소하며, 최종값이 섬의 개수이다
    return count;
}
```
