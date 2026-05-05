# Designing a Time-Based Key-Value Store — 타임스탬프 기반 키-밸류 스토어를 설계하기

## 문제의 본질

`set(key, value, timestamp)`으로 키와 값을 타임스탬프와 함께 저장하고, `get(key, timestamp)`으로 지정된 타임스탬프 **이하**의 최대 타임스탬프에 대응하는 값을 반환하는 데이터 구조를 설계한다. 해당하는 타임스탬프가 존재하지 않는 경우에는 빈 문자열을 반환한다.

## 핵심 아이디어

각 키에 대해 타임스탬프를 정렬된 상태로 유지하면, "지정된 값 이하의 최대 키"를 대수 시간으로 검색할 수 있다. Java의 TreeMap은 이 연산을 `floorEntry` 메서드로 내장 제공하고 있다.

## 사고 프로세스

1. **연산을 정리한다**: `set`은 키에 타임스탬프와 값의 쌍을 추가하는 연산이고, `get`은 "지정된 타임스탬프 이하에서 최대인 타임스탬프"에 대응하는 값을 반환하는 연산이다. `get`의 본질은 "특정 값 이하의 최대값을 찾는" 검색 문제이다
2. **키별로 타임스탬프를 관리한다**: 서로 다른 키는 상호 독립적이므로, 외부 HashMap으로 키별로 분리하고, 각 키에 대해 타임스탬프→값의 대응을 유지하는 구조로 만든다
3. **"이하의 최대값"을 효율적으로 구하는 데이터 구조를 선택한다**: 정렬된 데이터에서 "특정 값 이하의 최대값"을 구하려면 이진 탐색이 필요하다. TreeMap(레드-블랙 트리 기반의 균형 이진 탐색 트리)은 키를 정렬 순서로 유지하며, `floorEntry(key)`로 "지정된 키 이하의 최대 엔트리"를 O(log n)으로 반환한다
4. **set의 구현을 결정한다**: 외부 HashMap에 키가 미등록이면 새로운 TreeMap을 생성하고, TreeMap에 타임스탬프를 키, 값을 밸류로 `put`한다. `computeIfAbsent`를 사용하면 존재 확인과 생성을 한 줄로 작성할 수 있다
5. **get의 구현을 결정한다**: 먼저 HashMap에 키가 존재하는지 확인하고, 존재하지 않으면 빈 문자열을 반환한다. 존재하면 TreeMap의 `floorEntry(timestamp)`를 호출하고, 결과가 null이 아니면 그 값을, null이면 빈 문자열을 반환한다
6. **엣지 케이스를 처리한다**: 키 자체가 미등록인 경우와, 키는 존재하지만 타임스탬프가 모두 지정된 값보다 큰 경우의 두 가지에서 빈 문자열을 반환한다

## 사전 지식

### HashMap이란

키와 값의 쌍을 저장하는 데이터 구조이다. 키를 지정하여 값의 검색 및 취득을 O(1)으로 수행할 수 있다.

```java
HashMap<String, TreeMap<Integer, String>> map = new HashMap<>();  // 빈 HashMap을 생성한다
map.containsKey("foo");    // 키 "foo"가 존재하는지를 boolean으로 반환한다
map.get("foo");            // 키 "foo"에 대응하는 값을 반환한다
```

### computeIfAbsent란

HashMap의 메서드이다. 키가 미등록인 경우에만 람다식으로 값을 생성하여 등록하고, 그 값을 반환한다. 키가 이미 존재하는 경우에는 기존 값을 반환한다. 존재 확인→생성→등록을 한 줄로 작성할 수 있다.

```java
map.computeIfAbsent("foo", k -> new TreeMap<>());
// "foo"가 미등록 → 새로운 TreeMap을 생성하여 등록하고, 그 TreeMap을 반환한다
// "foo"가 등록 완료 → 기존의 TreeMap을 반환한다
```

