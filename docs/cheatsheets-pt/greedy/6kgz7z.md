# Finding the Minimum Jumps to Reach the End — Encontrar o número mínimo de saltos para alcançar o final do array

## Essência do problema

Dado um array de inteiros `nums`, cada elemento `nums[i]` representa o número máximo de posições que se pode saltar a partir daquela posição. Começando no índice 0, retorne o **número mínimo de saltos** necessário para alcançar o último índice. É garantido que sempre é possível alcançar o final.

## Ideia central

Cada salto é tratado como "o intervalo (janela) alcançável com um único salto". Cada vez que se atinge a borda da janela, o número de saltos é incrementado em 1. Ao percorrer o interior da janela e registrar o ponto mais distante alcançável da próxima janela, obtém-se o mesmo efeito de uma busca por nível em BFS com espaço O(1).

## Processo de raciocínio

1. **Problemas de contagem mínima podem ser resolvidos com BFS**: Ao considerar cada posição como um nó e o alcance de salto como arestas, o problema se torna encontrar o caminho mais curto do índice 0 até o final. Como BFS explora nível por nível, o primeiro nível a alcançar o final corresponde ao número mínimo de saltos
2. **Representar os níveis de BFS como janelas**: BFS convencional usa uma fila e consome O(n) de espaço. Porém, em saltos sobre arrays, o intervalo alcançável em cada nível forma um segmento contíguo, portanto apenas o limite do segmento `currentEnd` é necessário para representar o nível atual
3. **Rastrear o ponto mais distante alcançável dentro da janela**: Ao percorrer a janela atual (do `currentEnd` anterior até o `currentEnd` atual), registra-se na variável `farthest` o valor máximo de `i + nums[i]` para cada posição `i`. Esse valor se torna o limite da próxima janela
4. **Confirmar o salto na borda da janela**: Quando o índice `i` atinge `currentEnd`, significa que a janela atual foi completamente utilizada. Nesse momento, o número de saltos é incrementado em 1 e `currentEnd` é atualizado para `farthest`, avançando para a próxima janela
5. **O loop vai até uma posição antes do final**: Ao iterar com `i < nums.length - 1`, evita-se contar um salto extra ao alcançar o último índice. Como é garantido que o final pode ser alcançado, não é necessária uma verificação de alcance
6. **O que é retornado ao final**: Após o término do loop, retorna-se o número mínimo de saltos acumulado na variável `jumps`

## Conhecimentos prévios

### O que é Greedy BFS (Busca em largura gulosa)

BFS (Busca em Largura) é um algoritmo que encontra o caminho mais curto do ponto de partida até cada nó em um grafo. Normalmente utiliza uma fila, mas em problemas de saltos em arrays, como o intervalo alcançável forma um segmento contíguo, o mesmo resultado pode ser obtido com uma abordagem gulosa que gerencia apenas os limites do segmento. Ao escolher de forma gulosa o ponto mais distante alcançável em cada nível (equivalente a um salto), obtém-se o número mínimo de saltos.

### O que é Math.max

É um método padrão de Java que retorna o maior entre dois inteiros. É utilizado para comparar o ponto mais distante atual com um novo ponto calculado e manter o mais distante.

```java
Math.max(3, 7);       // Retorna o maior entre dois valores → 7
Math.max(farthest, i + nums[i]);  // Compara o ponto mais distante atual com o novo ponto alcançável
```

### O que é janela (intervalo de salto)

É o segmento contíguo de índices alcançáveis com um único salto. A variável `currentEnd` representa a borda direita da janela. Quando `i` atinge `currentEnd`, significa que a janela atual foi completamente utilizada e um próximo salto é necessário.
Exemplo: Para `nums = [2,3,1,1,4]`, a primeira janela é `[1,2]` (até 2 posições a partir do índice 0), e a próxima janela é `[3,4]` (até o ponto mais distante 4 alcançável dentro da janela).

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer o array uma única vez |
| Space | O(1) — Utiliza apenas 3 variáveis, sem necessidade de estruturas de dados adicionais |

## Código

```java
// Entrada: array de inteiros nums (cada elemento é o comprimento máximo de salto a partir daquela posição)
// Saída: retorna um int com o número mínimo de saltos para alcançar o último índice
public int jump(int[] nums) {
    // Variável que registra o número de saltos. Incrementada em 1 cada vez que a borda da janela é atingida
    int jumps = 0;
    // Borda direita da janela de salto atual. Inicializada com 0 pois começa no índice 0
    int currentEnd = 0;
    // Índice mais distante alcançável a partir da janela. Usado para determinar a borda direita da próxima janela
    int farthest = 0;

    // Percorre até uma posição antes do final. Ao alcançar o final, o objetivo é atingido, então não é necessário saltar mais
    for (int i = 0; i < nums.length - 1; i++) {
        // i + nums[i] é o índice de destino ao realizar o salto máximo a partir da posição i
        // Atualiza se for mais distante que o farthest atual
        farthest = Math.max(farthest, i + nums[i]);

        // Se atingiu a borda direita da janela atual, o próximo salto é necessário
        if (i == currentEnd) {
            // Incrementa o número de saltos em 1
            jumps++;
            // Define a borda direita da próxima janela como farthest. O intervalo da próxima janela vai de currentEnd+1 até o novo currentEnd
            currentEnd = farthest;
        }
    }
    // Retorna o número mínimo de saltos acumulado
    return jumps;
}
```
