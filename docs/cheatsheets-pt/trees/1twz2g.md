# Serializing and Deserializing a Binary Tree — Converter uma árvore binária em string e restaurar a estrutura original da árvore

## Essência do Problema

Projetar um algoritmo que serializa uma árvore binária em uma string e deserializa essa string de volta para a árvore binária original. O round-trip deve ser lossless — a árvore restaurada deve ser completamente idêntica à árvore original.

## Ideia Central

Ao serializar a árvore usando travessia Preorder (pré-ordem), a estrutura "filho esquerdo → filho direito" de cada nó é registrada recursivamente. Se registrarmos explicitamente null como um valor sentinela, na deserialização basta consumir os tokens sequencialmente desde o início para restaurar de forma recursiva e unívoca a estrutura original da árvore.

## Processo de Raciocínio

1. **O que é necessário para restaurar univocamente a estrutura da árvore**: Para determinar univocamente a estrutura de uma árvore binária, é necessária a informação sobre se os filhos de cada nó existem ou não. Se registrarmos explicitamente as posições de null, uma única ordem de travessia é suficiente para reproduzir univocamente a estrutura da árvore
2. **Por que a travessia Preorder é adequada**: Preorder visita na ordem "raiz → subárvore esquerda → subárvore direita". Como a raiz vem primeiro, durante a deserialização podemos gerar nós recursivamente enquanto consumimos tokens desde o início. A ordem de travessia e a ordem de geração de nós coincidem, tornando a implementação natural
3. **Registrar null como valor sentinela**: Quando um nó é null, registramos a string `"null"`. Dessa forma, durante a deserialização podemos determinar o limite "aqui a subárvore termina". Sem o sentinela, não seria possível identificar o término de uma subárvore
4. **Formato da serialização**: Concatenamos os valores de cada nó separados por vírgula. O formato fica como `"1,2,null,null,3,4,null,null,5,null,null"`. Ao fazer split por vírgula, obtemos um array de tokens
5. **A deserialização consome tokens recursivamente**: Fazemos poll (extração) dos tokens um a um desde o início da lista. Se o valor extraído for `"null"`, retornamos null; caso contrário, criamos um nó e construímos recursivamente o filho esquerdo e o filho direito. Usando LinkedList, o poll desde o início é O(1)
6. **A ordem da recursão coincide com Preorder**: A ordem Preorder da serialização (raiz → esquerda → direita) e a ordem das chamadas recursivas da deserialização (criação do nó → filho esquerdo → filho direito) coincidem perfeitamente, portanto basta consumir os tokens em ordem para restaurar corretamente a árvore

## Conhecimentos Prévios

### O que é Travessia Preorder (Pré-ordem)

Um método de travessia que visita recursivamente uma árvore binária na ordem "raiz → subárvore esquerda → subárvore direita". Como a raiz é processada primeiro, o início dos dados serializados é sempre o nó raiz.

```java
void preorder(TreeNode node) {
    if (node == null) return;
    visit(node);           // Primeiro processa a raiz
    preorder(node.left);   // Em seguida processa recursivamente a subárvore esquerda
    preorder(node.right);  // Por último processa recursivamente a subárvore direita
}
```

### O que é StringBuilder

Uma classe para concatenar strings de forma eficiente. A concatenação de strings com o operador `+` gera um novo objeto String a cada vez, resultando em O(n²), mas StringBuilder acrescenta a um buffer interno, custando apenas O(n).

```java
StringBuilder sb = new StringBuilder();  // Cria um StringBuilder vazio
sb.append("hello");                      // Acrescenta a string ao final
sb.append(",");                          // Acrescenta uma vírgula
sb.deleteCharAt(sb.length() - 1);        // Remove o último caractere
sb.toString();                           // Converte para String → "hello"
```

### LinkedList e o Método poll

LinkedList é uma estrutura de dados que permite adição e remoção no início e no final da lista em O(1). O método `poll()` extrai e retorna o primeiro elemento da lista (removendo-o da lista). Retorna null se a lista estiver vazia.

```java
LinkedList<String> tokens = new LinkedList<>(Arrays.asList("1", "2", "null"));
tokens.poll();  // Retorna "1" e o remove da lista. Restante: ["2", "null"]
tokens.poll();  // Retorna "2" e o remove da lista. Restante: ["null"]
```

### O que é um Valor Sentinela

Um valor especial utilizado para indicar o término de dados ou um estado especial. Neste problema, usamos a string `"null"` como sentinela para representar "não existe nó filho nesta posição". Graças ao sentinela, durante a deserialização podemos determinar com precisão os limites das subárvores.

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Visita cada um dos n nós exatamente uma vez |
| Space | O(n) — Utiliza espaço proporcional a n para a string serializada e a lista de tokens. A pilha de chamadas recursivas é O(n) no pior caso (árvore desbalanceada) |

## Código

```java
// Entrada: Serialização — nó raiz root da árvore binária. Deserialização — string data separada por vírgulas
// Saída: Serialização — string separada por vírgulas representando a árvore. Deserialização — nó raiz da árvore binária original

// Serializa a árvore binária em uma string
public String serialize(TreeNode root) {
    // Buffer para acumular os valores de todos os nós da árvore separados por vírgula
    StringBuilder sb = new StringBuilder();
    // Percorre a árvore em ordem Preorder e acrescenta os valores ao StringBuilder
    serHelper(root, sb);
    // Remove a vírgula extra no final
    if (sb.length() > 0)
        sb.deleteCharAt(sb.length() - 1);
    return sb.toString();
}

// Percorre a árvore em ordem Preorder e acrescenta o valor de cada nó ao StringBuilder
void serHelper(TreeNode node, StringBuilder sb) {
    // Nós null são registrados como o valor sentinela "null" (para determinar o término da subárvore na deserialização)
    if (node == null) {
        sb.append("null,");
        return;
    }
    // Registra o valor do nó atual (como é Preorder, a raiz é processada primeiro)
    // Cada valor fica no formato separado por vírgula
    sb.append(node.val).append(",");
    // Processa recursivamente a subárvore esquerda
    serHelper(node.left, sb);
    // Processa recursivamente a subárvore direita (a ordem raiz→esquerda→direita realiza o Preorder)
    serHelper(node.right, sb);
}

// Deserializa a string de volta para uma árvore binária
public TreeNode deserialize(String data) {
    // Uma string vazia representa uma árvore vazia
    if (data.isEmpty()) return null;
    // Divide por vírgula e converte em LinkedList (porque é necessário poll() que extrai do início em O(1))
    LinkedList<String> tokens =
        new LinkedList<>(Arrays.asList(data.split(",")));
    // Gera nós recursivamente enquanto consome tokens sequencialmente desde o início
    return desHelper(tokens);
}

// Gera nós recursivamente enquanto consome tokens sequencialmente desde o início
TreeNode desHelper(LinkedList<String> tokens) {
    // Extrai o token do início (como poll remove o elemento da lista, na próxima recursão o próximo token estará no início)
    String val = tokens.poll();
    // Se for o valor sentinela, retorna null e encerra a recursão (o filho do nó pai é definido como null)
    if (val.equals("null")) return null;
    // Converte o valor do token em inteiro e cria um novo nó
    TreeNode node = new TreeNode(Integer.parseInt(val));
    // Seguindo a ordem Preorder, constrói o filho esquerdo primeiro (como coincide com a ordem da serialização, o token correto é associado)
    node.left = desHelper(tokens);
    // Em seguida constrói o filho direito
    node.right = desHelper(tokens);
    // Retorna o nó construído (o valor de retorno da primeira chamada é o nó raiz = a árvore inteira restaurada)
    return node;
}
```
