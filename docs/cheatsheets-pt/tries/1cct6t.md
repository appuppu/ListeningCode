# Implementing a Prefix Tree — Projetar uma estrutura de dados que realiza inserção, busca por correspondência exata e busca por prefixo de strings de forma eficiente

## Essência do Problema

Projetar e implementar uma estrutura de dados chamada Trie (árvore de prefixos). Esta estrutura de dados precisa suportar três operações: (1) `insert(word)` insere uma palavra, (2) `search(word)` determina se existe uma palavra com correspondência exata, (3) `startsWith(prefix)` determina se entre as palavras já inseridas existe alguma que começa com o prefixo especificado.

## Ideia Central

Se decompormos uma string em uma estrutura de árvore com cada caractere como um nó, palavras que compartilham prefixos comuns compartilham nós entre si. Ao adicionar a cada nó um flag que indica "uma palavra termina aqui", a diferença entre busca por correspondência exata e busca por prefixo se resume apenas a verificar ou não esse flag ao final da travessia.

## Processo de Raciocínio

1. **Expandir a string em uma estrutura de árvore caractere por caractere**: Representamos cada caractere da palavra a ser inserida como um nó, e a relação pai-filho representa a ordem dos caracteres. Dessa forma, palavras com prefixos comuns como "apple" e "app" podem compartilhar os 3 primeiros nós (a→p→p)
2. **Gerenciar os nós filhos de cada nó com HashMap**: Cada nó possui nós filhos correspondentes ao próximo caractere. Para gerenciar os nós filhos, usamos um HashMap, armazenando o "caractere" como chave e a "referência ao nó filho" como valor. Assim, a transição para qualquer caractere pode ser feita em O(1)
3. **É necessário um flag para distinguir o final de uma palavra**: Após inserir "apple", se buscarmos "app", conseguimos percorrer os nós a→p→p. Porém, como "app" não foi inserido, precisamos retornar false. Ao adicionar um flag `isEnd` a cada nó e definir `isEnd = true` no último nó durante o `insert`, conseguimos distinguir o final de uma palavra
4. **Todas as três operações são baseadas na travessia de nós**: `insert`, `search` e `startsWith` começam todos a partir da raiz e percorrem a string caractere por caractere, transitando entre nós. O `insert` cria um novo nó se o destino da transição não existir. O `search` e `startsWith` retornam false imediatamente se o destino da transição não existir
5. **A diferença entre search e startsWith é apenas a verificação do isEnd**: O `search` verifica se `node.isEnd` é true após percorrer todos os caracteres. O `startsWith` retorna true quando consegue percorrer todos os caracteres. A lógica de travessia é idêntica, apenas a verificação final é diferente
6. **O nó raiz é um nó fictício**: O nó raiz, que é o ponto de partida da Trie, é inicializado como um nó vazio sem caractere. Todas as operações iniciam a travessia a partir deste nó raiz

## Conhecimento Prévio

### O que é uma Trie

Uma estrutura de árvore para armazenar e buscar strings de forma eficiente. Cada nó corresponde a um caractere, e o caminho da raiz até a folha representa uma string. Como strings com prefixos comuns compartilham nós, é uma estrutura de dados especializada em busca por prefixo.

```
Exemplo: estrutura de árvore após inserir "app", "apple", "bat"

      root
      / \
     a   b
     |   |
     p   a
     |   |
     p*  t*
     |
     l
     |
     e*

* indica nós com isEnd = true (final de uma palavra)
```

### O que é um HashMap

Uma estrutura de dados que armazena pares de chave e valor. É possível buscar e obter valores especificando a chave em O(1). Na Trie, é utilizado para gerenciar os nós filhos de cada nó.

```java
HashMap<Character, TrieNode> children = new HashMap<>();  // Cria um HashMap vazio
children.put('a', new TrieNode());      // Armazena um novo nó na chave 'a'
children.containsKey('a');              // Retorna boolean indicando se a chave 'a' existe → true
children.get('a');                      // Retorna o nó correspondente à chave 'a'
children.putIfAbsent('a', new TrieNode());  // Armazena apenas se a chave 'a' não estiver registrada
```

