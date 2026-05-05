# Simulando o Jogo da Última Pedra — Encontrar o peso da pedra que resta após colidir as pedras duas a duas

## Essência do problema

Um array de inteiros `stones` é fornecido. A cada rodada, as **duas pedras mais pesadas** são retiradas e colididas. Se as duas pedras tiverem o mesmo peso, ambas são destruídas; se forem diferentes, a mais leve é destruída e a mais pesada tem seu peso reduzido para a diferença. Essa operação é repetida até restar no máximo uma pedra, e o peso da pedra restante é retornado. Se nenhuma pedra restar, retorna-se 0.

## Ideia central

É necessário extrair eficientemente as "duas mais pesadas" a cada rodada. Usando um Max-Heap (heap máximo), a extração do valor máximo é feita em O(log n), permitindo obter sempre as duas pedras mais pesadas sem necessidade de reordenar.

## Processo de raciocínio

1. **Cada operação requer os dois maiores valores**: Pelas regras de colisão, sempre se escolhem as duas pedras mais pesadas. Ou seja, o problema consiste em repetir a operação de "extrair o valor máximo duas vezes do conjunto atual"
2. **A extração do valor máximo deve ser feita de forma eficiente**: Ordenar o array a cada rodada custaria O(n log n) por rodada. Com um Max-Heap, a extração do valor máximo custa O(log n), e a inserção de um elemento também custa O(log n)
3. **Usar a PriorityQueue do Java como Max-Heap**: A PriorityQueue do Java é, por padrão, um Min-Heap (o menor valor fica no topo). Passando `Collections.reverseOrder()` como comparador, ela funciona como um Max-Heap com o maior valor no topo
4. **Inserir todas as pedras no heap**: Todos os elementos do array `stones` são adicionados à PriorityQueue. Isso prepara o heap para gerenciar o valor máximo
5. **Repetir a operação de colisão enquanto houver duas ou mais pedras**: Extrair o valor máximo duas vezes com `poll()`, e se a diferença não for 0, devolvê-la ao heap com `add()`. Se a diferença for 0, nada é devolvido (ambas são destruídas)
6. **Avaliar o estado final e retornar o resultado**: Após o término do loop, se o heap estiver vazio, todas as pedras foram destruídas, então retorna-se 0. Se restar uma pedra no heap, seu peso é extraído com `poll()` e retornado

## Conhecimentos prévios

### O que é PriorityQueue (fila de prioridade)

Uma estrutura de dados que gerencia automaticamente a ordem dos elementos ao serem adicionados, e `poll()` sempre extrai o elemento de maior prioridade. A implementação interna é um heap (heap binário), e tanto a inserção quanto a extração operam em O(log n).

```java
// O padrão é Min-Heap (o menor valor fica no topo)
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.add(5);       // Adiciona o elemento 5
minHeap.add(2);       // Adiciona o elemento 2
minHeap.poll();       // Extrai e retorna o menor valor 2
minHeap.size();       // Retorna o número atual de elementos → 1
minHeap.isEmpty();    // Retorna boolean indicando se a fila está vazia → false
```

### O que é Collections.reverseOrder()

Um comparador passado ao construtor da PriorityQueue que inverte a ordem padrão ascendente (Min-Heap) para descendente (Max-Heap). Com isso, `poll()` passa a retornar o maior valor.

```java
// Cria um Max-Heap (o maior valor fica no topo)
PriorityQueue<Integer> maxHeap =
    new PriorityQueue<>(Collections.reverseOrder());
maxHeap.add(3);       // Adiciona o elemento 3
maxHeap.add(7);       // Adiciona o elemento 7
maxHeap.add(1);       // Adiciona o elemento 1
maxHeap.poll();       // Extrai e retorna o maior valor 7
maxHeap.poll();       // Extrai e retorna o próximo maior valor 3
```

### Imagem do funcionamento do Max-Heap

stones = [2, 7, 4, 1, 8, 1] no caso:
- Ao adicionar todos os elementos ao heap, internamente ele é gerenciado como `[8, 7, 4, 1, 2, 1]`
- `poll()` → Extrai 8. O heap é reestruturado para `[7, 4, 2, 1, 1]`
- `poll()` → Extrai 7. O resultado 8 - 7 = 1 é devolvido ao heap com `add()`

## Complexidade

| | Valor |
|---|---|
| Time | O(n log n) — Há no máximo n operações de colisão, e cada operação custa O(log n) para extração e inserção no heap |
| Space | O(n) — O heap armazena no máximo n pedras |

## Código

```java
// Entrada: array de inteiros stones (cada elemento é o peso de uma pedra)
// Saída: retorna o peso da última pedra restante como int. Se nenhuma pedra restar, retorna 0
public int lastStoneWeight(int[] stones) {
    // Especifica Collections.reverseOrder() como comparador para criar um Max-Heap onde poll() retorna o maior valor
    PriorityQueue<Integer> pq =
        new PriorityQueue<>(Collections.reverseOrder());

    // Adiciona todas as pedras ao heap. Após a conclusão, o heap gerencia o maior valor no topo
    for (int s : stones) pq.add(s);

    // Repete a operação de colidir as duas pedras mais pesadas enquanto houver duas ou mais pedras
    while (pq.size() >= 2) {
        // Chama poll() duas vezes para extrair a pedra mais pesada e a segunda mais pesada
        // Como é um Max-Heap, a >= b é sempre verdadeiro
        int a = pq.poll();
        int b = pq.poll();

        // Se os pesos forem diferentes, devolve a pedra com a diferença ao heap. Se forem iguais, ambas são destruídas e nada é devolvido
        if (a != b) pq.add(a - b);
    }

    // Se o heap estiver vazio, todas as pedras foram destruídas e retorna 0; caso contrário, retorna o peso da pedra restante
    return pq.isEmpty() ? 0 : pq.poll();
}
```
