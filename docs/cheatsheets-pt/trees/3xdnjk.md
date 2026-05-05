# Checking if a Binary Tree is Height-Balanced — Determinar se uma árvore binária é balanceada em altura

## Essência do Problema

Um nó raiz `root` de uma árvore binária é fornecido. O objetivo é determinar se essa árvore é **balanceada em altura (height-balanced)**. Balanceamento em altura significa que, para todos os nós, a diferença entre a altura da subárvore esquerda e a altura da subárvore direita é no máximo 1. O resultado deve ser retornado como `boolean`.

## Ideia Central

Durante o processo recursivo de calcular a altura de cada nó, no momento em que um desequilíbrio é detectado, o valor `-1` é retornado e propagado. Ao realizar o cálculo da altura e a verificação de balanceamento simultaneamente em uma única travessia pós-ordem (post-order traversal), é possível obter a resposta visitando cada nó apenas uma vez.

## Processo de Raciocínio

1. **Capturar a definição de balanceamento recursivamente**: Uma árvore ser balanceada significa que, para todos os nós, a diferença de altura entre as subárvores esquerda e direita é no máximo 1. Ou seja, para verificar o balanceamento de um nó, é necessário obter a "altura" das subárvores esquerda e direita
2. **O cálculo da altura em si é recursivo**: A altura de um nó é obtida por `1 + max(altura esquerda, altura direita)`. Percorrendo a árvore de baixo para cima (em pós-ordem) com essa recursão, a altura de cada nó é obtida naturalmente
3. **Integrar o cálculo da altura com a verificação de balanceamento**: Dentro da função recursiva que retorna a altura, quando a diferença entre as alturas esquerda e direita excede 1, o valor especial `-1` indicando "desequilíbrio" é retornado. Dessa forma, o cálculo da altura e a verificação de balanceamento podem ser realizados simultaneamente em uma única função
4. **Eliminar explorações desnecessárias com término antecipado**: Se o resultado da subárvore esquerda for `-1`, a árvore inteira está desequilibrada sem necessidade de verificar a subárvore direita. O valor de retorno da recursão é verificado a cada chamada, e no momento em que um desequilíbrio é encontrado, `-1` é retornado imediatamente para encerrar a recursão
5. **Utilizar o duplo significado do valor de retorno**: Se o valor de retorno for `0 ou maior`, ele representa uma altura normal; se for `-1`, significa desequilíbrio. O método chamador `isBalanced` obtém a resposta apenas verificando se o valor de retorno final não é `-1`

## Conhecimentos Prévios

### O que é a altura (height) de uma árvore binária

O número de arestas desde um nó até o nó folha mais distante. A altura de um nó folha é 1 (quando contada em número de nós), e a altura de `null` é 0. Recursivamente, é obtida por `height(node) = 1 + max(height(node.left), height(node.right))`.

```
        1           Altura do nó 1: 3
       / \          Altura do nó 2: 2
      2   3         Altura do nó 4: 1
     /              Altura do nó 3: 1
    4
```

### O que é Travessia Pós-Ordem (Post-Order Traversal)

É um método de travessia que processa os nós na ordem: subárvore esquerda → subárvore direita → o próprio nó. Como as informações dos filhos são determinadas antes do processamento do pai, esse método é adequado para processamentos de agregação de baixo para cima, como "calcular a altura do pai usando a altura dos filhos".

```java
void postOrder(TreeNode node) {
    if (node == null) return;
    postOrder(node.left);   // Processa a subárvore esquerda primeiro
    postOrder(node.right);  // Processa a subárvore direita em seguida
    // Aqui o próprio node é processado (os resultados esquerdo e direito já estão determinados)
}
```

### O que é Math.abs

É um método padrão do Java que retorna o valor absoluto de um inteiro. É utilizado para verificar se a diferença entre as alturas esquerda e direita é no máximo 1, independentemente de ser positiva ou negativa.

```java
Math.abs(3 - 1);    // → 2
Math.abs(1 - 3);    // → 2
Math.abs(2 - 3);    // → 1
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Cada nó é visitado exatamente uma vez |
| Space | O(n) — A pilha de chamadas recursivas tem no máximo n níveis (no caso de uma árvore degenerada) |

## Código

```java
// Entrada: nó raiz root de uma árvore binária
// Saída: retorna true se a árvore for balanceada em altura, caso contrário retorna false

// Função recursiva que retorna a altura de um nó. Retorna o valor sentinela -1 se detectar desequilíbrio
// Se o valor de retorno for 0 ou maior, representa uma altura normal; -1 significa "alguma subárvore está desequilibrada"
private int checkHeight(TreeNode node) {
    // Caso base: null representa uma subárvore vazia com altura 0
    if (node == null) return 0;

    // Calcula recursivamente a altura da subárvore esquerda (parte "esquerda primeiro" da travessia pós-ordem)
    int left = checkHeight(node.left);
    // Se a subárvore esquerda estiver desequilibrada, propaga -1 imediatamente sem verificar a subárvore direita (término antecipado)
    if (left == -1) return -1;

    // Calcula recursivamente a altura da subárvore direita (parte "direita em seguida" da travessia pós-ordem)
    int right = checkHeight(node.right);
    // Se a subárvore direita estiver desequilibrada, propaga -1 imediatamente
    if (right == -1) return -1;

    // Se a diferença de altura entre esquerda e direita no nó atual exceder 1, há desequilíbrio (parte "processamento do próprio nó" da travessia pós-ordem)
    // Math.abs é usado para verificar corretamente a diferença independentemente de qual lado é mais alto
    if (Math.abs(left - right) > 1)
        return -1;

    // Se estiver balanceado, retorna a altura do nó atual. Será usada no cálculo do nó pai
    return 1 + Math.max(left, right);
}

public boolean isBalanced(TreeNode root) {
    // Se checkHeight não retornar -1, a árvore inteira está balanceada
    // -1 é o valor sentinela que indica "alguma subárvore está desequilibrada"
    return checkHeight(root) != -1;
}
```
