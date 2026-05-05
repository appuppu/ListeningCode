# Finding the Median From a Data Stream — 데이터 스트림에서 중앙값을 실시간으로 구하기

## 문제의 본질

데이터 스트림에서 정수가 연속적으로 추가되는 상황에서, 두 가지 연산을 지원하는 데이터 구조를 설계한다. `addNum(int num)`은 정수를 추가하고, `findMedian()`은 지금까지 추가된 모든 정수의 **중앙값**을 반환한다. 요소 수가 홀수이면 가운데 값을 반환하고, 짝수이면 가운데 두 값의 평균을 반환한다.

## 핵심 아이디어

모든 요소를 "작은 쪽 절반"과 "큰 쪽 절반"으로 분할하고, 각각을 max-heap과 min-heap으로 관리하면, 중앙값을 항상 두 힙의 선두에서 O(1)로 가져올 수 있다.

## 사고 프로세스

1. **중앙값은 "한가운데"에 있다**: 중앙값을 구하려면 모든 요소를 정렬된 상태로 유지하고, 가운데 요소에 접근해야 한다. 그러나 요소를 추가할 때마다 정렬하면 O(n log n)이 소요된다
2. **모든 요소의 정렬 순서는 불필요하고, 가운데만 알면 된다**: 모든 요소를 "작은 쪽 절반(lower half)"과 "큰 쪽 절반(upper half)"으로 이분할하면, lower half의 최댓값과 upper half의 최솟값이 중앙값의 후보가 된다
3. **각 절반의 극값을 빠르게 가져오고 싶다**: lower half의 최댓값을 O(1)로 가져오려면 max-heap이, upper half의 최솟값을 O(1)로 가져오려면 min-heap이 적합하다. 힙에 추가하는 연산은 O(log n)으로 처리할 수 있다
4. **두 힙의 크기 균형을 유지한다**: 중앙값을 올바르게 구하려면, 두 힙의 크기 차이를 최대 1로 유지해야 한다. lo(max-heap)의 크기가 hi(min-heap)의 크기 이상이 되도록 균형을 맞춘다
5. **요소 추가 시 균형 조정 절차**: 새로운 요소를 먼저 lo에 추가하고, lo의 최댓값을 hi로 이동한다. 이를 통해 lo의 최댓값 ≤ hi의 최솟값이라는 관계가 항상 보장된다. 그 후, hi의 크기가 lo보다 커지면 hi의 최솟값을 lo로 되돌린다
6. **중앙값 가져오기**: lo의 크기가 hi보다 크면 요소 수가 홀수이므로 lo의 선두(최댓값)가 중앙값이다. 크기가 같으면 요소 수가 짝수이므로 lo의 선두와 hi의 선두의 평균이 중앙값이다

## 전제 지식

### PriorityQueue(힙)란

요소를 우선순위 순서로 관리하는 데이터 구조이다. 기본적으로 min-heap(최솟값이 선두)으로 동작한다. 선두 요소의 가져오기는 O(1), 요소의 추가·삭제는 O(log n)으로 수행할 수 있다.

```java
// min-heap(기본값): 최솟값이 선두에 온다
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.offer(5);       // 요소 5를 추가한다
minHeap.offer(3);       // 요소 3을 추가한다
minHeap.peek();          // 선두의 최솟값을 가져온다 → 3(삭제하지 않는다)
minHeap.poll();          // 선두의 최솟값을 꺼낸다 → 3(삭제한다)

// max-heap: 최댓값이 선두에 온다(Collections.reverseOrder()를 지정)
PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
maxHeap.offer(5);       // 요소 5를 추가한다
maxHeap.offer(3);       // 요소 3을 추가한다
maxHeap.peek();          // 선두의 최댓값을 가져온다 → 5
```

### offer / poll / peek의 차이

| 메서드 | 동작 | 반환값 |
|---|---|---|
| `offer(e)` | 요소 `e`를 힙에 추가한다 | `boolean`(성공 시 true) |
| `poll()` | 선두 요소를 꺼내서 **삭제한다** | 꺼낸 요소(비어 있으면 `null`) |
| `peek()` | 선두 요소를 **삭제하지 않고** 참조한다 | 선두의 요소(비어 있으면 `null`) |

### 중앙값(median)이란

정렬된 리스트의 한가운데 값이다. 요소 수가 홀수이면 가운데 1개, 짝수이면 가운데 2개의 평균값이다.
예: `[1, 2, 3]` → 중앙값은 `2`. `[1, 2, 3, 4]` → 중앙값은 `(2 + 3) / 2.0 = 2.5`.

## 계산량

| | 값 |
|---|---|
| Time | O(log n) — `addNum`에서 힙에 대한 추가·꺼내기가 최대 3회 발생하며, 각 연산은 O(log n)이다. `findMedian`은 O(1)이다 |
| Space | O(n) — 2개의 힙이 모든 요소를 보유한다 |

## 코드

```java
// 입력: addNum(int num)으로 정수가 하나씩 스트림으로 전달된다
// 출력: findMedian()이 지금까지 추가된 모든 정수의 중앙값을 double로 반환한다
class MedianFinder {
    // 작은 쪽 절반을 관리하는 max-heap(선두가 최댓값)
    PriorityQueue<Integer> lo;
    // 큰 쪽 절반을 관리하는 min-heap(선두가 최솟값)
    PriorityQueue<Integer> hi;

    MedianFinder() {
        // max-heap은 Collections.reverseOrder()로 큰 순서로 만든다
        lo = new PriorityQueue<>(Collections.reverseOrder());
        // min-heap은 기본값 그대로(작은 순서)이다
        hi = new PriorityQueue<>();
    }

    void addNum(int num) {
        // 모든 요소를 먼저 작은 쪽 절반(lo)에 넣는다
        lo.offer(num);
        // lo의 최댓값을 hi로 이동하여, lo의 모든 요소 ≤ hi의 모든 요소라는 대소 관계를 항상 유지한다
        hi.offer(lo.poll());

        // hi의 크기가 lo보다 커지면, hi의 최솟값을 lo로 되돌려 균형을 맞춘다
        // 이 연산을 통해, lo의 크기는 항상 hi의 크기 이상이 된다(차이는 최대 1)
        if (hi.size() > lo.size())
            lo.offer(hi.poll());
    }

    double findMedian() {
        // lo의 크기가 더 크다 = 전체 요소 수가 홀수 → lo의 선두(작은 절반의 최댓값)가 중앙값이다
        if (lo.size() > hi.size())
            return lo.peek();

        // 크기가 같다 = 전체 요소 수가 짝수 → 가운데 2개의 평균을 반환한다
        // 2.0으로 나누어 정수 나눗셈이 아닌 부동소수점 나눗셈을 수행한다
        return (lo.peek() + hi.peek()) / 2.0;
    }
}
```
