# Scheduling Tasks With Cooldown Intervals — Encontrar o tempo mínimo de execução de tarefas com cooldown

## Essência do problema

São dados um array de tarefas (representadas por caracteres) e um inteiro não negativo `n` (intervalo de cooldown). A mesma tarefa só pode ser executada novamente após um intervalo mínimo de `n` unidades. Durante o cooldown, a CPU fica em estado ocioso. O objetivo é retornar o **número mínimo de unidades de tempo** necessárias para concluir todas as tarefas.

## Ideia central

A tarefa com maior frequência determina a estrutura geral do cronograma. Dependendo de se as lacunas de cooldown entre as tarefas mais frequentes podem ser preenchidas por outras tarefas, o tempo total será o maior valor entre "o resultado da fórmula matemática" e "o número total de tarefas".

## Processo de raciocínio

1. **A tarefa mais frequente se torna o gargalo**: A restrição de cooldown é mais severa para a tarefa com o maior número de ocorrências. Essa tarefa domina o comprimento total do cronograma
2. **Ao alinhar as tarefas mais frequentes, surgem lacunas**: Se o número de ocorrências da tarefa mais frequente é `maxFreq`, ao alinhar essa tarefa com intervalo de `n`, surgem `(maxFreq - 1)` blocos entre as tarefas. O comprimento de cada bloco é `(n + 1)` (1 tarefa + `n` slots de cooldown)
3. **Preencher as lacunas com outras tarefas**: Nos slots de cooldown dentro de cada bloco, outras tarefas são posicionadas para reduzir o tempo ocioso. Se todas as lacunas forem preenchidas, nenhum tempo ocioso ocorre
4. **O último bloco recebe tratamento especial**: Como a última execução não necessita de cooldown, o último bloco contém apenas as tarefas mais frequentes (e as de mesma frequência). Se `maxCount` é o número de tarefas com a mesma frequência máxima, o comprimento do último bloco é `maxCount`
5. **Calcular o comprimento total com a fórmula**: `(maxFreq - 1) * (n + 1) + maxCount` calcula o comprimento do cronograma baseado na tarefa mais frequente
6. **É necessário comparar com o número total de tarefas**: Se todas as lacunas forem preenchidas e ainda sobrarem tarefas, nenhum tempo ocioso é necessário e o número total de tarefas se torna a resposta diretamente. Portanto, a resposta final é `Math.max(formulaResult, tasks.length)`

## Conhecimentos prévios

### O que é um array de frequência

Uma técnica que utiliza um array de tamanho fixo para contar o número de ocorrências de cada caractere. No caso de apenas letras maiúsculas, um array de tamanho 26 cobre todos os caracteres. É mais rápido e consome menos memória do que um HashMap.

```java
int[] freq = new int[26];            // Inicializa 26 contadores com 0, correspondendo a A~Z
freq['B' - 'A']++;                   // Incrementa a contagem de 'B' em 1 (índice 1)
freq['B' - 'A'];                     // Obtém a contagem de 'B' → 1
```

### O que é Math.max

Um método que retorna o maior dos dois valores. É usado para escolher a resposta entre dois candidatos.

```java
Math.max(10, 7);    // → 10 (retorna o maior)
Math.max(5, 12);    // → 12
```

### O que é a estrutura de blocos neste problema

Se a tarefa mais frequente é `A` (com 3 ocorrências) e `n = 2`, o cronograma forma a seguinte estrutura de blocos:

```
[A _ _] [A _ _] [A]
 Bloco 1  Bloco 2  Último
```

`_` são slots de cooldown, que podem ser preenchidos por outras tarefas ou ficam ociosos. O último bloco não necessita de cooldown, então contém apenas `A`.

## Complexidade

| | Valor |
|---|---|
| Time | O(k) — Percorre o array de tarefas uma vez e percorre o array fixo de tamanho 26 um número constante de vezes (k é o número de tarefas) |
| Space | O(1) — Utiliza apenas um array de tamanho fixo 26 |

## Código

```java
// Entrada: array de caracteres tasks (cada tarefa é uma letra maiúscula de 'A' a 'Z') e inteiro não negativo n (intervalo de cooldown)
// Saída: retorna como int o número mínimo de unidades de tempo necessárias para concluir todas as tarefas
public int leastInterval(char[] tasks, int n) {
    // Cria um array de frequência de tamanho 26. freq[0] corresponde à contagem de 'A', freq[1] à contagem de 'B'
    int[] freq = new int[26];
    // Percorre tasks e converte cada caractere em um índice de 0 a 25 usando t - 'A' para contar
    for (char t : tasks)
        freq[t - 'A']++;

    // Percorre o array freq para encontrar o número máximo de ocorrências. maxFreq determina o número de blocos no cronograma
    int maxFreq = 0;
    for (int f : freq)
        maxFreq = Math.max(maxFreq, f);

    // Conta o número de tarefas cuja frequência é igual a maxFreq. maxCount é o número de tarefas no último bloco
    int maxCount = 0;
    for (int f : freq)
        if (f == maxFreq) maxCount++;

    // (maxFreq - 1): número de blocos que necessitam de cooldown
    // (n + 1): comprimento de cada bloco (1 tarefa + n slots de cooldown)
    // maxCount: comprimento do último bloco (contém apenas as tarefas com frequência máxima)
    int formulaResult =
        (maxFreq - 1) * (n + 1)
        + maxCount;

    // formulaResult é o comprimento quando ocorre tempo ocioso devido ao cooldown
    // tasks.length é o comprimento quando nenhum tempo ocioso é necessário (todas as lacunas são preenchidas e sobram tarefas)
    // O maior dos dois valores é a resposta correta
    return Math.max(formulaResult,
        tasks.length);
}
```
