# Merging K Sorted Linked Lists — K개의 정렬된 연결 리스트를 하나로 통합하기

## 문제의 본질

K개의 정렬된 연결 리스트(Linked List) 배열이 주어진다. 이들 모두를 **하나의 정렬된 연결 리스트**로 통합하고, 그 첫 번째 노드를 반환한다. 각 리스트는 개별적으로 정렬되어 있으며, 통합 후의 리스트도 오름차순을 유지해야 한다.

## 핵심 아이디어

K개의 리스트를 한꺼번에 통합하는 것이 아니라, 2개씩 쌍을 지어 머지를 반복한다. 각 라운드에서 리스트 수가 절반으로 줄어들기 때문에 log k 라운드만에 하나로 수렴하며, 전체 요소 N에 대해 O(N log k)의 효율을 달성할 수 있다.

## 사고 과정

1. **기본 연산은 "2개의 정렬된 리스트 머지"이다**: K개의 리스트를 통합하는 문제는 "2개의 정렬된 리스트를 하나로 머지하는" 기본 연산의 조합으로 분해할 수 있다. 2개의 리스트 머지는 각각의 선두를 비교하여 작은 쪽을 선택하는 것을 반복하면 O(n)으로 실행할 수 있다
2. **K개의 리스트에 이 기본 연산을 어떻게 적용할 것인가**: 단순히 1번째와 2번째를 머지하고, 그 결과와 3번째를 머지하고… 순서대로 진행하면 O(Nk)가 된다. 매번 머지 결과가 길어지기 때문에 후반 머지일수록 비용이 높아지기 때문이다
3. **쌍별로 머지하면 비용이 균등해진다**: 리스트를 2개씩 쌍으로 묶어 머지하면, 각 라운드에서 전체 요소를 1번씩만 처리하면 된다. 리스트 수는 각 라운드에서 절반으로 줄어들기 때문에 라운드 수는 log k가 되며, 전체적으로 O(N log k)를 달성할 수 있다
4. **배열의 인덱스로 쌍을 관리한다**: `interval` 변수를 1, 2, 4, 8…로 배증시키며, `lists[i]`와 `lists[i + interval]`을 머지하여 `lists[i]`에 저장한다. 이렇게 하면 추가 배열 없이 in-place로 쌍별 머지를 구현할 수 있다
5. **모든 라운드 종료 후, lists[0]이 최종 결과가 된다**: 각 라운드에서 머지 결과는 `lists[0]`, `lists[2]`, `lists[4]`… 와 같이 짝수 인덱스에 집약되어 가며, 최종적으로 `lists[0]`에 모든 요소가 통합된다

## 전제 지식

### ListNode(연결 리스트의 노드)란

연결 리스트의 각 요소를 나타내는 클래스이다. `val`에 값을, `next`에 다음 노드에 대한 참조를 보유한다. `next`가 `null`인 노드가 리스트의 끝이다.

```java
class ListNode {
    int val;              // 이 노드가 보유하는 값
    ListNode next;        // 다음 노드에 대한 참조 (끝이면 null)
    ListNode(int val) {   // 생성자: 값을 지정하여 노드를 생성
        this.val = val;
    }
}
```

### 더미 노드(Sentinel Node)란

리스트 구축을 간결하게 하기 위한 기법이다. 값 0의 더미 노드를 선두에 배치하고, 그 뒤에 실제 노드를 연결해 간다. 마지막에 `dummy.next`를 반환함으로써 선두 노드를 특별하게 처리할 필요가 없어진다.

```java
ListNode dummy = new ListNode(0);  // 더미 노드를 생성
ListNode tail = dummy;             // tail은 끝을 추적하는 포인터
tail.next = someNode;              // 더미 뒤에 노드를 연결
tail = tail.next;                  // tail을 끝으로 이동
return dummy.next;                 // 더미의 다음, 즉 실제 선두를 반환
```

### 분할 정복법(Divide and Conquer)이란

