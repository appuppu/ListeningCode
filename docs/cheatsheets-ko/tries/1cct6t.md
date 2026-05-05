# Implementing a Prefix Tree — 주어진 문자열의 삽입·완전 일치 검색·접두사 검색을 효율적으로 수행하는 데이터 구조를 설계한다

## 문제의 본질

Trie(접두사 트리)라는 데이터 구조를 설계·구현한다. 이 데이터 구조는 세 가지 연산을 지원해야 한다: (1) `insert(word)`로 단어를 삽입한다, (2) `search(word)`로 완전히 일치하는 단어가 존재하는지를 판정한다, (3) `startsWith(prefix)`로 삽입된 단어 중에 지정된 접두사로 시작하는 단어가 있는지를 판정한다.

## 핵심 아이디어

문자열을 한 글자씩 노드로 분해하여 트리 구조로 만들면, 공통 접두사를 가진 단어들이 노드를 공유한다. 각 노드에 "여기서 단어가 끝나는지"를 나타내는 플래그를 두면, 완전 일치 검색과 접두사 검색의 차이는 탐색 종료 시에 그 플래그를 확인하느냐 하지 않느냐의 차이뿐이다.

## 사고 과정

1. **문자열을 한 글자씩 트리 구조로 전개한다**: 삽입할 단어를 한 글자씩 노드로 표현하고, 부모-자식 관계로 글자의 순서를 나타낸다. 이렇게 하면 "apple"과 "app"처럼 공통 접두사를 가진 단어는 앞쪽 3개의 노드(a→p→p)를 공유할 수 있다
2. **각 노드의 자식 노드를 HashMap으로 관리한다**: 각 노드는 다음에 오는 글자에 대응하는 자식 노드를 가진다. 자식 노드의 관리에는 HashMap을 사용하며, 키에 "글자", 값에 "자식 노드에 대한 참조"를 저장한다. 이렇게 하면 임의의 글자로의 전이를 O(1)로 수행할 수 있다
3. **단어의 끝을 구별하는 플래그가 필요하다**: "apple"을 삽입한 후 "app"을 검색하면, a→p→p로 노드를 따라갈 수 있다. 그러나 "app"은 삽입되지 않았으므로 false를 반환해야 한다. 각 노드에 `isEnd` 플래그를 두고, `insert` 시에 마지막 노드에서 `isEnd = true`로 설정하면 단어의 끝을 구별할 수 있다
4. **세 가지 연산은 모두 노드 순회가 기본이다**: `insert`·`search`·`startsWith`는 모두 루트에서 시작하여 문자열을 한 글자씩 따라가며 노드를 전이한다. `insert`는 전이할 대상이 존재하지 않으면 새로운 노드를 생성한다. `search`와 `startsWith`는 전이할 대상이 존재하지 않으면 즉시 false를 반환한다
5. **search와 startsWith의 차이는 isEnd 확인뿐이다**: `search`는 모든 글자를 따라간 후에 `node.isEnd`가 true인지를 확인한다. `startsWith`는 모든 글자를 따라가기만 하면 true를 반환한다. 순회 로직은 동일하며, 마지막 판정만 다르다
6. **루트 노드는 더미 노드이다**: Trie의 시작점인 루트 노드는 글자를 갖지 않는 빈 노드로 초기화한다. 모든 연산은 이 루트 노드에서 순회를 시작한다

## 전제 지식

### Trie(트라이)란

문자열을 효율적으로 저장·검색하기 위한 트리 구조이다. 각 노드가 하나의 글자에 대응하며, 루트에서 리프까지의 경로가 하나의 문자열을 나타낸다. 공통 접두사를 가진 문자열은 노드를 공유하므로, 접두사 검색에 강점을 가진 데이터 구조이다.

```
예: "app", "apple", "bat"을 삽입한 경우의 트리 구조

      root
      / \
     a   b
     |   |
     p   a
     |   |
     p*  t*
     |
     l
     |
     e*

*는 isEnd = true인 노드(단어의 끝)
```

### HashMap이란

키와 값의 쌍을 저장하는 데이터 구조이다. 키를 지정하여 값을 검색·취득하는 것을 O(1)로 수행할 수 있다. Trie에서는 각 노드의 자식 노드를 관리하기 위해 사용한다.

```java
HashMap<Character, TrieNode> children = new HashMap<>();  // 빈 HashMap을 생성한다
children.put('a', new TrieNode());      // 키 'a'에 새로운 노드를 저장한다
children.containsKey('a');              // 키 'a'가 존재하는지를 boolean으로 반환한다 → true
children.get('a');                      // 키 'a'에 대응하는 노드를 반환한다
children.putIfAbsent('a', new TrieNode());  // 키 'a'가 미등록인 경우에만 저장한다
```

