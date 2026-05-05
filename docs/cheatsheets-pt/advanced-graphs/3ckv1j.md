# Calculando o Tempo de Propagação de Sinal na Rede — Determinar o menor tempo para que o sinal alcance toda a rede

## Essência do Problema

São fornecidos `n` nós (de 1 a n) e uma lista de arestas dirigidas com pesos `times` (cada aresta é `[origem, destino, tempo necessário]`). Quando um sinal é enviado a partir de um nó de origem especificado `k`, o objetivo é retornar o menor tempo para que o sinal alcance todos os nós. Se houver pelo menos um nó inalcançável, retornar `-1`.

## Ideia Central

"O menor tempo para alcançar todos os nós" equivale a "o maior entre os menores caminhos até cada nó". Basta calcular o menor caminho até todos os nós com o algoritmo de Dijkstra e obter o valor máximo.

## Processo de Raciocínio

1. **Interpretar o problema como um problema de menor caminho**: O sinal se propaga do nó de origem através de cada aresta. O instante em que o sinal alcança cada nó é igual à menor distância do nó de origem até esse nó. Portanto, basta resolver o problema de menor caminho a partir de uma única origem
2. **Calcular eficientemente o menor caminho até todos os nós**: Como os pesos das arestas são não negativos, o algoritmo de Dijkstra pode ser aplicado. O algoritmo de Dijkstra usa uma fila de prioridade (min-heap) e determina a distância de forma gulosa, começando pelo nó com menor distância
3. **Decidir a representação do grafo**: Utilizar uma lista de adjacência. Para cada nó, manter uma lista de pares "nó adjacente e peso da aresta". Isso permite enumerar eficientemente as arestas que partem de um determinado nó
4. **Inicializar o array de distâncias**: Inicializar a distância de todos os nós com infinito (`Integer.MAX_VALUE`) e definir a distância do nó de origem `k` como 0. Isso ocorre porque a distância da origem até ela mesma é 0
5. **Processar o nó com menor distância usando a fila de prioridade**: Retirar da fila o nó com menor distância e atualizar (relaxar) as distâncias dos nós adjacentes. Se houver atualização, adicionar o nó à fila
6. **Pular processamentos duplicados**: Se a distância do nó retirado da fila for maior que a menor distância atual, o nó já foi processado por um caminho melhor, então deve ser ignorado. Isso evita cálculos desnecessários
7. **Obter a resposta a partir das menores distâncias de todos os nós**: Percorrer o array de distâncias de todos os nós; se algum nó permanecer com valor infinito, ele é inalcançável e retornar `-1`. Caso contrário, o valor máximo das distâncias é a resposta

## Conhecimentos Prévios

### O que é uma Lista de Adjacência (Adjacency List)

Uma estrutura de dados para representar grafos. Para cada nó, mantém-se uma lista com "todas as arestas que partem desse nó". Para `n` nós, representa-se com `List<List<int[]>>`, e `graph.get(u)` obtém as arestas que partem do nó `u`.

```java
List<List<int[]>> graph = new ArrayList<>();
for (int i = 0; i <= n; i++) {
    graph.add(new ArrayList<>());       // Preparar uma lista vazia para cada nó
}
graph.get(1).add(new int[]{2, 5});      // Adicionar aresta do nó 1 ao nó 2 com peso 5
graph.get(1).add(new int[]{3, 2});      // Adicionar aresta do nó 1 ao nó 3 com peso 2
```

### O que é uma PriorityQueue (Fila de Prioridade)

Uma estrutura de dados que mantém sempre o menor (ou maior) elemento no início, independentemente da ordem de inserção. No algoritmo de Dijkstra, é usada para retirar eficientemente o "nó com menor distância".

```java
// min-heap ordenado em ordem crescente pelo elemento de índice 0 (distância) do int[]
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{0, 1});   // Adicionar {distância 0, nó 1} à fila
pq.offer(new int[]{5, 2});   // Adicionar {distância 5, nó 2} à fila
int[] curr = pq.poll();       // Retirar o elemento com menor distância {0, 1}
pq.isEmpty();                 // Retornar boolean indicando se a fila está vazia
```

### O que é a Relaxação (Relaxation) no Algoritmo de Dijkstra

Quando a distância para alcançar o nó `v` passando pelo nó `u`, ou seja, `dist[u] + w`, é menor que o `dist[v]` atual, a operação de atualizar `dist[v]` para o valor mais curto. Ao repetir essa atualização, a menor distância até todos os nós é determinada.

```java
int newDist = dist[u] + w;      // Calcular a distância até v passando por u
if (newDist < dist[v]) {        // Se for menor que a menor distância atual
    dist[v] = newDist;          // Atualizar a menor distância
    pq.offer(new int[]{newDist, v});  // Adicionar v atualizado à fila
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O((V + E) log V) — Para cada nó e cada aresta, realiza-se uma operação na fila de prioridade (log V) |
| Space | O(V + E) — Armazena todas as arestas na lista de adjacência e utiliza o array de distâncias e a fila para a quantidade de nós |

## Código

```java
// Entrada: lista de arestas dirigidas int[][] times (cada elemento é [origem, destino, peso]), número de nós int n, nó de origem int k
// Saída: retorna o menor tempo como int para que o sinal alcance todos os nós a partir da origem. Retorna -1 se houver nó inalcançável
public int networkDelayTime(int[][] times, int n, int k) {
    // Criar a lista de adjacência (como os nós começam em 1, o tamanho é n+1 e o índice 0 não é utilizado)
    List<List<int[]>> graph = new ArrayList<>();
    for (int i = 0; i <= n; i++) {
        graph.add(new ArrayList<>());
    }
    // Registrar cada aresta [u, v, w] na lista de adjacência, completando a representação do grafo dirigido
    for (int[] t : times) {
        graph.get(t[0]).add(new int[]{t[1], t[2]});
    }

    // Inicializar o array de distâncias com infinito. dist[i] representa "a menor distância atual da origem até o nó i"
    int[] dist = new int[n + 1];
    Arrays.fill(dist, Integer.MAX_VALUE);
    // A distância do nó de origem até ele mesmo é 0
    dist[k] = 0;

    // Criar um min-heap que retira elementos em ordem crescente de distância (índice 0) e adicionar o nó de origem {distância 0, nó k}
    PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
    pq.offer(new int[]{0, k});

    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int d = curr[0];  // Distância da origem até o nó u
        int u = curr[1];  // Nó sendo processado atualmente

        // Se d > dist[u], o nó já foi processado com uma distância menor. Isso ocorre quando entradas antigas (com distância maior) permanecem na fila
        if (d > dist[u]) continue;

        // Tentar a relaxação para os nós adjacentes
        for (int[] nei : graph.get(u)) {
            int v = nei[0];  // Nó adjacente
            int w = nei[1];  // Peso da aresta
            // Se a distância passando por u, d + w, for menor que dist[v] atual, atualizar a distância e adicionar à fila
            if (d + w < dist[v]) {
                dist[v] = d + w;
                pq.offer(new int[]{d + w, v});
            }
        }
    }

    // Obter o valor máximo entre as menores distâncias de todos os nós. Esse valor máximo é "o menor tempo para que o sinal alcance todos os nós"
    int max = 0;
    for (int i = 1; i <= n; i++) {
        // Se o valor permanecer Integer.MAX_VALUE, existe um nó inalcançável, então retornar -1
        if (dist[i] == Integer.MAX_VALUE) return -1;
        max = Math.max(max, dist[i]);
    }
    return max;
}
```
