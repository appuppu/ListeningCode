# Capturing Surrounded Regions on a Board — Capturar las regiones rodeadas en un tablero

## Esencia del problema

Se da un tablero de m×n compuesto por `'X'` y `'O'`. Se deben invertir a `'X'` todas las regiones de `'O'` que estén **completamente rodeadas** por `'X'`. Sin embargo, las `'O'` que están en contacto con el **borde** del tablero y las `'O'` conectadas a ellas no están rodeadas, por lo que no se deben invertir.

## Idea central

En lugar de "buscar las O rodeadas", se piensa con la lógica inversa: "marcar primero las O no rodeadas (= las O alcanzables desde el borde) y las O restantes son todas las que están rodeadas". Se realiza una DFS desde las O del borde para marcar las celdas conectadas como seguras, y finalmente se escanea el tablero de una sola vez, separando así la determinación de la inversión.

## Proceso de razonamiento

1. **Considerar las características de las O no rodeadas**: La condición para que una `'O'` no sea capturada es que esa `'O'` esté en el borde del tablero o que esté conectada a una `'O'` del borde mediante conexiones arriba, abajo, izquierda o derecha. Dicho de otra manera, todas las `'O'` que no son alcanzables desde una `'O'` del borde están rodeadas
2. **Iniciar la exploración desde el borde**: Se recorren los 4 lados del tablero (lado superior, lado inferior, lado izquierdo y lado derecho), y cada vez que se encuentra una `'O'`, se ejecuta una DFS desde ese punto. Todas las `'O'` alcanzables mediante la DFS son "seguras (no capturables)"
3. **Distinguir las celdas seguras con un marcador**: Se reescriben las `'O'` visitadas por la DFS con un marcador temporal `'S'` (Safe). De esta manera, después de finalizar la DFS, las `'O'` que quedan en el tablero son solo las celdas "aún no marcadas = rodeadas"
4. **Escanear el tablero de una sola vez para invertir y restaurar**: Se recorren todas las celdas: las celdas que siguen siendo `'O'` están rodeadas, por lo que se invierten a `'X'`. Las celdas `'S'` son `'O'` seguras, por lo que se restauran a la `'O'` original. Las celdas `'X'` se dejan tal cual
5. **Estructura recursiva de la DFS**: Se explora recursivamente en las 4 direcciones (arriba, abajo, izquierda, derecha) desde cada celda. La verificación de fuera de rango y la terminación en celdas que no son `'O'` sirven también como comprobación de celdas ya visitadas (las celdas reescritas a `'S'` no son `'O'`, por lo que no se vuelven a visitar)

## Conocimientos previos

### ¿Qué es la DFS (búsqueda en profundidad)?

Es un algoritmo para explorar grafos o cuadrículas. Se parte de un punto y se avanza lo más profundo posible en una dirección; cuando se llega a un callejón sin salida, se retrocede y se prueba otra dirección. Se implementa de forma natural mediante llamadas recursivas. En una cuadrícula, se visitan recursivamente las 4 direcciones: arriba, abajo, izquierda y derecha.

```java
// Patrón básico de DFS en una cuadrícula
void dfs(char[][] grid, int r, int c) {
    if (r < 0 || r >= grid.length          // Verificación de fuera de rango
        || c < 0 || c >= grid[0].length
        || grid[r][c] != 'O')              // Terminación en celda no objetivo
        return;
    grid[r][c] = 'S';                      // Marca de visitada (también previene revisitas)
    dfs(grid, r + 1, c);                   // Abajo
    dfs(grid, r - 1, c);                   // Arriba
    dfs(grid, r, c + 1);                   // Derecha
    dfs(grid, r, c - 1);                   // Izquierda
}
```

### Método para recorrer las celdas del borde

En un tablero de m×n, para enumerar las celdas de los 4 lados se hace lo siguiente. Para los lados superior e inferior se itera sobre las columnas, y para los lados izquierdo y derecho se itera sobre las filas.

