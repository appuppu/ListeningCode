# Cálculo del tiempo de propagación de señal en una red — Determinar el tiempo mínimo para que la señal llegue a todos los nodos de la red

## Esencia del problema

Se proporcionan `n` nodos (del 1 al n) y una lista de aristas dirigidas con pesos `times` (cada arista es `[origen, destino, tiempo requerido]`). Al enviar una señal desde un nodo fuente `k` especificado, se debe devolver el tiempo mínimo para que la señal llegue a todos los nodos. Si existe al menos un nodo inalcanzable, se devuelve `-1`.

## Idea central

"El tiempo mínimo para que la señal llegue a todos los nodos" es igual a "el máximo entre las distancias mínimas hacia cada nodo". Se calculan las distancias mínimas hacia todos los nodos mediante el algoritmo de Dijkstra y se toma el valor máximo.

## Proceso de razonamiento

1. **Interpretar el problema como un problema de camino más corto**: La señal se propaga desde el nodo fuente a través de cada arista. El momento en que la señal llega a cada nodo es igual a la distancia mínima desde la fuente hasta ese nodo. Por lo tanto, basta con resolver un problema de camino más corto desde un único origen
2. **Calcular eficientemente la distancia mínima hacia todos los nodos**: Dado que los pesos de las aristas son no negativos, se puede aplicar el algoritmo de Dijkstra. El algoritmo de Dijkstra utiliza una cola de prioridad (min-heap) y confirma de forma voraz los nodos comenzando por el de menor distancia
3. **Decidir la representación del grafo**: Se utiliza una lista de adyacencia. Para cada nodo se almacena una lista de pares con el "nodo adyacente y el peso de la arista". Esto permite enumerar eficientemente las aristas que salen de un nodo
4. **Inicializar el arreglo de distancias**: Se inicializan las distancias de todos los nodos con infinito (`Integer.MAX_VALUE`) y se establece la distancia del nodo fuente `k` en 0. Esto se debe a que la distancia desde la fuente hacia sí misma es 0
5. **Procesar los nodos con menor distancia mediante la cola de prioridad**: Se extrae el nodo con la distancia mínima de la cola y se actualizan (relajan) las distancias hacia sus nodos adyacentes. Si se produce una actualización, se agrega el nodo a la cola
6. **Omitir el procesamiento duplicado**: Si la distancia del nodo extraído de la cola es mayor que la distancia mínima actual, significa que ya fue procesado por una ruta mejor, por lo que se omite. Esto evita cálculos innecesarios
7. **Obtener la respuesta a partir de las distancias mínimas de todos los nodos**: Se recorre el arreglo de distancias de todos los nodos; si algún nodo permanece con valor infinito, es inalcanzable y se devuelve `-1`. En caso contrario, el valor máximo de las distancias es la respuesta

## Conocimientos previos

### Lista de adyacencia (Adjacency List)

Es una estructura de datos para representar grafos. Para cada nodo se mantiene una lista con "todas las aristas que salen de ese nodo". Para `n` nodos se representa con `List<List<int[]>>`, y `graph.get(u)` obtiene las aristas que salen del nodo `u`.

```java
List<List<int[]>> graph = new ArrayList<>();
for (int i = 0; i <= n; i++) {
    graph.add(new ArrayList<>());       // Se prepara una lista vacía para cada nodo
}
graph.get(1).add(new int[]{2, 5});      // Se agrega una arista del nodo 1 al nodo 2 con peso 5
graph.get(1).add(new int[]{3, 2});      // Se agrega una arista del nodo 1 al nodo 3 con peso 2
```

### PriorityQueue (Cola de prioridad)

Es una estructura de datos que siempre mantiene el elemento mínimo (o máximo) al frente, independientemente del orden en que se agreguen los elementos. En el algoritmo de Dijkstra se utiliza para extraer eficientemente "el nodo con la distancia mínima".

