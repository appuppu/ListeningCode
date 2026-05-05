# Setting Entire Rows and Columns to Zero — Establecer en cero filas y columnas completas que contienen un cero

## Esencia del problema

Se da una matriz de m×n. Cuando se encuentra un elemento cuyo valor es 0, se deben establecer en 0 **toda la fila** y **toda la columna** a las que pertenece ese elemento. Esta transformación se realiza in-place (sin utilizar una matriz adicional).

## Idea central

Si se reutilizan la fila 0 y la columna 0 de la matriz como área de flags para registrar "qué filas y columnas deben ponerse en cero", se pueden gestionar las filas y columnas a poner en cero con un espacio adicional de O(1).

## Proceso de razonamiento

1. **Es necesario registrar qué filas y columnas deben ponerse en cero**: Si se reescriben la fila y la columna en el momento en que se encuentra un cero durante el recorrido, en recorridos posteriores no se podrá distinguir si un valor era originalmente cero o si fue resultado de la reescritura. Por eso, se necesita un método de dos pasadas: primero registrar "qué filas y columnas deben ponerse en cero" y luego reescribir todo de una vez
2. **Usar arreglos separados para el registro requiere un espacio de O(m+n)**: Se podría registrar usando un arreglo de tamaño m para las filas y uno de tamaño n para las columnas, pero el objetivo es lograr un espacio de O(1)
3. **Usar la fila 0 y la columna 0 de la propia matriz como flags**: Si `matrix[i][0]` es 0, significa "poner en cero la fila i"; si `matrix[0][j]` es 0, significa "poner en cero la columna j". De esta forma, no se necesitan arreglos adicionales
4. **Solo el flag de la columna 0 necesita una variable independiente**: `matrix[i][0]` tiene dos significados: "flag de la fila i" y "valor original de la columna 0". Para determinar si la columna 0 misma debe ponerse en cero, se utiliza una variable separada `firstCol`
5. **Marcado de flags**: Se recorre la matriz y, al encontrar `matrix[i][j] == 0`, se establecen `matrix[i][0] = 0` y `matrix[0][j] = 0` para marcar los flags
6. **Poner en cero en orden inverso**: Al escribir los ceros basándose en los flags, si se reescriben primero la fila 0 y la columna 0, los flags se destruyen. Por eso, se procesa en orden inverso desde el final y se procesan la fila 0 y la columna 0 al último

## Conocimientos previos

### Qué es una operación in-place

Es una operación que obtiene el resultado reescribiendo los datos de entrada directamente, sin usar estructuras de datos adicionales (otra matriz o arreglos grandes). Solo se permite el uso de una cantidad constante de variables adicionales.

```java
// Ejemplo de operación in-place: se reescriben directamente los elementos del arreglo
matrix[i][j] = 0;  // Se modifica directamente la matriz original sin copiar a otro arreglo
```

### Qué es un flag de tipo boolean

Es una variable que registra "si una condición se ha cumplido o no" con dos valores: true/false. Si la condición se cumple al menos una vez durante un bucle, se establece en true y se consulta en el procesamiento posterior.

```java
boolean firstCol = false;       // El valor inicial es false (condición no cumplida)
if (matrix[i][0] == 0)
    firstCol = true;            // Se registra que la condición se cumplió
// Se consulta posteriormente
if (firstCol)
    matrix[i][0] = 0;          // Si el flag es true, se ejecuta el procesamiento
```

### Qué es un bucle en orden inverso

Es un bucle que recorre un arreglo o una matriz desde el final hacia el principio. Cuando los elementos del principio funcionan también como flags utilizados en el procesamiento posterior, se utiliza el orden inverso para procesar el principio al final.

```java
for (int i = m - 1; i >= 0; i--)    // Se decrementa i de 1 en 1 desde el final (m-1) hasta 0
    for (int j = n - 1; j >= 1; j--)  // Se decrementa j de 1 en 1 desde el final (n-1) hasta 1
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m × n) — Se recorre toda la matriz dos veces (una vez para establecer los flags y otra para poner en cero) |
| Space | O(1) — La única variable adicional es `firstCol`. Se reutiliza la propia matriz como área de flags |

## Código

```java
// Entrada: matriz de enteros matrix de m×n (arreglo bidimensional)
// Salida: ninguna (se modifica matrix directamente. El tipo de retorno es void)
public void setZeroes(int[][] matrix) {
    // Se obtienen el número de filas m y el número de columnas n
    int m = matrix.length;
    int n = matrix[0].length;
    // Flag que registra si la columna 0 debe ponerse en cero
    // Como matrix[i][0] se comparte con el flag de fila, solo el flag de la columna 0 se gestiona con una variable independiente
    boolean firstCol = false;

    // Primera pasada: marcado de flags
    for (int i = 0; i < m; i++) {
        // Se verifica si la columna 0 contiene originalmente un cero; si es así, se establece firstCol en true
        if (matrix[i][0] == 0)
            firstCol = true;
        // Se recorre desde j=1 (j=0 se comparte con el flag de fila, por lo que solo se examinan las columnas desde la 1 en adelante)
        for (int j = 1; j < n; j++)
            if (matrix[i][j] == 0) {
                matrix[i][0] = 0;  // Flag para poner en cero la fila i
                matrix[0][j] = 0;  // Flag para poner en cero la columna j
            }
    }

    // Segunda pasada: se escriben los ceros en orden inverso
    // Razón del orden inverso: como los flags de la fila 0 (matrix[0][j]) se usan en el procesamiento de las demás filas, la fila 0 se procesa al final
    for (int i = m - 1; i >= 0; i--) {
        // Se recorre en orden inverso desde j=1; si el flag de fila o el flag de columna está activado, se establece en cero
        for (int j = n - 1; j >= 1; j--)
            if (matrix[i][0] == 0 || matrix[0][j] == 0)
                matrix[i][j] = 0;
        // La puesta en cero de la columna 0 se realiza después del bucle interno
        // Nota: si se reescribe matrix[i][0] antes, la evaluación del flag de fila anterior se corrompe
        if (firstCol)
            matrix[i][0] = 0;
    }
}
```
