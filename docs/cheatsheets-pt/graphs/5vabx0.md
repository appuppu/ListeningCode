# Finding Cells That Drain to Both Oceans — Encontrar todas as células das quais a água flui para ambos os oceanos

## Essência do Problema

Uma matriz de alturas m×n é fornecida. O Oceano Pacífico faz fronteira com a borda superior e a borda esquerda, e o Oceano Atlântico faz fronteira com a borda inferior e a borda direita. A água flui de uma célula atual para uma célula adjacente quando a altura da célula adjacente é menor ou igual à da célula atual. O objetivo é encontrar todas as células das quais a água pode alcançar **ambos** os oceanos, Pacífico e Atlântico.

## Ideia Central

Se a verificação de alcance do oceano for feita na direção direta a partir de cada célula, os cálculos se tornam redundantes. Em vez disso, ao executar BFS na direção reversa a partir das células de fronteira do oceano para o interior (para células adjacentes com altura igual ou maior), o conjunto de células que podem alcançar cada oceano é obtido em O(m*n), e a interseção dos dois conjuntos é a resposta.

## Processo de Raciocínio

1. **A busca na direção direta é ineficiente**: Buscar caminhos de cada célula (i,j) até o oceano exigiria BFS/DFS para cada uma das O(m*n) células, resultando em O((m*n)²) no total. Como a busca independente por célula tem muita redundância, consideramos a busca na direção reversa
2. **Inversão de perspectiva**: "A água flui de uma célula para o oceano" é equivalente a "existe um caminho não decrescente em altura do oceano até a célula". Executando BFS na direção do fluxo reverso a partir da fronteira do oceano, o conjunto de células alcançáveis pode ser obtido de uma só vez
3. **Processar os dois oceanos independentemente**: Colocar todas as células da fronteira do Pacífico (borda superior + borda esquerda) na fila e executar BFS, registrando as células alcançáveis. Fazer o mesmo para as células da fronteira do Atlântico (borda inferior + borda direita). Como as duas buscas são independentes entre si, a mesma lógica pode ser reutilizada
4. **Definir a condição de transição do BFS**: Como é um fluxo reverso, a transição ocorre quando a altura da célula adjacente é **maior ou igual** à da célula atual. Isso é o inverso de "a água flui de locais mais altos para locais mais baixos"
5. **Obter a interseção**: As células marcadas como alcançadas em ambos os BFS são as células das quais a água flui para ambos os oceanos. Percorrer todas as células e adicionar à lista de resultados aquelas que são true em ambos

## Conhecimentos Prévios

### Multi-source BFS (BFS com múltiplas origens)

O BFS normal começa a partir de uma única origem, mas nesta técnica, todas as múltiplas origens são colocadas na fila antes de iniciar o BFS. O efeito obtido é o mesmo de expandir a busca simultaneamente a partir de todas as origens, permitindo encontrar todas as células alcançáveis a partir de todas as origens em uma única execução de BFS.

```java
Queue<int[]> queue = new LinkedList<>();
// Adicionar todas as múltiplas origens à fila
queue.offer(new int[]{0, 0});
queue.offer(new int[]{0, 1});
queue.offer(new int[]{0, 2});
// Explorar simultaneamente a partir de todas as origens em um único loop while
while (!queue.isEmpty()) {
    int[] cell = queue.poll();
    // Explorar células adjacentes com base nas condições
}
```

### Controle de visitados com boolean[][]

Um array booleano bidimensional é usado para registrar se cada célula já foi alcançada. O valor inicial é false, e as células alcançadas são marcadas como true. Isso evita que a mesma célula seja processada novamente.

```java
boolean[][] reach = new boolean[m][n];  // Array inicializado com false de tamanho m×n
reach[r][c] = true;   // Marcar a célula (r,c) como alcançada
if (!reach[nr][nc])   // Verificar se a célula (nr,nc) ainda não foi alcançada
```

