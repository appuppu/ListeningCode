# Finding the Duplicate in an Array of N Plus One Integers — Encontrar o número duplicado em um array de N+1 inteiros

## Essência do Problema

É dado um array de inteiros `nums` com comprimento n+1. Cada elemento está no intervalo de 1 a n, e existe exatamente um número duplicado. O objetivo é encontrar e retornar esse número duplicado sem modificar o array e usando apenas espaço adicional constante.

## Ideia Central

Se interpretarmos a relação de mover do índice `i` para `nums[i]` como uma "lista ligada", os links convergem no ponto onde o número duplicado existe, gerando um ciclo (loop). Usando o Floyd's Cycle Detection (algoritmo da tartaruga e da lebre), é possível identificar a entrada do ciclo — que é o número duplicado — com espaço O(1).

## Processo de Raciocínio

1. **Interpretar o array como uma lista ligada implícita**: O valor `nums[i]` no índice `i` é tratado como um "ponteiro para o próximo nó". Partindo do índice 0 e seguindo `nums[0]` → `nums[nums[0]]` → …, o comportamento é idêntico à travessia de uma lista ligada. Como os valores estão no intervalo 1~n, nunca se retorna ao índice 0, e sempre se aponta para um índice válido
2. **Entender por que a duplicação gera um ciclo**: Quando dois índices diferentes possuem o mesmo valor, existem duas setas apontando para o índice desse valor. Na lista ligada, isso significa que dois nós apontam para o mesmo nó, e o ciclo começa a partir desse ponto de convergência. A entrada do ciclo é exatamente o número duplicado
3. **Detectar a existência do ciclo**: O ponteiro slow avança 1 passo por vez (`slow = nums[slow]`), e o ponteiro fast avança 2 passos por vez (`fast = nums[nums[fast]]`). Se um ciclo existir, slow e fast obrigatoriamente se encontrarão em algum ponto dentro do ciclo
4. **Identificar a entrada do ciclo**: Após o encontro, slow retorna ao ponto de partida (`nums[0]`), e fast permanece na posição atual. Ambos avançam 1 passo por vez, e se encontrarão novamente na entrada do ciclo. O valor correspondente ao índice dessa entrada é o número duplicado
5. **Por que o encontro ocorre na entrada**: Está matematicamente provado que a distância do início até a entrada do ciclo é igual à distância do ponto de encontro até a entrada do ciclo. Por isso, ao avançar ambos na mesma velocidade, eles coincidem na entrada

## Conhecimentos Prévios

### O que é uma Lista Ligada Implícita (Implicit Linked List)

Sem criar objetos de nó reais, é possível representar a mesma estrutura de uma lista ligada interpretando os valores do array como "ponteiros para o próximo índice". O "próximo nó" do nó no índice `i` é o nó no índice `nums[i]`.

```java
// Travessia da lista ligada para o array nums = [1, 3, 4, 2, 2]
int current = nums[0];       // Valor no índice 0 → 1 (próximo é o índice 1)
current = nums[current];     // Valor no índice 1 → 3 (próximo é o índice 3)
current = nums[current];     // Valor no índice 3 → 2 (próximo é o índice 2)
current = nums[current];     // Valor no índice 2 → 4 (próximo é o índice 4)
current = nums[current];     // Valor no índice 4 → 2 (retorna ao índice 2 → ciclo)
```

### O que é o Floyd's Cycle Detection (Detecção de Ciclo de Floyd)

É um algoritmo que detecta um ciclo em uma lista ligada e identifica sua entrada. Utiliza dois ponteiros (slow: 1 passo por vez, fast: 2 passos por vez). Se houver um ciclo, ambos obrigatoriamente se encontrarão, e através do procedimento subsequente é possível identificar a entrada do ciclo.

```java
// Fase 1: Encontro dentro do ciclo
slow = nums[slow];           // slow avança 1 passo
fast = nums[nums[fast]];     // fast avança 2 passos

// Fase 2: Identificação da entrada do ciclo
slow = nums[slow];           // Ambos avançam 1 passo por vez
fast = nums[fast];           // O ponto de encontro é a entrada do ciclo
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Cada ponteiro percorre no máximo 2 voltas na travessia da lista ligada |
| Space | O(1) — Utiliza apenas duas variáveis: slow e fast |

## Código

```java
// Entrada: array de inteiros nums com comprimento n+1 (cada elemento entre 1 e n, com exatamente uma duplicação)
// Saída: retorna o número duplicado como int
public int findDuplicate(int[] nums) {
    // Inicializa slow e fast no início da lista ligada (nums[0])
    // O índice 0 não está incluído no intervalo de valores (1~n), portanto não faz parte do ciclo e é um ponto de partida seguro
    int slow = nums[0];
    int fast = nums[0];

    // Fase 1: slow avança 1 passo, fast avança 2 passos, repetindo até se encontrarem dentro do ciclo
    // Usa do-while porque os valores iniciais são iguais e é necessário pular a primeira comparação
    do {
        slow = nums[slow];           // Avança slow em 1 passo
        fast = nums[nums[fast]];     // Avança fast em 2 passos (se houver ciclo, obrigatoriamente alcança slow)
    } while (slow != fast);

    // Fase 2: Retorna slow ao ponto de partida e ambos avançam 1 passo por vez
    // Utiliza a propriedade de que a distância do início até a entrada = distância do ponto de encontro até a entrada
    slow = nums[0];
    while (slow != fast) {
        slow = nums[slow];           // Ambos avançam 1 passo por vez
        fast = nums[fast];           // Obrigatoriamente coincidem na entrada do ciclo
    }

    // Entrada do ciclo = número apontado por dois índices diferentes = retorna o número duplicado
    return slow;
}
```
