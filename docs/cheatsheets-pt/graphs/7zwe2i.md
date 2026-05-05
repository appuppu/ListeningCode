# Capturing Surrounded Regions on a Board — Capturar regiões cercadas em um tabuleiro

## Essência do problema

É dado um tabuleiro de m×n composto por `'X'` e `'O'`. O objetivo é inverter para `'X'` todas as regiões de `'O'` que estão **completamente cercadas** por `'X'`. Porém, os `'O'` que estão na **borda** do tabuleiro e os `'O'` conectados a eles não estão cercados, portanto não devem ser invertidos.

## Ideia central

Em vez de "procurar os O cercados", adota-se a abordagem inversa: "marcar primeiro os O que não estão cercados (= O alcançáveis a partir da borda), e os O restantes são todos cercados". A partir dos O na borda, marca-se as células conectadas como seguras via DFS, e por fim faz-se uma varredura única do tabuleiro, separando a determinação da inversão.

## Processo de raciocínio

1. **Considerar as características dos O não cercados**: A condição para que um `'O'` não seja capturado é que ele esteja na borda do tabuleiro ou esteja conectado a um `'O'` da borda por adjacência horizontal/vertical. Em outras palavras, todo `'O'` que não é alcançável a partir de um `'O'` na borda está cercado
2. **Iniciar a busca a partir da borda**: Percorrer as 4 bordas do tabuleiro (superior, inferior, esquerda, direita) e, sempre que um `'O'` for encontrado, executar DFS a partir dele. Todos os `'O'` alcançáveis pela DFS são "seguros (não capturáveis)"
3. **Distinguir as células seguras com um marcador**: Substituir temporariamente os `'O'` visitados pela DFS pelo marcador `'S'` (Safe). Assim, após o término da DFS, os `'O'` restantes no tabuleiro são apenas as células "ainda não marcadas = cercadas"
4. **Realizar a inversão e restauração com uma varredura única do tabuleiro**: Percorrer todas as células: as que permanecem como `'O'` estão cercadas e são invertidas para `'X'`; as que estão como `'S'` são `'O'` seguros e são restauradas para `'O'`; as que estão como `'X'` permanecem inalteradas
5. **Estrutura recursiva da DFS**: A partir de cada célula, explora-se recursivamente nas 4 direções (cima, baixo, esquerda, direita). A verificação de limites e a interrupção em células que não são `'O'` também servem como controle de visitados (células já convertidas para `'S'` não são `'O'`, portanto não são revisitadas)

## Conhecimentos prévios

### O que é DFS (Busca em Profundidade)

É um algoritmo para explorar grafos ou grids. Partindo de um ponto, avança-se o mais profundamente possível em uma direção e, ao chegar a um beco sem saída, retrocede-se para tentar outra direção. Pode ser implementado naturalmente com chamadas recursivas. Em um grid, visita-se recursivamente as 4 direções (cima, baixo, esquerda, direita).

```java
// Padrão básico de DFS em um grid
void dfs(char[][] grid, int r, int c) {
    if (r < 0 || r >= grid.length          // Verificação de limites
        || c < 0 || c >= grid[0].length
        || grid[r][c] != 'O')              // Interrompe em célula fora do alvo
        return;
    grid[r][c] = 'S';                      // Marca como visitado (também previne revisita)
    dfs(grid, r + 1, c);                   // Baixo
    dfs(grid, r - 1, c);                   // Cima
    dfs(grid, r, c + 1);                   // Direita
    dfs(grid, r, c - 1);                   // Esquerda
}
```

### Como percorrer as células da borda

Para enumerar as células das 4 bordas de um tabuleiro m×n, percorre-se as colunas para as bordas superior e inferior, e as linhas para as bordas esquerda e direita.

```java
int m = board.length;    // Número de linhas
int n = board[0].length; // Número de colunas

// Percorrer todas as colunas da borda superior (linha 0) e inferior (linha m-1)
for (int j = 0; j < n; j++) {
    process(board[0][j]);      // Borda superior
    process(board[m - 1][j]);  // Borda inferior
}
// Percorrer todas as linhas da borda esquerda (coluna 0) e direita (coluna n-1)
for (int i = 0; i < m; i++) {
    process(board[i][0]);      // Borda esquerda
    process(board[i][n - 1]);  // Borda direita
}
```

### O que é a técnica de marcador

É uma técnica que substitui temporariamente as células do tabuleiro por outro caractere (neste caso `'S'`) para distinguir entre "visitado" e "não visitado". Em vez de preparar um array de visitados `boolean[][]` separado, utiliza-se o próprio tabuleiro para gerenciamento de estado. Ao final do processamento, o marcador é restaurado ao valor original.

## Complexidade

| | Valor |
|---|---|
| Time | O(m × n) — A DFS a partir da borda visita cada célula no máximo uma vez, e a varredura final também percorre todas as células uma vez |
| Space | O(m × n) — A pilha de chamadas recursivas da DFS pode atingir a profundidade de todas as células no pior caso |

## Código

```java
// Entrada: array de caracteres 2D board de m×n composto por 'X' e 'O'
// Saída: modifica board in-place. Inverte os 'O' cercados para 'X' e não retorna valor (void)

// DFS que substitui por marcador S os O alcançáveis a partir da borda
void dfs(char[][] board, int r, int c, int m, int n) {
    // Se está fora dos limites ou não é 'O', não faz nada (células já marcadas como 'S' também são rejeitadas)
    // Células já convertidas para 'S' não são 'O', portanto não são revisitadas
    if (r < 0 || r >= m
        || c < 0 || c >= n
        || board[r][c] != 'O')
        return;

    // Substitui pelo marcador de segurança S (também serve como marca de visitado)
    // Em vez de preparar um boolean[][] separado, utiliza o próprio tabuleiro para gerenciamento de estado
    board[r][c] = 'S';

    // Explora recursivamente nas 4 direções (cima, baixo, esquerda, direita)
    dfs(board, r + 1, c, m, n);
    dfs(board, r - 1, c, m, n);
    dfs(board, r, c + 1, m, n);
    dfs(board, r, c - 1, m, n);
}

public void solve(char[][] board) {
    // Obtém o número de linhas e colunas. Usado para verificação de limites e percorrimento da borda
    int m = board.length;     // Número de linhas
    int n = board[0].length;  // Número de colunas

    // Inicia DFS de borda a partir de cada coluna das bordas superior e inferior
    // A DFS só processa quando a célula alvo é 'O', portanto retorna imediatamente para células 'X'
    for (int j = 0; j < n; j++) {
        dfs(board, 0, j, m, n);       // Borda superior
        dfs(board, m - 1, j, m, n);   // Borda inferior
    }

    // Inicia DFS de borda a partir de cada linha das bordas esquerda e direita
    // Combinado com o loop acima, cobre todas as 4 bordas do tabuleiro como pontos de partida
    for (int i = 0; i < m; i++) {
        dfs(board, i, 0, m, n);       // Borda esquerda
        dfs(board, i, n - 1, m, n);   // Borda direita
    }

    // Realiza a inversão e restauração com uma varredura única do tabuleiro
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (board[i][j] == 'O')
                board[i][j] = 'X';        // O não alcançável a partir da borda = O cercado é invertido para X
            else if (board[i][j] == 'S')
                board[i][j] = 'O';        // O alcançável a partir da borda = marcador de segurança é restaurado para O original
            // Células 'X' não são alteradas
        }
    }
}
```
