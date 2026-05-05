# Finding the Number That Appears Only Once — Encontrar o elemento que aparece apenas uma vez em um array

## Essência do Problema

Um array de inteiros `nums` é fornecido. Todos os elementos no array aparecem exatamente 2 vezes, mas apenas um elemento aparece somente 1 vez. O objetivo é retornar esse **elemento que aparece apenas uma vez**.

## Ideia Central

A operação XOR possui a propriedade de que "aplicar XOR com o mesmo valor duas vezes resulta em 0". Ao aplicar XOR em todos os elementos do array, os elementos que aparecem 2 vezes se cancelam e se tornam 0, restando apenas o elemento que aparece somente uma vez.

## Processo de Raciocínio

1. **Se os pares duplicados puderem ser eliminados, a resposta permanece**: Se todos os elementos que aparecem 2 vezes no array forem removidos, o elemento que aparece apenas 1 vez será obtido. O objetivo é encontrar uma operação que realize essa "eliminação de pares" de forma eficiente
2. **Utilizar a propriedade de autoinversão do XOR**: A operação XOR possui a propriedade `a ^ a = 0`. Aplicar XOR com o mesmo valor duas vezes resulta em 0. Ou seja, os elementos que aparecem 2 vezes são automaticamente eliminados
3. **Utilizar o elemento neutro e a lei associativa do XOR**: `a ^ 0 = a` (XOR com 0 não altera o valor) e o XOR satisfaz as leis associativa e comutativa. Portanto, independentemente da ordem de aparição dos elementos, ao aplicar XOR em todos os elementos, os pares desaparecem e apenas o elemento único permanece
4. **Calcular o XOR acumulado com uma única variável**: A variável `result` é inicializada com 0, e durante a iteração do array, cada elemento é submetido à operação XOR. Ao final da iteração, o valor que permanece em `result` é a resposta
5. **Nenhuma estrutura de dados adicional é necessária**: Como o problema pode ser resolvido com apenas uma variável inteira, sem usar HashSet ou HashMap, a complexidade de espaço é O(1)

## Conhecimentos Prévios

### O que é XOR (ou exclusivo)

Uma operação bit a bit que retorna 1 quando dois bits são diferentes e 0 quando são iguais. Em Java, é representada pelo operador `^`. Quando aplicada a inteiros, o XOR é aplicado em cada posição de bit individualmente.

```java
int a = 5;          // binário: 101
int b = 3;          // binário: 011
int c = a ^ b;      // binário: 110 → 6
```

### Propriedades importantes do XOR

A operação XOR possui as 3 propriedades a seguir, todas necessárias para resolver este problema.

```java
// 1. Autoinversão: aplicar XOR com o mesmo valor duas vezes resulta em 0
a ^ a;    // → 0

// 2. Elemento neutro: XOR com 0 não altera o valor original
a ^ 0;    // → a

// 3. Leis comutativa e associativa: o resultado é o mesmo independentemente da ordem
a ^ b ^ a;    // → (a ^ a) ^ b → 0 ^ b → b
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer o array uma única vez |
| Space | O(1) — Não utiliza estruturas de dados adicionais, apenas uma variável inteira |

## Código

```java
// Entrada: array de inteiros nums (todos os elementos aparecem 2 vezes, e apenas um elemento aparece 1 vez)
// Saída: retorna o elemento que aparece apenas uma vez como int
public int singleNumber(int[] nums) {
    // Valor inicial do XOR acumulado. 0 é o elemento neutro do XOR, portanto XOR com qualquer valor não altera esse valor
    int result = 0;

    // O loop for-each percorre cada elemento do array do início ao fim, um por um
    for (int num : nums) {
        // Calcula o XOR entre o result atual e num, e atribui o resultado a result
        // Os elementos que aparecem 2 vezes se cancelam por a ^ a = 0, e apenas o elemento que aparece uma vez é acumulado
        result ^= num;
    }

    // Após o término do loop, como todos os pares foram cancelados, apenas o valor do elemento que aparece uma única vez permanece
    return result;
}
```
