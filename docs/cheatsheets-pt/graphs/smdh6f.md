# Filling Distances to the Nearest Gate — Encontrar a distância de cada sala vazia até o portão mais próximo em um grid

## Essência do problema

Um grid m×n é fornecido. Cada célula é uma das seguintes: "parede (−1)", "portão (0)" ou "sala vazia (Integer.MAX_VALUE)". O objetivo é escrever em cada célula de sala vazia a distância até o portão mais próximo. As salas que não conseguem alcançar nenhum portão permanecem com o valor Integer.MAX_VALUE.

## Ideia central

Em vez de procurar o portão mais próximo a partir de cada sala vazia, inicia-se uma BFS simultaneamente a partir de todos os portões. Como cada passo da BFS corresponde às distâncias 1, 2, 3…, a distância mínima de cada célula é determinada no momento em que ela é alcançada pela primeira vez.

## Processo de raciocínio

1. **Procurar portões a partir de cada sala é ineficiente**: Se uma BFS for executada para cada sala vazia, o número de execuções de BFS cresce proporcionalmente ao número de salas, aumentando a complexidade computacional. Invertendo a abordagem e explorando dos portões em direção às salas, é possível obter a distância mínima de todas as salas com uma única execução de BFS usando todos os portões como pontos de partida
2. **Partir de múltiplos portões simultaneamente (Multi-source BFS)**: A BFS é iniciada com todos os portões já inseridos na fila. Dessa forma, todas as salas à distância 1 são processadas primeiro, seguidas pelas salas à distância 2. Devido à propriedade de exploração por níveis da BFS, a distância registrada quando uma sala é alcançada pela primeira vez é a distância mínima
3. **A verificação de visitação pode ser feita pelo valor da célula**: As salas vazias são inicializadas com Integer.MAX_VALUE. Como a BFS escreve a distância nas células alcançadas, apenas as células com valor Integer.MAX_VALUE permanecem não visitadas. Não é necessário preparar um array visited separado
4. **A distância é calculada como valor da célula pai + 1**: O valor da célula retirada da fila (pai) acrescido de 1 se torna a distância da célula adjacente (filha). Como o valor do portão é 0, a sala adjacente recebe 1, a próxima recebe 2, e assim os valores se propagam corretamente
5. **Paredes e posições fora dos limites são simplesmente ignoradas**: Paredes (−1) e portões (0) não possuem o valor Integer.MAX_VALUE, portanto são excluídos naturalmente pela verificação de visitação. Índices fora dos limites são descartados pela verificação de fronteira

## Conhecimentos prévios

### O que é BFS (Busca em Largura)

É um algoritmo que explora grafos ou grids na ordem "do mais próximo ao mais distante". Utilizando uma fila (primeiro a entrar, primeiro a sair), ele processa todos os nós à distância 1 do ponto de partida antes de avançar para os nós à distância 2. Essa propriedade garante a distância mínima até cada nó.

```java
Queue<int[]> queue = new LinkedList<>();  // Cria a fila para BFS
queue.offer(new int[]{0, 0});             // Adiciona as coordenadas do ponto de partida à fila
int[] cell = queue.poll();                // Remove o elemento da frente da fila
queue.isEmpty();                          // Verifica se a fila está vazia → true/false
```

### O que é Multi-source BFS

Na BFS convencional, há apenas um ponto de partida, mas na Multi-source BFS, múltiplos pontos de partida são inseridos na fila antes do início. A exploração avança como ondas se expandindo simultaneamente a partir de todos os pontos de partida, e cada célula registra a distância até o ponto de partida mais próximo.

```java
// Adiciona todos os portões (células com valor 0) à fila como pontos de partida
for (int i = 0; i < m; i++)
    for (int j = 0; j < n; j++)
        if (rooms[i][j] == 0)
            queue.offer(new int[]{i, j});
// Ao iniciar a BFS nesse estado, a exploração começa simultaneamente a partir de todos os portões
```

### Exploração de células adjacentes nas 4 direções

Ao se mover nas 4 direções (cima, baixo, esquerda, direita) em um grid, o uso de um array de vetores de direção torna o código mais conciso. As coordenadas da célula adjacente são obtidas somando cada vetor de direção às coordenadas atuais.

```java
int[][] dirs = {{-1,0},{1,0},{0,-1},{0,1}};  // Vetores de direção: cima, baixo, esquerda, direita
for (int[] d : dirs) {
    int r = cell[0] + d[0];  // Número da linha da célula adjacente
    int c = cell[1] + d[1];  // Número da coluna da célula adjacente
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m × n) — Cada célula é adicionada à fila no máximo uma vez, portanto todas as células são processadas exatamente uma vez |
| Space | O(m × n) — A fila pode conter no máximo m×n células |

## Código

```java
// Entrada: grid de inteiros m×n rooms (−1=parede, 0=portão, Integer.MAX_VALUE=sala vazia)
// Saída: sem valor de retorno (void). O grid rooms é modificado diretamente, armazenando a distância até o portão mais próximo em cada célula de sala vazia
public void wallsAndGates(int[][] rooms) {
    // Obtém o número de linhas do grid
    int m = rooms.length;
    // Se o grid estiver vazio, encerra o processamento
    if (m == 0) return;
    // Obtém o número de colunas do grid
    int n = rooms[0].length;

    // Cria a fila para BFS. Armazena as coordenadas das células {linha, coluna}
    Queue<int[]> q = new LinkedList<>();

    // Percorre todo o grid e adiciona todos os portões (células com valor 0) à fila
    // Com isso, todos os portões são registrados simultaneamente como pontos de partida da BFS (Multi-source BFS)
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (rooms[i][j] == 0)
                q.offer(new int[]{i, j});

    // Vetores de direção representando as 4 direções: cima, baixo, esquerda, direita. Usados para enumerar as células adjacentes em um loop
    int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    // Continua a BFS até que a fila esteja vazia. Devido à propriedade da BFS, as células são processadas em ordem crescente de distância
    while (!q.isEmpty()) {
        // Remove a célula da frente da fila. cell[0] é o número da linha, cell[1] é o número da coluna
        int[] cell = q.poll();

        // Examina as células adjacentes nas 4 direções
        for (int[] d : dirs) {
            // Calcula as coordenadas da célula adjacente somando o vetor de direção
            int r = cell[0] + d[0];
            int c = cell[1] + d[1];

            // Ignora se estiver fora dos limites
            if (r < 0 || r >= m || c < 0 || c >= n) continue;

            // Ignora se o valor não for Integer.MAX_VALUE (parede, portão ou sala com distância já definida)
            // Essa verificação evita revisitas sem a necessidade de um array visited separado
            if (rooms[r][c] != Integer.MAX_VALUE) continue;

            // Escreve a distância da célula pai + 1. Como o portão vale 0, a célula adjacente recebe 1, a próxima recebe 2, propagando-se corretamente
            // Como a BFS processa as células em ordem de distância, a primeira distância alcançada é a distância mínima
            rooms[r][c] = rooms[cell[0]][cell[1]] + 1;
            // Adiciona a célula com distância registrada à fila para explorar as salas seguintes
            q.offer(new int[]{r, c});
        }
    }
}
```
