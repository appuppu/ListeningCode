# Counting Ways to Assign Signs to Reach a Target Sum — Contando o número de formas de atribuir sinais para alcançar uma soma alvo

## Essência do problema

Um array de inteiros `nums` e um inteiro `target` são fornecidos. O problema consiste em retornar o número de combinações possíveis ao atribuir o sinal `+` ou `-` a cada elemento de `nums`, de forma que a soma de todos os elementos seja igual a `target`.

## Ideia central

O problema de atribuir `+` ou `-` a cada elemento é equivalente ao problema de dividir o array em um "grupo de sinais positivos (P)" e um "grupo de sinais negativos (N)". A partir de P - N = target e P + N = totalSum, deduz-se que P = (target + totalSum) / 2. Portanto, o problema pode ser transformado em um problema de soma de subconjuntos: "contar o número de subconjuntos cuja soma é igual a P".

## Processo de raciocínio

1. **Interpretar a atribuição de sinais como uma divisão de conjuntos**: Se P é a soma dos elementos com sinal `+` e N é a soma dos elementos com sinal `-`, então P - N = target. Ao mesmo tempo, P + N = totalSum (soma de todos os elementos). Resolvendo essas duas equações simultaneamente, obtém-se P = (target + totalSum) / 2
2. **Eliminar previamente as condições em que não existe solução**: Se P = (target + totalSum) / 2 não for um inteiro (ou seja, se `(target + totalSum)` for ímpar), não existe uma divisão válida. Além disso, se `|target|` exceder `totalSum`, também não existe solução. O algoritmo verifica essas condições primeiro e retorna 0
3. **Resolver com DP como um problema de soma de subconjuntos**: "O número de combinações ao selecionar elementos do array `nums` cuja soma seja `subsetSum` (= P)" é um problema clássico de contagem de soma de subconjuntos. Define-se o array DP `dp[j]` como "o número de subconjuntos cuja soma é j" e atualiza-se para cada elemento
4. **Otimizar o espaço com um array DP unidimensional**: Em vez de usar uma tabela bidimensional, prepara-se um array unidimensional `dp[0..subsetSum]` e, para cada elemento `num`, percorre-se `j` de `subsetSum` até `num` em ordem reversa, atualizando com `dp[j] += dp[j - num]`. A razão para percorrer em ordem reversa é evitar o uso múltiplo do mesmo elemento
5. **Definir a condição inicial**: Define-se `dp[0] = 1`. Isso significa que "existe exatamente 1 forma de obter a soma 0 sem selecionar nenhum elemento"
6. **Valor a retornar**: Após processar todos os elementos, `dp[subsetSum]` é o número de subconjuntos cuja soma é `subsetSum`, ou seja, a resposta do problema original

## Conhecimentos prévios

### O que é o Problema de Soma de Subconjuntos (Subset Sum Problem)

É um problema que consiste em selecionar elementos de um conjunto dado de forma que a soma deles seja igual a um valor específico. É uma variante do problema da mochila e pode ser resolvido eficientemente com DP.

### Contagem de soma de subconjuntos com array DP unidimensional

`dp[j]` representa "o número de subconjuntos cuja soma é j". Para cada elemento `num`, atualiza-se com `dp[j] += dp[j - num]`.

```java
int[] dp = new int[targetSum + 1]; // dp[j] = número de combinações cuja soma é j
dp[0] = 1;                         // Existe 1 forma de obter a soma 0 (não selecionar nenhum elemento)
dp[j] += dp[j - num];              // Usar num para obter j = somar o número de formas de obter j-num sem usar num
```

### Razão para o loop em ordem reversa

O loop interno percorre de `subsetSum` até `num` em ordem reversa. Se percorrer na ordem direta, o mesmo elemento `num` seria somado múltiplas vezes dentro da mesma iteração. Ao percorrer em ordem reversa, satisfaz-se a restrição da mochila 0-1, onde cada elemento é "selecionado ou não selecionado".

```java
// Loop em ordem reversa: cada elemento é usado no máximo 1 vez (mochila 0-1)
for (int j = subsetSum; j >= num; j--) {
    dp[j] += dp[j - num];
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n × subsetSum) — O array DP é percorrido uma vez para cada elemento |
| Space | O(subsetSum) — Utiliza-se apenas um array DP unidimensional |

## Código

```java
// Entrada: array de inteiros nums e inteiro target
// Saída: retorna como int o número de combinações que atribuem +/- a cada elemento e cuja soma é igual a target
public int findTargetSumWays(int[] nums, int target) {
    // Calcula a soma de todos os elementos do array nums e armazena na variável totalSum
    int totalSum = 0;
    for (int num : nums) {
        totalSum += num;
    }

    // Verifica as condições em que não existe solução
    // Se (target + totalSum) for ímpar, P = (target + totalSum) / 2 não será um inteiro,
    // e não é possível alcançá-lo com um subconjunto composto por um número inteiro de elementos, portanto retorna 0
    // Se |target| exceder totalSum, nenhuma atribuição de sinais pode alcançar target, portanto retorna 0
    if ((target + totalSum) % 2 != 0
        || Math.abs(target) > totalSum)
        return 0;

    // Calcula o valor da soma do grupo de sinais positivos. Este será o alvo a ser alcançado no processamento seguinte
    int subsetSum = (target + totalSum) / 2;

    // dp[j] = número de combinações ao selecionar elementos de nums cuja soma é j
    int[] dp = new int[subsetSum + 1];
    // Caso base: existe exatamente 1 forma de obter a soma 0 sem selecionar nenhum elemento
    dp[0] = 1;

    // Loop externo: percorre cada elemento do array nums do início ao fim em ordem
    for (int num : nums) {
        // Loop interno: percorre de subsetSum até num em ordem reversa
        // Razão para a ordem reversa: evitar o uso múltiplo do mesmo num dentro da mesma iteração (restrição da mochila 0-1)
        for (int j = subsetSum; j >= num; j--) {
            // Soma o número de formas de obter a soma j - num sem usar num, ao número de formas de obter a soma j usando num
            dp[j] += dp[j - num];
        }
    }

    // dp[subsetSum] é o número de subconjuntos cuja soma é subsetSum, ou seja, o total de formas de atribuir sinais no problema original
    return dp[subsetSum];
}
```
