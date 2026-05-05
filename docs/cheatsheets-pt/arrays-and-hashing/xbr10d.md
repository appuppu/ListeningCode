# Finding the K Most Frequent Elements — Retornar os K elementos com maior frequência de ocorrência em um array

## Essência do Problema

Um array de inteiros `nums` e um inteiro `k` são fornecidos. Você deve selecionar os `k` elementos com maior número de ocorrências em `nums` e retorná-los em um array. A ordem de retorno não importa. É garantido que a resposta é única.

## Ideia Central

Após contar a frequência de ocorrência de cada elemento, você pode criar um array de buckets onde a frequência serve como índice. Isso permite extrair os elementos em ordem de frequência em O(n), sem utilizar ordenação (O(n log n)). Como o valor máximo da frequência é no máximo o comprimento `n` do array, o tamanho do array de buckets é finito.

## Processo de Raciocínio

1. **Primeiro, é necessário contar o número de ocorrências de cada elemento**: Para encontrar os K elementos com maior frequência, é necessário saber quantas vezes cada elemento aparece. Utilizando um HashMap, você pode armazenar o "valor numérico" como chave e o "número de ocorrências" como valor, agregando a frequência de todos os elementos em O(n)
2. **Queremos ordenar por frequência, mas a ordenação custa O(n log n)**: Após completar o mapa de frequências, queremos extrair os K elementos com maior frequência. Ordenar por frequência custaria O(n log n), mas existe um método mais rápido
3. **Utilizar um array de buckets com a frequência como índice**: Quando o comprimento do array é `n`, a frequência de ocorrência de qualquer elemento é no máximo `n`. Portanto, preparamos um array de tamanho `n+1` e armazenamos na posição de índice `i` a "lista de elementos com frequência de ocorrência igual a `i`". Este é o conceito do bucket sort
4. **Percorrer o array de buckets do final para o início e coletar K elementos**: Quanto maior o índice do array de buckets, maior a frequência de ocorrência. Percorremos do final (índice `n`) em direção ao início e, se o bucket não estiver vazio, adicionamos seus elementos à lista de resultados. Quando o tamanho da lista de resultados atinge `k`, convertemos a lista em um array e o retornamos

## Conhecimentos Prévios

### O que é um HashMap

Uma estrutura de dados que armazena pares de chave e valor. Permite buscar e obter valores especificando a chave em O(1). Neste problema, o HashMap é utilizado como um contador para contar o número de ocorrências de cada valor numérico.

```java
HashMap<Integer, Integer> map = new HashMap<>();  // Criar um HashMap vazio
map.merge(1, 1, Integer::sum);  // Somar 1 ao valor da chave 1 (inicializar com 1 se a chave não existir)
map.entrySet();                 // Retornar todos os pares de chave e valor como um Set
entry.getKey();                 // Obter a chave do par
entry.getValue();               // Obter o valor do par
```

### O que é o método merge

`map.merge(key, value, remappingFunction)` armazena `value` diretamente se a chave não existir, e combina o valor existente com `value` usando `remappingFunction` se a chave já existir. Ao passar `Integer::sum`, o `value` é somado ao valor existente. É um método conveniente que substitui a combinação de `put` + `getOrDefault` em uma única linha.

```java
map.merge(5, 1, Integer::sum);  // Se a chave 5 não existir, armazenar 1; se existir, armazenar valor existente + 1
// O código acima tem o mesmo significado que o seguinte
map.put(5, map.getOrDefault(5, 0) + 1);
```

### O que é Bucket Sort

Uma técnica de ordenação que distribui elementos em um array utilizando o próprio valor do elemento como índice. Diferentemente da ordenação baseada em comparação (O(n log n)), é possível processar em O(n) quando o intervalo de valores é finito. Neste problema, a frequência de ocorrência (máximo `n`) é utilizada como índice.

```java
List<Integer>[] buckets = new ArrayList[4];  // Criar um array de buckets com índices de 0 a 3
buckets[2] = new ArrayList<>();              // Inicializar o bucket de índice 2
buckets[2].add(7);                           // Armazenar 7 como "elemento com frequência 2"
// buckets = [null, null, [7], null]
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — O(n) para construir o mapa de frequências, O(n) para construir o array de buckets e O(n) para coletar os resultados, totalizando O(n) |
| Space | O(n) — O mapa de frequências contém no máximo n elementos e o array de buckets tem tamanho n+1, totalizando O(n) |

## Código

```java
// Entrada: array de inteiros nums e inteiro k
// Saída: retornar um int[] contendo os k elementos com maior frequência de ocorrência
public int[] topKFrequent(int[] nums, int k) {
    // Passo 1: Agregar a frequência de ocorrência de cada elemento usando um HashMap
    Map<Integer, Integer> freqMap = buildFrequencyMap(nums);
    // Passo 2: Construir um array de buckets com a frequência como índice
    List<Integer>[] buckets = buildBuckets(freqMap, nums.length);
    // Passo 3: Percorrer o array de buckets do final para o início e coletar os K elementos mais frequentes
    return collectTopK(buckets, k);
}

// Agregar o número de ocorrências de cada elemento usando um HashMap e retorná-lo
// Chave=valor numérico, Valor=número de ocorrências desse valor numérico
public Map<Integer, Integer> buildFrequencyMap(int[] nums) {
    Map<Integer, Integer> freqMap = new HashMap<>();
    for (int num : nums) {
        // O merge inicializa com 1 se a chave não existir, ou soma 1 ao valor existente se a chave existir
        freqMap.merge(num, 1, Integer::sum);
    }
    // Após a iteração, o HashMap contém a frequência de ocorrência de todos os elementos
    return freqMap;
}

// Construir e retornar um array de buckets com a frequência como índice
// buckets[i] contém a lista de elementos com frequência de ocorrência igual a i
public List<Integer>[] buildBuckets(Map<Integer, Integer> freqMap, int n) {
    // O tamanho é n+1 porque um elemento pode ocorrer no máximo n vezes, utilizando índices de 0 a n
    List<Integer>[] buckets = new ArrayList[n + 1];
    for (var entry : freqMap.entrySet()) {
        int num = entry.getKey();
        int freq = entry.getValue();
        // Se o bucket for null, criar um novo ArrayList antes de adicionar
        if (buckets[freq] == null) {
            buckets[freq] = new ArrayList<>();
        }
        // Adicionar o valor numérico num ao bucket usando a frequência de ocorrência freq como índice
        buckets[freq].add(num);
    }
    return buckets;
}

// Percorrer o array de buckets do final para o início e coletar K elementos em ordem decrescente de frequência
// Como índices maiores correspondem a frequências de ocorrência mais altas, percorrer na ordem inversa permite extrair os elementos mais frequentes primeiro
public int[] collectTopK(List<Integer>[] buckets, int k) {
    List<Integer> result = new ArrayList<>();
    // Percorrer do final (índice n) em direção ao início. O índice 0 significa "frequência de ocorrência 0", portanto é excluído
    for (int i = buckets.length - 1; i > 0; i--) {
        if (buckets[i] != null) {
            for (int num : buckets[i]) {
                result.add(num);
                // Quando K elementos forem coletados, converter para array e retornar
                if (result.size() == k) {
                    return result.stream().mapToInt(Integer::intValue).toArray();
                }
            }
        }
    }
    // Pelas restrições do problema, a resposta sempre existe, portanto este ponto nunca é alcançado
    return new int[0];
}
```
