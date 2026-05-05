# Checking if a String is a Palindrome — 문자열이 회문인지 판정하기

## 문제의 본질

문자열 `s`가 주어진다. 영숫자만을 대상으로 하고, 대문자·소문자의 차이를 무시하여, 해당 문자열이 회문(앞에서 읽어도 뒤에서 읽어도 동일)인지를 판정한다. 회문이면 `true`를, 그렇지 않으면 `false`를 반환한다.

## 핵심 아이디어

문자열의 양쪽 끝에서 2개의 포인터를 안쪽으로 이동시키며, 영숫자가 아닌 문자를 건너뛰면서 한 문자씩 비교하면, 추가 문자열을 생성하지 않고 O(1)의 공간으로 회문 판정을 할 수 있다.

## 사고 프로세스

1. **회문의 정의를 확인한다**: 회문이란, 앞에서 읽어도 뒤에서 읽어도 동일한 문자열을 말한다. 즉, 선두와 말미의 문자가 일치하고, 그 안쪽도 마찬가지로 일치하면 회문이다
2. **양쪽 끝에서 비교하면 한 번의 순회로 판정할 수 있다**: 선두에 포인터 `left`, 말미에 포인터 `right`를 놓고, 양쪽이 만날 때까지 안쪽으로 이동시키며 비교하면, 모든 문자를 한 번씩만 확인하는 것으로 판정이 완료된다
3. **영숫자가 아닌 문자를 건너뛸 필요가 있다**: 문제는 영숫자만을 대상으로 하므로, 각 포인터가 영숫자가 아닌 문자를 가리키고 있는 경우에는 건너뛰고 다음으로 이동한다. `Character.isLetterOrDigit`로 영숫자인지 여부를 판정할 수 있다
4. **대문자·소문자를 통일한 후 비교한다**: 문제는 대소문자를 구별하지 않으므로, 비교 전에 `Character.toLowerCase`로 양쪽 문자를 소문자로 변환한 후 일치 여부를 확인한다
5. **불일치를 발견한 시점에서 즉시 `false`를 반환한다**: 한 곳이라도 다르면 회문이 아니므로, 조기 리턴할 수 있다
6. **포인터가 교차할 때까지 불일치가 없으면 회문이다**: 루프가 정상적으로 종료된 경우, 모든 대응하는 문자가 일치했음을 의미하므로 `true`를 반환한다

## 전제 지식

### Two Pointers(투 포인터 기법)란

배열이나 문자열의 양쪽 끝에 포인터를 놓고, 조건에 따라 안쪽으로 이동시켜 나가는 기법이다. 대칭성을 활용하는 문제(회문 판정, 쌍 탐색 등)에 유효하다. 한 번의 순회로 문제를 풀 수 있으므로, 시간 O(n)·공간 O(1)을 실현할 수 있다.

```java
int left = 0;                    // 선두를 가리키는 포인터
int right = s.length() - 1;     // 말미를 가리키는 포인터
// left와 right가 교차할 때까지 루프를 계속한다
while (left < right) {
    // 비교 또는 처리를 수행한다
    left++;    // 왼쪽 포인터를 오른쪽으로 이동시킨다
    right--;   // 오른쪽 포인터를 왼쪽으로 이동시킨다
}
```

### Character.isLetterOrDigit란

문자가 영문자(a-z, A-Z) 또는 숫자(0-9)인지를 판정하는 메서드이다. 스페이스나 기호 등 영숫자가 아닌 문자를 제외하고 싶을 때 사용한다.

```java
Character.isLetterOrDigit('A');   // true(영문자)
Character.isLetterOrDigit('3');   // true(숫자)
Character.isLetterOrDigit(' ');   // false(스페이스)
Character.isLetterOrDigit(',');   // false(기호)
```

### Character.toLowerCase란

영문자를 소문자로 변환하는 메서드이다. 대문자·소문자를 구별하지 않고 비교하고 싶을 때 사용한다. 이미 소문자이거나 숫자인 경우에는 그대로 반환한다.

```java
Character.toLowerCase('A');   // 'a'
Character.toLowerCase('a');   // 'a'(변화 없음)
Character.toLowerCase('3');   // '3'(숫자는 그대로)
```

## 계산량

| | 값 |
|---|---|
| Time | O(n) — 각 포인터가 문자열을 최대 1회 순회한다 |
| Space | O(1) — 포인터 2개만 사용하며 추가 문자열이나 데이터 구조를 사용하지 않는다 |

## 코드

```java
// 입력: 문자열 s
// 출력: s가 회문이면 true를, 그렇지 않으면 false를 반환한다
public boolean isPalindrome(String s) {
    // 선두와 말미에 포인터를 배치한다. 이 2개가 문자열의 양쪽 끝에서 안쪽으로 이동한다
    int left = 0;
    int right = s.length() - 1;

    // 2개의 포인터가 교차할 때까지 반복한다. 교차하면 모든 비교가 완료되었음을 의미한다
    while (left < right) {
        // left가 영숫자가 아니면 오른쪽으로 건너뛴다
        // 주의: 건너뛰는 중에도 left < right 조건을 유지하여, 포인터가 교차하지 않도록 한다
        while (left < right && !Character.isLetterOrDigit(s.charAt(left))) {
            left++;
        }
        // right가 영숫자가 아니면 왼쪽으로 건너뛴다. 마찬가지로 left < right 조건을 유지한다
        while (left < right && !Character.isLetterOrDigit(s.charAt(right))) {
            right--;
        }
        // 양쪽 문자를 소문자로 변환한 후 비교함으로써, 대소문자의 차이를 무시한다
        // 불일치라면 회문이 아니다. 한 곳이라도 다르면 회문의 조건을 충족하지 않으므로 즉시 반환한다
        if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right))) {
            return false;
        }
        // 2개의 문자가 일치했으므로, 양쪽 포인터를 안쪽으로 이동시켜 다음 문자 쌍의 비교로 넘어간다
        left++;
        right--;
    }
    // 루프가 정상적으로 종료되었으므로(모든 대응하는 문자 쌍이 일치했으므로) 회문이다
    return true;
}
```
