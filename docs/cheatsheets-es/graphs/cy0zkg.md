# Simulating Rotting Oranges Spreading — Encontrar el tiempo mínimo hasta que se complete la propagación de naranjas podridas

## Esencia del problema

Se proporciona una cuadrícula de m×n donde cada celda contiene 0 (vacía), 1 (naranja fresca) o 2 (naranja podrida). Cada minuto, una naranja podrida pudre las naranjas frescas adyacentes en las cuatro direcciones (arriba, abajo, izquierda, derecha). Se debe devolver el **número mínimo de minutos** hasta que todas las naranjas frescas se pudran. Si es imposible pudrir todas las naranjas, se devuelve -1.

## Idea central

Las naranjas podridas se propagan a las celdas adyacentes "simultáneamente". Esto es exactamente un "Multi-Source BFS" que inicia BFS desde múltiples puntos de partida al mismo tiempo, donde cada nivel (capa) del BFS corresponde a un minuto.

## Proceso de razonamiento

1. **La propagación ocurre simultáneamente**: Cuando hay múltiples naranjas podridas, cada una pudre las celdas adyacentes al mismo tiempo. No se trata de una búsqueda desde un solo punto de partida, sino que es necesario usar todas las naranjas podridas como puntos de partida simultáneos
2. **Se usa Multi-Source BFS para la partida simultánea**: Si se insertan todas las naranjas podridas en la cola al inicio, un nivel de BFS (una ronda que procesa tantos elementos como el tamaño actual de la cola) corresponde a un minuto de propagación. DFS no puede garantizar el "tiempo mínimo", por lo que BFS es adecuado
3. **Se rastrea la cantidad de naranjas frescas**: Si después de que termina la propagación quedan naranjas frescas, se trata de un caso imposible. Por ello, se cuenta la cantidad de naranjas frescas en el estado inicial y se decrementa cada vez que se pudre una
4. **Método de medición del tiempo transcurrido**: Se procesan todos los elementos de la cola por nivel de BFS, y cada vez que se completa un nivel se suma 1 minuto al tiempo transcurrido. El número de niveles en el momento en que las naranjas frescas llegan a 0 es la respuesta
5. **Condición de terminación y determinación de imposibilidad**: Si después de que termina el BFS `fresh > 0`, existen naranjas frescas inalcanzables, por lo que se devuelve -1. Si `fresh == 0`, se devuelve el tiempo transcurrido

## Conocimientos previos

### ¿Qué es BFS (Búsqueda en Anchura)?

Es un algoritmo que explora grafos o cuadrículas "en orden de menor distancia desde el punto de partida". Usa una cola (FIFO), procesa todos los nodos del nivel actual y luego avanza al siguiente nivel. Es adecuado para problemas que requieren encontrar la distancia mínima o el tiempo mínimo.

### ¿Qué es Multi-Source BFS?

El BFS normal tiene un solo punto de partida, pero Multi-Source BFS inicia el BFS con múltiples puntos de partida insertados en la cola. Se usa para simulaciones donde la propagación ocurre simultáneamente desde todos los puntos de partida. Excepto que el estado inicial de la cola contiene múltiples elementos, es igual que el BFS normal.

### ¿Qué es una Queue (Cola)?

Es una estructura de datos de tipo primero en entrar, primero en salir (FIFO). En BFS se usa para procesar los nodos a explorar en orden.

```java
Queue<int[]> queue = new LinkedList<>();  // Crear una cola con elementos de tipo arreglo de int
queue.offer(new int[]{0, 1});  // Agregar un elemento al final de la cola
int[] pos = queue.poll();       // Extraer y eliminar el elemento del inicio de la cola → {0, 1}
queue.size();                   // Devolver la cantidad de elementos en la cola
queue.isEmpty();                // Devolver un boolean indicando si la cola está vacía
```

### ¿Qué es un arreglo de direcciones?

Es una técnica para enumerar las celdas adyacentes en las cuatro direcciones durante la exploración de cuadrículas. Se definen los desplazamientos de fila y columna en un arreglo y se recorren con un bucle.

```java
int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};  // 4 direcciones: derecha, izquierda, abajo, arriba
for (int[] d : dirs) {
    int nr = row + d[0];  // Índice de fila de la celda adyacente
    int nc = col + d[1];  // Índice de columna de la celda adyacente
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m × n) — Se procesa cada celda de la cuadrícula una vez en el recorrido inicial y como máximo una vez en el BFS |
| Space | O(m × n) — La cola puede almacenar como máximo m×n celdas |

## Código

```java
// Entrada: cuadrícula de enteros grid de m×n (cada celda es 0=vacía, 1=naranja fresca, 2=naranja podrida)
// Salida: devolver como int el número mínimo de minutos hasta que todas las naranjas frescas se pudran. Devolver -1 si es imposible
public int orangesRotting(int[][] grid) {
    int rows = grid.length;
    int cols = grid[0].length;
    // Cola para BFS. Almacena las coordenadas de las celdas a explorar
    Queue<int[]> queue = new LinkedList<>();
    // Variable que rastrea la cantidad de naranjas frescas restantes
    int fresh = 0;

    // Recorrer toda la cuadrícula para preparar simultáneamente los múltiples puntos de partida del BFS y la cantidad restante hasta el objetivo
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] == 2) {
                // Agregar la naranja podrida a la cola (punto de partida del Multi-Source BFS)
                queue.offer(new int[]{i, j});
            } else if (grid[i][j] == 1) {
                // Contar la cantidad de naranjas frescas
                fresh++;
            }
        }
    }

    // Arreglo de direcciones que representa las 4 direcciones (arriba, abajo, izquierda, derecha). Se usa para enumerar celdas adyacentes
    int[][] dirs = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
    int minutes = 0;

    // Se incluye como condición no solo que la cola no esté vacía, sino también que queden naranjas frescas, para evitar bucles innecesarios después de que todas se hayan podrido
    while (!queue.isEmpty() && fresh > 0) {
        // Guardar previamente la cantidad de celdas a procesar en este nivel (1 minuto). Esto es para distinguirlas de los elementos del siguiente nivel que se agregan durante el bucle
        int size = queue.size();
        // Se inicia el procesamiento de un nivel, por lo que se suma 1 minuto al tiempo transcurrido
        minutes++;

        // Extraer elementos de la cola exactamente size veces para procesar todas las celdas de este nivel
        for (int k = 0; k < size; k++) {
            int[] pos = queue.poll();

            // Usar el arreglo de direcciones para verificar las 4 celdas adyacentes (arriba, abajo, izquierda, derecha)
            for (int[] d : dirs) {
                int nr = pos[0] + d[0];
                int nc = pos[1] + d[1];

                // Si está dentro del rango y es una naranja fresca, pudrirla
                if (nr >= 0 && nr < rows
                    && nc >= 0 && nc < cols
                    && grid[nr][nc] == 1) {
                    // Actualizar la celda a 2 para marcarla como visitada (reemplaza un arreglo visited. Previene el procesamiento duplicado de la misma celda)
                    grid[nr][nc] = 2;
                    fresh--;
                    queue.offer(new int[]{nr, nc});
                }
            }
        }
    }

    // Si quedan naranjas frescas, son inalcanzables, por lo que se devuelve -1. De lo contrario, se devuelve el tiempo transcurrido
    return fresh > 0 ? -1 : minutes;
}
```
