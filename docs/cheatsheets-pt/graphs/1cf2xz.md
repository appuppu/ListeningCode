# Finding the Redundant Edge in a Graph — Encontrar a aresta redundante em um grafo formado ao adicionar uma aresta a uma árvore

## Essência do problema

É dado um grafo formado ao adicionar uma aresta a uma árvore composta por n nós e n-1 arestas, criando exatamente um ciclo. O objetivo é encontrar e retornar a aresta redundante adicionada. Ao remover essa aresta, o grafo volta a ser uma árvore válida.

## Ideia central

Ao processar as arestas uma a uma, se aparecer uma aresta que conecta dois nós que já pertencem ao mesmo componente conexo, essa aresta é a aresta redundante que cria o ciclo. Union-Find é a estrutura ideal para essa verificação.

## Processo de raciocínio

1. **Utilizar as propriedades da árvore**: Uma árvore é uma estrutura que conecta n nós com n-1 arestas e não possui ciclos. Ao adicionar uma aresta, exatamente um ciclo é formado. Portanto, basta detectar a aresta que gera o ciclo durante o processo de adição sequencial das arestas
2. **Considerar a condição de detecção de ciclo**: Ao adicionar a aresta (u, v), se u e v já pertencem ao mesmo componente conexo, essa aresta forma um ciclo. Por outro lado, se u e v pertencem a componentes conexos diferentes, a aresta apenas unifica os dois componentes sem criar um ciclo
3. **Union-Find é adequado para gerenciar componentes conexos**: Union-Find é a estrutura de dados que realiza de forma eficiente a verificação "dois nós pertencem ao mesmo componente conexo?" e a operação "unificar dois componentes conexos". A operação find compara as raízes para determinar se pertencem ao mesmo componente, e a operação union unifica os componentes
4. **Otimização do Union-Find**: A compressão de caminho (path compression) reconecta os nós diretamente à raiz a cada operação find. A união por rank mantém a altura da árvore baixa. Com essas duas otimizações, a complexidade de cada operação se torna α(n) (função inversa de Ackermann, praticamente constante)
5. **Processar as arestas em ordem**: O array de arestas é processado do início ao fim, tentando a operação union para cada aresta. A aresta cuja operação union falha (= os nós já pertencem ao mesmo componente) é a aresta redundante, e ela é retornada
6. **O que retornar ao final**: A aresta cuja operação union falhou é retornada como `int[]`. Pela restrição do problema, sempre existe exatamente uma aresta redundante, portanto não há caso em que a resposta não seja encontrada

## Conhecimentos prévios

### O que é Union-Find (estrutura de dados de conjuntos disjuntos)

É uma estrutura de dados que divide múltiplos elementos em grupos (componentes conexos) e realiza de forma eficiente a verificação "dois elementos pertencem ao mesmo grupo?" e a operação "unificar dois grupos". A estrutura de árvore dos grupos é representada pelo array `parent`, e se dois elementos possuem a mesma raiz (representante), eles pertencem ao mesmo grupo.

```java
int[] parent = new int[n + 1];  // parent[i] armazena o pai do nó i
int[] rank = new int[n + 1];    // rank[i] é o limite superior da altura da árvore com raiz no nó i
for (int i = 1; i <= n; i++)
    parent[i] = i;              // No estado inicial, cada nó é seu próprio pai (todos são grupos independentes)
```

### Operação find (com compressão de caminho)

Retorna a raiz (representante) do grupo ao qual o nó x pertence. Percorre os pais recursivamente e reconecta todos os nós no caminho diretamente à raiz (compressão de caminho). Isso acelera as operações find subsequentes.

```java
int find(int[] parent, int x) {
    if (parent[x] != x)                    // Se x não é a raiz
        parent[x] = find(parent, parent[x]); // Percorre os pais recursivamente e reconecta diretamente à raiz
    return parent[x];                       // Retorna a raiz de x
}
```

### Operação union (unificação por rank)

