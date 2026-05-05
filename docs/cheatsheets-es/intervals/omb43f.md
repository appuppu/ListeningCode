# Determinar si se puede asistir a todas las reuniones — Meeting Rooms

## Esencia del problema

Se recibe un arreglo `intervals` que representa intervalos de tiempo de reuniones (pares de hora de inicio y hora de fin). Se debe determinar si una persona puede **asistir a todas las reuniones** y devolver un `boolean`. Si una reunión comienza antes de que otra termine, las dos reuniones entran en conflicto (se solapan) y no es posible asistir a todas.

## Idea central

Si se ordenan los intervalos por hora de inicio, los solapamientos solo pueden ocurrir entre intervalos adyacentes. Basta con comparar los pares adyacentes en orden y verificar si la hora de inicio del siguiente intervalo es anterior a la hora de fin del intervalo previo para determinar si existe algún solapamiento en todo el conjunto.

## Proceso de razonamiento

1. **Organizar la condición de solapamiento**: Que dos intervalos se solapen significa que la hora de inicio de uno es anterior a la hora de fin del otro. Sin embargo, si los intervalos están en un orden arbitrario, sería necesario comparar todos los pares, lo que resulta en O(n²)
2. **Limitar las comparaciones mediante ordenamiento**: Si se ordenan los intervalos en orden ascendente por hora de inicio, los solapamientos solo ocurren entre intervalos adyacentes. Esto se debe a que, si `intervals[i]` e `intervals[i+2]` se solapan, entonces necesariamente `intervals[i]` e `intervals[i+1]` también se solapan
3. **Detección de solapamiento en pares adyacentes**: Después de ordenar, si la hora de inicio de `intervals[i]` es anterior a la hora de fin de `intervals[i-1]`, las dos reuniones se solapan. Esta condición se expresa como `intervals[i][0] < intervals[i-1][1]`
4. **Un solo solapamiento determina el resultado de inmediato**: Si se encuentra al menos un par con solapamiento, no es posible asistir a todas las reuniones, por lo que se devuelve `false`. Si se verifican todos los pares adyacentes sin encontrar solapamientos, se devuelve `true`

## Conocimientos previos

### Arrays.sort y Comparator personalizado

`Arrays.sort` es un método que ordena un arreglo. En el caso de un arreglo bidimensional, se puede especificar un Comparator (función de comparación) mediante una expresión lambda para controlar qué elemento se usa como criterio de ordenamiento.

```java
int[][] intervals = {{7, 10}, {2, 4}, {5, 8}};
Arrays.sort(intervals, (a, b) -> a[0] - b[0]);  // Ordena en orden ascendente por la hora de inicio ([0]) de cada intervalo
// Resultado: {{2, 4}, {5, 8}, {7, 10}}
```

`(a, b) -> a[0] - b[0]` recibe dos intervalos `a` y `b`, y devuelve la diferencia entre sus horas de inicio. Si la diferencia es negativa, `a` se coloca primero; si es positiva, `b` se coloca primero.

### Detección de solapamiento entre intervalos

Cuando dos intervalos están ordenados por hora de inicio, si el inicio del intervalo posterior es anterior al fin del intervalo previo, existe un solapamiento.

```java
int[] prev = {2, 4};   // Reunión de 2:00 a 4:00
int[] curr = {3, 6};   // Reunión de 3:00 a 6:00
curr[0] < prev[1];     // 3 < 4 → true → Existe solapamiento
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n log n) — El ordenamiento es O(n log n), el recorrido de pares adyacentes es O(n), y el ordenamiento es el factor dominante |
| Space | O(1) — El ordenamiento reordena el arreglo de entrada directamente, sin utilizar arreglos adicionales |

## Código

```java
// Entrada: arreglo bidimensional de enteros intervals que representa los horarios de las reuniones (cada elemento es [hora de inicio, hora de fin])
// Salida: true si se puede asistir a todas las reuniones, false si hay reuniones que se solapan
public boolean canAttendMeetings(int[][] intervals) {
    // Ordena los intervalos en orden ascendente por hora de inicio
    // Se pasa la expresión lambda (a, b) -> a[0] - b[0] como Comparator
    // De este modo, basta con comparar solo los pares adyacentes de los intervalos ordenados cronológicamente
    Arrays.sort(intervals, (a, b) -> a[0] - b[0]);

    // Se comienza desde i = 1 en lugar de i = 0, ya que en cada paso se compara el par adyacente intervals[i] e intervals[i-1]
    for (int i = 1; i < intervals.length; i++) {
        // Si la hora de inicio de la reunión actual es anterior a la hora de fin de la reunión previa, existe solapamiento
        if (intervals[i][0] < intervals[i - 1][1]) {
            // Si se encuentra al menos un solapamiento, no se puede asistir a todas las reuniones, por lo que se devuelve false de inmediato
            return false;
        }
        // Si no hay solapamiento, se avanza al siguiente par adyacente
    }
    // Si el bucle se completa hasta el final, no hubo solapamiento en ningún par adyacente, por lo que se devuelve true
    return true;
}
```
