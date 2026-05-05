# Finding the Lowest Common Ancestor in a BST — Encontrar o ancestral comum mais profundo de 2 nós em uma BST

## Essência do problema

Dados uma árvore binária de busca (BST) e dois nós `p`, `q` existentes na árvore, retornar o nó mais profundo que possui ambos os nós como descendentes (ancestral comum mais baixo: LCA). Um nó é considerado descendente de si mesmo.

## Ideia central

Em uma BST, todos os descendentes à esquerda são menores que o nó atual, e todos os descendentes à direita são maiores. No momento em que `p` e `q` se separam para lados opostos em relação ao nó atual, esse nó é o LCA.

## Processo de raciocínio

1. **Podemos aproveitar a propriedade da BST**: Em uma BST, para qualquer nó, é garantida a ordem: todos os valores da subárvore esquerda < valor do nó < todos os valores da subárvore direita. Essa propriedade permite determinar em qual subárvore `p` e `q` estão apenas comparando os valores dos nós
2. **Se ambos estão à esquerda, avançar para a esquerda**: Se tanto `p.val` quanto `q.val` são menores que o valor do nó atual, então `p` e `q` existem na subárvore esquerda. Como o LCA também está nessa subárvore esquerda, movemos para o filho esquerdo
3. **Se ambos estão à direita, avançar para a direita**: Se tanto `p.val` quanto `q.val` são maiores que o valor do nó atual, então `p` e `q` existem na subárvore direita. Como o LCA também está nessa subárvore direita, movemos para o filho direito
4. **Se se separam para lados opostos, o nó atual é o LCA**: Quando `p` e `q` se separam para lados opostos do nó atual (um é menor e o outro é maior), não existe uma única subárvore mais profunda que contenha ambos. Portanto, o nó atual é o LCA. Quando `p` ou `q` é igual ao nó atual, esse nó também é o LCA, pois um nó é considerado descendente de si mesmo
5. **Podemos implementar iterativamente sem recursão**: Como em cada passo avançamos em apenas uma direção (esquerda ou direita), a pilha de chamadas recursivas é desnecessária. Basta atualizar o nó atual em um loop while, alcançando complexidade espacial O(1)

## Conhecimentos prévios

### O que é uma árvore binária de busca (BST)

Uma árvore binária em que cada nó satisfaz a ordem "descendentes à esquerda < si mesmo < descendentes à direita". Essa propriedade permite determinar em qual subárvore um nó pertence apenas pela comparação de valores.

```
        6
       / \
      2    8
     / \  / \
    0   4 7   9
```

Nesta árvore, o LCA dos nós 2 e 8 é 6. O LCA dos nós 2 e 4 é 2 (o nó 2 também é descendente de si mesmo).

### O que é o ancestral comum mais baixo (LCA)

Entre os ancestrais comuns de dois nós `p` e `q`, é o nó mais profundo (mais distante da raiz). Quando `p` ou `q` é ancestral do outro, esse próprio nó é o LCA.

### Estrutura do TreeNode

Classe que representa cada nó da BST. Possui o valor `val`, o filho esquerdo `left` e o filho direito `right`.

```java
TreeNode node = new TreeNode(6);   // Cria um nó com valor 6
node.val;                           // Obtém o valor do nó → 6
node.left;                          // Obtém o nó filho esquerdo
node.right;                         // Obtém o nó filho direito
```

## Complexidade

| | Valor |
|---|---|
| Time | O(h) — Percorre a altura da árvore. Em uma BST balanceada, O(log n) |
| Space | O(1) — Não utiliza memória adicional devido ao processamento iterativo |

## Código

```java
// Entrada: nó raiz da BST root, dois nós p e q existentes na árvore
// Saída: retorna o TreeNode correspondente ao ancestral comum mais baixo (LCA) de p e q
TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    // Inicializa a posição atual de busca na raiz. Será atualizada no loop while
    TreeNode node = root;

    // Repete a busca enquanto node não for null
    while (node != null) {
        // Verifica se tanto p quanto q são menores que o nó atual
        if (p.val < node.val && q.val < node.val) {
            // Ambos existem na subárvore esquerda, então o LCA também está na subárvore esquerda
            node = node.left;
        // Verifica se tanto p quanto q são maiores que o nó atual
        } else if (p.val > node.val && q.val > node.val) {
            // Ambos existem na subárvore direita, então o LCA também está na subárvore direita
            node = node.right;
        } else {
            // p e q se separaram para lados opostos (ou um deles é igual ao nó atual)
            // Não é possível acomodar ambos os nós em uma única subárvore mais profunda, portanto o LCA está confirmado
            return node;
        }
    }
    // Devido às restrições do problema, p e q existem na árvore, então o retorno acima sempre ocorre e este ponto nunca é alcançado
    return null;
}
```