```java
// Min-heap que ordena en forma ascendente por el elemento 0 del int[] (distancia)
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{0, 1});   // Se agrega {distancia 0, nodo 1} a la cola
pq.offer(new int[]{5, 2});   // Se agrega {distancia 5, nodo 2} a la cola
int[] curr = pq.poll();       // Se extrae el elemento con distancia mínima {0, 1}
pq.isEmpty();                 // Devuelve un boolean indicando si la cola está vacía
```

### Relajación en el algoritmo de Dijkstra (Relaxation)

Es la operación de actualizar `dist[v]` a un valor menor cuando la distancia para llegar al nodo `v` pasando por el nodo `u`, es decir `dist[u] + w`, es menor que el `dist[v]` actual. Al repetir esta actualización, se determinan las distancias mínimas hacia todos los nodos.

```java
int newDist = dist[u] + w;      // Se calcula la distancia para llegar a v pasando por u
if (newDist < dist[v]) {        // Si es menor que la distancia mínima actual
    dist[v] = newDist;          // Se actualiza la distancia mínima
    pq.offer(new int[]{newDist, v});  // Se agrega v actualizado a la cola
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O((V + E) log V) — Se realizan operaciones en la cola de prioridad (log V) para cada nodo y cada arista |
| Space | O(V + E) — Se almacenan todas las aristas en la lista de adyacencia, y se utiliza espacio proporcional al número de nodos para el arreglo de distancias y la cola |

## Código

```java
// Entrada: lista de aristas dirigidas int[][] times (cada elemento es [origen, destino, peso]), número de nodos int n, nodo fuente int k
// Salida: devuelve como int el tiempo mínimo para que la señal llegue a todos los nodos desde la fuente. Devuelve -1 si existe un nodo inalcanzable
public int networkDelayTime(int[][] times, int n, int k) {
    // Se crea la lista de adyacencia (los nodos comienzan en 1, por lo que el tamaño es n+1 y el índice 0 no se utiliza)
    List<List<int[]>> graph = new ArrayList<>();
    for (int i = 0; i <= n; i++) {
        graph.add(new ArrayList<>());
    }
    // Se registra cada arista [u, v, w] en la lista de adyacencia para completar la representación del grafo dirigido
    for (int[] t : times) {
        graph.get(t[0]).add(new int[]{t[1], t[2]});
    }

    // Se inicializa el arreglo de distancias con infinito. dist[i] representa "la distancia mínima actual desde la fuente hasta el nodo i"
    int[] dist = new int[n + 1];
    Arrays.fill(dist, Integer.MAX_VALUE);
    // La distancia desde el nodo fuente hacia sí mismo es 0
    dist[k] = 0;

    // Se crea un min-heap que extrae en orden ascendente por distancia (elemento 0) y se agrega el nodo fuente {distancia 0, nodo k}
    PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
    pq.offer(new int[]{0, k});

    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int d = curr[0];  // Distancia desde la fuente hasta el nodo u
        int u = curr[1];  // Nodo que se procesa actualmente

        // Si d > dist[u], ya fue procesado con una distancia menor. Esto ocurre cuando quedan entradas antiguas (con distancia mayor) en la cola
        if (d > dist[u]) continue;

        // Se intenta la relajación hacia los nodos adyacentes
        for (int[] nei : graph.get(u)) {
            int v = nei[0];  // Nodo adyacente
            int w = nei[1];  // Peso de la arista
            // Si la distancia pasando por u (d + w) es menor que dist[v] actual, se actualiza la distancia y se agrega a la cola
            if (d + w < dist[v]) {
                dist[v] = d + w;
                pq.offer(new int[]{d + w, v});
            }
        }
    }

    // Se obtiene el máximo entre las distancias mínimas de todos los nodos. Este valor máximo es "el tiempo mínimo para que la señal llegue a todos los nodos"
    int max = 0;
    for (int i = 1; i <= n; i++) {
        // Si permanece con Integer.MAX_VALUE, existe un nodo inalcanzable, por lo que se devuelve -1
        if (dist[i] == Integer.MAX_VALUE) return -1;
        max = Math.max(max, dist[i]);
    }
    return max;
}
```
