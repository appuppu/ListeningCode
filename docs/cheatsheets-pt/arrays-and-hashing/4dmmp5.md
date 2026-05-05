# Validating a Sudoku Board — Determinar se um tabuleiro Sudoku 9×9 é válido

## Essência do problema

Um tabuleiro de Sudoku representado por uma matriz bidimensional de caracteres 9×9 é fornecido. O programa determina que o tabuleiro é válido e retorna `true` se nenhuma linha, coluna ou subgrade 3×3 contiver números duplicados. Células vazias são representadas por um ponto `.`. O tabuleiro não precisa estar completo; o programa apenas verifica se a disposição atual não viola as regras.

## Ideia central

O programa percorre o tabuleiro inteiro uma única vez e determina que ele é inválido se o número de qualquer célula já tiver aparecido na mesma linha, na mesma coluna ou na mesma caixa 3×3. O índice da caixa à qual uma célula arbitrária `(i, j)` pertence pode ser mapeado de forma única para um valor de 0 a 8 pela fórmula `(i/3) * 3 + j/3`.

## Processo de raciocínio

1. **Organizar as condições a serem verificadas**: A validade do Sudoku é determinada por três condições: "sem duplicatas em cada linha", "sem duplicatas em cada coluna" e "sem duplicatas em cada caixa 3×3". Verificar essas três condições simultaneamente é eficiente
2. **HashSet é adequado para detecção de duplicatas**: O HashSet é ideal para determinar em O(1) se um número já apareceu. Preparando 9 HashSets por linha, 9 por coluna e 9 por caixa, totalizando 27 HashSets, o programa pode verificar as três condições simultaneamente
3. **O mapeamento de célula para caixa é necessário**: É preciso calcular a qual caixa a célula `(i, j)` pertence. Na direção das linhas, `i/3` (divisão inteira) divide em 3 grupos: 0, 1, 2. Na direção das colunas, `j/3` divide em 3 grupos: 0, 1, 2. Para converter isso em um índice unidimensional, utiliza-se `(i/3) * 3 + j/3`. Dessa forma, as 9 caixas correspondem aos números de 0 a 8
4. **Verificar todas as condições em uma única passagem**: O programa percorre o tabuleiro inteiro com um laço for duplo e realiza a verificação e o registro de duplicatas nos três Sets para cada célula referentes à linha, coluna e caixa. Pontos são ignorados porque não são números
5. **Retornar false imediatamente quando uma duplicata é encontrada**: Se qualquer um dos três Sets já contiver o mesmo número, o tabuleiro é inválido e o programa retorna `false` imediatamente
6. **Retornar true após percorrer todas as células**: Se nenhuma duplicata for encontrada, o tabuleiro é válido

## Conhecimentos prévios

### O que é um HashSet

É uma estrutura de dados que gerencia um conjunto de elementos sem duplicatas. A adição de elementos e a verificação de existência podem ser feitas em O(1). Neste caso, ele é utilizado para determinar rapidamente se um determinado número já apareceu.

```java
Set<Character> set = new HashSet<>();  // Criar um HashSet vazio
set.add('5');            // Adicionar o elemento '5'
set.contains('5');       // Verificar se o elemento '5' existe, retornando boolean → true
set.contains('3');       // Verificar se o elemento '3' existe, retornando boolean → false
```

### Como criar um array de HashSets

O programa gerencia 9 HashSets juntos como um array. Como não é possível criar diretamente um array de genéricos, um array de tipo bruto é criado com `new HashSet[9]`, e cada elemento é inicializado em um laço.

```java
Set<Character>[] sets = new HashSet[9];  // Alocar um array para 9 elementos
for (int i = 0; i < 9; i++) {
    sets[i] = new HashSet<>();           // Inicializar cada elemento com um HashSet vazio
}
```

### Fórmula de cálculo do índice da caixa

`boxIdx = (i/3) * 3 + j/3` retorna o número (0 a 8) da caixa 3×3 à qual a célula `(i, j)` pertence. `i/3` representa a posição da caixa na direção das linhas (0, 1, 2) e `j/3` representa a posição da caixa na direção das colunas (0, 1, 2). Multiplicando a posição na direção das linhas por 3 e somando a posição na direção das colunas, um número único é atribuído a cada uma das 9 caixas.

```
Disposição dos números das caixas:
0 | 1 | 2
3 | 4 | 5
6 | 7 | 8

Exemplo: Célula(4, 7) → (4/3)*3 + 7/3 = 1*3 + 2 = 5 → Pertence à caixa 5
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n²) — O tabuleiro inteiro 9×9 é percorrido uma vez (como n=9 é fixo, também pode ser considerado O(81)=O(1)) |
| Space | O(n²) — No máximo 81 elementos são armazenados em 27 HashSets |

## Código

```java
// Entrada: matriz bidimensional de caracteres 9×9 board (dígitos '1' a '9' ou ponto '.')
// Saída: retorna true se o tabuleiro for válido, false se for inválido
public boolean isValidSudoku(char[][] board) {
    // Criar arrays de HashSets para registrar os números que apareceram em cada linha, coluna e caixa
    // rowset[i] registra os números da linha i, columnset[j] os da coluna j, boxset[k] os da caixa k
    Set<Character>[] rowset = createSets();
    Set<Character>[] columnset = createSets();
    Set<Character>[] boxset = createSets();

    // O laço externo percorre as linhas e o interno percorre as colunas, visitando todas as 81 células uma vez
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            // Obter o valor da célula atual
            char c = board[i][j];
            // Ignorar pontos porque são células vazias (não são números)
            if (c == '.') {
                continue;
            }

            // Calcular o número da caixa à qual a célula (i, j) pertence (correspondência única de 0 a 8)
            int boxIdx = (i / 3) * 3 + j / 3;

            // Retornar false imediatamente se o mesmo número já existir na linha, coluna ou caixa (duplicata)
            if (rowset[i].contains(c) || columnset[j].contains(c) || boxset[boxIdx].contains(c)) {
                return false;
            }

            // Se não houver duplicata, registrar o número atual nos três Sets para detecção futura de duplicatas
            rowset[i].add(c);
            columnset[j].add(c);
            boxset[boxIdx].add(c);
        }
    }
    // Se nenhuma duplicata for encontrada após percorrer todas as células, o tabuleiro é válido
    return true;
}

// Método auxiliar que cria um array contendo 9 HashSets vazios
public Set<Character>[] createSets() {
    Set<Character>[] sets = new HashSet[9];
    for (int i = 0; i < 9; i++) {
        sets[i] = new HashSet<>();
    }
    return sets;
}
```
