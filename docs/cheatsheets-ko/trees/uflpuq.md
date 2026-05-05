# Checking if a Tree is a Subtree of Another — 다른 트리가 부분 트리로 포함되어 있는지를 판정하기

## 문제의 본질

2개의 이진 트리 `root`와 `subRoot`가 주어진다. `root` 안에 `subRoot`와 구조 및 값이 모두 완전히 일치하는 부분 트리가 존재하는지를 `boolean`으로 반환한다. 부분 트리란, `root`의 특정 노드를 루트로 했을 때, 그 노드 아래의 트리 전체가 `subRoot`와 동일한 것을 의미한다.

## 핵심 아이디어

트리를 null 마커가 포함된 전위 순회로 문자열에 직렬화하면, 부분 트리 판정은 "특정 문자열이 다른 문자열에 포함되는지"라는 문자열 검색 문제로 귀결할 수 있다.

## 사고 프로세스

1. **부분 트리의 일치 판정은 "트리 전체의 형태와 값의 비교"이다**: 부분 트리이기 위해서는, 특정 노드 이하의 구조와 모든 노드의 값이 완전히 일치해야 한다. 즉, 트리의 형상 정보를 보존한 상태에서 비교하는 방법이 필요하다
2. **트리를 고유하게 표현할 수 있으면 비교가 용이해진다**: 트리 구조 그대로는 비교 시 노드마다 재귀적 순회가 필요하다. 트리를 문자열로 직렬화하면, 구조와 값의 비교가 문자열 비교로 바뀌어 효율적으로 처리할 수 있다
3. **전위 순회(preorder)에 null 마커를 추가하여 고유성을 보장한다**: 전위 순회만으로는 서로 다른 트리가 동일한 문자열이 되는 경우가 있다. 자식이 null인 위치에 `#` 등의 마커를 삽입함으로써, 트리의 구조를 고유하게 인코딩할 수 있다
4. **각 노드의 값 앞에 쉼표 구분자를 붙인다**: 값의 경계를 명확하게 하기 위해, 각 노드의 값 앞에 쉼표 `,`를 추가한다. 이를 통해, 예를 들어 값 `2`와 `12`가 혼동되는 것을 방지한다
5. **부분 트리 판정은 문자열 포함 판정으로 귀결된다**: `root`를 직렬화한 문자열에 `subRoot`를 직렬화한 문자열이 부분 문자열로 포함되어 있으면, `subRoot`는 `root`의 부분 트리이다. Java의 `String.contains()`로 O(m+n)의 판정을 수행할 수 있다

## 전제 지식

### 이진 트리의 전위 순회(Preorder Traversal)란

트리의 노드를 "루트 → 왼쪽 자식 → 오른쪽 자식" 순서로 방문하는 순회 방법이다. 재귀로 구현하면, 먼저 현재 노드를 처리하고, 다음으로 왼쪽 부분 트리, 마지막으로 오른쪽 부분 트리를 재귀적으로 처리한다.

```java
void preorder(TreeNode node) {
    if (node == null) return;
    System.out.println(node.val);  // 루트를 처리한다
    preorder(node.left);           // 왼쪽 부분 트리를 재귀적으로 순회한다
    preorder(node.right);          // 오른쪽 부분 트리를 재귀적으로 순회한다
}
```

### StringBuilder란

문자열을 효율적으로 연결하기 위한 클래스이다. `String`의 `+` 연산자는 연결할 때마다 새로운 객체를 생성하지만, `StringBuilder`는 내부 버퍼에 추가하므로 O(1)로 추가할 수 있다.

```java
StringBuilder sb = new StringBuilder();  // 빈 StringBuilder를 생성한다
sb.append(",5");                         // 문자열 ",5"를 버퍼의 끝에 추가한다
sb.append(",#");                         // 문자열 ",#"를 버퍼의 끝에 추가한다
sb.toString();                           // 버퍼의 내용을 String 타입으로 변환한다 → ",5,#"
```

### String.contains()란

특정 문자열이 다른 문자열을 부분 문자열로 포함하고 있는지를 `boolean`으로 반환하는 메서드이다.

```java
String s = ",1,2,#,#,3,#,#";
s.contains(",2,#,#");    // s가 ",2,#,#"를 포함하는지를 판정한다 → true
s.contains(",4,#,#");    // s가 ",4,#,#"를 포함하는지를 판정한다 → false
```

### null 마커란

트리의 직렬화에서, 자식 노드가 존재하지 않는(null) 위치에 삽입하는 특수한 기호이다. `#`를 사용하는 경우가 많다. null 마커가 없으면, 서로 다른 구조의 트리가 동일한 순회 결과를 갖게 된다. 예를 들어, 왼쪽 자식만 가진 트리와 오른쪽 자식만 가진 트리를 구별하기 위해 null 마커가 필요하다.

## 계산량

| | 값 |
|---|---|
| Time | O(m + n) — root(노드 수 m)와 subRoot(노드 수 n)를 각각 1회 순회하여 직렬화하고, 문자열 포함 판정을 수행한다 |
| Space | O(m + n) — 2개 트리의 직렬화 결과를 StringBuilder에 저장한다 |

## 코드

```java
// 입력: 이진 트리의 루트 노드 root와 subRoot
// 출력: subRoot가 root의 부분 트리이면 true, 그렇지 않으면 false를 반환한다

// 트리를 전위 순회로 문자열에 직렬화하는 헬퍼 메서드
void serialize(TreeNode node, StringBuilder sb) {
    if (node == null) {
        // null 마커 ",#"를 추가하여 자식 노드가 존재하지 않음을 명시한다
        // 이를 통해 왼쪽 자식만 가진 트리와 오른쪽 자식만 가진 트리를 구별할 수 있다
        sb.append(",#");
        return;
    }
    // 값 앞에 쉼표를 붙여서 값 2와 12 같은 숫자의 경계가 모호해지지 않도록 한다
    sb.append("," + node.val);
    // 왼쪽 부분 트리를 재귀적으로 직렬화한다
    serialize(node.left, sb);
    // 오른쪽 부분 트리를 재귀적으로 직렬화한다
    serialize(node.right, sb);
}

boolean isSubtree(TreeNode root, TreeNode subRoot) {
    // sb1은 root의 직렬화 결과, sb2는 subRoot의 직렬화 결과를 저장한다
    StringBuilder sb1 = new StringBuilder();
    StringBuilder sb2 = new StringBuilder();

    // 두 트리를 전위 순회로 문자열에 직렬화한다
    serialize(root, sb1);
    serialize(subRoot, sb2);

    // root의 문자열이 subRoot의 문자열을 부분 문자열로 포함하고 있으면 부분 트리이다
    return sb1.toString().contains(sb2.toString());
}
```