### putIfAbsent란

HashMap의 메서드로, 지정한 키가 아직 존재하지 않는 경우에만 값을 저장한다. 키가 이미 존재하는 경우에는 아무 작업도 하지 않는다. `insert` 연산에서 기존 경로를 훼손하지 않고 새로운 노드만 추가하기 위해 사용한다.

```java
map.putIfAbsent('a', new TrieNode());  // 'a'가 미등록이면 새로운 노드를 등록한다
map.putIfAbsent('a', new TrieNode());  // 'a'는 이미 등록되어 있으므로 아무 작업도 하지 않는다
```

## 계산량

| | 값 |
|---|---|
| Time | O(m) — insert·search·startsWith 모두 문자열의 길이 m에 비례하여 한 번만 순회한다 |
| Space | O(n * m) — n개의 단어(평균 길이 m)를 저장한다. 공통 접두사가 노드를 공유하므로 실제 사용량은 이보다 적어진다 |

## 코드

```java
// 입력: insert(word)는 문자열 word, search(word)는 문자열 word, startsWith(prefix)는 문자열 prefix
// 출력: insert는 반환값 없음(Trie에 단어를 추가한다), search는 완전히 일치하는 단어가 존재하는지를 boolean으로 반환한다, startsWith는 접두사에 일치하는 단어가 존재하는지를 boolean으로 반환한다

// TrieNode 클래스: Trie의 각 노드를 나타낸다
class TrieNode {
    // 자식 노드에 대한 매핑. 키=글자, 값=대응하는 자식 노드
    Map<Character, TrieNode> children;
    // 이 노드에서 단어가 끝나는지를 나타내는 플래그(초기값은 false)
    // 이 플래그가 있으므로 search가 완전 일치와 접두사 일치를 구별할 수 있다
    boolean isEnd;

    TrieNode() {
        children = new HashMap<>();
        isEnd = false;
    }
}

class Trie {
    // 모든 연산의 시작점이 되는 루트 노드(글자를 갖지 않는 빈 더미 노드)
    private TrieNode root;

    // 생성자에서 빈 TrieNode를 루트로 생성한다
    public Trie() {
        root = new TrieNode();
    }

    public void insert(String word) {
        // node는 현재 순회 위치를 나타내는 포인터이다. 루트에서 순회를 시작한다
        TrieNode node = root;
        // 문자열 word를 앞에서부터 한 글자씩 순회한다
        for (char c : word.toCharArray()) {
            // putIfAbsent로 자식 노드가 존재하지 않으면 새로 생성하고, 이미 존재하면 아무 작업도 하지 않는다
            // putIfAbsent를 사용하면 기존 경로(다른 단어가 공유하는 노드)를 덮어쓰지 않을 수 있다
            node.children.putIfAbsent(c, new TrieNode());
            // 포인터를 글자 c에 대응하는 자식 노드로 이동한다
            node = node.children.get(c);
        }
        // 마지막 노드에 단어의 끝 플래그를 설정한다
        // 이 플래그로 인해 search에서 "apple" 삽입 완료·"app" 미삽입을 구별할 수 있다
        node.isEnd = true;
    }

    public boolean search(String word) {
        // 루트에서 순회를 시작한다
        TrieNode node = root;
        // 문자열 word를 앞에서부터 한 글자씩 순회한다
        for (char c : word.toCharArray()) {
            // 대응하는 자식 노드가 존재하지 않으면, 이 글자에 대응하는 경로가 Trie에 없으므로 즉시 false를 반환한다
            if (!node.children.containsKey(c))
                return false;
            // 포인터를 자식 노드로 이동한다
            node = node.children.get(c);
        }
        // 모든 글자를 따라간 노드가 단어의 끝이면 true, 그렇지 않으면 false를 반환한다
        // 이로 인해 "apple"이 삽입되어 있고 "app"이 미삽입일 때, search("app")는 올바르게 false를 반환한다
        return node.isEnd;
    }

    public boolean startsWith(String prefix) {
        // 루트에서 순회를 시작한다
        TrieNode node = root;
        // 문자열 prefix를 앞에서부터 한 글자씩 순회한다
        for (char c : prefix.toCharArray()) {
            // 대응하는 자식 노드가 존재하지 않으면, 이 접두사에 대응하는 경로가 Trie에 없으므로 즉시 false를 반환한다
            if (!node.children.containsKey(c))
                return false;
            // 포인터를 자식 노드로 이동한다
            node = node.children.get(c);
        }
        // 모든 글자를 따라갈 수 있었으므로, 이 접두사로 시작하는 단어가 Trie에 존재한다
        // search와의 차이는 isEnd를 확인하지 않는다는 점뿐이다
        return true;
    }
}
```
