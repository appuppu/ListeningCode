# Finding the Longest Increasing Subsequence — Encontrar o comprimento da maior subsequência estritamente crescente

## Essência do problema

Um array de inteiros `nums` é fornecido. O objetivo é retornar o comprimento da **subsequência estritamente crescente** mais longa que pode ser formada removendo elementos do array original (sem alterar a ordem). A subsequência não precisa ser contígua, mas deve manter a ordem relativa dos elementos no array original.

## Ideia central

"Quanto menor for o elemento final de uma subsequência crescente de comprimento `k`, maior será a possibilidade de estendê-la com elementos subsequentes." Se gerenciarmos o valor mínimo do elemento final para cada comprimento em um array `tails`, podemos determinar a posição de inserção de um novo elemento por busca binária em O(log n), resolvendo o problema inteiro em O(n log n).

## Processo de raciocínio

1. **Um elemento final menor é mais vantajoso para estender a subsequência crescente**: Quando existem múltiplas subsequências crescentes de mesmo comprimento, aquela com o menor elemento final possui o "intervalo de valores conectáveis" mais amplo. Portanto, basta registrar apenas o valor mínimo do elemento final para cada comprimento
2. **Gerenciar os valores mínimos dos elementos finais com o array tails**: Preparamos um array `tails` onde `tails[i]` armazena "o valor mínimo do elemento final que uma subsequência crescente de comprimento `i+1` pode ter". Este array mantém-se sempre ordenado (pois subsequências mais longas necessariamente têm elementos finais maiores)
3. **O processamento de cada novo elemento divide-se em 2 padrões**: Para cada elemento `num` do array, encontramos por busca binária o menor elemento em `tails` que seja maior ou igual a `num`. Se a posição encontrada ultrapassar o final de `tails`, `num` é maior que a subsequência mais longa existente, então o adicionamos ao final de `tails`. Caso contrário, substituímos o valor naquela posição por `num` para atualizar o valor mínimo do elemento final
4. **Razão pela qual a busca binária é aplicável**: Como o array `tails` está sempre ordenado, podemos determinar a posição de inserção de `num` com `Collections.binarySearch` em O(log n). Isso torna o processamento de cada elemento O(log n), alcançando O(n log n) no total
5. **O comprimento do array tails é a resposta**: Durante o processamento de cada elemento, `tails` recebe uma adição ou uma substituição. Uma adição significa que o comprimento da maior subsequência aumentou em 1. Ao final do processamento de todos os elementos, `tails.size()` é o comprimento da maior subsequência crescente

## Conhecimentos prévios

### O que é ArrayList

Um array de tamanho variável. A adição, obtenção e atualização de elementos são feitas em O(1). Diferente de arrays convencionais, não é necessário definir o tamanho antecipadamente.

```java
List<Integer> list = new ArrayList<>();  // Cria um ArrayList vazio
list.add(10);          // Adiciona 10 ao final → [10]
list.add(20);          // Adiciona 20 ao final → [10, 20]
list.get(0);           // Obtém o elemento no índice 0 → 10
list.set(0, 5);        // Substitui o elemento no índice 0 por 5 → [5, 20]
list.size();           // Retorna o número de elementos → 2
```

### O que é Collections.binarySearch

Um método que realiza busca binária em uma lista ordenada e retorna a posição do valor especificado. Se o valor for encontrado, retorna seu índice. Se não for encontrado, retorna um valor negativo no formato `-(posição de inserção) - 1`. A posição de inserção é a posição onde o valor pode ser inserido mantendo a ordem de classificação da lista.

```java
List<Integer> list = Arrays.asList(2, 5, 8, 12);
Collections.binarySearch(list, 5);   // 5 está no índice 1 → retorna 1
Collections.binarySearch(list, 6);   // 6 não existe. A posição de inserção é 2 → -(2)-1 = -3 é retornado
Collections.binarySearch(list, 1);   // 1 não existe. A posição de inserção é 0 → -(0)-1 = -1 é retornado
Collections.binarySearch(list, 15);  // 15 não existe. A posição de inserção é 4 → -(4)-1 = -5 é retornado
```

Para recuperar a posição de inserção a partir de um valor de retorno negativo, calcula-se `-(valor de retorno + 1)`. Exemplo: se o valor de retorno for -3, então `-(-3 + 1) = 2` é a posição de inserção.

### Conceito do array tails

`tails` é um array que registra "o valor mínimo do elemento final de subsequências crescentes para cada comprimento". `tails[i]` significa "o valor mínimo do elemento final que uma subsequência crescente de comprimento `i+1` pode ter". Este array mantém-se sempre em ordem crescente.

Exemplo: processo de processamento de nums = [3, 1, 4, 1, 5]:
- Processa 3 → tails = [3] (o valor mínimo do elemento final da subsequência de comprimento 1 é 3)
- Processa 1 → tails = [1] (atualiza o valor mínimo do elemento final de comprimento 1 para 1. 1 é menor que 3, portanto mais vantajoso)
- Processa 4 → tails = [1, 4] (4 é maior que 1, então é adicionado ao final. Uma subsequência de comprimento 2 foi formada)
- Processa 1 → tails = [1, 4] (a posição de inserção de 1 é o índice 0, que já contém 1, portanto não há alteração)
- Processa 5 → tails = [1, 4, 5] (5 é maior que 4, então é adicionado ao final. Uma subsequência de comprimento 3 foi formada)

O valor final de `tails.size()` = 3 é a resposta.

## Complexidade

| | Valor |
|---|---|
| Time | O(n log n) — realiza busca binária em O(log n) para cada um dos n elementos |
| Space | O(n) — armazena no máximo n elementos no array tails |

## Código

```java
// Entrada: array de inteiros nums
// Saída: retorna o comprimento da maior subsequência estritamente crescente como int
public int lengthOfLIS(int[] nums) {
    // Array que mantém em ordem crescente os valores mínimos dos elementos finais das subsequências crescentes de cada comprimento
    // tails[i] significa "o valor mínimo do elemento final que uma subsequência crescente de comprimento i+1 pode ter"
    List<Integer> tails = new ArrayList<>();

    // Percorre cada elemento do array nums do início ao fim, um por vez
    for (int num : nums) {
        // Determina por busca binária a posição onde num deve ser inserido no array tails
        // A busca binária é aplicável porque tails está sempre ordenado
        int pos = Collections.binarySearch(tails, num);

        // Um valor negativo significa "não encontrado", então o convertemos para a posição de inserção
        // Se pos for 0 ou maior, um valor igual a num já existe em tails[pos], então o usamos diretamente
        if (pos < 0)
            pos = -(pos + 1);

        if (pos == tails.size()) {
            // num é maior que todos os elementos de tails, então o adicionamos ao final
            // Isso significa que o comprimento da maior subsequência crescente aumentou em 1
            tails.add(num);
        } else {
            // Substitui o valor mínimo do elemento final na posição correspondente por num
            // Com isso, o valor mínimo do elemento final da subsequência crescente de comprimento pos+1 torna-se menor,
            // ampliando a possibilidade de estender a subsequência no futuro
            tails.set(pos, num);
        }
    }

    // O número de elementos em tails corresponde ao número de adições ao final realizadas durante o processamento,
    // e este é o comprimento da maior subsequência crescente
    return tails.size();
}
```
