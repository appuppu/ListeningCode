# Counting Combinations to Make a Target Amount — Contar o número de combinações de moedas para formar um valor alvo

## Essência do problema

É fornecido um array `coins` contendo os valores das moedas e um inteiro `amount`. O objetivo é retornar o **número de combinações** usando as moedas de `coins`, podendo repetir cada moeda quantas vezes quiser, de forma que a soma seja exatamente `amount`. Duas combinações são diferentes quando pelo menos uma moeda é usada um número diferente de vezes. Sequências que diferem apenas na ordem são tratadas como a mesma combinação.

## Ideia central

Processamos os tipos de moeda um por um, em ordem, e para cada moeda acumulamos no array DP "o número de combinações ao usar zero ou mais unidades dessa moeda". Ao iterar os tipos de moeda no loop externo, eliminamos naturalmente a contagem duplicada (permutações) que surgiria ao contar o mesmo conjunto de moedas em ordens diferentes.

## Processo de raciocínio

1. **Distinguir combinações de permutações**: Este problema pede "o número de combinações", então [1,2] e [2,1] devem ser contados como a mesma coisa. Se colocarmos o valor no loop externo e escolhermos moedas no loop interno, contaremos permutações; portanto, precisamos fixar a ordem de processamento colocando os tipos de moeda no loop externo
2. **Definir o estado do DP**: Definimos `dp[a]` como "o número de combinações para formar exatamente o valor `a`". A resposta final será `dp[amount]`
3. **Definir o caso base**: Há exatamente uma maneira de formar o valor 0, que é "não usar nenhuma moeda", então definimos `dp[0] = 1`. Sem esse caso base, a adição sempre somaria zero a partir de qualquer moeda, e a resposta seria sempre 0
4. **Derivar a relação de recorrência**: Para formar o valor `a` usando pelo menos uma unidade da moeda `coin`, basta somar o número de combinações do valor restante `a - coin`. Ou seja, a recorrência é `dp[a] += dp[a - coin]`. Como `dp[a - coin]` já inclui combinações com zero ou mais unidades da mesma moeda, essa adição cobre automaticamente os casos de usar 1, 2, 3… unidades da moeda
5. **Definir a ordem dos loops**: O loop externo processa um tipo de moeda por vez, e o loop interno percorre os valores `a` de `coin` até `amount` em ordem crescente. Dessa forma, cada moeda adiciona sua contribuição ao "número de combinações considerando apenas os tipos de moeda anteriores", evitando contagem duplicada de permutações
6. **Valor a retornar**: Após processar todas as moedas, `dp[amount]` contém o número total de combinações para formar o valor alvo

## Conhecimentos prévios

### O que é um array DP (array unidimensional de programação dinâmica)

É uma técnica que armazena as respostas dos subproblemas em um array e as reutiliza para calcular eficientemente a resposta de problemas maiores. Neste problema, `dp[a]` representa "o número de combinações para formar o valor `a`".

```java
int[] dp = new int[amount + 1];  // Cria um array com índices de 0 a amount (todos inicializados com 0)
dp[0] = 1;                       // Caso base: há 1 maneira de formar o valor 0
dp[a] += dp[a - coin];           // Recorrência: soma ao número de combinações para o valor a o número de combinações do restante após usar uma moeda
```

### Por que o loop externo deve ser sobre as moedas

Se o valor estiver no loop externo e as moedas no interno, ao formar o valor 5, contaríamos [1,2,2], [2,1,2] e [2,2,1] separadamente (permutações). Com as moedas no loop externo, o processamento da moeda 1 é concluído antes de processar a moeda 2, fixando a ordem "moeda 1 → moeda 2" e contando apenas combinações.

```java
// Contar combinações (ordem correta)
for (int coin : coins) {          // Externo: processa cada tipo de moeda
    for (int a = coin; a <= amount; a++) {  // Interno: percorre os valores
        dp[a] += dp[a - coin];
    }
}

// Conta permutações (ordem incorreta)
for (int a = 1; a <= amount; a++) {         // Externo: processa cada valor
    for (int coin : coins) {                // Interno: testa todas as moedas
        if (a >= coin) dp[a] += dp[a - coin];
    }
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n × amount) — Para cada um dos n tipos de moeda, percorre os valores de 0 a amount |
| Space | O(amount) — Utiliza apenas um array DP de tamanho amount+1 |

## Código

```java
// Entrada: array de inteiros coins contendo os valores das moedas e inteiro amount representando o valor alvo
// Saída: retorna um int com o número de combinações de moedas cuja soma é exatamente amount
public int change(int amount, int[] coins) {
    // dp[a] = número de combinações para formar exatamente o valor a
    // O tamanho é amount + 1 (para corresponder a cada valor do índice 0 até amount)
    int[] dp = new int[amount + 1];

    // Caso base: há exatamente 1 maneira de formar o valor 0, que é "não escolher nada"
    // Sem esse caso base, o valor de origem na recorrência seria sempre 0, e todos os resultados seriam 0
    dp[0] = 1;

    // Processa cada tipo de moeda (o loop externo fixa a ordem e conta apenas combinações)
    // Colocar os tipos de moeda no loop externo evita a contagem duplicada (permutações) do mesmo conjunto de moedas em ordens diferentes
    for (int coin : coins) {
        // Percorre os valores de coin até amount em ordem crescente
        // Começa em coin porque a - coin precisa ser maior ou igual a 0
        // A ordem crescente faz com que o uso de múltiplas unidades da mesma moeda seja refletido naturalmente
        for (int a = coin; a <= amount; a++) {
            // Usa uma unidade de coin e soma o número de combinações do restante a-coin
            // Como dp[a - coin] já inclui combinações com 0 ou mais unidades da mesma moeda,
            // esta única linha cobre todos os casos de usar 1, 2, 3… unidades de coin
            dp[a] += dp[a - coin];
        }
    }

    // Retorna o número total de combinações para formar o valor alvo
    return dp[amount];
}
```
