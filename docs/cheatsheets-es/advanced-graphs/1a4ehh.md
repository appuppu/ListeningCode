# Finding the Cheapest Flight With Limited Stops — Encontrar el vuelo más barato con un número limitado de escalas

## Esencia del problema

Se proporcionan `n` ciudades, una lista de vuelos `[from, to, price]`, una ciudad de origen `src`, una ciudad de destino `dst` y un número máximo de escalas `k`. El objetivo es devolver la tarifa total más barata para llegar desde el origen hasta el destino con **un máximo de k escalas** (es decir, pasando por k ciudades intermedias o menos). Si no es posible llegar al destino, se devuelve `-1`.

## Idea central

El algoritmo de Dijkstra estándar solo rastrea la ruta de menor costo, pero en este problema una ruta con mayor costo pero menos escalas puede resultar ser la ruta más barata al final. Por eso, se registra el "número mínimo de escalas" con el que se ha llegado a cada ciudad, y solo se mantienen como candidatos de exploración las rutas que llegan con menos escalas, lo que permite encontrar la solución óptima considerando tanto el costo como el número de escalas.

## Proceso de razonamiento

1. **Dijkstra es la base para buscar la ruta más barata**: Dado que se trata de un problema de ruta más corta en un grafo ponderado, el enfoque básico es usar Dijkstra con una cola de prioridad. Al extraer los nodos en orden ascendente de costo, la primera vez que se llega al destino, esa es la ruta más barata
2. **Cómo manejar la restricción del número de escalas**: En el Dijkstra estándar, "una ciudad visitada con el costo mínimo no se vuelve a visitar", pero en este problema existe la restricción del número de escalas. Si la ruta de menor costo supera k escalas, es inválida, y una ruta ligeramente más cara pero con menos escalas puede ser válida
3. **Registrar el "número mínimo de escalas" para cada ciudad**: Se prepara un arreglo `stops[]` y se registra el número mínimo de escalas con el que se ha llegado a cada ciudad. Si se llega a una ciudad con más escalas que las registradas previamente, esa ruta no mejora ni en costo ni en número de escalas, por lo que se puede podar
4. **Qué almacenar en la cola de prioridad**: Cada estado se gestiona como una tupla de tres elementos `[costo, ciudad, número de escalas]`. Al extraer en orden ascendente de costo, la solución en el momento de llegar por primera vez al destino es la más barata
5. **Organizar las condiciones de poda**: (a) Si el número actual de escalas es igual o mayor al número mínimo de escalas registrado para esa ciudad, se interrumpe la exploración. (b) Si el número de escalas supera k, no se expande hacia las ciudades adyacentes
6. **Expansión hacia ciudades adyacentes**: Solo cuando se pasan las condiciones de poda, se añade a la cola `[costo actual + tarifa, ciudad adyacente, número de escalas + 1]` para cada ciudad adyacente

## Conocimientos previos

### Lista de adyacencia (Adjacency List)

Es una estructura de datos que, para cada vértice del grafo, mantiene una lista de los vértices directamente alcanzables junto con el peso de la arista. Se representa con `HashMap<Integer, List<int[]>>`, donde la clave es la ciudad de origen y el valor es una lista de `[ciudad de destino, tarifa]`.

```java
Map<Integer, List<int[]>> adj = new HashMap<>();
// Agregar un vuelo de la ciudad 0 a la ciudad 1 con tarifa 100
adj.computeIfAbsent(0, x -> new ArrayList<>()).add(new int[]{1, 100});
// Obtener la lista de adyacencia de la ciudad 0
List<int[]> neighbors = adj.get(0);  // → [[1, 100]]
```

### PriorityQueue (cola de prioridad)

Es una estructura de datos que ordena internamente los elementos al agregarlos y permite extraer siempre el elemento mínimo (o máximo) desde el frente. En Dijkstra, se utiliza para extraer eficientemente el "estado con el menor costo".

