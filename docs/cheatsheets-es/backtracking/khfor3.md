# Placing N Queens on a Board Without Conflicts — Colocar N reinas en un tablero sin conflictos

## Esencia del problema

Se recibe un entero `n`. Se deben colocar n reinas en un tablero de ajedrez de n×n de manera que ningún par de reinas comparta la misma fila, la misma columna ni la misma diagonal. El programa debe devolver todas las configuraciones válidas del tablero como una lista de cadenas de texto.

## Idea central

Si se coloca una reina por fila, los conflictos de fila se eliminan automáticamente. Los conflictos restantes de columna, diagonal positiva y diagonal negativa se gestionan mediante los bits de una máscara de bits, lo que permite verificar conflictos y actualizar el estado en tiempo constante O(1).

## Proceso de razonamiento

1. **Eliminar los conflictos de fila de forma estructural**: Como se colocan n reinas en n filas, si se coloca exactamente una reina por fila, los conflictos de fila no ocurren. Por lo tanto, el problema se reduce a una búsqueda que decide en qué columna colocar la reina en cada fila
2. **Es necesario detectar los conflictos de columna y diagonal**: Los conflictos de columna se gestionan con un conjunto de columnas ya utilizadas. Los conflictos de diagonal son de dos tipos: diagonal positiva (dirección superior derecha, donde row + col es igual) y diagonal negativa (dirección superior izquierda, donde row - col es igual). Gestionando estos tres conjuntos, se pueden detectar todos los conflictos
3. **Representar los conjuntos con máscaras de bits**: El estado de uso de columnas, diagonales positivas y diagonales negativas se representa con los bits de un entero. Si el bit c-ésimo es 1, significa que esa columna (o diagonal) ya está en uso. La verificación de conflictos se realiza con AND y el registro con OR, lo que es más rápido que un HashSet
4. **Desplazar la máscara de bits de las diagonales por cada fila**: Cuando se baja una fila, el área de influencia de la diagonal positiva se desplaza una columna a la izquierda, por lo que se aplica un desplazamiento a la izquierda (`<< 1`). La diagonal negativa se desplaza una columna a la derecha, por lo que se aplica un desplazamiento a la derecha (`>> 1`). De esta manera, la verificación de conflictos diagonales se realiza únicamente con la posición del bit de la columna
5. **Explorar todas las soluciones con backtracking**: Desde la fila 0 hasta la fila n-1, se prueban en cada fila las columnas sin conflicto. Si se encuentra una columna sin conflicto, se coloca la reina y se recurre a la siguiente fila. Al alcanzar la fila n, se registra una solución. Al retornar de la recursión, la colocación se deshace automáticamente y se prueba otra columna
6. **Devolver el número total de soluciones**: Se suma y devuelve el número de veces que se logró colocar reinas en todas las filas (es decir, se alcanzó row == n)

## Conocimientos previos

### Qué es el backtracking

El backtracking es una técnica de búsqueda que prueba una opción y, si llega a un punto muerto, retrocede a la elección anterior para probar otra opción. La recursión permite implementar de forma natural el ciclo de "probar → avanzar → retroceder". Esta técnica es adecuada para problemas que enumeran todas las combinaciones válidas.

```java
void backtrack(int step) {
    if (step == goal) {       // Si se alcanzó la meta, se registra la solución
        recordSolution();
        return;
    }
    for (int choice : choices) {
        if (isValid(choice)) {    // Si la elección es válida, se prueba
            apply(choice);        // Se aplica la elección
            backtrack(step + 1);  // Se recurre al siguiente paso
            undo(choice);         // Se deshace la elección y se prueba otra opción
        }
    }
}
```

### Qué es una máscara de bits

Una máscara de bits es una técnica que utiliza cada bit de un entero como indicador de si un elemento pertenece o no a un conjunto. Las operaciones sobre conjuntos se realizan de forma eficiente mediante operaciones a nivel de bits.

