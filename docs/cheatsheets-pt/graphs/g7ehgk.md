# Finding the Shortest Word Transformation Sequence — Encontrar o comprimento da menor sequência de transformação de palavras

## Essência do problema

São dados uma palavra inicial `beginWord`, uma palavra final `endWord` e um dicionário de palavras válidas `wordList`. O objetivo é retornar o **menor comprimento** de uma sequência de transformação da palavra inicial até a palavra final, onde **cada passo altera exatamente um caractere** e todas as palavras intermediárias devem existir no dicionário. Se a sequência de transformação não existir, retorna-se 0.

## Ideia central

Se considerarmos a transformação de um caractere entre palavras como uma aresta de um grafo, a menor sequência de transformação se torna um problema de caminho mais curto. Ao executar o BFS simultaneamente a partir do ponto de partida e do ponto de chegada, e sempre expandir a fronteira menor, é possível reduzir drasticamente o espaço de busca.

## Processo de raciocínio

1. **Modelar como um grafo**: Considere um grafo onde cada palavra é um nó e palavras que diferem por apenas um caractere são conectadas por arestas. O comprimento da menor sequência de transformação corresponde ao comprimento do caminho mais curto de beginWord até endWord nesse grafo
2. **Usar BFS para o caminho mais curto**: Como se trata de um problema de caminho mais curto em um grafo sem pesos, o BFS (busca em largura) é a abordagem adequada. Cada nível corresponde a um passo de transformação
3. **Ineficiência do BFS unidirecional**: Se o BFS for executado apenas a partir do ponto de partida, os candidatos crescem exponencialmente em cada nível. O espaço de busca explode conforme a profundidade aumenta
4. **Reduzir o espaço de busca com BFS bidirecional**: Ao executar o BFS simultaneamente a partir do ponto de partida e do ponto de chegada, o caminho mais curto é encontrado quando ambas as buscas se encontram. Como a profundidade de cada busca é limitada a d/2, o espaço de busca é significativamente reduzido
5. **Expandir prioritariamente a fronteira menor**: Em cada passo, o algoritmo compara o tamanho das fronteiras do lado inicial e do lado final, e expande a menor. Dessa forma, a expansão das fronteiras é sempre controlada
6. **Método de geração de palavras adjacentes**: Em vez de comparar com todas as palavras do dicionário, o algoritmo gera palavras adjacentes tentando as 26 letras de a a z em cada posição da palavra. Quando o comprimento m da palavra é suficientemente menor que o tamanho n do dicionário, esse método é mais eficiente
7. **Verificação de encontro com a fronteira oposta**: Se uma palavra adjacente gerada estiver contida na fronteira do lado oposto, isso significa que ambas as buscas se encontraram, e o algoritmo retorna o nível atual + 1

## Conhecimentos prévios

### O que é BFS (Busca em Largura)

É um algoritmo que explora os nós de um grafo na ordem de proximidade a partir do ponto de partida. Como a distância aumenta em 1 a cada nível, a distância no momento da primeira chegada é a menor distância. É utilizado em problemas de caminho mais curto em grafos sem pesos.

### O que é HashSet

É uma estrutura de dados que mantém um conjunto de elementos. A adição, busca e remoção de elementos são realizadas em O(1). Duplicatas são automaticamente eliminadas.

```java
Set<String> set = new HashSet<>();   // Criar um HashSet vazio
set.add("hot");                      // Adicionar um elemento
set.contains("hot");                 // Retornar boolean indicando se o elemento existe → true
set.size();                          // Retornar o número de elementos → 1
```

### O que é BFS bidirecional

Enquanto o BFS convencional explora apenas a partir do ponto de partida, o BFS bidirecional executa a exploração simultaneamente a partir do ponto de partida e do ponto de chegada. O caminho mais curto é encontrado quando as fronteiras de ambos os lados se sobrepõem. O espaço de busca é reduzido de O(b^d) para O(b^(d/2)) (onde b é o fator de ramificação e d é a menor distância).

### O que são toCharArray / String.valueOf

São métodos para converter uma String em um array de caracteres e manipular cada caractere individualmente.

```java
char[] ch = "hot".toCharArray();     // Converter String → char[] → ['h','o','t']
ch[0] = 'b';                        // Substituir diretamente um caractere → ['b','o','t']
String next = String.valueOf(ch);    // Converter char[] → String → "bot"
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n × m) — n é o número de palavras no dicionário, m é o comprimento da palavra. O algoritmo testa 26 caracteres para cada posição de cada palavra |
| Space | O(n × m) — O conjunto de visitados e as fronteiras armazenam no máximo n palavras (cada uma com comprimento m) |

## Código

```java
// Entrada: palavra inicial beginWord, palavra final endWord, dicionário de palavras válidas wordList
// Saída: retornar o comprimento da menor sequência de transformação como int. Retornar 0 se a sequência não existir
int ladderLength(String beginWord, String endWord, List<String> wordList) {
    // Converter o dicionário em HashSet para verificação de existência de palavras em O(1)
    Set<String> wordSet = new HashSet<>(wordList);
    // Se endWord não estiver no dicionário, a sequência de transformação não pode ser construída, retornar 0
    if (!wordSet.contains(endWord)) return 0;

    // Criar três HashSets: fronteira do lado inicial, fronteira do lado final e conjunto de visitados
    Set<String> start = new HashSet<>();
    Set<String> end = new HashSet<>();
    Set<String> visited = new HashSet<>();
    start.add(beginWord);
    end.add(endWord);
    // Registrar as palavras de ambas as fronteiras como visitadas
    visited.add(beginWord);
    visited.add(endWord);
    // level representa o comprimento da sequência de transformação (contando o ponto de partida como 1)
    int level = 1;

    // Se uma das fronteiras ficar vazia, o destino é inalcançável e o loop é encerrado
    while (!start.isEmpty() && !end.isEmpty()) {
        // Sempre expandir a fronteira menor para controlar a expansão do espaço de busca
        if (start.size() > end.size()) {
            Set<String> temp = start;
            start = end;
            end = temp;
        }

        // Conjunto para armazenar os candidatos do próximo nível
        Set<String> nextLevel = new HashSet<>();

        for (String word : start) {
            // Converter a palavra em char[] e substituir cada posição caractere por caractere para gerar palavras adjacentes
            char[] ch = word.toCharArray();
            for (int j = 0; j < ch.length; j++) {
                // Salvar o caractere original para restaurá-lo após a exploração
                char orig = ch[j];
                // Testar as 26 letras de a a z em cada posição para gerar palavras adjacentes
                for (char c = 'a'; c <= 'z'; c++) {
                    ch[j] = c;
                    String next = String.valueOf(ch);
                    // Se a palavra estiver na fronteira oposta, ambas as buscas se encontraram
                    if (end.contains(next)) return level + 1;
                    // Se a palavra estiver no dicionário e não foi visitada, adicioná-la à próxima fronteira
                    // Adicionar ao visited para evitar revisitar a mesma palavra
                    if (wordSet.contains(next) && !visited.contains(next)) {
                        nextLevel.add(next);
                        visited.add(next);
                    }
                }
                // Restaurar o caractere original para preparar a exploração da próxima posição
                ch[j] = orig;
            }
        }
        // Substituir a fronteira pelo próximo nível, incrementar level em 1 e prosseguir para a próxima iteração
        start = nextLevel;
        level++;
    }
    // Se uma das fronteiras ficou vazia, a sequência de transformação não existe
    return 0;
}
```