Unifica os grupos aos quais dois nós pertencem. O grupo com rank menor (limite superior da altura da árvore) é conectado abaixo do grupo com rank maior, suprimindo o aumento da altura da árvore. Se os dois nós já pertencem ao mesmo grupo, retorna `false` sem unificar.

```java
boolean union(int[] parent, int[] rank, int x, int y) {
    int rx = find(parent, x);  // Obtém a raiz de x
    int ry = find(parent, y);  // Obtém a raiz de y
    if (rx == ry) return false; // Se pertencem ao mesmo grupo, a unificação é desnecessária → retorna false
    // Conecta o grupo com rank menor abaixo do grupo com rank maior
    if (rank[rx] < rank[ry]) parent[rx] = ry;
    else if (rank[rx] > rank[ry]) parent[ry] = rx;
    else { parent[ry] = rx; rank[rx]++; }  // Se os ranks são iguais, conecta um abaixo do outro e incrementa o rank em 1
    return true;  // Unificação bem-sucedida → retorna true
}
```

### O que é a função inversa de Ackermann α(n)

É a função que expressa a complexidade por operação do Union-Find. α(n) cresce muito lentamente e, para tamanhos de entrada realistas (n < 2^65536), α(n) ≤ 4, sendo assim praticamente considerada constante.

## Complexidade

| | Valor |
|---|---|
| Time | O(n × α(n)) ≈ O(n) — Para cada uma das n arestas, find e union são executados uma vez. Como α(n) é praticamente constante, pode ser considerado O(n) |
| Space | O(n) — Os arrays parent e rank armazenam n+1 elementos cada |

## Código

```java
// Entrada: array de arestas edges (cada elemento é int[]{u, v}, representando uma aresta que conecta o nó u ao nó v)
// Saída: retorna a aresta redundante que forma o ciclo como int[]

// Retorna a raiz do grupo ao qual o nó x pertence (com compressão de caminho)
int find(int[] parent, int x) {
    if (parent[x] != x)
        // Percorre os pais recursivamente e reconecta diretamente à raiz (compressão de caminho)
        parent[x] = find(parent,
            parent[x]);
    return parent[x];
}

// Unifica os grupos aos quais dois nós pertencem. Retorna false se já pertencem ao mesmo grupo
boolean union(int[] parent,
        int[] rank, int x, int y) {
    int rx = find(parent, x); // Obtém a raiz de x
    int ry = find(parent, y); // Obtém a raiz de y
    if (rx == ry) return false; // Já pertencem ao mesmo componente conexo → retorna false pois um ciclo seria formado
    // Conecta o grupo com rank menor abaixo do grupo com rank maior para suprimir o aumento da altura da árvore
    if (rank[rx] < rank[ry])
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        // Se os ranks são iguais, conecta um abaixo do outro e incrementa o rank em 1
        parent[ry] = rx;
        rank[rx]++;
    }
    return true; // Unificação bem-sucedida → nenhum ciclo foi formado
}

public int[] findRedundantConnection(
        int[][] edges) {
    // Número de arestas = número de nós (n-1 arestas da árvore + 1 aresta redundante = n arestas). Os nós são numerados de 1 a n
    int n = edges.length;
    // Inicializa cada nó como um grupo independente (parent[i] = i significa que ele próprio é a raiz)
    int[] parent = new int[n + 1];
    int[] rank = new int[n + 1]; // O array rank pode permanecer com o valor padrão 0
    for (int i = 1; i <= n; i++)
        parent[i] = i;

    // Processa as arestas uma a uma desde o início e detecta a aresta que forma o ciclo
    for (int[] e : edges) {
        // Se union retorna false, e[0] e e[1] já pertencem ao mesmo componente conexo
        // → Esta aresta é a aresta redundante que forma o ciclo, portanto é retornada diretamente
        if (!union(parent, rank,
                e[0], e[1]))
            return e;
    }
    // Pela restrição do problema, sempre existe exatamente uma aresta redundante, portanto este ponto nunca é alcançado
    return new int[0];
}
```
