# Counting Unique Paths in a Grid — Contar o número de caminhos únicos do canto superior esquerdo ao canto inferior direito de um grid

## Essência do Problema

É dado um grid de `m × n`. Partindo da célula superior esquerda `(0, 0)` até a célula inferior direita `(m-1, n-1)`, podendo mover-se **apenas para a direita ou para baixo** em cada passo, retorne o número total de caminhos únicos.

## Ideia Central

O número de caminhos até uma célula é a soma do "número de caminhos até a célula de cima" e do "número de caminhos até a célula da esquerda". Preenchendo essa recorrência de forma bottom-up, obtemos a resposta. Como o cálculo de cada linha depende apenas da linha anterior e da linha atual, é possível economizar espaço usando apenas um array de uma linha.

## Processo de Raciocínio

1. **O número de caminhos até cada célula pode ser decomposto em subproblemas**: Para chegar à célula `(i, j)`, é necessário vir de cima `(i-1, j)` ou da esquerda `(i, j-1)`. Portanto, a recorrência `dp[i][j] = dp[i-1][j] + dp[i][j-1]` é válida
2. **Definir os casos base**: As células da linha superior só podem ser alcançadas pela esquerda, e as células da coluna mais à esquerda só podem ser alcançadas por cima. Em ambos os casos o número de caminhos é 1, então inicializamos com `dp[0][j] = 1` e `dp[i][0] = 1`
3. **Preencher da esquerda para a direita, linha por linha**: A recorrência depende da "célula de cima" e da "célula da esquerda", então percorrendo as linhas de cima para baixo e cada linha da esquerda para a direita, os valores necessários já estarão calculados
4. **O espaço pode ser comprimido para uma única linha**: `dp[i][j]` depende apenas do vizinho à esquerda na mesma linha `dp[i][j-1]` e da mesma coluna na linha anterior `dp[i-1][j]`. Usando um array unidimensional `dp[j]`, o valor de `dp[j]` antes da atualização corresponde ao "valor da célula de cima", e o valor já atualizado de `dp[j-1]` corresponde ao "valor da célula da esquerda", permitindo expressar a recorrência como `dp[j] += dp[j-1]`
5. **A inicialização é com todos os elementos em 1**: Inicializar o array unidimensional inteiramente com 1 representa o estado da linha superior (número de caminhos para cada célula é 1). O elemento `dp[0]`, correspondente à coluna mais à esquerda, não é atualizado no loop interno, permanecendo sempre 1, preservando naturalmente o caso base da coluna mais à esquerda
6. **O que retornar no final**: Após o processamento de todas as linhas, `dp[n-1]` contém o número de caminhos até a célula inferior direita, então retornamos esse valor

## Conhecimentos Prévios

### O que é Arrays.fill

É um método utilitário que inicializa todos os elementos de um array com um valor especificado de uma só vez. Permite preencher um array com um valor uniforme sem escrever um loop.

```java
int[] dp = new int[5];       // Cria um array de tamanho 5 (valor inicial é 0 para todos)
Arrays.fill(dp, 1);          // Define todos os elementos como 1 → [1, 1, 1, 1, 1]
```

### O que é compressão de espaço com DP unidimensional

É uma técnica que substitui um array bidimensional por um array unidimensional quando, em uma tabela de DP bidimensional, o cálculo de cada célula depende apenas da "linha atual" e da "linha anterior". Ao sobrescrever e atualizar o array linha por linha, o espaço é reduzido de O(m×n) para O(n).

```java
// Caso bidimensional: dp[i][j] = dp[i-1][j] + dp[i][j-1]
// Comprimido para unidimensional: dp[j] += dp[j-1]
//   dp[j] (antes da atualização) = valor da mesma coluna na linha anterior (= equivalente a dp[i-1][j])
//   dp[j-1] (já atualizado) = valor do vizinho à esquerda na linha atual (= equivalente a dp[i][j-1])
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m × n) — Percorre cada célula do grid exatamente uma vez |
| Space | O(n) — Mantém apenas um array de uma linha |

## Código

```java
// Entrada: inteiro m (número de linhas) e inteiro n (número de colunas)
// Saída: retorna o número de caminhos únicos do canto superior esquerdo ao canto inferior direito como um inteiro
public int uniquePaths(int m, int n) {
    // Cria um array de DP de uma linha com tamanho n e inicializa todos os elementos com 1
    // Ao definir todos como 1, estabelece o caso base da linha superior (número de caminhos para cada célula é 1)
    int[] dp = new int[n];
    Arrays.fill(dp, 1);

    // i=0 (linha superior) já foi definida pela inicialização, então começa a partir de i=1
    for (int i = 1; i < m; i++) {
        // j=0 (coluna mais à esquerda) deve permanecer sempre 1, então começa a partir de j=1
        for (int j = 1; j < n; j++) {
            // dp[j] (antes da atualização) = valor da mesma coluna na linha anterior (número de caminhos vindos de cima)
            // dp[j-1] (já atualizado) = valor do vizinho à esquerda na linha atual (número de caminhos vindos da esquerda)
            // Esta soma realiza a recorrência dp[i][j] = dp[i-1][j] + dp[i][j-1] em um array unidimensional
            dp[j] += dp[j - 1];
        }
    }

    // dp[n-1] contém o número de caminhos únicos até a célula inferior direita (m-1, n-1) do grid
    return dp[n - 1];
}
```
