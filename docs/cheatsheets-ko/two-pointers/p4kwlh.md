# Calculating Trapped Rainwater Between Bars — 막대 사이에 고이는 빗물의 양을 계산하기

## 문제의 본질

비음수 정수 배열 `height`가 주어진다. 각 요소는 너비 1인 막대의 높이를 나타내는 고저차 맵이다. 비가 내린 후 막대와 막대 사이에 고이는 **물의 총량**을 계산하여 반환한다.

## 핵심 아이디어

특정 위치에 고이는 물의 양은 "왼쪽 최대 높이와 오른쪽 최대 높이 중 작은 쪽"에서 "해당 위치의 막대 높이"를 뺀 값으로 결정된다. 왼쪽과 오른쪽에서 포인터를 안쪽으로 이동시키면서 각 쪽의 최대 높이를 갱신해 나가면, 추가 배열 없이 각 위치의 물의 양을 계산할 수 있다.

## 사고 과정

1. **각 위치의 물의 양은 좌우의 최대 높이로 결정된다**: 특정 위치 `i`에 고이는 물의 양은 `min(왼쪽 최대 높이, 오른쪽 최대 높이) - height[i]`이다. 물은 좌우 벽 중 낮은 쪽의 높이까지만 고일 수 있기 때문이다
2. **좌우의 최대 높이를 효율적으로 구하고 싶다**: 각 위치에서 좌우의 최대 높이를 매번 탐색하면 O(n²)이 소요된다. 배열을 2개 준비하여 사전 계산하면 O(n)이 되지만, Space O(n)이 필요하다. Space O(1)로 구현하는 방법을 생각한다
3. **좌우에서 포인터를 안쪽으로 이동시킨다**: 왼쪽 끝에 포인터 `left`, 오른쪽 끝에 포인터 `right`를 놓고 안쪽을 향해 이동시킨다. 각 포인터 쪽에서 지금까지 본 최대 높이를 변수 `maxLeftHeight`와 `maxRightHeight`로 추적한다
4. **작은 쪽의 포인터를 이동시킨다**: `height[left] <= height[right]`일 때, 왼쪽 최대 높이가 오른쪽 최대 높이 이하임이 보장된다. 왜냐하면 오른쪽에는 적어도 `height[right]` 이상의 벽이 존재하기 때문이다. 따라서 왼쪽 포인터 위치에서는 `maxLeftHeight`만으로 물의 양을 확정할 수 있다
5. **포인터를 이동시킨 후에 물의 양을 더한다**: 포인터를 하나 전진시킨 후, 그 새로운 위치에서 최대 높이를 갱신하고, `maxLeftHeight - height[left]`(또는 `maxRightHeight - height[right]`)를 물의 양에 더한다. 최대 높이는 항상 현재 막대의 높이 이상이므로, 이 차이는 반드시 0 이상이 된다
6. **두 포인터가 만나면 종료한다**: `left < right`인 동안 루프를 계속하고, 모든 위치의 물의 양을 합산한 `totalwater`를 반환한다

## 전제 지식

### Two Pointers(투 포인터)란

배열의 양쪽 끝 또는 서로 다른 위치에 2개의 포인터를 놓고, 조건에 따라 어느 한쪽을 이동시키면서 탐색하는 기법이다. 배열 전체를 한 번의 탐색으로 처리할 수 있으며, 정렬된 배열이나 양쪽 끝에서의 탐색에 유효하다.

```java
int left = 0;                    // 왼쪽 끝 포인터
int right = height.length - 1;   // 오른쪽 끝 포인터
while (left < right) {           // 두 포인터가 만날 때까지 루프
    // 조건에 따라 left++ 또는 right--로 포인터를 안쪽으로 이동시킨다
}
```

### Math.max란

두 값 중 큰 쪽을 반환하는 Java의 정적 메서드이다. 여기서는 포인터가 전진할 때마다 지금까지의 최대 높이를 갱신하기 위해 사용한다.

```java
int maxHeight = 3;
maxHeight = Math.max(maxHeight, 5);  // maxHeight는 5로 갱신된다
maxHeight = Math.max(maxHeight, 2);  // maxHeight는 5 그대로이다 (2 < 5이므로)
```

### 물이 고이는 조건

특정 위치에 물이 고이려면, 해당 위치의 좌우 양쪽에 현재 막대보다 높은 벽이 필요하다. 고이는 물의 양은 "좌우 벽 중 낮은 쪽의 높이"에서 "현재 막대의 높이"를 뺀 값이다.

```
// height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]
// 위치 2 (높이 0): 왼쪽 최대=1, 오른쪽 최대=3 → min(1,3) - 0 = 1의 물이 고인다
// 위치 5 (높이 0): 왼쪽 최대=2, 오른쪽 최대=3 → min(2,3) - 0 = 2의 물이 고인다
```

## 계산량

| | 값 |
|---|---|
| Time | O(n) — 좌우 포인터가 합계 n번 이동하여 배열을 한 번 탐색한다 |
| Space | O(1) — 포인터와 최대 높이 변수만 사용하며, 추가 배열은 불필요하다 |

## 코드

```java
// 입력: 비음수 정수 배열 height (각 요소는 막대의 높이)
// 출력: 막대 사이에 고이는 물의 총량을 int로 반환한다
public int trap(int[] height) {
    // 고이는 물의 총량을 보관하는 변수를 0으로 초기화한다
    int totalwater = 0;

    // 왼쪽 포인터를 배열의 맨 앞, 오른쪽 포인터를 배열의 맨 끝에 설정한다
    int left = 0;
    int right = height.length - 1;

    // 좌우 각각의 지금까지의 최대 높이를 초기화한다
    // 양쪽 끝의 막대 자체에는 물이 고이지 않으므로, 초기값으로 사용한다
    int maxLeftHeight = height[left];
    int maxRightHeight = height[right];

    // 두 포인터가 만날 때까지 루프한다
    while (left < right) {
        // height[left] <= height[right]일 때, 오른쪽에는 적어도 height[right]의 벽이 존재한다
        // 따라서 왼쪽의 최대 높이만으로 물의 양을 확정할 수 있다
        if (height[left] <= height[right]) {
            // 포인터를 하나 오른쪽으로 전진시킨 후 물의 양을 계산한다
            left++;
            // 지금까지의 왼쪽 최대 높이를 갱신한다
            maxLeftHeight = Math.max(maxLeftHeight, height[left]);
            // maxLeftHeight는 항상 height[left] 이상이므로, 더하는 값은 반드시 0 이상이 된다
            totalwater += maxLeftHeight - height[left];
        } else {
            // height[left] > height[right]일 때, 왼쪽에는 적어도 height[left]의 벽이 존재한다
            // 따라서 오른쪽의 최대 높이만으로 물의 양을 확정할 수 있다
            right--;
            // 지금까지의 오른쪽 최대 높이를 갱신한다
            maxRightHeight = Math.max(maxRightHeight, height[right]);
            // maxRightHeight는 항상 height[right] 이상이므로, 더하는 값은 반드시 0 이상이 된다
            totalwater += maxRightHeight - height[right];
        }
    }
    // 루프 종료 후, 모든 위치의 물의 양을 합산한 totalwater를 반환한다
    return totalwater;
}
```
