# Scheduling Tasks With Cooldown Intervals — Encontrar o tempo mínimo de execução de tarefas com cooldown

## Essência do problema

Um array de tarefas (representadas por caracteres) e um inteiro não negativo `n` (intervalo de cooldown) são fornecidos. A mesma tarefa não pode ser executada novamente sem um intervalo mínimo de `n` unidades. Durante o cooldown, a CPU fica em estado ocioso. O objetivo é retornar o **número mínimo de unidades de tempo** necessário para completar todas as tarefas.

## Ideia central

A tarefa com maior frequência determina a estrutura de todo o cronograma. Dependendo de se os intervalos de cooldown entre as tarefas mais frequentes podem ser preenchidos por outras tarefas, o tempo total será o maior valor entre "o resultado calculado pela fórmula" e "o número total de tarefas".

## Processo de raciocínio

1. **A tarefa mais frequente se torna o gargalo**: A restrição de cooldown é mais severa para a tarefa com o maior número de ocorrências. Essa tarefa domina o comprimento total do cronograma
2. **Ao dispor a tarefa mais frequente, surgem lacunas**: Se o número de ocorrências da tarefa mais frequente for `maxFreq`, ao dispô-la com intervalo de `n`, surgem `(maxFreq - 1)` blocos entre as tarefas. O comprimento de cada bloco é `(n + 1)` (1 tarefa + `n` slots de cooldown)
3. **Preencher as lacunas com outras tarefas**: Nos slots de cooldown dentro de cada bloco, outras tarefas são colocadas para reduzir o tempo ocioso. Se todas as lacunas forem preenchidas, não há tempo ocioso
4. **O último bloco recebe tratamento especial**: Como a última execução não precisa de cooldown, o último bloco contém apenas a tarefa mais frequente (e tarefas com a mesma frequência). Se `maxCount` for o número de tarefas com a mesma frequência máxima, o comprimento do último bloco é `maxCount`
5. **Calcular o comprimento total com a fórmula**: `(maxFreq - 1) * (n + 1) + maxCount` calcula o comprimento do cronograma baseado na tarefa mais frequente
6. **É necessário comparar com o número total de tarefas**: Se todas as lacunas forem preenchidas e ainda sobrarem tarefas, não há tempo ocioso e o número total de tarefas é a resposta direta. Portanto, a resposta final é `Math.max(formulaResult, tasks.length)`

## Conhecimentos prévios

### O que é um array de frequência

Uma técnica que usa um array de tamanho fixo para contar o número de ocorrências de cada caractere. No caso de apenas letras maiúsculas, um array de tamanho 26 cobre todos os caracteres. É mais rápido e usa menos memória que um HashMap.

```java
int[] freq = new int[26];            // Inicializa 26 contadores (A a Z) com 0
freq['B' - 'A']++;                   // Incrementa a contagem de 'B' em 1 (índice 1)
freq['B' - 'A'];                     // Obtém a contagem de 'B' → 1
```

### O que é Math.max

Um método que retorna o maior entre dois valores. É usado para escolher a resposta entre dois candidatos.

```java
Math.max(10, 7);    // → 10 (retorna o maior)
Math.max(5, 12);    // → 12
```

### O que é a estrutura de blocos neste problema

Se a tarefa mais frequente for `A` (com 3 ocorrências) e `n = 2`, o cronograma terá a seguinte estrutura de blocos:

```
[A _ _] [A _ _] [A]
 bloco1   bloco2  último
```

`_` são slots de cooldown, onde outras tarefas ou tempo ocioso são inseridos. O último bloco não precisa de cooldown, então contém apenas `A`.

## Complexidade

| | Valor |
|---|---|
| Time | O(k) — Percorre o array de tarefas uma vez e percorre o array fixo de tamanho 26 um número constante de vezes (k é o número de tarefas) |
| Space | O(1) — Usa apenas um array de tamanho fixo 26 |

## Código

```java
// Entrada: array de caracteres tasks (cada caractere representa uma tarefa) e inteiro não negativo n (intervalo de cooldown)
// Saída: retorna como int o número mínimo de unidades de tempo necessário para completar todas as tarefas
public int leastInterval(char[] tasks, int n) {
    // Array de frequência que conta as ocorrências de cada tarefa (A a Z). freq[0] corresponde a 'A', freq[1] a 'B'
    int[] freq = new int[26];
    // Percorre o array tasks e converte cada caractere em índice de 0 a 25 com t - 'A' para contar
    for (char t : tasks)
        freq[t - 'A']++;

    // Encontra o número máximo de ocorrências. Este valor determina o número de blocos no cronograma
    int maxFreq = 0;
    for (int f : freq)
        maxFreq = Math.max(maxFreq, f);

    // Conta o número de tarefas com a mesma frequência máxima. Este valor é o número de tarefas no último bloco
    int maxCount = 0;
    for (int f : freq)
        if (f == maxFreq) maxCount++;

    // Calcula usando a fórmula baseada na estrutura de blocos
    // (maxFreq - 1): número de blocos que precisam de cooldown
    // (n + 1): comprimento de cada bloco (1 tarefa + n slots de cooldown)
    // maxCount: comprimento do último bloco (contém apenas tarefas com frequência máxima)
    int formulaResult =
        (maxFreq - 1) * (n + 1)
        + maxCount;

    // formulaResult: comprimento quando há tempo ocioso devido ao cooldown
    // tasks.length: comprimento quando não há tempo ocioso (quando todas as lacunas são preenchidas e ainda sobram tarefas)
    // O maior dos dois é a resposta correta
    return Math.max(formulaResult,
        tasks.length);
}
```
