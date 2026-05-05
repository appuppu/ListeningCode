# Finding the Longest Increasing Path in a Matrix — Encontrar o comprimento do caminho mais longo com valores estritamente crescentes em uma matriz

## Essência do Problema

Uma matriz de inteiros `matrix` de tamanho m×n é fornecida. É possível mover-se nas 4 direções (cima, baixo, esquerda, direita), e o movimento só é permitido quando o valor da célula de destino é **estritamente maior** que o valor da célula atual. O objetivo é retornar o **comprimento do caminho mais longo** (número de células) que satisfaz essa condição.

## Ideia Central

A matriz é interpretada como um "DAG (Grafo Acíclico Dirigido) onde as arestas vão de valores menores para valores maiores". A BFS é iniciada a partir das células com grau de entrada 0 (células que não possuem vizinhos com valores menores), avançando camada por camada, e o número de camadas corresponde diretamente ao comprimento do caminho mais longo.

## Processo de Raciocínio

1. **A condição de movimento se torna uma aresta do DAG**: Como o movimento só é possível na direção em que os valores são estritamente crescentes, não existem ciclos. Ou seja, ao interpretar as relações de adjacência da matriz como um grafo, obtém-se um DAG (Grafo Acíclico Dirigido) com arestas na direção menor→maior
2. **O caminho mais longo em um DAG é obtido por ordenação topológica**: O problema do caminho mais longo em um DAG pode ser resolvido eficientemente processando na ordem topológica. Usando BFS (Algoritmo de Kahn), é possível processar camada por camada, e o número de camadas corresponde ao comprimento do caminho mais longo
3. **Definir o significado do grau de entrada**: O grau de entrada de cada célula é "o número de células adjacentes nas 4 direções que possuem valor menor que a própria célula". Células com grau de entrada 0 são candidatas a ponto de partida do caminho, pois não possuem vizinhos adjacentes com valores menores
4. **Processar a BFS camada por camada**: Todas as células com grau de entrada 0 são inseridas na fila e a BFS é iniciada. Os células de uma camada são processados em conjunto, e para cada célula, o grau de entrada dos "vizinhos com valor maior" é decrementado em 1. Células cujo grau de entrada se torna 0 são adicionadas à fila como a próxima camada
5. **Por que o número de camadas é a resposta**: Cada camada da BFS é o conjunto de células que estão à mesma distância no DAG. O número de camadas até que a última camada seja processada é a distância do ponto de partida até a célula mais distante, ou seja, o comprimento do caminho mais longo

## Conhecimentos Prévios

### O que é um DAG (Grafo Acíclico Dirigido)

Um grafo composto por vértices e arestas dirigidas, sem ciclos (circuitos). Quando as arestas são criadas apenas na direção em que os valores são estritamente crescentes, não é possível retornar ao mesmo valor, portanto não surgem ciclos, e um DAG é formado.

### O que é grau de entrada (in-degree)

O **número de arestas que entram** em um vértice. Neste problema, o grau de entrada da célula `(i, j)` é "o número de células adjacentes (cima, baixo, esquerda, direita) que possuem valor menor que `matrix[i][j]`". Uma célula com grau de entrada 0 significa um ponto de partida de caminho que não é alcançado por nenhuma outra célula.

```java
// Exemplo de cálculo do grau de entrada da célula (i,j)
int indegree = 0;
for (int[] d : dirs) {
    int ni = i + d[0], nj = j + d[1];
    if (ni >= 0 && ni < m && nj >= 0 && nj < n
        && matrix[ni][nj] < matrix[i][j])  // Se o vizinho é menor, uma aresta entra nesta célula
        indegree++;
}
```

### O que é Ordenação Topológica (BFS / Algoritmo de Kahn)

Um método para ordenar os vértices de um DAG de forma que todas as arestas apontem de "anterior→posterior". No Algoritmo de Kahn, os vértices com grau de entrada 0 são inseridos na fila, e cada vez que um vértice é retirado, o grau de entrada dos vértices adjacentes é decrementado em 1, e os vértices cujo grau de entrada se torna 0 são adicionados à fila. Repetindo esse processo, a ordem topológica é obtida.

