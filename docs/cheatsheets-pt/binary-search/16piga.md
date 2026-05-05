# Finding the Median of Two Sorted Arrays — Encontrar a mediana ao mesclar dois arrays ordenados

## Essência do Problema

São dados dois arrays de inteiros ordenados `n1` e `n2`. O objetivo é encontrar a **mediana** quando os dois arrays são mesclados. A solução deve operar em tempo logarítmico em relação ao número total de elementos.

## Ideia Central

Encontrar a mediana de dois arrays ordenados equivale a encontrar a fronteira que divide corretamente os elementos em "metade esquerda" e "metade direita". Ao realizar uma busca binária no array mais curto para determinar a posição de corte, a posição de corte do outro array é determinada automaticamente.

## Processo de Raciocínio

1. **A mediana é determinada pelo "valor máximo da metade esquerda" e pelo "valor mínimo da metade direita"**: Se o array mesclado puder ser dividido igualmente em esquerda e direita mantendo a ordenação, a mediana será o valor máximo da metade esquerda (se o número de elementos for ímpar) ou a média entre o valor máximo da metade esquerda e o valor mínimo da metade direita (se o número de elementos for par). Ou seja, não é necessário ordenar todos os elementos — basta encontrar a posição de corte correta
2. **Ao determinar a posição de corte em um array, a posição no outro é determinada automaticamente**: Decidindo que a metade esquerda terá um total de `half = (m + n + 1) / 2` elementos, se tomarmos `cut1` elementos do array `n1`, precisamos tomar `cut2 = half - cut1` elementos do array `n2`. Ou seja, basta buscar apenas `cut1`
3. **A condição de corte correto é verificada por "comparação cruzada"**: Um corte correto significa que todos os elementos da metade esquerda são menores ou iguais a todos os elementos da metade direita. Como cada array já está ordenado internamente, basta verificar apenas as partes que se cruzam. Concretamente, o corte é correto se o último elemento da parte esquerda de `n1` (`l1`) ≤ primeiro elemento da parte direita de `n2` (`r2`), e o último elemento da parte esquerda de `n2` (`l2`) ≤ primeiro elemento da parte direita de `n1` (`r1`)
4. **A busca binária encontra `cut1` de forma eficiente**: O intervalo de `cut1` vai de `0` até `m`. Se `l1 > r2`, estamos tomando elementos demais de `n1`, então reduzimos `cut1`. Se `l2 > r1`, estamos tomando elementos de menos de `n1`, então aumentamos `cut1`. Essa lógica de decisão viabiliza a busca binária
5. **Razão para buscar no array mais curto**: Como o intervalo da busca binária vai de `0` até `m` (comprimento do array), escolher o array mais curto reduz o intervalo de busca, resultando em uma complexidade de `O(log(min(m, n)))`
6. **Valores sentinela são usados para tratar fronteiras**: Quando `cut1 = 0` (nenhum elemento é tomado de `n1`) ou `cut1 = m` (todos os elementos de `n1` são tomados), ocorre acesso a elementos inexistentes. Usando `Integer.MIN_VALUE` e `Integer.MAX_VALUE` como valores sentinela, as condições de comparação funcionam corretamente em todos os casos

## Conhecimentos Prévios

### O que é a Mediana

É o valor que ocupa a posição central em uma sequência ordenada de números. Se o número de elementos for ímpar, é o elemento central único. Se for par, é a média dos dois elementos centrais.

```java
// Número ímpar de elementos: [1, 3, 5] → a mediana é 3
// Número par de elementos: [1, 3, 5, 7] → a mediana é (3 + 5) / 2.0 = 4.0
```

### O que é a Busca Binária (Binary Search)

É uma técnica que encontra o valor desejado em O(log n), reduzindo pela metade o intervalo de busca a cada iteração em dados ordenados. O intervalo de busca é gerenciado por `lo` e `hi`, e é reduzido com base no valor central.

```java
int lo = 0, hi = n;
while (lo <= hi) {
    int mid = (lo + hi) / 2;       // Calcula o ponto central do intervalo de busca
    if (condição satisfeita) { /* resposta */ }
    else if (mid é grande demais) { hi = mid - 1; }  // Restringe à metade esquerda
    else { lo = mid + 1; }                            // Restringe à metade direita
}
```

