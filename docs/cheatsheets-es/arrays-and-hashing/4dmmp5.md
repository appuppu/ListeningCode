# Validating a Sudoku Board — Determinar si un tablero de Sudoku de 9×9 es válido

## Esencia del problema

Se recibe un tablero de Sudoku representado como un arreglo bidimensional de caracteres de 9×9. Si ninguna fila, columna ni subgrilla de 3×3 contiene números duplicados, el tablero se considera válido y se devuelve `true`. Las celdas vacías se representan con un punto `.`. No es necesario que el tablero esté completo; solo se verifica que la disposición actual no viole las reglas.

## Idea central

Se recorre el tablero completo una sola vez y, si el número de una celda ya apareció en "su fila", "su columna" o "su caja de 3×3", se determina que el tablero es inválido. El índice de la caja a la que pertenece cualquier celda `(i, j)` se mapea de forma única a un valor entre 0 y 8 mediante la fórmula `(i/3) * 3 + j/3`.

## Proceso de razonamiento

1. **Organizar las condiciones que se deben verificar**: La validez de un Sudoku se determina por tres condiciones: "sin duplicados en cada fila", "sin duplicados en cada columna" y "sin duplicados en cada caja de 3×3". Verificar estas tres condiciones simultáneamente resulta eficiente
2. **HashSet es adecuado para detectar duplicados**: Para determinar en O(1) si un número ya apareció, HashSet es la estructura óptima. Si se preparan 9 HashSets por fila, 9 por columna y 9 por caja, es decir, 27 HashSets en total, se pueden verificar las tres condiciones simultáneamente
3. **Se necesita un mapeo de celda a caja**: Es necesario calcular a qué caja pertenece la celda `(i, j)`. En la dirección de filas, `i/3` (división entera) produce 3 grupos: 0, 1, 2. En la dirección de columnas, `j/3` produce 3 grupos: 0, 1, 2. Para convertir esto en un índice unidimensional se usa `(i/3) * 3 + j/3`. De esta forma, las 9 cajas se corresponden con los números del 0 al 8
4. **Verificar todas las condiciones en un solo recorrido**: Se recorre el tablero completo con un doble bucle for y, para cada celda, se realiza la verificación de duplicados y el registro en los tres Sets de fila, columna y caja. Los puntos no son números, por lo que se omiten
5. **Devolver false inmediatamente al encontrar un duplicado**: Si alguno de los tres Sets ya contiene el mismo número, el tablero es inválido y se devuelve `false` de inmediato
6. **Devolver true tras recorrer todas las celdas**: Si no se encuentra ningún duplicado, el tablero es válido

## Conocimientos previos

### Qué es un HashSet

Es una estructura de datos que gestiona un conjunto de elementos sin duplicados. La inserción y la verificación de existencia se realizan en O(1). En este caso se utiliza para determinar rápidamente si un número ya apareció.

```java
Set<Character> set = new HashSet<>();  // Crear un HashSet vacío
set.add('5');            // Agregar el elemento '5'
set.contains('5');       // Devuelve un boolean indicando si el elemento '5' existe → true
set.contains('3');       // Devuelve un boolean indicando si el elemento '3' existe → false
```

### Cómo crear un arreglo de HashSets

Se gestionan 9 HashSets agrupados en un arreglo. Dado que no se puede crear directamente un arreglo de genéricos, se crea un arreglo de tipo crudo con `new HashSet[9]` y se inicializa cada elemento en un bucle.

```java
Set<Character>[] sets = new HashSet[9];  // Reservar un arreglo de 9 elementos
for (int i = 0; i < 9; i++) {
    sets[i] = new HashSet<>();           // Inicializar cada elemento con un HashSet vacío
}
```

### Fórmula de cálculo del índice de caja

`boxIdx = (i/3) * 3 + j/3` devuelve el número (0 a 8) de la caja de 3×3 a la que pertenece la celda `(i, j)`. `i/3` representa la posición de la caja en la dirección de filas (0, 1, 2) y `j/3` representa la posición de la caja en la dirección de columnas (0, 1, 2). Al multiplicar la posición en filas por 3 y sumar la posición en columnas, se asigna un número único a cada una de las 9 cajas.

```
Disposición de los números de caja:
0 | 1 | 2
3 | 4 | 5
6 | 7 | 8

Ejemplo: Celda (4, 7) → (4/3)*3 + 7/3 = 1*3 + 2 = 5 → Pertenece a la caja 5
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n²) — Se recorre el tablero completo de 9×9 una sola vez (con n=9 fijo, también se puede expresar como O(81)=O(1)) |
| Space | O(n²) — Se almacenan hasta 81 elementos en 27 HashSets |

## Código

```java
// Entrada: arreglo bidimensional de caracteres board de 9×9 (dígitos '1' a '9' o punto '.')
// Salida: devuelve true si el tablero es válido, false si es inválido
public boolean isValidSudoku(char[][] board) {
    // Crear arreglos de HashSets para registrar los números aparecidos por fila, columna y caja
    // rowset[i] registra los números de la fila i, columnset[j] los de la columna j, boxset[k] los de la caja k
    Set<Character>[] rowset = createSets();
    Set<Character>[] columnset = createSets();
    Set<Character>[] boxset = createSets();

    // El bucle externo recorre las filas y el interno las columnas, visitando las 81 celdas una vez cada una
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            // Obtener el valor de la celda actual
            char c = board[i][j];
            // El punto representa una celda vacía (no es un número), por lo que se omite
            if (c == '.') {
                continue;
            }

            // Calcular el número de caja al que pertenece la celda (i, j) (correspondencia única de 0 a 8)
            int boxIdx = (i / 3) * 3 + j / 3;

            // Si el mismo número ya existe en la fila, columna o caja, hay un duplicado y se devuelve false de inmediato
            if (rowset[i].contains(c) || columnset[j].contains(c) || boxset[boxIdx].contains(c)) {
                return false;
            }

            // Si no hay duplicado, se registra el número actual en los tres Sets para detectar futuros duplicados
            rowset[i].add(c);
            columnset[j].add(c);
            boxset[boxIdx].add(c);
        }
    }
    // Si se recorrieron todas las celdas sin encontrar ningún duplicado, el tablero es válido
    return true;
}

// Método auxiliar que crea un arreglo con 9 HashSets vacíos
public Set<Character>[] createSets() {
    Set<Character>[] sets = new HashSet[9];
    for (int i = 0; i < 9; i++) {
        sets[i] = new HashSet<>();
    }
    return sets;
}
```
