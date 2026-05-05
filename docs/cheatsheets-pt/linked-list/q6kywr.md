# Merging K Sorted Linked Lists — Unificar K Listas Ligadas Ordenadas em Uma Única Lista

## Essência do Problema

Um array de K listas ligadas (Linked Lists) ordenadas é fornecido. O objetivo é unificar todas essas listas em **uma única lista ligada ordenada** e retornar o nó inicial dessa lista. Cada lista já está individualmente ordenada, e a lista resultante da unificação também deve manter a ordem crescente.

## Ideia Central

Em vez de unificar as K listas de uma só vez, o algoritmo emparelha as listas duas a duas e repete o merge. Como o número de listas é reduzido pela metade a cada rodada, o processo converge em uma única lista após log k rodadas, alcançando uma eficiência de O(N log k) para todos os N elementos.

## Processo de Raciocínio

1. **A operação básica é "merge de duas listas ordenadas"**: O problema de unificar K listas pode ser decomposto em combinações da operação básica "fazer merge de duas listas ordenadas em uma". O merge de duas listas pode ser executado em O(n) comparando repetidamente os elementos iniciais e escolhendo o menor
2. **Como aplicar essa operação básica às K listas**: Se fizermos merge da primeira com a segunda lista, depois o resultado com a terceira, e assim por diante sequencialmente, a complexidade será O(Nk). Isso ocorre porque o resultado do merge cresce a cada etapa, tornando os merges posteriores cada vez mais custosos
3. **O merge em pares distribui o custo uniformemente**: Ao emparelhar as listas duas a duas para o merge, cada rodada processa todos os elementos apenas uma vez. Como o número de listas é reduzido pela metade a cada rodada, o número de rodadas é log k, alcançando O(N log k) no total
4. **Gerenciar os pares usando índices do array**: A variável `interval` é dobrada progressivamente como 1, 2, 4, 8…, e o merge de `lists[i]` com `lists[i + interval]` é armazenado em `lists[i]`. Dessa forma, o merge em pares é realizado in-place sem usar arrays adicionais
5. **Após todas as rodadas, lists[0] contém o resultado final**: A cada rodada, os resultados dos merges são consolidados nos índices pares `lists[0]`, `lists[2]`, `lists[4]`…, e no final todos os elementos são unificados em `lists[0]`

## Conhecimentos Prévios

### O que é um ListNode (nó de lista ligada)

Uma classe que representa cada elemento de uma lista ligada. O campo `val` armazena o valor e o campo `next` mantém a referência para o próximo nó. O nó cujo `next` é `null` representa o final da lista.

```java
class ListNode {
    int val;              // Valor armazenado neste nó
    ListNode next;        // Referência para o próximo nó (null se for o último)
    ListNode(int val) {   // Construtor: cria um nó com o valor especificado
        this.val = val;
    }
}
```

### O que é um Nó Dummy (Sentinel Node)

Uma técnica para simplificar a construção de listas. Um nó dummy com valor 0 é colocado no início, e os nós reais são conectados após ele. No final, `dummy.next` é retornado, eliminando a necessidade de tratamento especial para o nó inicial.

```java
ListNode dummy = new ListNode(0);  // Cria o nó dummy
ListNode tail = dummy;             // tail é o ponteiro que rastreia o final
tail.next = someNode;              // Conecta um nó após o dummy
tail = tail.next;                  // Avança tail para o final
return dummy.next;                 // Retorna o próximo do dummy, ou seja, o início real
```

### O que é Divisão e Conquista (Divide and Conquer)

Uma técnica que divide o problema em subproblemas menores, resolve cada subproblema e depois combina os resultados. O merge sort é um exemplo clássico, onde o array é dividido ao meio e os subarrays ordenados são combinados por merge. Neste problema, as K listas são emparelhadas duas a duas e o merge é repetido.

```java
// interval é dobrado como 1, 2, 4, 8..., aumentando a distância entre os pares
for (int interval = 1; interval < n; interval *= 2) {
    // Em cada rodada, os pares são combinados sequencialmente por merge
    for (int i = 0; i < n - interval; i += 2 * interval) {
        lists[i] = merge(lists[i], lists[i + interval]);
    }
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(N log k) — Todos os N elementos são processados uma vez por rodada, e o número de rodadas é log k |
| Space | O(log k) — Não utiliza recursão, mas corresponde ao espaço da pilha dos loops para o número de rodadas de merge |

## Código

```java
// Entrada: array de listas ligadas ordenadas ListNode[] lists (com K elementos)
// Saída: retorna o nó inicial ListNode da lista ligada ordenada unificada de todas as listas

// Método auxiliar que faz merge de duas listas ordenadas em uma
private ListNode mergeTwoLists(ListNode a, ListNode b) {
    // Cria um nó dummy como marcador do início da lista de resultado do merge (os dados reais começam em dummy.next)
    ListNode dummy = new ListNode(0);
    // tail sempre rastreia o final do resultado do merge, indicando a posição onde o próximo nó será conectado
    ListNode tail = dummy;

    // Enquanto ambas as listas tiverem nós restantes, seleciona o menor e o conecta (para manter a ordem)
    while (a != null && b != null) {
        if (a.val <= b.val) {
            tail.next = a;  // Conecta o nó atual de a ao resultado do merge
            a = a.next;     // Avança a para o próximo nó
        } else {
            tail.next = b;  // Conecta o nó atual de b ao resultado do merge
            b = b.next;     // Avança b para o próximo nó
        }
        tail = tail.next;   // Avança tail para o final, preparando para conectar o próximo nó
    }

    // Após o fim do loop while, um dos lados (a ou b) ainda possui nós restantes. Como ambos já estão ordenados, basta conectá-los diretamente
    tail.next = (a != null) ? a : b;

    // O dummy em si é apenas um marcador, portanto o nó seguinte é o início real do resultado do merge
    return dummy.next;
}

public ListNode mergeKLists(ListNode[] lists) {
    // Se a entrada for null ou vazia, não existem listas para unificar, portanto retorna null
    if (lists == null || lists.length == 0) return null;

    // Armazena o número de listas K em n
    int n = lists.length;

    // interval é dobrado como 1, 2, 4, 8... Ele representa a distância entre os pares a serem combinados, e o número de listas é reduzido pela metade a cada rodada
    for (int interval = 1; interval < n; interval *= 2) {
        // A condição i < n - interval garante que o par direito lists[i + interval] existe dentro dos limites do array
        for (int i = 0; i < n - interval; i += 2 * interval) {
            // O resultado do merge do par é armazenado em lists[i]. A lista da direita não será mais utilizada, portanto sobrescrever a da esquerda não causa problemas
            lists[i] = mergeTwoLists(lists[i], lists[i + interval]);
        }
    }

    // Após todas as rodadas, o resultado do merge de todas as listas está consolidado em lists[0]
    return lists[0];
}
```
