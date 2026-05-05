# Traversing a Matrix in Spiral Order — Obtener todos los elementos de una matriz en orden espiral

## Esencia del problema

Se da una matriz `matrix` de m filas y n columnas. Comenzando desde la esquina superior izquierda, se recorre el perímetro en el orden derecha → abajo → izquierda → arriba, repitiendo hacia el interior, y se devuelve un arreglo con todos los elementos ordenados en **orden espiral**.

## Idea central

Se considera el perímetro de la matriz como una "capa" y se recorren sus cuatro lados en orden: lado superior, lado derecho, lado inferior y lado izquierdo. Una vez completado el recorrido de una capa, se contraen los cuatro punteros de límite hacia el interior, lo que permite pasar naturalmente a la siguiente capa.

## Proceso de razonamiento

1. **El recorrido en espiral es una repetición de 4 direcciones**: La estructura repite las 4 direcciones derecha → abajo → izquierda → arriba desde el exterior hacia el interior, por lo que si se gestionan los límites "superior, inferior, izquierdo y derecho" del rango actual de recorrido, el rango de cada dirección queda determinado de forma única
2. **Se representa el rango de recorrido con 4 punteros de límite**: Se preparan las 4 variables `top` (fila superior), `bottom` (fila inferior), `left` (columna izquierda) y `right` (columna derecha). Estas indican la posición de los cuatro lados de la capa actual
3. **Se determina el orden de recorrido de cada lado**: El lado superior se recorre de izquierda a derecha (incrementando columnas), el lado derecho de arriba a abajo (incrementando filas), el lado inferior de derecha a izquierda (decrementando columnas) y el lado izquierdo de abajo a arriba (decrementando filas). Con estos 4 bucles for se completa el recorrido de una capa
4. **Después del recorrido de cada lado se contrae el límite**: Tras recorrer el lado superior se ejecuta `top++` (se baja el límite superior una fila), tras el lado derecho `right--` (se mueve el límite derecho una columna a la izquierda), tras el lado inferior `bottom--`, y tras el lado izquierdo `left++`. De este modo, en la siguiente iteración se recorre la capa inmediatamente interior
5. **El recorrido del lado inferior y del lado izquierdo requiere una condición adicional**: Dado que tras el recorrido del lado superior se incrementa `top` y tras el del lado derecho se decrementa `right`, es posible que en el momento de recorrer el lado inferior la condición `top <= bottom` ya no se cumpla. De igual forma, al recorrer el lado izquierdo la condición `left <= right` puede no cumplirse. Si no se verifican estas condiciones, se leerían filas o columnas ya recorridas de forma duplicada, por lo que la verificación es necesaria
6. **La condición de terminación es el cruce de los límites**: Cuando `top > bottom` o `left > right`, el recorrido de todas las capas ha finalizado. Si se especifica `top <= bottom && left <= right` como condición del bucle while, este termina de forma natural

## Conocimientos previos

### Qué es un ArrayList

Es un arreglo de longitud variable. La operación `add`, que agrega un elemento al final, se ejecuta en O(1). Se utiliza para construir el arreglo resultante en orden espiral.

```java
List<Integer> res = new ArrayList<>();  // Se crea un ArrayList vacío
res.add(5);                             // Se agrega 5 al final → [5]
res.add(3);                             // Se agrega 3 al final → [5, 3]
res.size();                             // Se devuelve el número de elementos → 2
```

### Qué son los punteros de límite (Boundary Pointers)

Son 4 variables enteras que indican el rango de recorrido de la matriz. `top` y `bottom` representan el rango de filas, y `left` y `right` representan el rango de columnas. Al modificar sus valores después de cada recorrido, se contrae el rango hacia el interior.

```java
int top = 0;                    // Índice de la fila superior (valor inicial: 0)
int bottom = matrix.length - 1; // Índice de la fila inferior (valor inicial: última fila)
int left = 0;                   // Índice de la columna izquierda (valor inicial: 0)
int right = matrix[0].length - 1; // Índice de la columna derecha (valor inicial: última columna)
top++;    // Se contrae el límite superior una fila hacia abajo
right--;  // Se contrae el límite derecho una columna hacia la izquierda
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m × n) — Se recorre cada elemento de la matriz exactamente una vez |
| Space | O(1) — Excluyendo la lista de salida, solo se utilizan 4 punteros de límite |

## Código

```java
// Entrada: matriz de enteros matrix de m filas y n columnas
// Salida: se devuelve una List<Integer> con todos los elementos en orden espiral
List<Integer> spiralOrder(int[][] matrix) {
    // Se crea una lista de longitud variable para almacenar el resultado
    List<Integer> res = new ArrayList<>();
    // Si la matriz está vacía (0 filas), se devuelve la lista vacía tal cual
    if (matrix.length == 0) return res;

    // Se inicializan los 4 punteros de límite. Estos representan la posición de los cuatro lados de la capa que se debe recorrer actualmente
    int top = 0;                      // Fila superior (fila más alta)
    int bottom = matrix.length - 1;   // Fila inferior (fila más baja)
    int left = 0;                     // Columna izquierda (columna más a la izquierda)
    int right = matrix[0].length - 1; // Columna derecha (columna más a la derecha)

    // Se repite capa por capa mientras exista un rango de recorrido. Cuando los límites se cruzan, el recorrido de todos los elementos ha finalizado
    while (top <= bottom && left <= right) {
        // Lado superior: se recorre de izquierda a derecha
        for (int c = left; c <= right; c++)
            res.add(matrix[top][c]);
        // Recorrido del lado superior completado. Se contrae el límite superior una fila hacia abajo para evitar leer elementos duplicados de las esquinas en el siguiente recorrido del lado derecho
        top++;

        // Lado derecho: se recorre de arriba a abajo (top ya está actualizado, por lo que no hay duplicación de esquinas)
        for (int r = top; r <= bottom; r++)
            res.add(matrix[r][right]);
        // Recorrido del lado derecho completado. Se contrae el límite derecho una columna hacia la izquierda
        right--;

        // Lado inferior: se recorre de derecha a izquierda
        // Verificación de condición: si como resultado de top++ se cumple que top > bottom (quedaba solo 1 fila),
        // el lado inferior es la misma fila que el lado superior y ya fue recorrido, por lo que se omite
        if (top <= bottom) {
            for (int c = right; c >= left; c--)
                res.add(matrix[bottom][c]);
            // Se contrae el límite inferior una fila hacia arriba
            bottom--;
        }

        // Lado izquierdo: se recorre de abajo a arriba
        // Verificación de condición: si como resultado de right-- se cumple que left > right (quedaba solo 1 columna),
        // el lado izquierdo es la misma columna que el lado derecho y ya fue recorrido, por lo que se omite
        if (left <= right) {
            for (int r = bottom; r >= top; r--)
                res.add(matrix[r][left]);
            // Se contrae el límite izquierdo una columna hacia la derecha
            left++;
        }
    }
    // Se devuelve la lista con los m×n elementos almacenados en orden espiral
    return res;
}
```
