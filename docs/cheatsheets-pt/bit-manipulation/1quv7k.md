# Adding Two Numbers Without the Plus Operator — Calcular a soma de dois inteiros sem usar o operador de adição

## Essência do problema

Dois inteiros `a` e `b` são fornecidos. O objetivo é calcular e retornar a soma dos dois inteiros usando **apenas operações de bits**, sem utilizar os operadores `+` ou `-`.

## Ideia central

A adição em binário pode ser decomposta em dois componentes: "a soma de cada dígito sem carry (XOR)" e "o carry (AND com deslocamento à esquerda)". Repetindo essa decomposição até que o carry se torne zero, obtemos a soma final.

## Processo de raciocínio

1. **Pensar na essência da adição em nível de bits**: A adição de cada dígito em binário, ignorando o carry, resulta em 1 quando apenas um dos bits é 1. Isso corresponde exatamente à operação XOR (`a ^ b`)
2. **Calcular o carry separadamente**: O carry ocorre quando ambos os dígitos são 1. Isso é obtido pela operação AND (`a & b`). Como o carry afeta o próximo dígito, deslocamos o resultado 1 bit para a esquerda (`(a & b) << 1`)
3. **É necessário adicionar o carry à soma**: Somando o resultado do XOR com o carry, obtemos a soma final, mas não podemos usar `+`. No entanto, como isso se reduz ao mesmo problema de "somar dois números", podemos aplicar o mesmo processo recursivamente
4. **Definir a condição de término da recursão**: Quando o carry `b` se torna zero, não há mais valor a ser adicionado, portanto o valor de `a` nesse momento é a soma final. Este é o caso base
5. **A terminação é garantida porque o número de bits é finito**: O deslocamento à esquerda move os bits do carry para posições superiores a cada iteração, e em inteiros de 32 bits, o carry se torna zero em no máximo 32 recursões

## Conhecimentos prévios

### O que é a operação XOR (ou exclusivo)

É uma operação de bits que retorna 1 quando os dois bits são diferentes e 0 quando são iguais. O resultado é idêntico ao da adição ignorando o carry.

```java
int result = 5 ^ 3;   // 0101 ^ 0011 = 0110 → 6
int result2 = 7 ^ 7;  // 0111 ^ 0111 = 0000 → 0 (XOR de valores iguais é 0)
```

### O que é a operação AND

É uma operação de bits que retorna 1 apenas quando ambos os bits são 1. É utilizada para identificar os dígitos onde ocorre carry.

```java
int result = 5 & 3;   // 0101 & 0011 = 0001 → 1
int result2 = 6 & 3;  // 0110 & 0011 = 0010 → 2
```

### O que é o deslocamento à esquerda

É uma operação que desloca a sequência de bits para a esquerda pelo número especificado de posições, preenchendo os bits vagos à direita com 0. Um deslocamento de 1 bit à esquerda tem o efeito de multiplicar o valor por 2. Como o carry afeta o próximo dígito, o deslocamento de 1 bit à esquerda move o carry para a posição correta.

```java
int result = 1 << 1;  // 0001 → 0010 → 2
int result2 = 3 << 1; // 0011 → 0110 → 6
```

### Como funciona a adição em binário

Assim como na adição manual em decimal, cada dígito é somado individualmente e o carry é propagado para o dígito superior.
Exemplo: `5 + 3` (`0101 + 0011`):
- XOR (soma sem carry): `0101 ^ 0011 = 0110` (6)
- AND + deslocamento à esquerda (carry): `(0101 & 0011) << 1 = 0001 << 1 = 0010` (2)
- Somar 6 e 2 pelo mesmo método → `0110 ^ 0010 = 0100` (4), `(0110 & 0010) << 1 = 0100` (4)
- Somar 4 e 4 → `0100 ^ 0100 = 0000` (0), `(0100 & 0100) << 1 = 1000` (8)
- Somar 0 e 8 → `0000 ^ 1000 = 1000` (8), carry é 0 → fim. O resultado é **8**

## Complexidade

| | Valor |
|---|---|
| Time | O(1) — Em inteiros de 32 bits, o deslocamento do carry termina em no máximo 32 iterações, completando em um número constante de recursões |
| Space | O(1) — A profundidade da recursão também é no máximo 32, sendo constante, e nenhuma estrutura de dados adicional é utilizada |

## Código

```java
// Entrada: dois inteiros a e b
// Saída: retorna a soma de a e b como int
public int getSum(int a, int b) {
    // Caso base: se o carry (b) é zero, não há valor a ser adicionado, portanto a é a soma final
    if (b == 0) return a;

    // a ^ b: calcula a soma de cada dígito ignorando o carry (XOR retorna 1 quando os dois bits são diferentes)
    // (a & b) << 1: calcula o carry (AND identifica os dígitos onde ambos são 1, e o deslocamento à esquerda move para a posição do próximo dígito)
    // A cada recursão, os bits do carry se movem para posições superiores, e em inteiros de 32 bits, o carry se torna zero em no máximo 32 iterações
    return getSum(a ^ b, (a & b) << 1);
}
```
