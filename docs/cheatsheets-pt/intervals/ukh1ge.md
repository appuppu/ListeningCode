# Inserting a New Interval Into a Sorted List — Inserir um novo intervalo em uma lista ordenada de intervalos não sobrepostos e realizar a mesclagem

## Essência do Problema

É fornecida uma lista de intervalos `intervals`, ordenada e sem sobreposições, e um novo intervalo `newInterval`. O objetivo é inserir `newInterval` na posição correta, mesclar todos os intervalos que se sobrepõem e retornar a lista resultante de intervalos não sobrepostos.

## Ideia Central

Ao percorrer a lista ordenada de intervalos da esquerda para a direita, cada intervalo se enquadra em um dos três grupos: "completamente antes do novo intervalo", "sobreposto ao novo intervalo" ou "completamente depois do novo intervalo". Ao processar essas três fases em ordem, a inserção e a mesclagem são concluídas em uma única varredura.

## Processo de Raciocínio

1. **Existem apenas 3 padrões de relação posicional entre intervalos**: Cada intervalo na lista ordenada pode ser classificado em relação ao newInterval como "completamente antes", "sobreposto" ou "completamente depois". Utilizando essa classificação, é possível processar a lista com uma única varredura
2. **Condição para determinar "completamente antes"**: Se o fim do intervalo existente `intervals[i][1]` for menor que o início do newInterval `newInterval[0]`, esse intervalo não se sobrepõe ao newInterval. Os intervalos que satisfazem essa condição são adicionados diretamente ao resultado
3. **Condição para determinar "sobreposto"**: Se o início do intervalo existente `intervals[i][0]` for menor ou igual ao fim do newInterval `newInterval[1]`, esse intervalo se sobrepõe ao newInterval. Cada vez que um intervalo sobreposto é encontrado, o início e o fim do newInterval são atualizados para expandir o intervalo mesclado
4. **Método de mesclagem**: O novo início é o menor entre o início do intervalo sobreposto e o início do newInterval. O novo fim é o maior entre o fim do intervalo sobreposto e o fim do newInterval. Dessa forma, múltiplos intervalos sobrepostos são consolidados em um único intervalo
5. **Momento de adicionar o resultado da mesclagem**: Quando não há mais intervalos sobrepostos, o newInterval mesclado é adicionado ao resultado. Todos os intervalos subsequentes estão completamente depois do newInterval e são adicionados diretamente ao resultado
6. **O que é retornado ao final**: A lista de resultados construída nas 3 fases é convertida em `int[][]` e retornada

## Conhecimentos Prévios

### O que é ArrayList

Um array de tamanho variável. A adição de elementos com `add()` é O(1) (amortizado) e pode ser convertido em um array de tamanho fixo ao final. É utilizado quando o tamanho do resultado não é conhecido antecipadamente.

```java
List<int[]> res = new ArrayList<>();   // Cria um ArrayList vazio
res.add(new int[]{1, 3});              // Adiciona um elemento ao final
res.toArray(new int[0][]);             // Converte para um array do tipo int[][]
```

### O que são Math.min / Math.max

Métodos que retornam o menor ou o maior entre dois valores. São utilizados para determinar o início e o fim durante a mesclagem de intervalos.

```java
Math.min(1, 3);   // → 1 (retorna o menor)
Math.max(1, 3);   // → 3 (retorna o maior)
```

### Verificação de sobreposição de intervalos

A sobreposição entre dois intervalos `[a, b]` e `[c, d]` pode ser verificada com `a <= d && c <= b`. Neste problema, como a lista está ordenada, apenas uma das condições é suficiente para a verificação.

```java
// O intervalo existente está completamente antes do newInterval (sem sobreposição)
intervals[i][1] < newInterval[0]   // Fim do intervalo existente < Início do novo intervalo

// O intervalo existente se sobrepõe ao newInterval
intervals[i][0] <= newInterval[1]  // Início do intervalo existente <= Fim do novo intervalo
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta uma única varredura pela lista de intervalos |
| Space | O(n) — A lista de resultados armazena no máximo n+1 intervalos |

## Código

```java
// Entrada: lista ordenada de intervalos não sobrepostos intervals (int[][]) e um novo intervalo newInterval (int[])
// Saída: retorna a lista de intervalos não sobrepostos resultante da inserção e mesclagem do newInterval como int[][]
public int[][] insert(int[][] intervals, int[] newInterval) {
    // Lista para armazenar o resultado. Usa ArrayList porque o tamanho não é conhecido antecipadamente
    List<int[]> res = new ArrayList<>();
    // Variável para rastrear a posição de varredura
    int i = 0;
    // Armazena o total de intervalos em uma variável para evitar referenciar .length a cada iteração
    int n = intervals.length;

    // Fase 1: Adiciona diretamente os intervalos que estão completamente antes do newInterval
    // Condição: se o fim do intervalo existente < início do newInterval, não há sobreposição
    while (i < n && intervals[i][1] < newInterval[0]) {
        res.add(intervals[i]);
        i++;
    }

    // Fase 2: Mescla todos os intervalos que se sobrepõem ao newInterval
    // Condição: se o início do intervalo existente <= fim do newInterval, há sobreposição
    while (i < n && intervals[i][0] <= newInterval[1]) {
        // Toma o menor início (expande a borda esquerda do newInterval até a borda esquerda do intervalo sobreposto)
        newInterval[0] = Math.min(newInterval[0], intervals[i][0]);
        // Toma o maior fim (expande a borda direita do newInterval até a borda direita do intervalo sobreposto)
        newInterval[1] = Math.max(newInterval[1], intervals[i][1]);
        i++;
    }
    // Adiciona o newInterval mesclado ao resultado (é adicionado mesmo que haja 0 intervalos sobrepostos)
    res.add(newInterval);

    // Fase 3: Adiciona diretamente os intervalos que estão completamente depois do newInterval (sem necessidade de mesclagem)
    while (i < n) {
        res.add(intervals[i]);
        i++;
    }

    // Converte o ArrayList em int[][] e retorna. new int[0][] é um array vazio para informar o tipo
    return res.toArray(new int[0][]);
}
```
