# Counting Unique Paths in a Grid — Contar el número de rutas únicas desde la esquina superior izquierda hasta la inferior derecha de un grid

## Esencia del problema

Se da un grid de `m × n`. Desde la celda superior izquierda `(0, 0)` hasta la celda inferior derecha `(m-1, n-1)`, en cada paso solo se puede mover **hacia la derecha o hacia abajo**. Se debe devolver el número total de rutas únicas.

## Idea central

El número de rutas hacia una celda es la suma del "número de rutas hacia la celda de arriba" y el "número de rutas hacia la celda de la izquierda". Si se completa esta recurrencia de forma bottom-up, se obtiene la respuesta. Además, dado que el cálculo de cada fila depende únicamente de la fila anterior y la fila actual, se puede ahorrar espacio utilizando solo un arreglo de una fila.

## Proceso de razonamiento

1. **El número de rutas hacia cada celda se puede descomponer en subproblemas**: Para llegar a la celda `(i, j)`, se debe venir necesariamente desde arriba `(i-1, j)` o desde la izquierda `(i, j-1)`. Por lo tanto, se establece la recurrencia `dp[i][j] = dp[i-1][j] + dp[i][j-1]`
2. **Definir los casos base**: A las celdas de la fila superior solo se puede llegar desde la izquierda, y a las celdas de la columna izquierda solo se puede llegar desde arriba. En ambos casos el número de rutas es 1, por lo que se inicializa con `dp[0][j] = 1` y `dp[i][0] = 1`
3. **Llenar de izquierda a derecha por cada fila**: Dado que la recurrencia depende de "la celda de arriba" y "la celda de la izquierda", si se recorren las filas de arriba hacia abajo y dentro de cada fila de izquierda a derecha, los valores necesarios siempre están ya calculados
4. **Se puede comprimir el espacio a una sola fila**: `dp[i][j]` depende únicamente del vecino izquierdo en la misma fila `dp[i][j-1]` y de la misma columna en la fila anterior `dp[i-1][j]`. Al usar un arreglo unidimensional `dp[j]`, el valor de `dp[j]` antes de la actualización corresponde al "valor de la celda de arriba", y el valor ya actualizado de `dp[j-1]` corresponde al "valor de la celda de la izquierda", por lo que la recurrencia se expresa como `dp[j] += dp[j-1]`
5. **La inicialización establece todos los elementos en 1**: Inicializar el arreglo unidimensional con todos los valores en 1 representa el estado de la fila superior (donde el número de rutas a cada celda es 1). El elemento `dp[0]`, que corresponde a la columna izquierda, no se actualiza en el bucle interno y permanece siempre en 1, por lo que el caso base de la columna izquierda se mantiene de forma natural
6. **Qué devolver al final**: Después de procesar todas las filas, `dp[n-1]` contiene el número de rutas hacia la celda inferior derecha, por lo que se devuelve este valor

## Conocimientos previos

### Qué es Arrays.fill

Es un método utilitario que inicializa todos los elementos de un arreglo con un valor especificado de una sola vez. Permite llenar un arreglo con un valor uniforme sin necesidad de escribir un bucle.

```java
int[] dp = new int[5];       // Crear un arreglo de longitud 5 (valor inicial de todos los elementos es 0)
Arrays.fill(dp, 1);          // Establecer todos los elementos en 1 → [1, 1, 1, 1, 1]
```

### Qué es la compresión de espacio mediante DP unidimensional

Es una técnica que permite reemplazar un arreglo bidimensional por uno unidimensional cuando el cálculo de cada celda en una tabla de DP bidimensional depende únicamente de "la fila actual" y "la fila anterior". Al sobrescribir y actualizar el arreglo fila por fila, se reduce el espacio de O(m×n) a O(n).

```java
// Caso bidimensional: dp[i][j] = dp[i-1][j] + dp[i][j-1]
// Compresión a unidimensional: dp[j] += dp[j-1]
//   dp[j] (antes de actualizar) = valor de la misma columna en la fila anterior (equivale a dp[i-1][j])
//   dp[j-1] (ya actualizado) = valor del vecino izquierdo en la fila actual (equivale a dp[i][j-1])
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m × n) — Se recorre cada celda del grid una vez |
| Space | O(n) — Solo se mantiene un arreglo de una fila |

## Código

```java
// Entrada: entero m (número de filas) y entero n (número de columnas)
// Salida: devolver como entero el número de rutas únicas desde la esquina superior izquierda hasta la inferior derecha
public int uniquePaths(int m, int n) {
    // Crear un arreglo DP de una fila de longitud n e inicializar todos los elementos en 1
    // Al establecer todos en 1, se configura el caso base de la fila superior (el número de rutas a cada celda es 1)
    int[] dp = new int[n];
    Arrays.fill(dp, 1);

    // La fila i=0 (fila superior) ya está configurada por la inicialización, por lo que se comienza desde i=1
    for (int i = 1; i < m; i++) {
        // j=0 (columna izquierda) debe permanecer siempre en 1, por lo que se comienza desde j=1
        for (int j = 1; j < n; j++) {
            // dp[j] (antes de actualizar) = valor de la misma columna en la fila anterior (número de rutas desde arriba)
            // dp[j-1] (ya actualizado) = valor del vecino izquierdo en la fila actual (número de rutas desde la izquierda)
            // Esta suma realiza la recurrencia dp[i][j] = dp[i-1][j] + dp[i][j-1] sobre el arreglo unidimensional
            dp[j] += dp[j - 1];
        }
    }

    // dp[n-1] contiene el número de rutas únicas hacia la celda inferior derecha (m-1, n-1) del grid
    return dp[n - 1];
}
```