### O que é um Valor Sentinela (Sentinel Value)

É um valor especial usado para evitar acessos fora dos limites do array. Usando `Integer.MIN_VALUE` (menor valor inteiro) e `Integer.MAX_VALUE` (maior valor inteiro), as condições de comparação não falham mesmo nos casos de fronteira.

```java
Integer.MIN_VALUE;  // -2147483648 — usado como valor menor que qualquer elemento
Integer.MAX_VALUE;  //  2147483647 — usado como valor maior que qualquer elemento
```

## Complexidade

| | Valor |
|---|---|
| Time | O(log(min(m, n))) — Realiza busca binária no array mais curto |
| Space | O(1) — Usa apenas variáveis, sem criar estruturas de dados adicionais |

## Código

```java
// Entrada: dois arrays de inteiros ordenados n1 e n2
// Saída: retorna a mediana da mesclagem dos dois arrays como double
public double findMedian(int[] n1, int[] n2) {
    // Para realizar a busca binária no array mais curto, troca e faz chamada recursiva se n1 for mais longo
    // Isso minimiza o intervalo de busca e garante O(log(min(m, n)))
    if (n1.length > n2.length)
        return findMedian(n2, n1);

    int m = n1.length, n = n2.length;
    // Número de elementos na metade esquerda. Ao somar +1, quando o total é ímpar a metade esquerda tem um elemento a mais,
    // e o valor máximo da metade esquerda se torna diretamente a mediana
    int half = (m + n + 1) / 2;
    // Intervalo de busca de cut1: 0 (nenhum elemento de n1) até m (todos os elementos de n1)
    int lo = 0, hi = m;

    while (lo <= hi) {
        // Determina o número de elementos de n1 na metade esquerda pelo ponto central da busca binária
        int cut1 = (lo + hi) / 2;
        // Número de elementos de n2 na metade esquerda (determinado automaticamente para que o total da metade esquerda seja half)
        int cut2 = half - cut1;

        // Último elemento da metade esquerda de n1 (se cut1=0, a metade esquerda está vazia,
        // então usa o valor sentinela menor que qualquer elemento para que a condição de comparação sempre seja satisfeita)
        int l1 = cut1 == 0 ?
            Integer.MIN_VALUE :
            n1[cut1 - 1];
        // Último elemento da metade esquerda de n2 (se cut2=0, a metade esquerda está vazia, então usa o valor sentinela)
        int l2 = cut2 == 0 ?
            Integer.MIN_VALUE :
            n2[cut2 - 1];
        // Primeiro elemento da metade direita de n1 (se cut1=m, a metade direita está vazia,
        // então usa o valor sentinela maior que qualquer elemento para que a condição de comparação sempre seja satisfeita)
        int r1 = cut1 == m ?
            Integer.MAX_VALUE :
            n1[cut1];
        // Primeiro elemento da metade direita de n2 (se cut2=n, a metade direita está vazia, então usa o valor sentinela)
        int r2 = cut2 == n ?
            Integer.MAX_VALUE :
            n2[cut2];

        // Comparação cruzada: se todos os elementos da metade esquerda ≤ todos os elementos da metade direita, o corte está correto
        if (l1 <= r2 && l2 <= r1) {
            // Corte correto encontrado
            if ((m + n) % 2 == 1)
                // Número ímpar de elementos: o valor máximo da metade esquerda é diretamente a mediana
                return Math.max(l1, l2);
            // Número par de elementos: a mediana é a média entre o valor máximo da metade esquerda e o valor mínimo da metade direita
            return (Math.max(l1, l2)
                + Math.min(r1, r2))
                / 2.0;
        } else if (l1 > r2) {
            // O último elemento da metade esquerda de n1 excede o primeiro elemento da metade direita de n2 → elementos demais de n1 → reduz cut1
            hi = cut1 - 1;
        } else {
            // l2 > r1: elementos de menos de n1 → aumenta cut1
            lo = cut1 + 1;
        }
    }
    // Pelas restrições do problema, um corte correto sempre é encontrado, então este ponto nunca é alcançado
    return -1;
}
```
