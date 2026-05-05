# Finding Combinations That Sum to a Target Without Reuse — 중복 요소를 포함하는 배열에서 타겟에 합산되는 고유한 조합을 모두 찾기

## 문제의 본질

정수 배열 `candidates`(중복 요소를 포함할 수 있음)와 정수 `target`이 주어진다. 배열에서 합계가 `target`이 되는 숫자의 조합을 모두 찾는다. 각 숫자는 조합 내에서 **1번만** 사용할 수 있으며, 결과에 **중복되는 조합을 포함해서는 안 된다**.

## 핵심 아이디어

배열을 정렬하면 같은 값의 요소가 인접하게 되고, 재귀의 같은 계층에서 중복 요소를 건너뛰는 조건 `i > start && cands[i] == cands[i-1]`이 성립한다. 이를 통해 중복된 조합의 생성을 근본적으로 방지하면서, 모든 고유한 조합을 빠짐없이 탐색할 수 있다.

## 사고 과정

1. **모든 조합을 열거해야 한다**: 문제는 "조건을 만족하는 모든 조합"을 구하므로, 하나의 최적해가 아닌 해 공간 전체를 탐색해야 한다. 이러한 "전체 열거" 문제에는 백트래킹이 적합하다
2. **각 요소를 "사용/미사용"으로 분기한다**: 배열의 각 요소에 대해 "현재 조합에 포함할지 포함하지 않을지"를 재귀적으로 선택해 나간다. 요소를 1번만 사용하기 위해 재귀 호출에서 시작 인덱스를 `i + 1`로 진행시킨다
3. **중복되는 조합을 제거해야 한다**: 배열에 중복 요소가 있는 경우, 서로 다른 인덱스의 같은 값을 선택함으로써 동일한 조합이 생성될 수 있다. 예를 들어 `[1,1,2]`에서 target=3일 때, 첫 번째 1과 2의 조합, 두 번째 1과 2의 조합은 같은 `[1,2]`가 된다
4. **정렬하여 중복을 건너뛴다**: 배열을 정렬하면 같은 값이 인접하게 된다. 재귀의 같은 계층(같은 for 루프 내)에서 직전과 같은 값의 요소를 건너뛰면 중복되는 조합의 생성을 방지할 수 있다. 건너뛰기 조건은 `i > start && cands[i] == cands[i-1]`이다. `i > start` 조건에 의해 첫 번째 요소는 사용을 허용하면서, 두 번째 이후의 같은 값을 건너뛴다
5. **가지치기로 탐색을 효율화한다**: 배열이 정렬되어 있으므로, 현재 요소가 남은 합계 `remain`을 초과한 시점에서 그 이후의 요소도 모두 초과한다. `if (cands[i] > remain) break`으로 루프를 중단함으로써 불필요한 탐색을 생략할 수 있다
6. **기저 조건의 판정**: `remain`이 0이 되었을 때, 현재 `path`에 포함된 요소의 합계가 정확히 `target`과 같다는 것을 의미하므로, `path`의 복사본을 결과 리스트에 추가한다

## 사전 지식

### 백트래킹이란

해의 후보를 단계적으로 구축하고, 조건을 만족하지 않는다고 판명된 시점에서 직전 상태로 되돌아가(백트랙) 다른 후보를 시도하는 탐색 기법이다. "선택 → 재귀 → 선택 취소"의 패턴으로 구현한다.

```java
path.add(element);          // 선택: 요소를 조합에 추가한다
backtrack(next_state);      // 재귀: 다음 요소에 대해 탐색을 계속한다
path.remove(path.size()-1); // 취소: 요소를 조합에서 제거하여 원래 상태로 되돌린다
```

### Arrays.sort란

배열을 오름차순으로 정렬하는 Java의 표준 메서드이다. 정렬에 의해 같은 값의 요소가 인접하게 되므로, 중복의 감지와 건너뛰기가 용이해진다.

```java
int[] arr = {2, 1, 2, 3};
Arrays.sort(arr);           // arr가 {1, 2, 2, 3}으로 변경된다
```

### ArrayList의 복사 생성자

`new ArrayList<>(path)`는 `path`의 내용을 복사한 새로운 리스트를 생성한다. 백트래킹에서는 `path`가 재귀 중에 계속 변화하므로, 결과에 추가하는 시점에서 복사본을 만들어야 한다.

```java
List<Integer> path = new ArrayList<>(Arrays.asList(1, 2));
List<Integer> copy = new ArrayList<>(path);  // [1, 2]의 복사본을 생성한다
path.add(3);        // path는 [1, 2, 3]으로 변경된다
// copy는 [1, 2] 그대로 변경되지 않는다
```

## 계산량

| | 값 |
|---|---|
| Time | O(2^n) — 각 요소에 대해 "사용/미사용"의 2가지 선택이 있으므로, 최악의 경우 2^n가지의 조합을 탐색한다 |
| Space | O(n) — 재귀의 깊이가 최대 n이며, path도 최대 n개의 요소를 보유한다 |

## 코드

```java
// 입력: 정수 배열 candidates(중복 요소를 포함할 수 있음)와 정수 target
// 출력: 합계가 target이 되는 고유한 조합을 모두 저장한 List<List<Integer>>를 반환한다
private void backtrack(int[] cands, int start, int remain,
        List<Integer> path, List<List<Integer>> result) {
    // remain이 0이면 path의 합계가 정확히 target과 같은 조합을 발견한 것이다
    if (remain == 0) {
        // path는 이후의 재귀에서 계속 변화하므로, 복사본을 생성하여 결과에 추가한다
        result.add(new ArrayList<>(path));
        return;
    }

    // start부터 시작함으로써, 이미 사용한 요소(start 이전)를 다시 선택하는 것을 방지한다
    for (int i = start; i < cands.length; i++) {
        // 같은 재귀 계층에서 두 번째 이후의 요소이면서 직전과 같은 값이면 건너뛰어 중복 조합을 방지한다
        // i > start는 "같은 재귀 계층에서 첫 번째 요소가 아니다"를 의미한다
        if (i > start && cands[i] == cands[i - 1]) continue;

        // 정렬되어 있으므로 현재 값이 remain을 초과하면, 이후의 요소도 모두 초과한다(가지치기)
        if (cands[i] > remain) break;

        path.add(cands[i]);                  // 선택: 요소를 조합에 추가한다
        backtrack(cands, i + 1,              // 재귀: i+1로 함으로써 같은 요소를 2번 사용하는 것을 방지한다
            remain - cands[i], path, result); // remain에서 현재 요소를 차감하여 남은 합계를 갱신한다
        path.remove(path.size() - 1);        // 취소: 요소를 제거하고 다른 요소를 시도하기 위해 상태를 복원한다
    }
}

public List<List<Integer>> combinationSum2(
        int[] candidates, int target) {
    // 정렬에 의해 같은 값의 중복 요소를 인접시켜, 건너뛰기 조건의 판정을 가능하게 한다
    Arrays.sort(candidates);
    // 결과를 저장할 리스트와 현재의 조합을 기록하는 path를 빈 상태로 생성한다
    List<List<Integer>> result = new ArrayList<>();
    // 인덱스 0, 남은 합계 target에서 재귀 탐색을 시작한다
    backtrack(candidates, 0, target, new ArrayList<>(), result);
    // 모든 재귀가 완료된 후, 저장된 모든 고유한 조합을 반환한다
    return result;
}
```
