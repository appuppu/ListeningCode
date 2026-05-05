# Encoding and Decoding a List of Strings — Codificar e decodificar uma lista de strings em uma única string

## Essência do problema

Uma lista de strings `strs` é fornecida. O método `encode` converte a lista em uma única string, e o método `decode` restaura essa string de volta à lista original. A codificação e a decodificação devem ser stateless (sem manutenção de estado), e é necessário processar corretamente qualquer entrada, incluindo strings vazias, caracteres especiais e strings que contêm o próprio caractere delimitador.

## Ideia central

Se o comprimento de cada string for prefixado antes dela, é possível extraí-la com precisão independentemente do conteúdo da string. Quando o comprimento é conhecido, o problema de colisão com o delimitador não ocorre por princípio.

## Processo de raciocínio

1. **Reconhecer o problema da abordagem ingênua com delimitadores**: Se a lista for concatenada usando delimitadores como vírgula ou quebra de linha, não será possível decodificar corretamente quando a própria string contém esse delimitador. Mesmo introduzindo tratamento de escape, será necessário escapar o próprio caractere de escape, tornando a solução complexa
2. **Transmitir o comprimento da string antecipadamente elimina colisões**: Se o comprimento de cada string (em número de caracteres, não de bytes) for registrado antes dela, o decodificador sabe antecipadamente "quantos caracteres ler". Como o conteúdo da string é extraído sem nenhuma interpretação, qualquer caractere contido nela não causa problemas
3. **Usar `#` como separador entre o comprimento e o corpo da string**: Como o comprimento é um inteiro de dígitos variáveis, é necessário um símbolo para indicar o fim da parte do comprimento. Usa-se `#` como separador, no formato `comprimento#corpo_da_string`. Na decodificação, lê-se a parte do comprimento a partir da posição do primeiro `#` e extrai-se o número especificado de caracteres a partir da posição seguinte
4. **Codificação**: Para cada string, concatena-se `comprimento da string + "#" + corpo da string` para construir uma única string. Por exemplo, `["hello", "a#b"]` se torna `5#hello3#a#b`
5. **Decodificação**: A partir do início, procura-se `#` para ler o comprimento e extrai-se a quantidade de caracteres especificada logo após o `#`. A posição final da extração se torna a posição inicial da próxima iteração. Mesmo que o corpo da string contenha `#`, o intervalo exato é conhecido pelo comprimento, portanto não há reconhecimento incorreto
6. **O que é retornado no final**: `encode` retorna uma única `String` concatenada, e `decode` retorna uma `List<String>` restaurada a partir dessa `String`

## Conhecimentos prévios

### O que é StringBuilder

Uma classe para concatenar strings de forma eficiente. A concatenação com o operador `+` de `String` gera um novo objeto `String` a cada vez, mas `StringBuilder` adiciona ao buffer interno, permitindo concatenação em O(1).

```java
StringBuilder sb = new StringBuilder();  // Cria um StringBuilder vazio
sb.append("hello");                      // Adiciona "hello" ao final
sb.append(5);                            // Adiciona o inteiro 5 como string ao final
sb.toString();                           // Retorna a string resultante "hello5"
```

### O que é String.indexOf(char, int)

Um método que busca o caractere especificado a partir da posição inicial indicada e retorna a posição (índice) da primeira ocorrência encontrada. Retorna -1 se o caractere não for encontrado.

```java
String str = "12#hello";
str.indexOf('#', 0);    // Busca '#' a partir da posição 0 → retorna 2
str.indexOf('#', 3);    // Busca '#' a partir da posição 3 → retorna -1 se não encontrado
```

### O que é String.substring(int, int)

Um método que extrai um intervalo especificado de uma string. O primeiro argumento é a posição inicial (inclusiva), e o segundo argumento é a posição final (exclusiva).

```java
String str = "5#hello";
str.substring(0, 1);    // Da posição 0 até antes da posição 1 → "5"
str.substring(2, 7);    // Da posição 2 até antes da posição 7 → "hello"
```

### O que é Integer.parseInt(String)

Um método estático que converte uma string em um inteiro. É utilizado para ler a parte numérica do prefixo de comprimento como um valor inteiro.

```java
Integer.parseInt("5");    // Converte a string "5" no inteiro 5
Integer.parseInt("123");  // Converte a string "123" no inteiro 123
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n × k) — n é o número de strings, k é o comprimento médio das strings. Cada string é processada exatamente uma vez |
| Space | O(n × k) — Utiliza espaço proporcional a todas as strings, seja como resultado da codificação ou da decodificação |

## Código

```java
// === encode ===
// Entrada: uma lista de strings strs (List<String>)
// Saída: retorna uma String que agrupa todas as strings em uma só
public String encode(List<String> strs) {
    // Utiliza StringBuilder para concatenação eficiente de strings dentro do loop
    StringBuilder sb = new StringBuilder();
    // Percorre cada string da lista em ordem, do início ao fim
    for (String str : strs) {
        // Prefixa cada string com "comprimento#" e concatena
        // Ao registrar o comprimento antecipadamente, o intervalo exato do corpo da string é conhecido na decodificação
        sb.append(str.length() + "#" + str);
    }
    // Retorna o conteúdo do StringBuilder como String
    return sb.toString();
}

// === decode ===
// Entrada: uma única string codificada str (String)
// Saída: retorna a lista de strings restaurada List<String>
public List<String> decode(String str) {
    List<String> result = new ArrayList<>();
    // Variável que indica a posição atual de leitura. Inicia no começo da string
    int i = 0;
    while (i < str.length()) {
        // Busca o primeiro '#' a partir da posição atual i, identificando a posição de separação entre o comprimento e o corpo da string
        int separatorIndex = str.indexOf('#', i);
        // Lê como inteiro o trecho até antes do '#', obtendo o comprimento do corpo da string
        int textLength = Integer.parseInt(str.substring(i, separatorIndex));
        // A posição imediatamente após o '#' é o início do corpo da string
        int textStart = separatorIndex + 1;
        // A posição final é o início mais o comprimento. Como o intervalo é determinado pelo comprimento, a extração é correta mesmo que o corpo da string contenha '#'
        int textEnd = textStart + textLength;
        // Extrai o corpo da string e o adiciona à lista de resultados
        result.add(str.substring(textStart, textEnd));
        // Move a posição de leitura para o início da parte de comprimento da próxima string
        i = textEnd;
    }
    return result;
}
```
