# Finding the Minimum Cost to Connect All Points — Conectar todos los puntos con el costo mínimo

## Esencia del problema

Se recibe un arreglo de puntos `points` en un plano 2D. El costo entre dos puntos cualesquiera se define como la distancia de Manhattan `|xi - xj| + |yi - yj|`. Se debe devolver el **costo total mínimo** para conectar todos los puntos. Este es un problema de encontrar el árbol de expansión mínima (MST: Minimum Spanning Tree).

## Idea central

Para conectar todos los puntos con el costo mínimo, se utiliza el algoritmo de Prim, que selecciona de forma voraz el punto no visitado más cercano al MST actual. Usando una cola de prioridad, se puede extraer la arista de costo mínimo de manera eficiente.

## Proceso de razonamiento

1. **Este es un problema de MST**: Se deben conectar todos los puntos y minimizar el costo. Esta es exactamente la definición de un árbol de expansión mínima. Los pesos de las aristas del grafo se calculan mediante la distancia de Manhattan
2. **Prim es adecuado porque el grafo es completo**: Con n puntos, el número de aristas es n(n-1)/2. Con Kruskal sería necesario generar y ordenar todas las aristas previamente, pero con Prim se pueden procesar de forma incremental solo las aristas adyacentes al MST actual
3. **Se necesita extraer la arista de costo mínimo rápidamente**: En el algoritmo de Prim, es necesario seleccionar cada vez la arista de costo mínimo hacia un punto no visitado. Usando una cola de prioridad (min-heap), esta extracción se realiza en O(log n)
4. **Se puede comenzar desde cualquier punto**: El costo total del MST es el mismo sin importar desde qué punto se comience, por lo que se inicia desde el punto 0. En el estado inicial, se agrega a la cola el costo 0 hacia el punto 0
5. **Se previenen duplicados con un indicador de visitado**: Si el punto extraído de la cola ya está incluido en el MST, se omite. Esto evita procesar el mismo punto dos veces
6. **Se agregan aristas adyacentes cada vez que se añade un nuevo punto al MST**: Al agregar el punto u al MST, se calcula la distancia de Manhattan desde u hacia todos los puntos no visitados v y se agregan a la cola. La cola gestiona automáticamente la arista de costo mínimo como siguiente candidata

## Conocimientos previos

### ¿Qué es un árbol de expansión mínima (MST)?

Es el subgrafo que conecta todos los vértices de un grafo y cuya suma de pesos de las aristas es mínima. Para n vértices, tiene exactamente n-1 aristas y no contiene ciclos.

### ¿Qué es el algoritmo de Prim?

Es un algoritmo voraz que construye un MST. Comienza desde un vértice cualquiera y expande el MST seleccionando repetidamente la arista de peso mínimo que conecta el MST actual con un vértice no visitado. El algoritmo termina cuando todos los vértices están incluidos en el MST.

### ¿Qué es la distancia de Manhattan?

Es la suma de los valores absolutos de las diferencias de cada coordenada entre dos puntos. La distancia entre los puntos `(x1, y1)` y `(x2, y2)` en un plano 2D se calcula como `|x1 - x2| + |y1 - y2|`. Equivale a la distancia más corta al caminar por calles en forma de cuadrícula.

```java
int dist = Math.abs(pts[u][0] - pts[v][0]) + Math.abs(pts[u][1] - pts[v][1]);
```

### ¿Qué es una PriorityQueue (cola de prioridad)?

Es una estructura de datos que permite extraer elementos en orden de prioridad. Por defecto, el valor mínimo se extrae primero (min-heap). La adición se realiza con `offer` y la extracción del elemento mínimo con `poll`, ambas operaciones funcionan en O(log n).

```java
// Crear una cola de prioridad que ordena de forma ascendente por el elemento 0 de int[]
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{5, 0});   // Agregar [costo=5, índice del punto=0]
pq.offer(new int[]{2, 1});   // Agregar [costo=2, índice del punto=1]
int[] min = pq.poll();       // Extraer el elemento con costo mínimo [2, 1]
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n² log n) — Cada vez que se añade un punto al MST, se agregan hasta n aristas a la cola, y cada operación de cola cuesta log n |
| Space | O(n²) — La cola puede almacenar hasta n² aristas. El arreglo inMST es O(n) |

## Código

```java
// Entrada: arreglo de coordenadas 2D pts (cada elemento es [x, y])
// Salida: devuelve el costo mínimo para conectar todos los puntos como int
int minCostConnectPoints(int[][] pts) {
    // Obtener el número de puntos
    int n = pts.length;
    // Arreglo de indicadores que gestiona si cada punto está incluido en el MST (inicializado en false)
    boolean[] inMST = new boolean[n];
    // Cola de prioridad que almacena {costo, índice del punto} y extrae en orden ascendente de costo
    PriorityQueue<int[]> pq =
        new PriorityQueue<>((a, b) -> a[0] - b[0]);
    // Agregar el punto de inicio (índice 0) a la cola con costo 0
    // El costo 0 significa que el costo de agregar el primer punto al MST es 0
    // El costo total del MST es el mismo sin importar desde qué punto se comience, así que se elige el punto 0 arbitrariamente
    pq.offer(new int[]{0, 0});
    // cost: costo total del MST, visited: número de puntos añadidos al MST
    int cost = 0, visited = 0;

    // Repetir hasta que todos los puntos estén incluidos en el MST
    while (visited < n) {
        // Extraer la arista de costo mínimo (d: costo de conexión, u: índice del punto)
        int[] curr = pq.poll();
        int d = curr[0], u = curr[1];

        // Omitir los puntos que ya están incluidos en el MST
        // Esta verificación es necesaria porque el mismo punto puede haberse agregado a la cola varias veces con diferentes costos
        if (inMST[u]) continue;

        // Agregar el punto u al MST y sumar el costo
        inMST[u] = true;
        cost += d;
        visited++;

        // Agregar a la cola las aristas desde el punto u hacia todos los puntos no visitados
        // Las aristas candidatas se registran en la cola, que gestiona automáticamente la arista de costo mínimo
        for (int v = 0; v < n; v++) {
            if (!inMST[v]) {
                // Calcular la distancia de Manhattan: |xu - xv| + |yu - yv|
                int nd =
                    Math.abs(pts[u][0] - pts[v][0])
                    + Math.abs(pts[u][1] - pts[v][1]);
                pq.offer(new int[]{nd, v});
            }
        }
    }
    // Después de terminar el bucle while, cost contiene el costo total del MST
    return cost;
}
```
