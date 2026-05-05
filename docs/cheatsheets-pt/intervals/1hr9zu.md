# Finding the Smallest Interval Containing Each Query — Encontrar o menor intervalo que contém cada consulta

## Essência do problema

São dados um array 2D de inteiros `intervals` (cada elemento é `[left, right]`) e um array de inteiros `queries`. Para cada valor de consulta, é necessário encontrar o intervalo que contém esse valor e que possui o **menor tamanho**. O tamanho de um intervalo é definido como `right - left + 1`. Se não existir nenhum intervalo que contenha o valor da consulta, retorna-se `-1`.

## Ideia central

Ao ordenar tanto as consultas quanto os intervalos e processar as consultas em ordem crescente de valor, é possível adicionar sequencialmente ao Min-Heap os "intervalos cujo extremo esquerdo é menor ou igual ao valor da consulta". Extraindo do Min-Heap o intervalo com o menor tamanho cujo extremo direito é maior ou igual ao valor da consulta, obtém-se a resposta.

## Processo de raciocínio

1. **Verificar todos os intervalos para cada consulta é ineficiente**: Percorrer todos os intervalos para cada consulta custa O(n×q). Ao ordenar tanto as consultas quanto os intervalos, o processamento de adição de intervalos pode ser compartilhado entre todas as consultas, eliminando percursos redundantes
2. **Processar as consultas em ordem crescente torna a adição de intervalos monotônica**: Ao ordenar os intervalos pelo extremo esquerdo e as consultas em ordem crescente de valor, à medida que o valor da consulta aumenta, os intervalos que satisfazem a condição "extremo esquerdo menor ou igual à consulta" apenas aumentam, nunca diminuem. Ou seja, a adição de intervalos torna-se uma operação monotônica que apenas avança o ponteiro
3. **É necessário obter rapidamente o menor tamanho entre os intervalos adicionados**: Para extrair o intervalo de menor tamanho entre os candidatos, o Min-Heap (heap mínimo) é adequado. Usando o tamanho do intervalo como chave do heap, é possível obter o intervalo de menor tamanho em O(1) com a operação peek
4. **Intervalos com extremo direito menor que o valor da consulta são inválidos**: Entre os intervalos que permanecem no heap, aqueles cujo extremo direito é menor que o valor da consulta não contêm essa consulta. Esses intervalos são removidos sequencialmente do topo do heap com poll. Uma vez removido, o intervalo permanece inválido para as consultas seguintes (pois os valores das consultas são crescentes), não sendo necessário readicioná-lo
5. **É necessário preservar a ordem original das consultas**: As consultas são processadas após ordenação, mas os resultados devem ser retornados na ordem original. Para isso, antes de ordenar, o índice original de cada consulta é armazenado como um par, e a resposta é escrita na posição correspondente do array de resultados
6. **Se o heap estiver vazio, não existe intervalo que contenha a consulta**: Se, após remover os intervalos inválidos, o heap estiver vazio, não existe nenhum intervalo que contenha essa consulta, e `-1` é armazenado no resultado

## Conhecimentos prévios

### O que é PriorityQueue (Min-Heap)

É uma estrutura de dados que gerencia elementos por ordem de prioridade. Por padrão, o menor valor fica no topo (Min-Heap). A adição e a remoção de elementos custam O(log n), e a consulta ao topo custa O(1).

```java
// Min-Heap que armazena int[] e ordena em ordem crescente pelo elemento na posição 0 (tamanho)
PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[0] - b[0]);
heap.offer(new int[]{5, 10});  // Adiciona um elemento
heap.peek();                    // Consulta o elemento do topo sem removê-lo → {5, 10}
heap.poll();                    // Remove e retorna o elemento do topo → {5, 10}
heap.isEmpty();                 // Verifica se o heap está vazio → true
```

### O que é consulta offline

É uma técnica em que as consultas são reordenadas em uma ordem conveniente para o processamento, em vez de serem processadas na ordem de chegada. Os resultados são escritos de volta nas posições corretas usando os índices originais. É eficaz quando não há dependências entre as consultas.

