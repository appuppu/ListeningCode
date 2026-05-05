# Finding Combinations That Sum to a Target Without Reuse — Encontrar todas as combinações únicas que somam ao alvo a partir de um array com elementos duplicados

## Essência do problema

Um array de inteiros `candidates` (que pode conter elementos duplicados) e um inteiro `target` são fornecidos. O objetivo é encontrar todas as combinações de números no array cuja soma seja igual a `target`. Cada número pode ser usado **apenas uma vez** em cada combinação, e o resultado **não deve conter combinações duplicadas**.

## Ideia central

Ao ordenar o array, os elementos com o mesmo valor ficam adjacentes, permitindo que a condição `i > start && cands[i] == cands[i-1]` funcione para pular elementos duplicados no mesmo nível da recursão. Isso previne fundamentalmente a geração de combinações duplicadas, enquanto explora todas as combinações únicas sem omissões.

## Processo de raciocínio

1. **É necessário enumerar todas as combinações**: O problema pede "todas as combinações que satisfazem a condição", portanto é preciso explorar todo o espaço de soluções, e não apenas uma solução ótima. Backtracking é adequado para esse tipo de problema de "enumeração completa"
2. **Ramificar entre "usar/não usar" cada elemento**: Para cada elemento do array, escolhe-se recursivamente se ele será incluído ou não na combinação atual. Para garantir que cada elemento seja usado apenas uma vez, o índice inicial avança para `i + 1` na chamada recursiva
3. **É necessário eliminar combinações duplicadas**: Quando o array contém elementos duplicados, selecionar o mesmo valor em índices diferentes pode gerar combinações idênticas. Por exemplo, em `[1,1,2]` com target=3, a combinação do primeiro 1 com 2 e a combinação do segundo 1 com 2 produzem o mesmo `[1,2]`
4. **Ordenar e pular duplicatas**: Ao ordenar o array, valores iguais ficam adjacentes. No mesmo nível da recursão (dentro do mesmo loop for), pular elementos com o mesmo valor do anterior previne a geração de combinações duplicadas. A condição de pulo é `i > start && cands[i] == cands[i-1]`. A condição `i > start` permite o uso do primeiro elemento, enquanto pula os subsequentes com o mesmo valor
5. **Otimizar a busca com poda**: Como o array está ordenado, quando o elemento atual excede o valor restante `remain`, todos os elementos seguintes também o excedem. Interromper o loop com `if (cands[i] > remain) break` elimina buscas desnecessárias
6. **Avaliação do caso base**: Quando `remain` chega a 0, isso significa que a soma dos elementos no `path` atual é exatamente igual a `target`, então uma cópia de `path` é adicionada à lista de resultados

## Conhecimentos prévios

### O que é backtracking

Backtracking é uma técnica de busca que constrói candidatos a solução de forma incremental e, ao detectar que uma condição não é satisfeita, retorna ao estado anterior (faz backtrack) para tentar outro candidato. É implementado com o padrão "escolher → recursão → desfazer a escolha".

```java
path.add(element);          // Escolha: adicionar o elemento à combinação
backtrack(next_state);      // Recursão: continuar a busca para o próximo elemento
path.remove(path.size()-1); // Desfazer: remover o elemento da combinação e restaurar o estado original
```

### O que é Arrays.sort

É um método padrão do Java que ordena um array em ordem crescente. A ordenação faz com que elementos com o mesmo valor fiquem adjacentes, facilitando a detecção e o pulo de duplicatas.

```java
int[] arr = {2, 1, 2, 3};
Arrays.sort(arr);           // arr se torna {1, 2, 2, 3}
```

### Construtor de cópia do ArrayList

`new ArrayList<>(path)` cria uma nova lista copiando o conteúdo de `path`. No backtracking, como `path` muda continuamente durante a recursão, é necessário fazer uma cópia no momento de adicioná-lo ao resultado.

```java
List<Integer> path = new ArrayList<>(Arrays.asList(1, 2));
List<Integer> copy = new ArrayList<>(path);  // Cria uma cópia de [1, 2]
path.add(3);        // path se torna [1, 2, 3]
// copy permanece inalterado como [1, 2]
```

## Complexidade

| | Valor |
|---|---|
| Tempo | O(2^n) — Como há 2 opções para cada elemento ("usar/não usar"), no pior caso são exploradas 2^n combinações |
| Espaço | O(n) — A profundidade máxima da recursão é n, e o path também armazena no máximo n elementos |

## Código

```java
// Entrada: array de inteiros candidates (que pode conter elementos duplicados) e um inteiro target
// Saída: retorna uma List<List<Integer>> contendo todas as combinações únicas cuja soma é igual a target
private void backtrack(int[] cands, int start, int remain,
        List<Integer> path, List<List<Integer>> result) {
    // Se remain é 0, uma combinação cuja soma do path é exatamente igual a target foi encontrada
    if (remain == 0) {
        // Como path continuará mudando nas recursões seguintes, cria-se uma cópia e adiciona-se ao resultado
        result.add(new ArrayList<>(path));
        return;
    }

    // Iniciar a partir de start impede a seleção de elementos já usados (anteriores a start)
    for (int i = start; i < cands.length; i++) {
        // Pular se for o segundo elemento ou posterior no mesmo nível de recursão e tiver o mesmo valor do anterior, prevenindo combinações duplicadas
        // i > start significa "não é o primeiro elemento no mesmo nível de recursão"
        if (i > start && cands[i] == cands[i - 1]) continue;

        // Como o array está ordenado, se o valor atual excede remain, todos os seguintes também excedem (poda)
        if (cands[i] > remain) break;

        path.add(cands[i]);                  // Escolha: adicionar o elemento à combinação
        backtrack(cands, i + 1,              // Recursão: usar i+1 para impedir o uso do mesmo elemento duas vezes
            remain - cands[i], path, result); // Subtrair o elemento atual de remain para atualizar a soma restante
        path.remove(path.size() - 1);        // Desfazer: remover o elemento e restaurar o estado para tentar outro elemento
    }
}

public List<List<Integer>> combinationSum2(
        int[] candidates, int target) {
    // A ordenação posiciona elementos duplicados com o mesmo valor de forma adjacente, possibilitando a condição de pulo
    Arrays.sort(candidates);
    // Criar a lista de resultados e o path para registrar a combinação atual, ambos vazios
    List<List<Integer>> result = new ArrayList<>();
    // Iniciar a busca recursiva a partir do índice 0 e com soma restante igual a target
    backtrack(candidates, 0, target, new ArrayList<>(), result);
    // Após a conclusão de todas as recursões, retornar todas as combinações únicas armazenadas
    return result;
}
```
