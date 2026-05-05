# Counting All Palindromic Substrings — Contar o número total de substrings palindrômicas em uma string

## Essência do problema

Uma string `s` é fornecida. Retornar o **número total** de substrings de `s` que são palíndromos (strings que se leem da mesma forma da esquerda para a direita e da direita para a esquerda). Substrings de um único caractere também são contadas como palíndromos.

## Ideia central

Todo palíndromo possui um "centro". Ao fixar o centro e expandir para a esquerda e para a direita, é possível enumerar todos os palíndromos que se originam desse centro. Os candidatos a centro são apenas 2n-1 no total: cada caractere (comprimento ímpar) e cada espaço entre dois caracteres adjacentes (comprimento par), o que torna a busca completa viável.

## Processo de raciocínio

1. **Observar a propriedade estrutural dos palíndromos**: Todo palíndromo é simétrico em relação ao seu centro. Palíndromos de comprimento ímpar têm um único caractere como centro, e palíndromos de comprimento par têm dois caracteres adjacentes como centro. Utilizando essa propriedade, é possível descobrir palíndromos de forma eficiente a partir do centro
2. **Expandir do centro para fora**: Para um determinado centro, definir ponteiros `left` e `right` e expandir para fora enquanto `s.charAt(left) == s.charAt(right)`. Cada vez que a expansão é bem-sucedida, um novo palíndromo é encontrado, então o contador é incrementado em 1
3. **Processar comprimentos ímpar e par separadamente**: Para cada índice `i`, chamar `expand(s, i, i)` para contar palíndromos de comprimento ímpar e `expand(s, i, i+1)` para contar palíndromos de comprimento par. Essas duas chamadas cobrem todos os palíndromos centrados em `i`
4. **Definir a condição de parada da expansão**: A expansão é interrompida quando `left` se torna menor que 0, ou `right` se torna maior ou igual ao comprimento da string, ou os caracteres à esquerda e à direita não coincidem. Isso previne acesso fora dos limites enquanto realiza a expansão máxima
5. **Somar os resultados de cada centro**: A soma dos números de palíndromos de comprimento ímpar e par para todos os índices resulta no número total de substrings palindrômicas da string inteira
6. **O que retornar no final**: Retornar a soma total de palíndromos obtidos de todos os centros como um inteiro `result`

## Conhecimentos prévios

### O que é um Palíndromo (Palindrome)

Uma string que se lê da mesma forma da esquerda para a direita e da direita para a esquerda. `"aba"`, `"abba"` e `"a"` são todos palíndromos. Existem dois tipos de palíndromos: de comprimento ímpar (centro é 1 caractere) e de comprimento par (centro está entre 2 caracteres).

```
Exemplo de comprimento ímpar: "aba"  → o centro é 'b'
Exemplo de comprimento par: "abba" → o centro está entre 'b' e 'b'
```

### O que é a Expansão a partir do Centro (Expand Around Center)

Uma técnica que fixa o centro de um palíndromo e expande um caractere de cada vez para a esquerda e para a direita, verificando se forma um palíndromo. A expansão continua enquanto os caracteres coincidem do centro para fora, e para quando deixam de coincidir.

```
String: "abacd"
Expansão a partir do centro i=1 ('b'):
  left=1, right=1 → 'b'=='b' → palíndromo "b" encontrado, count=1
  left=0, right=2 → 'a'=='a' → palíndromo "aba" encontrado, count=2
  left=-1 → fora dos limites, então para
```

### O que é String.charAt(int index)

Um método que retorna o caractere no índice especificado da string. O índice começa em 0.

```java
String s = "abc";
s.charAt(0);    // retorna 'a'
s.charAt(2);    // retorna 'c'
s.length();     // retorna o comprimento da string → 3
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n²) — para cada centro (n centros), realiza-se uma expansão de no máximo O(n) |
| Space | O(1) — utiliza apenas ponteiros e contadores, sem estruturas de dados adicionais |

## Código

```java
// Entrada: string s
// Saída: retorna o número total de substrings palindrômicas de s como um inteiro

// Expande a partir do centro especificado para a esquerda e direita, e retorna o número de palíndromos encontrados
// Se left e right têm o mesmo valor, busca palíndromos de comprimento ímpar; se são valores adjacentes, busca palíndromos de comprimento par
int expand(String s, int left, int right) {
    int count = 0;
    // Expande enquanto as 3 condições são satisfeitas: extremo esquerdo dentro dos limites, extremo direito dentro dos limites, caracteres esquerdo e direito coincidem
    while (left >= 0 && right < s.length()
            && s.charAt(left) == s.charAt(right)) {
        count++;   // s.substring(left, right+1) é um novo palíndromo, então incrementa o contador
        left--;    // expande 1 posição para a esquerda
        right++;   // expande 1 posição para a direita
    }
    // Retorna o número total de palíndromos encontrados a partir deste centro
    return count;
}

int countSubstrings(String s) {
    // Variável que acumula o número de palíndromos encontrados a partir de todos os centros
    int result = 0;

    // Percorre cada índice como candidato a centro
    for (int i = 0; i < s.length(); i++) {
        // Palíndromos de comprimento ímpar: inicia a expansão com left=i, right=i a partir de um centro de 1 caractere
        result += expand(s, i, i);
        // Palíndromos de comprimento par: inicia a expansão com left=i, right=i+1 a partir de um centro de 2 caracteres adjacentes
        result += expand(s, i, i + 1);
    }
    // Retorna a soma total de palíndromos obtidos de todos os centros
    return result;
}
```
