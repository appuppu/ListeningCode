# Finding the Best Time to Buy and Sell a Stock — Encontrar o lucro máximo obtido com uma única transação de compra e venda a partir de um array de preços de ações

## Essência do Problema

Um array de inteiros `prices` é fornecido. Cada elemento `prices[i]` representa o preço da ação no dia `i`. Sob a condição de que apenas uma operação de "compra → venda" pode ser realizada, o programa deve retornar o **lucro máximo** possível. Se não for possível obter lucro, o programa retorna `0`. O dia da compra deve ser anterior ao dia da venda.

## Ideia Central

Ao percorrer o array da esquerda para a direita e registrar continuamente o "menor preço encontrado até o momento", basta subtrair o menor preço do preço de cada dia para obter o lucro máximo caso a venda fosse feita naquele dia, em O(1). A resposta é o valor máximo desse lucro considerando todos os dias.

## Processo de Raciocínio

1. **O lucro é determinado por "preço de venda − preço de compra"**: Ao vender em um determinado dia, para maximizar o lucro, o preço de compra deve ser o menor possível. Ou seja, basta comprar pelo menor preço entre todos os dias anteriores ao dia da venda
2. **Queremos calcular eficientemente o "menor preço anterior" para cada dia**: Ao percorrer o array da esquerda para a direita, rastreamos o valor mínimo dos preços vistos até agora com a variável `minPrice`. Como basta atualizar `minPrice` a cada novo preço, não é necessário um array adicional e o espaço utilizado é O(1)
3. **Calculamos o "lucro caso a venda fosse feita" para cada dia**: Para cada dia `i` durante a varredura, `prices[i] - minPrice` é o lucro máximo caso a venda fosse feita naquele dia. Esse valor é comparado com a variável `maxProfit` e, se for maior, `maxProfit` é atualizado
4. **Organizamos a relação entre a atualização de minPrice e o cálculo do lucro**: Se o preço atual for menor que `minPrice`, atualizamos `minPrice`. Como vender neste dia resultaria em lucro negativo, o cálculo do lucro é desnecessário. Se o preço atual for maior ou igual a `minPrice`, calculamos o lucro e atualizamos `maxProfit`
5. **Tratamento do caso sem lucro**: Se os preços das ações forem monotonicamente decrescentes, `maxProfit` permanece com o valor inicial `0` sem ser atualizado. O valor `0` é retornado naturalmente sem necessidade de condição adicional
6. **O que é retornado ao final**: O valor de `maxProfit` ao término da varredura única do array é retornado. Este é o lucro máximo obtido com uma única transação de compra e venda

## Conhecimentos Prévios

### O que é Integer.MAX_VALUE

É o valor máximo que o tipo `int` do Java pode armazenar (2.147.483.647). É utilizado como valor inicial em algoritmos que buscam o mínimo. Como é garantidamente maior do que qualquer preço de ação, na primeira comparação ele é substituído pelo preço real da ação.

```java
int minPrice = Integer.MAX_VALUE;  // Define um valor suficientemente grande como valor inicial para o mínimo
// Se prices[0] for 7, por exemplo, como 7 < Integer.MAX_VALUE, minPrice é atualizado para 7
```

### O que é Math.max

É um método estático que recebe dois valores `int` e retorna o maior deles. Permite escrever a lógica de atualização do valor máximo em uma única linha.

```java
int a = 5;
int b = 3;
Math.max(a, b);  // → retorna 5

// Utilizado para atualizar o lucro máximo
maxProfit = Math.max(maxProfit, profit);  // Se profit for maior, maxProfit é atualizado
```

### O que é Running Minimum (rastreamento do mínimo durante a varredura)

É uma técnica que rastreia o valor mínimo dos elementos vistos até o momento usando uma variável enquanto percorre o array. Em cada passo, o elemento atual é comparado com a variável, e a variável é atualizada com o menor valor. Isso permite obter "o valor mínimo até a posição atual" em O(1) para qualquer posição.

```java
int minPrice = Integer.MAX_VALUE;
for (int price : prices) {
    if (price < minPrice) {
        minPrice = price;  // Atualiza o menor preço encontrado até o momento
    }
    // Neste ponto, minPrice contém o valor mínimo entre prices[0] e prices[atual]
}
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer o array uma única vez |
| Space | O(1) — Utiliza apenas duas variáveis (minPrice, maxProfit) |

## Código

```java
// Entrada: array de inteiros prices (cada elemento é o preço da ação em um dia)
// Saída: retorna o lucro máximo obtido com uma única transação como int. Retorna 0 se não houver lucro
public int maxProfit(int[] prices) {
    // Variável que rastreia o menor preço encontrado até o momento. Inicializada com Integer.MAX_VALUE para garantir que o primeiro preço sempre atualize o valor
    int minPrice = Integer.MAX_VALUE;
    // Variável que rastreia o lucro máximo encontrado até o momento. Inicializada com 0 para que, no caso de não haver lucro, o valor 0 seja retornado naturalmente
    int maxProfit = 0;

    // Percorre o array do início ao fim, um elemento por vez, usando um loop for-each
    for (int price : prices) {
        if (price < minPrice) {
            // Se o preço atual for menor que o menor preço, atualiza o menor preço
            // Este dia é o dia de atualização do menor preço, portanto vender neste dia não geraria lucro (o lucro seria negativo). Por isso, o cálculo do lucro é ignorado
            minPrice = price;
        } else {
            // Calcula o lucro caso a compra tenha sido feita no dia do menor preço e a venda seja feita hoje
            int profit = price - minPrice;
            // Se o lucro superar o máximo registrado até o momento, atualiza o lucro máximo
            maxProfit = Math.max(maxProfit, profit);
        }
    }
    // O maxProfit ao término do loop é o lucro máximo considerando todo o array
    return maxProfit;
}
```
