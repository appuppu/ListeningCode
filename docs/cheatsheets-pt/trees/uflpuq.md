# Checking if a Tree is a Subtree of Another — Verificar se uma árvore está contida como subárvore de outra

## Essência do problema

Duas árvores binárias `root` e `subRoot` são fornecidas. O objetivo é retornar um `boolean` indicando se existe, dentro de `root`, uma subárvore que seja completamente idêntica a `subRoot` em estrutura e valores. Uma subárvore significa que, ao tomar um determinado nó de `root` como raiz, toda a árvore abaixo dele é idêntica a `subRoot`.

## Ideia central

Se serializarmos a árvore em uma string usando travessia em pré-ordem com marcadores de null, a verificação de subárvore se reduz ao problema de busca de string: "uma string está contida em outra string".

## Processo de raciocínio

1. **A verificação de correspondência de subárvore é uma "comparação de forma e valores da árvore inteira"**: Para ser uma subárvore, a estrutura abaixo de um determinado nó e os valores de todos os nós devem ser completamente idênticos. Isso exige um método que preserve as informações de formato da árvore para comparação
2. **Se a árvore puder ser representada de forma única, a comparação se torna fácil**: Na forma de árvore, a comparação exige travessia recursiva nó a nó. Ao serializar a árvore em uma string, a comparação de estrutura e valores se transforma em comparação de strings, permitindo processamento eficiente
3. **A travessia em pré-ordem (preorder) com marcadores de null garante a unicidade**: Somente a travessia em pré-ordem pode gerar a mesma string para árvores diferentes. Ao inserir um marcador como `#` nas posições onde o filho é null, a estrutura da árvore pode ser codificada de forma única
4. **Adicionar separador de vírgula antes do valor de cada nó**: Para tornar os limites dos valores claros, adiciona-se uma vírgula `,` antes do valor de cada nó. Isso evita que, por exemplo, os valores `2` e `12` sejam confundidos
5. **A verificação de subárvore se reduz à verificação de contenção de string**: Se a string serializada de `subRoot` estiver contida como substring na string serializada de `root`, então `subRoot` é uma subárvore de `root`. Com `String.contains()` do Java, a verificação pode ser feita em O(m+n)

## Conhecimentos prévios

### O que é a travessia em pré-ordem (Preorder Traversal) de uma árvore binária

É um método de travessia que visita os nós da árvore na ordem "raiz → filho esquerdo → filho direito". Ao implementar com recursão, primeiro processa-se o nó atual, depois a subárvore esquerda e por fim a subárvore direita recursivamente.

```java
void preorder(TreeNode node) {
    if (node == null) return;
    System.out.println(node.val);  // Processa a raiz
    preorder(node.left);           // Percorre a subárvore esquerda recursivamente
    preorder(node.right);          // Percorre a subárvore direita recursivamente
}
```

### O que é StringBuilder

É uma classe para concatenar strings de forma eficiente. O operador `+` de `String` cria um novo objeto a cada concatenação, mas `StringBuilder` adiciona ao buffer interno em O(1).

```java
StringBuilder sb = new StringBuilder();  // Cria um StringBuilder vazio
sb.append(",5");                         // Adiciona a string ",5" ao final do buffer
sb.append(",#");                         // Adiciona a string ",#" ao final do buffer
sb.toString();                           // Converte o conteúdo do buffer para o tipo String → ",5,#"
```

### O que é String.contains()

É um método que retorna um `boolean` indicando se uma string contém outra string como substring.

```java
String s = ",1,2,#,#,3,#,#";
s.contains(",2,#,#");    // Verifica se s contém ",2,#,#" → true
s.contains(",4,#,#");    // Verifica se s contém ",4,#,#" → false
```

### O que é um marcador de null

É um símbolo especial inserido nas posições onde um nó filho não existe (null) durante a serialização da árvore. Geralmente utiliza-se `#`. Sem o marcador de null, árvores com estruturas diferentes podem produzir o mesmo resultado de travessia. Por exemplo, o marcador de null é necessário para distinguir uma árvore que possui apenas o filho esquerdo de uma árvore que possui apenas o filho direito.

## Complexidade computacional

| | Valor |
|---|---|
| Time | O(m + n) — Percorre root (m nós) e subRoot (n nós) uma vez cada para serializar, e realiza a verificação de contenção de string |
| Space | O(m + n) — Armazena os resultados da serialização das duas árvores no StringBuilder |

## Código

```java
// Entrada: nós raiz das árvores binárias root e subRoot
// Saída: retorna true se subRoot for uma subárvore de root, caso contrário retorna false

// Método auxiliar que serializa a árvore em string usando travessia em pré-ordem
void serialize(TreeNode node, StringBuilder sb) {
    if (node == null) {
        // Adiciona o marcador de null ",#" para indicar explicitamente que o nó filho não existe
        // Isso permite distinguir uma árvore com apenas o filho esquerdo de uma árvore com apenas o filho direito
        sb.append(",#");
        return;
    }
    // Adiciona uma vírgula antes do valor para evitar ambiguidade nos limites de números como 2 e 12
    sb.append("," + node.val);
    // Serializa a subárvore esquerda recursivamente
    serialize(node.left, sb);
    // Serializa a subárvore direita recursivamente
    serialize(node.right, sb);
}

boolean isSubtree(TreeNode root, TreeNode subRoot) {
    // sb1 armazena o resultado da serialização de root, sb2 armazena o resultado da serialização de subRoot
    StringBuilder sb1 = new StringBuilder();
    StringBuilder sb2 = new StringBuilder();

    // Serializa ambas as árvores em strings usando travessia em pré-ordem
    serialize(root, sb1);
    serialize(subRoot, sb2);

    // Se a string de root contém a string de subRoot como substring, então é uma subárvore
    return sb1.toString().contains(sb2.toString());
}
```
