# Rotating a Matrix 90 Degrees — Rotar una matriz n×n 90 grados en sentido horario sin memoria adicional

## Esencia del problema

Se da una matriz cuadrada de n×n. Se debe rotar esta matriz 90 grados en sentido horario. La transformación se realiza **in-place (en el lugar)** sin asignar una nueva matriz. Después de la rotación, cada elemento `matrix[i][j]` de la matriz original se mueve a la posición `matrix[j][n-1-i]`.

## Idea central

La rotación de 90 grados se puede descomponer en dos operaciones simples: "transposición (intercambiar filas y columnas)" + "invertir cada fila de izquierda a derecha". Gracias a esta descomposición, se puede mover cada elemento a su posición correcta sin memoria adicional.

## Proceso de razonamiento

1. **Observar el destino de la rotación**: El elemento `matrix[i][j]` se mueve a `matrix[j][n-1-i]` con una rotación de 90 grados en sentido horario. Si se realiza esta transformación elemento por elemento, se necesita una permutación cíclica de 4 elementos, lo cual resulta complejo
2. **Considerar si la rotación se puede descomponer en operaciones conocidas**: La operación de transposición mueve `matrix[i][j]` a `matrix[j][i]`. Si después de la transposición se invierte cada fila de izquierda a derecha, `matrix[j][i]` se mueve a `matrix[j][n-1-i]`. Esto coincide con la rotación de 90 grados: `matrix[i][j]` → `matrix[j][n-1-i]`
3. **Cómo realizar la transposición in-place**: Se intercambian los elementos del triángulo superior y del triángulo inferior respecto a la diagonal (`i == j`). Si se hace swap de `matrix[i][j]` y `matrix[j][i]` en el rango donde `j > i`, cada par se intercambia exactamente una vez
4. **Cómo realizar la inversión de cada fila in-place**: Para cada fila, se preparan dos punteros en el extremo izquierdo y el extremo derecho, y se intercambian los elementos avanzando hacia el centro. Esta operación no requiere memoria adicional
5. **Aplicar las dos operaciones en orden**: Primero se transpone toda la matriz, luego se invierte cada fila. Como ambas operaciones se realizan in-place, la rotación de 90 grados se completa con O(1) de memoria adicional en total

## Conocimientos previos

### Qué es la transposición (Transpose)

Es la operación de intercambiar las filas y columnas de una matriz. Se intercambian las posiciones de los elementos `matrix[i][j]` y `matrix[j][i]`. En el caso de una matriz cuadrada, los elementos sobre la diagonal no se mueven, y se intercambian los elementos en posiciones simétricas respecto a la diagonal.

```java
// Ejemplo de transposición de una matriz 3×3
// Antes de transponer:   Después de transponer:
// [1, 2, 3]              [1, 4, 7]
// [4, 5, 6]  →           [2, 5, 8]
// [7, 8, 9]              [3, 6, 9]

// Se intercambian matrix[0][1]=2 y matrix[1][0]=4
int temp = matrix[i][j];
matrix[i][j] = matrix[j][i];
matrix[j][i] = temp;
```

### Qué es la inversión de un arreglo (Reverse)

Es la operación de intercambiar simétricamente los elementos de un arreglo de izquierda a derecha. Se avanza con punteros desde el extremo izquierdo y el extremo derecho hacia el centro, intercambiando los elementos.

```java
// [1, 4, 7] → [7, 4, 1]
int left = 0, right = n - 1;
while (left < right) {
    int temp = array[left];
    array[left] = array[right];
    array[right] = temp;
    left++;
    right--;
}
```

### Qué es la operación in-place (en el lugar)

Es una operación que modifica directamente los datos de entrada sin asignar una nueva estructura de datos. El uso de variables temporales (`temp`) es O(1), por lo que se permite. Dado que el problema indica "no asignar una nueva matriz", es necesario resolverlo in-place.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n²) — Se realizan n²/2 intercambios en la transposición y n²/2 intercambios en la inversión |
| Space | O(1) — Solo se usan variables temporales, no se asigna una nueva matriz |

## Código

```java
// Entrada: matriz de enteros n×n matrix (arreglo bidimensional int[][]). Al ser una matriz cuadrada, el número de filas y columnas es igual
// Salida: ninguna (void). Se modifica la propia matrix pasada como argumento para que quede rotada 90 grados en sentido horario
public void rotate(int[][] matrix) {
    // Se obtiene el tamaño n de la matriz con matrix.length
    int n = matrix.length;

    // Paso 1: Transposición (intercambiar elementos respecto a la diagonal para intercambiar filas y columnas)
    for (int i = 0; i < n; i++) {
        // j comienza en i+1 porque: en la diagonal (i==j) no se necesita intercambiar, y el rango j<i ya fue intercambiado
        for (int j = i + 1; j < n; j++) {
            // Se intercambian matrix[i][j] y matrix[j][i] usando una variable temporal para intercambiar filas y columnas
            int temp = matrix[i][j];
            matrix[i][j] = matrix[j][i];
            matrix[j][i] = temp;
        }
    }

    // Paso 2: Invertir cada fila de izquierda a derecha
    for (int i = 0; i < n; i++) {
        // Se preparan dos punteros en el extremo izquierdo y el extremo derecho, y se intercambian avanzando hacia el centro
        int left = 0, right = n - 1;
        while (left < right) {
            // Se intercambian matrix[i][left] y matrix[i][right] para invertir la fila de izquierda a derecha
            int temp = matrix[i][left];
            matrix[i][left] = matrix[i][right];
            matrix[i][right] = temp;
            left++;
            right--;
        }
    }
    // Una vez completada la inversión de todas las filas, toda la matriz queda en estado rotado 90 grados en sentido horario
}
```
