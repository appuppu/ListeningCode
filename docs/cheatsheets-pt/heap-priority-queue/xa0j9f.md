# Tracking the Kth Largest Element in a Stream — Obter sempre o K-ésimo maior elemento de um stream

## Essência do problema

Projeta-se uma classe que recebe um inteiro `k` e uma lista inicial de números. Cada vez que o método `add` é chamado, um novo número é adicionado ao stream, e o método retorna o **K-ésimo maior elemento** de todo o stream naquele momento.

## Ideia central

Como apenas o K-ésimo maior elemento é necessário, basta manter os K maiores elementos em um Min-Heap. Dessa forma, a raiz do heap (valor mínimo) será sempre o K-ésimo maior elemento.

## Processo de raciocínio

1. **Apenas o K-ésimo maior elemento é necessário**: Não é preciso ordenar todo o stream; basta acompanhar os K maiores elementos para determinar o K-ésimo maior elemento
2. **Gerenciar os K maiores elementos de forma eficiente**: O Min-Heap (heap mínimo) é adequado, pois a inserção de elementos e a extração do valor mínimo são realizadas em O(log n). A raiz do Min-Heap sempre mantém o menor valor dentro do heap, portanto, se o tamanho for mantido em K, a raiz será o K-ésimo maior elemento
3. **Método para limitar o tamanho do heap a K**: Após adicionar um novo elemento, se o tamanho do heap exceder K, a raiz (valor mínimo) é removida com `poll()`. Com isso, valores menores que o K-ésimo maior elemento são eliminados automaticamente, e apenas os K maiores elementos permanecem
4. **Método para obter o K-ésimo maior elemento**: Quando o tamanho do heap é exatamente K, o valor da raiz é o K-ésimo maior elemento. Esse valor pode ser obtido em O(1) com `peek()`
5. **Reutilizar o método add na inicialização**: Ao chamar `add` para cada elemento da lista inicial no construtor, o heap é construído com a mesma lógica. Dessa forma, o código de inicialização e de adição é compartilhado

## Conhecimentos prévios

### O que é um Min-Heap (heap mínimo)

O heap é uma estrutura de dados com formato de árvore binária completa. No Min-Heap, o valor do nó pai é sempre mantido menor ou igual ao valor dos nós filhos. Por isso, a raiz sempre contém o menor valor do heap. A inserção de elementos e a extração do valor mínimo são realizadas em O(log n).

### O que é PriorityQueue

PriorityQueue é a classe de implementação do Min-Heap em Java. Por padrão, os elementos são priorizados em ordem crescente (do menor para o maior).

```java
PriorityQueue<Integer> heap = new PriorityQueue<>();  // Cria um Min-Heap vazio
heap.offer(5);        // Adiciona o elemento 5 ao heap
heap.offer(3);        // Adiciona o elemento 3 ao heap
heap.offer(8);        // Adiciona o elemento 8 ao heap
heap.peek();          // Retorna a raiz (valor mínimo) do heap sem removê-la → 3
heap.poll();          // Remove e retorna a raiz (valor mínimo) do heap → 3
heap.size();          // Retorna o número de elementos no heap → 2
```

### Por que o Min-Heap permite identificar o K-ésimo maior elemento

Um Min-Heap de tamanho K contém os K maiores elementos. A raiz do heap é o menor valor entre eles, ou seja, "o menor valor entre os K maiores" = "o K-ésimo maior elemento de todo o conjunto".
Exemplo: k=3, conteúdo do heap [4, 5, 8], a raiz é 4. Este é o 3º maior elemento do conjunto total.

## Complexidade

| | Valor |
|---|---|
| Time | O(log k) — por chamada do método add, a inserção e a remoção no heap de tamanho K são realizadas em O(log k) cada |
| Space | O(k) — o heap mantém no máximo K elementos a qualquer momento |

## Código

```java
// Entrada: inteiro k, array inicial de inteiros nums e inteiro val passado ao método add
// Saída: o método add retorna o K-ésimo maior elemento de todo o stream como int
class KthLargest {
    // K é mantido como campo, pois é usado continuamente como limite de tamanho do heap
    int k;
    // PriorityQueue opera por padrão como Min-Heap (valor mínimo na raiz)
    PriorityQueue<Integer> heap;

    // Construtor: recebe k e o array inicial e constrói o heap
    KthLargest(int k, int[] nums) {
        this.k = k;
        heap = new PriorityQueue<>();
        // Como a limitação de tamanho do heap é feita dentro do método add, não é necessária lógica exclusiva para a inicialização
        for (int n : nums) {
            add(n);
        }
    }

    // Adiciona um novo valor e retorna o K-ésimo maior elemento
    int add(int val) {
        // Insere o elemento no final do heap e o move em direção ao pai para manter a propriedade do heap (O(log k))
        heap.offer(val);

        // Se o tamanho exceder K, existe um elemento a mais que é menor que o K-ésimo maior
        if (heap.size() > k) {
            // A raiz do Min-Heap é sempre o valor mínimo, portanto o valor removido é menor que o K-ésimo maior
            heap.poll();
        }

        // Quando o tamanho do heap é exatamente K, a raiz é o menor valor no heap = o K-ésimo maior elemento do conjunto total
        return heap.peek();
    }
}
```
