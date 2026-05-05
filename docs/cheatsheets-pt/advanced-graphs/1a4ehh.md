# Finding the Cheapest Flight With Limited Stops — Encontrar o voo mais barato com no máximo k escalas

## Essência do problema

São dados `n` cidades, uma lista de voos `[from, to, price]`, uma origem `src`, um destino `dst` e um número máximo de escalas `k`. O objetivo é retornar a tarifa total mais barata para ir da origem ao destino com **no máximo k escalas** (ou seja, no máximo k cidades intermediárias). Se não for possível alcançar o destino, retornar `-1`.

## Ideia central

O Dijkstra convencional rastreia apenas o caminho de menor custo, mas neste problema, um caminho com custo mais alto e menos escalas pode se tornar a rota mais barata no final. Por isso, registramos o "menor número de escalas" com que cada cidade foi alcançada e mantemos na exploração apenas os caminhos que alcançam a cidade com menos escalas, obtendo assim a solução ótima que considera tanto o custo quanto o número de escalas.

## Processo de raciocínio

1. **Dijkstra é a base para buscar a rota mais barata**: Como se trata de um problema de caminho mínimo em um grafo ponderado, a abordagem básica é o Dijkstra com fila de prioridade. Ao extrair os nós em ordem crescente de custo, a primeira vez que alcançamos o destino corresponde à tarifa mais barata
2. **Como lidar com a restrição do número de escalas**: O Dijkstra convencional não revisita cidades já alcançadas com custo mínimo, mas neste problema existe a restrição do número de escalas. Se o caminho de custo mínimo ultrapassar k escalas, ele é inválido, e um caminho com custo um pouco maior mas com menos escalas pode ser válido
3. **Registrar o "menor número de escalas" para cada cidade**: Preparamos um array `stops[]` para registrar o menor número de escalas com que cada cidade foi alcançada. Se uma cidade for alcançada com mais escalas do que o registrado anteriormente, esse caminho não apresenta melhoria nem em custo nem em número de escalas, podendo ser podado
4. **O que armazenar na fila de prioridade**: Cada estado é gerenciado como uma tupla de 3 elementos `[custo, cidade, número de escalas]`. Ao extrair em ordem crescente de custo, a solução na primeira vez que o destino é alcançado é a mais barata
5. **Organizar as condições de poda**: (a) Se o número atual de escalas for maior ou igual ao menor número registrado para essa cidade, interromper a exploração. (b) Se o número de escalas ultrapassar k, não expandir para as cidades adjacentes
6. **Expansão para cidades adjacentes**: Apenas quando a poda é superada, adicionar à fila `[custo atual + tarifa, cidade adjacente, número de escalas + 1]` para cada cidade adjacente

## Conhecimentos prévios

### O que é uma Lista de Adjacência (Adjacency List)

É uma estrutura de dados que mantém, para cada vértice do grafo, uma lista dos vértices diretamente alcançáveis e os pesos das arestas. É representada por `HashMap<Integer, List<int[]>>`, onde a chave é a cidade de origem e o valor é uma lista de `[cidade de destino, tarifa]`.

```java
Map<Integer, List<int[]>> adj = new HashMap<>();
// Adicionar um voo da cidade 0 para a cidade 1 com tarifa 100
adj.computeIfAbsent(0, x -> new ArrayList<>()).add(new int[]{1, 100});
// Obter a lista de adjacência da cidade 0
List<int[]> neighbors = adj.get(0);  // → [[1, 100]]
```

### O que é uma PriorityQueue (Fila de Prioridade)

É uma estrutura de dados que ordena automaticamente os elementos internamente ao adicioná-los, permitindo sempre extrair o menor (ou maior) elemento do topo. No Dijkstra, é utilizada para extrair eficientemente o "estado de menor custo".

```java
// Fila de prioridade que ordena em ordem crescente pelo elemento 0 (custo) de int[]
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{100, 1, 0});   // Adicionar [custo=100, cidade=1, escalas=0]
pq.offer(new int[]{50, 2, 1});    // Adicionar [custo=50, cidade=2, escalas=1]
int[] min = pq.poll();            // Extrair [50, 2, 1] com menor custo
pq.isEmpty();                      // Verificar se a fila está vazia → false
```

### O que é a poda com o array stops

No Dijkstra convencional, um array `visited` gerencia as cidades já visitadas, mas neste problema é necessário distinguir caminhos que alcançam a mesma cidade com "diferentes números de escalas". O array `stops[]` registra o menor número de escalas para cada cidade e interrompe caminhos que chegam com um número de escalas igual ou superior, eliminando explorações desnecessárias.

```java
int[] stops = new int[n];
Arrays.fill(stops, k + 2);  // k+2 é um valor inicial suficientemente grande que significa "ainda não alcançado"
// Quando a cidade 2 é alcançada com 1 escala
stops[2] = 1;
// Posteriormente, a cidade 2 é alcançada com 2 escalas → 2 >= stops[2], então é podado (ignorado)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(E · log n) — Para cada voo (aresta), a adição e extração na fila de prioridade custam log n |
| Space | O(n + E) — O(E) para a lista de adjacência, O(n) para o array stops, e no máximo O(E) estados na fila |

## Código

```java
// Entrada: número de cidades n, array de voos flights (cada elemento é [from, to, price]), origem src, destino dst, número máximo de escalas k
// Saída: retorna como int a tarifa mais barata da origem ao destino com no máximo k escalas. Retorna -1 se não for possível alcançar o destino
public int findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
    // Construir a lista de adjacência. Chave=cidade de origem, Valor=lista de [cidade de destino, tarifa]
    // Para cada voo f, adicionar [f[1], f[2]] à chave f[0] de adj
    Map<Integer, List<int[]>> adj = new HashMap<>();
    for (int[] f : flights)
        adj.computeIfAbsent(f[0], x -> new ArrayList<>())
            .add(new int[]{f[1], f[2]});

    // Fila de prioridade em ordem crescente de custo. Cada estado é [custo, cidade, número de escalas]
    // Ao extrair prioritariamente o estado de menor custo, a primeira vez que o destino é alcançado corresponde à tarifa mais barata
    PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
    // Estado inicial: a origem é alcançada com custo 0 e 0 escalas
    pq.offer(new int[]{0, src, 0});

    // Array que registra o menor número de escalas para cada cidade
    // k+2 é um valor inicial suficientemente maior que o limite k de escalas, significando "ainda não alcançado"
    int[] stops = new int[n];
    Arrays.fill(stops, k + 2);

    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int cost = curr[0];
        int city = curr[1];
        int stop = curr[2];

        // Se o destino foi alcançado, como extraímos em ordem crescente de custo, esta é a tarifa mais barata
        if (city == dst) return cost;

        // Se esta cidade foi alcançada com mais (ou igual número de) escalas que antes, podar
        // Como extraímos em ordem crescente de custo, a chegada anterior também tinha menor custo → não há sentido em explorar
        if (stop >= stops[city]) continue;
        // Atualizar o menor número de escalas com que esta cidade foi alcançada
        stops[city] = stop;

        // Se o número de escalas ultrapassou o limite k, não é possível expandir desta cidade para cidades adjacentes
        if (stop > k) continue;

        // Se não há voos partindo desta cidade, ignorar
        if (!adj.containsKey(city)) continue;

        // Para cada cidade adjacente, adicionar [custo acumulado, cidade adjacente, número de escalas + 1] à fila
        for (int[] next : adj.get(city)) {
            pq.offer(new int[]{cost + next[1], next[0], stop + 1});
        }
    }

    // Se o loop terminou sem alcançar o destino, retornar -1
    return -1;
}
```
