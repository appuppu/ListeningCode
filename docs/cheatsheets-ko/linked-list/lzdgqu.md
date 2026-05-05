# Deep Copying a Linked List With Random Pointers — 랜덤 포인터가 있는 연결 리스트의 완전한 복제를 만들기

## 문제의 본질

각 노드가 `next` 포인터에 더하여, 리스트 내의 임의의 노드(또는 null)를 가리키는 `random` 포인터를 가진 연결 리스트가 주어진다. 이 연결 리스트의 **딥 카피**(완전히 독립된 복제)를 생성하여 반환한다. 복사된 노드의 `random`은 원본 리스트가 아니라 복사된 리스트 내의 대응하는 노드를 가리켜야 한다.

## 핵심 아이디어

복사한 노드를 원본 노드의 바로 뒤에 삽입(인터리브)하면, 원본 노드의 `random`의 "다음 노드"가 복사 측의 대응 노드가 된다. 이 구조적 관계를 이용하면, HashMap 없이 O(1) 공간으로 랜덤 포인터를 올바르게 설정할 수 있다.

## 사고 과정

1. **어려운 부분은 random 포인터의 대응 관계 설정이다**: `next` 포인터만 있다면 단순히 순서대로 복사하면 되지만, `random`은 임의의 노드를 가리키기 때문에 원본 노드와 복사 노드의 대응 관계를 알 수 있는 수단이 필요하다
2. **HashMap을 사용하면 O(n) 공간으로 풀 수 있지만, O(1)로 줄일 수 없는가**: 원본 노드→복사 노드의 대응을 HashMap에 저장하면 풀 수 있지만, 추가적인 데이터 구조를 사용하지 않고 리스트 자체의 구조로 대응 관계를 표현할 수 없는지를 생각한다
3. **복사 노드를 원본 노드의 바로 뒤에 삽입한다**: 원본 노드 A의 바로 뒤에 복사본 A'를 삽입하면, `A → A' → B → B' → C → C'`라는 인터리브 구조가 된다. 이렇게 하면 임의의 원본 노드 `X`에 대해 `X.next`가 반드시 복사본 `X'`이 되는 대응 관계가 리스트 구조 자체에 내장된다
4. **random 포인터를 인터리브 구조로 설정한다**: 원본 노드 `curr`의 `random`이 다른 원본 노드 `R`을 가리키고 있을 때, 복사 노드 `curr.next`의 `random`은 `R`의 복사본, 즉 `R.next`로 설정하면 된다. 즉 `curr.next.random = curr.random.next`라는 식으로 일괄 설정할 수 있다
5. **두 리스트를 분리한다**: random 포인터 설정 후, 인터리브된 리스트에서 원본 리스트와 복사 리스트를 교대로 꺼내어 분리한다. 원본 리스트도 원래대로 복원해야 한다
6. **3번의 패스로 완료한다**: 제1패스에서 복사 노드를 삽입하고, 제2패스에서 random 포인터를 설정하고, 제3패스에서 리스트를 분리한다. 각 패스는 O(n)이며, 추가적인 데이터 구조를 사용하지 않으므로 Space O(1)이 된다

## 전제 지식

### 연결 리스트의 노드 구조 (random 포함)

일반적인 연결 리스트의 `next`에 더하여, 리스트 내의 임의의 노드를 가리키는 `random` 포인터를 가진 특수한 노드이다. `random`은 `null`인 경우도 있다.

```java
class Node {
    int val;
    Node next;      // 다음 노드를 가리킨다 (일반적인 연결 리스트)
    Node random;    // 리스트 내의 임의의 노드 또는 null을 가리킨다

    Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
```

### 딥 카피란

원본 객체와 완전히 독립된 복제를 만드는 것이다. 복사된 노드가 원본 리스트의 노드를 참조해서는 안 된다. 모든 포인터(`next`와 `random`)가 복사된 리스트 내의 노드만을 가리켜야 한다.

```java
// 얕은 복사 (NG): copy.random이 원본 리스트의 노드를 가리켜 버린다
copy.random = original.random;

// 딥 카피 (OK): copy.random이 복사된 리스트의 대응 노드를 가리킨다
copy.random = originalToCopyMapping(original.random);
```

### 인터리브(교차 배치)란

두 열의 요소를 교대로 나열하는 것이다. 이 문제에서는 원본 리스트의 노드 사이에 복사 노드를 삽입하여, `A → A' → B → B' → C → C'`라는 구조를 만든다. 이를 통해 원본 노드 `X`의 복사본은 항상 `X.next`로 접근할 수 있다.

```java
// 원본 리스트:       A → B → C → null
// 인터리브 후:       A → A' → B → B' → C → C' → null
// A의 복사본은 A.next, B의 복사본은 B.next로 접근 가능
```

## 계산량

| | 값 |
|---|---|
| Time | O(n) — 리스트를 3회 순회한다. 각 패스는 O(n)이므로 합계 O(3n) = O(n) |
| Space | O(1) — 출력용 복사 노드 이외에 추가적인 데이터 구조를 사용하지 않는다 |

## 코드

```java
// 입력: random 포인터가 있는 연결 리스트의 선두 노드 head
// 출력: 입력 리스트의 딥 카피의 선두 노드를 반환한다
public Node copyRandomList(Node head) {
    // 빈 리스트에는 복사할 것이 없다
    if (head == null) return null;

    // === 제1패스: 각 원본 노드의 바로 뒤에 복사 노드를 삽입한다 ===
    // 이 패스가 끝나면 A → A' → B → B' → C → C'라는 인터리브 구조가 된다
    Node curr = head;
    while (curr != null) {
        // 원본 노드와 같은 값을 가진 새로운 복사 노드를 생성한다
        Node copy = new Node(curr.val);
        copy.next = curr.next;       // 복사본의 next를 원본의 next로 설정한다
        curr.next = copy;            // 원본의 next를 복사본으로 설정하여, curr의 바로 뒤에 삽입한다
        curr = copy.next;            // copy.next는 원본의 다음 노드이다. 다음 원본 노드로 진행한다
    }

    // === 제2패스: 인터리브 구조를 이용하여 random 포인터를 설정한다 ===
    curr = head;
    while (curr != null) {
        // curr.next는 복사 노드이고, curr.random.next는 random 대상의 복사 노드이다
        // curr.random이 null인 경우에는 복사본의 random도 null 그대로 둔다
        curr.next.random =
            curr.random != null
            ? curr.random.next : null;
        curr = curr.next.next;       // 복사 노드를 건너뛰고 다음 원본 노드로 진행한다
    }

    // === 제3패스: 인터리브된 리스트를 원본 리스트와 복사 리스트로 분리한다 ===
    // 원본 리스트도 원래대로 복원해야 한다
    curr = head;
    Node copyHead = head.next;       // 복사 리스트의 선두를 저장한다. 이것이 최종 반환값이 된다
    while (curr != null) {
        Node copy = curr.next;       // 복사 노드를 가져온다
        curr.next = copy.next;       // 원본 리스트의 next를 복원한다 (복사본을 건너뛰고 원본의 다음 노드로)
        copy.next = copy.next != null
            ? copy.next.next : null;  // 복사 리스트의 next를 연결한다 (원본 노드를 건너뛰고 복사본의 다음으로)
        curr = curr.next;            // 복원한 원본의 다음 노드로 진행한다
    }

    // copyHead가 딥 카피된 리스트의 선두이다
    return copyHead;
}
```
