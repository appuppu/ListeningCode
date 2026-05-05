# Designing a Time-Based Key-Value Store — Projetar um armazenamento chave-valor baseado em timestamp

## Essência do Problema

Projetar uma estrutura de dados que armazena chaves e valores com timestamp usando `set(key, value, timestamp)`, e retorna o valor correspondente ao maior timestamp **menor ou igual** ao timestamp especificado usando `get(key, timestamp)`. Se não existir um timestamp correspondente, a estrutura retorna uma string vazia.

## Ideia Central

Se mantemos os timestamps ordenados para cada chave, podemos buscar "o maior valor menor ou igual ao valor especificado" em tempo logarítmico. O TreeMap do Java fornece essa operação nativamente através do método `floorEntry`.

## Processo de Raciocínio

1. **Organizar as operações**: `set` é a operação que adiciona um par de timestamp e valor a uma chave, e `get` é a operação que retorna o valor correspondente ao "maior timestamp menor ou igual ao timestamp especificado". A essência do `get` é um problema de busca: "encontrar o maior valor menor ou igual a um determinado valor"
2. **Gerenciar timestamps por chave**: Como chaves diferentes são independentes entre si, separamos por chave usando um HashMap externo e mantemos o mapeamento timestamp→valor para cada chave
3. **Escolher a estrutura de dados que calcula eficientemente "o maior valor menor ou igual"**: Para encontrar "o maior valor menor ou igual" em dados ordenados, é necessária uma busca binária. O TreeMap (árvore de busca binária balanceada baseada em árvore rubro-negra) mantém as chaves em ordem e retorna "a maior entrada menor ou igual à chave especificada" em O(log n) com `floorEntry(key)`
4. **Definir a implementação do set**: Se a chave não estiver registrada no HashMap externo, criamos um novo TreeMap e usamos `put` com o timestamp como chave e o valor como valor no TreeMap. Usando `computeIfAbsent`, podemos escrever a verificação de existência e a criação em uma única linha
5. **Definir a implementação do get**: Primeiro verificamos se a chave existe no HashMap; se não existir, retornamos uma string vazia. Se existir, chamamos `floorEntry(timestamp)` do TreeMap; se o resultado não for null, retornamos seu valor; se for null, retornamos uma string vazia
6. **Tratar casos extremos**: Retornamos uma string vazia em dois casos: quando a chave não está registrada, e quando a chave existe mas todos os timestamps são maiores que o valor especificado

## Conhecimentos Prévios

### O que é HashMap

Uma estrutura de dados que armazena pares de chave e valor. É possível buscar e obter valores especificando a chave em O(1).

```java
HashMap<String, TreeMap<Integer, String>> map = new HashMap<>();  // Cria um HashMap vazio
map.containsKey("foo");    // Retorna boolean indicando se a chave "foo" existe
map.get("foo");            // Retorna o valor correspondente à chave "foo"
```

### O que é computeIfAbsent

Um método do HashMap. Somente quando a chave não está registrada, gera um valor usando uma expressão lambda, registra-o e retorna esse valor. Se a chave já existe, retorna o valor existente. Permite escrever verificação de existência → criação → registro em uma única linha.

```java
map.computeIfAbsent("foo", k -> new TreeMap<>());
// "foo" não registrada → cria um novo TreeMap, registra e retorna esse TreeMap
// "foo" já registrada → retorna o TreeMap existente
```

### O que é TreeMap

Um Map baseado em árvore de busca binária balanceada que mantém as chaves em ordem (crescente). Diferente de um HashMap comum, oferece operações de busca baseadas na relação de ordem entre as chaves. `put` e `get` operam em O(log n).

```java
TreeMap<Integer, String> tree = new TreeMap<>();  // Cria um TreeMap vazio
tree.put(1, "one");        // Armazena "one" no timestamp 1
tree.put(3, "three");      // Armazena "three" no timestamp 3
tree.put(5, "five");       // Armazena "five" no timestamp 5
```

### O que é floorEntry

Um método do TreeMap. Retorna a entrada (par de chave e valor) correspondente à maior chave **menor ou igual** à chave especificada. Retorna null se não existir uma entrada correspondente. Opera em O(log n) pois realiza uma busca binária internamente.

```java
tree.floorEntry(4);   // Maior menor ou igual a 4 → retorna a entrada da chave 3 {3="three"}
tree.floorEntry(5);   // Maior menor ou igual a 5 → retorna a entrada da chave 5 {5="five"}
tree.floorEntry(0);   // Não existe entrada menor ou igual a 0 → retorna null

Map.Entry<Integer, String> entry = tree.floorEntry(4);
entry.getValue();     // Obtém o valor da entrada → "three"
```

## Complexidade

| | Valor |
|---|---|
| Time | O(log n) — tanto set quanto get realizam operações no TreeMap em O(log n) (n é o número de timestamps armazenados para essa chave) |
| Space | O(n) — armazena todas as entradas salvas por todas as chamadas de set (n é o número total de entradas) |

## Código

```java
// Entrada: set(key, value, timestamp) — chave string, valor string, timestamp inteiro / get(key, timestamp) — chave string, timestamp inteiro
// Saída: set não tem valor de retorno / get retorna a string do valor correspondente (string vazia se não houver correspondência)
class TimeMap {
    // HashMap que mantém um TreeMap (timestamp → valor) para cada chave
    // O HashMap externo separa por chave, e o TreeMap interno mantém os timestamps em ordem
    Map<String, TreeMap<Integer, String>> map;

    public TimeMap() {
        // Cria um HashMap como estrutura de dados externa
        map = new HashMap<>();
    }

    public void set(String key, String val, int ts) {
        // computeIfAbsent cria e registra automaticamente um novo TreeMap se a chave não estiver registrada, ou retorna o TreeMap existente
        // O TreeMap posiciona as chaves em ordem durante a inserção, portanto não é necessária uma operação explícita de ordenação
        map.computeIfAbsent(key, k -> new TreeMap<>())
            .put(ts, val);
    }

    public String get(String key, int ts) {
        // Se a chave não existe, significa que set nunca foi chamado, então retorna string vazia
        if (!map.containsKey(key))
            return "";

        // Obtém o TreeMap dessa chave
        TreeMap<Integer, String> tree = map.get(key);

        // Busca a maior entrada menor ou igual ao timestamp especificado (o TreeMap percorre a árvore de busca binária interna em O(log n))
        Map.Entry<Integer, String> entry = tree.floorEntry(ts);

        // Se encontrou uma entrada, retorna o valor. Se for null, significa que todos os timestamps são maiores que o valor especificado, então retorna string vazia
        return entry != null ? entry.getValue() : "";
    }
}
```
