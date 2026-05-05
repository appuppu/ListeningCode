# Finding the Median From a Data Stream — Encontrar a mediana em tempo real a partir de um fluxo de dados

## Essência do problema

Em uma situação onde inteiros são adicionados continuamente a partir de um fluxo de dados, o objetivo é projetar uma estrutura de dados que suporte duas operações. `addNum(int num)` adiciona um inteiro, e `findMedian()` retorna a **mediana** de todos os inteiros adicionados até o momento. Se a quantidade de elementos for ímpar, retorna o valor central; se for par, retorna a média dos dois valores centrais.

## Ideia central

Se dividirmos todos os elementos em "metade inferior" e "metade superior", gerenciando cada uma com um max-heap e um min-heap respectivamente, a mediana pode ser obtida em O(1) a partir do topo dos dois heaps.

## Processo de raciocínio

1. **A mediana está "no meio"**: Para encontrar a mediana, é necessário manter todos os elementos em estado ordenado e acessar o elemento do meio. No entanto, ordenar a cada adição de elemento custa O(n log n)
2. **Não é necessário ordenar todos os elementos, basta saber o meio**: Se dividirmos todos os elementos em "metade inferior (lower half)" e "metade superior (upper half)", o valor máximo da metade inferior e o valor mínimo da metade superior se tornam candidatos à mediana
3. **Queremos obter o valor extremo de cada metade rapidamente**: Para obter o valor máximo da metade inferior em O(1), um max-heap é adequado; para obter o valor mínimo da metade superior em O(1), um min-heap é adequado. A adição ao heap custa O(log n)
4. **Manter o equilíbrio de tamanho entre os dois heaps**: Para calcular a mediana corretamente, é necessário manter a diferença de tamanho entre os dois heaps em no máximo 1. O equilíbrio é mantido de forma que o tamanho de lo (max-heap) seja sempre maior ou igual ao tamanho de hi (min-heap)
5. **Procedimento de balanceamento ao adicionar elementos**: O novo elemento é adicionado primeiro a lo, e então o valor máximo de lo é movido para hi. Isso garante que o valor máximo de lo ≤ valor mínimo de hi sempre. Depois, se o tamanho de hi ficar maior que lo, o valor mínimo de hi é devolvido a lo
6. **Obtenção da mediana**: Se o tamanho de lo for maior que hi, a quantidade de elementos é ímpar, então o topo de lo (valor máximo) é a mediana. Se os tamanhos forem iguais, a quantidade de elementos é par, então a média do topo de lo e do topo de hi é a mediana

## Conhecimentos prévios

### O que é PriorityQueue (heap)

Uma estrutura de dados que gerencia elementos por ordem de prioridade. Por padrão, funciona como um min-heap (o valor mínimo fica no topo). A obtenção do elemento do topo é O(1), e a adição/remoção de elementos é O(log n).

```java
// min-heap (padrão): o valor mínimo fica no topo
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.offer(5);       // Adiciona o elemento 5
minHeap.offer(3);       // Adiciona o elemento 3
minHeap.peek();          // Obtém o valor mínimo do topo → 3 (sem remover)
minHeap.poll();          // Remove e retorna o valor mínimo do topo → 3 (com remoção)

// max-heap: o valor máximo fica no topo (especificando Collections.reverseOrder())
PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
maxHeap.offer(5);       // Adiciona o elemento 5
maxHeap.offer(3);       // Adiciona o elemento 3
maxHeap.peek();          // Obtém o valor máximo do topo → 5
```

### Diferenças entre offer / poll / peek

| Método | Comportamento | Valor de retorno |
|---|---|---|
| `offer(e)` | Adiciona o elemento `e` ao heap | `boolean` (true em caso de sucesso) |
| `poll()` | Remove e retorna o elemento do topo (**com remoção**) | O elemento removido (`null` se vazio) |
| `peek()` | Consulta o elemento do topo **sem removê-lo** | O elemento do topo (`null` se vazio) |

### O que é mediana (median)

O valor do meio de uma lista ordenada. Se a quantidade de elementos for ímpar, é o único valor central; se for par, é a média dos dois valores centrais.
Exemplo: `[1, 2, 3]` → a mediana é `2`. `[1, 2, 3, 4]` → a mediana é `(2 + 3) / 2.0 = 2.5`.

## Complexidade

| | Valor |
|---|---|
| Time | O(log n) — Em `addNum`, ocorrem no máximo 3 adições/remoções ao heap, e cada operação é O(log n). `findMedian` é O(1) |
| Space | O(n) — Os dois heaps armazenam todos os elementos |

## Código

```java
// Entrada: inteiros são passados um a um como fluxo via addNum(int num)
// Saída: findMedian() retorna a mediana de todos os inteiros adicionados até o momento como double
class MedianFinder {
    // Max-heap que gerencia a metade inferior (o topo é o valor máximo)
    PriorityQueue<Integer> lo;
    // Min-heap que gerencia a metade superior (o topo é o valor mínimo)
    PriorityQueue<Integer> hi;

    MedianFinder() {
        // O max-heap usa Collections.reverseOrder() para ordenar em ordem decrescente
        lo = new PriorityQueue<>(Collections.reverseOrder());
        // O min-heap usa a ordenação padrão (ordem crescente)
        hi = new PriorityQueue<>();
    }

    void addNum(int num) {
        // Qualquer elemento é inserido primeiro na metade inferior (lo)
        lo.offer(num);
        // Move o valor máximo de lo para hi, mantendo sempre a relação: todos os elementos de lo ≤ todos os elementos de hi
        hi.offer(lo.poll());

        // Se o tamanho de hi ficar maior que lo, devolve o valor mínimo de hi para lo para manter o equilíbrio
        // Esta operação garante que o tamanho de lo seja sempre maior ou igual ao de hi (diferença máxima de 1)
        if (hi.size() > lo.size())
            lo.offer(hi.poll());
    }

    double findMedian() {
        // Se o tamanho de lo for maior = quantidade total de elementos é ímpar → o topo de lo (valor máximo da metade inferior) é a mediana
        if (lo.size() > hi.size())
            return lo.peek();

        // Se os tamanhos forem iguais = quantidade total de elementos é par → retorna a média dos dois valores centrais
        // Divide por 2.0 para realizar divisão de ponto flutuante em vez de divisão inteira
        return (lo.peek() + hi.peek()) / 2.0;
    }
}
```
