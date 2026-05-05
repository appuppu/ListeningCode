# Multiplying Two Numbers Represented as Strings — Multiplicar dois números representados como strings

## Essência do problema

São dadas duas strings `num1` e `num2` que representam números inteiros não negativos. O objetivo é retornar o **produto** dos dois números como uma string. É proibido usar bibliotecas de inteiros grandes embutidas ou converter a entrada diretamente em inteiros.

## Ideia central

Simular exatamente a multiplicação manual aprendida na escola. A chave é a relação de posição: o produto do i-ésimo dígito de `num1` com o j-ésimo dígito de `num2` é somado nas posições `i + j` e `i + j + 1` do resultado.

## Processo de raciocínio

1. **Reproduzir a multiplicação manual**: Como não é possível converter em inteiros, implementa-se diretamente o algoritmo de multiplicação manual, multiplicando dígito por dígito e acumulando os resultados
2. **Estimar o número máximo de dígitos do produto**: O produto de um número de n dígitos por um número de m dígitos tem no máximo `n + m` dígitos (exemplo: 99 × 99 = 9801, 2 dígitos × 2 dígitos = 4 dígitos). Portanto, prepara-se um array `pos` de tamanho `n + m` para armazenar o valor de cada dígito
3. **Identificar a posição correspondente de cada produto parcial no resultado**: O produto do i-ésimo dígito de `num1` (contando da direita) pelo j-ésimo dígito de `num2` (contando da direita) afeta as posições `i + j` e `i + j + 1` do resultado (contando da direita). Em termos de índices da string, o produto de `num1[i] * num2[j]` é somado em `pos[i + j + 1]` (dígito inferior) e `pos[i + j]` (dígito superior)
4. **Processar o vai-um imediatamente**: Após calcular o produto de cada par de dígitos, soma-se ao valor já acumulado em `pos[p2]`, mantém-se o resto da divisão por 10 nessa posição e soma-se o quociente da divisão por 10 na posição superior `pos[p1]`. Isso processa o vai-um instantaneamente
5. **Remover zeros à esquerda e construir a string**: O início do array `pos` pode conter zeros (exemplo: quando o produto de 3 dígitos × 2 dígitos tem 4 dígitos, a primeira posição do array de 5 dígitos é 0). A string é construída com `StringBuilder`, pulando os zeros à esquerda
6. **Tratamento especial para zero**: Se qualquer uma das entradas for `"0"`, o produto é necessariamente `"0"`, então retorna-se `"0"` antecipadamente

## Conhecimentos prévios

### charAt e conversão de caractere para número

`String.charAt(i)` retorna o i-ésimo caractere da string como tipo `char`. Para converter os caracteres `'0'`–`'9'` do tipo `char` nos inteiros 0–9, subtrai-se o código do caractere `'0'`.

```java
String s = "123";
char c = s.charAt(0);       // '1' (tipo char)
int digit = c - '0';        // 1 (tipo int). Subtrai o código 48 de '0' do código 49 de '1'
```

### Relação de posição na multiplicação manual

Na multiplicação manual de n dígitos × m dígitos, o produto de `num1[i]` por `num2[j]` (no máximo 81) pode ter 2 dígitos. Esses 2 dígitos correspondem a `pos[i + j]` (dígito superior) e `pos[i + j + 1]` (dígito inferior) no resultado.

```
Exemplo: "12" × "34"
  num1[0]=1, num2[0]=3 → produto 3  → somado em pos[0], pos[1]
  num1[0]=1, num2[1]=4 → produto 4  → somado em pos[1], pos[2]
  num1[1]=2, num2[0]=3 → produto 6  → somado em pos[1], pos[2]
  num1[1]=2, num2[1]=4 → produto 8  → somado em pos[2], pos[3]
```

### StringBuilder

Classe para construir strings de comprimento variável de forma eficiente. Adiciona caracteres ao final com `append` e converte para `String` com `toString` no final.

```java
StringBuilder sb = new StringBuilder();  // Cria um StringBuilder vazio
sb.append(4);                            // Adiciona "4" ao final
sb.append(0);                            // Resulta em "40"
sb.append(8);                            // Resulta em "408"
sb.toString();                           // Retorna a String "408"
sb.length();                             // Retorna o número atual de caracteres → 3
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n × m) — Cada dígito de num1 é multiplicado por cada dígito de num2 exatamente uma vez |
| Space | O(n + m) — O tamanho do array que armazena cada dígito do produto é n + m |

## Código

```java
// Entrada: strings num1 e num2 que representam inteiros não negativos
// Saída: retorna uma string representando o produto dos dois números
String multiply(String num1, String num2) {
    // Se qualquer um for "0", o produto é necessariamente 0, então retorna "0" antecipadamente
    if (num1.equals("0") || num2.equals("0"))
        return "0";

    int n = num1.length();
    int m = num2.length();
    // Array para armazenar cada dígito do produto. O produto de n dígitos × m dígitos tem no máximo n+m dígitos, então este tamanho é suficiente
    int[] pos = new int[n + m];

    // Assim como na multiplicação manual, multiplica-se da direita (último dígito) para a esquerda
    for (int i = n - 1; i >= 0; i--) {
        for (int j = m - 1; j >= 0; j--) {
            // Obtém o caractere com charAt, subtrai '0' para converter o caractere no inteiro correspondente e multiplica
            int mul = (num1.charAt(i) - '0')
                * (num2.charAt(j) - '0');
            // Posições onde o produto é somado: p1 é o dígito superior, p2 é o dígito inferior. Esta relação de posição baseia-se na correspondência de dígitos na multiplicação manual
            int p1 = i + j;
            int p2 = i + j + 1;
            // Considera valores somados na mesma posição em iterações anteriores, somando ao valor já acumulado
            int sum = mul + pos[p2];
            // Mantém apenas um dígito na posição inferior (resto da divisão por 10) e soma o vai-um na posição superior (quociente da divisão por 10)
            pos[p2] = sum % 10;
            pos[p1] += sum / 10;
        }
    }

    // Constrói a string pulando os zeros à esquerda (exemplo: caso em que a primeira posição de um array de 5 dígitos é 0)
    StringBuilder sb = new StringBuilder();
    for (int p : pos) {
        // Se o StringBuilder ainda estiver vazio e o valor atual for 0, trata-se de um zero à esquerda, então pula
        if (sb.length() == 0 && p == 0)
            continue;
        sb.append(p);
    }
    // Converte o StringBuilder para tipo String e retorna
    return sb.toString();
}
```
