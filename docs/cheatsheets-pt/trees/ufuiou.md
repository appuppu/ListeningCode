# Checking if Two Binary Trees Are Identical — Determinar se duas árvores binárias são idênticas em estrutura e valores

## Essência do Problema

Duas árvores binárias `p` e `q` são fornecidas. Duas árvores são consideradas "idênticas" quando suas estruturas são completamente iguais e os valores de todos os nós correspondentes são iguais. O algoritmo retorna `true` se forem idênticas, caso contrário retorna `false`.

## Ideia Central

Os nós correspondentes das duas árvores são inseridos na fila como "pares" e comparados um a um em ordem de nível. Se a estrutura e os valores coincidirem em todos os pares, as árvores são idênticas; se houver qualquer divergência, o algoritmo determina imediatamente que não são idênticas.

## Processo de Raciocínio

1. **Basta comparar os nós correspondentes entre si**: Para determinar se duas árvores são idênticas, basta comparar par a par os nós que estão na mesma posição nas árvores. Se os valores coincidirem em todos os pares e a estrutura (presença ou ausência de filhos) também coincidir, as duas árvores são idênticas
2. **Como gerenciar os pares**: É necessário gerenciar os pares de nós a serem comparados em ordem. Usando uma fila (FIFO), é possível extrair e comparar os pares nível a nível em largura. A fila armazena arrays `TreeNode[]` com 2 elementos, onde `pair[0]` representa o nó da árvore p e `pair[1]` representa o nó da árvore q
3. **O que determinar ao extrair um par**: Para cada par extraído, três casos são avaliados em sequência. (a) Se ambos são null, a estrutura coincide nessa posição e o algoritmo avança para o próximo par. (b) Se apenas um é null, a estrutura é diferente e o algoritmo retorna `false`. (c) Se ambos não são null mas os valores diferem, o algoritmo retorna `false`
4. **Após passar na verificação, adicionar os pares de nós filhos à fila**: Quando o par atual coincide, os próximos a serem comparados são os filhos esquerdos entre si e os filhos direitos entre si. Os dois pares `{n1.left, n2.left}` e `{n1.right, n2.right}` são adicionados à fila. Mesmo que os filhos sejam null, eles são adicionados (pois a verificação de null no passo 3 os trata corretamente)
5. **Se a fila ficar vazia, todos os pares coincidiram**: Se todos os pares foram comparados e nenhuma divergência foi encontrada, as duas árvores são idênticas e o algoritmo retorna `true`

## Conhecimentos Prévios

### O que é uma Queue (Fila)

Uma estrutura de dados first-in first-out (FIFO). O primeiro elemento adicionado é o primeiro a ser extraído. É utilizada para processar nós em ordem de nível na busca em largura. Em Java, a interface `Queue` é implementada com `LinkedList`.

```java
Queue<TreeNode[]> queue = new LinkedList<>();  // Criar uma fila que armazena arrays de TreeNode
queue.add(new TreeNode[]{p, q});               // Adicionar um par (array de 2 elementos) ao final da fila
TreeNode[] pair = queue.poll();                 // Extrair e retornar o par do início da fila (retorna null se a fila estiver vazia)
queue.isEmpty();                               // Retornar um boolean indicando se a fila está vazia → true/false
```

### O que é um TreeNode (Nó de Árvore Binária)

Uma classe que representa cada nó de uma árvore binária. O campo `val` contém o valor do nó, e os campos `left` e `right` contêm referências para o nó filho esquerdo e o nó filho direito, respectivamente. Se um filho não existir, o valor é `null`.

```java
TreeNode node = new TreeNode(5);   // Criar um nó com valor 5
node.val;                          // Obter o valor do nó → 5
node.left;                         // Obter o nó filho esquerdo (null se não existir)
node.right;                        // Obter o nó filho direito (null se não existir)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Compara no máximo n nós de cada árvore, uma vez cada |
| Space | O(n) — A fila mantém pares proporcionais ao número de nós |

## Código

```java
// Entrada: nós raiz p e q de duas árvores binárias
// Saída: retorna true se as duas árvores forem idênticas em estrutura e valores, caso contrário retorna false
public boolean isSameTree(TreeNode p, TreeNode q) {
    // Criar uma fila para gerenciar os pares de nós a serem comparados
    // Os pares são armazenados como arrays TreeNode[] de 2 elementos, onde pair[0] é o nó da árvore p e pair[1] é o nó da árvore q
    Queue<TreeNode[]> queue = new LinkedList<>();
    // Como estado inicial, adicionar o par dos nós raiz das duas árvores à fila (primeiro par a ser comparado)
    queue.add(new TreeNode[]{p, q});

    // Enquanto a fila não estiver vazia, extrair e comparar os pares um a um
    while (!queue.isEmpty()) {
        // Extrair o par do início da fila
        TreeNode[] pair = queue.poll();
        TreeNode n1 = pair[0];
        TreeNode n2 = pair[1];

        // Se ambos são null, nenhuma das árvores tem filho nesta posição, então a estrutura coincide. Avançar para o próximo par
        if (n1 == null && n2 == null)
            continue;
        // Se apenas um é null, um nó existe em uma árvore mas não na outra, então a estrutura é diferente
        if (n1 == null || n2 == null)
            return false;
        // Se os valores diferem, os valores dos nós correspondentes não coincidem, então retornar false
        if (n1.val != n2.val)
            return false;

        // O par atual coincidiu, então adicionar os pares de nós filhos a serem comparados em seguida à fila
        // Mesmo que os filhos sejam null, eles são adicionados como estão (a verificação de null acima os trata corretamente)
        queue.add(new TreeNode[]{n1.left, n2.left});
        queue.add(new TreeNode[]{n1.right, n2.right});
    }
    // Todos os pares coincidiram em estrutura e valores, então retornar true
    return true;
}
```
