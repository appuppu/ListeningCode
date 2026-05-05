# Serializing and Deserializing a Binary Tree — 이진 트리를 문자열로 변환하고 원래의 트리 구조로 복원하기

## 문제의 본질

이진 트리를 문자열로 직렬화(시리얼라이즈)하고, 그 문자열로부터 원래의 이진 트리를 역직렬화(디시리얼라이즈)하는 알고리즘을 설계한다. 라운드트립은 무손실이어야 한다 — 복원된 트리는 원래의 트리와 완전히 동일해야 한다.

## 핵심 아이디어

Preorder(전위) 순회로 트리를 직렬화하면, 각 노드의 「왼쪽 자식 → 오른쪽 자식」이라는 구조가 재귀적으로 기록된다. null을 센티넬 값으로 명시적으로 기록해 두면, 역직렬화 시에 토큰을 앞에서부터 순서대로 소비하는 것만으로 재귀적으로 원래의 트리 구조를 유일하게 복원할 수 있다.

## 사고 프로세스

1. **트리 구조를 유일하게 복원하려면 무엇이 필요한가**: 이진 트리의 구조를 유일하게 결정하려면, 각 노드의 자식이 존재하는지 여부에 대한 정보가 필요하다. null의 위치를 명시적으로 기록하면, 하나의 순회 순서만으로 트리 구조를 유일하게 재현할 수 있다
2. **Preorder 순회가 적합한 이유**: Preorder는 「루트 → 왼쪽 서브트리 → 오른쪽 서브트리」의 순서로 방문한다. 루트가 가장 먼저 오기 때문에, 역직렬화 시에 토큰을 앞에서부터 소비하면서 재귀적으로 노드를 생성할 수 있다. 순회 순서와 노드 생성 순서가 일치하므로 구현이 자연스러워진다
3. **null을 센티넬 값으로 기록한다**: 노드가 null인 경우에 `"null"`이라는 문자열을 기록한다. 이렇게 함으로써, 역직렬화 시에 「여기서 서브트리가 끝난다」는 경계를 판정할 수 있다. 센티넬이 없으면 서브트리의 종단을 특정할 수 없다
4. **직렬화의 형식**: 각 노드의 값을 쉼표 구분으로 연결한다. 형식은 `"1,2,null,null,3,4,null,null,5,null,null"`과 같이 된다. 쉼표로 split하면 토큰 배열을 얻을 수 있다
5. **역직렬화는 재귀로 토큰을 소비한다**: 토큰 리스트를 앞에서부터 하나씩 poll(추출)한다. 추출한 값이 `"null"`이면 null을 반환하고, 그 외에는 노드를 생성하여 왼쪽 자식과 오른쪽 자식을 재귀적으로 구축한다. LinkedList를 사용하면 앞에서부터의 poll이 O(1)로 가능하다
6. **재귀의 순서가 Preorder와 일치한다**: 직렬화 시의 Preorder 순서(루트 → 왼쪽 → 오른쪽)와 역직렬화 시의 재귀 호출 순서(노드 생성 → 왼쪽 자식 → 오른쪽 자식)가 완전히 일치하기 때문에, 토큰을 순서대로 소비하는 것만으로 올바른 트리가 복원된다

## 전제 지식

### Preorder(전위) 순회란

이진 트리를 「루트 → 왼쪽 서브트리 → 오른쪽 서브트리」의 순서로 재귀적으로 방문하는 순회 방법이다. 루트가 가장 먼저 처리되므로, 직렬화한 데이터의 선두가 항상 루트 노드가 된다.

```java
void preorder(TreeNode node) {
    if (node == null) return;
    visit(node);           // 먼저 루트를 처리한다
    preorder(node.left);   // 다음으로 왼쪽 서브트리를 재귀적으로 처리한다
    preorder(node.right);  // 마지막으로 오른쪽 서브트리를 재귀적으로 처리한다
}
```

### StringBuilder란

문자열을 효율적으로 연결하기 위한 클래스이다. `+` 연산자에 의한 문자열 연결은 매번 새로운 String 객체를 생성하므로 O(n²)이 되지만, StringBuilder는 내부 버퍼에 추가 기록하므로 O(n)으로 처리할 수 있다.

```java
StringBuilder sb = new StringBuilder();  // 빈 StringBuilder를 생성한다
sb.append("hello");                      // 끝에 문자열을 추가한다
sb.append(",");                          // 쉼표를 추가한다
sb.deleteCharAt(sb.length() - 1);        // 끝의 1문자를 삭제한다
sb.toString();                           // String으로 변환한다 → "hello"
```

### LinkedList와 poll 메서드