```java
// Cola de prioridad que ordena en orden ascendente por el elemento 0 del int[] (costo)
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{100, 1, 0});   // Agregar [costo=100, ciudad=1, escalas=0]
pq.offer(new int[]{50, 2, 1});    // Agregar [costo=50, ciudad=2, escalas=1]
int[] min = pq.poll();            // Extraer [50, 2, 1] con el menor costo
pq.isEmpty();                      // Verificar si la cola está vacía → false
```

### Poda mediante el arreglo stops

En el Dijkstra estándar se gestiona las ciudades visitadas con un arreglo `visited`, pero en este problema es necesario distinguir las rutas que llegan a la misma ciudad con "diferente número de escalas". El arreglo `stops[]` registra el número mínimo de escalas para cada ciudad, y al descartar las rutas que llegan con un número de escalas igual o mayor, se eliminan las exploraciones innecesarias.

```java
int[] stops = new int[n];
Arrays.fill(stops, k + 2);  // k+2 es un valor inicial suficientemente grande que significa "aún no alcanzado"
// Si se llega a la ciudad 2 con 1 escala
stops[2] = 1;
// Luego se llega a la ciudad 2 con 2 escalas → 2 >= stops[2], por lo que se poda (se omite)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(E · log n) — Para cada vuelo (arista), la inserción y extracción en la cola de prioridad toma log n |
| Space | O(n + E) — O(E) para la lista de adyacencia, O(n) para el arreglo stops y un máximo de O(E) estados en la cola |

## Código

```java
// Entrada: número de ciudades n, arreglo de vuelos flights (cada elemento es [from, to, price]), origen src, destino dst, número máximo de escalas k
// Salida: devuelve como int la tarifa más barata para llegar del origen al destino con un máximo de k escalas. Devuelve -1 si no es posible llegar
public int findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
    // Construir la lista de adyacencia. Clave=ciudad de origen, valor=lista de [ciudad de destino, tarifa]
    // Para cada vuelo f, se agrega [f[1], f[2]] a la clave f[0] de adj
    Map<Integer, List<int[]>> adj = new HashMap<>();
    for (int[] f : flights)
        adj.computeIfAbsent(f[0], x -> new ArrayList<>())
            .add(new int[]{f[1], f[2]});

    // Cola de prioridad en orden ascendente de costo. Cada estado es [costo, ciudad, número de escalas]
    // Al extraer prioritariamente el estado con menor costo, la primera llegada al destino es la más barata
    PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
    // Estado inicial: se ha llegado al origen con costo 0 y 0 escalas
    pq.offer(new int[]{0, src, 0});

    // Arreglo que registra el número mínimo de escalas para cada ciudad
    // k+2 es un valor inicial suficientemente mayor que el límite de escalas k, que significa "aún no alcanzado"
    int[] stops = new int[n];
    Arrays.fill(stops, k + 2);

    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int cost = curr[0];
        int city = curr[1];
        int stop = curr[2];

        // Si se ha llegado al destino, como se extrae en orden ascendente de costo, esta es la tarifa más barata
        if (city == dst) return cost;

        // Si se ha llegado a esta ciudad con un número de escalas igual o mayor al previo, se poda
        // Como se extrae en orden ascendente de costo, la llegada anterior también tiene menor costo → no tiene sentido explorar
        if (stop >= stops[city]) continue;
        // Actualizar el número mínimo de escalas con el que se ha llegado a esta ciudad
        stops[city] = stop;

        // Si el número de escalas supera el límite k, no se puede expandir desde esta ciudad hacia ciudades adyacentes
        if (stop > k) continue;

        // Si no hay vuelos que salgan de esta ciudad, se omite
        if (!adj.containsKey(city)) continue;

        // Para cada ciudad adyacente, se agrega a la cola [costo acumulado, ciudad adyacente, número de escalas + 1]
        for (int[] next : adj.get(city)) {
            pq.offer(new int[]{cost + next[1], next[0], stop + 1});
        }
    }

    // Si el bucle termina sin haber llegado al destino, se devuelve -1
    return -1;
}
```
