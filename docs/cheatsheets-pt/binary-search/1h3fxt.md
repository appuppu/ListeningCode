# Searching for a Value in a Sorted Matrix — Buscar um valor alvo em uma matriz ordenada

## Essência do problema

É dada uma matriz m×n. Cada linha está ordenada em ordem crescente, e o primeiro elemento de cada linha é maior que o último elemento da linha anterior. O objetivo é determinar se um dado `target` existe nessa matriz e retornar um `boolean`.

## Ideia central

Se os elementos da matriz inteira forem dispostos em sequência do canto superior esquerdo ao canto inferior direito, ela pode ser considerada como um único array ordenado. Utilizando a conversão do índice unidimensional `mid` para as coordenadas da matriz `[mid / n][mid % n]`, é possível realizar a busca em O(log(m * n)) com uma única busca binária, sem precisar achatar a matriz.

## Processo de raciocínio

1. **A matriz inteira é um único array ordenado**: Como cada linha está em ordem crescente e o primeiro elemento da próxima linha é maior que o último elemento da linha anterior, ao ler os elementos da matriz do canto superior esquerdo ao canto inferior direito em sequência, o conjunto inteiro forma um único array ordenado em ordem crescente
2. **A busca binária pode ser aplicada a um array ordenado**: O número total de elementos é `m * n`, então basta realizar a busca binária no intervalo de 0 a `m * n - 1`. O limite inferior do intervalo de busca é definido como `lo = 0` e o limite superior como `hi = m * n - 1`
3. **É necessário converter o índice unidimensional em coordenadas bidimensionais**: O ponto médio `mid` da busca binária é um índice unidimensional. Como são necessárias coordenadas bidimensionais para obter o valor da matriz, o índice da linha é calculado como `mid / n` (quociente da divisão pelo número de colunas) e o índice da coluna como `mid % n` (resto da divisão pelo número de colunas)
4. **Aplicar a lógica padrão da busca binária**: Se o valor obtido com `matrix[mid / n][mid % n]` for igual ao `target`, retorna `true`. Se for menor, o intervalo de busca é reduzido à metade direita com `lo = mid + 1`. Se for maior, o intervalo é reduzido à metade esquerda com `hi = mid - 1`
5. **Se o intervalo de busca se esgotar, o target não existe**: Se nenhuma correspondência for encontrada até que `lo > hi`, o `target` não existe na matriz, então retorna `false`

## Conhecimentos prévios

### O que é Busca Binária (Binary Search)

É um algoritmo que encontra rapidamente um valor desejado em um array ordenado, reduzindo o intervalo de busca pela metade a cada iteração. Para um array com n elementos, o resultado é obtido em no máximo log₂(n) comparações.

```java
int lo = 0, hi = array.length - 1;  // Define o limite inferior e superior do intervalo de busca
while (lo <= hi) {                    // Itera enquanto o intervalo de busca existir
    int mid = lo + (hi - lo) / 2;    // Calcula o ponto médio evitando overflow de inteiros
    if (array[mid] == target)         // Verifica se o valor no ponto médio é igual ao target
        return true;
    else if (array[mid] < target)
        lo = mid + 1;                // O target está na metade direita, então eleva o limite inferior
    else
        hi = mid - 1;                // O target está na metade esquerda, então reduz o limite superior
}
return false;                         // Caso o valor não seja encontrado
```

### Conversão entre índice unidimensional e coordenadas bidimensionais

Em uma matriz com `n` colunas, a conversão de um índice unidimensional `idx` para coordenadas bidimensionais é feita por divisão e resto. Essa conversão permite tratar a matriz como um array unidimensional virtual.

```java
int n = matrix[0].length;        // Obtém o número de colunas
int row = idx / n;               // O quociente é o índice da linha (ex: idx=7, n=4 → row=1)
int col = idx % n;               // O resto é o índice da coluna (ex: idx=7, n=4 → col=3)
int val = matrix[row][col];      // Obtém o valor da matriz usando as coordenadas bidimensionais
```

## Complexidade

| | Valor |
|---|---|
| Time | O(log(m * n)) — Realiza uma única busca binária sobre o total de m * n elementos |
| Space | O(1) — Utiliza apenas variáveis de ponteiro, sem necessidade de estruturas de dados adicionais |

## Código

```java
// Entrada: uma matriz de inteiros m×n matrix e um inteiro target
// Saída: retorna true se o target existir na matriz, false caso contrário
public boolean searchMatrix(int[][] matrix, int target) {
    // Obtém o número de linhas e colunas da matriz. Usado para calcular o total de elementos e para a conversão 1D→2D
    int m = matrix.length;
    int n = matrix[0].length;

    // Define o intervalo de busca da busca binária como a matriz inteira
    // lo=0 corresponde ao canto superior esquerdo, hi=m*n-1 corresponde ao canto inferior direito da matriz
    int lo = 0, hi = m * n - 1;

    // Quando lo > hi, o intervalo de busca se esgota e é possível determinar que o target não existe
    while (lo <= hi) {
        // Usa esta forma em vez de (lo + hi) / 2 para evitar overflow de inteiros em lo + hi
        int mid = lo + (hi - lo) / 2;

        // Converte o índice unidimensional em coordenadas bidimensionais para obter o valor
        // Índice da linha = mid / n (quociente), índice da coluna = mid % n (resto)
        int val = matrix[mid / n][mid % n];

        if (val == target)
            return true;           // O valor alvo foi encontrado, então retorna true
        else if (val < target)
            lo = mid + 1;          // O target está na metade direita (valores maiores), então eleva o limite inferior
        else
            hi = mid - 1;          // O target está na metade esquerda (valores menores), então reduz o limite superior
    }

    // O loop terminou sem retornar true, portanto o target não existe na matriz
    return false;
}
```
