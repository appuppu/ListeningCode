# Merging Triplets to Form a Target Triplet — Determinar se é possível formar o alvo com o máximo elemento a elemento de tripletos

## Essência do problema

É fornecido um array bidimensional de tripletos `triplets`, onde cada tripleto consiste em três inteiros, e um tripleto alvo `target`. O objetivo é determinar se é possível selecionar qualquer subconjunto de `triplets` e, ao calcular o máximo elemento a elemento (element-wise maximum), obter um resultado que coincida exatamente com `target`, retornando um **boolean**.

## Ideia central

Um tripleto que possui qualquer valor superior ao elemento correspondente do alvo não pode ser utilizado no merge, pois incluí-lo faria com que aquela posição ultrapassasse o alvo. Por outro lado, ao fazer o merge apenas dos tripletos cujos elementos são todos menores ou iguais ao alvo, é possível acumular os valores máximos sem risco de ultrapassar o alvo, bastando verificar no final se o resultado coincide com o alvo.

## Processo de raciocínio

1. **Identificar tripletos inutilizáveis**: Se qualquer elemento de um tripleto `t` excede o elemento correspondente de `target`, incluir `t` no merge fará com que o máximo ultrapasse o alvo. Como o valor máximo, uma vez elevado, não pode ser reduzido, esse tripleto jamais pode ser selecionado
2. **Todos os tripletos utilizáveis podem ser incluídos**: Tripletos cujos elementos são todos menores ou iguais a `target` não ultrapassarão o alvo ao serem mesclados. Como incluí-los não causa prejuízo, todos podem ser adotados de forma gulosa
3. **Como acumular o resultado do merge**: O array `result` é inicializado com `[0, 0, 0]`, e para cada tripleto utilizável, calcula-se o máximo entre cada elemento de `result` e o elemento correspondente do tripleto. Atualizando elemento a elemento com `Math.max`, obtém-se o element-wise maximum de todos os tripletos selecionados
4. **Verificação final**: Após processar todos os tripletos, se `result` coincide exatamente com `target`, retorna-se `true`; caso contrário, retorna-se `false`. O método `Arrays.equals` permite comparar todos os elementos dos arrays

## Conhecimentos prévios

### O que é element-wise maximum (máximo elemento a elemento)

É a operação de comparar elementos na mesma posição de dois ou mais arrays e selecionar o maior valor em cada posição. Por exemplo, o element-wise maximum de `[2, 5, 3]` e `[5, 1, 6]` resulta em `[5, 5, 6]`.

```java
int[] a = {2, 5, 3};
int[] b = {5, 1, 6};
int[] merged = new int[3];
merged[0] = Math.max(a[0], b[0]);  // max(2, 5) → 5
merged[1] = Math.max(a[1], b[1]);  // max(5, 1) → 5
merged[2] = Math.max(a[2], b[2]);  // max(3, 6) → 6
// merged = [5, 5, 6]
```

### O que é Math.max

É um método que retorna o maior entre dois valores. É utilizado para acumular o resultado do merge.

```java
Math.max(3, 7);   // → 7
Math.max(5, 5);   // → 5
Math.max(0, 4);   // → 4 (uso para atualizar comparando com o valor inicial 0)
```

### O que é Arrays.equals

É um método que verifica se dois arrays possuem o mesmo comprimento e todos os elementos iguais, retornando um boolean. O operador `==` compara referências, por isso este método deve ser utilizado para comparar o conteúdo dos arrays.

```java
int[] a = {2, 5, 3};
int[] b = {2, 5, 3};
a == b;              // → false (porque as referências são diferentes)
Arrays.equals(a, b); // → true (porque todos os elementos são iguais)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer o array de tripletos uma única vez (o processamento de cada tripleto é O(1)) |
| Space | O(1) — Utiliza-se apenas o array `result` de tamanho fixo 3 |

## Código

```java
// Entrada: array bidimensional de inteiros triplets (cada elemento é um tripleto de comprimento 3) e um array de inteiros target de comprimento 3
// Saída: true se for possível formar target com o element-wise maximum de um subconjunto dos tripletos, false caso contrário
public boolean mergeTriplets(int[][] triplets, int[] target) {
    // Inicializa o array que acumula o element-wise maximum dos tripletos utilizáveis com [0, 0, 0]
    int[] result = new int[3];

    // Percorre cada tripleto t de triplets do início ao fim, um por um
    for (int[] t : triplets) {
        // Tripletos com qualquer elemento que exceda o alvo são ignorados, pois incluí-los no merge faria o máximo ultrapassar o alvo sem possibilidade de correção
        if (t[0] > target[0] ||
            t[1] > target[1] ||
            t[2] > target[2])
            continue;

        // Como todos os elementos são menores ou iguais ao alvo, esta atualização não fará result ultrapassar o alvo
        // Atualiza o resultado com o máximo de cada elemento
        result[0] = Math.max(result[0], t[0]);
        result[1] = Math.max(result[1], t[1]);
        result[2] = Math.max(result[2], t[2]);
    }

    // Verifica se o resultado acumulado coincide exatamente com o alvo e retorna o resultado
    return Arrays.equals(result, target);
}
```
