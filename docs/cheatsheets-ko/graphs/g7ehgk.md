# Finding the Shortest Word Transformation Sequence — 최단 단어 변환 시퀀스의 길이를 구하기

## 문제의 본질

시작 단어 `beginWord`, 종료 단어 `endWord`, 유효한 단어 사전 `wordList`가 주어진다. 시작 단어에서 종료 단어까지 **한 단계에 한 글자만 변경**하며, 모든 중간 단어가 사전에 존재하는 변환 시퀀스 중 **최단 길이**를 반환한다. 변환 시퀀스가 존재하지 않는 경우 0을 반환한다.

## 핵심 아이디어

단어 간의 한 글자 변환을 그래프의 간선으로 간주하면, 최단 변환 시퀀스는 최단 경로 문제가 된다. BFS를 시작점과 종료점 양쪽에서 동시에 실행하고, 항상 작은 쪽의 프론티어를 확장함으로써 탐색 공간을 극적으로 줄일 수 있다.

## 사고 프로세스

1. **그래프로 파악하기**: 각 단어를 노드로, 한 글자 차이인 단어끼리를 간선으로 연결한 그래프를 생각한다. 최단 변환 시퀀스의 길이는 이 그래프 위에서 beginWord에서 endWord로의 최단 경로 길이에 해당한다
2. **최단 경로에는 BFS를 사용하기**: 가중치 없는 그래프의 최단 경로 문제이므로 BFS(너비 우선 탐색)가 적합하다. 각 레벨이 변환 1단계에 대응한다
3. **단방향 BFS의 비효율성**: 시작점에서만 BFS를 수행하면 각 레벨에서 후보가 지수적으로 증가한다. 탐색 공간은 깊이에 따라 폭발적으로 커진다
4. **양방향 BFS로 탐색 공간을 축소하기**: 시작점과 종료점 양쪽에서 BFS를 동시에 진행하면, 양쪽이 만나는 시점에서 최단 경로를 찾을 수 있다. 한쪽의 탐색 깊이가 d/2로 충분하므로 탐색 공간이 대폭 축소된다
5. **작은 쪽의 프론티어를 우선적으로 확장하기**: 매 단계에서 시작점 측과 종료점 측의 프론티어(현재 레벨의 단어 집합) 크기를 비교하여 작은 쪽을 확장한다. 이렇게 함으로써 항상 프론티어의 팽창을 억제할 수 있다
6. **인접 단어의 생성 방법**: 사전 내의 모든 단어와 비교하는 대신, 단어의 각 위치에 대해 a~z의 26글자를 시도하여 인접 단어를 생성한다. 단어 길이 m이 사전 크기 n보다 충분히 작은 경우 이 방법이 효율적이다
7. **상대 프론티어와의 합류 판정**: 생성한 인접 단어가 상대측 프론티어에 포함되어 있으면, 양쪽 탐색이 합류했음을 의미하며 해당 시점의 레벨+1을 반환한다

## 전제 지식

### BFS(너비 우선 탐색)란

그래프의 시작점에서 가까운 순서대로 노드를 탐색하는 알고리즘이다. 각 레벨에서 거리가 1씩 증가하므로, 처음 도달한 시점의 거리가 최단 거리가 된다. 가중치 없는 그래프의 최단 경로 문제에 사용한다.

### HashSet란

요소의 집합을 유지하는 데이터 구조이다. 요소의 추가·검색·삭제를 O(1)로 수행할 수 있다. 중복을 자동으로 제거한다.

```java
Set<String> set = new HashSet<>();   // 빈 HashSet을 생성한다
set.add("hot");                      // 요소를 추가한다
set.contains("hot");                 // 요소가 존재하는지를 boolean으로 반환한다 → true
set.size();                          // 요소 수를 반환한다 → 1
```

### 양방향 BFS란

일반 BFS가 시작점에서만 탐색하는 것에 반해, 양방향 BFS는 시작점과 종료점 양쪽에서 동시에 탐색을 진행한다. 양쪽의 프론티어가 겹치는 시점에서 최단 경로를 찾을 수 있다. 탐색 공간이 O(b^d)에서 O(b^(d/2))로 줄어든다(b는 분기 인수, d는 최단 거리).

