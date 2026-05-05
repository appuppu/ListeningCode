# Traversing a Matrix in Spiral Order — Obter todos os elementos de uma matriz em ordem espiral

## Essência do problema

Uma matriz `matrix` de m linhas e n colunas é fornecida. Começando pelo canto superior esquerdo, percorre-se o perímetro na ordem direita → baixo → esquerda → cima, repetindo em direção ao interior, para retornar um array com todos os elementos organizados em **ordem espiral**.

## Ideia central

Considera-se o perímetro da matriz como uma "camada" e percorrem-se sequencialmente os 4 lados: superior, direito, inferior e esquerdo. Após completar a varredura de uma camada, contrai-se os 4 ponteiros de fronteira para o interior, avançando naturalmente para a próxima camada.

## Processo de raciocínio

1. **A varredura espiral é uma repetição de 4 direções**: Como a estrutura repete as 4 direções (direita → baixo → esquerda → cima) do perímetro para o interior, ao gerenciar os limites "superior, inferior, esquerdo e direito" da faixa de varredura atual, o intervalo de varredura de cada direção fica unicamente determinado
2. **Representar a faixa de varredura com 4 ponteiros de fronteira**: Preparam-se 4 variáveis: `top` (linha do limite superior), `bottom` (linha do limite inferior), `left` (coluna do limite esquerdo) e `right` (coluna do limite direito). Elas indicam a posição dos 4 lados da camada atual
3. **Determinar a ordem de varredura de cada lado**: O lado superior vai da esquerda para a direita (incrementa colunas), o lado direito vai de cima para baixo (incrementa linhas), o lado inferior vai da direita para a esquerda (decrementa colunas) e o lado esquerdo vai de baixo para cima (decrementa linhas). Esses 4 laços for completam a varredura de uma camada
4. **Contrair a fronteira após a varredura de cada lado**: Após percorrer o lado superior, executa-se `top++` (desce o limite superior 1 linha); após o lado direito, `right--` (move o limite direito 1 coluna para a esquerda); após o lado inferior, `bottom--`; após o lado esquerdo, `left++`. Isso faz com que o próximo laço percorra a camada imediatamente interior
5. **As varreduras dos lados inferior e esquerdo exigem condições adicionais**: Como `top` é incrementado após o lado superior e `right` é decrementado após o lado direito, no momento de percorrer o lado inferior a condição `top <= bottom` pode ter sido violada. Da mesma forma, no momento de percorrer o lado esquerdo, `left <= right` pode ter sido violada. Se essas condições não forem satisfeitas, linhas ou colunas já percorridas seriam lidas em duplicidade, portanto a verificação das condições é necessária
6. **A condição de término é o cruzamento das fronteiras**: Quando `top > bottom` ou `left > right`, a varredura de todas as camadas está concluída. Especificando `top <= bottom && left <= right` como condição do laço while, o programa termina naturalmente

## Conhecimentos prévios

### O que é ArrayList

Um array de comprimento variável. A operação `add`, que adiciona um elemento ao final, é executada em O(1). É utilizado para construir o array resultante em ordem espiral.

```java
List<Integer> res = new ArrayList<>();  // Cria um ArrayList vazio
res.add(5);                             // Adiciona 5 ao final → [5]
res.add(3);                             // Adiciona 3 ao final → [5, 3]
res.size();                             // Retorna o número de elementos → 2
```

### O que são Ponteiros de Fronteira (Boundary Pointers)

São 4 variáveis inteiras que indicam a faixa de varredura da matriz. `top` e `bottom` representam o intervalo de linhas, e `left` e `right` representam o intervalo de colunas. Ao modificar os valores a cada varredura, a faixa é contraída para o interior.

```java
int top = 0;                    // Índice da linha do limite superior (valor inicial: 0)
int bottom = matrix.length - 1; // Índice da linha do limite inferior (valor inicial: última linha)
int left = 0;                   // Índice da coluna do limite esquerdo (valor inicial: 0)
int right = matrix[0].length - 1; // Índice da coluna do limite direito (valor inicial: última coluna)
top++;    // Contrai o limite superior 1 linha para baixo
right--;  // Contrai o limite direito 1 coluna para a esquerda
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m × n) — Percorre cada elemento da matriz exatamente uma vez |
| Space | O(1) — Excluindo a lista de saída, utiliza apenas 4 ponteiros de fronteira |

## Código

```java
// Entrada: matriz de inteiros matrix com m linhas e n colunas
// Saída: retorna uma List<Integer> com todos os elementos em ordem espiral
List<Integer> spiralOrder(int[][] matrix) {
    // Cria uma lista de comprimento variável para armazenar o resultado
    List<Integer> res = new ArrayList<>();
    // Se a matriz estiver vazia (0 linhas), retorna a lista vazia diretamente
    if (matrix.length == 0) return res;

    // Inicializa os 4 ponteiros de fronteira. Eles representam a posição dos 4 lados da camada a ser percorrida
    int top = 0;                      // Linha do limite superior (linha mais alta)
    int bottom = matrix.length - 1;   // Linha do limite inferior (linha mais baixa)
    int left = 0;                     // Coluna do limite esquerdo (coluna mais à esquerda)
    int right = matrix[0].length - 1; // Coluna do limite direito (coluna mais à direita)

    // Repete camada por camada enquanto existir faixa de varredura. Quando as fronteiras se cruzam, a varredura de todos os elementos está concluída
    while (top <= bottom && left <= right) {
        // Lado superior: percorre da esquerda para a direita
        for (int c = left; c <= right; c++)
            res.add(matrix[top][c]);
        // Varredura do lado superior concluída. Contrai o limite superior 1 linha para baixo para evitar leitura duplicada do elemento de canto na próxima varredura do lado direito
        top++;

        // Lado direito: percorre de cima para baixo (top já foi atualizado, portanto não há duplicação de canto)
        for (int r = top; r <= bottom; r++)
            res.add(matrix[r][right]);
        // Varredura do lado direito concluída. Contrai o limite direito 1 coluna para a esquerda
        right--;

        // Lado inferior: percorre da direita para a esquerda
        // Verificação de condição: se top++ resultou em top > bottom (caso restasse apenas 1 linha),
        // o lado inferior é a mesma linha que o lado superior e já foi percorrido, portanto é ignorado
        if (top <= bottom) {
            for (int c = right; c >= left; c--)
                res.add(matrix[bottom][c]);
            // Contrai o limite inferior 1 linha para cima
            bottom--;
        }

        // Lado esquerdo: percorre de baixo para cima
        // Verificação de condição: se right-- resultou em left > right (caso restasse apenas 1 coluna),
        // o lado esquerdo é a mesma coluna que o lado direito e já foi percorrido, portanto é ignorado
        if (left <= right) {
            for (int r = bottom; r >= top; r--)
                res.add(matrix[r][left]);
            // Contrai o limite esquerdo 1 coluna para a direita
            left++;
        }
    }
    // Retorna a lista contendo todos os m×n elementos em ordem espiral
    return res;
}
```
