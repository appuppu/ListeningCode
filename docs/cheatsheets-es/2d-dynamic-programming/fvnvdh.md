# Finding the Longest Increasing Path in a Matrix — Encontrar la longitud del camino más largo con valores estrictamente crecientes en una matriz

## Esencia del problema

Se da una matriz de enteros `matrix` de tamaño m×n. Se puede mover en 4 direcciones (arriba, abajo, izquierda, derecha), y solo se permite mover a una celda adyacente si su valor es **estrictamente mayor** que el valor de la celda actual. Se debe devolver la **longitud del camino más largo** (número de celdas) que cumple esta condición.

## Idea central

Se interpreta la matriz como un "DAG (grafo dirigido acíclico) donde las aristas van de valores menores a valores mayores". Se inicia un BFS desde las celdas con grado de entrada 0 (celdas que no tienen ningún valor menor en sus celdas adyacentes) y se avanza capa por capa; el número de capas corresponde directamente a la longitud del camino más largo.

## Proceso de razonamiento

1. **La condición de movimiento define las aristas del DAG**: Como solo se puede mover en la dirección en que los valores son estrictamente crecientes, no existen ciclos. Es decir, al ver las relaciones de adyacencia de la matriz como un grafo, se obtiene un DAG (grafo dirigido acíclico) con aristas en la dirección de menor a mayor
2. **El camino más largo en un DAG se obtiene mediante ordenamiento topológico**: El problema del camino más largo en un DAG se resuelve eficientemente procesando en orden topológico. Al usar BFS (algoritmo de Kahn), se puede procesar capa por capa, y el número de capas corresponde a la longitud del camino más largo
3. **Se define el significado del grado de entrada**: El grado de entrada de cada celda es "la cantidad de celdas adyacentes en las 4 direcciones que tienen un valor menor al propio". Las celdas con grado de entrada 0 son candidatas a punto de inicio del camino, ya que no existe ninguna celda adyacente con un valor menor
4. **Se procesa el BFS capa por capa**: Se agregan todas las celdas con grado de entrada 0 a la cola y se inicia el BFS. Se procesan todas las celdas de una capa a la vez, y para cada celda se reduce en 1 el grado de entrada de las "celdas adyacentes con valor mayor". Las celdas cuyo grado de entrada llega a 0 se agregan a la cola como la siguiente capa
5. **La razón por la que el número de capas es la respuesta**: Cada capa del BFS es un conjunto de celdas que están a la misma distancia en el DAG. El número de capas hasta que se procesa la última capa es la distancia desde el punto de inicio hasta la celda más lejana, es decir, la longitud del camino más largo

## Conocimientos previos

### ¿Qué es un DAG (grafo dirigido acíclico)?

Es un grafo compuesto por vértices y aristas dirigidas que no contiene ciclos. Al trazar aristas solo en la dirección en que los valores son estrictamente crecientes, no se puede volver al mismo valor, por lo que no se generan ciclos y se forma un DAG.

### ¿Qué es el grado de entrada (in-degree)?

Es el **número de aristas que llegan** a un vértice. En este problema, el grado de entrada de la celda `(i, j)` es "la cantidad de celdas adyacentes (arriba, abajo, izquierda, derecha) que tienen un valor menor que `matrix[i][j]`". Una celda con grado de entrada 0 significa un punto de inicio del camino al que no se puede llegar desde ninguna otra celda.

```java
// Ejemplo de cálculo del grado de entrada de la celda (i,j)
int indegree = 0;
for (int[] d : dirs) {
    int ni = i + d[0], nj = j + d[1];
    if (ni >= 0 && ni < m && nj >= 0 && nj < n
        && matrix[ni][nj] < matrix[i][j])  // Si la celda vecina es menor, entra una arista
        indegree++;
}
```

### ¿Qué es el ordenamiento topológico (BFS / algoritmo de Kahn)?

Es un método para ordenar los vértices de un DAG de manera que todas las aristas vayan en la dirección "anterior → posterior". En el algoritmo de Kahn, se agregan los vértices con grado de entrada 0 a la cola, y cada vez que se extrae uno, se reduce en 1 el grado de entrada de los vértices adyacentes; los vértices cuyo grado de entrada llega a 0 se agregan a la cola. Al repetir este proceso, se obtiene el orden topológico.

