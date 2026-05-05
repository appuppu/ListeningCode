# Maximizing Coins From Bursting Balloons — Otimizar a ordem de estourar balões para maximizar moedas

## Essência do problema

O programa recebe um array de inteiros `nums` (valor de cada balão). Ao estourar o balão `i`, o jogador obtém `nums[left] * nums[i] * nums[right]` moedas (left e right são os balões adjacentes restantes). O programa deve retornar o valor máximo de moedas obtido ao estourar todos os balões. Valores fora dos limites do array são tratados como `1`.

## Ideia central

Em vez de pensar "em qual ordem estourar os balões", o raciocínio é invertido para "qual balão estourar **por último**" no intervalo `[left, right]`. Ao fixar o balão `k` como o último a ser estourado, os subintervalos esquerdo e direito tornam-se independentes entre si, permitindo compor a solução ótima com DP de intervalos.

## Processo de raciocínio

1. **Eliminar a dependência da ordem de estouro**: Ao estourar um balão, a relação de adjacência muda, portanto as moedas obtidas variam conforme a ordem. Explorar todas as ordens resulta em `n!` combinações, o que é impraticável. É necessário encontrar uma perspectiva que elimine essa dependência
2. **Pensar em "estourar por último" torna os intervalos independentes**: Ao decidir que o balão `k` será o último estourado no intervalo `[left, right]`, no momento de estourar `k`, todos os balões de `[left, k-1]` e `[k+1, right]` já foram eliminados. Isso significa que os vizinhos de `k` ficam fixos em `arr[left-1]` e `arr[right+1]`, que estão fora do intervalo. Como os subproblemas esquerdo e direito se tornam independentes, é possível compô-los com DP
3. **Simplificar o tratamento de bordas**: O algoritmo cria um novo array `arr` adicionando balões virtuais com valor `1` em ambas as extremidades do array original. Definindo `arr[0] = 1` e `arr[n+1] = 1`, a fórmula `arr[left-1] * arr[k] * arr[right+1]` pode ser utilizada de forma uniforme, sem tratamento especial para as bordas
4. **Definição da tabela DP**: `dp[left][right]` é definido como "o valor máximo de moedas obtido ao estourar todos os balões no intervalo `[left, right]`". A resposta final é `dp[1][n]` (o intervalo correspondente ao array original completo)
5. **Preencher a partir dos intervalos mais curtos**: O preenchimento da tabela DP começa com intervalos de comprimento 1 (um único balão) e avança até intervalos de comprimento `n`. Como os valores de intervalos mais longos dependem dos valores de intervalos mais curtos, calcular a partir dos mais curtos garante que os valores referenciados já estejam calculados
6. **Explorar todos os balões como último a ser estourado em cada intervalo**: Para o intervalo `[left, right]`, o algoritmo testa o balão `k` como último estourado, variando `k` de `left` até `right`. As moedas obtidas ao estourar `k` por último são `arr[left-1] * arr[k] * arr[right+1] + dp[left][k-1] + dp[k+1][right]`, e o valor máximo é registrado em `dp[left][right]`

## Conhecimentos prévios

### DP de intervalos (Interval DP)

O DP de intervalos é uma técnica que constrói a tabela DP usando o intervalo `[left, right]` como unidade. O método divide o intervalo e combina as soluções ótimas dos subintervalos para obter a solução ótima do intervalo inteiro. O cálculo é feito de forma bottom-up, dos intervalos mais curtos para os mais longos.

```java
// Estrutura básica do DP de intervalos: calcular na ordem crescente do comprimento do intervalo
for (int len = 1; len <= n; len++) {        // Comprimento do intervalo
    for (int left = 1; left <= n - len + 1; left++) {  // Extremidade esquerda do intervalo
        int right = left + len - 1;          // Extremidade direita do intervalo
        // Calcular dp[left][right]
    }
}
```

### Sentinela (Sentinel)

A sentinela é uma técnica que adiciona elementos virtuais em ambas as extremidades do array para eliminar o tratamento especial de condições de borda. Neste problema, balões com valor `1` são colocados em ambas as extremidades.

```java
int[] arr = new int[n + 2];   // Criar um array 2 posições maior que o original
arr[0] = 1;                   // Sentinela na extremidade esquerda (valor 1)
arr[n + 1] = 1;               // Sentinela na extremidade direita (valor 1)
for (int i = 0; i < n; i++)
    arr[i + 1] = nums[i];     // Copiar os elementos originais para os índices 1 a n
```

### Tabela DP com array bidimensional

`dp[i][j]` registra a solução ótima para o intervalo `[i, j]`. Em Java, ao criar com `new int[n+2][n+2]`, todos os elementos são inicializados com `0`. Como intervalos vazios (`left > right`) devem permanecer com valor `0`, nenhum processamento adicional de inicialização é necessário.

```java
int[][] dp = new int[n + 2][n + 2];  // Todos os elementos são inicializados com 0
dp[left][right];                      // Armazena o máximo de moedas do intervalo [left, right]
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n³) — Três loops aninhados para a extremidade esquerda, a extremidade direita e a posição do último balão estourado |
| Space | O(n²) — Utiliza a tabela DP `dp[n+2][n+2]` |

## Código

```java
// Entrada: array de inteiros nums (valor de cada balão)
// Saída: retorna como int o valor máximo de moedas obtido ao estourar todos os balões
public int maxCoins(int[] nums) {
    int n = nums.length;

    // Criar um array com sentinelas (valor 1) adicionadas em ambas as extremidades
    // Essas sentinelas eliminam a necessidade de tratamento especial ao referenciar posições fora do intervalo
    int[] arr = new int[n + 2];
    arr[0] = arr[n + 1] = 1;
    for (int i = 0; i < n; i++)
        arr[i + 1] = nums[i];

    // dp[left][right] = valor máximo de moedas obtido ao estourar todos os balões no intervalo [left, right]
    // O tamanho é n+2 para incluir os índices das sentinelas (0 e n+1)
    // Intervalos vazios (left > right) permanecem com valor 0
    int[][] dp = new int[n + 2][n + 2];

    // Calcular na ordem crescente do comprimento do intervalo
    // Calcular a partir dos intervalos mais curtos garante que os valores dos subintervalos necessários já estejam calculados ao processar intervalos mais longos
    for (int len = 1; len <= n; len++) {
        // Percorrer todos os intervalos de comprimento len
        for (int left = 1; left <= n - len + 1; left++) {
            int right = left + len - 1;

            // Explorar todos os balões k como último a ser estourado no intervalo [left, right]
            for (int k = left; k <= right; k++) {
                // Ao decidir estourar k por último, os vizinhos de k ficam fixos em arr[left-1] e arr[right+1], que estão fora do intervalo
                int coins = arr[left - 1] * arr[k] * arr[right + 1];
                // Somar as moedas dos subintervalos esquerdo e direito para obter o total
                int total = coins + dp[left][k - 1] + dp[k + 1][right];
                // Atualizar dp[left][right] com o valor máximo
                dp[left][right] = Math.max(dp[left][right], total);
            }
        }
    }

    // Retornar o máximo de moedas correspondente ao array original completo (índices 1 a n)
    return dp[1][n];
}
```