### TreeMap이란

키를 정렬 순서(오름차순)로 유지하는 균형 이진 탐색 트리 기반의 Map이다. 일반 HashMap과 달리, 키의 대소 관계에 기반한 검색 연산을 제공한다. `put`과 `get`은 O(log n)으로 동작한다.

```java
TreeMap<Integer, String> tree = new TreeMap<>();  // 빈 TreeMap을 생성한다
tree.put(1, "one");        // 타임스탬프 1에 "one"을 저장한다
tree.put(3, "three");      // 타임스탬프 3에 "three"를 저장한다
tree.put(5, "five");       // 타임스탬프 5에 "five"를 저장한다
```

### floorEntry란

TreeMap의 메서드이다. 지정된 키 **이하**의 최대 키에 대응하는 엔트리(키와 값의 쌍)를 반환한다. 해당하는 엔트리가 존재하지 않는 경우에는 null을 반환한다. 내부에서 이진 탐색을 수행하므로 O(log n)으로 동작한다.

```java
tree.floorEntry(4);   // 키 4 이하의 최대 → 키 3의 엔트리 {3="three"}를 반환한다
tree.floorEntry(5);   // 키 5 이하의 최대 → 키 5의 엔트리 {5="five"}를 반환한다
tree.floorEntry(0);   // 키 0 이하의 엔트리는 존재하지 않는다 → null을 반환한다

Map.Entry<Integer, String> entry = tree.floorEntry(4);
entry.getValue();     // 엔트리에서 값을 취득한다 → "three"
```

## 계산량

| | 값 |
|---|---|
| Time | O(log n) — set과 get 모두 TreeMap의 연산이 O(log n)이다 (n은 해당 키에 저장된 타임스탬프의 수) |
| Space | O(n) — 모든 set 호출에서 저장된 엔트리를 보관한다 (n은 전체 엔트리 수) |

## 코드

```java
// 입력: set(key, value, timestamp) — 문자열 키, 문자열 값, 정수 타임스탬프 / get(key, timestamp) — 문자열 키, 정수 타임스탬프
// 출력: set은 반환값 없음 / get은 해당하는 값의 문자열을 반환한다 (해당 없으면 빈 문자열)
class TimeMap {
    // 키 → (타임스탬프 → 값)의 TreeMap을 보유하는 HashMap
    // 외부 HashMap으로 키별로 분리하고, 내부 TreeMap으로 타임스탬프를 정렬 순서로 유지한다
    Map<String, TreeMap<Integer, String>> map;

    public TimeMap() {
        // 외부 데이터 구조로서 HashMap을 생성한다
        map = new HashMap<>();
    }

    public void set(String key, String val, int ts) {
        // computeIfAbsent로 키가 미등록이면 새로운 TreeMap을 자동 생성 및 등록하고, 기존이면 기존의 TreeMap을 반환한다
        // TreeMap은 삽입 시 키를 정렬 순서로 배치하므로, 명시적인 정렬 연산은 불필요하다
        map.computeIfAbsent(key, k -> new TreeMap<>())
            .put(ts, val);
    }

    public String get(String key, int ts) {
        // 키 자체가 존재하지 않으면, set이 한 번도 호출되지 않았으므로 빈 문자열을 반환한다
        if (!map.containsKey(key))
            return "";

        // 해당 키의 TreeMap을 취득한다
        TreeMap<Integer, String> tree = map.get(key);

        // 지정된 타임스탬프 이하의 최대 엔트리를 검색한다 (TreeMap이 내부의 이진 탐색 트리를 O(log n)으로 탐색한다)
        Map.Entry<Integer, String> entry = tree.floorEntry(ts);

        // 엔트리가 발견되면 값을 반환한다. null인 경우는 모든 타임스탬프가 지정된 값보다 크다는 것을 의미하므로 빈 문자열을 반환한다
        return entry != null ? entry.getValue() : "";
    }
}
```
