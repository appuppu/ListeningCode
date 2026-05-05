# Constructing a Binary Tree From Traversal Orders — Reconstruir a árvore binária original a partir da travessia em pré-ordem e em ordem

## Essência do problema

São dados dois arrays de inteiros: `preorder` (travessia em pré-ordem) e `inorder` (travessia em ordem). A partir desses dois resultados de travessia, o objetivo é construir e retornar a árvore binária original. A travessia em pré-ordem organiza os elementos na ordem "raiz → esquerda → direita", e a travessia em ordem organiza na ordem "esquerda → raiz → direita".

## Ideia central

O primeiro elemento da travessia em pré-ordem é sempre a raiz da subárvore atual. Ao verificar em que posição o valor dessa raiz se encontra na travessia em ordem, é possível dividir a travessia em ordem em "elementos da subárvore esquerda" e "elementos da subárvore direita". Repetindo essa divisão recursivamente, é possível reconstruir a árvore inteira.

## Processo de raciocínio

1. **O primeiro elemento da travessia em pré-ordem é a raiz**: A travessia em pré-ordem organiza os elementos na ordem "raiz → esquerda → direita", portanto o primeiro elemento do array é sempre o nó raiz de toda a árvore. Essa propriedade também se aplica recursivamente às subárvores
2. **Se a posição da raiz na travessia em ordem for conhecida, é possível dividir esquerda e direita**: A travessia em ordem segue a ordem "esquerda → raiz → direita", então quando o valor da raiz está na posição `mid` da travessia em ordem, todos os elementos à esquerda de `mid` pertencem à subárvore esquerda, e todos os elementos à direita de `mid` pertencem à subárvore direita
3. **É desejável encontrar a posição da raiz de forma eficiente**: Se a travessia em ordem for percorrida linearmente a cada vez, o custo total será O(n²). Se um HashMap que registra "valor → índice na travessia em ordem" for criado previamente, a posição da raiz pode ser obtida em O(1)
4. **Representar o intervalo da subárvore com limites de índice em vez de copiar arrays**: Se o array for copiado a cada recursão, será necessário O(n²) de espaço. Representando o intervalo da travessia em ordem com dois índices, `inLeft` e `inRight`, é possível especificar o intervalo da subárvore sem copiar o array
5. **Avançar o ponteiro da travessia em pré-ordem globalmente**: A travessia em pré-ordem é organizada na ordem "raiz → subárvore esquerda inteira → subárvore direita inteira", então ao preparar um ponteiro global `preIdx` e incrementá-lo cada vez que uma raiz é extraída, quando a recursão da subárvore esquerda termina, o ponteiro aponta naturalmente para a raiz da subárvore direita
6. **Construir a subárvore esquerda primeiro**: A ordem da travessia em pré-ordem é "raiz → esquerda → direita", então após extrair a raiz, a subárvore esquerda deve ser construída recursivamente primeiro, e depois a subárvore direita. Respeitar essa ordem garante que `preIdx` avance corretamente

## Conhecimentos prévios

### O que é travessia em pré-ordem (Preorder Traversal)

É um método de travessia que visita a árvore binária na ordem "raiz → subárvore esquerda → subárvore direita". O primeiro elemento do array é sempre o valor do nó raiz.

```
        3
       / \
      9   20
         / \
        15   7

Travessia em pré-ordem: [3, 9, 20, 15, 7]  ← O primeiro elemento, 3, é a raiz
```

### O que é travessia em ordem (Inorder Traversal)

É um método de travessia que visita a árvore binária na ordem "subárvore esquerda → raiz → subárvore direita". Tomando o valor da raiz como referência, os elementos à esquerda pertencem à subárvore esquerda e os elementos à direita pertencem à subárvore direita.

```
Travessia em ordem: [9, 3, 15, 20, 7]  ← [9] à esquerda do 3 é a subárvore esquerda, [15,20,7] à direita é a subárvore direita
```

### O que é HashMap

É uma estrutura de dados que armazena pares de chave e valor. É possível buscar e obter valores especificando a chave em O(1).

```java
HashMap<Integer, Integer> map = new HashMap<>();  // Cria um HashMap vazio
map.put(3, 1);           // Armazena o valor 1 com a chave 3
map.get(3);              // Retorna o valor correspondente à chave 3 → 1
```

### O que é TreeNode

É uma classe que representa um nó de uma árvore binária. Possui o valor `val`, o filho esquerdo `left` e o filho direito `right`.

```java
TreeNode root = new TreeNode(3);    // Cria um nó com valor 3
root.left = new TreeNode(9);        // Define um nó com valor 9 como filho esquerdo
root.right = new TreeNode(20);      // Define um nó com valor 20 como filho direito
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Cada nó é processado uma vez, e a busca no HashMap é feita em O(1) |
| Space | O(n) — O HashMap armazena n elementos, e a pilha de recursão é O(n) no pior caso (árvore desbalanceada) |

## Código

```java
// Entrada: array de inteiros preorder (travessia em pré-ordem) e array de inteiros inorder (travessia em ordem)
// Saída: retorna o nó raiz TreeNode da árvore binária reconstruída

// HashMap que armazena chave=valor da travessia em ordem, valor=índice desse valor na travessia em ordem
// Utilizado para obter em O(1) a posição na travessia em ordem a partir do valor da raiz
Map<Integer, Integer> map = new HashMap<>();
// Ponteiro global que aponta para "a posição da próxima raiz a ser extraída" no array de travessia em pré-ordem
// É incrementado e avançado a cada chamada recursiva
int preIdx = 0;

public TreeNode buildTree(int[] preorder, int[] inorder) {
    // Registra cada valor e seu índice da travessia em ordem no HashMap
    // Isso permite consultar instantaneamente em que posição da travessia em ordem qualquer valor se encontra
    for (int i = 0; i < inorder.length; i++)
        map.put(inorder[i], i);

    // Inicia a recursão especificando o intervalo completo do array (inLeft=0, inRight=último índice)
    return helper(preorder, 0, inorder.length - 1);
}

// inLeft e inRight representam o intervalo da subárvore atual no array de travessia em ordem
TreeNode helper(int[] preorder, int inLeft, int inRight) {
    // Se o intervalo da subárvore estiver vazio (inLeft > inRight), o nó filho não existe
    if (inLeft > inRight) return null;

    // Extrai o valor da raiz da posição atual na travessia em pré-ordem e avança o ponteiro
    int rootVal = preorder[preIdx++];
    TreeNode root = new TreeNode(rootVal);

    // Obtém via HashMap a posição do valor da raiz na travessia em ordem
    // mid indica o limite entre a subárvore esquerda e a subárvore direita na travessia em ordem
    int mid = map.get(rootVal);

    // Atenção: a travessia em pré-ordem é organizada na ordem "raiz → esquerda → direita", então a subárvore esquerda deve ser construída primeiro
    // Essa ordem garante que preIdx aponte corretamente para a raiz da subárvore direita
    // O intervalo de inLeft até mid-1 na travessia em ordem corresponde à subárvore esquerda
    root.left = helper(preorder, inLeft, mid - 1);
    // O intervalo de mid+1 até inRight na travessia em ordem corresponde à subárvore direita
    root.right = helper(preorder, mid + 1, inRight);

    // Retorna o nó root construído. Quando toda a recursão é concluída, o nó raiz de toda a árvore é retornado
    return root;
}
```
