# Generating All Subsets of a Set — Gerar todos os subconjuntos de um conjunto

## Essência do problema

É fornecido um array de inteiros distintos `nums`. Retorne uma lista com todos os subconjuntos (conjunto potência) de `nums`. Os subconjuntos não devem conter duplicatas, e a ordem de retorno não importa.

## Ideia central

Um conjunto com `n` elementos possui `2^n` subconjuntos. Ao enumerar inteiros de `n` bits de `0` até `2^n - 1`, cada bit representa "incluir ou não o elemento correspondente", permitindo gerar todos os subconjuntos sem omissões nem duplicatas.

## Processo de raciocínio

1. **O número de subconjuntos é determinado por 2^n**: Para cada elemento existem duas escolhas — "incluir" ou "não incluir" — portanto, um conjunto com `n` elementos possui `2^n` subconjuntos. Para enumerar todos, é necessário um mecanismo que represente todos os `2^n` padrões de escolha
2. **A enumeração de duas escolhas pode ser representada por bits**: Associando "incluir=1, não incluir=0", o padrão de escolha de `n` elementos pode ser representado por um inteiro de `n` bits. Por exemplo, quando `nums = [a, b, c]`, a sequência de bits `101` significa "incluir a, não incluir b, incluir c", ou seja, o subconjunto `[a, c]`
3. **Os inteiros de 0 a 2^n-1 cobrem todos os padrões**: Os inteiros representáveis com `n` bits vão de `0` (todos os bits 0 = conjunto vazio) até `2^n - 1` (todos os bits 1 = conjunto com todos os elementos), totalizando `2^n` valores. Enumerando-os em sequência, é possível gerar todos os subconjuntos sem omissões nem duplicatas
4. **Método para construir um subconjunto a partir de cada inteiro**: É possível verificar se o bit `i` do inteiro `mask` é `1` usando `(mask & (1 << i)) != 0`. Se for `1`, adiciona-se `nums[i]` ao subconjunto. Percorrendo `i` de `0` a `n-1`, o subconjunto correspondente a `mask` é concluído
5. **Calcular 2^n com 1 << n**: Em Java, utiliza-se o operador de deslocamento de bits `<<`, e `1 << n` calcula `2^n`. Usando `mask < (1 << n)` como condição do loop, enumeram-se todos os valores de `0` a `2^n - 1` sem omissões
6. **O que retornar no final**: Adiciona-se o subconjunto correspondente a cada `mask` à lista e, após processar todos os valores de `mask`, retorna-se a lista de subconjuntos `result`

## Conhecimentos prévios

### O que é uma máscara de bits

É uma técnica que utiliza cada bit (0 ou 1) de um inteiro como "flag". É possível representar as combinações de "incluir/não incluir" para `n` elementos com um único inteiro.

```java
int mask = 5;            // 101 em binário
// Bit 0: 1 (incluir), Bit 1: 0 (não incluir), Bit 2: 1 (incluir)
```

### Operadores de bits

Combinam-se `&` (AND) e `<<` (deslocamento à esquerda) para verificar se um bit específico está ativado.

```java
1 << 0;                  // 1 (binário: 001) — cria uma máscara com apenas o bit 0 igual a 1
1 << 1;                  // 2 (binário: 010) — cria uma máscara com apenas o bit 1 igual a 1
1 << 2;                  // 4 (binário: 100) — cria uma máscara com apenas o bit 2 igual a 1

int mask = 5;            // binário: 101
(mask & (1 << 0)) != 0;  // true  — o bit 0 é 1
(mask & (1 << 1)) != 0;  // false — o bit 1 é 0
(mask & (1 << 2)) != 0;  // true  — o bit 2 é 1
```

### Calcular 2^n com 1 << n

O deslocamento de bits `1 << n` é a operação de deslocar `1` para a esquerda em `n` bits, e o resultado é `2^n`. É utilizado para obter o número total de subconjuntos.

```java
1 << 3;                  // 8 (= 2^3) — para 3 elementos, existem 8 subconjuntos
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n × 2^n) — para cada uma das 2^n máscaras, percorrem-se n bits |
| Space | O(n × 2^n) — armazenam-se 2^n subconjuntos, e o número médio de elementos por subconjunto é n/2 |

## Código

```java
// Entrada: array de inteiros distintos nums
// Saída: retorna um List<List<Integer>> contendo todos os subconjuntos
List<List<Integer>> subsets(int[] nums) {
    // Número de elementos de nums. Utilizado tanto para o número de bits da máscara quanto para o intervalo de percurso do array
    int n = nums.length;
    // Lista que armazena todos os subconjuntos. Os subconjuntos gerados a partir de cada mask são adicionados aqui
    List<List<Integer>> result = new ArrayList<>();

    // Enumera mask de 0 a 2^n-1, onde cada valor corresponde a um subconjunto
    // Calcula 2^n com 1 << n e utiliza como condição do loop para enumerar todos os 2^n padrões
    for (int mask = 0; mask < (1 << n); mask++) {
        // Cria um subconjunto vazio para adicionar os elementos correspondentes ao mask atual
        List<Integer> subset = new ArrayList<>();

        // i é o índice de nums e, ao mesmo tempo, determina qual bit de mask será verificado
        for (int i = 0; i < n; i++) {
            // Cria uma máscara com apenas o bit i igual a 1 usando 1 << i, e extrai o valor do bit i com AND contra mask
            // Se o bit for 1, significa "incluir este elemento"; se for 0, significa "não incluir", e avança para o próximo i
            if ((mask & (1 << i)) != 0) {
                subset.add(nums[i]);
            }
        }

        // Após o término do loop interno, adiciona o subconjunto concluído à lista de resultados
        result.add(subset);
    }
    // Após processar todos os valores de mask, retorna result contendo os 2^n subconjuntos
    return result;
}
```
