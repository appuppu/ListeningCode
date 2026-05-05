# Finding the Minimum in a Rotated Sorted Array — Encontrar o valor mínimo em um array ordenado e rotacionado

## Essência do problema

Um array de inteiros únicos ordenados em ordem crescente foi rotacionado entre 1 e n vezes. O objetivo é encontrar e retornar o **elemento mínimo** neste array rotacionado. A rotação é a operação de mover o último elemento do array para o início, e existe um pivô onde a ordem original de classificação "se quebra".

## Ideia central

Em um array ordenado e rotacionado, o valor mínimo está na posição do "pivô", onde a ordem de classificação se rompe. Comparando o elemento central com o elemento mais à direita, é possível determinar em uma única comparação se o valor mínimo está na metade esquerda ou na metade direita, permitindo encontrá-lo em O(log n) com busca binária.

## Processo de raciocínio

1. **O valor mínimo está na posição do pivô**: Um array ordenado e rotacionado se divide em duas partes ordenadas: uma "subsequência maior" e uma "subsequência menor". O valor mínimo está no início da "subsequência menor", ou seja, na posição do pivô. Encontrar esse pivô é a essência do problema
2. **Queremos usar busca binária em vez de busca linear**: Embora o array não esteja completamente ordenado, ele possui a estrutura de estar dividido em duas partes ordenadas. Aproveitando essa estrutura, é possível aplicar a busca binária que descarta metade do array a cada iteração
3. **Comparar o elemento central com o elemento mais à direita**: Se `nums[mid] > nums[right]` for verdadeiro, existe um pivô (quebra na ordem de classificação) entre mid e right, portanto o valor mínimo está na metade direita. Caso contrário, se `nums[mid] <= nums[right]`, o trecho de mid a right está ordenado, e o valor mínimo está à esquerda de mid (incluindo o próprio mid)
4. **Razão para comparar com a extremidade direita em vez da esquerda**: Se compararmos com a extremidade esquerda, não é possível determinar corretamente o caso em que o array não foi rotacionado (todo o array está ordenado). Comparando com a extremidade direita, é possível delimitar corretamente a posição do valor mínimo independentemente de o array ter sido rotacionado ou não
5. **Método de atualização do intervalo de busca**: Quando `nums[mid] > nums[right]`, é certo que mid não é o valor mínimo, então definimos `left = mid + 1`. Caso contrário, mid pode ser o valor mínimo, então definimos `right = mid` (sem excluir mid)
6. **Condição de término do loop**: O loop continua enquanto `left < right`, e quando `left == right`, o intervalo de busca se reduz a um único elemento. Esse elemento `nums[left]` é o valor mínimo

## Conhecimentos prévios

### O que é um array ordenado e rotacionado

Ao rotacionar o array ordenado em ordem crescente `[1, 2, 3, 4, 5]` duas vezes para a direita, obtemos `[4, 5, 1, 2, 3]`. O array se divide em duas subsequências ordenadas `[4, 5]` e `[1, 2, 3]`, e a fronteira entre elas é o pivô.

```
Array original:          [1, 2, 3, 4, 5]
Após 2 rotações:         [4, 5, 1, 2, 3]
                              ↑ Pivô (valor mínimo)
```

### Estrutura básica da busca binária

Técnica que encontra o elemento desejado em O(log n) reduzindo o intervalo de busca pela metade a cada iteração. O intervalo de busca é gerenciado com dois ponteiros, left e right, e o intervalo é atualizado com base no elemento central.

```java
int left = 0;
int right = nums.length - 1;
int mid = left + (right - left) / 2;  // Cálculo do ponto médio que evita overflow
```

### O que é `left + (right - left) / 2`

Fórmula para calcular o índice central. `(left + right) / 2` produz o mesmo resultado, mas quando left e right são valores grandes, a soma pode exceder o valor máximo de int. Esta fórmula é uma forma segura de escrita que **evita esse overflow**.

## Complexidade

| | Valor |
|---|---|
| Time | O(log n) — Como o intervalo de busca é reduzido pela metade a cada vez, o valor mínimo é encontrado em no máximo log n comparações |
| Space | O(1) — Utiliza apenas três variáveis: left, right e mid, sem necessidade de estruturas de dados adicionais |

## Código

```java
// Entrada: array de inteiros únicos ordenado e rotacionado nums
// Saída: retorna o valor mínimo do array como int
public int findMin(int[] nums) {
    // Inicializar as extremidades do intervalo de busca. Estas duas variáveis representam as extremidades do intervalo de busca
    int left = 0;
    int right = nums.length - 1;

    // Quando left == right, o intervalo de busca se reduz a um único elemento, que é o valor mínimo
    while (left < right) {
        // Usa esta fórmula em vez de (left + right) / 2 para evitar overflow de inteiros
        int mid = left + (right - left) / 2;

        // Se o elemento central for maior que o elemento mais à direita, existe um pivô (quebra na ordem) entre mid e right
        if (nums[mid] > nums[right]) {
            // O valor mínimo está à direita de mid. Como mid é maior que a extremidade direita, não é o mínimo e pode ser excluído
            left = mid + 1;
        } else {
            // De mid até right está ordenado. O valor mínimo está à esquerda de mid (incluindo o próprio mid)
            // Como o próprio mid pode ser o valor mínimo, não o excluímos do intervalo de busca
            right = mid;
        }
    }

    // left == right, o intervalo de busca se reduziu a um único elemento, portanto esse elemento é o valor mínimo
    return nums[left];
}
```
