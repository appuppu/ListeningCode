# Finding Cells That Drain to Both Oceans — Encontrar todas las celdas cuyo agua fluye hacia ambos océanos

## Esencia del problema

Se da una matriz de alturas de m×n. El océano Pacífico limita con el borde superior y el borde izquierdo, y el océano Atlántico limita con el borde inferior y el borde derecho. El agua fluye desde una celda actual hacia una celda adyacente cuando la altura de la celda adyacente es menor o igual a la de la celda actual. Se deben encontrar todas las celdas desde las cuales el agua puede llegar **tanto** al océano Pacífico como al océano Atlántico.

## Idea central

Si se evalúa la alcanzabilidad desde cada celda hacia el océano en dirección directa, los cálculos se duplican. En cambio, si se realiza un BFS desde las celdas fronterizas del océano hacia el interior en la dirección en la que "el agua puede remontar (celdas adyacentes con altura igual o mayor)", se obtiene el conjunto de celdas alcanzables para cada océano en O(m*n), y la intersección de los dos conjuntos es la respuesta.

## Proceso de razonamiento

1. **La exploración en dirección directa es ineficiente**: Si se exploran rutas desde cada celda (i,j) hacia el océano, se necesita BFS/DFS para cada una de las O(m*n) celdas, lo que resulta en O((m*n)²) en total. La exploración independiente por celda tiene muchas redundancias, por lo que se considera la exploración en dirección inversa
2. **Invertir el enfoque**: "El agua fluye desde una celda hacia el océano" es equivalente a "existe un camino no decreciente en altura desde el océano hacia la celda". Si se realiza un BFS en dirección de reflujo desde la frontera del océano, se puede obtener el conjunto de celdas alcanzables de una sola vez
3. **Procesar los dos océanos de forma independiente**: Se colocan todas las celdas fronterizas del Pacífico (borde superior + borde izquierdo) en la cola y se ejecuta un BFS, registrando las celdas alcanzables. Se hace lo mismo con las celdas fronterizas del Atlántico (borde inferior + borde derecho). Las dos exploraciones son independientes entre sí, por lo que se puede reutilizar la misma lógica
4. **Definir la condición de transición del BFS**: Como se trata de un reflujo, la transición se realiza cuando la altura de la celda adyacente es **mayor o igual** a la de la celda actual. Esto es el inverso de "el agua fluye de lugares altos a lugares bajos"
5. **Obtener la intersección**: Las celdas marcadas como alcanzadas en ambos BFS son las celdas cuyo agua fluye hacia ambos océanos. Se recorren todas las celdas y se agregan a la lista de resultados aquellas que son true en ambos conjuntos

## Conocimientos previos

### ¿Qué es el BFS de múltiples fuentes (Multi-source BFS)?

El BFS normal comienza desde un único punto de partida, pero en esta técnica se colocan múltiples puntos de partida en la cola antes de iniciar el BFS. Se obtiene el mismo efecto que si la exploración se expandiera simultáneamente desde todos los puntos de partida, y se pueden determinar las celdas alcanzables desde todos los orígenes con un solo BFS.

```java
Queue<int[]> queue = new LinkedList<>();
// Se agregan todos los puntos de partida a la cola
queue.offer(new int[]{0, 0});
queue.offer(new int[]{0, 1});
queue.offer(new int[]{0, 2});
// Se explora simultáneamente desde todos los orígenes en un solo bucle while
while (!queue.isEmpty()) {
    int[] cell = queue.poll();
    // Se exploran las celdas adyacentes según la condición
}
```

### Gestión de celdas visitadas mediante boolean[][]

Se utiliza un arreglo bidimensional de booleanos para registrar si cada celda ha sido alcanzada. El valor inicial es false, y se establece en true para las celdas alcanzadas. Esto evita que se procese la misma celda más de una vez.

```java
boolean[][] reach = new boolean[m][n];  // Arreglo de m×n inicializado en false
reach[r][c] = true;   // Se marca la celda (r,c) como alcanzada
if (!reach[nr][nc])   // Se verifica si la celda (nr,nc) no ha sido alcanzada
```