문제를 작은 하위 문제로 분할하고, 하위 문제를 풀고 나서 결과를 통합하는 기법이다. 머지 소트가 대표적인 예로, 배열을 절반씩 분할하고 정렬된 부분 배열을 머지한다. 본 문제에서는 K개의 리스트를 2개씩 쌍으로 묶어 반복적으로 머지한다.

```java
// interval이 1, 2, 4, 8...로 배증하며, 쌍 간의 간격을 넓혀 간다
for (int interval = 1; interval < n; interval *= 2) {
    // 각 라운드에서 쌍을 순서대로 머지한다
    for (int i = 0; i < n - interval; i += 2 * interval) {
        lists[i] = merge(lists[i], lists[i + interval]);
    }
}
```

## 계산 복잡도

| | 값 |
|---|---|
| Time | O(N log k) — 전체 요소 N개를 각 라운드에서 1번씩 처리하며, 라운드 수는 log k회 |
| Space | O(log k) — 재귀를 사용하지 않지만, 머지 라운드 수에 대응하는 루프의 스택 분량 |

## 코드

```java
// 입력: 정렬된 연결 리스트의 배열 ListNode[] lists (요소 수 K)
// 출력: 모든 리스트를 통합한 하나의 정렬된 연결 리스트의 첫 번째 노드 ListNode를 반환

// 2개의 정렬된 리스트를 하나로 머지하는 보조 메서드
private ListNode mergeTwoLists(ListNode a, ListNode b) {
    // 더미 노드를 생성하여 머지 결과 리스트의 선두 표식으로 사용한다 (실제 데이터는 dummy.next부터 시작)
    ListNode dummy = new ListNode(0);
    // tail은 머지 결과의 끝을 항상 추적하며, 새로운 노드를 연결할 위치를 가리킨다
    ListNode tail = dummy;

    // 양쪽 리스트에 노드가 남아 있는 동안, 작은 쪽을 선택하여 연결한다 (정렬 순서를 유지하기 위해)
    while (a != null && b != null) {
        if (a.val <= b.val) {
            tail.next = a;  // a의 현재 노드를 머지 결과에 연결
            a = a.next;     // a를 다음 노드로 이동
        } else {
            tail.next = b;  // b의 현재 노드를 머지 결과에 연결
            b = b.next;     // b를 다음 노드로 이동
        }
        tail = tail.next;   // tail을 끝으로 이동하여 다음 노드를 연결할 준비를 한다
    }

    // while 루프 종료 후, a 또는 b 중 하나에 남은 노드가 있다. 양쪽 모두 정렬되어 있으므로 그대로 연결해도 문제없다
    tail.next = (a != null) ? a : b;

    // dummy 자체는 더미이므로, 그 다음 노드가 머지 결과의 실제 선두이다
    return dummy.next;
}

public ListNode mergeKLists(ListNode[] lists) {
    // 입력이 null이거나 비어 있는 경우, 통합할 리스트가 존재하지 않으므로 null을 반환한다
    if (lists == null || lists.length == 0) return null;

    // n에 리스트의 수 K를 저장한다
    int n = lists.length;

    // interval을 1, 2, 4, 8...로 배증시킨다. interval은 머지할 쌍 간의 거리를 나타내며, 각 라운드에서 리스트 수가 절반으로 줄어든다
    for (int interval = 1; interval < n; interval *= 2) {
        // i < n - interval 조건을 통해, 쌍의 오른쪽 lists[i + interval]이 배열 범위 내에 존재함을 보장한다
        for (int i = 0; i < n - interval; i += 2 * interval) {
            // 쌍의 머지 결과를 lists[i]에 저장한다. 오른쪽 리스트는 이후 사용하지 않으므로 왼쪽에 덮어써도 문제없다
            lists[i] = mergeTwoLists(lists[i], lists[i + interval]);
        }
    }

    // 모든 라운드 종료 후, 전체 리스트의 머지 결과가 lists[0]에 집약되어 있다
    return lists[0];
}
```
