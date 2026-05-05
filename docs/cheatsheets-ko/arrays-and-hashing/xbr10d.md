# Finding the K Most Frequent Elements — 배열에서 출현 빈도가 가장 높은 K개의 요소를 반환한다

## 문제의 본질

정수 배열 `nums`와 정수 `k`가 주어진다. `nums`에서 출현 횟수가 가장 많은 요소를 상위 `k`개 선택하여 배열로 반환한다. 반환 순서는 상관없다. 답은 유일하다는 것이 보장되어 있다.

## 핵심 아이디어

각 요소의 출현 빈도를 센 후, 빈도를 인덱스로 하는 버킷 배열을 만들면, 정렬(O(n log n))을 사용하지 않고 O(n)으로 빈도 순서대로 요소를 꺼낼 수 있다. 빈도의 최댓값은 배열의 길이 `n` 이하이므로, 버킷 배열의 크기는 유한하다.

## 사고 프로세스

1. **먼저 각 요소의 출현 횟수를 세야 한다**: 빈도 상위 K개를 구하려면, 각 요소가 몇 번 출현하는지 알아야 한다. HashMap을 사용하면, 키에 「숫자」, 값에 「출현 횟수」를 저장하여 O(n)으로 전체 요소의 빈도를 집계할 수 있다
2. **빈도 순으로 정렬하고 싶지만, 정렬은 O(n log n)이 걸린다**: 빈도 맵이 완성되면, 빈도가 높은 순서대로 K개를 꺼내고 싶다. 빈도로 정렬하면 O(n log n)이 되지만, 더 빠른 방법이 있다
3. **빈도를 인덱스로 하는 버킷 배열을 사용한다**: 배열의 길이가 `n`일 때, 어떤 요소의 출현 빈도도 최대 `n`이다. 따라서 크기 `n+1`의 배열을 준비하고, 인덱스 `i` 위치에 「출현 빈도가 `i`회인 요소의 리스트」를 저장한다. 이것이 버킷 정렬의 개념이다
4. **버킷 배열을 끝에서부터 순회하여 K개를 모은다**: 버킷 배열의 인덱스가 클수록 출현 빈도가 높다. 끝(인덱스 `n`)에서 앞쪽으로 순회하며, 버킷이 비어 있지 않으면 그 안의 요소를 결과 리스트에 추가한다. 결과 리스트의 크기가 `k`에 도달한 시점에서, 그 리스트를 배열로 변환하여 반환한다

## 사전 지식

### HashMap이란

키와 값의 쌍을 저장하는 데이터 구조이다. 키를 지정하여 값의 검색 및 취득을 O(1)로 수행할 수 있다. 이 문제에서는 각 숫자의 출현 횟수를 세는 카운터로 사용한다.

```java
HashMap<Integer, Integer> map = new HashMap<>();  // 빈 HashMap을 생성한다
map.merge(1, 1, Integer::sum);  // 키 1의 값에 1을 더한다 (키가 존재하지 않으면 1로 초기화한다)
map.entrySet();                 // 모든 키와 값의 쌍을 Set으로 반환한다
entry.getKey();                 // 쌍에서 키를 취득한다
entry.getValue();               // 쌍에서 값을 취득한다
```

### merge 메서드란

`map.merge(key, value, remappingFunction)`은, 키가 존재하지 않으면 `value`를 그대로 저장하고, 키가 이미 존재하면 `remappingFunction`으로 기존 값과 `value`를 결합한다. `Integer::sum`을 전달하면, 기존 값에 `value`를 더한다. `put` + `getOrDefault` 조합을 한 줄로 작성할 수 있는 편리한 메서드이다.

```java
map.merge(5, 1, Integer::sum);  // 키 5가 없으면 1을 저장하고, 있으면 기존 값+1을 저장한다
// 위 코드는 아래와 같은 의미이다
map.put(5, map.getOrDefault(5, 0) + 1);
```

### 버킷 정렬이란

요소의 값 자체를 인덱스로 하여 배열에 분배하는 정렬 기법이다. 비교 기반 정렬(O(n log n))과 달리, 값의 범위가 유한하면 O(n)으로 처리할 수 있다. 이 문제에서는 출현 빈도(최대 `n`)를 인덱스로 사용한다.

