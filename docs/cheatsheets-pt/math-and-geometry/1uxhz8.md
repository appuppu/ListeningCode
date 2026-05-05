# Determining if a Number is a Happy Number — Determinar se um número é feliz repetindo a soma dos quadrados de cada dígito

## Essência do Problema

Dado um inteiro positivo `n`, repete-se a operação de elevar ao quadrado cada dígito de `n` e somar os resultados. Se o resultado alcançar **1**, o número é um "número feliz" e retorna-se `true`. Se nunca alcançar 1 e entrar em um loop infinito, retorna-se `false`.

## Ideia Central

A operação de repetir a soma dos quadrados dos dígitos sempre circula dentro de um conjunto finito de valores. Essa estrutura é idêntica à detecção de ciclos em uma lista encadeada. Utilizando o ponteiro lento e o ponteiro rápido de Floyd, é possível determinar a existência de um ciclo e o ponto de chegada sem memória adicional.

## Processo de Raciocínio

1. **A repetição da operação sempre gera um loop**: Ao repetir a operação de calcular a soma dos quadrados dos dígitos, os valores ficam confinados a um intervalo finito, portanto eventualmente um valor já obtido será alcançado novamente. Ou seja, a sequência sempre entra em um "loop que para em 1" ou em um "loop que não contém 1"
2. **A detecção de loop se reduz a um problema de detecção de ciclo**: Se considerarmos a transição de cada valor para o próximo como um "link de nó para nó", este problema possui a mesma estrutura que detectar se uma lista encadeada contém um ciclo
3. **Detecção em espaço O(1) com o método dos dois ponteiros de Floyd**: O ponteiro lento avança 1 passo por vez, e o ponteiro rápido avança 2 passos por vez. Se existir um ciclo, os dois ponteiros obrigatoriamente se encontram em algum ponto dentro do ciclo
4. **Determinação do resultado pelo valor no ponto de encontro**: Quando os dois ponteiros se encontram, se o valor for 1, o número é feliz (a soma dos quadrados dos dígitos de 1 é 1, portanto 1 forma um ciclo consigo mesmo). Se o encontro ocorrer em um valor diferente de 1, significa que a sequência entrou em um ciclo que não contém 1, logo o número não é feliz
5. **Configuração dos valores iniciais**: O ponteiro lento é definido como `n` e o ponteiro rápido como `getNext(n)`. Dessa forma, o loop `while (slow != fast)` inicia naturalmente

## Conhecimentos Prévios

### Cálculo da soma dos quadrados de cada dígito

Para extrair cada dígito de um inteiro `n`, obtém-se o dígito menos significativo com `n % 10` e remove-se esse dígito com `n /= 10`, repetindo a operação até que `n` se torne 0.

```java
int n = 19;
int digit = n % 10;   // Obtém o dígito menos significativo → 9
n /= 10;              // Remove o dígito menos significativo → n se torna 1
digit = n % 10;       // Obtém o próximo dígito → 1
// 19 → 1² + 9² = 1 + 81 = 82
```

### O que é o método de detecção de ciclo de Floyd (método dos dois ponteiros)

É um algoritmo que detecta se uma lista encadeada ou uma sequência contém um ciclo (loop). O ponteiro lento avança 1 passo por vez e o ponteiro rápido avança 2 passos por vez. Se existir um ciclo, o ponteiro rápido alcança o ponteiro lento e os dois obrigatoriamente se encontram. Como não utiliza estruturas de dados adicionais, a complexidade espacial é O(1).

```java
int slow = start;                // O ponteiro lento avança 1 passo por vez
int fast = getNext(start);       // O ponteiro rápido inicia uma posição à frente
while (slow != fast) {
    slow = getNext(slow);        // Avança 1 passo
    fast = getNext(getNext(fast)); // Avança 2 passos
}
// Ao término do loop, slow == fast é o valor no ponto de encontro
```

## Complexidade

| | Valor |
|---|---|
| Time | O(log n) — O cálculo da soma dos quadrados dos dígitos custa O(log n), e o número de iterações até alcançar o ciclo é limitado por uma constante |
| Space | O(1) — Utiliza apenas duas variáveis: o ponteiro lento e o ponteiro rápido |

## Código

```java
// Entrada: inteiro positivo n
// Saída: retorna true se n for um número feliz, caso contrário retorna false

// Função auxiliar que calcula e retorna a soma dos quadrados de cada dígito do inteiro n
// Extrai o dígito menos significativo com n % 10, acumula o quadrado, e remove o dígito com n /= 10
private int getNext(int n) {
    int sum = 0;
    while (n > 0) {
        int digit = n % 10;   // Extrai o dígito menos significativo
        sum += digit * digit;  // Adiciona o quadrado do dígito a sum
        n /= 10;               // Remove o dígito menos significativo
    }
    return sum;
}

public boolean isHappy(int n) {
    // O ponteiro lento inicia em n, e o ponteiro rápido inicia um passo à frente em getNext(n)
    // Ao iniciar fast uma posição à frente, o loop while (slow != fast) começa naturalmente
    int slow = n;
    int fast = getNext(n);

    // Repete o loop até que os dois ponteiros se encontrem
    // Devido à diferença de velocidade entre o lento e o rápido, se existir um ciclo, o encontro é garantido
    while (slow != fast) {
        slow = getNext(slow);           // O ponteiro lento avança 1 passo
        fast = getNext(getNext(fast));   // O ponteiro rápido avança 2 passos
    }

    // Se o ponto de encontro for 1, o número é feliz (a soma dos quadrados dos dígitos de 1 é 1, formando um ciclo consigo mesmo)
    // Se o encontro ocorrer em um valor diferente de 1, a sequência entrou em um ciclo sem 1, logo não é um número feliz
    return fast == 1;
}
```