### O que é putIfAbsent

Um método do HashMap que armazena o valor apenas se a chave especificada ainda não existir. Se a chave já existir, não faz nada. É utilizado na operação `insert` para adicionar apenas novos nós sem destruir caminhos existentes.

```java
map.putIfAbsent('a', new TrieNode());  // Se 'a' não estiver registrado, registra um novo nó
map.putIfAbsent('a', new TrieNode());  // 'a' já está registrado, então não faz nada
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m) — Tanto insert, search quanto startsWith percorrem a string apenas uma vez, proporcional ao comprimento m da string |
| Space | O(n * m) — Armazena n palavras (com comprimento médio m). Como prefixos comuns compartilham nós, o uso real é menor que isso |

## Código

```java
// Entrada: insert(word) recebe a string word, search(word) recebe a string word, startsWith(prefix) recebe a string prefix
// Saída: insert não tem valor de retorno (adiciona a palavra à Trie), search retorna boolean indicando se existe uma palavra com correspondência exata, startsWith retorna boolean indicando se existe uma palavra que corresponde ao prefixo

// Classe TrieNode: representa cada nó da Trie
class TrieNode {
    // Mapeamento para os nós filhos. Chave=caractere, Valor=nó filho correspondente
    Map<Character, TrieNode> children;
    // Flag que indica se uma palavra termina neste nó (valor inicial é false)
    // Este flag permite que o search distinga entre correspondência exata e correspondência de prefixo
    boolean isEnd;

    TrieNode() {
        children = new HashMap<>();
        isEnd = false;
    }
}

class Trie {
    // Nó raiz que é o ponto de partida de todas as operações (nó fictício vazio sem caractere)
    private TrieNode root;

    // O construtor cria um TrieNode vazio como raiz
    public Trie() {
        root = new TrieNode();
    }

    public void insert(String word) {
        // node é um ponteiro que representa a posição atual da travessia. A travessia inicia a partir da raiz
        TrieNode node = root;
        // Percorre a string word caractere por caractere desde o início
        for (char c : word.toCharArray()) {
            // Com putIfAbsent, cria um novo nó filho se não existir, e não faz nada se já existir
            // Usar putIfAbsent evita sobrescrever caminhos existentes (nós compartilhados por outras palavras)
            node.children.putIfAbsent(c, new TrieNode());
            // Avança o ponteiro para o nó filho correspondente ao caractere c
            node = node.children.get(c);
        }
        // Define o flag de final de palavra no último nó
        // Este flag permite distinguir no search que "apple" foi inserido e "app" não foi inserido
        node.isEnd = true;
    }

    public boolean search(String word) {
        // Inicia a travessia a partir da raiz
        TrieNode node = root;
        // Percorre a string word caractere por caractere desde o início
        for (char c : word.toCharArray()) {
            // Se o nó filho correspondente não existir, não há caminho na Trie para este caractere, retorna false imediatamente
            if (!node.children.containsKey(c))
                return false;
            // Avança o ponteiro para o nó filho
            node = node.children.get(c);
        }
        // Se o nó ao final da travessia de todos os caracteres for final de palavra retorna true, caso contrário retorna false
        // Isso garante que quando "apple" foi inserido e "app" não foi, search("app") retorna false corretamente
        return node.isEnd;
    }

    public boolean startsWith(String prefix) {
        // Inicia a travessia a partir da raiz
        TrieNode node = root;
        // Percorre a string prefix caractere por caractere desde o início
        for (char c : prefix.toCharArray()) {
            // Se o nó filho correspondente não existir, não há caminho na Trie para este prefixo, retorna false imediatamente
            if (!node.children.containsKey(c))
                return false;
            // Avança o ponteiro para o nó filho
            node = node.children.get(c);
        }
        // Como todos os caracteres foram percorridos com sucesso, existe uma palavra na Trie que começa com este prefixo
        // A diferença em relação ao search é apenas que não verifica o isEnd
        return true;
    }
}
```
