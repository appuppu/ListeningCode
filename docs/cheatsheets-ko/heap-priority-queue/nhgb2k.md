# Simulating a Last Stone Weight Game — 돌을 2개씩 부딪혀서 마지막에 남는 돌의 무게를 구한다

## 문제의 본질

정수 배열 `stones`가 주어진다. 매번 **가장 무거운 2개의 돌**을 꺼내서 부딪힌다. 두 돌의 무게가 같으면 둘 다 소멸하고, 다르면 가벼운 쪽이 소멸하고 무거운 쪽은 차이만큼의 무게로 줄어든다. 이 연산을 돌이 1개 이하가 될 때까지 반복하고, 마지막에 남은 돌의 무게를 반환한다. 돌이 남지 않으면 0을 반환한다.

## 핵심 아이디어

매번 "가장 무거운 2개"를 효율적으로 꺼내야 한다. 최대 힙(Max-Heap)을 사용하면 최댓값 추출을 O(log n)에 수행할 수 있으므로, 매번 정렬할 필요 없이 항상 가장 무거운 2개의 돌을 가져올 수 있다.

## 사고 프로세스

1. **매번의 연산에서 필요한 것은 최댓값 2개이다**: 돌을 부딪히는 규칙에서는 항상 가장 무거운 2개의 돌을 선택한다. 즉, "현재 집합에서 최댓값을 2번 꺼내는" 연산을 반복하는 문제이다
2. **최댓값 추출을 고속으로 수행하고 싶다**: 배열을 매번 정렬하면 매 라운드마다 O(n log n)이 소요된다. 최대 힙을 사용하면 최댓값 추출이 O(log n)으로 끝나고, 요소 삽입도 O(log n)으로 끝난다
3. **Java의 PriorityQueue를 Max-Heap으로 사용한다**: Java의 PriorityQueue는 기본적으로 Min-Heap(최솟값이 선두)이다. `Collections.reverseOrder()`를 비교자로 전달하면 최댓값이 선두에 오는 Max-Heap으로 동작시킬 수 있다
4. **모든 돌을 힙에 투입한다**: 배열 `stones`의 모든 요소를 PriorityQueue에 추가한다. 이렇게 하면 힙이 최댓값을 관리할 준비가 완료된다
5. **돌이 2개 이상 있는 동안 부딪히는 연산을 반복한다**: 힙에서 `poll()`로 최댓값을 2번 꺼내고, 차이가 0이 아니면 차이를 힙에 `add()`로 되돌린다. 차이가 0이면 아무것도 되돌리지 않는다(둘 다 소멸)
6. **마지막 상태를 판정하여 반환한다**: 루프 종료 후, 힙이 비어 있으면 모든 돌이 소멸한 것이므로 0을 반환한다. 힙에 1개가 남아 있으면 그 돌의 무게를 `poll()`로 꺼내서 반환한다

## 전제 지식

### PriorityQueue(우선순위 큐)란

요소를 추가하면 내부에서 자동으로 순서가 관리되며, `poll()`로 항상 가장 우선순위가 높은 요소를 꺼낼 수 있는 자료구조이다. 내부 구현은 힙(이진 힙)이며, 추가와 추출 모두 O(log n)으로 동작한다.

```java
// 기본값은 Min-Heap(최솟값이 선두)이다
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.add(5);       // 요소 5를 추가한다
minHeap.add(2);       // 요소 2를 추가한다
minHeap.poll();       // 최솟값 2를 꺼내서 반환한다
minHeap.size();       // 현재 요소 수를 반환한다 → 1
minHeap.isEmpty();    // 큐가 비어 있는지를 boolean으로 반환한다 → false
```

### Collections.reverseOrder()란

PriorityQueue의 생성자에 전달하는 비교자로, 기본 오름차순(Min-Heap)을 내림차순(Max-Heap)으로 반전시킨다. 이를 통해 `poll()`이 최댓값을 반환하게 된다.

```java
// Max-Heap(최댓값이 선두)을 생성한다
PriorityQueue<Integer> maxHeap =
    new PriorityQueue<>(Collections.reverseOrder());
maxHeap.add(3);       // 요소 3을 추가한다
maxHeap.add(7);       // 요소 7을 추가한다
maxHeap.add(1);       // 요소 1을 추가한다
maxHeap.poll();       // 최댓값 7을 꺼내서 반환한다
maxHeap.poll();       // 다음 최댓값 3을 꺼내서 반환한다
```

### Max-Heap의 동작 이미지

stones = [2, 7, 4, 1, 8, 1]인 경우:
- 힙에 모든 요소를 추가하면, 내부에서 `[8, 7, 4, 1, 2, 1]`과 같이 관리된다
- `poll()` → 8을 꺼낸다. 힙은 `[7, 4, 2, 1, 1]`로 재구성된다
- `poll()` → 7을 꺼낸다. 8 - 7 = 1을 `add()`로 힙에 되돌린다

## 계산량

| | 값 |
|---|---|
| Time | O(n log n) — 최대 n번의 부딪히는 연산이 있으며, 각 연산에서 힙의 추출과 추가에 O(log n)이 소요된다 |
| Space | O(n) — 힙에 최대 n개의 돌을 저장한다 |

## 코드

```java
// 입력: 정수 배열 stones(각 요소는 돌의 무게)
// 출력: 마지막에 남은 돌의 무게를 int로 반환한다. 돌이 남지 않으면 0을 반환한다
public int lastStoneWeight(int[] stones) {
    // Collections.reverseOrder()로 Max-Heap(최댓값이 선두)을 생성한다
    // 기본 PriorityQueue는 Min-Heap이므로, 비교자로 내림차순으로 반전시킨다
    PriorityQueue<Integer> pq =
        new PriorityQueue<>(Collections.reverseOrder());

    // 모든 돌을 힙에 추가한다. 전체 요소 추가 후, 힙이 최댓값을 선두에서 관리한다
    for (int s : stones) pq.add(s);

    // 돌이 2개 이상 있는 동안, 가장 무거운 2개를 부딪히는 연산을 반복한다
    while (pq.size() >= 2) {
        // poll()을 2번 호출하여 가장 무거운 돌과 그다음으로 무거운 돌을 꺼낸다
        // Max-Heap이므로 a >= b가 항상 성립한다
        int a = pq.poll();  // 가장 무거운 돌을 꺼낸다
        int b = pq.poll();  // 그다음으로 무거운 돌을 꺼낸다

        // 무게가 다르면 차이만큼의 돌을 힙에 되돌린다. 같으면 둘 다 소멸하므로 아무것도 되돌리지 않는다
        if (a != b) pq.add(a - b);
    }

    // 힙이 비어 있으면 모든 돌이 소멸한 것이므로 0을, 남아 있으면 그 돌의 무게를 반환한다
    return pq.isEmpty() ? 0 : pq.poll();
}
```
