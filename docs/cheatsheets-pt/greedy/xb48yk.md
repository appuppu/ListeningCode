# Dividing Cards Into Consecutive Groups — Determinar se as cartas podem ser divididas em grupos consecutivos de tamanho especificado

## Essência do Problema

São dados um array de inteiros `hand` (valores das cartas) e um inteiro `groupSize`. O objetivo é retornar um `boolean` indicando se é possível dividir todas as cartas em grupos onde cada grupo é composto por `groupSize` valores **consecutivos**. Todas as cartas devem ser utilizadas sem sobra nem falta.

## Ideia Central

Se processarmos as cartas de forma gulosa a partir do menor valor, o grupo ao qual cada carta pertence é determinado de forma única. Repetimos o processo de criar grupos consecutivos a partir da menor carta e remover as cartas utilizadas; se todas as cartas forem consumidas, a divisão é possível.

## Processo de Raciocínio

1. **Verificar a pré-condição**: Como as cartas são divididas em grupos de `groupSize` cartas cada, se o número total de cartas não for divisível por `groupSize`, a divisão é impossível. Realizar essa verificação primeiro evita processamento desnecessário
2. **Razão para processar a partir da menor carta**: A menor carta só pode pertencer a um grupo consecutivo que começa com ela mesma. Por exemplo, se o menor valor for 3 e `groupSize` for 3, essa carta necessariamente pertence ao grupo [3, 4, 5]. Portanto, a estratégia gulosa de processar a partir do menor valor é correta
3. **Necessidade de gerenciar a contagem de ocorrências de cada carta**: Como podem existir múltiplas cartas com o mesmo valor, é necessária uma estrutura de dados que registre a contagem de ocorrências (frequência) de cada valor. Além disso, como queremos obter o menor valor de forma eficiente, um TreeMap com chaves ordenadas é adequado
4. **Procedimento de construção dos grupos**: Obtemos a menor chave `first` do TreeMap e verificamos se todos os valores consecutivos de `first` até `first + groupSize - 1` existem no TreeMap. Se existirem, decrementamos a frequência de cada valor em 1, e removemos do TreeMap os valores cuja frequência chegar a 0
5. **Quando um valor consecutivo está ausente**: Se durante a construção de um grupo um valor necessário não existir no TreeMap, determinamos nesse ponto que a divisão é impossível e retornamos `false`
6. **Sucesso ao processar todas as cartas**: Repetimos a construção de grupos até o TreeMap ficar vazio; se todos os grupos forem construídos com sucesso, retornamos `true`

## Conhecimentos Prévios

### O que é TreeMap

É uma estrutura de dados Map cujas chaves são sempre mantidas em ordem. Assim como HashMap, armazena pares de chave e valor, mas permite operações baseadas na ordem das chaves (como obter a menor chave) em O(log n). Internamente é implementado como uma árvore rubro-negra (árvore binária de busca autobalanceada).

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();  // Cria um TreeMap vazio
tm.put(5, 2);           // Armazena o valor 2 na chave 5
tm.put(3, 1);           // Armazena o valor 1 na chave 3
tm.firstKey();           // Retorna a menor chave → 3
tm.containsKey(5);       // Retorna boolean indicando se a chave 5 existe → true
tm.get(5);               // Retorna o valor correspondente à chave 5 → 2
tm.remove(3);            // Remove a chave 3 e seu valor
```

### O que é getOrDefault

É um método que, ao obter um valor de um Map, retorna um valor padrão especificado caso a chave não exista. Permite omitir a verificação de `null` na contagem de frequências.

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();
tm.getOrDefault(10, 0);  // A chave 10 não existe, então retorna o valor padrão 0 → 0
tm.put(10, 3);
tm.getOrDefault(10, 0);  // A chave 10 existe, então retorna seu valor → 3
```

### O que é o Método Guloso (Greedy)

É uma técnica que busca a solução ótima global fazendo a escolha localmente ótima em cada etapa. Neste problema, a escolha gulosa de "criar grupos sequencialmente a partir da menor carta" conduz à divisão correta como um todo. Como a menor carta não pode ser inserida no meio de outro grupo, a escolha gulosa coincide com a solução ótima.

## Complexidade

| | Valor |
|---|---|
| Tempo | O(n log n) — Inserção e remoção no TreeMap são O(log n) cada, e todas as n cartas são processadas |
| Espaço | O(n) — O TreeMap armazena no máximo n entradas |

## Código

```java
// Entrada: array de inteiros hand (valores das cartas) e inteiro groupSize (tamanho de cada grupo)
// Saída: retorna true se todas as cartas puderem ser divididas em grupos de valores consecutivos, false caso contrário
public boolean isNStraightHand(int[] hand, int groupSize) {
    // Se o número total de cartas não for divisível pelo tamanho do grupo, a divisão uniforme é impossível
    if (hand.length % groupSize != 0)
        return false;

    // TreeMap que armazena chave=valor da carta, valor=quantidade restante (frequência)
    // Razão para usar TreeMap: permite obter o menor valor de carta em O(log n)
    TreeMap<Integer, Integer> tm = new TreeMap<>();
    // Conta as ocorrências de cada carta, usando getOrDefault para adicionar 1 à frequência existente
    for (int card : hand) {
        tm.put(card, tm.getOrDefault(card, 0) + 1);
    }

    // Constrói grupos até o TreeMap ficar vazio (ficar vazio significa que todas as cartas foram divididas)
    while (!tm.isEmpty()) {
        // Obtém o menor valor de carta atual e o define como início do grupo
        // O menor valor não pode ser inserido no meio de outro grupo, portanto necessariamente se torna o início de um novo grupo
        int first = tm.firstKey();

        // Cria um grupo com groupSize valores consecutivos a partir de first
        for (int i = 0; i < groupSize; i++) {
            int cur = first + i;

            // Se o valor consecutivo não existir, o grupo não pode ser formado e a divisão é impossível
            if (!tm.containsKey(cur))
                return false;

            // Se a frequência for 1, esta é a última carta desse valor e é removida; se for 2 ou mais, decrementa a frequência em 1
            if (tm.get(cur) == 1) {
                tm.remove(cur);
            } else {
                tm.put(cur, tm.get(cur) - 1);
            }
        }
    }

    // Todas as cartas foram divididas em grupos consecutivos com sucesso
    return true;
}
```
