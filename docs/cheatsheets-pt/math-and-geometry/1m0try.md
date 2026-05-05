# Setting Entire Rows and Columns to Zero — Definir como zero linhas e colunas inteiras que contêm zero

## Essência do problema

Uma matriz m×n é fornecida. Ao encontrar um elemento igual a 0, todas as posições da **linha inteira** e da **coluna inteira** às quais esse elemento pertence devem ser definidas como 0. Essa transformação deve ser realizada in-place (sem utilizar uma matriz adicional).

## Ideia central

Se reutilizarmos a linha 0 e a coluna 0 da matriz como área de flags para registrar "quais linhas e colunas devem ser zeradas", é possível gerenciar as linhas e colunas a serem zeradas com espaço adicional O(1).

## Processo de raciocínio

1. **É necessário registrar quais linhas e colunas devem ser zeradas**: Se sobrescrevermos a linha ou coluna no momento em que encontramos um zero durante a varredura, nas varreduras subsequentes não será possível distinguir se o valor original era zero ou se foi zerado pela sobrescrita. Por isso, é necessário um método de dois passos: primeiro registrar "quais linhas e colunas devem ser zeradas" e depois sobrescrever tudo de uma vez
2. **Usar arrays separados para registro custa O(m+n) de espaço**: Poderíamos usar um array de tamanho m para as linhas e um de tamanho n para as colunas, mas o objetivo é alcançar espaço O(1)
3. **Usar a linha 0 e a coluna 0 da própria matriz como flags**: Se `matrix[i][0]` for 0, significa "zerar a linha i"; se `matrix[0][j]` for 0, significa "zerar a coluna j". Dessa forma, arrays adicionais se tornam desnecessários
4. **Apenas a flag da coluna 0 requer uma variável independente**: `matrix[i][0]` acumula dois significados: "flag da linha i" e "valor original da coluna 0". A decisão de zerar a própria coluna 0 é gerenciada por uma variável separada `firstCol`
5. **Marcação das flags**: Percorremos a matriz e, ao encontrar `matrix[i][j] == 0`, definimos `matrix[i][0] = 0` e `matrix[0][j] = 0` para marcar as flags
6. **Zerar em ordem reversa**: Ao escrever os zeros com base nas flags, se sobrescrevermos a linha 0 e a coluna 0 primeiro, as flags serão corrompidas. Por isso, processamos do final para o início em ordem reversa, e a linha 0 e a coluna 0 são processadas por último

## Conhecimentos prévios

### O que é operação in-place

É uma operação que obtém o resultado sobrescrevendo os próprios dados de entrada, sem utilizar estruturas de dados adicionais (outra matriz ou arrays grandes). Apenas um número constante de variáveis adicionais é permitido.

```java
// Exemplo de operação in-place: sobrescrever diretamente os elementos da matriz
matrix[i][j] = 0;  // Modificar a matriz original diretamente, sem copiar para outro array
```

### O que é uma flag do tipo boolean

É uma variável que registra "se uma determinada condição foi satisfeita" com dois valores: true/false. Se a condição for satisfeita pelo menos uma vez durante o loop, a variável é definida como true e consultada no processamento subsequente.

```java
boolean firstCol = false;       // Valor inicial é false (condição não satisfeita)
if (matrix[i][0] == 0)
    firstCol = true;            // Registrar que a condição foi satisfeita
// Consultar posteriormente
if (firstCol)
    matrix[i][0] = 0;          // Se a flag for true, executar o processamento
```

### O que é loop em ordem reversa

É um loop que percorre um array ou matriz do final para o início. Quando o elemento do início serve como flag utilizada no processamento subsequente, a ordem reversa é utilizada para processar o início por último.

```java
for (int i = m - 1; i >= 0; i--)    // Decrementar i de 1 em 1, do final (m-1) até 0
    for (int j = n - 1; j >= 1; j--)  // Decrementar j de 1 em 1, do final (n-1) até 1
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m × n) — A matriz inteira é percorrida duas vezes (uma vez para definir as flags, uma vez para zerar) |
| Space | O(1) — A única variável adicional é `firstCol`. A própria matriz é reutilizada como área de flags |

## Código

```java
// Entrada: matriz de inteiros m×n matrix (array bidimensional)
// Saída: nenhuma (matrix é modificada diretamente. O retorno é void)
public void setZeroes(int[][] matrix) {
    // Obter o número de linhas m e o número de colunas n
    int m = matrix.length;
    int n = matrix[0].length;
    // Flag que registra se a coluna 0 deve ser zerada
    // Como matrix[i][0] é compartilhado com a flag de linha, apenas a flag da coluna 0 é gerenciada por uma variável independente
    boolean firstCol = false;

    // Primeiro passo: marcação das flags
    for (int i = 0; i < m; i++) {
        // Verificar se a coluna 0 originalmente contém zero; se sim, definir firstCol como true
        if (matrix[i][0] == 0)
            firstCol = true;
        // Percorrer a partir de j=1 (j=0 é compartilhado com a flag de linha, então apenas colunas a partir de 1 são verificadas)
        for (int j = 1; j < n; j++)
            if (matrix[i][j] == 0) {
                matrix[i][0] = 0;  // Flag para zerar a linha i
                matrix[0][j] = 0;  // Flag para zerar a coluna j
            }
    }

    // Segundo passo: escrever zeros em ordem reversa
    // Motivo da ordem reversa: como as flags da linha 0 (matrix[0][j]) são usadas no processamento das outras linhas, a linha 0 é processada por último
    for (int i = m - 1; i >= 0; i--) {
        // Percorrer em ordem reversa a partir de j=1; se a flag de linha ou de coluna estiver marcada, zerar
        for (int j = n - 1; j >= 1; j--)
            if (matrix[i][0] == 0 || matrix[0][j] == 0)
                matrix[i][j] = 0;
        // Zerar a coluna 0 após o loop interno
        // Atenção: se matrix[i][0] for sobrescrito antes, a verificação da flag de linha acima será corrompida
        if (firstCol)
            matrix[i][0] = 0;
    }
}
```
