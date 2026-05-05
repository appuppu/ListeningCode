# Checking if a String is a Palindrome — Determinar se uma string é um palíndromo

## Essência do problema

Dada uma string `s`, considerando apenas caracteres alfanuméricos e ignorando diferenças entre maiúsculas e minúsculas, determinar se a string é um palíndromo (lê-se da mesma forma de frente para trás e de trás para frente). Retornar `true` se for um palíndromo, caso contrário retornar `false`.

## Ideia central

Avançando dois ponteiros das extremidades da string em direção ao centro, pulando caracteres não alfanuméricos e comparando um caractere por vez, é possível determinar se a string é um palíndromo em espaço O(1) sem gerar strings adicionais.

## Processo de raciocínio

1. **Confirmar a definição de palíndromo**: Um palíndromo é uma string que se lê da mesma forma de frente para trás e de trás para frente. Ou seja, se o primeiro e o último caractere coincidem, e os caracteres internos também coincidem da mesma forma, então a string é um palíndromo
2. **Comparar a partir das extremidades permite determinar em uma única varredura**: Colocando um ponteiro `left` no início e um ponteiro `right` no final, avançando ambos em direção ao centro até que se encontrem, a determinação se completa examinando cada caractere apenas uma vez
3. **É necessário pular caracteres não alfanuméricos**: Como o problema considera apenas caracteres alfanuméricos, quando cada ponteiro aponta para um caractere não alfanumérico, ele deve ser pulado e avançar para o próximo. Pode-se usar `Character.isLetterOrDigit` para verificar se um caractere é alfanumérico
4. **Unificar maiúsculas e minúsculas antes de comparar**: Como o problema não diferencia maiúsculas de minúsculas, antes da comparação ambos os caracteres são convertidos para minúsculas com `Character.toLowerCase` para então verificar a correspondência
5. **Retornar `false` imediatamente ao encontrar uma divergência**: Se houver pelo menos uma diferença, a string não é um palíndromo, permitindo um retorno antecipado
6. **Se não houver divergência até os ponteiros se cruzarem, a string é um palíndromo**: Se o loop terminar normalmente, isso significa que todos os pares de caracteres correspondentes coincidiram, então retornar `true`

## Conhecimentos prévios

### O que é Two Pointers (técnica de dois ponteiros)

É uma técnica que posiciona ponteiros em ambas as extremidades de um array ou string e os move em direção ao centro conforme a condição. É eficaz para problemas que utilizam simetria (determinação de palíndromo, busca de pares, etc.). Como resolve o problema em uma única varredura, alcança tempo O(n) e espaço O(1).

```java
int left = 0;                    // Ponteiro que aponta para o início
int right = s.length() - 1;     // Ponteiro que aponta para o final
// Continua o loop até left e right se cruzarem
while (left < right) {
    // Realiza comparação ou processamento
    left++;    // Avança o ponteiro esquerdo para a direita
    right--;   // Avança o ponteiro direito para a esquerda
}
```

### O que é Character.isLetterOrDigit

É um método que verifica se um caractere é uma letra (a-z, A-Z) ou um dígito (0-9). É utilizado quando se deseja excluir caracteres não alfanuméricos como espaços ou símbolos.

```java
Character.isLetterOrDigit('A');   // true (letra)
Character.isLetterOrDigit('3');   // true (dígito)
Character.isLetterOrDigit(' ');   // false (espaço)
Character.isLetterOrDigit(',');   // false (símbolo)
```

### O que é Character.toLowerCase

É um método que converte uma letra para minúscula. É utilizado quando se deseja comparar sem diferenciar maiúsculas de minúsculas. Se o caractere já for minúsculo ou um dígito, ele é retornado sem alteração.

```java
Character.toLowerCase('A');   // 'a'
Character.toLowerCase('a');   // 'a' (sem alteração)
Character.toLowerCase('3');   // '3' (dígitos permanecem inalterados)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Cada ponteiro percorre a string no máximo uma vez |
| Space | O(1) — Utiliza apenas dois ponteiros, sem strings ou estruturas de dados adicionais |

## Código

```java
// Entrada: string s
// Saída: retorna true se s for um palíndromo, caso contrário retorna false
public boolean isPalindrome(String s) {
    // Posiciona ponteiros no início e no final. Ambos avançam das extremidades da string em direção ao centro
    int left = 0;
    int right = s.length() - 1;

    // Repete até que os dois ponteiros se cruzem. Quando se cruzarem, todas as comparações estarão completas
    while (left < right) {
        // Se left não for alfanumérico, pula para a direita
        // Nota: durante o avanço, mantém a condição left < right para evitar que os ponteiros se cruzem
        while (left < right && !Character.isLetterOrDigit(s.charAt(left))) {
            left++;
        }
        // Se right não for alfanumérico, pula para a esquerda. Da mesma forma, mantém a condição left < right
        while (left < right && !Character.isLetterOrDigit(s.charAt(right))) {
            right--;
        }
        // Converte ambos os caracteres para minúsculas antes de comparar, ignorando diferenças entre maiúsculas e minúsculas
        // Se forem diferentes, não é um palíndromo. Se houver pelo menos uma diferença, a condição de palíndromo não é satisfeita, então retorna imediatamente
        if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right))) {
            return false;
        }
        // Os dois caracteres coincidem, então avança ambos os ponteiros para o centro para comparar o próximo par de caracteres
        left++;
        right--;
    }
    // O loop terminou normalmente (todos os pares de caracteres correspondentes coincidiram), portanto é um palíndromo
    return true;
}
```
