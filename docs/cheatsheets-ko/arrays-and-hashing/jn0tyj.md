# Encoding and Decoding a List of Strings — 문자열 리스트를 하나의 문자열로 인코딩·디코딩하기

## 문제의 본질

문자열 리스트 `strs`가 주어진다. `encode` 메서드로 리스트를 하나의 문자열로 변환하고, `decode` 메서드로 그 문자열을 원래의 리스트로 복원한다. 인코딩과 디코딩은 스테이트리스(상태를 갖지 않는)여야 하며, 빈 문자열·특수 문자·구분 문자 자체를 포함하는 문자열 등 모든 입력을 올바르게 처리해야 한다.

## 핵심 아이디어

각 문자열 앞에 "해당 문자열의 길이"를 부여하면, 문자열 내용에 무엇이 포함되어 있어도 정확하게 잘라낼 수 있다. 길이를 알고 있으면 구분 문자와의 충돌 문제는 원리적으로 발생하지 않는다.

## 사고 프로세스

1. **단순한 구분 문자 방식의 문제점을 인식한다**: 쉼표나 개행 등의 구분 문자로 리스트를 결합하면, 문자열 자체에 해당 구분 문자가 포함되어 있는 경우 올바르게 디코딩할 수 없다. 이스케이프 처리를 도입하더라도 이스케이프 문자 자체의 이스케이프가 필요해져 복잡해진다
2. **문자열의 길이를 먼저 전달하면 충돌이 발생하지 않는다**: 각 문자열 앞에 해당 문자열의 길이(바이트 수가 아닌 문자 수)를 기록해 두면, 디코딩 시 "몇 문자를 읽을지"를 사전에 알 수 있다. 문자열의 내용을 전혀 해석하지 않고 잘라낼 수 있으므로, 어떤 문자가 포함되어 있어도 문제가 없다
3. **길이와 문자열 본체의 구분에 `#`를 사용한다**: 길이는 가변 자릿수의 정수이므로, 길이 부분의 끝을 나타내는 기호가 필요하다. `#`를 구분자로 사용하여 `길이#문자열본체` 형식으로 한다. 디코딩 시 첫 번째 `#`의 위치에서 길이 부분을 읽어내고, 그 뒤에서 지정된 문자 수를 잘라낸다
4. **인코딩**: 각 문자열에 대해 `문자열의 길이 + "#" + 문자열 본체`를 연결하여 하나의 문자열을 구축한다. 예를 들어 `["hello", "a#b"]`는 `5#hello3#a#b`가 된다
5. **디코딩**: 선두에서 `#`를 찾아 길이를 읽어내고, `#` 직후부터 길이만큼의 문자를 잘라낸다. 잘라내기 종료 위치를 다음 시작 위치로 하여 반복한다. 문자열 본체에 `#`가 포함되어 있어도, 길이로 정확한 범위를 알고 있으므로 오인하지 않는다
6. **최종적으로 반환하는 것**: `encode`는 연결된 하나의 `String`을 반환하고, `decode`는 해당 `String`에서 복원한 `List<String>`을 반환한다

## 사전 지식

### StringBuilder란

문자열을 효율적으로 연결하기 위한 클래스이다. `String`의 `+` 연산자를 통한 연결은 매번 새로운 `String` 객체를 생성하지만, `StringBuilder`는 내부 버퍼에 추가하므로 O(1)로 연결할 수 있다.

```java
StringBuilder sb = new StringBuilder();  // 빈 StringBuilder를 생성한다
sb.append("hello");                      // 끝에 "hello"를 추가한다
sb.append(5);                            // 끝에 정수 5를 문자열로 추가한다
sb.toString();                           // 결과 문자열 "hello5"를 반환한다
```

### String.indexOf(char, int)란

지정한 문자를 지정한 시작 위치부터 순방향으로 검색하여, 처음 발견된 위치(인덱스)를 반환하는 메서드이다. 찾지 못하면 -1을 반환한다.

```java
String str = "12#hello";
str.indexOf('#', 0);    // 위치 0부터 '#'를 찾는다 → 2를 반환한다
str.indexOf('#', 3);    // 위치 3부터 '#'를 찾는다 → 찾지 못하면 -1을 반환한다
```

### String.substring(int, int)란

문자열의 지정 범위를 잘라내는 메서드이다. 첫 번째 인수는 시작 위치(포함), 두 번째 인수는 종료 위치(미포함)이다.

```java
String str = "5#hello";
str.substring(0, 1);    // 위치 0부터 위치 1 앞까지 → "5"
str.substring(2, 7);    // 위치 2부터 위치 7 앞까지 → "hello"
```

### Integer.parseInt(String)란

문자열을 정수로 변환하는 정적 메서드이다. 길이 프리픽스의 숫자 부분을 정수로 읽어내기 위해 사용한다.

```java
Integer.parseInt("5");    // 문자열 "5"를 정수 5로 변환한다
Integer.parseInt("123");  // 문자열 "123"을 정수 123으로 변환한다
```

## 계산량

| | 값 |
|---|---|
| Time | O(n × k) — n은 문자열의 개수, k는 문자열의 평균 길이. 모든 문자열을 한 번씩 처리한다 |
| Space | O(n × k) — 인코딩 결과 또는 디코딩 결과로서 모든 문자열분의 영역을 사용한다 |

## 코드

```java
// === encode ===
// 입력: 문자열 리스트 strs (List<String>)
// 출력: 모든 문자열을 하나로 합친 String을 반환한다
public String encode(List<String> strs) {
    // 루프 내에서 문자열 연결을 효율적으로 수행하기 위해 StringBuilder를 사용한다
    StringBuilder sb = new StringBuilder();
    // 리스트의 각 문자열을 처음부터 순서대로 순회한다
    for (String str : strs) {
        // 각 문자열 앞에 "길이#"를 부여하여 연결한다
        // 길이를 먼저 기록함으로써, 디코딩 시 문자열 본체의 정확한 범위를 알 수 있다
        sb.append(str.length() + "#" + str);
    }
    // StringBuilder의 내용을 String으로 반환한다
    return sb.toString();
}

// === decode ===
// 입력: 인코딩된 하나의 문자열 str (String)
// 출력: 복원한 문자열 리스트 List<String>을 반환한다
public List<String> decode(String str) {
    List<String> result = new ArrayList<>();
    // 현재 읽기 위치를 나타내는 변수. 선두부터 시작한다
    int i = 0;
    while (i < str.length()) {
        // 현재 위치 i부터 첫 번째 '#'를 찾아, 길이 부분과 문자열 본체의 구분 위치를 특정한다
        int separatorIndex = str.indexOf('#', i);
        // '#' 앞까지를 정수로 읽어내어, 문자열 본체의 길이를 얻는다
        int textLength = Integer.parseInt(str.substring(i, separatorIndex));
        // '#' 직후가 문자열 본체의 시작 위치이다
        int textStart = separatorIndex + 1;
        // 시작 위치에서 길이만큼 앞이 종료 위치이다. 길이로 범위를 결정하므로, 문자열 본체에 '#'가 포함되어 있어도 올바르게 잘라낼 수 있다
        int textEnd = textStart + textLength;
        // 문자열 본체를 잘라내어 결과 리스트에 추가한다
        result.add(str.substring(textStart, textEnd));
        // 읽기 위치를 다음 문자열의 길이 부분 선두로 이동한다
        i = textEnd;
    }
    return result;
}
```
