# Calculating Trapped Rainwater Between Bars — Calcular a quantidade de água da chuva acumulada entre barras

## Essência do Problema

Um array de inteiros não negativos `height` é fornecido. Cada elemento representa um mapa de elevação com barras de largura 1. O objetivo é calcular e retornar a **quantidade total de água** acumulada entre as barras após a chuva.

## Ideia Central

A quantidade de água acumulada em uma posição é determinada subtraindo a altura da barra naquela posição do menor valor entre a altura máxima à esquerda e a altura máxima à direita. Movendo ponteiros de ambos os lados para o centro e atualizando a altura máxima de cada lado, é possível calcular a quantidade de água em cada posição sem arrays adicionais.

## Processo de Raciocínio

1. **A quantidade de água em cada posição é determinada pelas alturas máximas à esquerda e à direita**: A quantidade de água acumulada em uma posição `i` é `min(altura máxima à esquerda, altura máxima à direita) - height[i]`. A água só se acumula até a altura da parede mais baixa entre as paredes esquerda e direita
2. **Queremos calcular as alturas máximas à esquerda e à direita de forma eficiente**: Percorrer para encontrar as alturas máximas à esquerda e à direita em cada posição custa O(n²). Pré-calcular com dois arrays resulta em O(n), mas requer Space O(n). Vamos considerar uma forma de alcançar Space O(1)
3. **Mover ponteiros de ambos os lados para o centro**: Colocamos um ponteiro `left` na extremidade esquerda e um ponteiro `right` na extremidade direita, movendo-os para o centro. As variáveis `maxLeftHeight` e `maxRightHeight` rastreiam a altura máxima vista até agora em cada lado
4. **Mover o ponteiro do lado menor**: Quando `height[left] <= height[right]`, é garantido que a altura máxima à esquerda é menor ou igual à altura máxima à direita. Isso ocorre porque existe pelo menos uma parede com altura `height[right]` ou maior no lado direito. Portanto, na posição do ponteiro esquerdo, apenas `maxLeftHeight` é suficiente para determinar a quantidade de água
5. **Adicionar a quantidade de água após mover o ponteiro**: Após avançar o ponteiro em uma posição, atualizamos a altura máxima naquela nova posição e adicionamos `maxLeftHeight - height[left]` (ou `maxRightHeight - height[right]`) à quantidade de água. Como a altura máxima é sempre maior ou igual à altura da barra atual, essa diferença é sempre não negativa
6. **Terminar quando os dois ponteiros se encontram**: O loop continua enquanto `left < right`, e retorna `totalwater` com a soma da quantidade de água de todas as posições

## Conhecimentos Prévios

### O que é Two Pointers (Dois Ponteiros)

É uma técnica que posiciona dois ponteiros em ambas as extremidades ou em posições diferentes de um array, movendo um deles conforme a condição durante a varredura. O array inteiro pode ser processado em uma única varredura, sendo eficaz para arrays ordenados e buscas a partir de ambas as extremidades.

```java
int left = 0;                    // Ponteiro na extremidade esquerda
int right = height.length - 1;   // Ponteiro na extremidade direita
while (left < right) {           // Loop até os dois ponteiros se encontrarem
    // Mover os ponteiros para o centro com left++ ou right-- conforme a condição
}
```

### O que é Math.max

É um método estático do Java que retorna o maior entre dois valores. Aqui, é utilizado para atualizar a altura máxima vista até o momento cada vez que o ponteiro avança.

```java
int maxHeight = 3;
maxHeight = Math.max(maxHeight, 5);  // maxHeight é atualizado para 5
maxHeight = Math.max(maxHeight, 2);  // maxHeight permanece 5 (porque 2 < 5)
```

### Condição para a Água se Acumular

Para que a água se acumule em uma posição, são necessárias paredes mais altas que a barra atual em ambos os lados dessa posição. A quantidade de água acumulada é o valor obtido subtraindo a altura da barra atual da altura da parede mais baixa entre as paredes esquerda e direita.

```
// height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]
// Posição 2 (altura 0): máx esquerda=1, máx direita=3 → min(1,3) - 0 = 1 de água acumulada
// Posição 5 (altura 0): máx esquerda=2, máx direita=3 → min(2,3) - 0 = 2 de água acumulada
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Os ponteiros esquerdo e direito movem-se um total de n vezes, percorrendo o array uma única vez |
| Space | O(1) — Utiliza apenas variáveis para ponteiros e alturas máximas, sem necessidade de arrays adicionais |

## Código

```java
// Entrada: array de inteiros não negativos height (cada elemento é a altura de uma barra)
// Saída: retorna a quantidade total de água acumulada entre as barras como int
public int trap(int[] height) {
    // Inicializa a variável que armazena a quantidade total de água acumulada com 0
    int totalwater = 0;

    // Define o ponteiro esquerdo no início do array e o ponteiro direito no final do array
    int left = 0;
    int right = height.length - 1;

    // Inicializa as alturas máximas de cada lado até o momento
    // As barras nas extremidades não acumulam água, então são usadas como valores iniciais
    int maxLeftHeight = height[left];
    int maxRightHeight = height[right];

    // Loop até os dois ponteiros se encontrarem
    while (left < right) {
        // Quando height[left] <= height[right], existe pelo menos uma parede com altura height[right] no lado direito
        // Portanto, apenas a altura máxima à esquerda é suficiente para determinar a quantidade de água
        if (height[left] <= height[right]) {
            // Avança o ponteiro uma posição para a direita antes de calcular a quantidade de água
            left++;
            // Atualiza a altura máxima à esquerda até o momento
            maxLeftHeight = Math.max(maxLeftHeight, height[left]);
            // Como maxLeftHeight é sempre maior ou igual a height[left], o valor adicionado é sempre não negativo
            totalwater += maxLeftHeight - height[left];
        } else {
            // Quando height[left] > height[right], existe pelo menos uma parede com altura height[left] no lado esquerdo
            // Portanto, apenas a altura máxima à direita é suficiente para determinar a quantidade de água
            right--;
            // Atualiza a altura máxima à direita até o momento
            maxRightHeight = Math.max(maxRightHeight, height[right]);
            // Como maxRightHeight é sempre maior ou igual a height[right], o valor adicionado é sempre não negativo
            totalwater += maxRightHeight - height[right];
        }
    }
    // Após o término do loop, retorna totalwater com a soma da quantidade de água de todas as posições
    return totalwater;
}
```
