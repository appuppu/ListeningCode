# Searching for a Target in a Sorted Array — Encontrar a posição de um alvo em um array ordenado

## Essência do problema

Um array ordenado de inteiros `nums` e um inteiro `target` são fornecidos. O objetivo é encontrar o elemento que corresponde ao `target` no array e retornar seu **índice**. Se o `target` não existir no array, retorna-se `-1`.

## Ideia central

Como o array está ordenado, basta comparar o elemento central com o alvo para reduzir o intervalo de busca pela metade a cada iteração. Com isso, a busca é concluída em O(log n), em vez de O(n), que seria necessário para verificar todos os elementos.

## Processo de raciocínio

1. **Aproveitar a condição de ordenação**: Como o array está ordenado, ao observar o elemento em qualquer posição, é possível determinar se o alvo está à esquerda ou à direita dessa posição. Essa propriedade permite reduzir o intervalo de busca pela metade a cada iteração
2. **Gerenciar o intervalo de busca com dois ponteiros**: O intervalo de busca é representado por dois ponteiros: `left` para a extremidade esquerda e `right` para a extremidade direita do array. No estado inicial, o array inteiro é o intervalo de busca
3. **Comparar o elemento central com o alvo**: Calcula-se o índice central `mid` do intervalo de busca e compara-se `nums[mid]` com `target`. Se forem iguais, `mid` é a resposta
4. **Reduzir o intervalo de busca pela metade conforme o resultado da comparação**: Se `nums[mid] < target`, o alvo está à direita do centro, então reduz-se a extremidade esquerda com `left = mid + 1`. Se `nums[mid] > target`, o alvo está à esquerda do centro, então reduz-se a extremidade direita com `right = mid - 1`
5. **Repetir até que o intervalo de busca se esgote**: A busca continua enquanto `left <= right`. Quando `left > right`, o intervalo de busca está vazio, o que significa que o alvo não existe no array, e retorna-se `-1`
6. **Prevenir overflow no cálculo do índice central**: A expressão `mid = (left + right) / 2` pode causar overflow quando `left + right` excede o valor máximo de um inteiro. Escrever `mid = left + (right - left) / 2` evita o overflow

## Conhecimentos prévios

### O que é Binary Search (busca binária)

É um algoritmo que encontra um elemento de forma eficiente em um array ordenado, reduzindo o intervalo de busca pela metade a cada iteração. O elemento central do intervalo de busca é comparado com o alvo e, se não houver correspondência, descarta-se a metade esquerda ou a metade direita. Repetindo esse processo, o número de iterações de busca se torna O(log n).

```java
// Número de iterações de busca para um array de comprimento 8
// 1ª vez: 8 → 4 (reduzido pela metade)
// 2ª vez: 4 → 2 (reduzido pela metade)
// 3ª vez: 2 → 1 (reduzido pela metade)
// Máximo de 3 vezes = log₂(8) = 3
```

### Cálculo do índice central

Calcula-se a posição intermediária entre os dois ponteiros `left` e `right`. Usa-se `left + (right - left) / 2` em vez de `(left + right) / 2` para evitar o overflow de inteiros na soma `left + right`.

```java
int left = 0;
int right = 10;
int mid = left + (right - left) / 2;  // mid = 0 + (10 - 0) / 2 = 5
```

### Condição do loop while `left <= right`

`left <= right` significa que resta pelo menos um elemento no intervalo de busca. Quando `left == right`, resta apenas um elemento no intervalo de busca, e esse elemento também precisa ser verificado. Por isso, usa-se `<=` em vez de `<`.

```java
// Quando left=3, right=3, nums[3] ainda não foi verificado
// left <= right é true, então nums[3] pode ser verificado
// Se fosse left < right, seria false, e nums[3] não seria verificado
```

## Complexidade

| | Valor |
|---|---|
| Time | O(log n) — Como o intervalo de busca é reduzido pela metade a cada iteração, são necessárias no máximo log₂(n) comparações |
| Space | O(1) — Utiliza-se apenas variáveis para os ponteiros, sem necessidade de estruturas de dados adicionais |

## Código

```java
// Entrada: array ordenado de inteiros nums e inteiro target
// Saída: retorna o índice do elemento correspondente ao target como int. Retorna -1 se não existir
public int binarySearch(int[] nums, int target) {
    // Inicializar as extremidades esquerda e direita do intervalo de busca. Essas duas variáveis gerenciam o intervalo de busca
    int left = 0;
    int right = nums.length - 1;

    // left <= right: repetir enquanto restar pelo menos um elemento no intervalo de busca
    // Quando left > right, o intervalo de busca está vazio, então sai-se do loop
    while (left <= right) {
        // Atenção: (left + right) / 2 pode causar overflow de inteiros na soma left + right
        // Escrever left + (right - left) / 2 previne o overflow
        int mid = left
            + (right - left) / 2;

        // Se o elemento central corresponder ao alvo, retorna-se o índice
        if (nums[mid] == target) {
            return mid;
        }

        // Se o alvo for maior que o elemento central, reduz-se o intervalo de busca para a metade direita
        // Como mid já foi verificado, usa-se mid + 1
        if (nums[mid] < target) {
            left = mid + 1;
        }
        // Se o alvo for menor que o elemento central, reduz-se o intervalo de busca para a metade esquerda
        // Como mid já foi verificado, usa-se mid - 1
        else {
            right = mid - 1;
        }
    }

    // O intervalo de busca está vazio, portanto o alvo não existe no array
    return -1;
}
```
