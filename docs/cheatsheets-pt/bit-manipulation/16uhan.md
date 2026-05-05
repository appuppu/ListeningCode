# Counting Bits for Every Number Up to N — Retornar um array com o número de bits 1 contidos em cada inteiro de 0 até N

## Essência do problema

Um inteiro não negativo `n` é fornecido. Retorne um array de comprimento `n + 1`. O elemento no índice `i` do array armazena o **número de bits 1** quando `i` é representado em binário. Exemplo: quando n=5, temos 0→0, 1→1, 2→1, 3→2, 4→1, 5→2, portanto retornamos `[0,1,1,2,1,2]`.

## Ideia central

O número de bits 1 de qualquer inteiro `i` é igual ao número de bits 1 do valor `i >> 1` (obtido deslocando `i` um bit para a direita) somado ao bit menos significativo de `i` (`i & 1`). Essa relação recursiva permite reutilizar os resultados de valores menores e calcular cada valor em O(1).

## Processo de raciocínio

1. **Observar a estrutura binária**: Quando deslocamos a representação binária de um inteiro `i` um bit para a direita, o bit menos significativo é removido e a sequência de bits restante é igual a `i / 2` (com truncamento). Ou seja, a sequência de bits de `i` tem a estrutura "sequência de bits de `i >> 1`" + "1 bit menos significativo"
2. **Decompor o número de bits 1**: A partir da estrutura acima, o número de 1s contidos em `i` pode ser decomposto em "número de 1s contidos em `i >> 1`" + "se o bit menos significativo é 1 ou não (0 ou 1)". Expressando isso como fórmula, obtemos `countBits(i) = countBits(i >> 1) + (i & 1)`
3. **Calcular em ordem crescente permite reutilização**: Como `i >> 1` é sempre um valor menor que `i`, se calcularmos em ordem a partir de `i = 0`, `result[i >> 1]` já estará calculado. Essa propriedade permite preencher os valores sequencialmente com um laço, sem necessidade de recursão
4. **O próprio array de resultado serve como tabela DP**: Utilizamos o array de retorno `result` diretamente como tabela DP. Com `result[0] = 0` como caso base, preenchemos de `i = 1` até `n` usando `result[i] = result[i >> 1] + (i & 1)`. Nenhuma estrutura de dados adicional é necessária

## Conhecimentos prévios

### O que é a operação de deslocamento à direita (`>>`)

Uma operação que desloca a representação binária de um inteiro para a direita pelo número especificado de bits. Ao deslocar um bit para a direita, o bit menos significativo é removido e o valor se torna o quociente da divisão por 2 (com truncamento).

```java
int a = 6;      // binário: 110
int b = a >> 1;  // binário: 011 → valor é 3 (6 ÷ 2 = 3)

int c = 7;      // binário: 111
int d = c >> 1;  // binário: 011 → valor é 3 (7 ÷ 2 = 3, com truncamento)
```

### O que é a operação AND bit a bit (`&`)

Uma operação que compara cada bit de dois inteiros e define como 1 apenas os bits que são 1 em ambos. `i & 1` é a operação que extrai apenas o bit menos significativo de `i`, retornando 1 se `i` é ímpar e 0 se `i` é par.

```java
int a = 5;       // binário: 101
int b = a & 1;   // binário: 001 → valor é 1 (ímpar, então o bit menos significativo é 1)

int c = 4;       // binário: 100
int d = c & 1;   // binário: 000 → valor é 0 (par, então o bit menos significativo é 0)
```

### O que é Programação Dinâmica (DP)

Uma técnica que divide um problema grande em subproblemas menores, registrando os resultados dos subproblemas em um array para reutilização. Neste problema, utilizamos `result[i >> 1]` (resultado já calculado de um valor menor) para obter `result[i]` em O(1).

```java
int[] result = new int[n + 1];  // Criar array que serve como tabela DP e resultado
result[0] = 0;                  // Caso base: o número de bits 1 de 0 é 0
result[i] = result[i >> 1] + (i & 1);  // Fórmula de transição: reutilizar resultado já conhecido
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Para cada valor de 1 até n, basta realizar uma operação de deslocamento de bits e uma operação AND, cada uma apenas uma vez |
| Space | O(n) — Utiliza um array de comprimento n+1 para armazenar o resultado (como é a própria saída, o espaço adicional também pode ser interpretado como O(1)) |

## Código

```java
// Entrada: inteiro não negativo n
// Saída: int[] de comprimento n+1. Cada result[i] armazena o número de bits 1 contidos na representação binária de i
public int[] countBits(int n) {
    // Criar array que serve como tabela DP e resultado. new int[n+1] inicializa todos os elementos com 0,
    // portanto result[0] = 0 (o número de bits 1 de 0 é 0) já está automaticamente satisfeito
    int[] result = new int[n + 1];

    // Como i=0 já está corretamente com 0, iniciamos a iteração a partir de i=1
    for (int i = 1; i <= n; i++) {
        // result[i >> 1]: número de bits 1 do valor obtido deslocando i um bit à direita (i >> 1 é sempre menor que i, portanto já foi calculado)
        // i & 1: bit menos significativo de i (1 se ímpar, 0 se par)
        // A soma desses dois valores resulta no número total de 1s contidos na representação binária de i
        result[i] = result[i >> 1] + (i & 1);
    }
    // Retorna o array com cada elemento result[i] armazenando o número de bits 1 do índice i
    return result;
}
```
