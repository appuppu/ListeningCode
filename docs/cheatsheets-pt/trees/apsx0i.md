# Traversing a Binary Tree Level by Level — Agrupar os nós de uma árvore binária por nível em listas

## Essência do problema

É dado o `root` de uma árvore binária. Agrupe os nós da árvore **por nível (profundidade)** e retorne uma `List<List<Integer>>` em que cada `List<Integer>` contém os valores dos nós de um nível, da esquerda para a direita, ordenados do nível mais alto para o mais baixo.

## Ideia central

Usando uma fila (Queue), é possível processar os nós em ordem de **busca em largura**, da esquerda para a direita. Ao registrar o tamanho da fila no início de cada nível e retirar exatamente essa quantidade de nós, a separação entre os níveis é gerenciada com precisão.

## Processo de raciocínio

1. **A busca em largura (BFS) é adequada para processar por nível**: A busca em profundidade (DFS) percorre um ramo até o fundo, o que dificulta o agrupamento por nível. A BFS processa os nós dos mais rasos para os mais profundos, correspondendo naturalmente à travessia por nível
2. **Utiliza-se uma fila para implementar a BFS**: A fila é uma estrutura de dados FIFO (primeiro a entrar, primeiro a sair), que permite processar primeiro os nós adicionados antes (os mais rasos), realizando o comportamento da BFS
3. **Como determinar a fronteira entre os níveis**: No momento em que o processamento de cada nível começa, todos os nós na fila pertencem ao mesmo nível. Nesse instante, registra-se `queue.size()` na variável `size` e retira-se exatamente `size` nós, processando assim os nós de exatamente um nível
4. **Os filhos dos nós retirados são adicionados à fila como o próximo nível**: Ao retirar cada nó, seus filhos esquerdo e direito são adicionados à fila. Esses filhos não são retirados durante o processamento do nível atual (pois o número de iterações é limitado por `size`). Eles são processados como o próximo nível na próxima iteração do laço while
5. **O resultado de cada nível é coletado em uma lista e retornado**: Para cada nível, cria-se uma `List<Integer>` que armazena os valores dos nós daquele nível. Ao concluir o processamento de um nível, essa lista é adicionada ao resultado final `List<List<Integer>>`
6. **Quando a fila fica vazia, o processamento de todos os níveis está concluído**: Quando todos os nós são retirados, a fila fica vazia e o laço while termina. Nesse ponto, a lista de resultados contém os valores dos nós de todos os níveis, ordenados de cima para baixo

## Conhecimentos prévios

### O que é uma Queue (fila)

É uma estrutura de dados FIFO (primeiro a entrar, primeiro a sair). O elemento adicionado primeiro é o primeiro a ser retirado. Em Java, utiliza-se LinkedList como implementação da interface Queue.

```java
Queue<TreeNode> queue = new LinkedList<>();  // Cria uma fila vazia
queue.offer(node);   // Adiciona node ao final da fila
queue.poll();        // Retira e retorna o elemento do início da fila (o elemento é removido da fila)
queue.size();        // Retorna o número de elementos na fila → int
queue.isEmpty();     // Retorna um boolean indicando se a fila está vazia
```

### O que é BFS (busca em largura)

É um algoritmo que explora um grafo ou uma árvore na direção da "largura". Os nós mais próximos do ponto de partida são processados primeiro. É implementado utilizando uma fila. Quando aplicado a uma árvore, os nós são visitados na ordem nível 0 → nível 1 → nível 2…

### Estrutura do TreeNode

É uma classe que representa cada nó de uma árvore binária. Possui três campos: o valor `val`, o filho esquerdo `left` e o filho direito `right`.

```java
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Cada nó da árvore é processado exatamente uma vez |
| Space | O(n) — A fila armazena no máximo a quantidade de nós do nível mais largo da árvore (no pior caso, n/2) |

## Código

```java
// Entrada: o nó raiz root de uma árvore binária
// Saída: retorna uma List<List<Integer>> que agrupa os valores dos nós por nível
List<List<Integer>> levelOrder(TreeNode root) {
    // Resultado final que armazena a lista de valores dos nós de cada nível
    List<List<Integer>> result = new ArrayList<>();

    // Se root for null, a árvore está vazia, então retorna result vazio diretamente
    if (root == null) return result;

    // Cria a fila para BFS e adiciona o nó raiz
    // Neste ponto, a fila contém apenas um nó do nível 0
    Queue<TreeNode> queue = new LinkedList<>();
    queue.offer(root);

    // Repete o processamento por nível até que a fila fique vazia
    // Quando a fila ficar vazia, o processamento de todos os nós estará concluído
    while (!queue.isEmpty()) {
        // Atenção: é necessário salvar este valor em uma variável antes do laço
        // Como nós filhos são adicionados à fila dentro do laço for, o tamanho da fila muda,
        // e usar queue.size() diretamente na condição do laço for não resulta na separação correta dos níveis
        int size = queue.size();
        // Lista que armazena os valores dos nós do nível atual
        List<Integer> level = new ArrayList<>();

        for (int i = 0; i < size; i++) {
            // Retira o nó do início da fila
            TreeNode node = queue.poll();
            // Adiciona o valor do nó à lista do nível atual
            level.add(node.val);

            // Se o filho esquerdo existir, adiciona-o à fila (será processado no próximo nível)
            if (node.left != null)
                queue.offer(node.left);
            // Se o filho direito existir, adiciona-o à fila
            // Ao adicionar os filhos na ordem esquerda → direita, os nós do próximo nível também são processados da esquerda para a direita
            if (node.right != null)
                queue.offer(node.right);
        }

        // O processamento de um nível foi concluído, então adiciona-o ao resultado
        result.add(level);
    }
    // Retorna result, que contém os valores dos nós de todos os níveis ordenados de cima para baixo
    return result;
}
```
