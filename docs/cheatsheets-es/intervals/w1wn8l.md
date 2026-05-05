# Finding the Minimum Removals for Non-Overlapping Intervals — Encontrar el número mínimo de intervalos a eliminar para que no se superpongan

## Esencia del problema

Se recibe un arreglo de intervalos `intervals` (cada intervalo es un par `[start, end]`). Se debe devolver el **número mínimo de intervalos a eliminar** para que los intervalos restantes no se superpongan entre sí.

## Idea central

Si se ordenan los intervalos por tiempo de finalización y se priorizan los que terminan antes, se minimiza la posibilidad de superposición con los intervalos siguientes. Cuando ocurre una superposición, se elimina el intervalo que termina más tarde (es decir, el intervalo actual), lo que minimiza el número total de eliminaciones.

## Proceso de razonamiento

1. **Para reducir superposiciones, se deben priorizar los intervalos que "ocupan menos espacio"**: Cuanto antes termina un intervalo, más espacio libre queda después de él, lo que reduce la probabilidad de superposición con los intervalos siguientes. Por lo tanto, es óptimo ordenar los intervalos en orden ascendente por tiempo de finalización y seleccionarlos de forma voraz en ese orden
2. **Después de ordenar, solo es necesario rastrear el tiempo de finalización del último intervalo conservado**: Como los intervalos están ordenados por tiempo de finalización, basta con recordar el tiempo de finalización `lastEnd` del último intervalo conservado para determinar si el siguiente intervalo se superpone. Si el tiempo de inicio del siguiente intervalo es menor que `lastEnd`, existe superposición
3. **Cuando hay superposición, se elimina el intervalo actual**: Cuando ocurre una superposición, se debe decidir si eliminar el intervalo conservado anteriormente o el intervalo actual. Como los intervalos están ordenados por tiempo de finalización, el tiempo de finalización del intervalo actual es mayor o igual al del intervalo anterior. Eliminar el intervalo actual, que termina más tarde, tiene menor impacto en los intervalos siguientes. Por eso se incrementa `removals` y no se actualiza `lastEnd`
4. **Cuando no hay superposición, se conserva el intervalo actual**: Si el tiempo de inicio del intervalo actual es mayor o igual a `lastEnd`, no hay superposición, por lo que se conserva este intervalo y se actualiza `lastEnd` al tiempo de finalización del intervalo actual
5. **Valor de retorno final**: Al terminar el bucle, se devuelve `removals` (el número de intervalos eliminados)

## Conocimientos previos

### Comparador personalizado de Arrays.sort

Se puede personalizar el criterio de ordenamiento pasando una expresión lambda como segundo argumento de `Arrays.sort`. `(a, b) -> a[1] - b[1]` ordena en orden ascendente según el tiempo de finalización de cada intervalo (el elemento en el índice 1).

```java
int[][] intervals = {{1,3}, {2,4}, {0,2}};
Arrays.sort(intervals, (a, b) -> a[1] - b[1]);
// Resultado: {{0,2}, {1,3}, {2,4}} — ordenados de menor a mayor tiempo de finalización
```

### ¿Qué es el algoritmo voraz (Greedy)?

Es una técnica que en cada paso realiza "la mejor elección posible en ese momento" para obtener la solución óptima global. En este problema, la elección local de "priorizar conservar el intervalo con el tiempo de finalización más temprano" conduce a minimizar el número total de eliminaciones.

```java
// Patrón típico del algoritmo voraz: ordenar y luego seleccionar la opción óptima desde el inicio
Arrays.sort(data, comparator);  // Ordenar según el criterio
for (int i = 0; i < data.length; i++) {
    // Si se cumple la condición, se selecciona; si no, se omite
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n log n) — El ordenamiento requiere O(n log n) y el recorrido requiere O(n); el ordenamiento es el factor dominante |
| Space | O(1) — No se utilizan estructuras de datos adicionales, excluyendo el espacio interno del ordenamiento |

## Código

```java
// Entrada: arreglo de intervalos int[][] intervals (cada elemento es [start, end])
// Salida: devuelve como int el número mínimo de intervalos a eliminar para que no haya superposiciones
int eraseOverlapIntervals(int[][] intervals) {
    // Si hay 0 intervalos, no es necesario eliminar ninguno
    if (intervals.length == 0)
        return 0;

    // Ordenar en orden ascendente por tiempo de finalización (para priorizar conservar los intervalos que terminan antes)
    // Algoritmo voraz: los intervalos que terminan antes tienen menos probabilidad de superponerse con los siguientes, por lo que es óptimo conservarlos primero
    Arrays.sort(intervals, (a, b) -> a[1] - b[1]);

    // Variable que registra el número de intervalos eliminados
    int removals = 0;
    // El primer intervalo después de ordenar siempre se conserva (porque tiene el tiempo de finalización más temprano). Se registra su tiempo de finalización
    int lastEnd = intervals[0][1];

    // Se recorre desde el índice 1 (el elemento 0 ya se confirmó como intervalo conservado)
    for (int i = 1; i < intervals.length; i++) {
        // Si el tiempo de inicio del intervalo actual es menor que lastEnd, se superpone con el último intervalo conservado
        if (intervals[i][0] < lastEnd) {
            // Se elimina el intervalo actual. Como los intervalos están ordenados por tiempo de finalización, el fin del intervalo actual es mayor o igual a lastEnd,
            // por lo que eliminar el intervalo actual que termina más tarde reduce las superposiciones con los siguientes. No se actualiza lastEnd
            removals++;
        } else {
            // No hay superposición, por lo que se conserva el intervalo actual y se actualiza lastEnd al tiempo de finalización del intervalo actual
            // La verificación de superposición con el siguiente intervalo se realizará con base en este nuevo lastEnd
            lastEnd = intervals[i][1];
        }
    }
    // removals es el número mínimo de intervalos que es necesario eliminar para que no haya superposiciones
    return removals;
}
```