```java
int m = board.length;    // Número de filas
int n = board[0].length; // Número de columnas

// Recorrer todas las columnas del lado superior (fila 0) y del lado inferior (fila m-1)
for (int j = 0; j < n; j++) {
    process(board[0][j]);      // Lado superior
    process(board[m - 1][j]);  // Lado inferior
}
// Recorrer todas las filas del lado izquierdo (columna 0) y del lado derecho (columna n-1)
for (int i = 0; i < m; i++) {
    process(board[i][0]);      // Lado izquierdo
    process(board[i][n - 1]);  // Lado derecho
}
```

### ¿Qué es la técnica de marcadores?

Es una técnica que distingue entre "visitada" y "no visitada" reescribiendo temporalmente las celdas del tablero con otro carácter (en este caso `'S'`). En lugar de preparar un arreglo de visitas `boolean[][]` aparte, se utiliza el propio tablero para la gestión de estado. Al final del procesamiento, se restauran los marcadores a sus valores originales.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m × n) — La DFS desde el borde visita cada celda como máximo una vez, y el escaneo final también recorre todas las celdas una vez |
| Space | O(m × n) — La pila de llamadas recursivas de la DFS alcanza en el peor caso una profundidad igual al número total de celdas |

## Código

```java
// Entrada: arreglo bidimensional de caracteres board de m×n compuesto por 'X' y 'O'
// Salida: se modifica board en el lugar (in-place). Se invierten las 'O' rodeadas a 'X' y no se devuelve valor (void)

// DFS que reescribe con el marcador S las O alcanzables desde el borde
void dfs(char[][] board, int r, int c, int m, int n) {
    // Si la celda está fuera de rango o no es 'O', no se hace nada (las celdas ya reescritas a 'S' también se descartan)
    // Las celdas reescritas a 'S' no son 'O', por lo que no se vuelven a visitar
    if (r < 0 || r >= m
        || c < 0 || c >= n
        || board[r][c] != 'O')
        return;

    // Se reescribe con el marcador de seguridad S (sirve también como marca de visitada)
    // En lugar de preparar un boolean[][] aparte, se utiliza el propio tablero para la gestión de estado
    board[r][c] = 'S';

    // Se explora recursivamente en las 4 direcciones: arriba, abajo, izquierda y derecha
    dfs(board, r + 1, c, m, n);
    dfs(board, r - 1, c, m, n);
    dfs(board, r, c + 1, m, n);
    dfs(board, r, c - 1, m, n);
}

public void solve(char[][] board) {
    // Se obtienen el número de filas y columnas. Se utilizan para la verificación de rango y el recorrido del borde
    int m = board.length;     // Número de filas
    int n = board[0].length;  // Número de columnas

    // Se inicia la DFS de borde desde cada columna de los lados superior e inferior
    // La DFS solo procesa si la celda objetivo es 'O', por lo que en celdas 'X' retorna sin hacer nada
    for (int j = 0; j < n; j++) {
        dfs(board, 0, j, m, n);       // Lado superior
        dfs(board, m - 1, j, m, n);   // Lado inferior
    }

    // Se inicia la DFS de borde desde cada fila de los lados izquierdo y derecho
    // Junto con el bucle anterior, se cubren los 4 lados del tablero como puntos de inicio
    for (int i = 0; i < m; i++) {
        dfs(board, i, 0, m, n);       // Lado izquierdo
        dfs(board, i, n - 1, m, n);   // Lado derecho
    }

    // Se escanea el tablero de una sola vez para invertir y restaurar
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (board[i][j] == 'O')
                board[i][j] = 'X';        // Las O no alcanzables desde el borde = rodeadas se invierten a X
            else if (board[i][j] == 'S')
                board[i][j] = 'O';        // Las O alcanzables desde el borde = marcador de seguridad se restauran a la O original
            // Las celdas 'X' no se modifican
        }
    }
}
```
