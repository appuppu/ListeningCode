# Counting Connected Components in an Undirected Graph — Contar o número de componentes conexos em um grafo não direcionado

## Essência do problema

São dados `n` nós rotulados de `0` a `n-1` e uma lista de arestas não direcionadas `edges`. O objetivo é retornar o **número de componentes conexos (connected components)** no grafo como um inteiro. Um componente conexo é um conjunto de nós que são mutuamente alcançáveis percorrendo as arestas.

## Ideia central

Inicialmente, cada nó é considerado um componente conexo independente. As arestas são processadas uma a uma, unificando os grupos aos quais os nós de cada extremidade pertencem. O número de grupos restantes após processar todas as arestas é o número de componentes conexos.

## Processo de raciocínio

1. **Nós conectados por uma aresta pertencem ao mesmo grupo**: Como um componente conexo é "o conjunto de nós alcançáveis percorrendo arestas", dois nós unidos por uma aresta necessariamente pertencem ao mesmo componente conexo. Repetindo a operação de "agrupar os nós de ambas as extremidades no mesmo grupo" para todas as arestas, obtemos os componentes conexos finais
2. **Union-Find é adequado para gerenciar grupos**: Union-Find é a estrutura de dados que realiza de forma eficiente "unificar dois elementos no mesmo grupo (union)" e "verificar a qual grupo um elemento pertence (find)". Cada nó possui um "nó pai", e nós com a mesma raiz (root) são considerados do mesmo grupo
3. **No estado inicial, cada nó tem a si mesmo como pai**: Ao inicializar com `parent[i] = i`, cada um dos n nós começa como um grupo independente (componente conexo). O número inicial de componentes conexos é `n`
4. **A cada aresta processada, realiza-se union e, se houver unificação, o número de componentes diminui**: Para cada aresta `[a, b]`, encontram-se as raízes de `a` e `b`. Se as raízes forem diferentes, os dois pertencem a grupos distintos, então a raiz de um é tornada filha da raiz do outro para unificá-los, e o número de componentes conexos é reduzido em 1. Se as raízes forem iguais, já pertencem ao mesmo grupo e nada é feito
5. **Compressão de caminho e rank aceleram as operações**: Durante o find, aplica-se compressão de caminho (path compression), que redireciona o pai dos nós visitados diretamente para a raiz. Durante o union, comparam-se os ranks (limite superior da altura da árvore) e a árvore mais baixa é colocada sob a mais alta (union by rank). Isso faz com que a complexidade do find seja praticamente O(1) (precisamente O(α(V)))
6. **O valor de `components` após processar todas as arestas é a resposta**: O resultado de subtrair 1 do valor inicial `n` cada vez que um union é bem-sucedido é o número final de componentes conexos

## Conhecimentos prévios

### O que é Union-Find (estrutura de dados de conjuntos disjuntos)

É uma estrutura de dados que gerencia elementos divididos em grupos. Fornece duas operações: "unificar dois elementos no mesmo grupo (union)" e "encontrar o representante (raiz) do grupo ao qual um elemento pertence (find)". O array `parent` registra o pai de cada elemento, e o representante do grupo é identificado seguindo os pais até a raiz.

```java
int[] parent = new int[n];   // parent[i] armazena o nó pai do nó i
for (int i = 0; i < n; i++)
    parent[i] = i;            // Estado inicial: cada nó tem a si mesmo como pai (grupo independente)
```

### O que é Compressão de Caminho (Path Compression)

É uma técnica de otimização que, durante o processo recursivo de find, redireciona o pai de todos os nós visitados diretamente para a raiz. Isso faz com que chamadas subsequentes de find retornem a raiz imediatamente, e a árvore é achatada, melhorando a complexidade para praticamente O(1).

```java
int find(int[] parent, int x) {
    if (parent[x] != x)
        parent[x] = find(parent, parent[x]);  // Encontra a raiz recursivamente e redireciona o pai para a raiz
    return parent[x];                          // Retorna a raiz
}
```

### O que é Union por Rank

É uma técnica que, durante o union, compara o limite superior da altura da árvore (rank) e coloca a árvore com rank menor sob a árvore com rank maior. Isso suprime o aumento da altura da árvore, mantendo a eficiência do find. Somente quando os ranks são iguais, o rank do destino da unificação é incrementado em 1.

```java
int[] rank = new int[n];     // rank[i] é o limite superior da altura da árvore com raiz no nó i (valor inicial é 0)
// Tornar o de rank maior como pai → a árvore dificilmente se torna profunda
if (rank[r1] > rank[r2])
    parent[r2] = r1;         // Coloca a árvore de r2 sob r1
```

### O que é α (inversa da função de Ackermann)

É uma função que aparece na complexidade do Union-Find. Para tamanhos de entrada práticos, α(V) é sempre 5 ou menos, podendo ser considerada efetivamente uma constante. Por isso, cada operação do Union-Find funciona em praticamente O(1).

## Complexidade

| | Valor |
|---|---|
| Time | O(V + E · α(V)) — O(V) para inicialização; find e union são realizados para cada aresta, mas como α(V) é praticamente uma constante, é efetivamente O(V + E) |
| Space | O(V) — O array parent e o array rank armazenam V elementos cada |

## Código

```java
// Entrada: número de nós n e lista de arestas edges (cada aresta é um array de 2 elementos [a, b])
// Saída: retorna o número de componentes conexos como um inteiro

// Função find com compressão de caminho: retorna a raiz do grupo ao qual o nó x pertence
int find(int[] parent, int x) {
    if (parent[x] != x)
        // Encontra a raiz recursivamente e redireciona o pai diretamente para a raiz (compressão de caminho)
        // Isso faz com que chamadas subsequentes de find retornem a raiz imediatamente
        parent[x] = find(parent, parent[x]);
    return parent[x];
}

int countComponents(int n, int[][] edges) {
    // Array que armazena o pai de cada nó. Inicializado com parent[i] = i, tornando cada nó um grupo independente
    int[] parent = new int[n];
    // Array que armazena o limite superior da altura da árvore com raiz em cada nó (usado para decidir sob qual árvore colocar durante o union)
    int[] rank = new int[n];
    for (int i = 0; i < n; i++)
        parent[i] = i;

    // No estado inicial, cada nó é um componente conexo independente, então o número de componentes é n
    int components = n;

    // Percorre as arestas uma a uma, unificando os grupos aos quais os nós de cada extremidade pertencem
    for (int[] e : edges) {
        // Encontra a raiz do grupo ao qual cada extremidade da aresta pertence (a compressão de caminho redireciona o pai dos nós visitados para a raiz)
        int r1 = find(parent, e[0]);
        int r2 = find(parent, e[1]);

        // Se as raízes forem diferentes, pertencem a grupos distintos e são unificados (se as raízes forem iguais, já pertencem ao mesmo grupo e nada é feito)
        if (r1 != r2) {
            // Compara os ranks e coloca o de menor rank sob o de maior rank (suprime o aumento da altura da árvore)
            if (rank[r1] > rank[r2])
                parent[r2] = r1;
            else if (rank[r1] < rank[r2])
                parent[r1] = r2;
            else {
                // Se os ranks forem iguais, coloca r2 sob r1 e incrementa o rank de r1 em 1
                parent[r2] = r1;
                rank[r1]++;
            }
            // Dois grupos foram unificados em um, então o número de componentes é reduzido em 1
            components--;
        }
    }
    // O valor de components após processar todas as arestas é o número de componentes conexos
    return components;
}
```
