# Finding the Minimum Cost to Connect All Points — Encontrar o Custo Mínimo para Conectar Todos os Pontos

## Essência do Problema

É fornecido um array de pontos `points` em um plano 2D. O custo entre quaisquer dois pontos é definido pela distância de Manhattan `|xi - xj| + |yi - yj|`. O objetivo é retornar o **custo total mínimo** para conectar todos os pontos. Este é um problema de encontrar a Árvore Geradora Mínima (MST: Minimum Spanning Tree).

## Ideia Central

Para conectar todos os pontos com o custo mínimo, basta utilizar o algoritmo de Prim, selecionando de forma gulosa o "ponto não visitado mais próximo da MST atual". Utilizando uma fila de prioridade, é possível extrair a aresta de menor custo de forma eficiente.

## Processo de Raciocínio

1. **Este é um problema de MST**: O objetivo é conectar todos os pontos e minimizar o custo. Esta é exatamente a definição de uma árvore geradora mínima. Os pesos das arestas do grafo podem ser calculados pela distância de Manhattan
2. **Prim é adequado porque o grafo é completo**: Com n pontos, o número de arestas é n(n-1)/2. Com Kruskal seria necessário gerar e ordenar todas as arestas antecipadamente, mas com Prim é possível processar apenas as arestas adjacentes à MST atual de forma incremental
3. **Queremos extrair a aresta de menor custo rapidamente**: No algoritmo de Prim, é necessário selecionar a "aresta de menor custo para um ponto não visitado" a cada iteração. Utilizando uma fila de prioridade (min-heap), essa extração pode ser feita em O(log n)
4. **É possível iniciar a partir de qualquer ponto**: O custo total da MST é o mesmo independentemente do ponto de partida, portanto iniciamos a partir do ponto 0. No estado inicial, inserimos o custo 0 para o ponto 0 na fila
5. **O flag de visitado previne duplicatas**: Se o ponto extraído da fila já estiver incluído na MST, ele é ignorado. Isso evita o processamento duplicado do mesmo ponto
6. **A cada novo ponto adicionado à MST, as arestas adjacentes são inseridas**: Ao adicionar o ponto u à MST, calculamos a distância de Manhattan de u para todos os pontos não visitados v e os inserimos na fila. A fila gerencia automaticamente a aresta de menor custo como próxima candidata

## Conhecimentos Prévios

### O que é uma Árvore Geradora Mínima (MST)

É o subgrafo que conecta todos os vértices de um grafo e cuja soma dos pesos das arestas é mínima. Para n vértices, possui exatamente n-1 arestas e não contém ciclos.

### O que é o Algoritmo de Prim

É um algoritmo guloso para construir a MST. Iniciando a partir de um vértice arbitrário, seleciona repetidamente "a aresta de menor peso que conecta a MST atual a um vértice não visitado" para expandir a MST. O processo termina quando todos os vértices estiverem incluídos na MST.

### O que é a Distância de Manhattan

É a soma dos valores absolutos das diferenças de cada coordenada entre dois pontos. A distância entre os pontos `(x1, y1)` e `(x2, y2)` em um plano 2D é calculada como `|x1 - x2| + |y1 - y2|`. Corresponde à menor distância ao caminhar por ruas em formato de grade.

```java
int dist = Math.abs(pts[u][0] - pts[v][0]) + Math.abs(pts[u][1] - pts[v][1]);
```

### O que é uma PriorityQueue (Fila de Prioridade)

É uma estrutura de dados que permite extrair elementos em ordem de prioridade. Por padrão, o menor valor é extraído primeiro (min-heap). A inserção é feita com `offer` e a extração do menor elemento com `poll`, ambos com complexidade O(log n).

```java
// Cria uma fila de prioridade ordenada de forma crescente pelo elemento no índice 0 do int[]
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{5, 0});   // Adiciona [custo=5, índice do ponto=0]
pq.offer(new int[]{2, 1});   // Adiciona [custo=2, índice do ponto=1]
int[] min = pq.poll();       // Extrai o elemento com menor custo [2, 1]
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n² log n) — A cada ponto adicionado à MST, até n arestas são inseridas na fila, e cada operação na fila custa log n |
| Space | O(n²) — A fila pode armazenar até n² arestas. O array inMST é O(n) |

## Código

```java
// Entrada: array de coordenadas 2D pts (cada elemento é [x, y])
// Saída: retorna o custo mínimo para conectar todos os pontos como int
int minCostConnectPoints(int[][] pts) {
    // Obtém o número de pontos
    int n = pts.length;
    // Array de flags que gerencia se cada ponto está incluído na MST (inicializado com false)
    boolean[] inMST = new boolean[n];
    // Fila de prioridade que armazena {custo, índice do ponto} e extrai em ordem crescente de custo
    PriorityQueue<int[]> pq =
        new PriorityQueue<>((a, b) -> a[0] - b[0]);
    // Adiciona o ponto inicial (índice 0) à fila com custo 0
    // Custo 0 significa que o custo para adicionar o primeiro ponto à MST é 0
    // O custo total da MST é o mesmo independentemente do ponto de partida, então o ponto 0 foi escolhido arbitrariamente
    pq.offer(new int[]{0, 0});
    // cost: custo total da MST, visited: número de pontos já adicionados à MST
    int cost = 0, visited = 0;

    // Repete até que todos os pontos estejam incluídos na MST
    while (visited < n) {
        // Extrai a aresta com menor custo (d: custo de conexão, u: índice do ponto)
        int[] curr = pq.poll();
        int d = curr[0], u = curr[1];

        // Ignora o ponto se já estiver incluído na MST
        // Essa verificação é necessária porque o mesmo ponto pode ser adicionado à fila várias vezes com custos diferentes
        if (inMST[u]) continue;

        // Adiciona o ponto u à MST e soma o custo
        inMST[u] = true;
        cost += d;
        visited++;

        // Adiciona à fila as arestas do ponto u para todos os pontos não visitados
        // As arestas candidatas são registradas na fila, que gerencia automaticamente a aresta de menor custo
        for (int v = 0; v < n; v++) {
            if (!inMST[v]) {
                // Calcula a distância de Manhattan: |xu - xv| + |yu - yv|
                int nd =
                    Math.abs(pts[u][0] - pts[v][0])
                    + Math.abs(pts[u][1] - pts[v][1]);
                pq.offer(new int[]{nd, v});
            }
        }
    }
    // Após o término do loop while, cost contém o custo total da MST
    return cost;
}
```