```java
int q = queries.length;
int[][] sortedQ = new int[q][2];
for (int i = 0; i < q; i++) {
    sortedQ[i] = new int[]{queries[i], i};  // Cria um par {valor da consulta, índice original}
}
Arrays.sort(sortedQ, (a, b) -> a[0] - b[0]);  // Ordena em ordem crescente pelo valor da consulta
```

### Comparador personalizado do Arrays.sort

Ordena arrays 2D ou arrays de objetos por um critério arbitrário. A expressão lambda `(a, b) -> a[0] - b[0]` significa ordenar em ordem crescente pelo valor na posição 0 de cada elemento.

```java
int[][] intervals = {{3, 6}, {1, 4}, {2, 8}};
Arrays.sort(intervals, (a, b) -> a[0] - b[0]);  // Ordena em ordem crescente pelo extremo esquerdo → {{1,4}, {2,8}, {3,6}}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n log n + q log q) — O(n log n) para ordenar os intervalos, O(q log q) para ordenar as consultas, e as operações no heap são O(n log n) pois cada intervalo é adicionado e removido no máximo uma vez |
| Space | O(n + q) — O heap armazena no máximo n intervalos, e o array de consultas ordenado armazena q elementos |

## Código

```java
// Entrada: array 2D de inteiros intervals (cada elemento é [left, right]) e array de inteiros queries
// Saída: retorna um int[] contendo o tamanho do menor intervalo que contém cada consulta. Se não houver intervalo, armazena -1
public int[] minInterval(int[][] intervals, int[] queries) {
    // Ordena os intervalos em ordem crescente pelo extremo esquerdo. Assim, basta avançar o ponteiro j para adicionar todos os "intervalos com extremo esquerdo menor ou igual ao valor da consulta"
    Arrays.sort(intervals, (a, b) -> a[0] - b[0]);

    int q = queries.length;
    // Associa cada consulta ao seu índice original formando um par. Isso é necessário para escrever os resultados de volta na posição correta após a ordenação
    int[][] sortedQ = new int[q][2];
    for (int i = 0; i < q; i++) {
        sortedQ[i] = new int[]{queries[i], i};
    }
    // Ordena as consultas em ordem crescente de valor. Processar em ordem crescente torna a adição de intervalos uma operação monotônica
    Arrays.sort(sortedQ, (a, b) -> a[0] - b[0]);

    // Min-Heap que armazena {tamanho do intervalo, extremo direito} e extrai em ordem crescente de tamanho. Usando o tamanho como chave, o intervalo de menor tamanho pode ser consultado em O(1)
    PriorityQueue<int[]> heap =
        new PriorityQueue<>((a, b) -> a[0] - b[0]);

    int[] res = new int[q];
    int j = 0;  // Ponteiro que percorre o array de intervalos. Como só avança ao longo de todas as consultas, o total de adições é O(n)

    for (int[] sq : sortedQ) {
        int val = sq[0], idx = sq[1];  // val=valor da consulta, idx=índice original

        // Adiciona ao heap todos os intervalos cujo extremo esquerdo é menor ou igual ao valor da consulta. Como j não retrocede, o custo total é O(n)
        while (j < intervals.length && intervals[j][0] <= val) {
            int sz = intervals[j][1] - intervals[j][0] + 1;  // Tamanho do intervalo = right - left + 1
            heap.offer(new int[]{sz, intervals[j][1]});  // Adiciona {tamanho, extremo direito} ao heap
            j++;
        }

        // Remove intervalos cujo extremo direito é menor que o valor da consulta (que não contêm a consulta). Como os valores das consultas são crescentes, um intervalo removido permanece inválido para as consultas seguintes
        while (!heap.isEmpty() && heap.peek()[1] < val) {
            heap.poll();
        }

        // Se o heap estiver vazio, não existe intervalo que contenha a consulta; caso contrário, o tamanho do intervalo no topo é a resposta (os intervalos inválidos já foram removidos, então o topo é o menor e válido)
        res[idx] = heap.isEmpty() ? -1 : heap.peek()[0];
    }
    return res;
}
```
