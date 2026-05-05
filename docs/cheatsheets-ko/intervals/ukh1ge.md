# Inserting a New Interval Into a Sorted List — 정렬된 비중복 구간 리스트에 새로운 구간을 삽입하고 병합하기

## 문제의 본질

정렬되어 있고 서로 겹치지 않는 구간의 리스트 `intervals`와 새로운 구간 `newInterval`이 주어진다. `newInterval`을 올바른 위치에 삽입하고, 겹치는 구간이 있으면 모두 병합하여, 결과로 비중복 구간의 리스트를 반환한다.

## 핵심 아이디어

정렬된 구간 리스트를 왼쪽부터 순회하면, 각 구간은 "새로운 구간보다 완전히 앞에 있는 것", "새로운 구간과 겹치는 것", "새로운 구간보다 완전히 뒤에 있는 것"의 3개 그룹으로 나뉜다. 이 3단계를 순서대로 처리하면, 1회 순회만으로 삽입과 병합이 완료된다.

## 사고 과정

1. **구간의 위치 관계는 3가지 패턴뿐이다**: 정렬된 리스트의 각 구간은 newInterval과 비교하면 "완전히 앞에 있는 것", "겹치는 것", "완전히 뒤에 있는 것" 중 하나로 분류할 수 있다. 이 분류를 활용하면 리스트를 1회 순회하는 것만으로 처리할 수 있다
2. **"완전히 앞에 있는 것"의 판정 조건**: 기존 구간의 끝점 `intervals[i][1]`이 newInterval의 시작점 `newInterval[0]`보다 작으면, 그 구간은 newInterval과 겹치지 않는다. 이 조건을 만족하는 구간을 그대로 결과에 추가한다
3. **"겹치는 것"의 판정 조건**: 기존 구간의 시작점 `intervals[i][0]`이 newInterval의 끝점 `newInterval[1]` 이하이면, 그 구간은 newInterval과 겹친다. 겹치는 구간이 발견될 때마다 newInterval의 시작점과 끝점을 갱신하여 병합 범위를 확장한다
4. **병합 방법**: 겹치는 구간의 시작점과 newInterval의 시작점 중 작은 쪽을 새로운 시작점으로, 겹치는 구간의 끝점과 newInterval의 끝점 중 큰 쪽을 새로운 끝점으로 설정한다. 이를 통해 여러 개의 겹치는 구간을 하나의 구간으로 합칠 수 있다
5. **병합 결과의 추가 시점**: 겹치는 구간이 더 이상 없는 시점에서 병합이 완료된 newInterval을 결과에 추가한다. 그 이후의 구간은 모두 newInterval보다 뒤에 있으므로 그대로 결과에 추가한다
6. **최종적으로 반환하는 것**: 3단계로 구축한 결과 리스트를 `int[][]`로 변환하여 반환한다

## 사전 지식

### ArrayList란

가변 길이 배열이다. `add()`로 O(1)(분할 상환)에 요소를 추가할 수 있으며, 최종적으로 고정 길이 배열로 변환할 수 있다. 결과의 크기를 사전에 알 수 없는 경우에 사용한다.

```java
List<int[]> res = new ArrayList<>();   // 빈 ArrayList를 생성한다
res.add(new int[]{1, 3});              // 요소를 끝에 추가한다
res.toArray(new int[0][]);             // int[][] 타입의 배열로 변환한다
```

### Math.min / Math.max란

두 값 중 작은 쪽 또는 큰 쪽을 반환하는 메서드이다. 구간 병합에서 시작점과 끝점을 결정할 때 사용한다.

```java
Math.min(1, 3);   // → 1 (작은 쪽을 반환한다)
Math.max(1, 3);   // → 3 (큰 쪽을 반환한다)
```

### 구간의 중복 판정

두 구간 `[a, b]`와 `[c, d]`가 겹치는지는 `a <= d && c <= b`로 판정할 수 있다. 이 문제에서는 정렬되어 있으므로, 한쪽 조건만으로도 충분히 판정할 수 있다.

```java
// 기존 구간이 newInterval보다 완전히 앞에 있다 (겹치지 않는다)
intervals[i][1] < newInterval[0]   // 기존 구간의 끝점 < 새 구간의 시작점

// 기존 구간이 newInterval과 겹친다
intervals[i][0] <= newInterval[1]  // 기존 구간의 시작점 <= 새 구간의 끝점
```

## 계산량

| | 값 |
|---|---|
| Time | O(n) — 구간 리스트를 1회 순회하는 것만으로 충분하다 |
| Space | O(n) — 결과 리스트에 최대 n+1개의 구간을 저장한다 |

## 코드

```java
// 입력: 정렬된 비중복 구간 리스트 intervals (int[][])와 새로운 구간 newInterval (int[])
// 출력: newInterval을 삽입하고 병합한 결과의 비중복 구간 리스트를 int[][]로 반환한다
public int[][] insert(int[][] intervals, int[] newInterval) {
    // 결과를 저장할 리스트. 크기를 사전에 알 수 없으므로 ArrayList를 사용한다
    List<int[]> res = new ArrayList<>();
    // 순회 위치를 추적하는 변수
    int i = 0;
    // 구간의 총 개수를 변수에 저장하여 루프 조건에서 매번 .length를 참조하지 않도록 한다
    int n = intervals.length;

    // 1단계: newInterval보다 완전히 앞에 있는 구간을 그대로 추가한다
    // 판정 조건: 기존 구간의 끝점 < newInterval의 시작점이면 겹치지 않는다
    while (i < n && intervals[i][1] < newInterval[0]) {
        res.add(intervals[i]);
        i++;
    }

    // 2단계: newInterval과 겹치는 구간을 모두 병합한다
    // 판정 조건: 기존 구간의 시작점 <= newInterval의 끝점이면 겹친다
    while (i < n && intervals[i][0] <= newInterval[1]) {
        // 시작점은 작은 쪽을 취한다 (newInterval의 왼쪽 끝을 겹치는 구간의 왼쪽 끝까지 확장한다)
        newInterval[0] = Math.min(newInterval[0], intervals[i][0]);
        // 끝점은 큰 쪽을 취한다 (newInterval의 오른쪽 끝을 겹치는 구간의 오른쪽 끝까지 확장한다)
        newInterval[1] = Math.max(newInterval[1], intervals[i][1]);
        i++;
    }
    // 병합이 완료된 newInterval을 결과에 추가한다 (겹치는 구간이 0개여도 그대로 추가된다)
    res.add(newInterval);

    // 3단계: newInterval보다 완전히 뒤에 있는 구간을 그대로 추가한다 (병합 불필요)
    while (i < n) {
        res.add(intervals[i]);
        i++;
    }

    // ArrayList를 int[][]로 변환하여 반환한다. new int[0][]는 타입 정보를 전달하기 위한 빈 배열이다
    return res.toArray(new int[0][]);
}
```
