# Finding the Smallest Window Containing All Characters — 모든 문자를 포함하는 최소 부분 문자열 찾기

## 문제의 본질

2개의 문자열 `s`와 `t`가 주어진다. `s` 안에서 `t`의 모든 문자(중복 포함)를 포함하는 **최단 부분 문자열**을 찾아서 반환한다. 그러한 부분 문자열이 존재하지 않는 경우 빈 문자열을 반환한다.

## 핵심 아이디어

오른쪽 포인터를 확장하여 조건을 만족하는 윈도우를 만들고, 왼쪽 포인터를 축소하여 최소화한다. "조건을 만족하는 문자 종류의 수"를 하나의 변수로 관리함으로써, 윈도우의 유효성을 O(1)로 판정할 수 있다.

## 사고 프로세스

1. **필요한 문자의 출현 횟수를 사전에 센다**: `t`에 포함된 각 문자의 출현 횟수를 HashMap에 기록한다. 이것이 윈도우가 만족해야 할 조건이 된다. 예를 들어 `t = "ABC"`라면 `{A:1, B:1, C:1}`이 된다
2. **윈도우를 오른쪽으로 확장하여 조건을 만족시킨다**: 오른쪽 포인터 `r`을 하나씩 진행시켜 윈도우에 문자를 추가하고, 윈도우 내의 문자 출현 횟수를 별도의 HashMap으로 관리한다. 윈도우 내의 출현 횟수가 필요 수에 도달한 문자 종류가 하나 증가할 때마다, 카운터 `have`를 인크리먼트한다
3. **조건 충족을 O(1)로 판정한다**: `need`의 크기(필요한 문자 종류의 수)를 `required`로 하고, `have == required`가 성립하면 윈도우는 `t`의 모든 문자를 포함하고 있다. 문자 종류 단위로 관리함으로써 매번 모든 문자를 비교할 필요가 없어진다
4. **윈도우를 왼쪽부터 축소하여 최소화한다**: `have == required`인 동안, 왼쪽 포인터 `left`를 오른쪽으로 진행시켜 윈도우를 축소한다. 축소할 때마다 윈도우의 길이를 현재의 최솟값과 비교하고, 더 짧으면 갱신한다
5. **왼쪽 끝 문자를 제외할 때의 처리**: 왼쪽 끝 문자 `s.charAt(left)`를 윈도우에서 제외할 때, 해당 문자가 `need`에 포함되어 있고, 윈도우 내의 출현 횟수가 필요 수를 밑돌면 `have`를 디크리먼트한다. 이로 인해 `while` 루프가 종료되고, 오른쪽 포인터의 확장으로 돌아간다
6. **최종적으로 반환하는 것**: 탐색 종료 후, 최소 윈도우가 발견되었으면 `s.substring(resStart, resStart + resLen)`을 반환한다. 발견되지 않았으면 빈 문자열을 반환한다

## 사전 지식

### HashMap이란

키와 값의 쌍을 저장하는 자료 구조이다. 키를 지정하여 값의 검색·취득을 O(1)로 수행할 수 있다. 이 문제에서는 문자의 출현 횟수를 관리하기 위해 사용한다.

```java
HashMap<Character, Integer> map = new HashMap<>();  // 빈 HashMap을 생성한다
map.put('A', 1);                    // 키 'A'에 값 1을 저장한다
map.getOrDefault('A', 0);           // 키 'A'의 값을 반환한다. 존재하지 않으면 0을 반환한다 → 1
map.containsKey('A');               // 키 'A'가 존재하는지를 boolean으로 반환한다 → true
map.get('A').equals(map.get('B'));  // Integer 객체 간의 비교에는 equals를 사용한다
```

### Sliding Window(슬라이딩 윈도우)란

배열이나 문자열 위의 연속된 범위(윈도우)를 2개의 포인터 `left`와 `right`로 관리하는 기법이다. 오른쪽 포인터로 윈도우를 확장하고, 왼쪽 포인터로 윈도우를 축소함으로써, 모든 부분 문자열을 조사하는 O(n²)의 처리를 O(n)으로 최적화할 수 있다.

```java
int left = 0;
for (int r = 0; r < s.length(); r++) {
    // 오른쪽 포인터로 윈도우를 확장하는 처리
    while (조건을 만족하고 있다) {
        // 왼쪽 포인터로 윈도우를 축소하는 처리
        left++;
    }
}
```

