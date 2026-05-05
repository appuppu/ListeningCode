# Adding One to a Number Represented as an Array — Somar um a um número representado como array

## Essência do problema

Um array `digits` armazena um inteiro não negativo, com um dígito por elemento. O primeiro elemento do array é o dígito mais significativo e o último é o dígito menos significativo. O objetivo é somar 1 a esse número e retornar o resultado no mesmo formato de array. Cada elemento é um dígito de 0 a 9.

## Ideia central

Somamos 1 a partir do último dígito e retornamos imediatamente quando não ocorre carry. O carry só ocorre quando o dígito atual é 9, e o comprimento do array aumenta em 1 apenas quando todos os dígitos são 9.

## Processo de raciocínio

1. **A soma começa pelo dígito menos significativo**: Como a adição numérica naturalmente começa pela casa das unidades, percorremos o array em ordem reversa, do final para o início
2. **Considerar a condição de parada do carry**: Se o dígito atual for menor que 9, somar 1 não gera carry. Nesse ponto a adição está completa e podemos retornar o array imediatamente
3. **Considerar o tratamento quando o dígito é 9**: Quando o dígito atual é 9, somar 1 resulta em 10 e ocorre carry. Definimos esse dígito como 0 e propagamos o carry para o dígito superior. Na próxima iteração do loop, a soma de 1 ao dígito superior ocorre naturalmente
4. **Considerar o caso em que todos os dígitos são 9**: Em casos como 999, onde todos os dígitos são 9, o carry não para mesmo após o loop percorrer todos os elementos. O resultado será como 1000, com o número de dígitos aumentando em 1. Apenas neste caso criamos um novo array e definimos 1 na primeira posição. Como `new int[]` em Java inicializa todos os elementos com 0, não é necessário atribuir 0 aos dígitos restantes
5. **Não é necessário gerenciar o carry com uma variável**: O valor do carry é sempre 1, e enquanto o loop continua é certo que existe carry. Portanto, a própria continuação do loop significa a existência do carry, eliminando a necessidade de uma variável carry

## Conhecimentos prévios

### Percorrer array em ordem reversa

Percorremos o array do final para o início. Começamos com `i = n - 1` e decrementamos com `i--` enquanto `i >= 0`.

```java
int[] digits = {1, 2, 3};
int n = digits.length;                  // Obtém o comprimento do array → 3
for (int i = n - 1; i >= 0; i--) {      // Loop na ordem i=2, 1, 0
    System.out.println(digits[i]);      // Imprime na ordem 3, 2, 1
}
```

### Inicialização de arrays em Java

Ao criar um array de inteiros com comprimento n usando `new int[n]`, todos os elementos são automaticamente inicializados com 0. Não é necessário atribuir 0 explicitamente.

```java
int[] result = new int[4];   // Inicializado como {0, 0, 0, 0}
result[0] = 1;               // Torna-se {1, 0, 0, 0}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Percorre o array do final ao início no máximo uma vez |
| Space | O(1) — Exceto quando todos os dígitos são 9, modifica o array de entrada in-place sem memória adicional |

## Código

```java
// Entrada: array de inteiros digits contendo cada dígito de um inteiro não negativo
// Saída: retorna um int[] contendo o resultado da soma de 1 ao número representado por digits
public int[] plusOne(int[] digits) {
    // Armazena o comprimento do array. Usado como limite do loop reverso e como comprimento do novo array quando todos os dígitos são 9
    int n = digits.length;

    // Percorre do final para o início. A própria continuação do loop significa que "existe carry"
    for (int i = n - 1; i >= 0; i--) {
        // Se o dígito atual for menor que 9, não ocorre carry. Soma e retorna imediatamente
        if (digits[i] < 9) {
            digits[i]++;
            return digits;  // Sem carry. Retorna o array modificado e encerra
        }
        // O dígito atual é 9, então define como 0 e propaga o carry para o dígito superior
        digits[i] = 0;
    }

    // Todos os dígitos eram 9 (ex: [9,9,9] → [0,0,0]), o número de dígitos aumenta em 1
    // new int[] inicializa todos os elementos com 0, então não é necessário atribuir 0 aos dígitos restantes
    int[] result = new int[n + 1];
    result[0] = 1;  // Define 1 na primeira posição (ex: 999 + 1 = 1000 → [1, 0, 0, 0])
    return result;
}
```
