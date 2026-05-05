# Counting the Number of Set Bits — Contar o número de bits 1 na representação binária de um inteiro

## Essência do problema

Dado um inteiro não negativo `n`, retornar o número de bits com valor 1 (peso de Hamming) na representação binária de `n`.

## Ideia central

A operação `n & (n - 1)` elimina apenas o bit 1 menos significativo de `n`. Repetindo essa operação até que `n` se torne 0, o número de repetições será exatamente o número de bits 1.

## Processo de raciocínio

1. **Contar apenas os bits 1 de forma eficiente**: Em vez de percorrer todos os 32 bits, se for possível processar apenas as posições onde existem bits 1, o tempo será proporcional ao número de bits 1, `k`
2. **Pensar em como eliminar o bit 1 menos significativo**: Ao calcular `n - 1`, o bit 1 menos significativo de `n` se torna 0, e todos os bits abaixo dele são invertidos para 1. Por exemplo, quando `n = 1100`, `n - 1 = 1011`
3. **n AND (n - 1) elimina apenas o bit 1 menos significativo**: Ao fazer o AND de `n` com `n - 1`, todas as posições do bit 1 menos significativo para baixo se tornam 0, e os bits acima permanecem inalterados. `1100 & 1011 = 1000`, e o bit 1 menos significativo foi eliminado
4. **Repetir a operação de eliminação e contar**: Aplicando repetidamente `n &= (n - 1)` e contando o número de vezes até que `n` se torne 0, esse número será a quantidade de bits 1 contidos no `n` original
5. **Condição de término do loop**: Quando todos os bits 1 forem eliminados, `n` se torna 0. Usando `n != 0` como condição do loop, o loop executará exatamente o número de vezes igual à quantidade de bits 1 e terminará naturalmente

## Conhecimentos prévios

### O que é a operação AND bit a bit (&)

Uma operação que compara cada bit de dois inteiros e resulta em 1 apenas quando ambos os bits são 1. Para todas as outras combinações, o resultado é 0.

```java
int a = 0b1100;       // 1100 em binário
int b = 0b1010;       // 1010 em binário
int result = a & b;   // O resultado é 0b1000 (apenas as posições onde ambos são 1 resultam em 1)
```

### Funcionamento de n & (n - 1)

Ao subtrair 1 de `n`, o bit 1 menos significativo se torna 0, e todos os bits abaixo dele são invertidos para 1. Ao fazer o AND com `n`, todas as posições do bit 1 menos significativo para baixo se tornam 0.

```java
int n = 0b1100;       // n     = 1100 (2 bits 1)
n &= (n - 1);        // n - 1 = 1011, n = 1100 & 1011 = 1000 (reduzido para 1 bit 1)
n &= (n - 1);        // n - 1 = 0111, n = 1000 & 0111 = 0000 (reduzido para 0 bits 1)
```

### O que é o peso de Hamming (Hamming Weight)

O número de bits 1 contidos na representação binária de um inteiro. Por exemplo, a representação binária de `11` é `1011`, portanto o peso de Hamming é 3.

## Complexidade

| | Valor |
|---|---|
| Time | O(k) — k é o número de bits 1 contidos em `n`. O loop é executado exatamente k vezes |
| Space | O(1) — Utiliza apenas uma variável contadora |

## Código

```java
// Entrada: inteiro não negativo n
// Saída: retorna como int o número de bits 1 na representação binária de n
public int hammingWeight(int n) {
    // Contador que registra o número de vezes que um bit 1 foi eliminado. O total de eliminações será a resposta final
    int count = 0;

    // Se n for 0, não restam bits 1, então o loop é encerrado
    while (n != 0) {
        // Elimina o bit 1 menos significativo (Brian Kernighan's Trick)
        // n - 1 inverte os bits do bit 1 menos significativo para baixo, e o AND com n zera todas essas posições
        n &= (n - 1);
        // Um bit 1 foi eliminado, então registra a eliminação no contador
        count++;
    }
    // count contém o total de eliminações de bits 1, ou seja, o número de bits 1 contidos no n original
    return count;
}
```
