# Viewing a Binary Tree From the Right Side — Retornar os valores dos nós visíveis ao olhar uma árvore binária pelo lado direito

## Essência do problema

É dada a `root` de uma árvore binária. Ao olhar a árvore pelo lado direito, apenas o nó mais à direita em cada profundidade é visível. Retornar uma `List<Integer>` com os valores desses nós, ordenados de cima (root) para baixo.

## Ideia central

Se realizarmos uma DFS visitando o filho direito primeiro, o primeiro nó alcançado em cada profundidade será sempre o "nó visível pelo lado direito". Basta comparar a profundidade com o tamanho da lista de resultados para determinar se aquele nó é o primeiro visitado naquela profundidade.

## Processo de raciocínio

1. **O que é um nó visível pelo lado direito**: O nó posicionado mais à direita em cada profundidade é o "nó visível pelo lado direito". Ou seja, o problema se reduz a selecionar um nó por profundidade
2. **Considerar uma DFS que visita o filho direito primeiro**: Ao percorrer a árvore com DFS, se chamarmos recursivamente o filho direito antes do filho esquerdo, alcançaremos primeiro o nó mais à direita em cada profundidade. Utilizando essa propriedade, basta registrar apenas o primeiro nó visitado em cada profundidade
3. **Como determinar se é "a primeira visita naquela profundidade"**: O tamanho da lista de resultados `result` representa "o número de profundidades registradas até o momento". Se a `depth` atual for igual a `result.size()`, isso significa que nenhum nó dessa profundidade foi registrado ainda. Somente quando essa condição é verdadeira, executamos `result.add(node.val)`
4. **Estrutura da recursão**: Em cada nó, processamos na ordem: "se a profundidade é nova, registrar o valor" → "recursão no filho direito" → "recursão no filho esquerdo". Como o filho direito é visitado primeiro, os nós do lado direito são registrados com prioridade em cada profundidade
5. **Caso base**: Quando o nó é `null`, simplesmente retornamos sem fazer nada. Isso faz com que a recursão além dos nós folha termine naturalmente
6. **O que retornar no final**: Após a conclusão da DFS, a lista `result` contém os valores dos nós visíveis pelo lado direito, ordenados a partir da profundidade 0. Retornamos essa lista diretamente

## Conhecimentos prévios

### O que é DFS (Busca em Profundidade)

É um dos algoritmos para percorrer árvores ou grafos. A partir de um nó, avança o mais profundamente possível antes de retroceder (fazer backtracking). Pode ser implementada naturalmente usando recursão.

```java
void dfs(TreeNode node) {
    if (node == null) return;  // Caso base: se for null, não faz nada
    // Processar o node aqui
    dfs(node.left);   // Percorrer recursivamente o filho esquerdo
    dfs(node.right);  // Percorrer recursivamente o filho direito
}
```

### size() e add() de List

`List` é um array de tamanho variável. `size()` retorna o número atual de elementos e `add()` adiciona um elemento ao final. Os elementos são indexados na ordem em que foram adicionados: 0, 1, 2...

```java
List<Integer> list = new ArrayList<>();  // Criar uma lista vazia
list.size();      // Retorna o número atual de elementos → 0
list.add(5);      // Adicionar 5 ao final → [5]
list.add(3);      // Adicionar 3 ao final → [5, 3]
list.size();      // → 2
```

### O que é depth (profundidade)

É o número de arestas desde a raiz até o nó. A profundidade da raiz é 0, a dos filhos da raiz é 1 e a dos netos é 2. Ao passar `depth + 1` na chamada recursiva, é possível rastrear a profundidade de cada nó.

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Cada nó é visitado exatamente uma vez |
| Space | O(h) — A pilha de chamadas da recursão requer espaço proporcional à altura da árvore (h é a altura da árvore) |

## Código

```java
// Entrada: nó raiz da árvore binária root
// Saída: List<Integer> contendo os valores dos nós visíveis pelo lado direito, de cima para baixo
List<Integer> rightSideView(TreeNode root) {
    // Lista para armazenar o valor do nó mais à direita em cada profundidade
    // O índice da lista corresponde à profundidade (índice 0 = profundidade 0)
    List<Integer> result = new ArrayList<>();
    dfs(root, 0, result);
    // Após a conclusão da DFS, result contém os valores dos nós visíveis pelo lado direito, a partir da profundidade 0
    return result;
}

void dfs(TreeNode node, int depth,
         List<Integer> result) {
    // Caso base: se for null, não faz nada (a recursão para o filho inexistente além do nó folha termina)
    if (node == null) return;

    // Se depth == result.size(), o nó desta profundidade ainda não foi registrado
    // result.size() representa "o número de profundidades registradas até o momento"
    if (depth == result.size()) {
        // Como a DFS visita o filho direito primeiro, o primeiro nó alcançado em cada profundidade é sempre o nó mais à direita
        result.add(node.val);
    }

    // Ao visitar o filho direito primeiro, o nó mais à direita de cada profundidade é registrado primeiro
    // Esta é a essência do algoritmo: visitar na ordem direita → esquerda
    dfs(node.right, depth + 1, result);
    // Em profundidades onde o filho direito não existe, o filho esquerdo se torna "o primeiro nó visitado naquela profundidade" e é registrado corretamente
    dfs(node.left, depth + 1, result);
}
```