```java
int mask = 0;             // Conjunto vacío (todos los bits son 0)
int bit = 1 << c;         // Se crea un valor donde solo el bit c-ésimo es 1 (representa el elemento c)
mask |= bit;              // Se agrega el elemento c al conjunto (se establece el bit c-ésimo en 1)
(mask & bit) != 0;        // Se verifica si el elemento c pertenece al conjunto → true/false
```

### Seguimiento de diagonales mediante desplazamiento de bits

En un tablero de ajedrez, al bajar una fila, la influencia de la diagonal positiva (dirección superior derecha ↗) se desplaza una columna hacia un número menor, y la influencia de la diagonal negativa (dirección superior izquierda ↖) se desplaza una columna hacia un número mayor. Este desplazamiento se expresa mediante el desplazamiento de la máscara de bits.

```java
int posDiag = 0;          // Máscara de bits que gestiona el estado de uso de las diagonales positivas
posDiag |= (1 << c);      // Se registra la diagonal positiva de la reina colocada en la columna c
posDiag << 1;              // En la siguiente fila, la influencia se desplaza una columna a la izquierda (desplazamiento a la izquierda)

int negDiag = 0;          // Máscara de bits que gestiona el estado de uso de las diagonales negativas
negDiag |= (1 << c);      // Se registra la diagonal negativa de la reina colocada en la columna c
negDiag >> 1;              // En la siguiente fila, la influencia se desplaza una columna a la derecha (desplazamiento a la derecha)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n!) — El número de columnas disponibles en cada fila se reduce como máximo a n, n-1, n-2, ... |
| Space | O(n) — La profundidad de la recursión es de n niveles y cada nivel solo utiliza un número constante de enteros como máscaras de bits |

## Código

```java
// Entrada: un entero n (tamaño del tablero de ajedrez y número de reinas a colocar)
// Salida: se devuelve como int el número total de configuraciones en las que se pueden colocar n reinas sin conflictos
int totalNQueens(int n) {
    // Se inicia la búsqueda desde la fila 0 y se inicializan las máscaras de bits de columnas, diagonales positivas y diagonales negativas todas en vacío (0)
    return backtrack(0, n, 0, 0, 0);
}

int backtrack(int row, int n,
    int cols, int posDiag,
    int negDiag) {
    // Se colocaron reinas en todas las filas, por lo que se encontró una solución
    if (row == n) return 1;

    // Variable que acumula el número de soluciones encontradas a partir de esta fila
    int count = 0;

    // Se recorren las columnas de 0 a n-1 y se determina si se puede colocar una reina en cada columna
    for (int c = 0; c < n; c++) {
        // Se crea el bit correspondiente a la columna c. Este bit se usa para verificar conflictos con las tres máscaras de bits
        int bit = 1 << c;

        // Si hay conflicto con la columna, la diagonal positiva o la diagonal negativa, se omite y se prueba la siguiente columna
        if ((cols & bit) != 0 ||
            (posDiag & bit) != 0 ||
            (negDiag & bit) != 0)
            continue;

        // Se coloca una reina en la columna c, se actualizan las tres máscaras de bits y se recurre a la siguiente fila
        // cols | bit: se registra la columna c como utilizada
        // (posDiag | bit) << 1: se registra la diagonal positiva y se refleja el desplazamiento a la siguiente fila con un desplazamiento a la izquierda
        // (negDiag | bit) >> 1: se registra la diagonal negativa y se refleja el desplazamiento a la siguiente fila con un desplazamiento a la derecha
        // Las máscaras de bits se pasan por valor, por lo que al retornar de la recursión vuelven automáticamente al estado previo al registro, sin necesidad de una operación explícita de deshacer
        count += backtrack(row + 1, n,
            cols | bit,
            (posDiag | bit) << 1,
            (negDiag | bit) >> 1);
    }
    // Se devuelve el número total de soluciones encontradas tras probar todas las columnas
    return count;
}
```
