# Rotating a Matrix 90 Degrees — Rotacionar uma matriz n×n em 90 graus no sentido horário sem memória adicional

## Essência do Problema

Uma matriz quadrada n×n é fornecida. O objetivo é rotacionar essa matriz em 90 graus no sentido horário. A transformação deve ser realizada **in-place (no próprio local)**, sem alocar uma nova matriz. Após a rotação, cada elemento `matrix[i][j]` da matriz original se move para a posição `matrix[j][n-1-i]`.

## Ideia Central

A rotação de 90 graus pode ser decomposta em duas operações simples: "transposição (trocar linhas e colunas)" + "inversão horizontal de cada linha". Essa decomposição permite mover cada elemento para a posição correta sem memória adicional.

## Processo de Raciocínio

1. **Observar o destino de cada elemento na rotação**: O elemento `matrix[i][j]` se move para `matrix[j][n-1-i]` na rotação de 90 graus no sentido horário. Realizar essa transformação diretamente, elemento por elemento, exige uma permutação cíclica de 4 elementos, o que se torna complexo
2. **Considerar se a rotação pode ser decomposta em operações conhecidas**: A operação de transposição move `matrix[i][j]` para `matrix[j][i]`. Após a transposição, inverter cada linha horizontalmente move `matrix[j][i]` para `matrix[j][n-1-i]`. Isso corresponde exatamente à rotação de 90 graus: `matrix[i][j]` → `matrix[j][n-1-i]`
3. **Como realizar a transposição in-place**: Os elementos do triângulo superior e do triângulo inferior são trocados usando a diagonal (`i == j`) como fronteira. Fazendo swap de `matrix[i][j]` e `matrix[j][i]` no intervalo `j > i`, cada par é trocado exatamente uma vez
4. **Como realizar a inversão de cada linha in-place**: Para cada linha, dois ponteiros são posicionados nas extremidades esquerda e direita, e os elementos são trocados em direção ao centro. Essa operação não requer memória adicional
5. **Aplicar as duas operações em sequência**: Primeiro a matriz inteira é transposta, depois cada linha é invertida. Como ambas as operações são realizadas in-place, a rotação de 90 graus é concluída com O(1) de memória adicional no total

## Conhecimentos Prévios

### O que é Transposição (Transpose)

A transposição é a operação de trocar as linhas e colunas de uma matriz. As posições dos elementos `matrix[i][j]` e `matrix[j][i]` são trocadas. No caso de uma matriz quadrada, os elementos na diagonal permanecem no lugar, e os elementos em posições simétricas em relação à diagonal são trocados entre si.

```java
// Exemplo de transposição de uma matriz 3×3
// Antes da transposição:  Depois da transposição:
// [1, 2, 3]               [1, 4, 7]
// [4, 5, 6]            →  [2, 5, 8]
// [7, 8, 9]               [3, 6, 9]

// matrix[0][1]=2 e matrix[1][0]=4 são trocados
int temp = matrix[i][j];
matrix[i][j] = matrix[j][i];
matrix[j][i] = temp;
```

### O que é Inversão de Array (Reverse)

A inversão é a operação de trocar os elementos de um array simetricamente da esquerda para a direita. Dois ponteiros avançam da extremidade esquerda e da extremidade direita em direção ao centro, trocando os elementos ao longo do caminho.

```java
// [1, 4, 7] → [7, 4, 1]
int left = 0, right = n - 1;
while (left < right) {
    int temp = array[left];
    array[left] = array[right];
    array[right] = temp;
    left++;
    right--;
}
```

### O que é Operação In-Place

Uma operação in-place modifica diretamente os dados de entrada sem alocar uma nova estrutura de dados. O uso de variáveis temporárias (`temp`) é permitido, pois consome apenas O(1) de espaço. Como o problema exige "não alocar uma nova matriz", a solução deve ser realizada in-place.

## Complexidade

| | Valor |
|---|---|
| Time | O(n²) — A transposição realiza n²/2 trocas e a inversão realiza n²/2 trocas |
| Space | O(1) — Apenas variáveis temporárias são utilizadas, nenhuma nova matriz é alocada |

## Código

```java
// Entrada: matriz de inteiros n×n matrix (array bidimensional int[][]). Por ser uma matriz quadrada, o número de linhas e colunas é o mesmo
// Saída: nenhuma (void). A própria matriz passada como argumento é modificada para o estado rotacionado em 90 graus no sentido horário
public void rotate(int[][] matrix) {
    // Obtém o tamanho n da matriz usando matrix.length
    int n = matrix.length;

    // Passo 1: Transposição (trocar elementos em relação à diagonal, invertendo linhas e colunas)
    for (int i = 0; i < n; i++) {
        // j começa em i+1 porque: elementos na diagonal (i==j) não precisam ser trocados, e o intervalo j<i já foi trocado
        for (int j = i + 1; j < n; j++) {
            // Troca matrix[i][j] e matrix[j][i] usando uma variável temporária, invertendo linhas e colunas
            int temp = matrix[i][j];
            matrix[i][j] = matrix[j][i];
            matrix[j][i] = temp;
        }
    }

    // Passo 2: Inverter cada linha horizontalmente
    for (int i = 0; i < n; i++) {
        // Dois ponteiros são posicionados nas extremidades esquerda e direita, trocando elementos em direção ao centro
        int left = 0, right = n - 1;
        while (left < right) {
            // Troca matrix[i][left] e matrix[i][right] para inverter a linha horizontalmente
            int temp = matrix[i][left];
            matrix[i][left] = matrix[i][right];
            matrix[i][right] = temp;
            left++;
            right--;
        }
    }
    // Quando a inversão de todas as linhas é concluída, a matriz inteira está no estado rotacionado em 90 graus no sentido horário
}
```
