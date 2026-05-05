# Generating All Unique Subsets With Duplicates — Gerar todos os subconjuntos únicos a partir de um array com elementos duplicados

## Essência do problema

É dado um array de inteiros `nums` que pode conter valores duplicados. O objetivo é retornar todos os subconjuntos únicos possíveis. O resultado não deve conter subconjuntos duplicados, e a ordem dos elementos dentro de cada subconjunto pode ser qualquer uma.

## Ideia central

Se o array for ordenado previamente, basta pular elementos que possuem o mesmo valor que o elemento anterior no mesmo nível de recursão para evitar fundamentalmente a geração de subconjuntos duplicados.

## Processo de raciocínio

1. **A geração de subconjuntos é um problema clássico de backtracking**: Decidindo recursivamente para cada elemento "incluir ou não incluir", é possível enumerar todos os subconjuntos. Adicionando o subconjunto atual ao resultado em cada etapa da recursão, todos os subconjuntos são obtidos
2. **Identificar a causa da duplicação**: Quando o array contém múltiplos valores iguais, por exemplo em `[1,2,2]`, escolher o primeiro 2 ou o segundo 2 gera o mesmo subconjunto. A duplicação ocorre quando "o mesmo valor é escolhido múltiplas vezes no mesmo nível de recursão"
3. **Ordenar para tornar os elementos duplicados adjacentes**: Ao ordenar o array, elementos com o mesmo valor ficam lado a lado. Isso permite determinar "se o valor é igual ao do elemento anterior" por uma simples comparação
4. **Pular duplicatas no mesmo nível de recursão**: Dentro do loop for, quando a condição `i > start && nums[i] == nums[i-1]` é satisfeita, o elemento é pulado. A condição `i > start` significa "é a segunda opção em diante no mesmo nível de recursão", permitindo que o mesmo valor seja escolhido em níveis de recursão diferentes (é permitido incluir o mesmo valor múltiplas vezes em um subconjunto)
5. **Adicionar ao resultado em cada etapa da recursão**: No início da função recursiva, o subconjunto atual `curr` é adicionado à lista de resultados. Isso garante que todos os subconjuntos, desde o conjunto vazio até o conjunto com todos os elementos, sejam incluídos no resultado
6. **Restaurar o estado original com backtracking**: Removendo o último elemento de `curr` após a chamada recursiva, a próxima opção pode ser explorada corretamente

## Conhecimentos prévios

### O que é backtracking

É uma técnica de busca que constrói candidatos a solução recursivamente e, quando uma condição não é satisfeita, desfaz a última escolha e tenta uma alternativa. É utilizada para enumerar subconjuntos, permutações e combinações.

```java
// Estrutura básica do backtracking
void backtrack(estado, listaDeOpções) {
    adicionar estado atual ao resultado;
    for (cada opção) {
        aplicar a escolha;
        backtrack(próximo estado, opções restantes);
        desfazer a escolha;  // ← backtrack
    }
}
```

### O que é Arrays.sort

É um método que ordena um array em ordem crescente. Ao tornar os elementos duplicados adjacentes, facilita a detecção de duplicatas.

```java
int[] nums = {4, 1, 4, 2};
Arrays.sort(nums);  // nums se torna {1, 2, 4, 4}
```

### Sobre a cópia de ArrayList

`new ArrayList<>(list)` cria uma cópia rasa de uma lista existente. Ao adicionar um subconjunto ao resultado, se uma cópia não for adicionada em vez da referência, o conteúdo será modificado pelo backtracking posterior.

```java
List<Integer> curr = new ArrayList<>();
curr.add(1);
curr.add(2);
List<Integer> copy = new ArrayList<>(curr);  // Cria uma cópia de [1, 2]
curr.remove(curr.size() - 1);               // curr volta a ser [1], mas copy permanece [1, 2]
```

### Remoção do último elemento de uma List

`list.remove(list.size() - 1)` remove o último elemento da lista. É utilizado no backtracking para desfazer o elemento adicionado anteriormente.

```java
List<Integer> curr = new ArrayList<>();
curr.add(5);        // curr = [5]
curr.add(3);        // curr = [5, 3]
curr.remove(curr.size() - 1);  // curr volta a ser [5]
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n × 2^n) — Existem no máximo 2^n subconjuntos, e a cópia de cada subconjunto custa no máximo O(n) |
| Space | O(n) — A profundidade da recursão é no máximo n, e o comprimento da lista de trabalho `curr` também é no máximo n (excluindo a lista de resultados) |

## Código

```java
// Entrada: array de inteiros nums que pode conter duplicatas
// Saída: retorna List<List<Integer>> contendo todos os subconjuntos únicos
void backtrack(int[] nums, int start, List<Integer> curr, List<List<Integer>> result) {
    // Adiciona uma cópia do subconjunto atual ao resultado
    // Motivo de criar uma cópia com new ArrayList<>(curr): como curr muda de conteúdo nas recursões seguintes, é necessário salvar o estado naquele momento em vez da referência
    result.add(new ArrayList<>(curr));

    // Ao iterar a partir de start, não seleciona elementos anteriores a si mesmo, mantendo a ordem dos elementos no subconjunto
    for (int i = start; i < nums.length; i++) {
        // Pula se o valor é igual ao do elemento anterior no mesmo nível de recursão, evitando duplicatas
        // i > start: não é a primeira opção neste nível (em níveis diferentes, o mesmo valor pode ser escolhido)
        // nums[i] == nums[i-1]: o valor é igual ao do elemento anterior
        // Quando ambas as condições são verdadeiras simultaneamente, o mesmo valor seria escolhido duas vezes no mesmo nível, gerando subconjuntos duplicados
        if (i > start && nums[i] == nums[i - 1]) continue;

        // Adiciona o elemento atual ao subconjunto e avança para o próximo nível
        curr.add(nums[i]);
        // Ao passar i + 1, no próximo nível de recursão apenas elementos posteriores ao atual são candidatos à seleção
        backtrack(nums, i + 1, curr, result);

        // Backtrack: remove o último elemento para restaurar o estado original, permitindo selecionar outro elemento na próxima iteração
        curr.remove(curr.size() - 1);
    }
}

public List<List<Integer>> subsetsWithDup(int[] nums) {
    // Ordena para tornar elementos de mesmo valor adjacentes. Isso permite a detecção de duplicatas pela simples comparação nums[i] == nums[i-1]
    Arrays.sort(nums);
    List<List<Integer>> result = new ArrayList<>();
    // 0 significa "iniciar a busca a partir do início do array"
    backtrack(nums, 0, new ArrayList<>(), result);
    // Após todas as recursões serem concluídas, result contém todos os subconjuntos únicos
    return result;
}
```
