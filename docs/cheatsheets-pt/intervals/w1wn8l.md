# Finding the Minimum Removals for Non-Overlapping Intervals — Encontrar o número mínimo de intervalos a remover para eliminar sobreposições

## Essência do problema

É dado um array de intervalos `intervals` (cada intervalo é um par `[start, end]`). O objetivo é retornar o **número mínimo de intervalos a remover** para que os intervalos restantes não se sobreponham entre si.

## Ideia central

Se ordenarmos os intervalos pelo tempo de término e priorizarmos manter os intervalos que terminam mais cedo, minimizamos a possibilidade de sobreposição com os intervalos seguintes. Quando ocorre uma sobreposição, removemos o intervalo que termina mais tarde (ou seja, o intervalo atual), minimizando assim o número de remoções.

## Processo de raciocínio

1. **Para reduzir sobreposições, priorizamos manter os intervalos que "ocupam menos espaço"**: Quanto mais cedo um intervalo termina, mais espaço livre resta à frente, reduzindo a chance de sobreposição com intervalos seguintes. Portanto, ordenar os intervalos em ordem crescente de tempo de término e selecioná-los avidamente nessa ordem é a estratégia ótima
2. **Após a ordenação, basta rastrear apenas o tempo de término do último intervalo mantido**: Como os intervalos estão ordenados pelo tempo de término, precisamos memorizar apenas o tempo de término `lastEnd` do último intervalo que decidimos manter. Se o tempo de início do próximo intervalo for menor que `lastEnd`, há sobreposição
3. **Em caso de sobreposição, removemos o intervalo atual**: Quando ocorre sobreposição, devemos decidir se removemos o intervalo mantido anteriormente ou o intervalo atual. Como os intervalos estão ordenados pelo tempo de término, o tempo de término do intervalo atual é maior ou igual ao do intervalo anterior. Remover o intervalo atual, que termina mais tarde, causa menos impacto nos intervalos seguintes. Por isso, incrementamos `removals` e não atualizamos `lastEnd`
4. **Se não há sobreposição, mantemos o intervalo atual**: Se o tempo de início do intervalo atual for maior ou igual a `lastEnd`, não há sobreposição, então mantemos esse intervalo e atualizamos `lastEnd` para o tempo de término do intervalo atual
5. **Valor retornado ao final**: Após o término do loop, retornamos `removals` (o número de intervalos removidos)

## Conhecimentos prévios

### Comparador personalizado do Arrays.sort

Ao passar uma expressão lambda como segundo argumento de `Arrays.sort`, é possível personalizar o critério de ordenação. `(a, b) -> a[1] - b[1]` ordena em ordem crescente com base no tempo de término (elemento no índice 1) de cada intervalo.

```java
int[][] intervals = {{1,3}, {2,4}, {0,2}};
Arrays.sort(intervals, (a, b) -> a[1] - b[1]);
// Resultado: {{0,2}, {1,3}, {2,4}} — ordenados em ordem crescente de tempo de término
```

### O que é o algoritmo guloso (Greedy)

É uma técnica que, em cada etapa, faz "a melhor escolha disponível naquele momento" para alcançar a solução ótima global. Neste problema, a escolha local de "priorizar manter o intervalo com o tempo de término mais cedo" leva à minimização global do número de remoções.

```java
// Padrão típico do algoritmo guloso: ordenar e depois fazer a escolha ótima sequencialmente desde o início
Arrays.sort(data, comparator);  // Ordenar pelo critério
for (int i = 0; i < data.length; i++) {
    // Se a condição for satisfeita, selecionar; caso contrário, pular
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n log n) — A ordenação custa O(n log n) e a varredura custa O(n), sendo a ordenação o fator dominante |
| Space | O(1) — Não utiliza estruturas de dados adicionais, exceto o espaço interno da ordenação |

## Código

```java
// Entrada: array de intervalos int[][] intervals (cada elemento é [start, end])
// Saída: retorna como int o número mínimo de intervalos a remover para eliminar sobreposições
int eraseOverlapIntervals(int[][] intervals) {
    // Se não há intervalos, não é necessário remover nenhum
    if (intervals.length == 0)
        return 0;

    // Ordenar em ordem crescente de tempo de término (para priorizar manter os intervalos que terminam mais cedo)
    // Algoritmo guloso: intervalos que terminam mais cedo têm menor chance de sobrepor os seguintes, então mantê-los primeiro é ótimo
    Arrays.sort(intervals, (a, b) -> a[1] - b[1]);

    // Variável para registrar o número de intervalos removidos
    int removals = 0;
    // O primeiro intervalo após a ordenação é sempre mantido (pois tem o término mais cedo). Registramos o seu tempo de término
    int lastEnd = intervals[0][1];

    // Percorremos a partir do índice 1 (o índice 0 já foi confirmado como intervalo mantido)
    for (int i = 1; i < intervals.length; i++) {
        // Se o tempo de início do intervalo atual for menor que lastEnd, há sobreposição com o último intervalo mantido
        if (intervals[i][0] < lastEnd) {
            // Removemos o intervalo atual. Como os intervalos estão ordenados pelo tempo de término,
            // o término do intervalo atual é maior ou igual a lastEnd,
            // então remover o intervalo atual (que termina mais tarde) reduz sobreposições com os seguintes. Não atualizamos lastEnd
            removals++;
        } else {
            // Não há sobreposição, então mantemos o intervalo atual e atualizamos lastEnd para o tempo de término do intervalo atual
            // A verificação de sobreposição com o próximo intervalo será feita com base neste novo lastEnd
            lastEnd = intervals[i][1];
        }
    }
    // removals é o número mínimo de intervalos que precisam ser removidos para eliminar sobreposições
    return removals;
}
```
