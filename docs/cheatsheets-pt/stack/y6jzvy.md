# Finding How Many Days Until a Warmer Temperature — Encontrar o número de dias até uma temperatura mais alta para cada dia

## Essência do Problema

É dado um array de inteiros `temperatures`. Para cada dia, calcular quantos dias no **futuro** haverá um dia com temperatura mais alta e retornar o resultado em um array. Se não existir um dia com temperatura mais alta no futuro, a resposta para esse dia será `0`.

## Ideia Central

Ao empilhar índices em uma stack monotonicamente decrescente, apenas os dias que "ainda não encontraram um dia mais quente" permanecem na stack. Se a temperatura de um novo dia for maior que a temperatura do dia no topo da stack, a diferença entre os índices será diretamente o "número de dias de espera".

## Processo de Raciocínio

1. **É necessário encontrar "o próximo dia mais quente" para cada dia**: A abordagem ingênua seria fazer uma busca linear para a direita a partir de cada dia, mas isso resultaria em O(n²). É necessário um mecanismo para gerenciar eficientemente o "estado não resolvido" de cada dia
2. **Queremos rastrear os "dias que ainda não têm resposta"**: Ao percorrer o array da esquerda para a direita, se mantivermos como "dias não resolvidos" aqueles que ainda não encontraram um dia futuro com temperatura mais alta, podemos resolver todos de uma vez quando um novo dia chegar
3. **Gerenciar os dias não resolvidos com uma stack**: Empilhamos os índices na stack. Se a temperatura do novo dia for maior que a temperatura do dia no topo da stack, a resposta desse dia não resolvido é determinada. A stack mantém sempre uma ordem monotonicamente decrescente de temperaturas de cima para baixo (temperaturas mais baixas ficam no topo)
4. **A resposta é obtida pela diferença dos índices**: Quando um dia não resolvido `j` é resolvido pelo dia atual `i`, o número de dias de espera é `i - j`. Essa diferença é armazenada na posição `j` do array de resultados
5. **Cada elemento sofre no máximo um push e um pop**: Como cada elemento é empilhado uma vez e desempilhado no máximo uma vez, o número total de operações incluindo o loop while é O(n)

## Conhecimento Prévio

### O que é uma Stack (Pilha)

Uma estrutura de dados LIFO (Last In, First Out). O último elemento adicionado é o primeiro a ser removido. Em Java, utiliza-se a classe `Stack<Integer>`.

```java
Stack<Integer> stack = new Stack<>();  // Criar uma stack vazia
stack.push(5);          // Adicionar 5 no topo da stack
stack.peek();           // Retornar o elemento do topo da stack sem removê-lo → 5
stack.pop();            // Remover e retornar o elemento do topo da stack → 5
stack.isEmpty();        // Retornar um boolean indicando se a stack está vazia → true
```

### O que é uma Stack Monotônica (Monotonic Stack)

Uma stack gerenciada de forma que os elementos mantêm sempre uma ordem monotonicamente crescente ou decrescente. Neste problema, utiliza-se uma **stack monotonicamente decrescente**. Antes de adicionar um novo elemento, todos os elementos que quebrariam a ordem da stack são removidos com pop, mantendo assim a monotonicidade. Pode ser aplicada ao padrão de "encontrar o próximo elemento maior (ou menor)".

```java
// Padrão básico de uma stack monotonicamente decrescente
// As temperaturas na stack diminuem de baixo para cima
// Exemplo: fundo da stack [75, 71, 69] topo ← as temperaturas estão decrescendo
// Quando 72 chega, 69 e 71 são removidos e resolvidos, resultando em [75, 72]
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Cada elemento realiza no máximo um push e um pop na stack, portanto o total é O(n) |
| Space | O(n) — A stack armazena no máximo n índices |

## Código

```java
// Entrada: array de inteiros temperatures (temperatura de cada dia)
// Saída: retornar um int[] contendo o número de dias até o próximo dia mais quente para cada dia
public int[] dailyTemperatures(int[] temperatures) {
    // Criar o array de resultados (em Java, o valor inicial de int[] é 0, então a resposta 0 para dias sem um dia mais quente no futuro já está definida por padrão)
    int[] result = new int[temperatures.length];
    // Stack para armazenar os índices dos dias que ainda não encontraram um dia mais quente
    // O motivo de armazenar índices e não valores de temperatura: a diferença de índices é necessária para calcular os dias de espera, e a temperatura pode ser acessada via temperatures[index]
    Stack<Integer> indexStack = new Stack<>();

    // Percorrer o array do índice i = 0 até o final, um a um
    for (int i = 0; i < temperatures.length; i++) {
        // Enquanto a temperatura atual for maior que a temperatura do dia no topo da stack, resolver os dias não resolvidos
        // Condição: a stack não está vazia E a temperatura atual > a temperatura apontada pelo índice no topo da stack
        while (!indexStack.isEmpty() && temperatures[i] > temperatures[indexStack.peek()]) {
            // Remover o índice do topo da stack
            int stackTopIndex = indexStack.pop();
            // Dias de espera = índice atual - índice do dia que estava esperando
            result[stackTopIndex] = i - stackTopIndex;
        }
        // Após o término do loop while (a stack está vazia ou a temperatura no topo da stack é maior ou igual à temperatura atual), adicionar o índice atual à stack
        // Neste ponto, a ordem monotonicamente decrescente dentro da stack está mantida
        indexStack.push(i);
    }

    // Os índices restantes na stack são "dias que não tiveram um dia mais quente no futuro"
    // Os resultados desses dias permanecem com o valor inicial 0, portanto nenhum processamento adicional é necessário
    return result;
}
```
