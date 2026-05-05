# Designing a Least Recently Used Cache — Projetar um cache que remove automaticamente o elemento usado há mais tempo quando a capacidade é excedida

## Essência do problema

O objetivo é projetar um cache que armazena chaves e valores inteiros. O cache deve suportar duas operações, `get(key)` e `put(key, value)`, e ambas devem funcionar em O(1). Quando o cache exceder a capacidade `capacity`, o sistema deve remover automaticamente o **elemento menos recentemente usado (Least Recently Used)** antes de inserir o novo elemento.

## Ideia central

Ao criar um LinkedHashMap do Java no modo de ordem de acesso e sobrescrever o método `removeEldestEntry`, a ordem de acesso é atualizada automaticamente a cada chamada de get/put, e o elemento mais antigo é removido automaticamente quando a capacidade é excedida. Toda a funcionalidade do cache LRU pode ser implementada apenas com os mecanismos internos do LinkedHashMap.

## Processo de raciocínio

1. **get/put em O(1) são necessários**: Um HashMap é necessário para o acesso rápido de valores a partir de chaves. Porém, um HashMap convencional não possui a funcionalidade de rastrear a ordem de uso dos elementos
2. **O rastreamento da ordem de uso é necessário**: No LRU, é necessário identificar o "elemento usado há mais tempo". Cada vez que um elemento é acessado, ele deve ser movido para a posição "mais recente", e o elemento que permanece no início deve ser o "mais antigo". Portanto, uma estrutura ordenada é necessária
3. **O LinkedHashMap combina essas duas funcionalidades**: O LinkedHashMap do Java possui, além das funcionalidades do HashMap, uma lista duplamente encadeada interna. Ao passar `true` como terceiro argumento do construtor, o modo de ordem de acesso é ativado, e a cada chamada de get ou put, o elemento correspondente é movido automaticamente para o final da lista
4. **Remoção automática ao exceder a capacidade**: Ao sobrescrever o método `removeEldestEntry` do LinkedHashMap para retornar `true` quando `size() > capacity`, o LinkedHashMap chama esse método imediatamente após a inserção de um novo elemento com put. Se `true` for retornado, o elemento no início da lista (o mais antigo) é removido automaticamente
5. **Quando a chave não existe no get**: A especificação do problema exige que `-1` seja retornado quando a chave não existe. Usando `getOrDefault(key, -1)`, a verificação de existência e a obtenção do valor podem ser realizadas em uma única chamada
6. **Estrutura final**: Basta criar o LinkedHashMap no modo de ordem de acesso no construtor e sobrescrever o `removeEldestEntry`. Os métodos get e put consistem apenas em delegações simples ao LinkedHashMap

## Conhecimentos prévios

### O que é LinkedHashMap

É uma estrutura de dados que, além de todas as funcionalidades do HashMap, mantém a ordem dos elementos por meio de uma lista duplamente encadeada interna. Ao passar `true` para o terceiro argumento `accessOrder` do construtor, cada vez que um elemento é acessado (get ou put), esse elemento é movido para o final da lista. O elemento que não é acessado há mais tempo permanece no início da lista.

```java
// 1º argumento: capacidade inicial, 2º argumento: fator de carga, 3º argumento: true=modo de ordem de acesso
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(16, 0.75f, true);
map.put(1, 10);     // Armazena o valor 10 na chave 1. Lista: [1]
map.put(2, 20);     // Armazena o valor 20 na chave 2. Lista: [1, 2]
map.get(1);          // Acessa a chave 1. Lista: [2, 1] (1 é movido para o final)
map.put(3, 30);     // Armazena o valor 30 na chave 3. Lista: [2, 1, 3]
// Neste ponto, a chave 2 no início da lista é o "elemento usado há mais tempo"
```

### O que é removeEldestEntry

É um método que o LinkedHashMap chama automaticamente imediatamente após a inserção de um novo elemento com put. Quando esse método retorna `true`, o LinkedHashMap remove automaticamente o elemento mais antigo no início da lista. Por padrão, ele sempre retorna `false`, portanto é necessário sobrescrevê-lo para definir a condição de remoção.

```java
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(cap, 0.75f, true) {
    @Override
    protected boolean removeEldestEntry(Map.Entry<Integer, Integer> eldest) {
        return size() > cap;  // Retorna true quando o tamanho excede a capacidade, fazendo o elemento mais antigo ser removido
    }
};
```

### O que é getOrDefault

É um método da interface Map. Se a chave existir, o método retorna o valor correspondente; se não existir, retorna o valor padrão especificado no segundo argumento. Isso permite combinar as duas chamadas de `containsKey` e `get` em uma única chamada.

```java
map.put(1, 10);
map.getOrDefault(1, -1);   // A chave 1 existe, portanto retorna o valor 10
map.getOrDefault(99, -1);  // A chave 99 não existe, portanto retorna o valor padrão -1
```

## Complexidade

| | Valor |
|---|---|
| Time | O(1) — Tanto o get quanto o put operam em O(1), pois o acesso ao HashMap e a movimentação dentro da lista são todos O(1) |
| Space | O(n) — Os elementos correspondentes à capacidade do cache são armazenados dentro do LinkedHashMap (n é a capacity) |

## Código

```java
// Entrada: inteiro capacity (capacidade máxima do cache) no construtor, inteiro key no get, inteiro key e inteiro value no put
// Saída: get retorna o valor correspondente à chave (retorna -1 se a chave não existir). put não retorna valor
class LRUCache {
    LinkedHashMap<Integer, Integer> map;
    // Variável de instância que armazena a capacidade. Usada para a verificação de remoção dentro de removeEldestEntry
    int cap;

    // Recebe a capacidade e inicializa o LinkedHashMap no modo de ordem de acesso
    LRUCache(int capacity) {
        cap = capacity;
        // 1º argumento: capacidade inicial, 2º argumento: fator de carga padrão, 3º argumento: true=modo de ordem de acesso
        // No modo de ordem de acesso, a cada chamada de get ou put, o elemento correspondente é movido automaticamente para o final da lista
        map = new LinkedHashMap<>(cap, 0.75f, true) {
            // Método chamado automaticamente pelo LinkedHashMap a cada put
            // Retorna true quando size() > cap, fazendo o elemento mais antigo no início da lista ser removido automaticamente
            // Isso garante que o tamanho do cache seja sempre mantido igual ou inferior a cap
            protected boolean removeEldestEntry(Map.Entry<Integer, Integer> e) {
                return size() > cap;
            }
        };
    }

    // Quando a chave existe: no modo de ordem de acesso, o elemento correspondente é movido para o final da lista (registrado como mais recente), e o valor é retornado
    // Quando a chave não existe: o valor padrão -1 é retornado
    int get(int key) {
        return map.getOrDefault(key, -1);
    }

    // Insere ou atualiza o par chave-valor
    // Após a inserção, removeEldestEntry é chamado automaticamente, e se size() > cap, o elemento mais antigo é removido
    // Se a chave já existir, o valor é sobrescrito e o elemento correspondente é movido para o final da lista
    void put(int key, int value) {
        map.put(key, value);
    }
}
```
