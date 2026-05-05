# Counting Good Nodes in a Binary Tree — Contar os "nós bons" em uma árvore binária

## Essência do problema

Uma árvore binária é fornecida. Se o valor de um nó for maior ou igual ao valor máximo entre todos os valores no caminho da raiz até esse nó, ele é considerado um "nó bom (good node)". O objetivo é retornar a quantidade de nós bons em toda a árvore.

## Ideia central

Se o "valor máximo até o momento" for carregado ao longo do caminho da raiz até cada nó, é possível determinar se cada nó é um nó bom em O(1). Ao percorrer a árvore com DFS e propagar o valor máximo para os nós filhos, a resposta é obtida visitando todos os nós apenas uma vez.

## Processo de raciocínio

1. **Organizar a condição de julgamento**: Determinar se um nó é bom depende apenas da comparação com o valor máximo no caminho da raiz até esse nó. Ou seja, basta conhecer o valor máximo no caminho para fazer o julgamento
2. **Como gerenciar o valor máximo no caminho**: Ao percorrer a árvore com DFS, a pilha de chamadas recursivas corresponde ao caminho da raiz até o nó atual. Passando o "valor máximo até o momento" como argumento da recursão, cada nó obtém a informação necessária para o julgamento
3. **Definir o processamento em cada nó**: Se o valor do nó atual for maior ou igual ao valor máximo, ele é um nó bom e soma-se 1 ao resultado; caso contrário, soma-se 0. Isso permite realizar o julgamento e a contagem simultaneamente
4. **Atualizar o valor máximo a ser passado para os nós filhos**: O valor máximo passado para os nós filhos é o maior entre o valor máximo atual e o valor do nó atual. Dessa forma, à medida que o caminho se estende, o valor máximo é atualizado de forma monotonicamente não decrescente
5. **Processar as subárvores esquerda e direita recursivamente**: O número de nós bons na subárvore esquerda e na subárvore direita é obtido recursivamente, e o resultado é somado com o resultado do nó atual
6. **Valor máximo na chamada inicial**: O nó raiz é sempre um nó bom (pois ele é o único nó no caminho). Definindo o valor inicial como `Integer.MIN_VALUE`, o valor da raiz será necessariamente maior ou igual a ele, garantindo o julgamento correto

## Conhecimentos prévios

### O que é DFS recursivo (busca em profundidade)

É um algoritmo que percorre árvores ou grafos priorizando a direção mais profunda. Em uma árvore binária, a função recursiva chama a si mesma para o filho esquerdo e o filho direito. A pilha de chamadas recursivas mantém implicitamente o caminho da raiz até o nó atual.

```java
void dfs(TreeNode node) {
    if (node == null) return;  // Caso base: retorna ao alcançar um nó null
    // Processamento do nó atual
    dfs(node.left);            // Percorre a subárvore esquerda recursivamente
    dfs(node.right);           // Percorre a subárvore direita recursivamente
}
```

### O que é Math.max

É um método que retorna o maior entre dois valores. É utilizado para atualizar o valor máximo no caminho.

```java
Math.max(5, 3);    // → 5 (retorna o maior entre 5 e 3)
Math.max(-1, 4);   // → 4
```

### O que é Integer.MIN_VALUE

É o menor valor possível do tipo `int` em Java (-2.147.483.648). Como o valor de qualquer nó será maior ou igual a esse valor, ao usá-lo como valor máximo inicial, o nó raiz é sempre julgado como um nó bom.

```java
Integer.MIN_VALUE;  // → -2147483648 (valor mínimo do tipo int)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Cada nó é visitado exatamente uma vez |
| Space | O(h) — A pilha de chamadas recursivas utiliza espaço proporcional à altura da árvore |

## Código

```java
// Entrada: nó raiz da árvore binária root
// Saída: retorna o número total de nós bons como int

// Função auxiliar: retorna o número de nós bons na subárvore com raiz em node
// maxSoFar representa o valor máximo no caminho da raiz até o nó atual
private int dfs(TreeNode node, int maxSoFar) {
    // Caso base: ao alcançar null, o número de nós bons é 0 (não há nós a contar além das folhas)
    if (node == null) return 0;

    // Determina se o nó atual é um nó bom (é bom se seu valor for maior ou igual ao valor máximo no caminho)
    int result = node.val >= maxSoFar ? 1 : 0;

    // Atualiza o valor máximo a ser passado para os nós filhos (atualiza se o valor do nó atual for maior; caso contrário, mantém o valor máximo anterior)
    int newMax = Math.max(maxSoFar, node.val);

    // Calcula recursivamente o número de nós bons na subárvore esquerda e soma ao resultado
    result += dfs(node.left, newMax);
    // Calcula recursivamente o número de nós bons na subárvore direita e soma ao resultado
    result += dfs(node.right, newMax);

    // Retorna o número total de nós bons em toda a subárvore com raiz no nó atual
    return result;
}

public int goodNodes(TreeNode root) {
    // Ao definir o valor máximo inicial como o menor valor de int, o nó raiz é sempre julgado como um nó bom
    return dfs(root, Integer.MIN_VALUE);
}
```
