# Finding the Longest Common Subsequence — Encontrar o comprimento da maior subsequência comum entre duas strings

## Essência do Problema

Duas strings `text1` e `text2` são fornecidas. O objetivo é retornar o **comprimento** da **subsequência (subsequence)** mais longa que é comum a ambas as strings. Uma subsequência é uma sequência obtida selecionando caracteres da string original mantendo a ordem relativa, sem a necessidade de serem consecutivos.

## Ideia Central

Se os últimos caracteres das duas strings coincidem, esse caractere faz parte da LCS, e o subproblema restante consiste em ambas as strings reduzidas em um caractere. Se não coincidem, o algoritmo adota o maior resultado entre os dois subproblemas obtidos ao reduzir uma das strings em um caractere. Ao preencher essa estrutura recursiva de forma bottom-up em uma tabela bidimensional, a solução ótima é obtida sem cálculos redundantes.

## Processo de Raciocínio

1. **Definição do subproblema**: Define-se `dp[i][j]` como o comprimento da LCS entre os primeiros `i` caracteres de `text1` e os primeiros `j` caracteres de `text2`. A resposta final desejada é `dp[m][n]` (`m` = comprimento de text1, `n` = comprimento de text2)
2. **Transição quando os últimos caracteres coincidem**: Quando `text1[i-1] == text2[j-1]`, esse caractere faz parte da LCS. Portanto, `dp[i][j] = dp[i-1][j-1] + 1`. O algoritmo soma 1 à resposta do subproblema em que ambas as strings são reduzidas em um caractere
3. **Transição quando os últimos caracteres não coincidem**: Quando `text1[i-1] != text2[j-1]`, pelo menos um dos últimos caracteres não faz parte da LCS. O algoritmo adota o maior valor entre reduzir `text1` em um caractere (`dp[i-1][j]`) e reduzir `text2` em um caractere (`dp[i][j-1]`). Ou seja, `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`
4. **Caso base**: Quando uma das strings está vazia (comprimento 0), não existe subsequência comum, então `dp[0][j] = 0` e `dp[i][0] = 0`. Em Java, ao criar um `int[][]`, todos os elementos são inicializados com 0, portanto não é necessário definir isso explicitamente
5. **Ordem de preenchimento da tabela**: `dp[i][j]` depende de `dp[i-1][j-1]`, `dp[i-1][j]` e `dp[i][j-1]`. Portanto, ao preencher `i` de 1 a m e `j` de 1 a n em ordem crescente, as células referenciadas já estarão calculadas
6. **Valor a ser retornado**: Após preencher toda a tabela, `dp[m][n]` contém o comprimento da LCS das duas strings completas, e esse valor é retornado

## Conhecimentos Prévios

### O que é uma Subsequência (Subsequence)

Uma subsequência é uma sequência obtida ao remover zero ou mais caracteres de uma string, mantendo a ordem relativa dos caracteres restantes. Diferentemente de uma substring (subcadeia), os caracteres não precisam ser consecutivos.

```
String: "abcde"
Exemplo de subsequência: "ace" (selecionando a, c, e. Removendo b, d)
Exemplo que não é subsequência: "aec" (viola a ordem a→c→e na string original)
```

### Criação e Inicialização de Array Bidimensional

Em Java, ao declarar `new int[m+1][n+1]`, um array bidimensional de tamanho `(m+1) × (n+1)` é criado com todos os elementos inicializados com 0.

```java
int[][] dp = new int[m + 1][n + 1];  // Cria um array de (m+1) linhas × (n+1) colunas, todos os elementos com 0
dp[i][j] = 5;                         // Atribui o valor 5 à linha i, coluna j
int val = dp[i][j];                    // Obtém o valor da linha i, coluna j → 5
```

### O que é Math.max

Um método que retorna o maior entre dois inteiros. É utilizado para comparar as soluções de dois subproblemas e selecionar a melhor.

```java
Math.max(3, 7);    // Retorna o maior entre dois valores → 7
Math.max(dp[i-1][j], dp[i][j-1]);  // Compara os valores de duas células e retorna o maior
```

### O que é charAt

Um método que retorna o caractere na posição especificada de uma string. O índice começa em 0.

```java
String s = "abc";
s.charAt(0);    // Retorna o caractere no índice 0 → 'a'
s.charAt(2);    // Retorna o caractere no índice 2 → 'c'
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m × n) — Cada célula da tabela m×n é preenchida uma vez |
| Space | O(m × n) — Utiliza um array bidimensional de tamanho (m+1)×(n+1) |

## Código

```java
// Entrada: duas strings text1 e text2
// Saída: retorna o comprimento da maior subsequência comum entre as duas strings como int
public int longestCommonSubsequence(String text1, String text2) {
    // Atribui o comprimento de text1 a m e o comprimento de text2 a n. Usados para o tamanho da tabela e limite dos loops
    int m = text1.length();
    int n = text2.length();

    // dp[i][j] = comprimento da LCS entre os primeiros i caracteres de text1 e os primeiros j caracteres de text2
    // O tamanho é (m+1)×(n+1) para representar o caso em que uma das strings é vazia (caso base)
    // Em Java, todos os elementos de int[][] são inicializados com 0, então os casos base dp[0][j]=0 e dp[i][0]=0 são satisfeitos automaticamente
    int[][] dp = new int[m + 1][n + 1];

    // i representa quantos caracteres do início de text1 estão sendo considerados
    for (int i = 1; i <= m; i++) {
        // j representa quantos caracteres do início de text2 estão sendo considerados
        for (int j = 1; j <= n; j++) {
            // O índice de dp começa em 1, mas o índice da string começa em 0, então acessa-se com i-1 e j-1
            if (text1.charAt(i - 1) == text2.charAt(j - 1)) {
                // Quando os caracteres coincidem, o caractere correspondente é adicionado à LCS, então soma-se 1 à resposta do subproblema com ambas as strings reduzidas em um caractere
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                // Quando os caracteres não coincidem, adota-se o maior valor entre reduzir text1 em um caractere e reduzir text2 em um caractere
                dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }

    // O canto inferior direito da tabela contém o comprimento da LCS entre text1 e text2 completos
    return dp[m][n];
}
```
