# Maximizing Water Held Between Two Lines — Encontrar o volume máximo de água entre duas linhas verticais

## Essência do Problema

Um array de inteiros não negativos `height` é fornecido. Cada elemento `height[i]` representa a altura de uma linha vertical na posição `i` no eixo x. O objetivo é selecionar duas linhas e retornar o **volume máximo de água** que o contêiner formado por essas duas linhas e o eixo x pode armazenar. O volume do contêiner é determinado por "distância entre as duas linhas × altura da linha mais curta entre as duas".

## Ideia Central

Começando com a largura máxima do contêiner (ambas as extremidades), movemos o ponteiro do lado mais curto para dentro. Isso permite explorar eficientemente todos os pares, mantendo a possibilidade de melhoria da área por aumento de altura. A razão de mover o lado mais curto é que, como a largura diminui, a área não pode melhorar a menos que a altura aumente.

## Processo de Raciocínio

1. **Organizar a fórmula de cálculo da área**: A área do contêiner formado por duas linhas `i` e `j` (i < j) é `(j - i) × min(height[i], height[j])`. Para maximizar a área, é necessário maximizar o produto da "largura" pelo "valor mínimo da altura"
2. **Começar com a largura máxima**: Para maximizar a largura, selecionamos a extremidade esquerda (índice 0) e a extremidade direita (índice n-1). Iniciando a exploração a partir deste estado, partimos com a largura máxima
3. **Decidir qual ponteiro mover**: A largura sempre diminui em 1 ao mover para dentro. Para melhorar a área, a única opção é aumentar a altura. Como a altura do contêiner é determinada pela linha mais curta entre as duas, mover o ponteiro do lado mais curto para dentro oferece a possibilidade de encontrar uma linha mais alta. Por outro lado, mover o lado mais longo não melhora a área, pois o lado mais curto continua sendo o gargalo
4. **Registrar a área em cada passo**: A cada movimento de ponteiro, calculamos a nova área e a comparamos com o valor máximo até o momento para atualização. Desta forma, obtemos o mesmo resultado que uma busca exaustiva
5. **Definir a condição de término**: Quando o ponteiro esquerdo e o ponteiro direito se encontram, todos os pares promissores já foram examinados, e a exploração é encerrada
6. **O que retornar no final**: Retornamos o valor máximo da área `maxarea` registrado durante a exploração

## Conhecimentos Prévios

### O que é Two Pointers (Dois Ponteiros)

É uma técnica que posiciona dois ponteiros (índices) nas extremidades ou em diferentes posições de um array, movendo um ou ambos de acordo com condições durante a exploração. É eficaz quando é possível reduzir uma busca O(n²) de todos os pares para O(n) utilizando condições.

```java
int left = 0;                      // Posicionar o ponteiro esquerdo no início do array
int right = height.length - 1;     // Posicionar o ponteiro direito no final do array
while (left < right) {             // Repetir até que os dois ponteiros se encontrem
    // Mover left ou right
    left++;   // Avançar o ponteiro esquerdo uma posição para a direita
    right--;  // Recuar o ponteiro direito uma posição para a esquerda
}
```

### O que são Math.min / Math.max

`Math.min(a, b)` retorna o menor entre dois valores, e `Math.max(a, b)` retorna o maior. São usados para determinar a altura do contêiner (a linha mais curta) e para atualizar o valor máximo da área.

```java
Math.min(3, 7);          // Retorna o menor entre os dois → 3
Math.max(10, 25);        // Retorna o maior entre os dois → 25
```

### Cálculo da Área do Contêiner

A área do contêiner formado por duas linhas `left` e `right` é calculada por largura × altura. A altura é determinada pela linha mais curta entre as duas.

```java
int width = right - left;                              // Largura = distância entre as duas linhas
int minHeight = Math.min(height[left], height[right]);  // Altura = altura da linha mais curta
int area = width * minHeight;                           // Área = largura × altura
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Os ponteiros esquerdo e direito avançam para dentro apenas uma vez cada, percorrendo o array uma única vez |
| Space | O(1) — Utiliza apenas variáveis para os ponteiros e para armazenar o valor máximo |

## Código

```java
// Entrada: array de inteiros não negativos height (cada elemento é a altura de uma linha vertical)
// Saída: retorna como int o volume máximo de água que o contêiner formado por duas linhas e o eixo x pode armazenar
public int maxArea(int[] height) {
    // Variável para registrar o valor máximo da área encontrado durante a exploração. Inicializada com 0
    int maxarea = 0;
    // Posicionar o ponteiro esquerdo no início do array. Iniciar a exploração com a largura máxima
    int left = 0;
    // Posicionar o ponteiro direito no final do array
    int right = height.length - 1;

    // Repetir até que os dois ponteiros se encontrem. Quando se encontram, todos os pares promissores já foram examinados
    while (left < right) {
        // Largura = distância entre as duas linhas
        int width = right - left;
        // Altura = altura da linha mais curta. O volume do contêiner é determinado pela linha mais curta
        int minHeight = Math.min(height[left], height[right]);
        // Área = largura × altura
        int area = width * minHeight;

        // Comparar com o valor máximo até o momento e atualizar
        maxarea = Math.max(area, maxarea);

        // Mover o ponteiro do lado mais curto para dentro. Como a largura diminui, a área não melhora a menos que a altura aumente
        // Mover o lado mais longo não melhora a área, pois o lado mais curto continua sendo o gargalo
        if (height[left] <= height[right]) {
            // A linha esquerda é mais curta (ou igual), então avançar o ponteiro esquerdo uma posição para a direita buscando melhoria na altura
            left++;
        } else {
            // A linha direita é mais curta, então recuar o ponteiro direito uma posição para a esquerda buscando melhoria na altura
            right--;
        }
    }
    // Retornar o valor máximo da área registrado durante a exploração
    return maxarea;
}
```