```java
Queue<int[]> q = new LinkedList<>();   // Se crea una cola para BFS
q.offer(new int[]{0, 1});             // Se agrega una coordenada de celda a la cola
q.isEmpty();                           // Devuelve un boolean indicando si la cola está vacía → false
q.size();                              // Devuelve el número de elementos en la cola → 1
int[] cell = q.poll();                 // Se extrae y devuelve el elemento del frente de la cola → {0, 1}
```

### Representación de las 4 direcciones de movimiento con un arreglo

Se definen las 4 direcciones (arriba, abajo, izquierda, derecha) como un arreglo bidimensional de `{cambio en fila, cambio en columna}`, y se procesa cada dirección en un bucle.

```java
int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};  // derecha, izquierda, abajo, arriba
for (int[] d : dirs) {
    int ni = i + d[0];  // Fila de destino
    int nj = j + d[1];  // Columna de destino
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m\*n) — O(m\*n) para calcular el grado de entrada de cada celda, y O(m\*n) para procesar cada celda exactamente una vez en el BFS |
| Space | O(m\*n) — Se almacenan hasta m\*n celdas tanto en el arreglo bidimensional de grados de entrada como en la cola del BFS |

## Código

```java
// Entrada: matriz de enteros matrix de tamaño m×n
// Salida: devuelve como int la longitud del camino más largo con valores estrictamente crecientes (número de celdas)
int longestIncreasingPath(int[][] matrix) {
    // Se obtienen el número de filas m y el número de columnas n
    int m = matrix.length;
    int n = matrix[0].length;
    // Se definen los desplazamientos en las 4 direcciones (derecha, izquierda, abajo, arriba)
    int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};

    // Se calcula el grado de entrada de cada celda (cantidad de celdas adyacentes con valor menor)
    // Grado de entrada = número de aristas que entran a la celda = cantidad de celdas adyacentes con valor menor
    int[][] indeg = new int[m][n];
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            for (int[] d : dirs) {
                int ni = i + d[0];
                int nj = j + d[1];
                // Si la celda adyacente está dentro del rango y es menor, entra una arista desde ella
                if (ni >= 0 && ni < m && nj >= 0 && nj < n
                    && matrix[ni][nj] < matrix[i][j])
                    indeg[i][j]++;
            }
        }
    }

    // Se agregan a la cola todas las celdas con grado de entrada 0 (puntos de inicio del camino)
    // Grado de entrada 0 = no hay valores menores alrededor = punto de inicio al que no se llega desde ninguna celda en el DAG
    Queue<int[]> q = new LinkedList<>();
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (indeg[i][j] == 0)
                q.offer(new int[]{i, j});

    // Se procesa el BFS capa por capa y se cuenta el número de capas
    // Cada capa es un conjunto de celdas que están a la misma distancia desde el punto de inicio en el DAG
    int pathLen = 0;
    while (!q.isEmpty()) {
        // Se obtiene la cantidad de celdas que pertenecen a la capa actual
        int size = q.size();
        // Se incrementa la longitud del camino en 1 cada vez que se avanza a una nueva capa (total de capas = longitud del camino más largo)
        pathLen++;
        for (int k = 0; k < size; k++) {
            int[] cell = q.poll();
            // Se examinan las celdas adyacentes en las 4 direcciones de la celda extraída
            for (int[] d : dirs) {
                int ni = cell[0] + d[0];
                int nj = cell[1] + d[1];
                // Si la celda adyacente está dentro del rango y es mayor, se procesa esa arista
                if (ni >= 0 && ni < m && nj >= 0 && nj < n
                    && matrix[ni][nj] > matrix[cell[0]][cell[1]]) {
                    // Se reduce el grado de entrada en 1 (se marca como procesada la arista de entrada desde esta celda)
                    indeg[ni][nj]--;
                    // Si el grado de entrada llega a 0 = todas las aristas de entrada fueron procesadas → se agrega a la cola como la siguiente capa
                    if (indeg[ni][nj] == 0)
                        q.offer(new int[]{ni, nj});
                }
            }
        }
    }
    // El número de capas del BFS es la longitud del camino creciente más largo
    // Por las restricciones del problema, la matriz no está vacía, por lo que se garantiza que pathLen >= 1
    return pathLen;
}
```
