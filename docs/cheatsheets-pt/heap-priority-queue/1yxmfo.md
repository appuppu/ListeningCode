# Finding the K Closest Points to the Origin — Encontrar os K Pontos Mais Próximos da Origem

## Essência do Problema

Um array de pontos `points` em um plano bidimensional e um inteiro `k` são fornecidos. O objetivo é retornar os `k` pontos mais próximos da origem (0, 0), medidos pela distância euclidiana. A resposta pode ser retornada em qualquer ordem.

## Ideia Central

Para encontrar os "k pontos mais próximos", uma ordenação completa não é necessária. Utilizando o algoritmo Quickselect, o array é particionado por um pivô para encontrar a fronteira da k-ésima posição, e os k pontos mais próximos ficam reunidos no lado esquerdo.

## Processo de Raciocínio

1. **Uma ordenação completa é excessiva**: Basta retornar os k pontos mais próximos, e a ordem não importa. Ou seja, é suficiente particionar os dados em "os k mais próximos" e "o restante". Uma ordenação completa custa O(n log n), mas apenas particionar pode ser feito de forma mais rápida
2. **Usar Quickselect para encontrar a posição de partição**: Utilizando a operação de partição do Quicksort, os elementos menores que o pivô ficam à esquerda e os maiores ficam à direita. Se a posição final do pivô for exatamente k-1, os k elementos à esquerda são a resposta
3. **Simplificar o cálculo da distância**: A distância euclidiana é `√(x² + y²)`, mas para apenas comparar magnitudes, a raiz quadrada é desnecessária, e comparar `x² + y²` é suficiente. Isso evita operações com ponto flutuante
4. **Mecanismo da operação de partição**: O elemento mais à direita é escolhido como pivô, e `storeIdx` gerencia "a próxima posição onde elementos menores ou iguais ao pivô serão colocados". Durante a varredura, quando um elemento menor ou igual ao pivô é encontrado, ele é trocado com a posição `storeIdx`, e `storeIdx` é incrementado
5. **Reduzir o intervalo de busca com base na posição final do pivô**: Após a partição, o pivô é colocado na posição `storeIdx`. Se essa posição for menor que `k-1`, os elementos do lado esquerdo são insuficientes, então a metade direita é explorada. Se for maior ou igual a `k-1`, a metade esquerda é explorada. Essa repetição completa a partição em O(n) na média
6. **Retornar os primeiros k elementos**: Ao final do loop, os primeiros k elementos do array são os pontos mais próximos, então eles são extraídos com `Arrays.copyOfRange(points, 0, k)` e retornados

## Conhecimentos Prévios

### O que é Quickselect

É um algoritmo que encontra o k-ésimo menor elemento de um array em O(n) na média. Ao aplicar a operação de partição do Quicksort recursivamente em apenas um dos lados, a posição desejada é determinada sem realizar uma ordenação completa.

```java
// Estrutura básica da partição
int pivotValue = arr[right];       // Escolher o elemento mais à direita como pivô
int storeIdx = left;               // Posição para colocar elementos menores ou iguais ao pivô
for (int i = left; i < right; i++) {
    if (arr[i] <= pivotValue) {    // Se for menor ou igual ao pivô, agrupar à esquerda
        swap(arr, i, storeIdx);
        storeIdx++;
    }
}
swap(arr, storeIdx, right);        // Colocar o pivô na posição correta
// storeIdx é a posição final do pivô
```

### Quadrado da Distância Euclidiana

A distância até a origem é `√(x² + y²)`, mas para apenas comparar magnitudes, a raiz quadrada pode ser omitida e a comparação pode ser feita com `x² + y²`. Como a função raiz quadrada é monotonicamente crescente, a relação de ordem das distâncias é preservada mesmo com o quadrado das distâncias.

```java
private int dist(int[] point) {
    return point[0] * point[0] + point[1] * point[1];  // x² + y²
}
```

### O que é Arrays.copyOfRange

É um método utilitário do Java que copia um intervalo especificado de um array e retorna um novo array.

```java
int[][] result = Arrays.copyOfRange(points, 0, k);  // Copiar k elementos do índice 0 ao k-1
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) na média — Como a partição é aplicada em apenas um dos lados, converge com uma média de n + n/2 + n/4 + ... = 2n comparações |
| Space | O(1) — O array de entrada é reorganizado in-place, sem uso de memória adicional |

## Código

```java
// Entrada: array de coordenadas bidimensionais points (cada elemento é [x, y]) e um inteiro k
// Saída: retorna um int[][] contendo os k pontos mais próximos da origem

// Retorna o quadrado da distância euclidiana de um ponto até a origem (a raiz quadrada é omitida pois não é necessária para comparação de magnitude)
private int dist(int[] p) {
    return p[0] * p[0] + p[1] * p[1];
}

public int[][] kClosest(int[][] points, int k) {
    // Inicializar os limites esquerdo e direito do intervalo de busca. Dentro desse intervalo, a partição é repetida para reorganizar os primeiros k elementos como os pontos mais próximos
    int left = 0;
    int right = points.length - 1;

    // Repetir a partição até que os primeiros k elementos sejam os pontos mais próximos
    while (left < right) {
        // Escolher o ponto mais à direita como pivô e calcular o quadrado da sua distância euclidiana (x² + y²)
        int pivotDist = dist(points[right]);
        // storeIdx gerencia "a próxima posição onde pontos com distância menor ou igual ao pivô serão colocados"
        int storeIdx = left;

        // Comparar a distância de cada ponto com o pivô e agrupar à esquerda os pontos com distância menor ou igual ao pivô
        for (int i = left; i < right; i++) {
            if (dist(points[i]) <= pivotDist) {
                // Menor ou igual ao pivô, então trocar com a posição storeIdx para agrupar à esquerda
                int[] temp = points[i];
                points[i] = points[storeIdx];
                points[storeIdx] = temp;
                storeIdx++;
            }
        }

        // Colocar o pivô na sua posição final correta storeIdx. À esquerda ficam os pontos com distância menor ou igual, e à direita os pontos com distância maior que o pivô
        int[] temp = points[storeIdx];
        points[storeIdx] = points[right];
        points[right] = temp;

        // Comparar a posição final do pivô com k-1 para reduzir o intervalo de busca pela metade
        if (storeIdx < k - 1) {
            // Os elementos do lado esquerdo são menos que k, então explorar o lado direito
            left = storeIdx + 1;
        } else {
            // Nota: quando storeIdx é exatamente k-1, ao reduzir right, a condição do loop left < right se torna falsa e o loop termina
            right = storeIdx - 1;
        }
    }

    // Após o término do loop, os primeiros k elementos do array são os k pontos mais próximos da origem
    return Arrays.copyOfRange(points, 0, k);
}
```
