# Finding the Subarray With Maximum Sum — Encontrar o subarray contíguo com a maior soma

## Essência do problema

Um array de inteiros `nums` é fornecido. O array pode conter tanto números positivos quanto negativos. O objetivo é encontrar, entre todos os subarrays contíguos, aquele cuja soma dos elementos é a maior, e retornar essa **soma**.

## Ideia central

Ao alcançar cada elemento, existem apenas duas opções: "estender o subarray acumulado até agora" ou "iniciar um novo subarray a partir deste elemento". Se a soma acumulada até o momento for negativa, descartá-la e começar do zero sempre será mais vantajoso do que carregá-la adiante.

## Processo de raciocínio

1. **Existem apenas duas escolhas em cada elemento**: Ao alcançar o elemento `nums[i]`, as ações possíveis são apenas duas: "adicionar `nums[i]` ao subarray anterior para estendê-lo" ou "iniciar um novo subarray com `nums[i]` como primeiro elemento". Devido à restrição de subarray contíguo, não é possível pular elementos intermediários
2. **Critério para decidir entre estender ou começar do zero**: Se a soma acumulada `currentSum` até o momento anterior for positiva, somá-la a `nums[i]` resulta em um valor maior do que `nums[i]` sozinho, portanto o subarray deve ser estendido. Se `currentSum` for negativa, somá-la diminui o valor em relação a `nums[i]` sozinho, portanto deve-se descartá-la e começar um novo subarray. Ou seja, basta escolher o maior entre `currentSum + nums[i]` e `nums[i]`
3. **Expressar essa decisão com `Math.max`**: A linha `currentSum = Math.max(currentSum + nums[i], nums[i])` completa a decisão entre estender e começar do zero. `currentSum + nums[i]` corresponde à extensão, e `nums[i]` corresponde ao início de um novo subarray
4. **Rastrear o valor máximo global separadamente**: `currentSum` representa "a soma do subarray atual" e seu valor sobe e desce durante a varredura. Como o problema pede "a maior soma ao longo de todo o array", uma variável separada `maxSum` registra continuamente o valor máximo de `currentSum` encontrado durante a varredura
5. **Inicializar `maxSum` com `Integer.MIN_VALUE`**: Para que o algoritmo funcione corretamente mesmo quando todos os elementos do array forem negativos, o valor inicial de `maxSum` deve ser o menor inteiro possível. Se for inicializado com 0, quando todos os elementos forem negativos, o algoritmo interpretará erroneamente que "o subarray vazio (soma 0)" é o máximo
6. **Retornar `maxSum` ao final**: Quando a varredura do array termina, `maxSum` contém a maior soma entre todos os subarrays contíguos. Esse valor é retornado

## Conhecimentos prévios

### O que é Math.max

É um método padrão do Java que recebe dois valores e retorna o maior deles. Permite expressar uma ramificação condicional em uma única linha.

```java
Math.max(5, 3);       // Retorna o maior dos dois valores → 5
Math.max(-2, -7);     // Retorna o maior mesmo entre números negativos → -2
Math.max(a + b, b);   // Também é possível comparar resultados de expressões
```

### O que é Integer.MIN_VALUE

É uma constante que representa o menor valor do tipo `int` em Java (-2.147.483.648). É usada como valor inicial no estado de "ainda não comparou nada". Ao comparar com qualquer inteiro usando `Math.max`, o outro valor sempre será escolhido.

```java
int maxSum = Integer.MIN_VALUE;   // Inicializa com o menor valor do tipo int
maxSum = Math.max(maxSum, -5);    // Qualquer valor é maior que maxSum → -5
```

### O que é um subarray contíguo

É uma parte do array formada por elementos adjacentes extraídos sem interrupção. Não é permitido selecionar elementos pulando posições.
Exemplo: quando `nums = [-2, 1, -3, 4, -1, 2]`, `[4, -1, 2]` é um subarray contíguo (soma 5). `[1, 4, 2]` não é um subarray contíguo porque os elementos não são adjacentes.

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer o array uma única vez |
| Space | O(1) — Apenas duas variáveis são utilizadas: `maxSum` e `currentSum` |

## Código

```java
// Entrada: array de inteiros nums que pode conter números positivos e negativos
// Saída: retorna como int o valor máximo da soma de um subarray contíguo
public int maxSubArray(int[] nums) {
    // Variável que registra a maior soma de subarray encontrada ao longo de toda a varredura
    // Inicializada com Integer.MIN_VALUE para selecionar corretamente o máximo mesmo quando todos os elementos forem negativos
    // Atenção: se inicializar com 0, quando todos os elementos forem negativos, o algoritmo interpretará erroneamente que "o subarray vazio (soma 0)" é o máximo
    int maxSum = Integer.MIN_VALUE;
    // Variável que mantém a soma do subarray em construção. No início da varredura, nenhum elemento foi incluído ainda, portanto é 0
    int currentSum = 0;

    // Percorre o array do início ao fim, um elemento por vez
    for (int num : nums) {
        // currentSum + num é "a soma caso o subarray anterior seja estendido"
        // num é "a soma caso um novo subarray comece a partir deste elemento"
        // Ao escolher o maior dos dois, a decisão ótima é sempre tomada
        currentSum = Math.max(currentSum + num, num);
        // Se a soma do subarray atual superar o máximo registrado até agora, atualiza; caso contrário, mantém
        maxSum = Math.max(maxSum, currentSum);
    }
    // Ao final da varredura, maxSum contém a maior soma entre todos os subarrays contíguos
    return maxSum;
}
```
