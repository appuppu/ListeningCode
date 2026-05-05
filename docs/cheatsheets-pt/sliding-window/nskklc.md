# Finding the Smallest Window Containing All Characters — Encontrar a menor substring que contém todos os caracteres

## Essência do problema

Duas strings `s` e `t` são fornecidas. O objetivo é encontrar e retornar a **menor substring** de `s` que contém todos os caracteres de `t` (incluindo duplicatas). Se tal substring não existir, retorna-se uma string vazia.

## Ideia central

O ponteiro direito é expandido para criar uma janela que satisfaz a condição, e o ponteiro esquerdo é contraído para minimizá-la. Ao gerenciar "o número de tipos de caracteres que satisfazem a condição" em uma única variável, a validade da janela pode ser verificada em O(1).

## Processo de raciocínio

1. **Contar previamente as ocorrências dos caracteres necessários**: As ocorrências de cada caractere contido em `t` são registradas em um HashMap. Isso define a condição que a janela deve satisfazer. Por exemplo, se `t = "ABC"`, o resultado é `{A:1, B:1, C:1}`
2. **Expandir a janela para a direita para satisfazer a condição**: O ponteiro direito `r` é avançado um a um para adicionar caracteres à janela, e as ocorrências dos caracteres dentro da janela são gerenciadas em outro HashMap. Cada vez que um tipo de caractere atinge o número necessário de ocorrências dentro da janela, o contador `have` é incrementado
3. **Verificar o cumprimento da condição em O(1)**: O tamanho de `need` (número de tipos de caracteres necessários) é definido como `required`, e se `have == required` for verdadeiro, a janela contém todos os caracteres de `t`. Ao gerenciar por tipo de caractere, elimina-se a necessidade de comparar todos os caracteres a cada vez
4. **Contrair a janela pela esquerda para minimizá-la**: Enquanto `have == required`, o ponteiro esquerdo `left` é avançado para a direita para reduzir a janela. A cada contração, o comprimento da janela é comparado com o valor mínimo atual, e se for menor, o valor é atualizado
5. **Processamento ao remover o caractere da extremidade esquerda**: Ao remover o caractere `s.charAt(left)` da janela, se esse caractere estiver contido em `need` e o número de ocorrências na janela ficar abaixo do necessário, `have` é decrementado. Isso encerra o loop `while` e retorna à expansão do ponteiro direito
6. **O que retornar ao final**: Após a varredura completa, se a janela mínima foi encontrada, retorna-se `s.substring(resStart, resStart + resLen)`. Se não foi encontrada, retorna-se uma string vazia

## Conhecimentos prévios

### O que é um HashMap

É uma estrutura de dados que armazena pares de chave e valor. A busca e obtenção de valores por chave é feita em O(1). Neste problema, o HashMap é utilizado para gerenciar o número de ocorrências dos caracteres.

```java
HashMap<Character, Integer> map = new HashMap<>();  // Criar um HashMap vazio
map.put('A', 1);                    // Armazenar o valor 1 na chave 'A'
map.getOrDefault('A', 0);           // Retornar o valor da chave 'A'. Se não existir, retorna 0 → 1
map.containsKey('A');               // Retornar um boolean indicando se a chave 'A' existe → true
map.get('A').equals(map.get('B'));  // Usar equals para comparar objetos Integer entre si
```

### O que é Sliding Window (Janela Deslizante)

É uma técnica que gerencia um intervalo contínuo (janela) sobre um array ou string usando dois ponteiros `left` e `right`. Ao expandir a janela com o ponteiro direito e contraí-la com o ponteiro esquerdo, é possível otimizar de O(n²), que examina todas as substrings, para O(n).

```java
int left = 0;
for (int r = 0; r < s.length(); r++) {
    // Processamento para expandir a janela com o ponteiro direito
    while (condição está satisfeita) {
        // Processamento para contrair a janela com o ponteiro esquerdo
        left++;
    }
}
```