```java
Queue<int[]> q = new LinkedList<>();   // Criar fila para BFS
q.offer(new int[]{0, 1});             // Adicionar coordenadas da célula à fila
q.isEmpty();                           // Retornar boolean indicando se a fila está vazia → false
q.size();                              // Retornar o número de elementos na fila → 1
int[] cell = q.poll();                 // Retirar e retornar o elemento da frente da fila → {0, 1}
```

### Representar movimentos em 4 direções com um array

As 4 direções (cima, baixo, esquerda, direita) são definidas como um array bidimensional de `{variação da linha, variação da coluna}`, e cada direção é processada em um loop.

```java
int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};  // Direita, esquerda, baixo, cima
for (int[] d : dirs) {
    int ni = i + d[0];  // Linha de destino
    int nj = j + d[1];  // Coluna de destino
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m\*n) — O(m\*n) para calcular o grau de entrada de cada célula, e O(m\*n) para processar cada célula exatamente uma vez na BFS |
| Space | O(m\*n) — O array bidimensional para armazenar os graus de entrada e a fila da BFS armazenam no máximo m\*n células cada |

## Código

```java
// Entrada: matriz de inteiros matrix de tamanho m×n
// Saída: retornar como int o comprimento do caminho mais longo com valores estritamente crescentes (número de células)
int longestIncreasingPath(int[][] matrix) {
    // Obter o número de linhas m e o número de colunas n
    int m = matrix.length;
    int n = matrix[0].length;
    // Definir os deslocamentos de movimento nas 4 direções (direita, esquerda, baixo, cima)
    int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};

    // Calcular o grau de entrada de cada célula (número de vizinhos com valor menor)
    // Grau de entrada = número de arestas que entram na célula = número de células vizinhas com valor menor
    int[][] indeg = new int[m][n];
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            for (int[] d : dirs) {
                int ni = i + d[0];
                int nj = j + d[1];
                // Se a célula vizinha está dentro dos limites e possui valor menor, uma aresta entra nesta célula
                if (ni >= 0 && ni < m && nj >= 0 && nj < n
                    && matrix[ni][nj] < matrix[i][j])
                    indeg[i][j]++;
            }
        }
    }

    // Adicionar à fila todas as células com grau de entrada 0 (pontos de partida do caminho)
    // Grau de entrada 0 = não há vizinhos com valor menor = ponto de partida não alcançado por nenhuma célula no DAG
    Queue<int[]> q = new LinkedList<>();
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (indeg[i][j] == 0)
                q.offer(new int[]{i, j});

    // Processar a BFS camada por camada e contar o número de camadas
    // Cada camada é o conjunto de células à mesma distância do ponto de partida no DAG
    int pathLen = 0;
    while (!q.isEmpty()) {
        // Obter o número de células pertencentes à camada atual
        int size = q.size();
        // Incrementar o comprimento do caminho em 1 a cada nova camada (total de camadas = comprimento do caminho mais longo)
        pathLen++;
        for (int k = 0; k < size; k++) {
            int[] cell = q.poll();
            // Examinar as células vizinhas nas 4 direções da célula retirada
            for (int[] d : dirs) {
                int ni = cell[0] + d[0];
                int nj = cell[1] + d[1];
                // Se a célula vizinha está dentro dos limites e possui valor maior, processar essa aresta
                if (ni >= 0 && ni < m && nj >= 0 && nj < n
                    && matrix[ni][nj] > matrix[cell[0]][cell[1]]) {
                    // Decrementar o grau de entrada em 1 (marcar a aresta de entrada deste célula como processada)
                    indeg[ni][nj]--;
                    // Se o grau de entrada se tornou 0 = todas as arestas de entrada foram processadas → adicionar à fila como próxima camada
                    if (indeg[ni][nj] == 0)
                        q.offer(new int[]{ni, nj});
                }
            }
        }
    }
    // O número de camadas da BFS é o comprimento do caminho crescente mais longo
    // Pela restrição do problema, a matriz não é vazia, portanto pathLen >= 1 é garantido
    return pathLen;
}
```
