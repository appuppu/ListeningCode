# Counting the Number of Islands in a Grid — Contando o número de ilhas em uma grade

## Essência do problema

Uma grade 2D composta por `'1'` (terra) e `'0'` (água) é fornecida. Um conjunto de células de terra adjacentes na horizontal ou na vertical é considerado uma "ilha", e o problema pede para retornar o **número total** de ilhas na grade.

## Ideia central

Se tratarmos cada célula de terra como um nó e unirmos as células de terra adjacentes usando Union-Find, o número de grupos independentes (raízes) que restarem no final será exatamente o número de ilhas.

## Processo de raciocínio

1. **Ilhas são "componentes conexos"**: Como um conjunto de células de terra adjacentes forma uma ilha, este problema se reduz a encontrar o número de componentes conexos em uma grade
2. **Union-Find é adequado para gerenciar componentes conexos**: Union-Find realiza as operações de "unir dois elementos no mesmo grupo" e "verificar se dois elementos pertencem ao mesmo grupo" em tempo praticamente O(1). Ao tratar cada célula de terra da grade como um elemento, basta unir sequencialmente as células adjacentes para obter os componentes conexos
3. **Converter células da grade 2D em índices 1D**: Como o array do Union-Find é unidimensional, a célula `(i, j)` é convertida em um único inteiro por `i * n + j` (onde n é o número de colunas). Isso permite tratar as células da grade 2D como elementos do Union-Find
4. **Contar as células de terra na inicialização**: O `parent` de cada célula de terra é definido como ela mesma, e `count` (número de ilhas) é inicializado com o número total de células de terra. Neste ponto, cada célula de terra é uma ilha independente
5. **Reduzir o número de ilhas ao unir células adjacentes**: A grade é percorrida, e para cada célula de terra, se a célula adjacente à direita ou abaixo também for terra, a operação `union` é executada. Cada vez que `union` une dois grupos diferentes, `count` é decrementado em 1. Verificar apenas a direita e abaixo é suficiente, pois a esquerda e acima já foram processadas durante a varredura de células anteriores, cobrindo todas as relações de adjacência
6. **O count final é a resposta**: O valor de `count` após todas as uniões representa o número de componentes conexos independentes, ou seja, o número de ilhas

## Conhecimentos prévios

### O que é Union-Find (estrutura de dados de conjuntos disjuntos)

É uma estrutura de dados que gerencia múltiplos elementos divididos em grupos. Ela oferece duas operações: "unir dois elementos no mesmo grupo (union)" e "descobrir a qual grupo um elemento pertence (find)". O array `parent` gerencia o pai de cada elemento, e os grupos são representados como uma estrutura de árvore.

```java
int[] parent = new int[n];   // parent[i] = pai do elemento i
int[] rank = new int[n];     // rank[i] = limite superior da altura da árvore com raiz no elemento i

// Inicialização: definir o pai de cada elemento como ele mesmo (cada elemento é um grupo independente)
for (int i = 0; i < n; i++)
    parent[i] = i;
```

### O que é compressão de caminho (Path Compression)

É uma técnica de otimização que, durante a operação `find`, redireciona o pai de todos os nós ao longo do caminho de busca diretamente para a raiz. Após encontrar a raiz recursivamente, o pai é atualizado para a raiz com `parent[x] = find(parent[x])`. Isso faz com que chamadas subsequentes de `find` se aproximem de O(1).

```java
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);  // Redirecionar o pai para a raiz
    return parent[x];
}
```

### O que é união por rank (Union by Rank)

É uma técnica que, durante a operação `union`, conecta a árvore de menor altura (rank) sob a árvore de maior altura. Isso suprime o aumento da altura da árvore e mantém a eficiência de busca do `find`. Somente quando ambos os ranks são iguais, o rank é incrementado em 1 após a união.

```java
void union(int x, int y) {
    int rx = find(x), ry = find(y);  // Encontrar a raiz de cada um
    if (rx == ry) return;            // Se já estão no mesmo grupo, não fazer nada
    if (rank[rx] < rank[ry])         // Conectar o de menor rank sob o de maior rank
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;                  // Incrementar o rank somente quando os ranks são iguais
    }
}
```

### Conversão de índice 2D para índice 1D

Fórmula para converter a célula `(i, j)` de uma grade 2D em um índice de array unidimensional. Sendo `n` o número de colunas, a conversão é feita por `id = i * n + j`, resultando em um inteiro único.

```java
int m = 3, n = 4;          // Grade de 3 linhas e 4 colunas
int id = i * n + j;        // Célula (1, 2) → 1 * 4 + 2 = 6
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m × n × α(m × n)) — Todas as células são percorridas, e em cada célula são realizadas no máximo 2 operações de union/find. α é a inversa da função de Ackermann, que na prática pode ser considerada uma constante |
| Space | O(m × n) — O array parent e o array rank armazenam m × n elementos cada |

## Código

```java
// Entrada: char[][] grid composto por '1' (terra) e '0' (água)
// Saída: retorna o número de ilhas na grade como int

int[] parent;
int[] rank;
int count;

// find com compressão de caminho: retorna a raiz do elemento x e redireciona o pai de todos os nós no caminho para a raiz
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);
    return parent[x];
}

// União por rank: une dois elementos no mesmo grupo e decrementa count em 1 em caso de sucesso
void union(int x, int y) {
    int rx = find(x), ry = find(y);
    if (rx == ry) return;       // Se já estão no mesmo grupo, não fazer nada
    if (rank[rx] < rank[ry])
        parent[rx] = ry;       // Conectar o de menor rank sob o de maior rank
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;             // Incrementar o rank somente quando os ranks são iguais
    }
    count--;                    // Dois grupos foram unidos em um, então decrementar o número de ilhas em 1
}

public int numIslandsUF(char[][] grid) {
    // Obter o número de linhas m e o número de colunas n da grade
    int m = grid.length;
    int n = grid[0].length;
    // Criar o array parent e o array rank com tamanho m * n
    parent = new int[m * n];
    rank = new int[m * n];
    // Inicializar o número de ilhas com 0 (o número de células de terra será contado na varredura seguinte)
    count = 0;

    // Inicialização: definir o pai de cada célula de terra como ela mesma (i * n + j) e definir count como o número total de células de terra
    // Neste ponto, cada célula de terra é uma ilha independente
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            parent[i * n + j] = i * n + j;  // Converter o índice 2D para 1D e definir o pai como ele mesmo
            count++;                          // Incrementar count em 1 para cada célula de terra
        }

    // Para cada célula de terra, unir com a célula adjacente à direita e abaixo se forem terra
    // Motivo de verificar apenas as direções direita e abaixo: esquerda e acima já foram processadas durante a varredura de células anteriores
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            int id = i * n + j;              // Calcular o índice 1D da célula atual
            if (j + 1 < n && grid[i][j + 1] == '1')
                union(id, id + 1);           // Unir com a célula de terra à direita (id + 1 é o índice 1D da célula à direita)
            if (i + 1 < m && grid[i + 1][j] == '1')
                union(id, id + n);           // Unir com a célula de terra abaixo (id + n é o índice 1D da célula abaixo)
        }

    // count foi decrementado em 1 a cada união bem-sucedida a partir do valor inicial (número total de células de terra), e o valor final é o número de ilhas
    return count;
}
```
