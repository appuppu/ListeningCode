# Reversing a Linked List — Inverter uma lista ligada unidirecional

## Essência do problema

Um nó inicial `head` de uma lista ligada unidirecional (singly linked list) é fornecido. O objetivo é inverter a direção de todos os links (ponteiros) na lista, de modo que o nó final original se torne o novo nó inicial, e retornar esse novo nó inicial.

## Ideia central

Se o ponteiro `next` de cada nó for redirecionado do "próximo nó" para o "nó anterior", a lista inteira será invertida. Utilizando três ponteiros (prev, curr, next), é possível completar a inversão com uma única travessia, redirecionando os links um a um de forma segura.

## Processo de raciocínio

1. **Inverter significa reverter a direção dos links**: A ordem de uma lista ligada é determinada pelos ponteiros `next` dos nós. Se o `next` de todos os nós for alterado do "próximo nó" para o "nó anterior", a lista inteira será invertida
2. **Redirecionar um link faz perder a referência ao próximo nó**: No momento em que se escreve `curr.next = prev`, a referência ao próximo nó original desaparece. Por isso, é necessário salvar `curr.next` em uma variável separada `next` antes de realizar a alteração
3. **Gerenciar o estado com três ponteiros**: Com `prev` (o nó anterior que será o destino do redirecionamento), `curr` (o nó sendo processado atualmente) e `next` (backup do próximo nó original), é possível realizar o redirecionamento dos links e a travessia simultaneamente
4. **Definir o estado inicial**: Como o `next` do nó final da lista invertida (o nó inicial original) deve ser `null`, o valor inicial de `prev` é `null`. O valor inicial de `curr` é `head` (o nó inicial)
5. **Condição de término do loop e valor de retorno**: Quando `curr` se torna `null`, o processamento de todos os nós está concluído. Nesse momento, `prev` aponta para o último nó processado (o nó final original), portanto `prev` é retornado como o novo nó inicial

## Conhecimentos prévios

### O que é um ListNode (nó de uma lista ligada)

É o elemento que compõe uma lista ligada. Cada nó possui um "valor (val)" e um "ponteiro para o próximo nó (next)". O `next` do último nó é `null`.

```java
class ListNode {
    int val;          // Valor armazenado no nó
    ListNode next;    // Referência ao próximo nó (null se for o último)

    ListNode(int val) {
        this.val = val;
        this.next = null;
    }
}
```

### O que é redirecionamento de ponteiro

É a alteração da direção de um link atribuindo um nó diferente ao campo `next` de um nó.

```java
// Estado original: A → B → C
// A.next aponta para B

A.next = null;   // A → null (o link entre A e B é cortado)
B.next = A;      // B → A (um link reverso de B para A é criado)
// Resultado: C → null, B → A → null
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Apenas uma travessia da lista é necessária |
| Space | O(1) — Utiliza apenas três variáveis de ponteiro, sem necessidade de estruturas de dados adicionais |

## Código

```java
// Entrada: nó inicial head de uma lista ligada unidirecional
// Saída: retorna o novo nó inicial (ListNode) da lista invertida
ListNode reverseList(ListNode head) {
    // prev: destino do redirecionamento do link (o "nó anterior" após a inversão)
    // O primeiro nó (inicial original) se tornará o último após a inversão, então seu next deve ser null. Por isso, o valor inicial é null
    ListNode prev = null;
    // curr: o nó cujo link será redirecionado. O processamento começa a partir do nó inicial
    ListNode curr = head;

    // Quando curr se torna null, o processamento de todos os nós está concluído
    while (curr != null) {
        // Salvar o próximo nó original (para não perder a referência quando curr.next for sobrescrito no próximo passo)
        ListNode next = curr.next;

        // Inverter o link: fazer o nó apontar para o nó anterior em vez do próximo. Esta é a operação principal de inversão
        curr.next = prev;

        // Avançar prev para o nó atual (será usado como destino do redirecionamento do próximo nó na próxima iteração)
        prev = curr;
        // Avançar curr para o próximo nó original salvo anteriormente (isso permite continuar a travessia da lista)
        curr = next;
    }

    // Na última iteração do loop, prev recebeu o último nó processado (o nó final original)
    // Este é o novo nó inicial da lista invertida
    return prev;
}
```
