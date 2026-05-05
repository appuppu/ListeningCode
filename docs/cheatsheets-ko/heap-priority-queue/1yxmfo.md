# Finding the K Closest Points to the Origin — 원점에서 가장 가까운 K개의 점 찾기

## 문제의 본질

2차원 평면 위의 점 배열 `points`와 정수 `k`가 주어진다. 원점 (0, 0)으로부터 유클리드 거리가 가장 가까운 `k`개의 점을 반환한다. 거리는 유클리드 거리로 측정한다. 답은 임의의 순서로 반환해도 된다.

## 핵심 아이디어

"k개의 가장 가까운 점"을 구하는 데 완전한 정렬은 필요하지 않다. Quickselect 알고리즘을 사용하면 배열을 피벗으로 분할하여 k번째 경계를 찾는 것만으로 왼쪽에 k개의 최근접 점이 모인다.

## 사고 과정

1. **완전한 정렬은 과도하다**: k개의 최근접 점을 반환하면 되고, 순서는 상관없다. 즉, "가장 가까운 k개"와 "나머지"로 분할할 수 있으면 된다. 완전 정렬은 O(n log n)이 걸리지만, 분할만 하면 더 빠르게 할 수 있다
2. **Quickselect로 분할 위치를 찾는다**: Quicksort의 파티션 연산을 활용하면 피벗보다 작은 요소가 왼쪽에, 큰 요소가 오른쪽에 모인다. 피벗의 최종 위치가 정확히 k-1이 되면, 왼쪽의 k개가 답이다
3. **거리 계산을 간소화한다**: 유클리드 거리는 `√(x² + y²)`이지만, 대소 비교만 하면 제곱근은 불필요하고 `x² + y²`의 비교로 충분하다. 이를 통해 부동소수점 연산을 피할 수 있다
4. **파티션 연산의 동작 원리**: 오른쪽 끝 요소를 피벗으로 선택하고, `storeIdx`로 "피벗 이하의 요소를 배치할 다음 위치"를 관리한다. 탐색 중 피벗 이하의 요소가 발견되면 `storeIdx` 위치와 교환하고 `storeIdx`를 증가시킨다
5. **피벗의 최종 위치로 탐색 범위를 좁힌다**: 파티션 후 피벗은 `storeIdx` 위치에 들어간다. 이 위치가 `k-1`보다 작으면 왼쪽의 요소가 부족하므로 오른쪽 절반을 탐색하고, `k-1` 이상이면 왼쪽 절반을 탐색한다. 이 반복을 통해 평균 O(n)으로 분할이 완료된다
6. **최종적으로 앞쪽 k개를 반환한다**: 루프 종료 시점에서 배열의 앞쪽 k개가 최근접 점이 되어 있으므로, `Arrays.copyOfRange(points, 0, k)`로 잘라서 반환한다

## 사전 지식

### Quickselect란

배열에서 k번째로 작은 요소를 평균 O(n)으로 찾는 알고리즘이다. Quicksort의 파티션 연산을 한쪽에만 재귀적으로 적용함으로써, 완전한 정렬을 수행하지 않고 목표 위치를 확정한다.

```java
// 파티션의 기본 구조
int pivotValue = arr[right];       // 오른쪽 끝을 피벗으로 선택한다
int storeIdx = left;               // 피벗 이하의 요소를 배치할 위치
for (int i = left; i < right; i++) {
    if (arr[i] <= pivotValue) {    // 피벗 이하이면 왼쪽으로 모은다
        swap(arr, i, storeIdx);
        storeIdx++;
    }
}
swap(arr, storeIdx, right);        // 피벗을 올바른 위치에 배치한다
// storeIdx가 피벗의 최종 위치이다
```

### 유클리드 거리의 제곱

원점으로부터의 거리는 `√(x² + y²)`이지만, 대소 비교만 필요하면 제곱근을 생략하고 `x² + y²`로 비교할 수 있다. 제곱근 함수는 단조증가하므로, 거리의 대소 관계는 거리의 제곱에서도 유지된다.

```java
private int dist(int[] point) {
    return point[0] * point[0] + point[1] * point[1];  // x² + y²
}
```

### Arrays.copyOfRange란

배열의 지정 범위를 복사하여 새로운 배열로 반환하는 Java의 유틸리티 메서드이다.

```java
int[][] result = Arrays.copyOfRange(points, 0, k);  // 인덱스 0부터 k-1까지의 k개를 복사한다
```

## 계산량

| | 값 |
|---|---|
| Time | O(n) 평균 — 파티션을 한쪽에만 적용하므로, 평균적으로 n + n/2 + n/4 + ... = 2n 번의 비교로 수렴한다 |
| Space | O(1) — 입력 배열을 in-place로 재배치하므로, 추가 메모리를 사용하지 않는다 |

## 코드

```java
// 입력: 2차원 좌표 배열 points (각 요소는 [x, y])와 정수 k
// 출력: 원점에 가장 가까운 k개의 점을 저장한 int[][]를 반환한다

// 점의 원점으로부터의 유클리드 거리의 제곱을 반환한다 (제곱근은 대소 비교에 불필요하므로 생략한다)
private int dist(int[] p) {
    return p[0] * p[0] + p[1] * p[1];
}

public int[][] kClosest(int[][] points, int k) {
    // 탐색 범위의 왼쪽 끝과 오른쪽 끝을 초기화한다. 이 범위 내에서 파티션을 반복하여 앞쪽 k개가 최근접 점이 되도록 재배치한다
    int left = 0;
    int right = points.length - 1;

    // 앞쪽 k개가 최근접 점이 될 때까지 파티션을 반복한다
    while (left < right) {
        // 오른쪽 끝의 점을 피벗으로 선택하고, 그 유클리드 거리의 제곱을 계산한다 (x² + y²)
        int pivotDist = dist(points[right]);
        // storeIdx는 "피벗 이하의 거리를 가진 점을 배치할 다음 위치"를 관리한다
        int storeIdx = left;

        // 각 점의 거리를 피벗과 비교하여, 피벗 이하의 거리를 가진 점을 왼쪽으로 모은다
        for (int i = left; i < right; i++) {
            if (dist(points[i]) <= pivotDist) {
                // 피벗 이하이므로 storeIdx 위치로 교환하여 왼쪽으로 모은다
                int[] temp = points[i];
                points[i] = points[storeIdx];
                points[storeIdx] = temp;
                storeIdx++;
            }
        }

        // 피벗을 올바른 최종 위치 storeIdx에 배치한다. 왼쪽에는 피벗 이하, 오른쪽에는 피벗보다 큰 거리의 점이 배치된다
        int[] temp = points[storeIdx];
        points[storeIdx] = points[right];
        points[right] = temp;

        // 피벗의 최종 위치를 k-1과 비교하여 탐색 범위를 절반으로 좁힌다
        if (storeIdx < k - 1) {
            // 왼쪽의 요소가 k개에 미치지 못하므로, 오른쪽을 탐색한다
            left = storeIdx + 1;
        } else {
            // 주의: storeIdx가 정확히 k-1인 경우에도 right를 줄임으로써, 루프 조건 left < right가 거짓이 되어 루프가 종료된다
            right = storeIdx - 1;
        }
    }

    // 루프 종료 후, 배열의 앞쪽 k개가 원점에 가장 가까운 k개의 점이 되어 있다
    return Arrays.copyOfRange(points, 0, k);
}
```