LinkedList는 리스트의 선두·끝에 대한 추가·삭제가 O(1)로 가능한 데이터 구조이다. `poll()` 메서드는 리스트의 선두 요소를 추출하여 반환한다(리스트에서 삭제된다). 비어 있는 경우에는 null을 반환한다.

```java
LinkedList<String> tokens = new LinkedList<>(Arrays.asList("1", "2", "null"));
tokens.poll();  // "1"을 반환하고, 리스트에서 삭제한다. 나머지: ["2", "null"]
tokens.poll();  // "2"를 반환하고, 리스트에서 삭제한다. 나머지: ["null"]
```

### 센티넬 값이란

데이터의 종단이나 특수한 상태를 나타내기 위해 사용하는 특별한 값이다. 이 문제에서는 문자열 `"null"`을 센티넬로 사용하여, 「이 위치에 자식 노드가 존재하지 않는다」는 것을 표현한다. 센티넬이 있기 때문에, 역직렬화 시에 서브트리의 경계를 정확하게 판정할 수 있다.

## 계산량

| | 값 |
|---|---|
| Time | O(n) — 전체 n개의 노드를 1회씩 방문한다 |
| Space | O(n) — 직렬화 문자열과 토큰 리스트에 n개분의 영역을 사용한다. 재귀의 콜 스택은 최악 O(n)이다(편향된 트리의 경우) |

## 코드

```java
// 입력: 직렬화 — 이진 트리의 루트 노드 root. 역직렬화 — 쉼표 구분 문자열 data
// 출력: 직렬화 — 트리를 표현하는 쉼표 구분 문자열. 역직렬화 — 원래의 이진 트리의 루트 노드

// 이진 트리를 문자열로 직렬화한다
public String serialize(TreeNode root) {
    // 트리의 모든 노드의 값을 쉼표 구분으로 축적하는 버퍼
    StringBuilder sb = new StringBuilder();
    // Preorder 순서로 트리를 순회하며, StringBuilder에 값을 추가한다
    serHelper(root, sb);
    // 끝의 불필요한 쉼표를 삭제한다
    if (sb.length() > 0)
        sb.deleteCharAt(sb.length() - 1);
    return sb.toString();
}

// Preorder 순서로 트리를 순회하며, 각 노드의 값을 StringBuilder에 추가한다
void serHelper(TreeNode node, StringBuilder sb) {
    // null 노드는 센티넬 값 "null"로 기록한다(역직렬화 시에 서브트리의 종단을 판정하기 위함)
    if (node == null) {
        sb.append("null,");
        return;
    }
    // 현재 노드의 값을 기록한다(Preorder이므로 루트를 가장 먼저 처리한다)
    // 각 값은 쉼표로 구분된 형식이 된다
    sb.append(node.val).append(",");
    // 왼쪽 서브트리를 재귀적으로 처리한다
    serHelper(node.left, sb);
    // 오른쪽 서브트리를 재귀적으로 처리한다(루트 → 왼쪽 → 오른쪽의 순서가 Preorder를 실현한다)
    serHelper(node.right, sb);
}

// 문자열로부터 이진 트리를 역직렬화한다
public TreeNode deserialize(String data) {
    // 빈 문자열은 빈 트리를 나타낸다
    if (data.isEmpty()) return null;
    // 쉼표로 분할하여 LinkedList로 변환한다(선두에서 O(1)로 추출하는 poll()이 필요하기 때문)
    LinkedList<String> tokens =
        new LinkedList<>(Arrays.asList(data.split(",")));
    // 토큰을 선두부터 순서대로 소비하면서 노드를 재귀적으로 생성한다
    return desHelper(tokens);
}

// 토큰을 선두부터 순서대로 소비하면서 노드를 재귀적으로 생성한다
TreeNode desHelper(LinkedList<String> tokens) {
    // 선두 토큰을 추출한다(poll은 리스트에서 요소를 삭제하므로, 다음 재귀에서는 다음 토큰이 선두가 된다)
    String val = tokens.poll();
    // 센티넬 값이면 null을 반환하여 재귀를 종료한다(부모 노드의 자식이 null로 설정된다)
    if (val.equals("null")) return null;
    // 토큰의 값을 정수로 변환하고, 새로운 노드를 생성한다
    TreeNode node = new TreeNode(Integer.parseInt(val));
    // Preorder 순서에 따라, 왼쪽 자식을 먼저 구축한다(직렬화 시의 순서와 일치하므로 올바른 토큰이 대응된다)
    node.left = desHelper(tokens);
    // 다음으로 오른쪽 자식을 구축한다
    node.right = desHelper(tokens);
    // 구축한 노드를 반환한다(최초 호출의 반환값이 루트 노드 = 복원된 트리 전체)
    return node;
}
```
