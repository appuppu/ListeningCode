# Deep Copying a Graph — Clonar todos os nós de um grafo não direcionado conexo usando cópia profunda

## Essência do problema

Uma referência a um nó de um grafo não direcionado conexo é fornecida. O objetivo é criar uma **cópia profunda (clone)** de todo o grafo e retornar o nó correspondente no grafo clonado. Cada nó possui um valor inteiro `val` e uma lista de nós adjacentes `neighbors`. É necessário construir um novo grafo completamente independente, sem referenciar nenhum nó do grafo original.

## Ideia central

Como o grafo pode conter ciclos, utiliza-se um HashMap para registrar a correspondência "nó original → nó clonado", evitando clonar o mesmo nó duas vezes. Se o nó ainda não foi visitado, cria-se o clone e registra-se no HashMap; se já foi visitado, retorna-se o clone do HashMap. Dessa forma, é possível replicar todos os nós com precisão, sem cair em loops infinitos.

## Processo de raciocínio

1. **Percorrer o grafo é necessário**: Para copiar o grafo inteiro, é preciso visitar todos os nós alcançáveis a partir do nó inicial. A abordagem natural é utilizar DFS (busca em profundidade) com recursão
2. **É essencial lidar com ciclos**: Em grafos não direcionados, ciclos como A→B→A sempre existem. Tentar clonar um nó já visitado novamente causa um loop infinito, portanto é necessário um mecanismo para verificar se um nó já foi clonado
3. **Gerenciar a correspondência entre nó original e clone com HashMap**: Prepara-se um `HashMap<Node, Node>`, onde a chave é o "nó original" e o valor é o "seu clone". Assim, é possível verificar em O(1) se um nó já foi clonado e obter o clone em O(1)
4. **O que fazer em cada passo da recursão**: Se o nó atual existe no HashMap, retorna-se seu clone (já visitado). Se não existe, cria-se um novo Node, registra-se no HashMap, chama-se recursivamente o clone para todos os nós adjacentes do nó original, e adiciona-se os clones retornados à lista de neighbors
5. **O registro deve ser feito antes da recursão**: O registro no HashMap deve ser feito **antes** da chamada recursiva dos nós adjacentes. Sem registrar primeiro, ao retornar para si mesmo em um ciclo, o clone não será encontrado no HashMap, causando um loop infinito
6. **O que retornar no final**: Retorna-se o clone do nó inicial. A partir desse clone, todos os nós clonados estão conectados por meio das listas de adjacência

## Conhecimentos prévios

### O que é a classe Node

Uma classe que representa cada vértice do grafo. Possui um valor inteiro `val` e uma lista de nós adjacentes `neighbors`.

```java
class Node {
    public int val;
    public List<Node> neighbors;

    public Node(int val) {        // Cria um nó com o val especificado
        this.val = val;
        this.neighbors = new ArrayList<>();  // A lista de adjacência é inicializada vazia
    }
}
```

### O que é HashMap

Uma estrutura de dados que armazena pares de chave e valor. Permite buscar e obter valores em O(1) especificando a chave. Neste problema, a chave armazena o "nó original" e o valor armazena o "nó clonado", servindo tanto para verificação de visitados quanto para obtenção do clone.

```java
HashMap<Node, Node> map = new HashMap<>();  // Cria um HashMap vazio
map.put(original, clone);     // Armazena o nó original como chave e o clone como valor
map.containsKey(original);    // Retorna um boolean indicando se o nó original já está registrado → true
map.get(original);            // Retorna o clone correspondente ao nó original → clone
```

### O que é DFS (busca em profundidade)

Um dos algoritmos de percurso de grafos. Avança o mais profundamente possível em uma direção e, ao chegar a um beco sem saída, retorna e segue para outra direção. Pode ser implementado naturalmente com chamadas recursivas. Sem o controle de visitados, loops infinitos ocorrem em ciclos.

## Complexidade

| | Valor |
|---|---|
| Time | O(V + E) — Cada nó é visitado uma vez (V) e cada aresta é processada uma vez (E) |
| Space | O(V) — O HashMap armazena a correspondência de V nós e a pilha de recursão pode ter no máximo V níveis |

## Código

```java
// Entrada: um nó node (tipo Node) de um grafo não direcionado conexo. Se o grafo estiver vazio, é null
// Saída: retorna o nó clonado (tipo Node) correspondente ao nó de entrada na cópia profunda de todo o grafo

// HashMap que armazena chave=nó original, valor=nó clonado
// Colocado como campo da classe para ser compartilhado entre todas as chamadas recursivas
Map<Node, Node> map = new HashMap<>();

public Node cloneGraph(Node node) {
    // Se o grafo estiver vazio (null), retorna null e encerra
    if (node == null) return null;

    // Se o nó atual já foi clonado, retorna o clone correspondente
    // Este é o mecanismo que impede loops infinitos causados por ciclos
    if (map.containsKey(node))
        return map.get(node);

    // Cria o clone do nó atual (neste ponto, neighbors está vazio)
    Node clone = new Node(node.val);

    // Atenção: o registro é feito antes da chamada recursiva no for loop a seguir
    // Sem registrar primeiro, ao retornar para si mesmo em um ciclo, containsKey não o detectará, causando um loop infinito
    map.put(node, clone);

    // Clona recursivamente todos os nós adjacentes do nó original e os adiciona à lista de adjacência do clone
    // Isso constrói no lado do clone a mesma relação de adjacência do grafo original
    for (Node nbr : node.neighbors) {
        clone.neighbors
            .add(cloneGraph(nbr));
    }

    // O clone retornado na primeira chamada se torna o nó inicial de todo o grafo clonado
    return clone;
}
```
