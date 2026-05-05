# Finding the Minimum Cost to Climb Stairs — Encontrar o custo mínimo para alcançar o topo da escada

## Essência do problema

Um array de inteiros `cost` é fornecido, onde `cost[i]` representa o custo de pisar no degrau i. Você pode começar do degrau 0 ou do degrau 1, e em cada passo pode subir 1 ou 2 degraus. Retorne o custo total mínimo para alcançar o **topo** da escada (uma posição além do final do array).

## Ideia central

O custo mínimo para alcançar cada degrau é determinado pelo menor valor entre "vir do degrau anterior" e "vir de dois degraus atrás". Como esse cálculo depende apenas dos dois resultados anteriores, é possível calcular o custo mínimo usando apenas duas variáveis, sem manter um array.

## Processo de raciocínio

1. **Existem duas formas de alcançar o topo**: O topo (índice n) pode ser alcançado subindo 1 degrau a partir do degrau anterior (n-1) ou subindo 2 degraus a partir de dois degraus atrás (n-2). O menor custo entre essas duas opções é a resposta
2. **O custo mínimo para cada degrau pode ser definido recursivamente**: Se definirmos `dp[i]` como o custo mínimo para alcançar o degrau i, a recorrência `dp[i] = min(dp[i-1] + cost[i-1], dp[i-2] + cost[i-2])` é válida. Escolhemos o menor entre "custo mínimo do degrau anterior + custo desse degrau" e "custo mínimo de dois degraus atrás + custo desse degrau"
3. **Definir as condições iniciais**: Como é possível começar do degrau 0 ou do degrau 1, o custo para alcançar os degraus 0 e 1 é 0. Ou seja, `dp[0] = 0` e `dp[1] = 0`
4. **Não é necessário o array inteiro, apenas os dois valores anteriores**: A recorrência `dp[i]` depende apenas de `dp[i-1]` e `dp[i-2]`. Portanto, em vez de um array, basta manter duas variáveis: `prev1` (degrau anterior) e `prev2` (dois degraus atrás)
5. **Avançar atualizando as variáveis**: Iteramos do degrau 2 até o degrau n, calculando `curr` a cada iteração e deslizando com `prev2 = prev1`, `prev1 = curr`. Ao final do loop, `prev1` contém o custo mínimo para alcançar o topo

## Conhecimentos prévios

### O que é Programação Dinâmica (Dynamic Programming)

É uma técnica que divide um problema grande em subproblemas menores e reutiliza os resultados dos subproblemas para encontrar a solução de forma eficiente. Neste problema, o subproblema é "o custo mínimo para alcançar o degrau i", resolvido sequencialmente a partir dos índices menores (abordagem bottom-up).

### O que é Math.min

É um método padrão do Java que retorna o menor entre dois inteiros. É usado para escolher a opção de menor custo entre duas alternativas.

```java
Math.min(5, 3);    // Retorna 3 — retorna o menor dos dois argumentos
Math.min(10, 10);  // Retorna 10 — se os valores forem iguais, retorna esse valor
```

### Conceito de otimização de espaço

Quando cada elemento do array de DP depende apenas dos últimos poucos elementos, é possível realizar o cálculo com apenas o número necessário de variáveis, em vez de manter o array inteiro. Neste problema, apenas `dp[i-1]` e `dp[i-2]` são necessários, então duas variáveis são suficientes.

```java
int prev2 = 0;  // Variável correspondente a dp[i-2]
int prev1 = 0;  // Variável correspondente a dp[i-1]
int curr;       // Variável correspondente a dp[i] (calculada e atualizada a cada iteração)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer o array uma única vez |
| Space | O(1) — Utiliza apenas duas variáveis, sem depender do tamanho do array |

## Código

```java
// Entrada: array de inteiros cost (custo de pisar em cada degrau)
// Saída: retorna como int o custo total mínimo para alcançar o topo da escada (índice n)
public int minCostClimbingStairs(int[] cost) {
    // Obtém o comprimento do array. O topo está na posição de índice n (uma posição além do final do array)
    int n = cost.length;

    // prev2 = custo mínimo para o degrau dois passos atrás, prev1 = custo mínimo para o degrau anterior
    // Como é possível começar dos degraus 0 e 1, o custo inicial é 0
    int prev2 = 0, prev1 = 0;

    // Calcula o custo mínimo sequencialmente do degrau 2 até o topo (degrau n). i é o degrau que estamos tentando alcançar
    for (int i = 2; i <= n; i++) {
        // prev1 + cost[i-1]: custo total de subir 1 degrau a partir do degrau anterior
        // prev2 + cost[i-2]: custo total de subir 2 degraus a partir de dois degraus atrás
        // Escolhe o menor dos dois
        int curr = Math.min(
            prev1 + cost[i - 1],
            prev2 + cost[i - 2]);

        // Desliza as variáveis uma posição para frente
        // Atenção: prev2 deve ser atualizado primeiro, caso contrário o valor original de prev1 será perdido
        prev2 = prev1;
        prev1 = curr;
    }

    // prev1 contém o custo mínimo para alcançar o topo, calculado na última iteração do loop (i = n)
    return prev1;
}
```