### O que é o padrão have / required

É uma técnica para verificar em O(1) se a janela satisfaz a condição. `required` representa o número total de tipos de caracteres que devem ser satisfeitos, e `have` representa o número de tipos de caracteres que atingiram a quantidade necessária no momento atual. Quando `have == required`, a janela satisfaz todas as condições.

```java
int required = need.size();  // Número de tipos de caracteres necessários (ex: need={A:1,B:1,C:1} → 3)
int have = 0;                // Número de tipos de caracteres que satisfazem a condição (valor inicial 0)
// Quando o número de 'A' na janela atinge o número de 'A' em need, have++ → have==required significa que todas as condições estão satisfeitas
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — O ponteiro direito e o ponteiro esquerdo percorrem `s` no máximo uma vez cada |
| Space | O(n) — Os HashMaps `need` e `window` armazenam no máximo o número de tipos de caracteres de `s` e `t` |

## Código

```java
// Entrada: string s e string t
// Saída: retorna como String a menor substring de s que contém todos os caracteres de t. Se não existir, retorna uma string vazia
String minWindow(String s, String t) {
    // Se s for menor que t, não existe janela que contenha todos os caracteres
    if (s.length() < t.length())
        return "";

    // HashMap que registra o número necessário de ocorrências de cada caractere de t. Isso define a condição que a janela deve satisfazer
    Map<Character, Integer> need = new HashMap<>();
    for (char c : t.toCharArray()) {
        need.put(c, need.getOrDefault(c, 0) + 1);
    }

    // HashMap que gerencia o número de ocorrências de cada caractere dentro da janela
    Map<Character, Integer> window = new HashMap<>();
    int have = 0;              // Número de tipos de caracteres que satisfazem a condição
    int required = need.size(); // Número total de tipos de caracteres a serem satisfeitos (número de chaves em need)
    int resLen = Integer.MAX_VALUE; // Comprimento da janela mínima (valor inicial representando estado não encontrado)
    int resStart = 0;          // Posição inicial da janela mínima
    int left = 0;              // Ponteiro esquerdo

    // Expandir a janela para a direita com o ponteiro direito
    for (int r = 0; r < s.length(); r++) {
        char c = s.charAt(r);
        // Incrementar em 1 o número de ocorrências do caractere c na janela (a janela é expandida em 1 caractere para a direita)
        window.put(c, window.getOrDefault(c, 0) + 1);

        // Se o caractere c é necessário em t e o número de ocorrências na janela atingiu exatamente o necessário, incrementar have
        // Nota: usar equals em vez de == para comparar objetos Integer
        if (need.containsKey(c)
            && window.get(c).equals(need.get(c))) {
            have++;
        }

        // Enquanto a janela satisfaz todas as condições (have == required), contrair pela esquerda para minimizar
        while (have == required) {
            int wLen = r - left + 1;
            // Se uma janela menor for encontrada, atualizar o resultado
            if (wLen < resLen) {
                resLen = wLen;
                resStart = left;
            }
            // Remover o caractere da extremidade esquerda da janela
            char lc = s.charAt(left);
            window.put(lc, window.get(lc) - 1);
            // Se a remoção fez o número de ocorrências na janela ficar abaixo do necessário, a condição foi quebrada, então decrementar have
            if (need.containsKey(lc)
                && window.get(lc) < need.get(lc)) {
                have--;
            }
            // Avançar o ponteiro esquerdo para a direita para contrair a janela
            left++;
        }
    }

    // Se resLen permanece com o valor inicial, nenhuma janela satisfazendo a condição foi encontrada, então retornar string vazia
    if (resLen == Integer.MAX_VALUE)
        return "";
    // Extrair e retornar o trecho a partir da posição inicial da janela mínima com o comprimento da janela mínima
    return s.substring(resStart, resStart + resLen);
}
```
