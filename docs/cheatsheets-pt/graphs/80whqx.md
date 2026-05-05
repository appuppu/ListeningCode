# Encontrando a Maior Ilha por Área — Encontrar a ilha com a maior área em um grid 2D

## Essência do Problema

É dado um grid binário 2D composto por `1` (terra) e `0` (água). Uma ilha é um grupo de células `1` conectadas adjacentemente nas direções cima, baixo, esquerda e direita. Entre todas as ilhas no grid, encontre e retorne a **maior área** (número de células). Se não existir nenhuma ilha, retorne `0`.

## Ideia Central

Ao contar as células de terra conectadas a partir de cada célula de terra usando DFS, é possível obter a área da ilha. Em vez de gerenciar as células visitadas com um array separado, reescrevemos o valor da célula visitada para `0`, evitando visitas duplicadas sem memória adicional.

## Processo de Raciocínio

1. **A área da ilha é o tamanho do componente conectado**: Um grupo de `1` conectados nas direções cima, baixo, esquerda e direita no grid constitui uma ilha. A área da ilha é o número de células contidas nesse grupo. Portanto, basta calcular o tamanho de cada componente conectado e retornar o valor máximo
2. **DFS é adequada para explorar componentes conectados**: Se uma célula `(r, c)` é `1`, iniciamos uma DFS a partir dela, explorando recursivamente as células adjacentes nas quatro direções, e contamos todos os `1` conectados para obter a área dessa ilha
3. **É necessário um mecanismo para não contar a mesma célula várias vezes**: Se revisitarmos uma célula já visitada durante a DFS, a área será contada em duplicidade. Normalmente, prepara-se um array `boolean[][] visited` para registrar as células visitadas, mas isso requer memória adicional de O(m × n)
4. **Reescrever células visitadas para `0` elimina a necessidade de memória adicional**: Ao alterar o valor da célula visitada pela DFS de `1` para `0`, essa célula é tratada como água e não será revisitada nas explorações seguintes. Isso permite evitar duplicações sem usar um array `visited`, reduzindo a memória auxiliar para O(1)
5. **Agregar a área pelo valor de retorno da DFS**: A DFS retorna o `1` da própria célula visitada (contagem) somado aos valores de retorno das chamadas recursivas nas quatro direções. Como condição base, células fora dos limites do grid ou com valor `0` retornam `0`. Assim, uma única chamada de DFS agrega recursivamente a área total da ilha
6. **Percorrer todo o grid para encontrar o valor máximo**: Percorremos todas as células do grid com um loop duplo e chamamos a DFS para cada célula. Comparamos o valor de retorno da DFS (área da ilha) com o valor máximo atual e mantemos o maior. Para células com valor `0`, a condição base da DFS retorna imediatamente `0`, portanto nenhuma ramificação especial é necessária

## Conhecimentos Prévios

### O que é DFS (Busca em Profundidade)

É um algoritmo de exploração para grafos e grids. Parte de um nó e avança o mais profundamente possível antes de retroceder. Em um grid 2D, ao mover-se recursivamente de uma célula para as células adjacentes nas quatro direções, é possível visitar todas as células conectadas.

```java
// Estrutura básica de DFS em um grid 2D
void dfs(int[][] grid, int r, int c) {
    if (r < 0 || r >= grid.length || c < 0 || c >= grid[0].length)
        return;                    // Termina se estiver fora dos limites do grid
    dfs(grid, r - 1, c);          // Recursão para cima
    dfs(grid, r + 1, c);          // Recursão para baixo
    dfs(grid, r, c - 1);          // Recursão para a esquerda
    dfs(grid, r, c + 1);          // Recursão para a direita
}
```

### O que é In-place Modification (Modificação no Local)

É uma técnica que registra o estado modificando os próprios dados de entrada, sem utilizar estruturas de dados adicionais (como arrays ou conjuntos). Neste problema, reescrevemos as células de terra visitadas para `0`, substituindo o array `visited`.

```java
grid[r][c] = 0;  // Reescreve a terra visitada (1) para água (0)
```

### O que é Math.max

É um método padrão do Java que compara dois valores e retorna o maior. É usado em situações onde o valor máximo é atualizado continuamente dentro de um loop.

```java
Math.max(3, 7);   // → 7 (retorna o maior)
Math.max(10, 2);  // → 10
```

## Complexidade

| | Valor |
|---|---|
| Tempo | O(m × n) — Cada célula do grid é visitada no máximo 2 vezes (1 vez no loop, 1 vez na DFS) |
| Espaço | O(1) de memória auxiliar — O grid é modificado diretamente sem usar um array visited. Porém, a pilha de recursão utiliza no máximo O(m × n) |

## Código

```java
// Entrada: array 2D de inteiros grid composto por 1 (terra) e 0 (água)
// Saída: retorna a área da maior ilha no grid como int. Se não houver ilhas, retorna 0

// DFS: conta as células de terra conectadas e reescreve as células visitadas para 0
int dfs(int[][] grid, int r, int c) {
    // Condição base: não conta se estiver fora dos limites ou for água (0) / já visitada
    if (r < 0 || r >= grid.length
        || c < 0 || c >= grid[0].length
        || grid[r][c] == 0)
        return 0;

    // Reescreve a terra (1) para água (0) como visitada (in-place modification torna o array visited desnecessário)
    grid[r][c] = 0;

    // Retorna 1 (a própria célula) + a soma das células conectadas nas quatro direções
    // Ao somar os valores de retorno das recursões nas 4 direções, a área total da ilha é agregada recursivamente
    return 1 + dfs(grid, r - 1, c)   // cima
             + dfs(grid, r + 1, c)   // baixo
             + dfs(grid, r, c - 1)   // esquerda
             + dfs(grid, r, c + 1);  // direita
}

int maxAreaOfIsland(int[][] grid) {
    // Obtém o número de linhas e colunas do grid
    int m = grid.length;
    int n = grid[0].length;
    // Inicializa a variável de área máxima com 0 (se não houver ilhas, este valor é retornado diretamente)
    int maxArea = 0;

    // Percorre todas as células com um loop duplo e encontra o valor máximo da área de cada ilha
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            // Para células com valor 0, a condição base da DFS retorna imediatamente 0, portanto nenhuma ramificação especial é necessária
            maxArea = Math.max(maxArea,
                dfs(grid, i, j));

    return maxArea;
}
```
