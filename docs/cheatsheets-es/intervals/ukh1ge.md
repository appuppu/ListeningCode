# Inserting a New Interval Into a Sorted List — Insertar un nuevo intervalo en una lista ordenada de intervalos no superpuestos y fusionarlos

## Esencia del problema

Se da una lista de intervalos `intervals` ordenados y no superpuestos entre sí, junto con un nuevo intervalo `newInterval`. Se debe insertar `newInterval` en la posición correcta, fusionar todos los intervalos que se superpongan y devolver la lista resultante de intervalos no superpuestos.

## Idea central

Al recorrer la lista ordenada de intervalos de izquierda a derecha, cada intervalo se clasifica en uno de tres grupos: "completamente antes del nuevo intervalo", "superpuesto con el nuevo intervalo" o "completamente después del nuevo intervalo". Si se procesan estas tres fases en orden, la inserción y la fusión se completan en un solo recorrido.

## Proceso de razonamiento

1. **Solo existen 3 patrones de relación posicional entre intervalos**: Cada intervalo de la lista ordenada se clasifica, al compararlo con newInterval, en "completamente antes", "superpuesto" o "completamente después". Aprovechando esta clasificación, se puede procesar la lista con un solo recorrido
2. **Condición para determinar "completamente antes"**: Si el extremo final del intervalo existente `intervals[i][1]` es menor que el extremo inicial de newInterval `newInterval[0]`, ese intervalo no se superpone con newInterval. Los intervalos que cumplan esta condición se agregan directamente al resultado
3. **Condición para determinar "superpuesto"**: Si el extremo inicial del intervalo existente `intervals[i][0]` es menor o igual que el extremo final de newInterval `newInterval[1]`, ese intervalo se superpone con newInterval. Cada vez que se encuentra un intervalo superpuesto, se actualizan los extremos inicial y final de newInterval para ampliar el rango de fusión
4. **Método de fusión**: Se toma el menor entre el extremo inicial del intervalo superpuesto y el extremo inicial de newInterval como nuevo extremo inicial, y el mayor entre el extremo final del intervalo superpuesto y el extremo final de newInterval como nuevo extremo final. De esta manera, se consolidan múltiples intervalos superpuestos en uno solo
5. **Momento de agregar el resultado de la fusión**: Cuando ya no quedan intervalos superpuestos, se agrega el newInterval fusionado al resultado. Los intervalos restantes están todos después de newInterval, por lo que se agregan directamente al resultado
6. **Lo que se devuelve finalmente**: Se convierte la lista de resultados construida en las 3 fases a `int[][]` y se devuelve

## Conocimientos previos

### Qué es ArrayList

Es un arreglo de tamaño variable. La adición de elementos con `add()` se realiza en O(1) (amortizado) y se puede convertir a un arreglo de tamaño fijo al final. Se utiliza cuando no se conoce de antemano el tamaño del resultado.

```java
List<int[]> res = new ArrayList<>();   // Crear un ArrayList vacío
res.add(new int[]{1, 3});              // Agregar un elemento al final
res.toArray(new int[0][]);             // Convertir a un arreglo de tipo int[][]
```

### Qué son Math.min / Math.max

Son métodos que devuelven el menor o el mayor de dos valores. Se utilizan para determinar los extremos inicial y final al fusionar intervalos.

```java
Math.min(1, 3);   // → 1 (devuelve el menor)
Math.max(1, 3);   // → 3 (devuelve el mayor)
```

### Determinación de superposición de intervalos

Para determinar si dos intervalos `[a, b]` y `[c, d]` se superponen, se utiliza la condición `a <= d && c <= b`. En este problema, como la lista está ordenada, basta con verificar solo una de las condiciones.

```java
// El intervalo existente está completamente antes de newInterval (no se superpone)
intervals[i][1] < newInterval[0]   // Extremo final del intervalo existente < extremo inicial del nuevo intervalo

// El intervalo existente se superpone con newInterval
intervals[i][0] <= newInterval[1]  // Extremo inicial del intervalo existente <= extremo final del nuevo intervalo
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita un recorrido de la lista de intervalos |
| Space | O(n) — Se almacenan como máximo n+1 intervalos en la lista de resultados |

## Código

```java
// Entrada: lista ordenada de intervalos no superpuestos intervals (int[][]) y un nuevo intervalo newInterval (int[])
// Salida: devuelve la lista de intervalos no superpuestos en int[][] después de insertar y fusionar newInterval
public int[][] insert(int[][] intervals, int[] newInterval) {
    // Lista para almacenar el resultado. Se usa ArrayList porque no se conoce el tamaño de antemano
    List<int[]> res = new ArrayList<>();
    // Variable para rastrear la posición de recorrido
    int i = 0;
    // Se almacena la cantidad total de intervalos en una variable para no acceder a .length en cada iteración del bucle
    int n = intervals.length;

    // Fase 1: agregar directamente los intervalos que están completamente antes de newInterval
    // Condición: si el extremo final del intervalo existente < el extremo inicial de newInterval, no se superponen
    while (i < n && intervals[i][1] < newInterval[0]) {
        res.add(intervals[i]);
        i++;
    }

    // Fase 2: fusionar todos los intervalos que se superponen con newInterval
    // Condición: si el extremo inicial del intervalo existente <= el extremo final de newInterval, se superponen
    while (i < n && intervals[i][0] <= newInterval[1]) {
        // Se toma el menor de los extremos iniciales (se amplía el borde izquierdo de newInterval hasta el borde izquierdo del intervalo superpuesto)
        newInterval[0] = Math.min(newInterval[0], intervals[i][0]);
        // Se toma el mayor de los extremos finales (se amplía el borde derecho de newInterval hasta el borde derecho del intervalo superpuesto)
        newInterval[1] = Math.max(newInterval[1], intervals[i][1]);
        i++;
    }
    // Se agrega el newInterval fusionado al resultado (se agrega tal cual incluso si hubo 0 intervalos superpuestos)
    res.add(newInterval);

    // Fase 3: agregar directamente los intervalos que están completamente después de newInterval (no requieren fusión)
    while (i < n) {
        res.add(intervals[i]);
        i++;
    }

    // Se convierte el ArrayList a int[][] y se devuelve. new int[0][] es un arreglo vacío para indicar la información de tipo
    return res.toArray(new int[0][]);
}
```
