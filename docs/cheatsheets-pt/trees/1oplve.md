# Finding the Diameter of a Binary Tree — Encontrar o caminho mais longo (número de arestas) em uma árvore binária

## Essência do Problema

É dado o `root` de uma árvore binária. Retornar o comprimento (número de arestas) do caminho mais longo entre quaisquer dois nós na árvore. Este caminho não precisa passar pela raiz.

## Ideia Central

Para qualquer nó, "altura da subárvore esquerda + altura da subárvore direita + 2" é o número de arestas do caminho mais longo que passa por esse nó. Ao calcular a altura de cada nó com DFS e rastrear o valor máximo, o diâmetro é obtido em uma única travessia.

## Processo de Raciocínio

1. **O diâmetro passa por algum nó como "vértice"**: O caminho mais longo sempre passa por exatamente um nó como o ponto mais alto (ponto de inflexão), indo de algum lugar na subárvore esquerda desse nó até algum lugar na subárvore direita. Portanto, calculamos "o comprimento do caminho que tem esse nó como vértice" para cada nó, e o valor máximo é o diâmetro
2. **O comprimento do caminho que passa pelo vértice é determinado pelas alturas esquerda e direita**: O número de arestas do caminho que tem um nó como vértice é calculado como "altura da subárvore esquerda + altura da subárvore direita + 2". A altura esquerda é o número de arestas até o nó mais profundo do lado esquerdo, a altura direita é o número de arestas até o nó mais profundo do lado direito, e soma-se +2 porque uma aresta é adicionada do vértice para cada lado
3. **Ajustar a definição de altura ao "número de arestas"**: Definindo a altura de um nó como "o número de arestas do nó até a folha mais distante", a altura de um nó folha é 0 e a altura de um nó null é -1. Ao definir null como -1, a altura de um nó folha é calculada naturalmente como `1 + max(-1, -1) = 0`
4. **Atualizar o diâmetro enquanto retorna a altura com DFS**: Usando DFS em pós-ordem, obtemos recursivamente a altura dos filhos esquerdo e direito de cada nó. A partir das alturas esquerda e direita obtidas, calculamos "o comprimento do caminho que tem esse nó como vértice" e atualizamos a variável global `maxDiameter`, retornando como valor de retorno a própria altura do nó `1 + max(left, right)`
5. **Rastrear o valor máximo com uma variável global**: O valor de retorno do DFS é a "altura" e não o "diâmetro", então o valor máximo do diâmetro é registrado na variável global `maxDiameter`. Em cada nó, comparamos `left + right + 2` com o `maxDiameter` atual e mantemos o maior
6. **O que retornar no final**: Após o DFS percorrer todos os nós, o valor armazenado em `maxDiameter` é o diâmetro de toda a árvore

## Conhecimento Prévio

### O que é a altura (height) de uma árvore binária

O número de arestas no caminho de um nó até o nó folha mais distante. A altura de um nó folha é definida como 0, e a altura de um nó null é definida como -1. A altura de um nó pai é obtida por `1 + max(altura do filho esquerdo, altura do filho direito)`.

```
      1          Altura do nó 1: 2 (arestas de 1→2→4)
     / \         Altura do nó 2: 1 (arestas de 2→4)
    2   3        Altura do nó 3: 0 (nó folha)
   /             Altura do nó 4: 0 (nó folha)
  4
```

### O que é DFS (Busca em Profundidade) por recursão

Uma técnica que visita cada nó da árvore recursivamente. Na pós-ordem, o processamento ocorre na sequência: filho esquerdo → filho direito → próprio nó. É adequada quando se precisa usar os resultados dos filhos para calcular o valor do pai.

```java
int dfs(TreeNode node) {
    if (node == null) return -1;   // Caso base: nó null tem altura -1
    int left = dfs(node.left);     // Processar a subárvore esquerda recursivamente
    int right = dfs(node.right);   // Processar a subárvore direita recursivamente
    return 1 + Math.max(left, right);  // Calcular e retornar a própria altura
}
```

### O que é Math.max

Um método padrão do Java que retorna o maior entre dois valores.

```java
Math.max(3, 5);    // → 5
Math.max(-1, -1);  // → -1
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta realizar um único DFS que visita todos os nós uma vez |
| Space | O(n) — A pilha de chamadas recursivas pode ter no máximo n níveis (no caso de uma árvore degenerada) |

## Código

```java
// Entrada: nó raiz root de uma árvore binária
// Saída: retornar o diâmetro da árvore (número de arestas do caminho mais longo entre quaisquer 2 nós) como int

// Variável global que mantém o diâmetro máximo encontrado durante a travessia DFS
// O valor inicial é 0 porque o diâmetro de uma árvore com apenas um nó é 0
int maxDiameter = 0;

// Função recursiva que retorna a altura de cada nó e, como efeito colateral, atualiza maxDiameter
int dfs(TreeNode node) {
    // A altura de um nó null é -1 (representa que não existem arestas)
    // Retornar -1 faz com que a altura do pai (nó folha) seja corretamente calculada como 1 + max(-1, -1) = 0
    if (node == null) return -1;

    // Obter recursivamente a altura da subárvore esquerda
    int left = dfs(node.left);
    // Obter recursivamente a altura da subárvore direita
    int right = dfs(node.right);

    // Atualizar o valor máximo do diâmetro com o número de arestas do caminho que tem o nó atual como vértice (left + right + 2)
    // +2 porque adicionamos as 2 arestas do nó atual para os filhos esquerdo e direito
    maxDiameter = Math.max(
        maxDiameter,
        left + right + 2);

    // Retornar a altura do nó atual para o pai (note que isto é a altura, não o diâmetro)
    // Este é o valor que o nó pai usa para calcular o comprimento do seu próprio caminho
    return 1 + Math.max(left, right);
}

public int diameterOfBinaryTree(TreeNode root) {
    // Percorrer todos os nós com DFS e atualizar maxDiameter a partir do comprimento do caminho que tem cada nó como vértice
    dfs(root);
    // O maxDiameter após a travessia completa é o diâmetro de toda a árvore
    return maxDiameter;
}
```