```java
List<Integer>[] buckets = new ArrayList[4];  // 인덱스 0~3의 버킷 배열을 생성한다
buckets[2] = new ArrayList<>();              // 인덱스 2의 버킷을 초기화한다
buckets[2].add(7);                           // 「빈도 2인 요소」로서 7을 저장한다
// buckets = [null, null, [7], null]
```

## 계산량

| | 값 |
|---|---|
| Time | O(n) — 빈도 맵 구축에 O(n), 버킷 배열 구축에 O(n), 결과 수집에 O(n)이므로 전체적으로 O(n)이다 |
| Space | O(n) — 빈도 맵에 최대 n개, 버킷 배열의 크기가 n+1이므로 전체적으로 O(n)이다 |

## 코드

```java
// 입력: 정수 배열 nums와 정수 k
// 출력: 출현 빈도가 가장 높은 상위 k개의 요소를 저장한 int[]를 반환한다
public int[] topKFrequent(int[] nums, int k) {
    // 단계1: 각 요소의 출현 빈도를 HashMap으로 집계한다
    Map<Integer, Integer> freqMap = buildFrequencyMap(nums);
    // 단계2: 빈도를 인덱스로 하는 버킷 배열을 구축한다
    List<Integer>[] buckets = buildBuckets(freqMap, nums.length);
    // 단계3: 버킷 배열을 끝에서부터 순회하여 상위 K개를 수집한다
    return collectTopK(buckets, k);
}

// 각 요소의 출현 횟수를 HashMap으로 집계하여 반환한다
// 키=숫자, 값=해당 숫자의 출현 횟수
public Map<Integer, Integer> buildFrequencyMap(int[] nums) {
    Map<Integer, Integer> freqMap = new HashMap<>();
    for (int num : nums) {
        // merge를 사용하여, 키가 없으면 1로 초기화하고, 있으면 기존 값에 1을 더한다
        freqMap.merge(num, 1, Integer::sum);
    }
    // 순회 완료 후, HashMap에는 전체 요소의 출현 빈도가 저장되어 있다
    return freqMap;
}

// 빈도를 인덱스로 하는 버킷 배열을 구축하여 반환한다
// buckets[i]에는 출현 빈도가 i회인 요소의 리스트가 들어간다
public List<Integer>[] buildBuckets(Map<Integer, Integer> freqMap, int n) {
    // 크기가 n+1인 이유는, 어떤 요소가 최대 n회 출현할 수 있으며, 인덱스 0~n을 사용하기 때문이다
    List<Integer>[] buckets = new ArrayList[n + 1];
    for (var entry : freqMap.entrySet()) {
        int num = entry.getKey();
        int freq = entry.getValue();
        // 버킷이 null인 경우 새로운 ArrayList를 생성한 후 추가한다
        if (buckets[freq] == null) {
            buckets[freq] = new ArrayList<>();
        }
        // 출현 빈도 freq를 인덱스로 하여, 해당 버킷에 숫자 num을 추가한다
        buckets[freq].add(num);
    }
    return buckets;
}

// 버킷 배열을 끝에서부터 순회하여, 빈도가 높은 순서대로 K개의 요소를 수집하여 반환한다
// 인덱스가 클수록 출현 빈도가 높으므로, 역순으로 순회하면 빈도가 높은 요소부터 순서대로 꺼낼 수 있다
public int[] collectTopK(List<Integer>[] buckets, int k) {
    List<Integer> result = new ArrayList<>();
    // 끝(인덱스 n)에서 앞쪽으로 순회한다. 인덱스 0은 「출현 빈도 0회」이므로 제외한다
    for (int i = buckets.length - 1; i > 0; i--) {
        if (buckets[i] != null) {
            for (int num : buckets[i]) {
                result.add(num);
                // K개를 모은 시점에서 배열로 변환하여 반환한다
                if (result.size() == k) {
                    return result.stream().mapToInt(Integer::intValue).toArray();
                }
            }
        }
    }
    // 문제의 제약상, 답은 반드시 존재하므로 여기에는 도달하지 않는다
    return new int[0];
}
```
