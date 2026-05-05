# Partitioning a String Into Maximum Parts — Dividir uma string no número máximo de partes de modo que cada caractere pertença a apenas uma parte

## Essência do Problema

Dada uma string `s` composta por letras minúsculas do alfabeto inglês, dividir a string no maior número possível de partes de modo que cada caractere esteja contido em no máximo uma parte. Retornar uma lista com o **comprimento** de cada parte.

## Ideia Central

Se um caractere está contido na parte atual, é necessário estender essa parte até a última posição de ocorrência desse caractere. Ao pré-calcular a última posição de ocorrência de cada caractere, é possível determinar os limites das partes de forma gulosa em uma única varredura.

## Processo de Raciocínio

1. **Compreender a restrição da divisão**: O mesmo caractere não pode aparecer em duas partes diferentes. Ou seja, a parte que contém um determinado caractere deve incluir pelo menos até a última posição de ocorrência desse caractere
2. **Pré-calcular a última posição de ocorrência de cada caractere**: Percorrer a string uma vez e registrar em um array o índice da última ocorrência de cada caractere. Como existem apenas 26 letras minúsculas, um array de tamanho 26 é suficiente
3. **Estender o final da parte de forma gulosa**: Percorrer a string desde o início, rastreando como `end` o valor máximo da última posição de ocorrência entre todos os caracteres contidos na parte atual. A cada novo caractere encontrado, atualizar `end` comparando-o com a última posição de ocorrência desse caractere
4. **Identificar a condição de confirmação da parte**: Quando o índice atual `i` alcança `end`, é garantido que todos os caracteres dentro da parte atual estão contidos dentro do intervalo dessa parte. Nesse momento, confirmar a parte e iniciar a próxima
5. **Calcular o comprimento da parte**: Cada vez que uma parte é confirmada, calcular o comprimento com `end - start + 1` e adicioná-lo à lista de resultados. Atualizar a posição de início `start` da próxima parte para `i + 1`

## Conhecimentos Prévios

### Conversão de Caractere para Índice

Em Java, o tipo `char` pode ser tratado como um inteiro. Com `s.charAt(i) - 'a'`, a letra minúscula `'a'` é convertida para `0`, `'b'` para `1`, ..., `'z'` para `25`. Isso permite gerenciar todas as letras minúsculas com um array de tamanho 26.

```java
char c = 'c';
int index = c - 'a';    // 2 ('c' é o segundo a partir de 'a')
int[] arr = new int[26]; // array para 26 caracteres
arr[c - 'a'] = 5;       // armazena o valor 5 na posição correspondente a 'c'
```

### O que é Math.max

É um método que retorna o maior entre dois valores. É utilizado ao estender o final da parte para comparar o `end` atual com a última posição de ocorrência do novo caractere e adotar o valor mais distante.

```java
Math.max(3, 7);   // retorna 7
Math.max(10, 2);  // retorna 10
```

### O que é ArrayList

É uma lista de tamanho variável. Como o número de partes não é conhecido previamente, é adequada para adicionar os comprimentos das partes um a um.

```java
List<Integer> res = new ArrayList<>();  // cria uma lista vazia
res.add(9);    // adiciona 9 ao final → [9]
res.add(7);    // adiciona 7 ao final → [9, 7]
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — basta percorrer a string duas vezes (uma para registrar as últimas posições, outra para dividir as partes) |
| Space | O(1) — utiliza apenas um array fixo de tamanho 26, não dependendo do tamanho da entrada |

## Código

```java
// Entrada: string s composta por letras minúsculas do alfabeto inglês
// Saída: retorna uma List<Integer> contendo o comprimento de cada parte
List<Integer> partitionLabels(String s) {
    // Array de inteiros de tamanho 26 que armazena o índice da última ocorrência de cada caractere ('a' a 'z')
    // Como existem apenas 26 letras minúsculas, o tamanho 26 é fixo
    int[] last = new int[26];

    // Primeira varredura: registrar a última posição de ocorrência de cada caractere
    // Quando o mesmo caractere aparece múltiplas vezes, o índice posterior sobrescreve o anterior, preservando a última posição
    for (int i = 0; i < s.length(); i++) {
        last[s.charAt(i) - 'a'] = i;
    }

    // Como o número de partes não é conhecido previamente, utilizar uma lista de tamanho variável
    List<Integer> res = new ArrayList<>();
    // start: posição de início da parte atual, end: posição final da parte atual
    int start = 0, end = 0;

    // Segunda varredura: confirmar as partes de forma gulosa
    for (int i = 0; i < s.length(); i++) {
        // Se a última posição de ocorrência do caractere atual é mais distante que end, estender o final da parte até lá
        // Isso garante que end sempre mantém o valor máximo da última posição de ocorrência entre todos os caracteres na parte
        end = Math.max(end,
            last[s.charAt(i) - 'a']);

        // i alcançou end → é garantido que todos os caracteres na parte estão contidos neste intervalo
        // Porque nenhum caractere na parte aparece após end
        if (i == end) {
            // Calcular o comprimento da parte com end - start + 1 e adicionar à lista de resultados
            res.add(end - start + 1);
            // Atualizar a posição de início da próxima parte
            start = i + 1;
        }
    }
    // Retornar a lista contendo os comprimentos de todas as partes
    return res;
}
```
