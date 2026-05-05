# Adding Two Numbers Represented as Linked Lists — Somar dois números representados como listas ligadas em ordem inversa

## Essência do problema

São dadas duas listas ligadas não vazias. Cada lista ligada representa um número inteiro não negativo em **ordem inversa** (o dígito das unidades está no início), e cada nó armazena um único dígito. O objetivo é somar os dois números e retornar o resultado como uma **lista ligada em ordem inversa**.

## Ideia central

Como as listas ligadas estão armazenadas em ordem inversa (o dígito das unidades está no início), ao somar sequencialmente a partir do nó inicial, a adição ocorre naturalmente na ordem unidades → dezenas → centenas…, exatamente como na adição manual. Basta manter o vai-um (carry) em uma variável e conectar o resultado de cada dígito como um novo nó.

## Processo de raciocínio

1. **A ordem inversa é uma vantagem**: A adição numérica começa pelo dígito das unidades. Como a lista ligada está em ordem inversa, processar a partir do nó inicial permite somar naturalmente desde as unidades. Não é necessário inverter a ordem dos dígitos
2. **Gerenciar a adição de cada dígito e o vai-um**: Para cada dígito, calcula-se `valor de l1 + valor de l2 + carry`. Se a soma for 10 ou mais, ocorre um vai-um. `sum % 10` é o resultado desse dígito e `sum / 10` é o vai-um para o próximo dígito. Esta é exatamente a regra da adição manual
3. **Tratar listas com comprimentos diferentes**: Mesmo que uma lista termine primeiro, o processamento deve continuar enquanto a outra lista ou o carry restante existirem. Ao definir a condição do while como `l1 != null || l2 != null || carry != 0`, todos os casos são tratados de forma unificada
4. **Usar um nó cabeça fictício para simplificar a construção da lista resultado**: Para não tratar o primeiro nó da lista resultado como caso especial, coloca-se um nó fictício com valor 0 no início. Todos os resultados dos dígitos são adicionados em `curr.next`, e ao final retorna-se `dummy.next` para obter a lista resultado correta
5. **Unificar o processamento dentro do loop**: Em cada iteração, se `l1` e `l2` não forem null, seus valores são adicionados à soma e os ponteiros avançam. Se forem null, nada é feito. Esta ramificação condicional absorve naturalmente a diferença de comprimento entre as listas
6. **O que retornar no final**: O nó seguinte ao nó cabeça fictício, `dummy.next`, é o início da lista resultado. Este é o valor retornado

## Conhecimentos prévios

### O que é ListNode

Uma classe que representa um nó de uma lista ligada unidirecional. Cada nó possui um valor inteiro `val` e uma referência `next` para o próximo nó. O nó cujo `next` é `null` é o último da lista.

```java
public class ListNode {
    int val;              // Valor numérico de um dígito armazenado neste nó
    ListNode next;        // Referência para o próximo nó (null se for o último)
    ListNode(int val) {   // Construtor: cria um nó com o valor especificado
        this.val = val;
    }
}
```

### O que é Nó Cabeça Fictício (Dummy Head)

Um nó fictício sem valor colocado no início da lista. É uma técnica que evita tratar o primeiro nó como caso especial ao construir a lista resultado. Todos os nós são adicionados uniformemente com `curr.next = new ListNode(...)`, e ao final retorna-se `dummy.next` para obter o nó inicial real.

```java
ListNode dummy = new ListNode(0);  // Criar o nó cabeça fictício
ListNode curr = dummy;             // curr é o ponteiro que rastreia o final da lista
curr.next = new ListNode(5);       // Adicionar um nó com valor 5 após o nó fictício
curr = curr.next;                  // Avançar curr para o final
// dummy.next aponta para o início real da lista (nó com valor 5)
```

### O que é Vai-um (Carry)

O valor transferido para o próximo dígito quando a soma de dois dígitos é 10 ou mais. É calculado com `sum / 10` (a divisão inteira resulta em 0 ou 1). O valor que permanece no dígito atual é obtido com `sum % 10`.
Exemplo: 7 + 8 = 15, então carry = 15 / 10 = 1, valor do dígito atual = 15 % 10 = 5.

## Complexidade

| | Valor |
|---|---|
| Time | O(max(n, m)) — Percorre o comprimento da mais longa das duas listas |
| Space | O(max(n, m)) — O número de nós da lista resultado é no máximo max(n, m) + 1 |

## Código

```java
// Entrada: listas ligadas em ordem inversa l1 e l2 (cada nó é um inteiro não negativo de um dígito)
// Saída: retorna a soma dos dois números como uma lista ligada em ordem inversa
public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
    // Criar o nó cabeça fictício. Evita tratar o primeiro nó da lista resultado como caso especial
    // Não é incluído no resultado final; dummy.next será o início real
    ListNode dummy = new ListNode(0);
    // curr é o ponteiro que rastreia o final da lista resultado
    ListNode curr = dummy;
    // Variável que armazena o vai-um. Valor transferido para o próximo dígito quando a soma é 10 ou mais (0 ou 1)
    int carry = 0;

    // Continuar o loop enquanto alguma lista restar ou houver vai-um
    // A condição carry != 0 trata casos em que o número de dígitos aumenta, como 999 + 1 = 1000
    while (l1 != null || l2 != null || carry != 0) {
        // Calcular sum usando o vai-um do dígito anterior como valor inicial
        int sum = carry;

        // Se l1 ainda tiver nós, adicionar o valor à soma e avançar o ponteiro
        // Se for null, nada é feito. Isso permite que o processamento continue mesmo que l1 termine primeiro
        if (l1 != null) {
            sum += l1.val;
            l1 = l1.next;
        }

        // Se l2 ainda tiver nós, adicionar o valor à soma e avançar o ponteiro
        // Se for null, nada é feito. Isso permite que o processamento continue mesmo que l2 termine primeiro
        if (l2 != null) {
            sum += l2.val;
            l2 = l2.next;
        }

        // Calcular o vai-um. Se sum for 10 ou mais, será 1; se for menor que 10, será 0
        carry = sum / 10;
        // Criar um novo nó com o valor do dígito atual (sum % 10) e conectá-lo ao final da lista resultado
        curr.next = new ListNode(sum % 10);
        // Avançar curr para o final, permitindo adicionar um novo nó na próxima iteração
        curr = curr.next;
    }

    // O nó seguinte ao nó cabeça fictício é o início da lista resultado
    return dummy.next;
}
```
