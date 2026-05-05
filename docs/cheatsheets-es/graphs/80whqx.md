# Finding the Largest Island by Area — Encontrar la isla con la mayor área en una cuadrícula 2D

## Esencia del problema

Se proporciona una cuadrícula binaria 2D compuesta por `1` (tierra) y `0` (agua). Una isla es un grupo de celdas con valor `1` conectadas horizontal o verticalmente entre sí. Se debe encontrar y devolver **el área máxima** (número de celdas) entre todas las islas de la cuadrícula. Si no existe ninguna isla, se devuelve `0`.

## Idea central

Si se cuentan las celdas de tierra conectadas mediante DFS desde cada celda de tierra, se obtiene el área de la isla. En lugar de gestionar las celdas visitadas con un arreglo separado, se sobreescribe el valor de cada celda visitada a `0`, lo que evita visitas duplicadas sin necesidad de memoria adicional.

## Proceso de razonamiento

1. **El área de una isla es el tamaño de un componente conexo**: Un grupo de `1` conectados horizontal y verticalmente en la cuadrícula constituye una isla. El área de la isla es la cantidad de celdas que pertenecen a ese grupo. Por lo tanto, basta con calcular el tamaño de cada componente conexo y devolver el valor máximo
2. **DFS es adecuado para explorar componentes conexos**: Si una celda `(r, c)` tiene valor `1`, se puede partir desde ella y explorar recursivamente las celdas adyacentes en las cuatro direcciones mediante DFS, contando todos los `1` conectados para obtener el área de esa isla
3. **Se necesita un mecanismo para no contar la misma celda múltiples veces**: Si se vuelve a visitar una celda ya explorada por DFS, el área se contará dos veces. Normalmente se prepara un arreglo `boolean[][] visited` para registrar las celdas visitadas, pero esto requiere O(m × n) de memoria adicional
4. **Sobreescribir las celdas visitadas con `0` elimina la necesidad de memoria adicional**: Si se cambia el valor de una celda visitada por DFS de `1` a `0`, esa celda se trata como agua y no se vuelve a visitar en exploraciones posteriores. Esto permite evitar duplicados sin usar un arreglo `visited`, reduciendo la memoria auxiliar a O(1)
5. **El valor de retorno de DFS acumula el área**: DFS devuelve `1` (por la propia celda visitada) más la suma de los valores de retorno de las llamadas recursivas en las cuatro direcciones. Como caso base, las celdas fuera del rango de la cuadrícula o con valor `0` devuelven `0`. De esta manera, una sola llamada a DFS acumula recursivamente el área total de la isla
6. **Se recorre toda la cuadrícula para encontrar el valor máximo**: Se recorren todas las celdas de la cuadrícula con un doble bucle for y se llama a DFS para cada celda. Se compara el valor de retorno de DFS (área de la isla) con el máximo actual y se conserva el mayor. Para las celdas con valor `0`, el caso base de DFS devuelve inmediatamente `0`, por lo que no se necesita una condición especial

## Conocimientos previos

### Qué es DFS (búsqueda en profundidad)

Es un algoritmo de exploración para grafos y cuadrículas. Parte de un nodo y avanza lo más profundo posible antes de retroceder. En una cuadrícula 2D, moviéndose recursivamente desde una celda hacia las celdas adyacentes en las cuatro direcciones, se pueden visitar todas las celdas conectadas.

```java
// Estructura básica de DFS en una cuadrícula 2D
void dfs(int[][] grid, int r, int c) {
    if (r < 0 || r >= grid.length || c < 0 || c >= grid[0].length)
        return;                    // Terminar si está fuera del rango de la cuadrícula
    dfs(grid, r - 1, c);          // Recursión hacia arriba
    dfs(grid, r + 1, c);          // Recursión hacia abajo
    dfs(grid, r, c - 1);          // Recursión hacia la izquierda
    dfs(grid, r, c + 1);          // Recursión hacia la derecha
}
```

### Qué es la modificación in-place (modificación en el lugar)

Es una técnica que modifica los datos de entrada directamente para registrar el estado sin usar estructuras de datos adicionales (como arreglos o conjuntos). En este problema, se sobreescriben las celdas de tierra visitadas con `0`, lo que sirve como sustituto del arreglo `visited`.

```java
grid[r][c] = 0;  // Sobreescribir la tierra visitada (1) con agua (0)
```

### Qué es Math.max

Es un método estándar de Java que compara dos valores y devuelve el mayor. Se utiliza en situaciones donde se actualiza continuamente el valor máximo dentro de un bucle.

```java
Math.max(3, 7);   // → 7 (devuelve el mayor)
Math.max(10, 2);  // → 10
```

## Complejidad computacional

| | Valor |
|---|---|
| Tiempo | O(m × n) — Cada celda de la cuadrícula se visita como máximo 2 veces (1 vez en el bucle y 1 vez en DFS) |
| Espacio | O(1) de memoria auxiliar — Se modifica la cuadrícula directamente sin usar un arreglo visited. Sin embargo, la pila de recursión utiliza como máximo O(m × n) |

## Código

```java
// Entrada: arreglo 2D de enteros grid compuesto por 1 (tierra) y 0 (agua)
// Salida: devuelve el área máxima de una isla en la cuadrícula como int. Si no hay islas, devuelve 0

// DFS: cuenta las celdas de tierra conectadas y sobreescribe las celdas visitadas con 0
int dfs(int[][] grid, int r, int c) {
    // Caso base: no contar si está fuera del rango, es agua (0) o ya fue visitada
    if (r < 0 || r >= grid.length
        || c < 0 || c >= grid[0].length
        || grid[r][c] == 0)
        return 0;

    // Sobreescribir la tierra (1) con agua (0) como marca de visitada (la modificación in-place elimina la necesidad del arreglo visited)
    grid[r][c] = 0;

    // Devolver 1 (por sí misma) + la suma de celdas conectadas en las cuatro direcciones
    // Al sumar los valores de retorno de las recursiones en 4 direcciones, el área total de la isla se acumula recursivamente
    return 1 + dfs(grid, r - 1, c)   // arriba
             + dfs(grid, r + 1, c)   // abajo
             + dfs(grid, r, c - 1)   // izquierda
             + dfs(grid, r, c + 1);  // derecha
}

int maxAreaOfIsland(int[][] grid) {
    // Obtener el número de filas y columnas de la cuadrícula
    int m = grid.length;
    int n = grid[0].length;
    // Inicializar la variable de área máxima en 0 (si no hay islas, se devuelve este valor tal cual)
    int maxArea = 0;

    // Recorrer todas las celdas con un doble bucle for y encontrar el área máxima entre todas las islas
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            // Para las celdas con valor 0, el caso base de DFS devuelve inmediatamente 0, por lo que no se necesita una condición especial
            maxArea = Math.max(maxArea,
                dfs(grid, i, j));

    return maxArea;
}
```
