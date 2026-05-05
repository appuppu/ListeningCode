# Deep Copying a Linked List With Random Pointers — Criar uma cópia completa de uma lista encadeada com ponteiros aleatórios

## Essência do problema

É fornecida uma lista encadeada onde cada nó possui, além do ponteiro `next`, um ponteiro `random` que aponta para qualquer nó da lista (ou null). O objetivo é criar e retornar um **deep copy** (uma cópia completamente independente) dessa lista encadeada. O ponteiro `random` dos nós copiados deve apontar para os nós correspondentes na lista copiada, e não para os nós da lista original.

## Ideia central

Se inserirmos os nós copiados imediatamente após os nós originais (intercalação), o "próximo nó" do `random` de cada nó original se torna o nó correspondente no lado da cópia. Utilizando essa relação estrutural, é possível configurar corretamente os ponteiros aleatórios em espaço O(1), sem usar um HashMap.

## Processo de raciocínio

1. **A dificuldade está no mapeamento do ponteiro random**: Se houvesse apenas o ponteiro `next`, bastaria copiar os nós em ordem sequencial. Porém, como `random` aponta para qualquer nó, é necessário um meio de conhecer a correspondência entre os nós originais e os nós copiados
2. **Com HashMap resolve-se em espaço O(n), mas será possível em O(1)?**: Armazenar a correspondência nó original → nó copiado em um HashMap resolve o problema, mas pensamos se é possível expressar essa correspondência usando a própria estrutura da lista, sem estruturas de dados adicionais
3. **Inserir o nó copiado imediatamente após o nó original**: Ao inserir a cópia A' logo após o nó original A, obtém-se uma estrutura intercalada `A → A' → B → B' → C → C'`. Dessa forma, para qualquer nó original `X`, `X.next` é sempre a cópia `X'`, ou seja, a correspondência fica embutida na própria estrutura da lista
4. **Configurar os ponteiros random usando a estrutura intercalada**: Quando o `random` do nó original `curr` aponta para outro nó original `R`, o `random` do nó copiado `curr.next` deve ser configurado para a cópia de `R`, ou seja, `R.next`. Assim, a expressão `curr.next.random = curr.random.next` configura tudo de uma vez
5. **Separar as duas listas**: Após configurar os ponteiros random, extraímos alternadamente os nós originais e os nós copiados da lista intercalada para separá-los. A lista original também precisa ser restaurada ao seu estado inicial
6. **Conclusão em 3 passagens**: A 1ª passagem insere os nós copiados, a 2ª configura os ponteiros random, e a 3ª separa as listas. Cada passagem é O(n) e, como não utiliza estruturas de dados adicionais, o espaço é O(1)

## Conhecimentos prévios

### Estrutura do nó de uma lista encadeada (com random)

Um nó especial que, além do `next` de uma lista encadeada convencional, possui um ponteiro `random` que aponta para qualquer nó da lista. O `random` também pode ser `null`.

```java
class Node {
    int val;
    Node next;      // Aponta para o próximo nó (lista encadeada convencional)
    Node random;    // Aponta para qualquer nó da lista ou null

    Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
```

### O que é deep copy

É criar uma cópia completamente independente do objeto original. Os nós copiados não devem referenciar nenhum nó da lista original. Todos os ponteiros (`next` e `random`) devem apontar exclusivamente para nós dentro da lista copiada.

```java
// Shallow copy (incorreto): copy.random aponta para um nó da lista original
copy.random = original.random;

// Deep copy (correto): copy.random aponta para o nó correspondente na lista copiada
copy.random = originalToCopyMapping(original.random);
```

### O que é intercalação (interleaving)

É dispor alternadamente os elementos de duas sequências. Neste problema, inserimos nós copiados entre os nós da lista original, criando a estrutura `A → A' → B → B' → C → C'`. Com isso, a cópia do nó original `X` é sempre acessível através de `X.next`.

```java
// Lista original:       A → B → C → null
// Após intercalação:    A → A' → B → B' → C → C' → null
// A cópia de A é acessível via A.next, a cópia de B via B.next
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Percorre a lista 3 vezes. Cada passagem é O(n), portanto o total é O(3n) = O(n) |
| Space | O(1) — Não utiliza estruturas de dados adicionais além dos nós copiados para a saída |

## Código

```java
// Entrada: nó cabeça head de uma lista encadeada com ponteiros random
// Saída: retorna o nó cabeça do deep copy da lista de entrada
public Node copyRandomList(Node head) {
    // Uma lista vazia não tem nada para copiar
    if (head == null) return null;

    // === 1ª passagem: inserir um nó copiado imediatamente após cada nó original ===
    // Ao final desta passagem, a estrutura intercalada A → A' → B → B' → C → C' é formada
    Node curr = head;
    while (curr != null) {
        // Criar um novo nó copiado com o mesmo valor do nó original
        Node copy = new Node(curr.val);
        copy.next = curr.next;       // Configurar o next da cópia para o próximo do original
        curr.next = copy;            // Configurar o next do original para a cópia, inserindo-a logo após curr
        curr = copy.next;            // copy.next é o próximo nó original. Avançar para o próximo nó original
    }

    // === 2ª passagem: configurar os ponteiros random utilizando a estrutura intercalada ===
    curr = head;
    while (curr != null) {
        // curr.next é o nó copiado, curr.random.next é o nó copiado do destino random
        // Se curr.random for null, o random da cópia permanece null
        curr.next.random =
            curr.random != null
            ? curr.random.next : null;
        curr = curr.next.next;       // Pular o nó copiado e avançar para o próximo nó original
    }

    // === 3ª passagem: separar a lista intercalada em lista original e lista copiada ===
    // A lista original também precisa ser restaurada ao seu estado inicial
    curr = head;
    Node copyHead = head.next;       // Salvar a cabeça da lista copiada. Este será o valor de retorno final
    while (curr != null) {
        Node copy = curr.next;       // Obter o nó copiado
        curr.next = copy.next;       // Restaurar o next da lista original (pular a cópia e apontar para o próximo nó original)
        copy.next = copy.next != null
            ? copy.next.next : null;  // Conectar o next da lista copiada (pular o nó original e apontar para a próxima cópia)
        curr = curr.next;            // Avançar para o próximo nó original restaurado
    }

    // copyHead é a cabeça da lista que foi deep copied
    return copyHead;
}
```
