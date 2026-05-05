# Searching for a Target in a Rotated Sorted Array — Buscar um alvo em um array ordenado e rotacionado

## Essência do problema

Um array de inteiros ordenado em ordem crescente foi rotacionado em um pivô desconhecido. O objetivo é encontrar o valor `target` fornecido nesse array e retornar seu índice. Se o `target` não existir, retorna-se `-1`. Todos os elementos são únicos.

## Ideia central

Ao dividir um array ordenado e rotacionado pelo meio, uma das duas metades — esquerda ou direita — é necessariamente ordenada. Verifica-se por meio de checagem de intervalo se o `target` está contido na metade ordenada; caso contrário, explora-se a outra metade. Dessa forma, o intervalo de busca é reduzido pela metade a cada iteração.

## Processo de raciocínio

1. **Deseja-se usar Binary Search porque o array é ordenado**: Em um array ordenado convencional, a Binary Search permite buscar em O(log n). Mesmo com a rotação, busca-se manter essa eficiência
2. **Ao dividir o array rotacionado pelo meio, uma das metades é necessariamente ordenada**: No array `[4,5,6,7,0,1,2]`, ao dividir em `mid=3` (valor 7), a metade esquerda `[4,5,6,7]` é ordenada e a metade direita `[0,1,2]` também é ordenada. Como o pivô da rotação está contido em apenas uma das metades, a outra metade mantém necessariamente a ordem crescente
3. **Como determinar qual metade é ordenada**: Se `nums[left] <= nums[mid]` for verdadeiro, a metade esquerda é ordenada. Caso contrário, a metade direita é ordenada. O sinal de igualdade é incluído para tratar corretamente o caso em que `left == mid` (quando há dois ou menos elementos)
4. **Como determinar se o target está na metade ordenada**: Na metade ordenada, os valores mínimo e máximo são conhecidos, então é possível verificar por meio de desigualdades se o `target` está dentro desse intervalo. Por exemplo, se a metade esquerda é ordenada, verifica-se com `target >= nums[left] && target < nums[mid]`
5. **Explorar a metade que contém o target**: Se o `target` estiver dentro do intervalo da metade ordenada, restringe-se a busca a essa metade. Se estiver fora do intervalo, o `target` deve estar na outra metade, então explora-se essa outra metade
6. **Tratamento ao final do loop**: Se a busca prosseguir até `left > right` sem encontrar o `target`, isso significa que o `target` não existe no array, e retorna-se `-1`

## Conhecimentos prévios

### O que é Binary Search (busca binária)

É uma técnica de busca em arrays ordenados que examina o elemento central do intervalo de busca e reduz o intervalo pela metade repetidamente. Como o intervalo é reduzido pela metade a cada iteração, a busca é realizada com complexidade de tempo O(log n).

```java
int left = 0;
int right = nums.length - 1;
while (left <= right) {                    // Itera enquanto o intervalo de busca for válido
    int mid = left + (right - left) / 2;   // Cálculo do meio que evita overflow
    // Compara nums[mid] com target e atualiza left ou right
}
```

### O que é um array ordenado e rotacionado

É um array ordenado em ordem crescente que foi cortado em uma determinada posição, movendo a segunda parte para o início. Por exemplo, ao rotacionar `[0,1,2,4,5,6,7]` no índice 4, obtém-se `[4,5,6,7,0,1,2]`. O array como um todo não está ordenado, mas cada lado do pivô é individualmente ordenado.

```
Array original:    [0, 1, 2, 4, 5, 6, 7]
Após rotação:      [4, 5, 6, 7, 0, 1, 2]
                    ordenado↑  ↑ordenado
```

## Complexidade

| | Valor |
|---|---|
| Time | O(log n) — Como o intervalo de busca é reduzido pela metade a cada iteração, são necessárias no máximo log n comparações |
| Space | O(1) — Utilizam-se apenas as 3 variáveis left, right e mid, sem necessidade de estruturas de dados adicionais |

## Código

```java
// Entrada: array de inteiros ordenado e rotacionado nums e um inteiro target
// Saída: retorna o índice do target como int. Retorna -1 se não existir
public int search(int[] nums, int target) {
    // Inicializa as extremidades do intervalo de busca. Essas duas variáveis representam os limites do intervalo
    int left = 0;
    int right = nums.length - 1;

    // Quando left > right, o intervalo de busca está vazio
    while (left <= right) {
        // Usa-se esta fórmula em vez de (left + right) / 2 para evitar overflow de inteiros em left + right
        int mid = left + (right - left) / 2;

        // Se o elemento central for igual ao target, retorna o índice
        if (nums[mid] == target) {
            return mid;
        }

        // Verifica se a metade esquerda é ordenada
        // O sinal de igualdade é incluído para identificar corretamente a metade esquerda como ordenada quando left == mid (intervalo com 2 ou menos elementos)
        if (nums[left] <= nums[mid]) {
            // Verifica se o target está dentro do intervalo da metade esquerda
            if (target >= nums[left] && target < nums[mid]) {
                right = mid - 1;  // O target está dentro do intervalo da metade esquerda, então restringe à metade esquerda
            } else {
                left = mid + 1;   // O target está fora do intervalo da metade esquerda, então restringe à metade direita
            }
        // Caso a metade direita seja ordenada
        } else {
            // Verifica se o target está dentro do intervalo da metade direita
            if (target > nums[mid] && target <= nums[right]) {
                left = mid + 1;   // O target está dentro do intervalo da metade direita, então restringe à metade direita
            } else {
                right = mid - 1;  // O target está fora do intervalo da metade direita, então restringe à metade esquerda
            }
        }
    }

    // O intervalo de busca está vazio, portanto o target não existe no array
    return -1;
}
```
