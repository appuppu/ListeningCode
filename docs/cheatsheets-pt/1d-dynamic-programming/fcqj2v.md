# Finding the Fewest Coins to Make a Target Amount — Encontrar o número mínimo de moedas para atingir um valor-alvo

## Essência do problema

É fornecido um array `coins` contendo os valores das moedas e um valor-alvo `amount`. Usando quantas moedas quiser do array `coins`, entre todas as combinações cuja soma é igual a `amount`, o objetivo é retornar o **número mínimo de moedas**. Se não for possível formar o valor `amount` com nenhuma combinação, retorna-se `-1`.

## Ideia central

Se calcularmos de forma bottom-up "o número mínimo de moedas necessário para formar cada valor" desde o valor 0 até o valor-alvo, o número mínimo de moedas para o valor `i` pode ser obtido como o menor valor entre "`número mínimo de moedas para o valor obtido subtraindo cada denominação de moeda de i` + 1".

## Processo de raciocínio

1. **O problema pode ser decomposto em subproblemas**: Se a última moeda usada para formar o valor `i` for a moeda `c`, e se já soubermos o número mínimo de moedas para formar o valor restante `i - c`, então o número mínimo de moedas para o valor `i` pode ser obtido por `dp[i - c] + 1`. Essa estrutura é adequada para programação dinâmica
2. **Não se sabe antecipadamente qual moeda será a última**: Todas as denominações de moedas são candidatas para a última moeda. Por isso, calcula-se `dp[i - c] + 1` para todas as moedas `c` e define-se o menor valor como `dp[i]`. Esta é a equação de transição `dp[i] = min(dp[i - c] + 1)` para cada moeda `c`
3. **Definir o caso base**: Como são necessárias 0 moedas para formar o valor 0, define-se `dp[0] = 0`. Este é o ponto de partida do cálculo bottom-up
4. **Definir um valor inicial representando "inalcançável"**: Como não se sabe antecipadamente se cada valor pode ser formado, todos os elementos do array `dp` são inicializados com `amount + 1` (um número de moedas impossivelmente grande). Os valores que não forem atualizados significam que "o valor não pode ser formado"
5. **Preencher a tabela sequencialmente a partir do valor 1**: Partindo de `dp[0]`, a tabela é preenchida na ordem dos valores 1, 2, ..., `amount`. No momento de calcular o valor `i`, o número mínimo de moedas para todos os valores menores que `i` já está determinado, portanto é seguro referenciar `dp[i - c]`
6. **O que retornar no final**: Se `dp[amount]` permanecer como `amount + 1`, o valor-alvo não pode ser formado, então retorna-se `-1`. Caso contrário, `dp[amount]` é o número mínimo de moedas

## Conhecimentos prévios

### O que é Programação Dinâmica (Dynamic Programming)

É uma técnica que decompõe um problema grande em subproblemas menores e constrói a solução de forma bottom-up, registrando a solução de cada subproblema em uma tabela. Como evita resolver o mesmo subproblema repetidamente, possui boa eficiência computacional.

```java
// Padrão básico de DP bottom-up
int[] dp = new int[n + 1];     // Criar a tabela
dp[0] = baseCase;              // Definir o caso base
for (int i = 1; i <= n; i++) { // Resolver os subproblemas do menor para o maior
    dp[i] = /* Calcular usando resultados anteriores como dp[i-1] */;
}
return dp[n];                  // Retornar a resposta final
```

### O que é Arrays.fill

É um método padrão do Java que preenche todos os elementos de um array com um valor especificado. É frequentemente usado para inicializar arrays de DP.

```java
int[] dp = new int[5];       // [0, 0, 0, 0, 0] é criado
Arrays.fill(dp, 100);        // Preenche todos os elementos com 100 → [100, 100, 100, 100, 100]
```

### O que é Math.min

É um método padrão do Java que retorna o menor entre dois inteiros. É usado para selecionar o valor mínimo entre múltiplos candidatos.

```java
Math.min(3, 7);    // → 3
Math.min(dp[i], dp[i - coin] + 1);  // Seleciona o menor entre o valor atual e o novo candidato
```

## Complexidade

| | Valor |
|---|---|
| Time | O(amount × n) — Para cada valor, percorre-se n tipos de moedas (n é o comprimento do array coins) |
| Space | O(amount) — O array dp armazena amount+1 elementos |

## Código

```java
// Entrada: array de inteiros coins contendo as denominações das moedas e inteiro amount representando o valor-alvo
// Saída: retorna um int com o número mínimo de moedas cuja soma é amount. Retorna -1 se não for possível formá-lo
int coinChange(int[] coins, int amount) {
    // dp[i] = número mínimo de moedas necessário para formar o valor i
    // Como corresponde a cada valor do índice 0 até amount, o tamanho é amount + 1
    int[] dp = new int[amount + 1];

    // Inicializa todos os elementos com um valor sentinela representando "inalcançável"
    // Como a menor denominação de moeda é pelo menos 1, nunca serão necessárias mais de amount moedas; se este valor permanecer, significa que "o valor não pode ser formado"
    Arrays.fill(dp, amount + 1);

    // Caso base: são necessárias 0 moedas para formar o valor 0. Ponto de partida do cálculo bottom-up
    dp[0] = 0;

    // Preenche a tabela sequencialmente do valor 1 até amount
    // Calculando dos valores menores para os maiores, garante-se que dp[i - coin] já está determinado
    for (int i = 1; i <= amount; i++) {
        // Testa cada moeda como candidata a "última moeda para formar o valor i" e busca a denominação ótima entre todas
        for (int coin : coins) {
            // Se coin > i, essa moeda não pode formar o valor i, então é ignorada
            if (coin <= i)
                // dp[i - coin] + 1 é "o número mínimo de moedas para o valor i - coin mais 1 moeda adicionada"
                // Compara com o dp[i] atual e adota o menor valor
                dp[i] = Math.min(dp[i],
                    dp[i - coin] + 1);
        }
    }

    // Se o valor sentinela permaneceu, significa que não foi atualizado desde a inicialização = o valor-alvo não pode ser formado, então retorna -1
    return dp[amount] > amount
        ? -1 : dp[amount];
}
```
