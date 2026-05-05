# Counting Car Fleets Arriving at a Destination — Determinar o número de comboios de carros que chegam ao destino

## Essência do problema

São dados um inteiro `target` (posição do destino), um array de inteiros `position` (posição atual de cada carro) e um array de inteiros `speed` (velocidade de cada carro). Todos os carros trafegam em direção ao mesmo destino. Quando um carro mais rápido alcança um carro mais lento à frente, ele ajusta sua velocidade à do carro mais lento e ambos trafegam como um único comboio (fleet). O objetivo é retornar um inteiro representando o **número de comboios** que chegam ao destino.

## Ideia central

Se processarmos os carros em ordem decrescente de proximidade ao destino e gerenciarmos o "tempo de chegada ao destino" de cada carro com uma pilha, podemos determinar que um carro traseiro se junta ao comboio anterior quando seu tempo de chegada é menor ou igual ao do carro da frente, e que ele forma um novo comboio quando seu tempo é maior. O tamanho final da pilha é o número de comboios.

## Processo de raciocínio

1. **Determinar a formação de comboios pelo tempo de chegada**: Se um carro traseiro alcança ou não o carro da frente depende do tempo de chegada ao destino. Se o tempo de chegada do carro traseiro for menor ou igual ao do carro da frente, ele o alcança no caminho e se junta ao mesmo comboio. O tempo de chegada é calculado por `(target - position[i]) / speed[i]`
2. **Processar os carros mais próximos ao destino primeiro**: Como a determinação de junção ao comboio depende de "se o carro da frente (mais próximo do destino) atua como barreira", ao ordenar e processar pela proximidade ao destino, podemos avaliar sequencialmente os carros traseiros usando o tempo de chegada do carro da frente como referência
3. **Ordenar usando um array de índices**: Como position e speed são arrays separados, criamos um array de índices e o ordenamos em ordem decrescente de `position` (mais próximo do destino primeiro). Dessa forma, podemos referenciar os valores correspondentes de position e speed sem alterar os arrays originais
4. **Gerenciar os comboios com uma pilha**: O topo da pilha contém o tempo de chegada do comboio imediatamente anterior (= tempo de chegada do carro líder desse comboio). Se o tempo de chegada do novo carro for menor ou igual ao topo da pilha, esse carro se junta ao comboio anterior e não é adicionado à pilha. Se o tempo de chegada for maior que o topo, um novo comboio é formado e o valor é empilhado
5. **O tamanho da pilha é a resposta**: Carros que se juntam a comboios existentes não são adicionados à pilha, e apenas carros que formam novos comboios são empilhados. Portanto, o número de elementos na pilha ao final corresponde diretamente ao número de comboios

## Conhecimentos prévios

### Cálculo do tempo de chegada

Quando a posição atual de um carro é `pos`, sua velocidade é `speed` e o destino é `target`, o tempo de chegada é calculado por `(target - pos) / speed`. Quanto menor esse valor, mais cedo o carro chega.

```
Exemplo: target=12, pos=10, speed=2
Tempo de chegada = (12 - 10) / 2 = 1.0
```

### Ordenação personalizada com Integer[]

Como o tipo primitivo `int[]` não pode ser ordenado com expressões lambda, criamos um array de índices do tipo `Integer[]` e passamos um Comparator para `Arrays.sort` para realizar a ordenação.

```java
Integer[] idx = new Integer[n];
for (int i = 0; i < n; i++) idx[i] = i;
// Ordenar os índices em ordem decrescente de pos (mais próximo do destino primeiro)
Arrays.sort(idx, (a, b) -> pos[b] - pos[a]);
```

### O que é uma Stack

É uma estrutura de dados do tipo último a entrar, primeiro a sair (LIFO). Usa-se `push` para empilhar elementos, `peek` para consultar o elemento do topo sem removê-lo, e `pop` para removê-lo. Aqui, o topo da pilha mantém o "tempo de chegada do comboio imediatamente anterior" e é usado como referência para a determinação de junção.

```java
Stack<Double> stack = new Stack<>();  // Criar uma pilha vazia
stack.push(3.0);    // Empilhar o elemento 3.0 no topo da pilha
stack.peek();        // Consultar o elemento do topo sem removê-lo → 3.0
stack.isEmpty();     // Verificar se a pilha está vazia → false
stack.size();        // Retornar o número de elementos na pilha → 1
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n log n) — A ordenação do array de índices custa O(n log n), e a varredura subsequente custa O(n) |
| Space | O(n) — O array de índices e a pilha armazenam no máximo n elementos cada |

## Código

```java
// Entrada: inteiro target (posição do destino), array de inteiros pos (posição de cada carro), array de inteiros speed (velocidade de cada carro)
// Saída: retornar um inteiro representando o número de comboios que chegam ao destino
public int carFleet(int target, int[] pos, int[] speed) {
    // Obter o número de carros
    int n = pos.length;

    // Criar um array de índices do tipo Integer[] e inicializá-lo com valores de 0 a n-1
    // Ao ordenar o array de índices, podemos alterar a ordem sem modificar os arrays originais
    Integer[] idx = new Integer[n];
    for (int i = 0; i < n; i++) {
        idx[i] = i;
    }

    // Ordenar o array de índices em ordem decrescente de position (mais próximo do destino primeiro)
    // Processar a partir do carro mais próximo do destino permite a determinação de junção com base no carro da frente
    Arrays.sort(idx, (a, b) -> pos[b] - pos[a]);

    // Pilha para armazenar o tempo de chegada de cada comboio
    // O topo da pilha representa o "tempo de chegada do último comboio confirmado"
    Stack<Double> stack = new Stack<>();

    for (int i : idx) {
        // Calcular o tempo de chegada deste carro ao destino
        // Sem o cast para double, a divisão inteira descartaria a parte decimal
        double time = (double) (target - pos[i]) / speed[i];

        // Se o tempo de chegada for menor ou igual ao topo da pilha, este carro alcança o comboio da frente e se junta a ele
        // O continue pula a adição à pilha e passa ao processamento do próximo carro
        if (!stack.isEmpty() && time <= stack.peek()) {
            continue;
        }

        // Se a pilha estiver vazia ou time for maior que o topo, o carro não alcança o comboio da frente
        // Um novo comboio é formado, então empilhamos o tempo de chegada
        stack.push(time);
    }

    // A pilha contém exatamente um tempo de chegada por comboio, portanto seu tamanho corresponde ao número de comboios
    return stack.size();
}
```
