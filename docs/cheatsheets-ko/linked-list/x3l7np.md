# Designing a Least Recently Used Cache — 용량 초과 시 가장 오래 사용된 요소를 자동 삭제하는 캐시를 설계한다

## 문제의 본질

정수 키와 값을 저장하는 캐시를 설계한다. `get(key)` 와 `put(key, value)` 의 2가지 연산을 지원하며, 두 연산 모두 O(1)로 동작해야 한다. 캐시가 용량 `capacity` 를 초과한 경우, **가장 오랫동안 사용되지 않은(Least Recently Used) 요소**를 자동으로 삭제한 후 새로운 요소를 삽입한다.

## 핵심 아이디어

Java의 LinkedHashMap을 접근 순서 모드로 생성하고, `removeEldestEntry` 를 오버라이드하면, get/put을 호출할 때마다 접근 순서가 자동으로 갱신되고, 용량 초과 시에는 가장 오래된 요소가 자동으로 삭제된다. LRU 캐시의 모든 기능을 LinkedHashMap의 내부 메커니즘만으로 구현할 수 있다.

## 사고 과정

1. **O(1)의 get/put이 필요하다**: 키에서 값으로의 빠른 접근에는 HashMap이 필요하다. 그러나 일반적인 HashMap에는 요소의 사용 순서를 추적하는 기능이 없다
2. **사용 순서의 추적이 필요하다**: LRU에서는 「가장 오래 사용된 요소」를 특정해야 한다. 요소에 접근할 때마다 「최신」으로 이동하고, 선두에 남은 요소가 「가장 오래된 것」이 되는 순서가 있는 구조가 필요하다
3. **LinkedHashMap이 이 두 가지를 겸비한다**: Java의 LinkedHashMap은 HashMap의 기능에 더하여, 내부에 이중 연결 리스트를 가지고 있다. 생성자의 세 번째 인자에 `true` 를 전달하면 접근 순서 모드가 되며, get이나 put을 호출할 때마다 해당 요소가 리스트의 끝으로 자동 이동한다
4. **용량 초과 시 자동 삭제**: LinkedHashMap의 `removeEldestEntry` 메서드를 오버라이드하여, `size() > capacity` 일 때 `true` 를 반환하도록 한다. LinkedHashMap은 새로운 요소를 put한 직후에 이 메서드를 호출하며, `true` 가 반환된 경우 리스트의 선두(가장 오래된 요소)를 자동으로 삭제한다
5. **get에서 존재하지 않는 키인 경우**: 문제의 사양에서는 키가 존재하지 않는 경우 `-1` 을 반환해야 한다. `getOrDefault(key, -1)` 을 사용하면, 존재 여부 확인과 값 조회를 한 번의 호출로 수행할 수 있다
6. **최종 구조**: 생성자에서 LinkedHashMap을 접근 순서 모드로 생성하고, `removeEldestEntry` 를 오버라이드하는 것만으로, get/put 두 메서드 모두 LinkedHashMap에 대한 단순한 위임으로 완성된다

## 사전 지식

### LinkedHashMap 이란

HashMap의 모든 기능에 더하여, 요소의 순서를 내부의 이중 연결 리스트로 유지하는 자료 구조이다. 생성자의 세 번째 인자 `accessOrder` 에 `true` 를 전달하면, 요소에 접근(get 또는 put)할 때마다, 해당 요소가 리스트의 끝으로 이동한다. 리스트의 선두에는 가장 오랫동안 접근되지 않은 요소가 남게 된다.

```java
// 첫 번째 인자: 초기 용량, 두 번째 인자: 부하 계수, 세 번째 인자: true=접근 순서 모드
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(16, 0.75f, true);
map.put(1, 10);     // 키 1에 값 10을 저장한다. 리스트: [1]
map.put(2, 20);     // 키 2에 값 20을 저장한다. 리스트: [1, 2]
map.get(1);          // 키 1에 접근한다. 리스트: [2, 1] (1이 끝으로 이동)
map.put(3, 30);     // 키 3에 값 30을 저장한다. 리스트: [2, 1, 3]
// 이 시점에서 리스트 선두의 키 2가 「가장 오래 사용된 요소」이다
```

