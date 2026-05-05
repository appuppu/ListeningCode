# Merging Triplets to Form a Target Triplet — 트리플렛의 요소별 최댓값으로 타겟을 구성할 수 있는지 판정하기

## 문제의 본질

세 개의 정수로 이루어진 트리플렛의 이차원 배열 `triplets`와 타겟 트리플렛 `target`이 주어진다. `triplets`에서 임의의 부분집합을 선택하여 요소별 최댓값(element-wise maximum)을 취한 결과가 `target`과 완전히 일치하는지를 판정하여 **boolean**으로 반환한다.

## 핵심 아이디어

타겟의 어느 하나의 요소라도 초과하는 값을 가진 트리플렛은, 병합에 사용하면 해당 위치가 타겟을 초과하게 되므로 절대 사용할 수 없다. 반대로, 모든 요소가 타겟 이하인 트리플렛만 병합하면 타겟을 초과할 걱정 없이 최댓값을 축적할 수 있으며, 최종적으로 타겟과 일치하는지 확인하기만 하면 된다.

## 사고 프로세스

1. **사용할 수 없는 트리플렛을 특정한다**: 트리플렛 `t`의 어느 하나의 요소라도 `target`의 대응하는 요소를 초과하는 경우, `t`를 병합에 포함하면 최댓값이 타겟을 초과하게 된다. 최댓값은 한번 올라가면 내릴 수 없으므로, 그러한 트리플렛은 절대 선택할 수 없다
2. **사용할 수 있는 트리플렛은 모두 사용해도 된다**: 모든 요소가 `target` 이하인 트리플렛은, 병합해도 타겟을 초과하지 않는다. 사용해도 해가 없으므로, 탐욕적으로 모두 채택해도 된다
3. **병합 결과를 어떻게 축적하는가**: 결과를 저장할 배열 `result`를 `[0, 0, 0]`으로 초기화하고, 사용 가능한 트리플렛의 각 요소와 `result`의 각 요소의 최댓값을 취하여 갱신해 나간다. `Math.max`로 요소별로 갱신하면, 선택한 모든 트리플렛의 element-wise maximum을 얻을 수 있다
4. **최종 판정**: 모든 트리플렛을 처리한 후, `result`가 `target`과 완전히 일치하면 `true`를, 일치하지 않으면 `false`를 반환한다. `Arrays.equals`로 배열의 모든 요소를 비교할 수 있다

## 사전 지식

### element-wise maximum(요소별 최댓값)이란

2개 이상의 배열에서 같은 위치의 요소를 비교하여, 각 위치에서 최대인 값을 취하는 연산이다. 예를 들어 `[2, 5, 3]`과 `[5, 1, 6]`의 element-wise maximum은 `[5, 5, 6]`이 된다.

```java
int[] a = {2, 5, 3};
int[] b = {5, 1, 6};
int[] merged = new int[3];
merged[0] = Math.max(a[0], b[0]);  // max(2, 5) → 5
merged[1] = Math.max(a[1], b[1]);  // max(5, 1) → 5
merged[2] = Math.max(a[2], b[2]);  // max(3, 6) → 6
// merged = [5, 5, 6]
```

### Math.max란

두 값 중 더 큰 쪽을 반환하는 메서드이다. 병합 결과의 축적에 사용한다.

```java
Math.max(3, 7);   // → 7
Math.max(5, 5);   // → 5
Math.max(0, 4);   // → 4（초깃값 0과 비교하여 갱신하는 용도）
```

### Arrays.equals란

두 배열의 길이와 모든 요소가 일치하는지를 판정하여 boolean으로 반환하는 메서드이다. `==` 연산자는 참조 비교이므로, 배열의 내용을 비교하려면 이 메서드를 사용해야 한다.

```java
int[] a = {2, 5, 3};
int[] b = {2, 5, 3};
a == b;              // → false（참조가 다르기 때문）
Arrays.equals(a, b); // → true（모든 요소가 일치하기 때문）
```

## 계산량

| | 값 |
|---|---|
| Time | O(n) — 트리플렛 배열을 1회 순회하는 것만으로 충분하다（각 트리플렛의 처리는 O(1)） |
| Space | O(1) — 길이 3의 고정 크기 배열 `result`만 사용한다 |

## 코드

```java
// 입력: 이차원 정수 배열 triplets（각 요소는 길이 3의 트리플렛）와, 길이 3의 정수 배열 target
// 출력: 트리플렛의 부분집합의 element-wise maximum으로 target을 구성할 수 있으면 true, 구성할 수 없으면 false
public boolean mergeTriplets(int[][] triplets, int[] target) {
    // 사용 가능한 트리플렛의 element-wise maximum을 축적할 배열을 [0, 0, 0]으로 초기화한다
    int[] result = new int[3];

    // triplets의 각 트리플렛 t를 처음부터 끝까지 하나씩 순회한다
    for (int[] t : triplets) {
        // 어느 하나의 요소라도 타겟을 초과하는 트리플렛은, 병합에 포함하면 최댓값이 타겟을 초과하게 되어 수정할 수 없으므로 건너뛴다
        if (t[0] > target[0] ||
            t[1] > target[1] ||
            t[2] > target[2])
            continue;

        // 모든 요소가 타겟 이하이므로, 이 갱신에 의해 result가 타겟을 초과하는 일은 없다
        // 각 요소의 최댓값으로 결과를 갱신한다
        result[0] = Math.max(result[0], t[0]);
        result[1] = Math.max(result[1], t[1]);
        result[2] = Math.max(result[2], t[2]);
    }

    // 축적한 결과가 타겟과 완전히 일치하는지를 판정하여 반환한다
    return Arrays.equals(result, target);
}
```