### have / required 패턴이란

윈도우가 조건을 만족하는지를 O(1)로 판정하기 위한 기법이다. `required`는 만족해야 할 문자 종류의 총수, `have`는 현시점에서 필요 수에 도달한 문자 종류의 수를 나타낸다. `have == required`일 때 윈도우는 모든 조건을 만족한다.

```java
int required = need.size();  // 필요한 문자 종류의 수 (예: need={A:1,B:1,C:1} → 3)
int have = 0;                // 조건을 만족한 문자 종류의 수 (초깃값 0)
// 윈도우 내의 'A'의 수가 need의 'A'의 수에 도달하면 have++ → have==required로 모든 조건 충족
```

## 계산량

| | 값 |
|---|---|
| Time | O(n) — 오른쪽 포인터와 왼쪽 포인터가 각각 `s`를 최대 1회씩 탐색한다 |
| Space | O(n) — HashMap `need`와 `window`에 최대로 `s`와 `t`의 문자 종류 수만큼의 요소를 저장한다 |

## 코드

```java
// 입력: 문자열 s와 문자열 t
// 출력: s 안에서 t의 모든 문자를 포함하는 최단 부분 문자열을 String으로 반환한다. 존재하지 않으면 빈 문자열을 반환한다
String minWindow(String s, String t) {
    // s가 t보다 짧으면 모든 문자를 포함하는 윈도우는 존재하지 않는다
    if (s.length() < t.length())
        return "";

    // t의 각 문자의 필요 출현 횟수를 기록하는 HashMap. 이것이 윈도우가 만족해야 할 조건을 정의한다
    Map<Character, Integer> need = new HashMap<>();
    for (char c : t.toCharArray()) {
        need.put(c, need.getOrDefault(c, 0) + 1);
    }

    // 윈도우 내의 각 문자의 출현 횟수를 관리하는 HashMap
    Map<Character, Integer> window = new HashMap<>();
    int have = 0;              // 조건을 만족한 문자 종류의 수
    int required = need.size(); // 만족해야 할 문자 종류의 총수 (need의 키의 수)
    int resLen = Integer.MAX_VALUE; // 최소 윈도우의 길이 (미발견 상태를 나타내는 초깃값)
    int resStart = 0;          // 최소 윈도우의 시작 위치
    int left = 0;              // 왼쪽 포인터

    // 오른쪽 포인터로 윈도우를 오른쪽으로 확장해 나간다
    for (int r = 0; r < s.length(); r++) {
        char c = s.charAt(r);
        // 윈도우 내의 문자 c의 출현 횟수를 1 증가시킨다 (윈도우가 오른쪽으로 1문자 확장된다)
        window.put(c, window.getOrDefault(c, 0) + 1);

        // 문자 c가 t에 필요한 문자이며, 윈도우 내의 출현 횟수가 필요 수에 정확히 도달하면 have를 증가시킨다
        // 주의: Integer 객체의 비교에는 == 대신 equals를 사용한다
        if (need.containsKey(c)
            && window.get(c).equals(need.get(c))) {
            have++;
        }

        // 윈도우가 모든 조건을 만족하는 동안 (have == required), 왼쪽부터 축소하여 최소화한다
        while (have == required) {
            int wLen = r - left + 1;
            // 더 짧은 윈도우가 발견되면 결과를 갱신한다
            if (wLen < resLen) {
                resLen = wLen;
                resStart = left;
            }
            // 왼쪽 끝 문자를 윈도우에서 제외한다
            char lc = s.charAt(left);
            window.put(lc, window.get(lc) - 1);
            // 제외로 인해 윈도우 내의 출현 횟수가 필요 수를 밑돌면, 조건이 깨졌으므로 have를 감소시킨다
            if (need.containsKey(lc)
                && window.get(lc) < need.get(lc)) {
                have--;
            }
            // 왼쪽 포인터를 오른쪽으로 진행시켜 윈도우를 축소한다
            left++;
        }
    }

    // resLen이 초깃값 그대로이면 조건을 만족하는 윈도우가 발견되지 않았으므로 빈 문자열을 반환한다
    if (resLen == Integer.MAX_VALUE)
        return "";
    // 최소 윈도우의 시작 위치부터 최소 윈도우의 길이만큼을 잘라서 반환한다
    return s.substring(resStart, resStart + resLen);
}
```
