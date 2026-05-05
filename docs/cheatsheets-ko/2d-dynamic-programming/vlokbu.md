# Counting Ways to Assign Signs to Reach a Target Sum — 부호를 할당하여 목표 합계를 만드는 방법의 수를 구하기

## 문제의 본질

정수 배열 `nums`와 정수 `target`이 주어진다. `nums`의 각 요소에 `+` 또는 `-` 부호를 할당하여, 모든 요소의 합계가 `target`과 같아지는 조합이 몇 가지인지를 반환한다.

## 핵심 아이디어

각 요소에 `+` 또는 `-`를 할당하는 문제는, 배열을 「양의 부호 그룹(P)」과 「음의 부호 그룹(N)」으로 분할하는 문제와 동일하다. P - N = target 이고 P + N = totalSum 이므로 P = (target + totalSum) / 2 가 도출되며, 문제는 「합계가 P가 되는 부분집합의 수를 세는」 부분합 문제로 변환할 수 있다.

## 사고 프로세스

1. **부호 할당을 집합의 분할로 파악한다**: 각 요소에 `+`를 붙인 요소의 합계를 P, `-`를 붙인 요소의 합계를 N이라 하면, P - N = target이 성립한다. 동시에 P + N = totalSum(모든 요소의 합계)도 성립한다. 이 두 식을 연립하면 P = (target + totalSum) / 2를 얻을 수 있다
2. **해가 존재하지 않는 조건을 먼저 배제한다**: P = (target + totalSum) / 2가 정수가 되지 않는 경우(즉 `(target + totalSum)`이 홀수인 경우), 유효한 분할은 존재하지 않는다. 또한 `|target|`이 `totalSum`을 초과하는 경우에도 해는 존재하지 않는다. 이러한 조건을 먼저 확인하여 0을 반환한다
3. **부분합 문제로서 DP로 풀다**: 「배열 `nums`에서 요소를 선택하여 합계가 `subsetSum`(= P)이 되는 조합의 수」는 전형적인 부분합 카운트 문제이다. DP 배열 `dp[j]`를 「합계가 j가 되는 부분집합의 수」로 정의하고, 각 요소에 대해 갱신해 나간다
4. **1차원 DP 배열로 공간을 최적화한다**: 2차원 테이블을 사용하는 대신, 1차원 배열 `dp[0..subsetSum]`을 준비하고, 각 요소 `num`에 대해 `j`를 `subsetSum`에서 `num`까지 역순으로 순회하면서 `dp[j] += dp[j - num]`으로 갱신한다. 역순으로 순회하는 이유는 같은 요소를 여러 번 사용하는 것을 방지하기 위함이다
5. **초기 조건을 설정한다**: `dp[0] = 1`로 설정한다. 이는 「아무것도 선택하지 않고 합계 0을 만드는 방법이 1가지 있다」는 것을 의미한다
6. **최종적으로 반환하는 것**: 모든 요소를 처리한 후의 `dp[subsetSum]`이 합계가 `subsetSum`이 되는 부분집합의 수, 즉 원래 문제의 답이다

## 사전 지식

### 부분합 문제(Subset Sum Problem)란

주어진 집합에서 요소를 선택하여, 그 합계가 특정 값이 되는 조합을 구하는 문제이다. 배낭 문제의 일종이며, DP로 효율적으로 풀 수 있다.

### 1차원 DP 배열에 의한 부분합 카운트

`dp[j]`는 「합계가 j가 되는 부분집합의 수」를 나타낸다. 각 요소 `num`에 대해, `dp[j] += dp[j - num]`으로 갱신한다.

```java
int[] dp = new int[targetSum + 1]; // dp[j] = 합계가 j가 되는 조합의 수
dp[0] = 1;                         // 합계 0을 만드는 방법은 1가지(아무것도 선택하지 않음)
dp[j] += dp[j - num];              // num을 사용하여 j를 만든다 = num을 사용하지 않고 j-num을 만드는 방법의 수를 가산한다
```

### 역순 루프의 이유

안쪽 루프를 `subsetSum`에서 `num`으로 역순으로 돌린다. 순방향으로 돌리면, 같은 요소 `num`을 동일 이터레이션 내에서 여러 번 가산하게 된다. 역순으로 함으로써, 각 요소를 「선택하거나 선택하지 않거나」의 0-1 배낭 제약을 충족한다.

```java
// 역순 루프: 각 요소를 최대 1번만 사용한다(0-1 배낭)
for (int j = subsetSum; j >= num; j--) {
    dp[j] += dp[j - num];
}
```

## 계산량

| | 값 |
|---|---|
| Time | O(n × subsetSum) — 각 요소에 대해 DP 배열을 1회 순회한다 |
| Space | O(subsetSum) — 1차원 DP 배열만 사용한다 |

## 코드

```java
// 입력: 정수 배열 nums와 정수 target
// 출력: 각 요소에 +/-를 할당하여 합계가 target이 되는 조합의 수를 int로 반환한다
public int findTargetSumWays(int[] nums, int target) {
    // 배열 nums의 모든 요소의 합계를 계산하여, 변수 totalSum에 대입한다
    int totalSum = 0;
    for (int num : nums) {
        totalSum += num;
    }

    // 해가 존재하지 않는 조건을 확인한다
    // (target + totalSum)이 홀수인 경우, P = (target + totalSum) / 2가 정수가 되지 않으므로,
    // 정수 개의 요소로 구성되는 부분집합으로는 달성할 수 없기 때문에 0을 반환한다
    // |target|이 totalSum을 초과하는 경우에도, 어떻게 부호를 할당해도 target에 도달할 수 없으므로 0을 반환한다
    if ((target + totalSum) % 2 != 0
        || Math.abs(target) > totalSum)
        return 0;

    // + 부호 그룹의 합계값을 구한다. 이후의 처리에서 구해야 할 타겟이 된다
    int subsetSum = (target + totalSum) / 2;

    // dp[j] = nums의 요소를 선택하여 합계가 j가 되는 조합의 수
    int[] dp = new int[subsetSum + 1];
    // 기저 케이스: 아무것도 선택하지 않고 합계 0을 만드는 방법은 1가지이다
    dp[0] = 1;

    // 바깥쪽 루프: 배열 nums의 각 요소를 처음부터 끝까지 순서대로 순회한다
    for (int num : nums) {
        // 안쪽 루프: subsetSum에서 num까지 역순으로 순회한다
        // 역순으로 하는 이유: 같은 num을 동일 이터레이션 내에서 여러 번 사용하는 것을 방지한다(0-1 배낭 제약)
        for (int j = subsetSum; j >= num; j--) {
            // num을 사용하지 않고 합계 j - num을 만드는 방법의 수를, num을 사용하여 합계 j를 만드는 방법의 수에 가산한다
            dp[j] += dp[j - num];
        }
    }

    // dp[subsetSum]이 합계가 subsetSum이 되는 부분집합의 수, 즉 원래 문제에서의 부호 할당 방법의 총 수이다
    return dp[subsetSum];
}
```
