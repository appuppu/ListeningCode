# Simulating Rotting Oranges Spreading — Encontrar o tempo mínimo até que a propagação das laranjas podres seja concluída

## Essência do problema

Um grid m×n é dado, onde cada célula contém 0 (vazia), 1 (laranja fresca) ou 2 (laranja podre). A cada minuto, uma laranja podre faz apodrecer as laranjas frescas adjacentes nas quatro direções (cima, baixo, esquerda, direita). O algoritmo deve retornar o **número mínimo de minutos** até que todas as laranjas frescas apodreçam. Se for impossível fazer todas apodrecerem, o algoritmo deve retornar -1.

## Ideia central

As laranjas podres se propagam para as células adjacentes "simultaneamente". Isso corresponde exatamente a uma "Multi-Source BFS", que inicia a BFS simultaneamente a partir de múltiplos pontos de partida, onde cada nível (camada) da BFS corresponde a 1 minuto.

## Processo de raciocínio

1. **A propagação ocorre simultaneamente**: Quando existem múltiplas laranjas podres, cada uma faz apodrecer as células adjacentes ao mesmo tempo. Em vez de explorar a partir de um único ponto de partida, é necessário usar todas as laranjas podres como pontos de partida simultâneos
2. **Usar Multi-Source BFS para partida simultânea**: Se todas as laranjas podres forem inseridas na fila inicialmente, um nível da BFS (uma rodada que processa exatamente o tamanho atual da fila) corresponde a 1 minuto de propagação. A DFS não consegue garantir o "tempo mínimo", por isso a BFS é a abordagem adequada
3. **Rastrear a quantidade de laranjas frescas**: Se laranjas frescas permanecerem após o término da propagação, trata-se de um caso impossível. Por isso, o algoritmo conta a quantidade de laranjas frescas no estado inicial e decrementa esse contador a cada vez que uma laranja apodrece
4. **Método de medição do tempo decorrido**: O algoritmo processa todos os elementos da fila em cada nível da BFS e incrementa o tempo decorrido em 1 minuto a cada nível concluído. O número de níveis no momento em que a quantidade de laranjas frescas chega a 0 é a resposta
5. **Condição de término e verificação de impossibilidade**: Se `fresh > 0` após o término da BFS, existem laranjas frescas inalcançáveis e o algoritmo retorna -1. Se `fresh == 0`, o algoritmo retorna o tempo decorrido

## Conhecimentos prévios

### O que é BFS (Busca em Largura)

A BFS é um algoritmo que explora grafos ou grids "na ordem da menor distância a partir do ponto de partida". Ela utiliza uma fila (FIFO), processando todos os nós do nível atual antes de avançar para o próximo nível. A BFS é adequada para problemas que exigem a menor distância ou o menor tempo.

### O que é Multi-Source BFS

A BFS convencional tem um único ponto de partida, mas a Multi-Source BFS inicia a BFS com múltiplos pontos de partida já inseridos na fila. Ela é usada para simular a propagação simultânea a partir de todos os pontos de partida. A única diferença em relação à BFS convencional é que o estado inicial da fila contém múltiplos elementos.

### O que é uma Queue (Fila)

Uma Queue é uma estrutura de dados do tipo primeiro a entrar, primeiro a sair (FIFO). Na BFS, ela é utilizada para processar os nós a serem explorados em ordem.

```java
Queue<int[]> queue = new LinkedList<>();  // Cria uma fila com elementos do tipo array de int
queue.offer(new int[]{0, 1});  // Adiciona um elemento ao final da fila
int[] pos = queue.poll();       // Remove e retorna o elemento do início da fila → {0, 1}
queue.size();                   // Retorna o número de elementos na fila
queue.isEmpty();                // Retorna um boolean indicando se a fila está vazia
```

### O que é um array de direções

Um array de direções é uma técnica para enumerar as células adjacentes nas quatro direções (cima, baixo, esquerda, direita) durante a exploração de grids. Os deslocamentos de linha e coluna são definidos em um array e iterados em um loop.

```java
int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};  // 4 direções: direita, esquerda, baixo, cima
for (int[] d : dirs) {
    int nr = row + d[0];  // Índice da linha da célula adjacente
    int nc = col + d[1];  // Índice da coluna da célula adjacente
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m × n) — O algoritmo processa todas as células do grid uma vez na varredura inicial e no máximo uma vez na BFS |
| Space | O(m × n) — A fila armazena no máximo m×n células |

## Código

```java
// Entrada: grid de inteiros m×n (cada célula contém 0=vazia, 1=laranja fresca, 2=laranja podre)
// Saída: retorna um int representando o número mínimo de minutos até que todas as laranjas frescas apodreçam. Retorna -1 se for impossível
public int orangesRotting(int[][] grid) {
    int rows = grid.length;
    int cols = grid[0].length;
    // Fila para BFS. Armazena as coordenadas das células a serem exploradas
    Queue<int[]> queue = new LinkedList<>();
    // Variável que rastreia a quantidade de laranjas frescas restantes
    int fresh = 0;

    // Percorre todo o grid e prepara simultaneamente os múltiplos pontos de partida da BFS e a contagem restante até o objetivo
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] == 2) {
                // Adiciona a laranja podre à fila (ponto de partida da Multi-Source BFS)
                queue.offer(new int[]{i, j});
            } else if (grid[i][j] == 1) {
                // Conta a quantidade de laranjas frescas
                fresh++;
            }
        }
    }

    // Array de direções representando as 4 direções (cima, baixo, esquerda, direita). Usado para enumerar células adjacentes
    int[][] dirs = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
    int minutes = 0;

    // Inclui a condição de que ainda existem laranjas frescas, além da fila não estar vazia, para evitar loops desnecessários após todas terem apodrecido
    while (!queue.isEmpty() && fresh > 0) {
        // Salva antecipadamente o número de células a processar neste nível (1 minuto). Isso distingue os elementos do nível atual dos elementos do próximo nível adicionados durante o loop
        int size = queue.size();
        // Incrementa o tempo decorrido em 1 minuto ao iniciar o processamento de um nível
        minutes++;

        // Remove exatamente size elementos da fila para processar todas as células deste nível
        for (int k = 0; k < size; k++) {
            int[] pos = queue.poll();

            // Usa o array de direções para verificar as 4 células adjacentes (cima, baixo, esquerda, direita)
            for (int[] d : dirs) {
                int nr = pos[0] + d[0];
                int nc = pos[1] + d[1];

                // Se estiver dentro dos limites e for uma laranja fresca, faz apodrecer
                if (nr >= 0 && nr < rows
                    && nc >= 0 && nc < cols
                    && grid[nr][nc] == 1) {
                    // Atualiza a célula para 2 marcando-a como visitada (substitui um array de visited, evitando o processamento duplicado da mesma célula)
                    grid[nr][nc] = 2;
                    fresh--;
                    queue.offer(new int[]{nr, nc});
                }
            }
        }
    }

    // Se ainda restarem laranjas frescas, elas são inalcançáveis e o algoritmo retorna -1. Caso contrário, retorna o tempo decorrido
    return fresh > 0 ? -1 : minutes;
}
```
