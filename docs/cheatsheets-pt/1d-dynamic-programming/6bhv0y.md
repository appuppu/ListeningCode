# Finding the Longest Palindromic Substring — Encontrar a maior substring palindrômica dentro de uma string

## Essência do problema

Uma string `s` é fornecida. O objetivo é encontrar e retornar a **maior substring (palíndromo)** dentro de `s` que seja igual quando lida da esquerda para a direita e da direita para a esquerda. Se existirem múltiplos palíndromos com o mesmo comprimento, basta retornar qualquer um deles.

## Ideia central

Todo palíndromo possui um "centro". Ao expandir para a esquerda e para a direita a partir de cada posição da string como centro, e estender o palíndromo enquanto os caracteres coincidirem, é possível descobrir todos os palíndromos sem omissão. É necessário testar dois tipos de centro: "1 caractere (comprimento ímpar)" e "entre 2 caracteres adjacentes (comprimento par)".

## Processo de raciocínio

1. **Um palíndromo tem uma estrutura simétrica que se expande a partir do centro**: O palíndromo `"racecar"` se expande simetricamente a partir do `e` central como `c→a→r` para ambos os lados. Utilizando essa propriedade, é possível detectar palíndromos fixando o centro e expandindo para a esquerda e para a direita
2. **Existem dois tipos de candidatos a centro**: Palíndromos de comprimento ímpar (exemplo: `"aba"`) têm 1 caractere como centro, e palíndromos de comprimento par (exemplo: `"abba"`) têm o espaço entre 2 caracteres adjacentes como centro. Para detectar todos os palíndromos sem omissão, é necessário testar ambos os tipos de centro
3. **Definir o procedimento de expansão**: Posicionar os ponteiros `left` e `right` a partir do centro, e enquanto `s.charAt(left) == s.charAt(right)`, mover `left` uma posição para a esquerda e `right` uma posição para a direita. A expansão termina quando os caracteres não coincidirem ou quando se atingir a extremidade da string
4. **Calcular o comprimento do palíndromo a partir do resultado da expansão**: No momento em que a expansão termina, `left` e `right` estão uma posição além do limite do palíndromo. Por isso, o comprimento do palíndromo é calculado como `right - left - 1`
5. **Registrar as posições de início e fim do palíndromo mais longo**: Quando o comprimento do palíndromo obtido a partir de cada centro supera o maior comprimento encontrado até o momento, as posições de início `start` e fim `end` são atualizadas. A partir da posição central `i` e do comprimento `len` do palíndromo, o cálculo é `start = i - (len - 1) / 2` e `end = i + len / 2`
6. **Retornar a substring final**: Após testar todos os centros, a maior substring palindrômica é extraída e retornada com `s.substring(start, end + 1)`

## Conhecimentos prévios

### O que é um palíndromo (Palindrome)

Um palíndromo é uma string que é igual quando lida da esquerda para a direita e da direita para a esquerda. `"aba"`, `"abba"` e `"racecar"` são palíndromos. Uma string de um único caractere também é um palíndromo.

### O que é o método de expansão a partir do centro (Expand Around Center)

É uma técnica que fixa o centro de um palíndromo e expande um caractere de cada vez para a esquerda e para a direita, verificando se a sequência é um palíndromo. Como os caracteres são comparados do centro para fora, a detecção de palíndromos é realizada de forma eficiente.

```java
// Se left=right, detecta um palíndromo de comprimento ímpar (centro de 1 caractere)
// Se left=i, right=i+1, detecta um palíndromo de comprimento par (centro de 2 caracteres)
expand(s, 2, 2);    // Procura um palíndromo de comprimento ímpar com centro no índice 2
expand(s, 2, 3);    // Procura um palíndromo de comprimento par com centro entre os índices 2 e 3
```

### O que é String.substring(int, int)

É um método que extrai uma substring de uma string. O primeiro argumento é o índice de início (inclusivo) e o segundo argumento é o índice de fim (exclusivo).

```java
String s = "babad";
s.substring(0, 3);   // Retorna "bab" (caracteres nos índices 0, 1, 2)
s.substring(1, 4);   // Retorna "aba" (caracteres nos índices 1, 2, 3)
```

### O que é String.charAt(int)

É um método que retorna o caractere no índice especificado de uma string.

```java
String s = "babad";
s.charAt(0);   // Retorna 'b'
s.charAt(2);   // Retorna 'b'
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n²) — Para cada índice como centro, realiza-se uma expansão de no máximo O(n), e existem n centros |
| Space | O(1) — Utiliza apenas variáveis para registrar ponteiros e comprimentos, sem necessidade de estruturas de dados adicionais |

## Código

```java
// Entrada: string s
// Saída: retorna a maior substring palindrômica de s como String

// Método auxiliar que expande a partir do centro para a esquerda e para a direita e retorna o comprimento do palíndromo
private int expand(String s, int left, int right) {
    // Continua a expansão enquanto os caracteres esquerdo e direito coincidirem e estiverem dentro dos limites da string
    while (left >= 0
            && right < s.length()
            && s.charAt(left)
            == s.charAt(right)) {
        left--;  // Expande uma posição para a esquerda
        right++; // Expande uma posição para a direita
    }
    // Ao terminar a expansão, left e right estão uma posição além dos limites do palíndromo
    // Por isso, o comprimento do palíndromo é calculado como right - left - 1
    return right - left - 1;
}

public String longestPalindrome(String s) {
    // Variáveis para registrar os índices de início e fim do palíndromo mais longo
    // O valor inicial 0 corresponde ao fato de que, no mínimo, o primeiro caractere é um palíndromo de comprimento 1
    int start = 0, end = 0;

    // Percorre cada índice i como candidato a centro do palíndromo
    for (int i = 0; i < s.length(); i++) {
        // Expande o palíndromo de comprimento ímpar (centro de 1 caractere) e obtém o comprimento
        int odd = expand(s, i, i);
        // Expande o palíndromo de comprimento par (centro de 2 caracteres) e obtém o comprimento
        int even = expand(s, i, i + 1);
        // Adota o maior entre o comprimento ímpar e o comprimento par
        int len = Math.max(odd, even);

        // Se o comprimento atual exceder o comprimento do palíndromo mais longo (end - start + 1), atualiza as posições de início e fim
        if (len > end - start + 1) {
            // (len - 1) / 2 é a distância do centro até o lado esquerdo
            start = i - (len - 1) / 2;
            // len / 2 é a distância do centro até o lado direito
            end = i + len / 2;
        }
    }
    // O segundo argumento de substring é exclusivo, então especifica-se end + 1 para incluir o caractere na posição end
    return s.substring(start, end + 1);
}
```
