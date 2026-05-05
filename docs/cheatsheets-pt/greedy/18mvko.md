# Finding the Starting Gas Station for a Circular Route — Encontrar o Posto de Gasolina Inicial para Completar uma Rota Circular

## Essência do Problema

São dados dois arrays de inteiros de comprimento `n`: `gas` e `cost`. `gas[i]` representa o combustível obtido no posto `i`, e `cost[i]` representa o combustível necessário para se deslocar do posto `i` até o próximo posto. O objetivo é retornar o índice do posto inicial a partir do qual é possível completar a rota circular. Se não existir nenhum posto que permita completar o circuito, retorna-se `-1`. Existe no máximo uma solução.

## Ideia Central

Se a soma total do balanço de combustível de todos os postos for não negativa, então a solução certamente existe. Como os postos até o ponto em que o combustível acumulado se torna negativo não podem ser o ponto de partida, basta reiniciar a partir do próximo posto como novo candidato a ponto de partida, e a resposta é encontrada em uma única varredura.

## Processo de Raciocínio

1. **Considerar o balanço de combustível de cada posto**: No posto `i`, obtém-se `gas[i]` de combustível e consome-se `cost[i]`, portanto a variação líquida de combustível é expressa por `net = gas[i] - cost[i]`. Se `net` for positivo, esse posto gera excedente de combustível; se for negativo, gera déficit de combustível
2. **Determinar a condição para completar o circuito**: Se a soma de `net` de todos os postos (`totalBalance`) for não negativa, o combustível total obtido na rota é maior ou igual ao consumido, logo é possível completar o circuito a partir de algum ponto de partida. Por outro lado, se `totalBalance` for negativo, o combustível é insuficiente independentemente do ponto de partida, e a solução não existe
3. **Restringir eficientemente os candidatos a ponto de partida**: Suponha que, partindo do posto `start`, ao avançar a varredura, o combustível acumulado (`currentBalance`) se torne negativo em algum ponto `i`. Nesse caso, partindo de qualquer posto entre `start` e `i`, não é possível ultrapassar o ponto `i`. Isso ocorre porque a soma acumulada de `start` até um posto intermediário `j` era não negativa, de modo que, partindo de `j`, chega-se ao ponto `i` com ainda menos combustível. Portanto, todos os postos de `start` até `i` são excluídos de uma só vez, e `i + 1` se torna o novo candidato a ponto de partida
4. **Reiniciar currentBalance e continuar a varredura**: Para rastrear o combustível acumulado a partir do novo candidato `i + 1`, reinicia-se `currentBalance` para `0` e atualiza-se `start` para `i + 1`. A varredura em si é realizada apenas uma vez, do início ao fim
5. **Após a varredura, realizar a verificação final com totalBalance**: Ao término da varredura, se `totalBalance >= 0`, a solução existe e retorna-se `start`. Se `totalBalance < 0`, o circuito é impossível e retorna-se `-1`

## Conhecimentos Prévios

### net (variação líquida de combustível)

É o balanço de combustível em cada posto. Calcula-se por `net = gas[i] - cost[i]`. Se for positivo, significa que há excedente de combustível; se for negativo, significa que há déficit de combustível.

```java
int net = gas[i] - cost[i];  // Calcular o balanço de combustível no posto i
// Exemplo: quando gas[i]=3, cost[i]=5, net=-2 (déficit de 2 unidades de combustível)
// Exemplo: quando gas[i]=4, cost[i]=1, net=3 (excedente de 3 unidades de combustível)
```

### Papel de totalBalance e currentBalance

`totalBalance` é a soma total do balanço de combustível de toda a rota e é usado para determinar se é possível completar o circuito. `currentBalance` é o combustível acumulado desde o candidato atual a ponto de partida até o posto em análise e é usado para determinar se o candidato deve ser atualizado.

```java
int totalBalance = 0;    // Soma total do balanço de combustível da rota (para verificar se o circuito é possível)
int currentBalance = 0;  // Combustível acumulado desde o candidato atual a ponto de partida (para atualizar o candidato)
totalBalance += net;     // Sempre acumulado para todos os postos
currentBalance += net;   // Reiniciado para 0 cada vez que o candidato a ponto de partida é atualizado
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta uma única varredura do array |
| Space | O(1) — Utilizam-se apenas 3 variáveis, independentemente do tamanho da entrada |

## Código

```java
// Entrada: array de inteiros gas (combustível obtido em cada posto) e array de inteiros cost (combustível necessário para ir de cada posto ao próximo)
// Saída: retorna como int o índice do posto inicial a partir do qual é possível completar a rota circular. Retorna -1 se não for possível completar o circuito
public int canCompleteCircuit(int[] gas, int[] cost) {
    // Soma total do balanço de combustível da rota (usada para a verificação final de viabilidade do circuito)
    int totalBalance = 0;
    // Combustível acumulado desde o candidato atual a ponto de partida (usado para determinar o reinício do candidato)
    int currentBalance = 0;
    // Índice do candidato a ponto de partida (inicia em 0 e é atualizado a cada reinício)
    int start = 0;

    // Percorrer o array do índice 0 até o final, um a um
    for (int i = 0; i < gas.length; i++) {
        // Calcular a variação líquida de combustível no posto i
        int net = gas[i] - cost[i];
        // Sempre acumular no balanço total da rota (usado para a verificação final de viabilidade do circuito)
        totalBalance += net;
        // Acumular no combustível acumulado desde o candidato atual (equivale ao combustível restante ao chegar no posto i)
        currentBalance += net;

        // Se o combustível acumulado se tornar negativo, nenhum posto de start até i pode ser o ponto de partida
        if (currentBalance < 0) {
            // Reiniciar o combustível acumulado e definir o próximo posto como novo candidato a ponto de partida
            currentBalance = 0;
            start = i + 1;
        }
    }
    // Se o balanço total de combustível da rota for não negativo, o circuito é possível e retorna-se start; caso contrário, retorna-se -1
    return totalBalance >= 0 ? start : -1;
}
```