### removeEldestEntry 란

LinkedHashMap이 새로운 요소를 put한 직후에 자동으로 호출하는 메서드이다. 이 메서드가 `true` 를 반환하면, LinkedHashMap은 리스트의 선두에 있는 가장 오래된 요소를 자동으로 삭제한다. 기본적으로는 항상 `false` 를 반환하므로, 오버라이드하여 삭제 조건을 정의한다.

```java
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(cap, 0.75f, true) {
    @Override
    protected boolean removeEldestEntry(Map.Entry<Integer, Integer> eldest) {
        return size() > cap;  // 크기가 용량을 초과하면 true를 반환하여 가장 오래된 요소를 삭제시킨다
    }
};
```

### getOrDefault 란

Map 인터페이스의 메서드이다. 키가 존재하면 해당 값을 반환하고, 존재하지 않으면 두 번째 인자에 지정한 기본값을 반환한다. `containsKey` 와 `get` 의 2번 호출을 1번으로 통합할 수 있다.

```java
map.put(1, 10);
map.getOrDefault(1, -1);   // 키 1이 존재하므로 값 10을 반환한다
map.getOrDefault(99, -1);  // 키 99가 존재하지 않으므로 기본값 -1을 반환한다
```

## 계산량

| | 값 |
|---|---|
| Time | O(1) — get/put 모두 HashMap의 접근과 리스트 내 이동이 전부 O(1)로 동작한다 |
| Space | O(n) — 캐시 용량만큼의 요소를 LinkedHashMap 내에 저장한다 (n은 capacity) |

## 코드

```java
// 입력: 생성자에 정수 capacity(캐시의 최대 용량), get에 정수 key, put에 정수 key와 정수 value
// 출력: get은 키에 대응하는 값을 반환한다 (키가 존재하지 않는 경우 -1). put은 값을 반환하지 않는다
class LRUCache {
    LinkedHashMap<Integer, Integer> map;
    // 용량을 저장하는 인스턴스 변수. removeEldestEntry 내에서 삭제 판정에 사용한다
    int cap;

    // 용량을 전달받아, 접근 순서 모드의 LinkedHashMap을 초기화한다
    LRUCache(int capacity) {
        cap = capacity;
        // 첫 번째 인자: 초기 용량, 두 번째 인자: 기본 부하 계수, 세 번째 인자: true=접근 순서 모드
        // 접근 순서 모드에 의해, get이나 put을 호출할 때마다 해당 요소가 리스트 끝으로 자동 이동한다
        map = new LinkedHashMap<>(cap, 0.75f, true) {
            // put을 호출할 때마다 LinkedHashMap이 자동으로 호출하는 메서드
            // size() > cap 일 때 true를 반환하여, 리스트 선두의 가장 오래된 요소를 자동 삭제시킨다
            // 이를 통해 캐시의 크기는 항상 cap 이하로 유지된다
            protected boolean removeEldestEntry(Map.Entry<Integer, Integer> e) {
                return size() > cap;
            }
        };
    }

    // 키가 존재하는 경우: 접근 순서 모드에 의해 해당 요소가 리스트 끝으로 이동하고 (최신으로 기록되고), 값이 반환된다
    // 키가 존재하지 않는 경우: 기본값 -1이 반환된다
    int get(int key) {
        return map.getOrDefault(key, -1);
    }

    // 키와 값의 쌍을 삽입하거나 갱신한다
    // 삽입 후 removeEldestEntry가 자동으로 호출되며, size() > cap이면 가장 오래된 요소가 삭제된다
    // 키가 이미 존재하는 경우 값이 덮어씌워지고, 해당 요소가 리스트 끝으로 이동한다
    void put(int key, int value) {
        map.put(key, value);
    }
}
```