### Vectores de movimiento en 4 direcciones

Los movimientos hacia arriba, abajo, izquierda y derecha en una cuadrícula se representan mediante un arreglo. Al iterar sobre las 4 direcciones en un bucle, se puede escribir la ramificación en cada dirección sin duplicar código.

```java
int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};  // derecha, izquierda, abajo, arriba
for (int[] d : dirs) {
    int nr = r + d[0];  // Nuevo índice de fila
    int nc = c + d[1];  // Nuevo índice de columna
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m×n) — Cada BFS visita cada celda como máximo una vez, y se ejecutan 2 BFS |
| Space | O(m×n) — Los dos arreglos de booleanos y la cola del BFS contienen como máximo m×n celdas cada uno |

## Código

```java
// Entrada: matriz de enteros heights de m×n (altura de cada celda)
// Salida: coordenadas de las celdas cuyo agua puede llegar a ambos océanos, como List<List<Integer>>

// Vectores de movimiento en las 4 direcciones: arriba, abajo, izquierda y derecha
int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};

// Se ejecuta un BFS de múltiples fuentes y se devuelve un arreglo de booleanos con las celdas alcanzables
boolean[][] bfs(int[][] h, Queue<int[]> q) {
    int m = h.length, n = h[0].length;
    // Arreglo que registra si cada celda es alcanzable por reflujo desde el océano
    boolean[][] reach = new boolean[m][n];

    // Se marcan como alcanzados todos los puntos de partida en la cola (las celdas fronterizas están directamente en contacto con el océano)
    for (int[] c : q)
        reach[c[0]][c[1]] = true;

    while (!q.isEmpty()) {
        int[] cell = q.poll();
        int r = cell[0], c = cell[1];

        // Se examinan las celdas adyacentes en las 4 direcciones
        for (int[] d : dirs) {
            int nr = r + d[0];
            int nc = c + d[1];

            // Si está dentro del rango, no ha sido alcanzada y su altura es mayor o igual a la actual (reflujo posible), se expande la exploración
            // La condición de altura mayor o igual representa el inverso de "el agua fluye de lugares altos a lugares bajos"
            if (nr >= 0 && nr < m
                && nc >= 0 && nc < n
                && !reach[nr][nc]
                && h[nr][nc] >= h[r][c]) {
                reach[nr][nc] = true;
                q.offer(new int[]{nr, nc});
            }
        }
    }
    return reach;
}

List<List<Integer>> pacificAtlantic(int[][] heights) {
    int m = heights.length;
    int n = heights[0].length;

    // Se crean las colas para el Pacífico y el Atlántico (conjuntos de puntos de partida del Multi-source BFS)
    Queue<int[]> pQ = new LinkedList<>();
    Queue<int[]> aQ = new LinkedList<>();

    // El borde superior está directamente en contacto con el Pacífico, por lo que es punto de partida del Pacífico; el borde inferior está directamente en contacto con el Atlántico, por lo que es punto de partida del Atlántico
    for (int j = 0; j < n; j++) {
        pQ.offer(new int[]{0, j});
        aQ.offer(new int[]{m - 1, j});
    }

    // El borde izquierdo está directamente en contacto con el Pacífico, por lo que es punto de partida del Pacífico; el borde derecho está directamente en contacto con el Atlántico, por lo que es punto de partida del Atlántico
    for (int i = 0; i < m; i++) {
        pQ.offer(new int[]{i, 0});
        aQ.offer(new int[]{i, n - 1});
    }

    // Se ejecuta el BFS de reflujo desde cada océano y se obtiene el conjunto de celdas alcanzables
    boolean[][] pacReach = bfs(heights, pQ);
    boolean[][] atlReach = bfs(heights, aQ);

    // Se agregan a la lista de resultados las celdas alcanzables desde ambos océanos
    // Que ambos sean true significa que desde esa celda el agua puede fluir tanto al Pacífico como al Atlántico
    List<List<Integer>> res = new ArrayList<>();
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (pacReach[i][j] && atlReach[i][j])
                res.add(Arrays.asList(i, j));

    return res;
}
```
