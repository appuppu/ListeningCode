# Counting Ways to Decode a Numeric String — Encontrar o número total de formas de converter uma string numérica em letras do alfabeto

## Essência do Problema

Uma string `s` composta apenas por dígitos é fornecida. Com base na correspondência A=1, B=2, ..., Z=26, o objetivo é retornar quantas formas existem de decodificar a string em uma sequência de letras do alfabeto. Por exemplo, "226" pode ser decodificada de 3 formas: "BZ" (2,26), "VF" (22,6) e "BBF" (2,2,6).

## Ideia Central

O número de formas de decodificação em cada posição é obtido pela soma de "número de formas restantes ao decodificar 1 caractere (1 dígito)" e "número de formas restantes ao decodificar 2 caracteres (2 dígitos)". Como essa dependência se limita apenas aos dois resultados imediatamente anteriores, duas variáveis são suficientes.

## Processo de Raciocínio

1. **Cada posição tem no máximo duas opções**: Ao observar o dígito na posição `i`, existem no máximo duas escolhas: decodificar como 1 dígito (1 a 9) para uma letra, ou decodificar como 2 dígitos (10 a 26) para uma letra. Como essa escolha ocorre recursivamente, é necessário calcular sistematicamente o número de formas de decodificação em cada posição
2. **'0' não pode ser decodificado sozinho**: Não existe letra do alfabeto correspondente a '0'. Se o dígito na posição `i` for '0', a decodificação de 1 dígito a partir dessa posição é impossível, resultando em 0 formas. '0' só pode ser decodificado em combinação com o dígito anterior, como 10 ou 20
3. **Definir a recorrência de DP**: Define-se `dp[i]` como "o número de formas de decodificação da posição `i` até o final". Se o dígito na posição `i` não for '0', soma-se `dp[i+1]`, que representa o restante após a decodificação de 1 dígito. Além disso, se os 2 dígitos nas posições `i` e `i+1` estiverem no intervalo de 10 a 26, soma-se também `dp[i+2]`, que representa o restante após a decodificação de 2 dígitos. Ou seja, `dp[i] = dp[i+1] + dp[i+2]` (condicional)
4. **A dependência é apenas dos dois elementos seguintes**: `dp[i]` depende apenas de `dp[i+1]` e `dp[i+2]`. Portanto, não é necessário manter o array inteiro, bastando duas variáveis (`next1` = `dp[i+1]`, `next2` = `dp[i+2]`) para realizar o cálculo. Isso alcança Space O(1)
5. **Percorrer do final para o início**: Como `dp[i]` depende de `dp[i+1]` e `dp[i+2]`, o lado direito precisa estar definido primeiro. Por isso, o loop percorre a string do final para o início, calculando o número de formas em cada posição
6. **O que retornar no final**: Após a conclusão do loop, `next1` contém `dp[0]` (o número de formas de decodificação da string inteira). Esse valor é retornado

## Conhecimentos Prévios

### O que é Programação Dinâmica (DP)

É uma técnica que divide um problema grande em subproblemas menores e reutiliza os resultados dos subproblemas para obter a resposta do problema inteiro. Para evitar recalcular os mesmos subproblemas várias vezes, os resultados calculados uma vez são armazenados (memoização) ou calculados em ordem (bottom-up).

```java
// Padrão típico de DP bottom-up: sequência de Fibonacci
int prev2 = 0, prev1 = 1;
for (int i = 2; i <= n; i++) {
    int current = prev1 + prev2;  // Calcula o valor atual usando apenas os dois resultados anteriores
    prev2 = prev1;                // Desliza as variáveis para preparar a próxima iteração
    prev1 = current;
}
// prev1 contém o resultado final
```

### O que é Integer.parseInt

É um método que converte uma string em um inteiro. É utilizado para avaliar uma substring como um valor numérico.

```java
Integer.parseInt("26");          // Converte a string "26" no inteiro 26 → 26
Integer.parseInt("09");          // Converte a string "09" no inteiro 9 → 9
```

### O que é String.substring

É um método que obtém uma substring de um intervalo especificado de uma string. Os argumentos são o índice inicial (inclusivo) e o índice final (exclusivo).

```java
String s = "226";
s.substring(0, 2);   // Retorna a substring do índice 0 ao 1 → "22"
s.substring(1, 3);   // Retorna a substring do índice 1 ao 2 → "26"
```

### O que é String.charAt

É um método que retorna o caractere na posição especificada de uma string. Como retorna o tipo char, é possível verificar se é um dígito comparando com o caractere '0'.

```java
String s = "206";
s.charAt(0);          // Retorna o caractere no índice 0 → '2'
s.charAt(1);          // Retorna o caractere no índice 1 → '0'
s.charAt(1) == '0';   // Verifica se o caractere é '0' → true
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer a string uma única vez do final ao início |
| Space | O(1) — O cálculo é feito com apenas duas variáveis (next1, next2), sem utilizar arrays |

## Código

```java
// Entrada: string s composta apenas por dígitos
// Saída: retorna como int o número total de formas de decodificar a string s em uma sequência de letras do alfabeto
public int numDecodings(String s) {
    // next1 = número de formas a partir da posição 1 à direita (dp[i+1]), next2 = número de formas a partir da posição 2 à direita (dp[i+2])
    // A posição à direita do final da string é definida como "formas de decodificar uma string vazia = 1 forma", portanto o valor inicial é 1
    int next1 = 1, next2 = 1;

    // Como dp[i] depende de dp[i+1] e dp[i+2], percorre-se do final ao início para definir o lado direito primeiro
    for (int i = s.length() - 1; i >= 0; i--) {
        int current;

        if (s.charAt(i) == '0') {
            // '0' não corresponde a nenhuma letra sozinho, portanto há 0 formas de decodificação a partir desta posição
            // '0' só pode ser decodificado em combinação com o dígito anterior, como 10 ou 20
            current = 0;
        } else {
            // Decodificação de 1 dígito: o dígito na posição i (1 a 9) como uma letra, e o restante de i+1 em diante tem next1 formas
            current = next1;

            // Verifica se a decodificação de 2 dígitos é possível (se i+1 estiver dentro do intervalo da string, é possível obter 2 dígitos)
            if (i + 1 < s.length()) {
                // Obtém a substring de 2 dígitos com s.substring(i, i+2) e converte em inteiro
                int two = Integer.parseInt(
                    s.substring(i, i + 2));
                // Se os 2 dígitos estiverem no intervalo de 10 a 26, decodifica os 2 dígitos como uma letra e soma next2 formas para o restante de i+2 em diante
                if (two >= 10 && two <= 26)
                    current += next2;
            }
        }

        // Desliza as variáveis uma posição para a esquerda: o current atual se torna next1 (1 posição à direita) na próxima iteração
        next2 = next1;
        next1 = current;
    }

    // Após a conclusão do loop, next1 contém o último current calculado (= dp[0])
    // Este é o número total de formas de decodificação da string inteira
    return next1;
}
```
