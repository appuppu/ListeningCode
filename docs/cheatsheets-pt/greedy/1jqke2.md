# Determining if You Can Reach the End of an Array — Determinar se é possível alcançar o final de um array

## Essência do Problema

Um array de inteiros `nums` é fornecido. Cada elemento `nums[i]` representa o **comprimento máximo** que você pode saltar para frente a partir daquele índice. Partindo do índice `0`, retorne um `boolean` indicando se é possível alcançar o **último índice** do array.

## Ideia Central

Se você continuar atualizando o "ponto mais distante alcançável a partir daqui" em cada posição, no momento em que esse ponto mais distante ficar aquém da posição atual, é possível determinar que o destino é inalcançável. Não é necessário rastrear cada caminho de salto individualmente — basta um único valor representando o "índice mais distante alcançável até agora".

## Processo de Raciocínio

1. **A alcançabilidade é determinada pelo ponto mais distante**: Para verificar se o índice `i` é alcançável, basta confirmar se o "índice mais distante alcançável", calculado a partir de todos os elementos anteriores, é maior ou igual a `i`. Os detalhes do caminho intermediário são desnecessários — apenas o ponto mais distante importa
2. **O ponto mais distante pode ser gerenciado com uma única variável**: Em cada índice `i`, `i + nums[i]` é o ponto mais distante alcançável a partir dali. Mantendo o maior valor entre esse resultado e o ponto mais distante anterior, é possível rastrear todo o intervalo alcançável com apenas uma variável
3. **Condição de impossibilidade de alcance**: Ao percorrer o array da esquerda para a direita, se o índice atual `i` ultrapassar o ponto mais distante `maxReach`, significa que o índice `i` é inalcançável. Ou seja, `i > maxReach` é a condição de impossibilidade
4. **Condição de encerramento antecipado**: No momento em que `maxReach` se tornar maior ou igual ao último índice `nums.length - 1`, é confirmado que o final é alcançável, então é possível pular o restante da iteração e retornar `true`
5. **Caso em que a iteração é concluída até o final**: Se o loop terminar sem retornar `false` nem `true` no meio do caminho, significa que todos os índices eram alcançáveis, então retorna-se `true`

## Conhecimento Prévio

### O que é Math.max

Um método estático que recebe dois inteiros e retorna o maior valor entre eles. É utilizado na atualização do ponto mais distante para comparar o "ponto mais distante atual" com o "novo ponto alcançável calculado".

```java
Math.max(3, 5);    // retorna 5 — o maior entre os dois argumentos
Math.max(7, 2);    // retorna 7
Math.max(4, 4);    // retorna 4 — quando iguais, retorna esse valor
```

### O que é maxReach (índice mais distante alcançável)

Uma variável que representa o índice mais distante alcançável considerando todos os elementos desde o início do array até a posição atual. Quando você está no índice `i`, `i + nums[i]` é o ponto mais distante alcançável a partir dessa posição, e `maxReach = Math.max(maxReach, i + nums[i])` mantém sempre o valor máximo.
Exemplo: para `nums = [2, 3, 1, 1, 4]`, em `i=0` temos `maxReach = 0 + 2 = 2`, em `i=1` temos `maxReach = max(2, 1 + 3) = 4`, e assim é possível determinar que o último índice `4` é alcançável.

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — basta percorrer o array uma única vez |
| Space | O(1) — a única variável adicional necessária é `maxReach` |

## Código

```java
// Entrada: array de inteiros nums (cada elemento é o comprimento máximo de salto a partir daquele índice)
// Saída: retorna true se o último índice for alcançável, false caso contrário
boolean canJump(int[] nums) {
    // Variável que rastreia o índice mais distante alcançável até agora
    // O ponto de partida é o índice 0, então o valor inicial é 0
    int maxReach = 0;

    // Percorre o array do início ao fim, um elemento por vez
    for (int i = 0; i < nums.length; i++) {
        // Se o índice atual ultrapassar o ponto mais distante alcançável, este índice é inalcançável
        if (i > maxReach) return false;

        // i + nums[i] é o índice mais distante alcançável a partir da posição atual
        // Mantém o maior valor entre o maxReach anterior e o novo cálculo
        maxReach = Math.max(maxReach,
            i + nums[i]);

        // Se o ponto mais distante alcançável for maior ou igual ao último índice, é confirmado que o final é alcançável
        if (maxReach >= nums.length - 1)
            return true;
    }
    // Se o loop foi concluído até o final, todos os índices eram alcançáveis, então retorna true
    return true;
}
```