### toCharArray / String.valueOf란

String을 문자 배열로 변환하여 한 글자씩 조작하기 위한 메서드 그룹이다.

```java
char[] ch = "hot".toCharArray();     // String → char[]로 변환한다 → ['h','o','t']
ch[0] = 'b';                        // 한 글자를 직접 변경한다 → ['b','o','t']
String next = String.valueOf(ch);    // char[] → String으로 되돌린다 → "bot"
```

## 계산량

| | 값 |
|---|---|
| Time | O(n × m) — n은 사전의 단어 수, m은 단어의 길이이다. 각 단어의 각 위치에 26글자를 시도한다 |
| Space | O(n × m) — 방문 완료 세트와 프론티어에 최대 n개의 단어(각 길이 m)를 저장한다 |

## 코드

```java
// 입력: 시작 단어 beginWord, 종료 단어 endWord, 유효한 단어 사전 wordList
// 출력: 최단 변환 시퀀스의 길이를 int로 반환한다. 변환 시퀀스가 존재하지 않는 경우 0을 반환한다
int ladderLength(String beginWord, String endWord, List<String> wordList) {
    // 사전을 HashSet으로 변환하여 단어의 존재 판정을 O(1)로 만든다
    Set<String> wordSet = new HashSet<>(wordList);
    // endWord가 사전에 없는 경우 변환 시퀀스를 만들 수 없으므로 0을 반환한다
    if (!wordSet.contains(endWord)) return 0;

    // 시작점 측 프론티어·종료점 측 프론티어·방문 완료 세트의 3개 HashSet을 생성한다
    Set<String> start = new HashSet<>();
    Set<String> end = new HashSet<>();
    Set<String> visited = new HashSet<>();
    start.add(beginWord);
    end.add(endWord);
    // 양쪽 프론티어의 단어를 방문 완료로 등록해 둔다
    visited.add(beginWord);
    visited.add(endWord);
    // level은 변환 시퀀스의 길이이다(시작점 자체를 1로 센다)
    int level = 1;

    // 어느 한쪽 프론티어가 비면 도달 불가능하므로 루프를 빠져나온다
    while (!start.isEmpty() && !end.isEmpty()) {
        // 항상 작은 쪽의 프론티어를 확장하여 탐색 공간의 팽창을 억제한다
        if (start.size() > end.size()) {
            Set<String> temp = start;
            start = end;
            end = temp;
        }

        // 다음 레벨의 후보를 유지하는 세트
        Set<String> nextLevel = new HashSet<>();

        for (String word : start) {
            // 단어를 char[]로 변환하여 각 위치를 한 글자씩 교체하여 인접 단어를 생성한다
            char[] ch = word.toCharArray();
            for (int j = 0; j < ch.length; j++) {
                // 원래 문자를 백업하여 탐색 후 복원할 수 있도록 한다
                char orig = ch[j];
                // 각 위치에 a~z의 26글자를 시도하여 인접 단어를 생성한다
                for (char c = 'a'; c <= 'z'; c++) {
                    ch[j] = c;
                    String next = String.valueOf(ch);
                    // 상대측 프론티어에 포함되어 있으면 양쪽 탐색이 합류한 것이다
                    if (end.contains(next)) return level + 1;
                    // 사전에 있고 미방문이면 다음 프론티어에 추가한다
                    // visited에 추가하여 같은 단어의 재방문을 방지한다
                    if (wordSet.contains(next) && !visited.contains(next)) {
                        nextLevel.add(next);
                        visited.add(next);
                    }
                }
                // 원래 문자로 복원하여 다음 위치의 탐색에 대비한다
                ch[j] = orig;
            }
        }
        // 프론티어를 다음 레벨로 교체하고 level을 1 증가시켜 다음 이터레이션으로 진행한다
        start = nextLevel;
        level++;
    }
    // 어느 한쪽 프론티어가 비면 변환 시퀀스는 존재하지 않는다
    return 0;
}
```
