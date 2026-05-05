# Computing Power of a Number Efficiently — Calcular eficientemente a potência de um número de ponto flutuante

## Essência do problema

São dados um número de ponto flutuante `x` e um inteiro `n`. O objetivo é calcular e retornar `x` elevado à `n`-ésima potência. Como `n` pode assumir valores negativos, é necessário lidar com expoentes negativos, e o cálculo deve ser eficiente mesmo quando o valor absoluto de `n` é muito grande.

## Ideia central

Quando o expoente `n` é representado em binário, o cálculo da potência pode ser decomposto na operação de "elevar x ao quadrado repetidamente e multiplicar o resultado apenas quando cada bit de n for 1". Isso reduz n multiplicações para log(n) multiplicações.

## Processo de raciocínio

1. **Converter expoente negativo em expoente positivo**: Como `x^(-n)` é igual a `(1/x)^n`, quando `n` é negativo, basta substituir `x` por `1/x` e inverter o sinal de `n`, unificando o problema para expoentes positivos
2. **n multiplicações são lentas demais**: Multiplicar `x` ingenuamente `n` vezes custa O(n). Quando `n` está na casa dos bilhões, isso não é viável. É necessário um método que reduza o expoente pela metade a cada passo
3. **A potência pode ser decomposta em quadrados repetidos**: Assim como `x^10 = x^8 × x^2`, qualquer potência pode ser decomposta em um produto de potências de 2. Isso corresponde à representação binária do expoente `n`. Como `10` em binário é `1010`, basta multiplicar apenas `x^8` e `x^2`, que correspondem aos dígitos com bit 1
4. **Verificar cada dígito com operações de bits**: Se o bit menos significativo de `n` é 1 pode ser verificado com `(n & 1) == 1`. Se for 1, multiplica-se o resultado pelo valor atual de `x` (que foi elevado ao quadrado correspondente ao dígito atual)
5. **Elevar x ao quadrado repetidamente para avançar os dígitos**: A cada iteração do loop, atualizar `x` para `x * x` faz com que `x` se torne o quadrado, a quarta potência, a oitava potência… do valor original. Simultaneamente, desloca-se `n` um bit para a direita para avançar ao próximo dígito
6. **Condição de término do loop**: Ao deslocar `n` para a direita continuamente, ele eventualmente se torna 0. Executando o loop enquanto `n > 0`, todos os bits são processados

## Conhecimentos prévios

### O que são operações de bits (& e >>)

São operações que tratam inteiros como binários e operam bit a bit. `&` (AND) resulta em 1 apenas quando ambos os bits são 1. `>>` (deslocamento à direita) desloca a sequência de bits para a direita, descartando o bit menos significativo (equivalente a dividir por 2).

```java
int n = 10;           // binário: 1010
n & 1;                // obtém o bit menos significativo → 0 (par)
n >>= 1;              // desloca 1 bit à direita → n é 5 (binário: 101)
n & 1;                // obtém o bit menos significativo → 1 (ímpar)
```

### O que é exponenciação rápida (Fast Exponentiation)

É uma técnica que utiliza a representação binária do expoente para calcular a potência com O(log n) multiplicações. Tomando `x^13` como exemplo, como `13` em binário é `1101`, pode-se decompor em `x^13 = x^8 × x^4 × x^1`. No loop, eleva-se `x` ao quadrado repetidamente (`x → x^2 → x^4 → x^8`) e multiplica-se o resultado apenas quando o bit correspondente é 1.

```java
// Processo de cálculo de x^13 (13 = 1101 em binário)
// Bit 0: 1 → result *= x    (result = x^1),  x = x^2
// Bit 1: 0 → pular,                           x = x^4
// Bit 2: 1 → result *= x^4  (result = x^5),  x = x^8
// Bit 3: 1 → result *= x^8  (result = x^13), x = x^16
```

### Por que é necessário fazer cast para o tipo long

O intervalo do tipo `int` em Java vai de `-2^31` até `2^31 - 1`. Quando `n = -2^31`, `-n` se torna `2^31`, que excede o intervalo do `int` e causa overflow. Fazendo cast para o tipo `long` antes de inverter o sinal, esse problema é evitado.

```java
int n = Integer.MIN_VALUE;   // -2147483648
long power = (long) n;       // -2147483648L (convertido para tipo long)
power = -power;              // 2147483648L (impossível no tipo int, mas seguro no tipo long)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(log n) — pois o loop itera uma vez para cada bit do expoente n |
| Space | O(1) — apenas três variáveis são utilizadas: result, x e power, sem necessidade de pilha de recursão |

## Código

```java
// Entrada: número de ponto flutuante x e inteiro n
// Saída: retorna o valor de x elevado à n-ésima potência como double
double myPow(double x, int n) {
    // Converte para tipo long pois inverter o sinal com int quando n = -2^31 causa overflow
    long power = (long) n;

    // Converte expoente negativo em positivo: x^(-n) = (1/x)^n
    // Esta conversão permite unificar o processamento subsequente apenas com expoentes positivos
    if (power < 0) {
        x = 1 / x;
        power = -power;
    }

    // Inicializa a variável de acumulação do resultado com 1.0
    // Acumula o resultado final multiplicando as potências de x correspondentes aos dígitos com bit 1
    double result = 1.0;

    // Processa todos os bits de power sequencialmente do menos significativo ao mais significativo
    // Ao deslocar power para a direita continuamente, ele eventualmente se torna 0 e o processamento de todos os dígitos é concluído
    while (power > 0) {
        // Verifica com power & 1 se o bit menos significativo (dígito atualmente sendo processado) é 1
        if ((power & 1) == 1) {
            // Se o bit for 1: neste ponto x é o valor original de x elevado ao quadrado tantas vezes quanto os dígitos já processados (x original elevado a 2^k)
            // Multiplica result pela contribuição deste dígito para refletir no resultado
            result *= x;
        }
        // Eleva x ao quadrado para atualizar para o valor de potência correspondente ao próximo dígito (potência com o dobro do expoente)
        x *= x;
        // Desloca power 1 bit à direita para avançar ao próximo dígito (o bit menos significativo é descartado)
        power >>= 1;
    }
    // Retorna o resultado final com as contribuições de todos os bits multiplicadas entre si
    return result;
}
```
