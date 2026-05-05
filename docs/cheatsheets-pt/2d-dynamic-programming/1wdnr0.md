# Finding the Minimum Edits to Transform One String Into Another — Encontrar a distância mínima de edição entre duas strings

## Essência do problema

O problema fornece duas strings `word1` e `word2`. Você deve retornar o **número mínimo de operações** necessárias para transformar `word1` em `word2`. As três operações permitidas são "inserção", "exclusão" e "substituição", e cada uma conta como uma operação.

## Ideia central

Ao comparar duas strings a partir do final, se os caracteres atuais forem iguais, nenhuma operação é necessária e ambos os índices avançam. Se forem diferentes, você escolhe a operação de menor custo entre "inserção", "exclusão" e "substituição". A sobreposição de subproblemas é eliminada com uma tabela de DP, e como cada célula depende apenas da linha atual e da linha anterior, é possível otimizar o espaço utilizando apenas um array de uma linha.

## Processo de raciocínio

1. **Existem apenas três escolhas em cada posição**: Ao comparar `word1[i]` com `word2[j]`, se os caracteres forem iguais, avança-se para `(i+1, j+1)` sem nenhuma operação. Se forem diferentes, você escolhe o menor custo entre "inserção (avançar j)", "exclusão (avançar i)" e "substituição (avançar ambos)". Essa estrutura recursiva sugere a aplicação de DP
2. **Definição da tabela de DP**: Definimos `dp[i][j]` como "o número mínimo de operações para transformar `word1[i:]` em `word2[j:]`". A resposta final será `dp[0][0]`
3. **Definir os casos base**: Se o restante de `word1` estiver vazio (`i == m`), são necessárias inserções equivalentes ao número de caracteres restantes em `word2[j:]`, portanto `dp[m][j] = n - j`. Se o restante de `word2` estiver vazio (`j == n`), são necessárias exclusões equivalentes ao número de caracteres restantes em `word1[i:]`, portanto `dp[i][n] = m - i`
4. **Definir a direção de preenchimento bottom-up**: Como `dp[i][j]` depende de `dp[i+1][j+1]`, `dp[i][j+1]` e `dp[i+1][j]`, preenchemos `i` de `m-1` até `0` e `j` de `n-1` até `0`, em ordem reversa
5. **Otimizar o espaço**: Para calcular cada linha `i`, apenas a "linha anterior (`i+1`)" e a "linha atual (`i`)" são necessárias. Portanto, não é preciso manter um array bidimensional — dois arrays unidimensionais `prev` (linha anterior) e `curr` (linha atual) são suficientes. Ao final do cálculo de cada linha, troca-se com `prev = curr`
6. **Valor a retornar**: Após processar todas as linhas, `prev[0]` corresponde ao valor de `dp[0][0]`, que é o número mínimo de operações para transformar `word1` inteira em `word2` inteira

## Conhecimentos prévios

### O que é Edit Distance (distância de edição)

É uma métrica que representa a "similaridade" entre duas strings, definida como o número mínimo de operações necessárias para transformar uma string na outra. Também é conhecida como distância de Levenshtein. As três operações permitidas são as seguintes, cada uma com custo 1.

- **Inserção (Insert)**: Adiciona um caractere à string
- **Exclusão (Delete)**: Remove um caractere da string
- **Substituição (Replace)**: Altera um caractere da string para outro caractere diferente

### O que é DP bottom-up (programação dinâmica)

É uma técnica que resolve subproblemas recursivos registrando os resultados em uma tabela, começando pelos problemas menores. Diferentemente da memoização recursiva (top-down), não há overhead de chamadas recursivas, e a otimização de espaço é mais fácil de aplicar.

```java
// Exemplo de DP unidimensional: calcular a sequência de Fibonacci com duas variáveis
int a = 0, b = 1;
for (int i = 2; i <= n; i++) {
    int temp = a + b;  // O valor atual depende apenas dos dois valores anteriores
    a = b;             // Descarta o valor antigo e atualiza
    b = temp;
}
```

### O que é Math.min()

É um método padrão de Java que retorna o menor entre dois inteiros. Para comparar três ou mais valores, utiliza-se chamadas aninhadas.

```java
Math.min(3, 5);                    // → 3
Math.min(3, Math.min(5, 1));       // → 1 (valor mínimo entre três valores)
```

### O que é String.charAt(int index)

É um método que retorna o caractere na posição especificada da string. O índice começa em 0.

```java
String s = "abc";
s.charAt(0);  // → 'a'
s.charAt(2);  // → 'c'
```

## Complexidade

| | Valor |
|---|---|
| Time | O(m × n) — Para cada posição de `word1`, percorre todas as posições de `word2` |
| Space | O(n) — Mantém apenas um array de uma linha em vez de uma tabela bidimensional |

## Código

```java
// Entrada: duas strings word1 (comprimento m) e word2 (comprimento n)
// Saída: retorna um int com o número mínimo de operações para transformar word1 em word2
public int minDistance(String w1, String w2) {
    int m = w1.length();  // Obtém o comprimento de word1
    int n = w2.length();  // Obtém o comprimento de word2

    // Array prev: corresponde à linha inferior (i+1) da tabela de DP
    // Inicializado com prev[j] = n - j: quando word1 está vazia, o número de operações é n-j para inserir todos os n-j caracteres restantes de word2[j:]
    int[] prev = new int[n + 1];
    for (int j = 0; j <= n; j++)
        prev[j] = n - j;

    // Percorre word1 em ordem reversa, do final ao início (i é a posição atual em word1)
    for (int i = m - 1; i >= 0; i--) {
        // Array curr: corresponde à linha atual (i) da tabela de DP
        int[] curr = new int[n + 1];
        // Quando word2 está vazia, o número de operações é m-i para excluir todos os m-i caracteres restantes de word1[i:]
        curr[n] = m - i;

        // Percorre word2 em ordem reversa, do final ao início (j é a posição atual em word2)
        for (int j = n - 1; j >= 0; j--) {
            if (w1.charAt(i) == w2.charAt(j)) {
                // Se os caracteres forem iguais, nenhuma operação é necessária. prev[j+1] é a resposta do subproblema dp[i+1][j+1], que avança ambos em um caractere
                curr[j] = prev[j + 1];
            } else {
                // Se forem diferentes, escolhe o menor custo entre as três operações e adiciona 1 pela operação atual (+1)
                curr[j] = 1 + Math.min(
                    curr[j + 1],           // Inserção: avança um caractere no lado de word2 (dp[i][j+1])
                    Math.min(prev[j],      // Exclusão: avança um caractere no lado de word1 (dp[i+1][j])
                        prev[j + 1]));     // Substituição: avança um caractere em ambos os lados (dp[i+1][j+1])
            }
        }
        // Salva a linha atual como linha anterior, preparando para a próxima iteração (i-1)
        prev = curr;
    }

    // prev[0] corresponde a dp[0][0], o número mínimo de operações para transformar word1 inteira em word2 inteira
    return prev[0];
}
```
