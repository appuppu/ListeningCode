# Filling Distances to the Nearest Gate — Calcular la distancia desde cada habitación vacía hasta la puerta más cercana en un grid

## Esencia del problema

Se da un grid de m×n. Cada celda es una "pared (−1)", una "puerta (0)" o una "habitación vacía (Integer.MAX_VALUE)". Se debe escribir en cada celda de habitación vacía la distancia hasta la puerta más cercana. Las habitaciones que no pueden alcanzar ninguna puerta permanecen con el valor Integer.MAX_VALUE.

## Idea central

En lugar de buscar la puerta más cercana desde cada habitación vacía, se inicia un BFS simultáneamente desde todas las puertas. Como cada paso del BFS corresponde a las distancias 1, 2, 3…, la distancia mínima de cada celda queda determinada en el momento en que el BFS la alcanza por primera vez.

## Proceso de razonamiento

1. **Buscar puertas desde cada habitación es ineficiente**: Si se ejecuta un BFS por cada habitación vacía, se realizan tantos BFS como habitaciones haya y el costo computacional se dispara. Invirtiendo el enfoque y explorando desde las puertas hacia las habitaciones, un solo BFS con todas las puertas como punto de partida calcula la distancia mínima de todas las habitaciones
2. **Partir simultáneamente desde múltiples puertas (Multi-source BFS)**: Se insertan todas las puertas en la cola y se inicia el BFS. De esta forma, primero se procesan todas las habitaciones a distancia 1, luego las de distancia 2, y así sucesivamente. Gracias a la propiedad de exploración por niveles del BFS, la distancia registrada cuando se alcanza una habitación por primera vez es la distancia mínima
3. **La verificación de visitados se realiza mediante el valor de la celda**: Las habitaciones vacías están inicializadas con Integer.MAX_VALUE. Como el BFS escribe la distancia en cada celda alcanzada, solo las celdas con valor Integer.MAX_VALUE están sin visitar. No es necesario preparar un arreglo visited aparte
4. **La distancia se calcula como valor de la celda padre + 1**: La distancia de una celda adyacente (hija) es el valor de la celda extraída de la cola (padre) más 1. Como el valor de las puertas es 0, las habitaciones adyacentes obtienen 1, las siguientes 2, y así la distancia se propaga correctamente
5. **Las paredes y las posiciones fuera del rango simplemente se omiten**: Las paredes (−1) y las puertas (0) no tienen el valor Integer.MAX_VALUE, por lo que la verificación de no visitado las excluye naturalmente. Los índices fuera del rango se descartan con la comprobación de límites

## Conocimientos previos

### Qué es BFS (búsqueda en anchura)

Es un algoritmo que explora un grafo o grid en orden de cercanía. Utiliza una cola (FIFO: primero en entrar, primero en salir) y procesa todos los nodos a distancia 1 desde el origen antes de avanzar a los nodos a distancia 2. Esta propiedad garantiza la distancia mínima hacia cada nodo.

```java
Queue<int[]> queue = new LinkedList<>();  // Crear la cola para BFS
queue.offer(new int[]{0, 0});             // Agregar las coordenadas del origen a la cola
int[] cell = queue.poll();                // Extraer el elemento del frente de la cola
queue.isEmpty();                          // Verificar si la cola está vacía → true/false
```

### Qué es Multi-source BFS

El BFS normal tiene un único punto de partida, pero el Multi-source BFS comienza con múltiples puntos de partida insertados en la cola. La exploración avanza como si ondas se expandieran simultáneamente desde todos los orígenes, y en cada celda se registra la distancia al origen más cercano.

```java
// Agregar a la cola todas las puertas (celdas con valor 0) como puntos de partida
for (int i = 0; i < m; i++)
    for (int j = 0; j < n; j++)
        if (rooms[i][j] == 0)
            queue.offer(new int[]{i, j});
// Al iniciar el BFS en este estado, la exploración comienza simultáneamente desde todas las puertas
```

### Exploración de celdas adyacentes en 4 direcciones

Para moverse en las 4 direcciones (arriba, abajo, izquierda, derecha) en un grid, se utiliza un arreglo de vectores de dirección para simplificar el código. Se suma cada vector de dirección a las coordenadas actuales para obtener las coordenadas de la celda adyacente.

```java
int[][] dirs = {{-1,0},{1,0},{0,-1},{0,1}};  // Vectores de dirección: arriba, abajo, izquierda, derecha
for (int[] d : dirs) {
    int r = cell[0] + d[0];  // Número de fila de la celda adyacente
    int c = cell[1] + d[1];  // Número de columna de la celda adyacente
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m × n) — Cada celda se agrega a la cola como máximo una vez, por lo que se procesan todas las celdas una sola vez |
| Space | O(m × n) — La cola puede contener como máximo m×n celdas |

## Código

```java
// Entrada: grid de enteros rooms de m×n (−1=pared, 0=puerta, Integer.MAX_VALUE=habitación vacía)
// Salida: sin valor de retorno (void). Se modifica rooms directamente, almacenando en cada celda de habitación vacía la distancia hasta la puerta más cercana
public void wallsAndGates(int[][] rooms) {
    // Obtener el número de filas del grid
    int m = rooms.length;
    // Si el grid está vacío, finalizar el proceso
    if (m == 0) return;
    // Obtener el número de columnas del grid
    int n = rooms[0].length;

    // Crear la cola para BFS. Se almacenan las coordenadas de las celdas {fila, columna}
    Queue<int[]> q = new LinkedList<>();

    // Recorrer todo el grid y agregar a la cola todas las puertas (celdas con valor 0)
    // De esta forma, todas las puertas se registran simultáneamente como puntos de partida del BFS (Multi-source BFS)
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (rooms[i][j] == 0)
                q.offer(new int[]{i, j});

    // Vectores de dirección que representan las 4 direcciones: arriba, abajo, izquierda, derecha. Se usan para enumerar las celdas adyacentes en el bucle
    int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    // Continuar el BFS hasta que la cola esté vacía. Por la propiedad del BFS, las celdas se procesan en orden creciente de distancia
    while (!q.isEmpty()) {
        // Extraer la celda del frente de la cola. cell[0] es el número de fila, cell[1] es el número de columna
        int[] cell = q.poll();

        // Examinar las celdas adyacentes en las 4 direcciones
        for (int[] d : dirs) {
            // Sumar el vector de dirección para calcular las coordenadas de la celda adyacente
            int r = cell[0] + d[0];
            int c = cell[1] + d[1];

            // Omitir si está fuera del rango
            if (r < 0 || r >= m || c < 0 || c >= n) continue;

            // Omitir si el valor no es Integer.MAX_VALUE (pared, puerta o habitación con distancia ya determinada)
            // Esta verificación evita revisitar celdas sin necesidad de un arreglo visited aparte
            if (rooms[r][c] != Integer.MAX_VALUE) continue;

            // Escribir la distancia de la celda padre + 1. Como las puertas tienen valor 0, las adyacentes obtienen 1, las siguientes 2, y así se propaga correctamente
            // Dado que el BFS procesa las celdas en orden de distancia, la primera distancia registrada es la distancia mínima
            rooms[r][c] = rooms[cell[0]][cell[1]] + 1;
            // Agregar la celda con distancia escrita a la cola para explorar las habitaciones más allá
            q.offer(new int[]{r, c});
        }
    }
}
```
