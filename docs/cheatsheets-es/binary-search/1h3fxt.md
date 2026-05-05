# Searching for a Value in a Sorted Matrix — Buscar un valor objetivo en una matriz ordenada

## Esencia del problema

Se da una matriz de m×n. Cada fila está ordenada en orden ascendente, y el primer elemento de cada fila es mayor que el último elemento de la fila anterior. Se debe determinar si el `target` dado existe en esta matriz y devolver un `boolean`.

## Idea central

Si se disponen todos los elementos de la matriz en una sola línea desde la esquina superior izquierda hasta la inferior derecha, se puede considerar como un único arreglo ordenado. Utilizando la conversión del índice unidimensional `mid` a las coordenadas de la matriz `[mid / n][mid % n]`, se puede buscar en O(log(m * n)) con una sola búsqueda binaria sin aplanar la matriz.

## Proceso de razonamiento

1. **La matriz completa es un único arreglo ordenado**: Dado que cada fila está en orden ascendente y el primer elemento de la siguiente fila es mayor que el último elemento de la fila anterior, al leer los elementos de la matriz desde la esquina superior izquierda hasta la inferior derecha, el conjunto forma un único arreglo ordenado ascendentemente
2. **Se puede aplicar búsqueda binaria a un arreglo ordenado**: El número total de elementos es `m * n`, por lo que se realiza una búsqueda binaria en el rango de 0 a `m * n - 1`. Se establece el límite inferior `lo = 0` y el límite superior `hi = m * n - 1`
3. **Se necesita la conversión de índice unidimensional a coordenadas bidimensionales**: El punto medio `mid` de la búsqueda binaria es un índice unidimensional. Para obtener el valor de la matriz se necesitan coordenadas bidimensionales, por lo que se convierte el índice de fila como `mid / n` (cociente de dividir entre el número de columnas) y el índice de columna como `mid % n` (resto de dividir entre el número de columnas)
4. **Se aplica la lógica estándar de búsqueda binaria**: Si el valor obtenido con `matrix[mid / n][mid % n]` es igual a `target`, se devuelve `true`. Si es menor, se reduce el rango de búsqueda a la mitad derecha con `lo = mid + 1`. Si es mayor, se reduce a la mitad izquierda con `hi = mid - 1`
5. **Si el rango de búsqueda se agota, el target no existe**: Si no se encuentra una coincidencia antes de que `lo > hi`, el `target` no existe en la matriz, por lo que se devuelve `false`

## Conocimientos previos

### ¿Qué es la búsqueda binaria (Binary Search)?

Es un algoritmo que encuentra rápidamente un valor objetivo en un arreglo ordenado reduciendo el rango de búsqueda a la mitad en cada iteración. Para n elementos, se obtiene el resultado con un máximo de log₂(n) comparaciones.

```java
int lo = 0, hi = array.length - 1;  // Se establecen el límite inferior y superior del rango de búsqueda
while (lo <= hi) {                    // Se itera mientras exista un rango de búsqueda
    int mid = lo + (hi - lo) / 2;    // Se calcula el punto medio evitando el desbordamiento
    if (array[mid] == target)         // Se verifica si el valor del punto medio coincide con target
        return true;
    else if (array[mid] < target)
        lo = mid + 1;                // El target está en la mitad derecha, se eleva el límite inferior
    else
        hi = mid - 1;                // El target está en la mitad izquierda, se reduce el límite superior
}
return false;                         // Caso en que no se encontró el valor
```

### Conversión entre índice unidimensional y coordenadas bidimensionales

En una matriz con `n` columnas, la conversión del índice unidimensional `idx` a coordenadas bidimensionales se realiza mediante división y módulo. Esta conversión permite tratar la matriz como un arreglo unidimensional virtual.

```java
int n = matrix[0].length;        // Se obtiene el número de columnas
int row = idx / n;               // El cociente es el índice de fila (ej: idx=7, n=4 → row=1)
int col = idx % n;               // El resto es el índice de columna (ej: idx=7, n=4 → col=3)
int val = matrix[row][col];      // Se obtiene el valor de la matriz con las coordenadas bidimensionales
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(log(m * n)) — Se realiza una búsqueda binaria sobre el total de m * n elementos |
| Space | O(1) — Solo se usan variables de puntero, no se requieren estructuras de datos adicionales |

## Código

```java
// Entrada: una matriz de enteros m×n matrix y un entero target
// Salida: devuelve true si target existe en la matriz, false en caso contrario
public boolean searchMatrix(int[][] matrix, int target) {
    // Se obtienen el número de filas y columnas de la matriz. Se usan para calcular el total de elementos y la conversión 1D→2D
    int m = matrix.length;
    int n = matrix[0].length;

    // Se establece el rango de búsqueda binaria sobre toda la matriz
    // lo=0 corresponde a la esquina superior izquierda, hi=m*n-1 corresponde a la esquina inferior derecha
    int lo = 0, hi = m * n - 1;

    // Cuando lo > hi, el rango de búsqueda se agota y se determina que target no existe
    while (lo <= hi) {
        // Se usa esta forma en lugar de (lo + hi) / 2 para evitar el desbordamiento de enteros en lo + hi
        int mid = lo + (hi - lo) / 2;

        // Se convierte el índice unidimensional a coordenadas bidimensionales para obtener el valor
        // Índice de fila = mid / n (cociente), índice de columna = mid % n (resto)
        int val = matrix[mid / n][mid % n];

        if (val == target)
            return true;           // Se encontró el valor objetivo, se devuelve true
        else if (val < target)
            lo = mid + 1;          // El target está en la mitad derecha (lado mayor), se eleva el límite inferior
        else
            hi = mid - 1;          // El target está en la mitad izquierda (lado menor), se reduce el límite superior
    }

    // El bucle terminó sin devolver true, por lo que target no existe en la matriz
    return false;
}
```
