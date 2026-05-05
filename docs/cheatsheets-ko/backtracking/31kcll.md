# Mapping Phone Number Digits to Letter Combinations — 전화번호의 숫자로부터 문자의 모든 조합을 생성하기

## 문제의 본질

숫자 2~9로 이루어진 문자열 `digits`가 주어진다. 각 숫자는 전화 키패드에 대응하는 문자(예: 2→"abc", 3→"def")에 매핑된다. `digits`의 각 숫자에서 1문자씩 선택하여 나열했을 때, 가능한 **모든 문자의 조합**을 리스트로 반환한다.

## 핵심 아이디어

각 숫자의 위치에서 선택할 수 있는 문자는 3~4개이며, 모든 조합을 열거할 필요가 있다. 한 문자씩 선택하여 끝에 추가하고, 모든 자릿수를 선택한 후에는 결과에 기록하며, 직전의 선택을 취소하고 다른 문자를 시도하는 「백트래킹」으로 모든 패턴을 빠짐없이 탐색할 수 있다.

## 사고 프로세스

1. **각 숫자의 위치에서 선택지가 있다**: 숫자마다 대응하는 문자가 3~4개 있으며, 각 위치에서 1문자를 선택한다. 모든 위치의 선택 조합이 답이 되므로, 모든 패턴을 체계적으로 열거할 필요가 있다
2. **재귀로 한 자릿수씩 처리한다**: 첫 번째 숫자부터 순서대로 1문자를 선택하고, 다음 숫자의 처리를 재귀 호출에 맡긴다. 이렇게 하면 각 재귀의 깊이가 하나의 숫자 위치에 대응하여 구조가 단순해진다
3. **종료 조건은 모든 자릿수를 처리한 시점이다**: 재귀의 깊이가 `digits`의 길이에 도달했을 때, 현재 구축 중인 문자열이 하나의 완성된 조합이 된다. 이것을 결과 리스트에 추가한다
4. **백트래킹으로 다른 선택지를 시도한다**: 재귀에서 돌아오면, 직전에 추가한 문자를 `StringBuilder`의 끝에서 삭제한다. 이렇게 함으로써 같은 위치의 다른 문자를 시도할 준비가 된다
5. **숫자에서 문자로의 변환에는 매핑 배열을 사용한다**: 인덱스 0~9의 문자열 배열을 준비하고, `digits.charAt(idx) - '0'`으로 숫자를 정수로 변환하여 인덱스 접근하면 대응하는 문자군을 O(1)로 가져올 수 있다
6. **빈 문자열 입력을 처리한다**: `digits`가 비어 있는 경우에는 조합이 존재하지 않으므로, 빈 리스트를 그대로 반환한다

## 전제 지식

### 백트래킹이란

해의 후보를 하나씩 구축하고, 완성되면 기록하며, 직전의 선택을 취소하고 다른 선택지를 시도하는 탐색 기법이다. 모든 조합·순열을 열거하는 문제에서 사용된다. 「선택→전진→복원→다른 것을 시도」의 사이클을 재귀로 구현한다.

```java
// 백트래킹의 기본 패턴
void backtrack(상태, 결과리스트) {
    if (종료조건) {
        결과리스트.add(현재의 상태);
        return;
    }
    for (선택지 : 현재의 선택지 목록) {
        상태에 선택지를 추가;       // 선택
        backtrack(다음 상태, 결과리스트); // 전진
        상태에서 선택지를 삭제;     // 복원 (백트래킹)
    }
}
```

### StringBuilder란

문자열을 효율적으로 조립하기 위한 클래스이다. `String`은 불변(변경할 때마다 새로운 객체가 생성됨)이지만, `StringBuilder`는 내부 버퍼를 직접 변경하므로 문자의 추가·삭제가 O(1)로 가능하다. 백트래킹에서 문자열을 조립할 때 적합하다.

```java
StringBuilder sb = new StringBuilder();  // 빈 StringBuilder를 생성한다
sb.append('a');           // 끝에 문자 'a'를 추가한다 → "a"
sb.append('b');           // 끝에 문자 'b'를 추가한다 → "ab"
sb.deleteCharAt(sb.length() - 1);  // 끝의 문자를 삭제한다 → "a"
sb.toString();            // String 타입으로 변환하여 반환한다 → "a"
```

### 전화 키패드의 매핑

숫자와 문자의 대응을 배열로 표현한다. 배열의 인덱스가 숫자에 대응하고, 값이 해당 숫자에 할당된 문자군이다.

```java
String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};
// phone[2] → "abc",  phone[7] → "pqrs",  phone[9] → "wxyz"
// 문자 '3'에서 정수 3으로의 변환: '3' - '0' → 3
```

## 계산량

| | 값 |
|---|---|
| Time | O(4^n) — 각 숫자에 최대 4문자의 선택지가 있으며, n자릿수분의 모든 조합을 열거한다 |
| Space | O(n) — 재귀의 깊이가 최대 n이고, StringBuilder의 길이도 최대 n이다 (결과 리스트 제외) |

## 코드

```java
// 입력: 숫자 2~9로 이루어진 문자열 digits
// 출력: 모든 문자의 조합을 저장한 List<String>을 반환한다

// 백트래킹으로 한 자릿수씩 문자를 선택하여 모든 조합을 열거한다
void backtrack(String digits, String[] phone, int idx, StringBuilder path, List<String> result) {
    // 종료 조건: idx가 digits의 길이와 같으면 모든 자릿수의 문자를 선택 완료한 것이다
    // StringBuilder의 내용을 String으로 변환하여 결과에 추가한다
    if (idx == digits.length()) {
        result.add(path.toString());
        return;
    }

    // digits.charAt(idx) - '0'으로 문자의 숫자를 정수로 변환하고, phone 배열에서 대응하는 문자군을 가져온다
    String letters = phone[digits.charAt(idx) - '0'];

    // 현재 숫자에 대응하는 각 문자를 하나씩 시도한다
    for (char c : letters.toCharArray()) {
        path.append(c);                            // 선택: 문자를 선택하여 끝에 추가한다
        backtrack(digits, phone, idx + 1, path, result);  // 재귀: 다음 자릿수의 처리로 진행한다
        path.deleteCharAt(path.length() - 1);      // 복원: 끝의 문자를 삭제하여 원래대로 되돌린다 (백트래킹)
    }
}

List<String> letterCombinations(String digits) {
    // 결과를 저장할 빈 리스트를 생성한다
    List<String> result = new ArrayList<>();

    // 빈 문자열인 경우에는 조합이 존재하지 않으므로 빈 리스트를 반환한다
    if (digits.isEmpty()) return result;

    // 인덱스가 숫자에 대응하는 매핑 배열을 정의한다
    // 인덱스 0과 1은 전화 키패드에서 문자가 할당되어 있지 않으므로 빈 문자열로 설정한다
    String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    // 위치 0부터 빈 StringBuilder로 백트래킹을 시작한다
    backtrack(digits, phone, 0, new StringBuilder(), result);

    // 모든 재귀가 완료되어 모든 조합이 저장된 result를 반환한다
    return result;
}
```
