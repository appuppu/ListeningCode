# Dividing Cards Into Consecutive Groups — 카드를 지정 크기의 연속 그룹으로 분할할 수 있는지 판정하기

## 문제의 본질

정수 배열 `hand`(카드의 값)와 정수 `groupSize`가 주어진다. 모든 카드를 각 그룹이 `groupSize`장의 **연속된 값**으로 구성되는 그룹으로 분할할 수 있는지를 `boolean`으로 반환한다. 카드는 남거나 부족함 없이 모두 사용해야 한다.

## 핵심 아이디어

카드를 작은 값부터 탐욕적으로 처리하면, 각 카드가 속해야 할 그룹은 유일하게 결정된다. 최솟값 카드부터 연속 그룹을 만들고, 사용한 카드를 제거하는 과정을 반복하여 모든 카드를 사용할 수 있으면 분할이 가능하다.

## 사고 과정

1. **전제 조건을 확인한다**: 카드를 `groupSize`장씩 그룹으로 나누므로, 카드의 총 수가 `groupSize`로 나누어떨어지지 않으면 분할은 불가능하다. 이 판정을 먼저 수행함으로써 불필요한 처리를 생략할 수 있다
2. **최솟값 카드부터 처리해야 하는 이유**: 최솟값 카드는 자기 자신을 선두로 하는 연속 그룹에만 속할 수 있다. 예를 들어 최솟값이 3이고 `groupSize`가 3이면, 그 카드는 반드시 [3, 4, 5] 그룹에 들어간다. 따라서 최솟값부터 탐욕적으로 처리하는 전략이 올바르다
3. **각 카드의 출현 횟수를 관리해야 한다**: 같은 값의 카드가 여러 장 있을 수 있으므로, 각 값의 출현 횟수(빈도)를 기록하는 데이터 구조가 필요하다. 또한 최솟값을 효율적으로 가져오고 싶으므로, 키가 정렬된 TreeMap이 적합하다
4. **그룹 구축 절차**: TreeMap에서 최소 키 `first`를 가져오고, `first`부터 `first + groupSize - 1`까지의 연속된 값이 모두 TreeMap에 존재하는지 확인한다. 존재하면 각 값의 빈도를 1 감소시키고, 빈도가 0이 된 값은 TreeMap에서 삭제한다
5. **연속된 값이 부족한 경우**: 그룹 구축 중 필요한 값이 TreeMap에 존재하지 않으면, 그 시점에서 분할 불가능으로 판정하고 `false`를 반환한다
6. **모든 카드를 처리하면 성공**: TreeMap이 비워질 때까지 그룹 구축을 반복하고, 모두 성공하면 `true`를 반환한다

## 사전 지식

### TreeMap이란

키가 항상 정렬 순서로 관리되는 Map 데이터 구조이다. HashMap과 마찬가지로 키와 값의 쌍을 저장할 수 있지만, 키의 순서에 기반한 연산(최소 키 가져오기 등)을 O(log n)으로 수행할 수 있다. 내부는 레드-블랙 트리(자기 균형 이진 탐색 트리)로 구현되어 있다.

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();  // 빈 TreeMap을 생성한다
tm.put(5, 2);           // 키 5에 값 2를 저장한다
tm.put(3, 1);           // 키 3에 값 1을 저장한다
tm.firstKey();           // 최소 키를 반환한다 → 3
tm.containsKey(5);       // 키 5가 존재하는지를 boolean으로 반환한다 → true
tm.get(5);               // 키 5에 대응하는 값을 반환한다 → 2
tm.remove(3);            // 키 3과 그 값을 삭제한다
```

### getOrDefault란

Map에서 값을 가져올 때 키가 존재하지 않으면 지정한 기본값을 반환하는 메서드이다. 빈도 카운트에서 `null` 체크를 생략할 수 있다.

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();
tm.getOrDefault(10, 0);  // 키 10이 존재하지 않으므로 기본값 0을 반환한다 → 0
tm.put(10, 3);
tm.getOrDefault(10, 0);  // 키 10이 존재하므로 그 값을 반환한다 → 3
```

### 탐욕법(Greedy)이란

각 단계에서 국소적으로 최적인 선택을 하여 전체의 최적해를 구하는 기법이다. 이 문제에서는 "최솟값 카드부터 순서대로 그룹을 만든다"라는 탐욕적 선택이 전체적으로 올바른 분할을 이끈다. 최솟값 카드는 다른 그룹의 중간에 넣을 수 없으므로, 탐욕적 선택이 최적해와 일치한다.

## 계산량

| | 값 |
|---|---|
| Time | O(n log n) — TreeMap에 대한 삽입·삭제가 각각 O(log n)이며, 전체 카드 n장을 처리한다 |
| Space | O(n) — TreeMap에 최대 n개의 엔트리를 저장한다 |

## 코드

```java
// 입력: 정수 배열 hand(카드의 값)와 정수 groupSize(각 그룹의 크기)
// 출력: 모든 카드를 연속 값의 그룹으로 분할할 수 있으면 true, 할 수 없으면 false를 반환한다
public boolean isNStraightHand(int[] hand, int groupSize) {
    // 카드의 총 수가 그룹 크기로 나누어떨어지지 않으면 균등한 그룹 분할은 불가능하다
    if (hand.length % groupSize != 0)
        return false;

    // 키=카드의 값, 밸류=남은 장수(빈도)를 저장하는 TreeMap
    // TreeMap을 사용하는 이유: 최솟값 카드를 O(log n)으로 가져올 수 있기 때문이다
    TreeMap<Integer, Integer> tm = new TreeMap<>();
    // 각 카드의 출현 횟수를 카운트하고, getOrDefault로 기존 빈도에 1을 더한다
    for (int card : hand) {
        tm.put(card, tm.getOrDefault(card, 0) + 1);
    }

    // TreeMap이 비워질 때까지 그룹을 구축한다(비워지면 모든 카드를 분할할 수 있었음을 의미한다)
    while (!tm.isEmpty()) {
        // 현재 최솟값 카드를 가져와서 그룹의 선두로 삼는다
        // 최솟값은 다른 그룹의 중간에 넣을 수 없으므로 반드시 새로운 그룹의 선두가 된다
        int first = tm.firstKey();

        // first부터 groupSize개의 연속된 값으로 그룹을 만든다
        for (int i = 0; i < groupSize; i++) {
            int cur = first + i;

            // 연속된 값이 존재하지 않으면 그룹을 구성할 수 없으므로 분할 불가능하다
            if (!tm.containsKey(cur))
                return false;

            // 빈도가 1이면 그 카드는 마지막 1장이므로 삭제하고, 2 이상이면 빈도를 1 감소시킨다
            if (tm.get(cur) == 1) {
                tm.remove(cur);
            } else {
                tm.put(cur, tm.get(cur) - 1);
            }
        }
    }

    // 모든 카드를 연속 그룹으로 분할할 수 있었다
    return true;
}
```
