# Placing N Queens on a Board Without Conflicts — Posicionar N rainhas sem conflitos

## Essência do problema

Um inteiro `n` é fornecido. O objetivo é posicionar n rainhas em um tabuleiro de xadrez n×n de modo que nenhum par de rainhas esteja na mesma linha, na mesma coluna ou na mesma diagonal. O programa deve retornar todas as configurações válidas do tabuleiro como uma lista de strings.

## Ideia central

Se posicionarmos uma rainha por linha, os conflitos de linha são eliminados automaticamente. Os conflitos restantes — de coluna, diagonal positiva e diagonal negativa — podem ser gerenciados por cada bit de uma bitmask, permitindo verificação de conflitos e atualização de estado em tempo constante O(1).

## Processo de raciocínio

1. **Eliminar conflitos de linha estruturalmente**: Como n rainhas são posicionadas em n linhas, colocando exatamente uma rainha por linha, conflitos de linha não ocorrem. Portanto, o problema se reduz a uma busca para decidir em qual coluna posicionar a rainha em cada linha
2. **Detectar conflitos de coluna e diagonal**: Conflitos de coluna podem ser gerenciados por um conjunto de colunas já utilizadas. Conflitos de diagonal se dividem em dois tipos: diagonal positiva (direção superior direita, onde row + col é igual) e diagonal negativa (direção superior esquerda, onde row - col é igual). Gerenciando esses três conjuntos, todos os conflitos podem ser detectados
3. **Representar conjuntos com bitmasks**: O estado de uso de colunas, diagonais positivas e diagonais negativas é representado por bits de um inteiro. Se o bit c estiver em 1, significa que aquela coluna (ou diagonal) já está em uso. A operação AND verifica conflitos e a operação OR registra o uso, operando mais rápido que um HashSet
4. **Deslocar bitmasks de diagonais a cada linha**: Quando descemos uma linha, a área de influência da diagonal positiva se desloca uma coluna para a esquerda, então aplicamos um deslocamento à esquerda (`<< 1`). A diagonal negativa se desloca uma coluna para a direita, então aplicamos um deslocamento à direita (`>> 1`). Dessa forma, a verificação de conflitos de diagonais pode ser feita apenas pela posição do bit da coluna
5. **Explorar todas as soluções com backtracking**: Da linha 0 até a linha n-1, testamos colunas sem conflito em cada linha. Se uma coluna sem conflito for encontrada, posicionamos a rainha e fazemos a recursão para a próxima linha. Ao alcançar a linha n, registramos uma solução. Ao retornar da recursão, o posicionamento é desfeito automaticamente, permitindo testar outra coluna
6. **Retornar o número total de soluções**: O programa soma e retorna o número de vezes em que todas as linhas receberam uma rainha (ou seja, o número de vezes que row == n foi alcançado)

## Conhecimentos prévios

### O que é backtracking

Backtracking é uma técnica de busca que tenta uma opção, e quando chega a um beco sem saída, retorna à escolha anterior e tenta outra opção. Utilizando chamadas recursivas, o ciclo "tentar → avançar → retroceder" é realizado naturalmente. É adequado para problemas que exigem a enumeração de todas as combinações válidas.

```java
void backtrack(int step) {
    if (step == goal) {       // Ao alcançar o objetivo, registra a solução
        recordSolution();
        return;
    }
    for (int choice : choices) {
        if (isValid(choice)) {    // Se a escolha for válida, tenta
            apply(choice);        // Aplica a escolha
            backtrack(step + 1);  // Faz recursão para o próximo passo
            undo(choice);         // Desfaz a escolha e tenta outra opção
        }
    }
}
```

### O que é bitmask

Bitmask é uma técnica que utiliza cada bit de um inteiro como um flag indicando a presença ou ausência de um elemento em um conjunto. As operações de conjunto podem ser realizadas de forma eficiente com operações bit a bit.

```java
int mask = 0;             // Conjunto vazio (todos os bits são 0)
int bit = 1 << c;         // Cria um valor com apenas o bit c em 1 (representa o elemento c)
mask |= bit;              // Adiciona o elemento c ao conjunto (define o bit c como 1)
(mask & bit) != 0;        // Verifica se o elemento c está contido no conjunto → true/false
```

### Rastreamento de diagonais por deslocamento de bits

Quando descemos uma linha no tabuleiro de xadrez, a influência da diagonal positiva (direção superior direita ↗) se desloca uma coluna para a esquerda, e a influência da diagonal negativa (direção superior esquerda ↖) se desloca uma coluna para a direita. Esse deslocamento é representado pelo shift da bitmask.

```java
int posDiag = 0;          // Bitmask que gerencia o uso das diagonais positivas
posDiag |= (1 << c);      // Registra a diagonal positiva da rainha posicionada na coluna c
posDiag << 1;              // Na próxima linha, a influência se desloca uma coluna para a esquerda (shift à esquerda)

int negDiag = 0;          // Bitmask que gerencia o uso das diagonais negativas
negDiag |= (1 << c);      // Registra a diagonal negativa da rainha posicionada na coluna c
negDiag >> 1;              // Na próxima linha, a influência se desloca uma coluna para a direita (shift à direita)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n!) — O número de colunas disponíveis em cada linha diminui no máximo como n, n-1, n-2, ... |
| Space | O(n) — A profundidade da recursão é de n níveis, e cada nível utiliza apenas um número constante de inteiros para as bitmasks |

## Código

```java
// Entrada: inteiro n (tamanho do tabuleiro de xadrez e número de rainhas a posicionar)
// Saída: retorna como int o número total de configurações válidas para posicionar n rainhas sem conflitos
int totalNQueens(int n) {
    // Inicia a busca a partir da linha 0 e inicializa as bitmasks de colunas, diagonais positivas e diagonais negativas como vazias (0)
    return backtrack(0, n, 0, 0, 0);
}

int backtrack(int row, int n,
    int cols, int posDiag,
    int negDiag) {
    // Todas as linhas receberam uma rainha, então uma solução foi encontrada
    if (row == n) return 1;

    // Variável que acumula o número de soluções encontradas a partir desta linha
    int count = 0;

    // Percorre as colunas de 0 a n-1 e verifica se é possível posicionar uma rainha em cada coluna
    for (int c = 0; c < n; c++) {
        // Cria o bit correspondente à coluna c. Esse bit é usado para verificar conflitos com as três bitmasks
        int bit = 1 << c;

        // Se houver conflito com coluna, diagonal positiva ou diagonal negativa, pula para a próxima coluna
        if ((cols & bit) != 0 ||
            (posDiag & bit) != 0 ||
            (negDiag & bit) != 0)
            continue;

        // Posiciona a rainha na coluna c, atualiza as três bitmasks e faz recursão para a próxima linha
        // cols | bit: registra a coluna c como utilizada
        // (posDiag | bit) << 1: registra a diagonal positiva e reflete o deslocamento para a próxima linha com shift à esquerda
        // (negDiag | bit) >> 1: registra a diagonal negativa e reflete o deslocamento para a próxima linha com shift à direita
        // Como as bitmasks são passadas por valor, ao retornar da recursão o estado anterior é restaurado automaticamente, sem necessidade de desfazer explicitamente
        count += backtrack(row + 1, n,
            cols | bit,
            (posDiag | bit) << 1,
            (negDiag | bit) >> 1);
    }
    // Retorna o número total de soluções após testar todas as colunas
    return count;
}
```
