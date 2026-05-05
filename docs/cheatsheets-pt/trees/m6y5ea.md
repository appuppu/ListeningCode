# Finding the Maximum Path Sum in a Binary Tree — Encontrar a soma máxima de qualquer caminho em uma árvore binária

## Essência do problema

Uma árvore binária é fornecida. Cada nó possui um valor inteiro (que pode ser negativo). Entre todos os caminhos possíveis conectados por arestas (cada nó pode ser usado no máximo uma vez), o objetivo é encontrar o caminho cuja soma dos valores dos nós seja máxima e retornar essa **soma**. O caminho não precisa passar pela raiz e pode ir de qualquer nó a qualquer outro nó.

## Ideia central

Em cada nó, calcula-se o "ganho máximo obtido dos descendentes à esquerda" e o "ganho máximo obtido dos descendentes à direita", e a soma do caminho que conecta esquerda e direita passando por esse nó é considerada candidata ao valor máximo global. Por outro lado, o valor retornado ao pai seleciona apenas um dos ramos, esquerdo ou direito (pois o caminho não pode se ramificar).

## Processo de raciocínio

1. **Considerar a estrutura do caminho**: Em qualquer caminho, existe exatamente um "nó na posição mais alta (vértice)". Visto a partir desse nó, o caminho é composto por três partes: "parte que desce para os descendentes à esquerda", "o próprio nó" e "parte que desce para os descendentes à direita". Basta experimentar todos os nós como vértice e encontrar a soma máxima do caminho
2. **Definir o ganho em cada nó**: O valor máximo da soma que pode ser levado de volta na direção do pai, a partir da subárvore enraizada em um nó, é chamado de "ganho". O ganho é calculado como "valor do próprio nó + ganho do filho maior entre esquerdo e direito". Como o caminho não pode se ramificar, não é possível retornar ambos os lados simultaneamente ao pai
3. **Tratar ganhos negativos como 0**: Se o ganho de um filho for negativo, incluir esse ramo reduz a soma do caminho. Por isso, usa-se `Math.max(0, gain)` para arredondar ganhos negativos para 0 (não usar esse ramo). Isso permite representar naturalmente caminhos compostos por um único nó ou caminhos que usam apenas um dos ramos
4. **Gerenciar o valor máximo global separadamente**: A soma "ganho esquerdo + valor do próprio nó + ganho direito", tendo cada nó como vértice, é a soma máxima do caminho que passa por esse nó. Esse valor é comparado e atualizado com a variável global `maxSum`. Como é um cálculo diferente do ganho retornado ao pai, precisa ser gerenciado de forma independente
5. **Calcular com DFS pós-ordem (postorder DFS)**: Como é necessário conhecer o ganho dos filhos antes de realizar o cálculo do próprio nó, o DFS pós-ordem, que processa na ordem esquerda → direita → próprio nó, é adequado. Isso permite experimentar todos os nós como vértice em uma única travessia
6. **O que retornar ao final**: Após a conclusão do DFS, `maxSum` contém a soma máxima do caminho entre todos os nós experimentados como vértice. Esse valor é retornado

## Conhecimentos prévios

### O que é DFS pós-ordem (Postorder DFS) em uma árvore binária

É um método de travessia que visita recursivamente uma árvore binária na ordem "filho esquerdo → filho direito → próprio nó". É adequado quando os resultados dos filhos são necessários para calcular o valor do pai.

```java
void postorder(TreeNode node) {
    if (node == null) return;     // Caso base: se for null, não faz nada
    postorder(node.left);         // Processa primeiro a subárvore esquerda
    postorder(node.right);        // Em seguida, processa a subárvore direita
    // Aqui processa o próprio nó (os resultados dos filhos já estão definidos)
}
```

### O que é Math.max

É um método padrão do Java que retorna o maior entre dois valores. É usado para arredondar ganhos negativos para 0 e para comparar os ganhos esquerdo e direito.

```java
Math.max(0, -5);    // → 0 (arredonda o valor negativo para 0)
Math.max(3, 7);     // → 7 (retorna o maior valor)
Math.max(0, gain(node.left));  // Se o ganho do filho esquerdo for negativo, torna-se 0
```

### O que é Integer.MIN_VALUE

É o menor valor que o tipo `int` do Java pode assumir (-2.147.483.648). É usado como valor inicial em algoritmos que buscam o máximo. É garantido que será atualizado ao ser comparado com qualquer valor.

```java
int maxSum = Integer.MIN_VALUE;  // Valor inicial menor que qualquer soma de caminho
maxSum = Math.max(maxSum, 10);   // → 10 (é sempre atualizado na primeira comparação)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Realiza um DFS que visita cada nó exatamente uma vez |
| Space | O(n) — A pilha de chamadas recursivas pode atingir n níveis no pior caso (árvore desbalanceada) |

## Código

```java
// Entrada: nó raiz root de uma árvore binária (cada nó possui um valor inteiro val, filho esquerdo left e filho direito right)
// Saída: retorna como int a soma máxima de qualquer caminho na árvore binária
class Solution {
    // Registra a soma máxima do caminho entre todos os nós experimentados como vértice
    // Inicializado com Integer.MIN_VALUE para ser menor que qualquer caminho com valor negativo, garantindo atualização na primeira comparação
    int maxSum = Integer.MIN_VALUE;

    // Função recursiva que retorna o ganho máximo que pode ser levado na direção do pai a partir de um nó (calcula na ordem filho → pai com DFS pós-ordem)
    int gain(TreeNode node) {
        // Caso base: o ganho de um nó null é 0 (nada pode ser obtido de um filho inexistente)
        if (node == null) return 0;

        // Obtém o ganho do filho esquerdo e arredonda para 0 se for negativo (opta por não usar um ramo negativo pois reduziria a soma do caminho)
        int leftGain = Math.max(0, gain(node.left));
        // Obtém o ganho do filho direito e, da mesma forma, arredonda para 0 se for negativo
        int rightGain = Math.max(0, gain(node.right));

        // Atualiza o valor máximo global com a soma do caminho que conecta esquerda e direita tendo o nó atual como vértice
        // Este valor representa a soma do caminho "descendentes à esquerda → nó atual → descendentes à direita"
        // Quando leftGain ou rightGain é 0, significa um caminho com apenas um ramo ou um caminho de nó único
        maxSum = Math.max(maxSum, node.val + leftGain + rightGain);

        // O ganho retornado ao pai é apenas o ramo maior entre esquerdo e direito
        // O caminho deve ser contínuo como um traço único e não pode se ramificar em um nó, portanto não é possível retornar ambos
        return node.val + Math.max(leftGain, rightGain);
    }

    int maxPathSum(TreeNode root) {
        // Inicia o DFS recursivamente a partir da raiz, experimentando todos os nós como vértice
        gain(root);
        // Após a conclusão do DFS, maxSum contém a maior soma entre todos os caminhos experimentados com cada nó como vértice
        return maxSum;
    }
}
```
