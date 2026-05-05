# Finding the Kth Smallest Element in a BST — Encontrar o k-ésimo menor elemento em uma BST

## Essência do Problema

São dados o nó raiz `root` de uma árvore binária de busca (BST) e um inteiro `k`. O objetivo é retornar o **k-ésimo menor valor** entre todos os valores dos nós na BST. É garantido que a árvore contém pelo menos k nós.

## Ideia Central

Quando realizamos uma travessia em ordem (in-order traversal) em uma BST, os valores dos nós aparecem em ordem crescente. Portanto, o valor do k-ésimo nó visitado na travessia em ordem é diretamente a resposta. Não é necessário percorrer todos os nós; podemos encerrar imediatamente ao alcançar o k-ésimo nó.

## Processo de Raciocínio

1. **Aproveitar a propriedade da BST**: Em uma BST, para qualquer nó, todos os nós da subárvore esquerda são menores que ele, e todos os nós da subárvore direita são maiores. Devido a essa propriedade, a travessia em ordem (esquerda → nó atual → direita) produz os valores dos nós em ordem crescente
2. **O k-ésimo menor valor é o k-ésimo elemento da travessia em ordem**: Como o k-ésimo elemento da sequência crescente obtida pela travessia em ordem é a resposta, basta contar durante a travessia
3. **Escolher travessia iterativa com pilha em vez de recursão**: Com recursão, não é possível retornar imediatamente ao alcançar o k-ésimo elemento (é necessário desfazer a pilha de chamadas). Com a travessia iterativa usando pilha, podemos sair com return no instante em que encontramos o k-ésimo elemento
4. **Como realizar a travessia em ordem com pilha**: A partir do nó atual, seguimos continuamente para o filho esquerdo empilhando os nós. Ao alcançar a extremidade esquerda, desempilhamos (pop) e "visitamos" esse nó. Em seguida, movemos para o filho direito e repetimos o mesmo processo
5. **Detectar o k-ésimo elemento com um contador**: Cada vez que desempilhamos e visitamos um nó, decrementamos k. Quando k chega a 0, o valor desse nó é a resposta
6. **O que retornar no final**: Retornamos o valor do nó `curr.val` no momento em que k se torna 0

## Conhecimentos Prévios

### O que é a travessia em ordem de uma BST (Árvore Binária de Busca)

É um método de travessia que visita a árvore binária de busca na ordem "subárvore esquerda → nó atual → subárvore direita". Ao realizar a travessia em ordem em uma BST, os valores dos nós são obtidos em ordem crescente.

```
Exemplo:     5
            / \
           3   7
          / \
         2   4

Resultado da travessia em ordem: 2, 3, 4, 5, 7 (ordem crescente)
```

### O que é uma Stack (Pilha)

É uma estrutura de dados do tipo último a entrar, primeiro a sair (LIFO). O último elemento adicionado é o primeiro a ser retirado. Na travessia em ordem, a pilha é usada para memorizar os nós pais percorridos durante o processo de seguir para os filhos esquerdos.

```java
Stack<TreeNode> stack = new Stack<>();  // Cria uma pilha vazia
stack.push(node);      // Adiciona node ao topo da pilha
stack.pop();           // Remove e retorna o elemento do topo da pilha
stack.isEmpty();       // Retorna um boolean indicando se a pilha está vazia
```

### Padrão da travessia em ordem iterativa

A travessia em ordem com pilha repete o ciclo "descer até a extremidade esquerda → desempilhar e visitar → mover para o filho direito". A condição de continuação do loop é: enquanto o nó atual não for null ou a pilha não estiver vazia.

```java
TreeNode curr = root;
while (curr != null || !stack.isEmpty()) {
    while (curr != null) {       // Descer até a extremidade esquerda
        stack.push(curr);
        curr = curr.left;
    }
    curr = stack.pop();          // Visitar (aqui os nós são obtidos em ordem crescente)
    curr = curr.right;           // Mover para o filho direito
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(h + k) — Desce h vezes até a extremidade esquerda e desempilha k nós |
| Space | O(h) — No máximo h nós (altura da árvore) são empilhados na pilha |

## Código

```java
// Entrada: nó raiz root de uma árvore binária de busca e um inteiro k
// Saída: retorna como int o valor do k-ésimo menor nó na BST
public int kthSmallest(TreeNode root, int k) {
    // Pilha para armazenar temporariamente os nós pais percorridos ao seguir para os filhos esquerdos, permitindo retornar a eles depois
    Stack<TreeNode> stack = new Stack<>();
    // Ponteiro que indica o nó atualmente em foco
    TreeNode curr = root;

    // Mesmo que curr seja null, se houver nós na pilha ainda existem nós não visitados, então continuamos
    while (curr != null || !stack.isEmpty()) {
        // Descer até a extremidade esquerda, empilhando os nós percorridos (alcançar o menor valor da subárvore atual)
        while (curr != null) {
            stack.push(curr);
            curr = curr.left;
        }

        // O nó desempilhado é o próximo nó a ser visitado na travessia em ordem (o menor valor entre os não visitados)
        curr = stack.pop();
        // Desempilhar corresponde a visitar um nó na travessia em ordem, então decrementamos o número de visitas restantes em 1
        k--;

        // O nó em que k se torna 0 é o k-ésimo menor elemento, então retornamos seu valor imediatamente
        if (k == 0)
            return curr.val;

        // Se houver subárvore direita, na próxima iteração desceremos até sua extremidade esquerda. Caso contrário, curr será null e desempilharemos o pai da pilha
        curr = curr.right;
    }
    // Devido às restrições do problema, a árvore tem pelo menos k nós, então este ponto nunca é alcançado
    return -1;
}
```
