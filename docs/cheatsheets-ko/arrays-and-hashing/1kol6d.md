# Two Sum — 합계가 타겟이 되는 두 수의 쌍을 찾기

## 문제의 본질

정수 배열 `nums`와 정수 `target`이 주어진다. `nums`에서 합계가 `target`이 되는 두 요소를 찾아 해당 **인덱스**를 배열로 반환한다. 해답은 반드시 하나만 존재하며, 같은 요소를 두 번 사용할 수 없다.

## 핵심 아이디어

배열을 순회할 때, 각 요소 `nums[i]`에 대해 "쌍의 상대방(target - nums[i])"은 유일하게 결정된다. 과거에 본 요소를 HashMap에 기록해 두면, 상대방이 존재하는지를 O(1)으로 확인할 수 있어 한 번의 순회로 답을 찾을 수 있다.

## 사고 과정

1. **쌍의 상대방은 계산으로 구할 수 있다**: 합계가 `target`이 되는 쌍을 찾으므로, 현재 요소 `nums[i]`에 대해 나머지 한쪽의 값은 `complement = target - nums[i]`로 유일하게 결정된다
2. **상대방이 과거에 출현했는지를 빠르게 판정하고 싶다**: 배열을 순회하면서 지금까지 본 숫자를 기록해 두면, complement가 기록되어 있는지를 O(1)으로 판정할 수 있다. 이 기록에는 HashMap이 적합하다
3. **HashMap에 무엇을 저장할 것인가**: 문제에서 인덱스를 반환해야 하므로, HashMap의 키에 "숫자", 값에 "해당 숫자의 인덱스"를 저장한다. 이렇게 하면 상대방의 존재 확인과 인덱스 취득을 동시에 할 수 있다
4. **순회하면서 HashMap을 구축한다**: 배열을 처음부터 순서대로 순회하며, 각 요소에 대해 "complement가 HashMap에 있는지"를 판정한다. 있으면 쌍 발견, 없으면 현재 요소를 HashMap에 등록하고 다음으로 진행한다
5. **등록은 판정 후에 수행한다**: HashMap에 등록을 판정보다 먼저 수행하면, `nums[i]` 자기 자신이 complement로 매칭되어 버린다. 따라서 판정 → 등록 순서를 지켜야 한다
6. **최종적으로 반환하는 것**: complement가 HashMap에서 발견된 시점에, `map.get(complement)`(상대방의 인덱스)와 `i`(현재의 인덱스) 두 개를 `int[]`로 반환한다

## 전제 지식

### HashMap이란

키와 값의 쌍을 저장하는 데이터 구조이다. 키를 지정하여 값의 검색 및 취득을 O(1)으로 수행할 수 있다. 배열의 인덱스 접근과 같은 속도로 임의의 키로 접근할 수 있는 사전과 같은 것이다.

```java
HashMap<Integer, Integer> map = new HashMap<>();  // 빈 HashMap을 생성한다
map.put(10, 0);           // 키 10에 값 0을 저장한다
map.containsKey(10);      // 키 10이 존재하는지를 boolean으로 반환한다 → true
map.get(10);              // 키 10에 대응하는 값을 반환한다 → 0
```

### complement(보수)란

`target`에서 현재 요소를 뺀 값이다. 쌍의 상대방에 해당하는 수이다. `complement = target - nums[i]`로 계산한다.
예: target=9, nums[i]=2일 때, complement=7이다. 배열 안에 7이 있으면 쌍이 성립한다.

## 계산량

| | 값 |
|---|---|
| Time | O(n) — 배열을 한 번 순회하는 것만으로 충분하다 |
| Space | O(n) — HashMap에 최대 n개의 요소를 저장한다 |

## 코드

```java
// 입력: 정수 배열 nums와 정수 target
// 출력: 합계가 target이 되는 두 요소의 인덱스를 int[]로 반환한다
public int[] twoSum(int[] nums, int target) {
    // 키=숫자, 값=해당 숫자의 인덱스를 저장하는 HashMap
    // 문제에서 요구하는 것은 값이 아니라 인덱스이므로, 값에 인덱스를 저장한다
    HashMap<Integer, Integer> map = new HashMap<>();

    for (int i = 0; i < nums.length; i++) {
        // 쌍의 상대방을 계산하고, 변수에 넣어 containsKey와 get에서 재사용한다
        int complement = target - nums[i];

        // complement가 이미 HashMap에 등록되어 있으면 쌍을 발견한 것이다
        if (map.containsKey(complement)) {
            // map.get(complement)가 상대방의 인덱스, i가 현재의 인덱스이다
            return new int[]{map.get(complement), i};
        }

        // 주의: 등록은 판정 후에 수행한다. 먼저 등록하면 nums[i] 자기 자신이 매칭되어 버린다
        map.put(nums[i], i);
    }
    // 문제의 제약상, 해답은 반드시 존재하므로 여기에는 도달하지 않는다
    return new int[]{};
}
```
