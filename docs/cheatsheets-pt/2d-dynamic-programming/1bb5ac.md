# Maximizing Stock Profit With a Cooldown Period — Maximizar o Lucro em Negociação de Ações com Período de Cooldown

## Essência do Problema

Um array de preços de ações `prices` é fornecido. Cada índice representa um dia. É possível comprar e vender ações múltiplas vezes, porém no dia seguinte a uma venda não é permitido negociar devido ao **cooldown**. O objetivo é retornar o **lucro máximo** possível sob essa restrição.

## Ideia Central

Classificamos o estado de cada dia em três categorias: "segurando a ação (hold)", "acabou de vender (sold)" e "em descanso (rest)". Definimos a transição dos três estados do dia anterior para os três estados do dia atual. Como cada dia depende apenas do dia anterior, podemos gerenciar os estados com apenas três variáveis em vez de um array.

## Processo de Raciocínio

1. **Cada dia possui três estados**: Ao final de um dia, estamos em um dos seguintes estados: "segurando a ação (hold)", "vendeu nesse dia (sold)" ou "não fez nada (rest)". Esses três estados cobrem todos os casos possíveis
2. **Definir as transições entre estados**: hold é o maior entre "manter hold do dia anterior sem fazer nada" e "estava em rest no dia anterior e compra hoje". sold é "estava em hold no dia anterior e vende hoje". rest é o maior entre "manter rest do dia anterior sem fazer nada" e "estava em sold no dia anterior e o cooldown terminou". A restrição de cooldown é naturalmente expressa pela regra de que "no dia seguinte a sold não é possível transicionar para hold"
3. **Definir o estado inicial**: Se comprarmos no dia 0, hold = -prices[0] (o lucro fica negativo). Como não é possível vender nem descansar no dia 0, definimos sold = Integer.MIN_VALUE (significa que esse estado ainda não foi alcançado) e rest = 0 (se não fizermos nada, o lucro é 0)
4. **Cada dia depende apenas do estado do dia anterior**: Observando as fórmulas de transição, cada estado do dia atual é calculado apenas a partir dos três estados do dia anterior. Ou seja, não é necessário manter um array para todos os dias; basta atualizar três variáveis diariamente
5. **A atualização simultânea é necessária**: Como hold, sold e rest do dia atual são todos calculados a partir dos valores do dia anterior, armazenamos os novos valores em variáveis temporárias e depois sobrescrevemos as variáveis anteriores de uma vez. Se sobrescrevermos sequencialmente, os valores do dia anterior que ainda precisam ser usados nos cálculos serão perdidos
6. **O que retornar no final**: Como terminar o último dia segurando uma ação não é ótimo, o lucro máximo é o maior entre prevSold e prevRest

## Conhecimentos Prévios

### O que é uma Máquina de Estados (State Machine)

É um modelo composto por um número finito de estados e regras de transição entre eles. Em cada momento, o sistema está necessariamente em um único estado e transiciona para outro estado conforme a entrada. Neste problema, modelamos a negociação como uma máquina de estados com três estados: hold / sold / rest.

```
rest ---(comprar)---> hold
hold ---(vender)---> sold
sold ---(esperar)---> rest (cooldown)
hold ---(manter)---> hold
rest ---(manter)---> rest
```

### O que é Math.max

É um método que retorna o maior entre dois inteiros. Quando há múltiplas opções em uma transição de estado, ele é utilizado para escolher a opção com maior lucro.

```java
Math.max(3, 7);    // → 7 (retorna o maior)
Math.max(-5, -2);  // → -2 (retorna o maior mesmo entre números negativos)
```

### O que é Integer.MIN_VALUE

É o menor valor que o tipo int do Java pode representar (-2.147.483.648). É utilizado para indicar que "esse estado ainda não foi alcançado". Como qualquer valor comparado com ele via Math.max nunca o selecionará, podemos ignorar com segurança os estados não alcançados.

```java
int x = Integer.MIN_VALUE;  // Representa um estado que ainda não foi alcançado
Math.max(x, 0);             // → 0 (o estado não alcançado não é selecionado)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer o array uma única vez |
| Space | O(1) — Os estados são gerenciados com apenas três variáveis |

## Código

```java
// Entrada: array de inteiros prices (cada elemento é o preço da ação naquele dia)
// Saída: retorna o lucro máximo como int, respeitando a restrição de cooldown
public int maxProfit(int[] prices) {
    int n = prices.length;
    // São necessários pelo menos 2 dias para negociar. Se n < 2, não há negociação possível, então retorna 0
    if (n < 2) return 0;

    // Inicializar os estados do dia 0
    int prevHold = -prices[0];          // Lucro ao comprar no dia 0 (é negativo pois é uma despesa)
    int prevSold = Integer.MIN_VALUE;   // Não é possível vender no dia 0 (representa estado não alcançado)
    int prevRest = 0;                   // Se não fizer nada, o lucro é 0

    for (int i = 1; i < n; i++) {
        // Calcular os 3 estados do dia atual a partir dos 3 estados do dia anterior
        // newHold: o maior entre "manter a posse (prevHold)" e "estava em descanso e compra hoje (prevRest - prices[i])"
        // Nota: "estava em sold e compra hoje" não é uma opção. Isso expressa a restrição de cooldown
        int newHold = Math.max(prevHold,
            prevRest - prices[i]);

        // newSold: vender a ação que estava segurando hoje. A venda só pode transicionar a partir de hold, então Math.max não é necessário
        int newSold = prevHold + prices[i];

        // newRest: o maior entre "manter descanso (prevRest)" e "vendeu no dia anterior e o cooldown terminou (prevSold)"
        int newRest = Math.max(prevRest,
            prevSold);

        // Atualizar todas as variáveis de uma vez após calcular todos os valores
        // Para não sobrescrever os valores do dia anterior durante o cálculo, calculamos os três novos valores antes de atribuí-los
        prevHold = newHold;
        prevSold = newSold;
        prevRest = newRest;
    }
    // Terminar o último dia segurando a ação (prevHold) não é ótimo, pois o lucro não foi realizado
    // O lucro máximo é o maior entre sold e rest
    return Math.max(prevSold, prevRest);
}
```