### Vetores de movimento nas 4 direções

Os movimentos para cima, baixo, esquerda e direita em uma grade são representados como um array. Ao iterar pelas 4 direções em um loop, as ramificações para cada direção podem ser escritas sem duplicação de código.

```java
int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};  // direita, esquerda, baixo, cima
for (int[] d : dirs) {
    int nr = r + d[0];  // novo índice de linha
    int nc = c + d[1];  // novo índice de coluna
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m×n) — Cada BFS visita cada célula no máximo uma vez, e o BFS é executado 2 vezes |
| Space | O(m×n) — Os dois arrays booleanos e a fila do BFS armazenam no máximo m×n células cada |

## Código

```java
// Entrada: matriz de inteiros heights de tamanho m×n (altura de cada célula)
// Saída: retorna as coordenadas das células que podem drenar para ambos os oceanos como List<List<Integer>>

// Vetores de movimento nas 4 direções: cima, baixo, esquerda, direita
int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};

// Executa BFS com múltiplas origens e retorna um array booleano das células alcançáveis
boolean[][] bfs(int[][] h, Queue<int[]> q) {
    int m = h.length, n = h[0].length;
    // Array que registra se cada célula é alcançável por fluxo reverso a partir do oceano
    boolean[][] reach = new boolean[m][n];

    // Marcar todas as origens na fila como alcançadas (células de fronteira estão diretamente adjacentes ao oceano)
    for (int[] c : q)
        reach[c[0]][c[1]] = true;

    while (!q.isEmpty()) {
        int[] cell = q.poll();
        int r = cell[0], c = cell[1];

        // Verificar as células adjacentes nas 4 direções
        for (int[] d : dirs) {
            int nr = r + d[0];
            int nc = c + d[1];

            // Se está dentro dos limites, não foi alcançada e a altura é maior ou igual à atual (fluxo reverso possível), expandir a busca
            // A condição de altura maior ou igual à atual representa o inverso de "a água flui de locais mais altos para mais baixos"
            if (nr >= 0 && nr < m
                && nc >= 0 && nc < n
                && !reach[nr][nc]
                && h[nr][nc] >= h[r][c]) {
                reach[nr][nc] = true;
                q.offer(new int[]{nr, nc});
            }
        }
    }
    return reach;
}

List<List<Integer>> pacificAtlantic(int[][] heights) {
    int m = heights.length;
    int n = heights[0].length;

    // Criar filas para o Pacífico e o Atlântico (conjuntos de origens para Multi-source BFS)
    Queue<int[]> pQ = new LinkedList<>();
    Queue<int[]> aQ = new LinkedList<>();

    // A borda superior está diretamente adjacente ao Pacífico, então é origem do Pacífico; a borda inferior está diretamente adjacente ao Atlântico, então é origem do Atlântico
    for (int j = 0; j < n; j++) {
        pQ.offer(new int[]{0, j});
        aQ.offer(new int[]{m - 1, j});
    }

    // A borda esquerda está diretamente adjacente ao Pacífico, então é origem do Pacífico; a borda direita está diretamente adjacente ao Atlântico, então é origem do Atlântico
    for (int i = 0; i < m; i++) {
        pQ.offer(new int[]{i, 0});
        aQ.offer(new int[]{i, n - 1});
    }

    // Executar BFS de fluxo reverso a partir de cada oceano e obter os conjuntos de células alcançáveis
    boolean[][] pacReach = bfs(heights, pQ);
    boolean[][] atlReach = bfs(heights, aQ);

    // Adicionar à lista de resultados as células alcançáveis por ambos os oceanos
    // Ambos serem true significa que a água pode fluir daquela célula tanto para o Pacífico quanto para o Atlântico
    List<List<Integer>> res = new ArrayList<>();
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (pacReach[i][j] && atlReach[i][j])
                res.add(Arrays.asList(i, j));

    return res;
}
```
