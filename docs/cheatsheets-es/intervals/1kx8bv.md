# Finding the Minimum Meeting Rooms Required — Encontrar el número mínimo de salas de reuniones necesarias para realizar todas las reuniones sin conflictos

## Esencia del problema

Se recibe un arreglo de intervalos de tiempo de reuniones (hora de inicio y hora de fin). Se debe devolver el **número mínimo de salas de reuniones** necesarias para realizar todas las reuniones sin conflictos. Las reuniones que se superponen en el mismo intervalo de tiempo requieren salas separadas.

## Idea central

Si se procesan los inicios y finales de las reuniones como eventos separados en orden cronológico, se puede obtener el número máximo de reuniones que ocurren simultáneamente en un momento dado. Ese número máximo es la cantidad de salas de reuniones necesarias.

## Proceso de razonamiento

1. **El número de reuniones simultáneas es la respuesta**: El número máximo de reuniones en curso simultáneamente en un momento dado = el número de salas necesarias. El problema se reduce a encontrar eficientemente el valor máximo de reuniones simultáneas
2. **Tratar los inicios y finales como eventos separados**: Al iniciar una reunión se necesita una sala, y al finalizar se libera una sala. Si se separan los inicios y finales y se ordena cada uno, se pueden procesar los eventos en orden cronológico
3. **Recorrer dos arreglos ordenados**: Se ordena el arreglo starts y el arreglo ends, y se recorre starts desde el principio. Para cada hora de inicio, se determina si es anterior a la hora de finalización más temprana, lo que indica si se necesita una sala o si una se libera
4. **Rastrear el número de reuniones simultáneas con dos punteros**: Se prepara un puntero `i` para el arreglo starts y un puntero `endPtr` para el arreglo ends. Si `starts[i] < ends[endPtr]`, la nueva reunión se superpone con una existente, por lo que se agrega una sala. En caso contrario, una reunión ha terminado y se libera una sala, por lo que se avanza `endPtr`
5. **Registrar el valor máximo**: Durante el recorrido, se registra continuamente el valor máximo de `rooms` en `maxRooms`. Al completar el recorrido, se devuelve `maxRooms`

## Conocimientos previos

### Qué es Arrays.sort

Es un método estándar de Java que ordena un arreglo en orden ascendente. Para arreglos de tipos primitivos, utiliza Dual-Pivot Quicksort (O(n log n)).

```java
int[] arr = {5, 2, 8, 1};
Arrays.sort(arr);        // arr se convierte en {1, 2, 5, 8}
```

### Qué es Two Pointer (Dos punteros)

Es una técnica que utiliza dos variables de índice para recorrer arreglos de forma independiente. Al aplicarla sobre arreglos ordenados, permite comparar y fusionar elementos de dos arreglos de manera eficiente.

```java
int i = 0;          // Puntero para el primer arreglo
int endPtr = 0;     // Puntero para el segundo arreglo
// Se decide cuál puntero avanzar según la condición
```

### Qué es Event Sweep (Barrido de eventos)

Es una técnica que procesa eventos (inicios y finales) en orden cronológico a lo largo del eje temporal, y rastrea el estado en un momento dado (como el número de reuniones simultáneas). Al incrementar un contador en los eventos de inicio y decrementarlo en los eventos de final, se puede conocer el número de reuniones simultáneas en cualquier instante.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n log n) — El ordenamiento de los dos arreglos es la operación dominante |
| Space | O(n) — Se crean dos arreglos para almacenar las horas de inicio y de fin |

## Código

```java
// Entrada: arreglo bidimensional de enteros intervals que representa los intervalos de tiempo de las reuniones (cada elemento es [start, end])
// Salida: devuelve un int con el número mínimo de salas de reuniones necesarias para realizar todas las reuniones sin conflictos
public int minMeetingRooms(int[][] intervals) {
    // Si la entrada es null o está vacía, no existen reuniones, por lo que se devuelve 0
    if (intervals == null || intervals.length == 0)
        return 0;

    int n = intervals.length;
    // Al separar los inicios y finales, se permite ordenar cada uno de forma independiente
    int[] starts = new int[n];  // Arreglo para almacenar las horas de inicio
    int[] ends = new int[n];    // Arreglo para almacenar las horas de fin

    // Se recorre intervals y se almacenan las horas de inicio y fin en arreglos separados
    for (int i = 0; i < n; i++) {
        starts[i] = intervals[i][0];
        ends[i] = intervals[i][1];
    }

    // Se ordenan ambos arreglos en orden ascendente para preparar el procesamiento de eventos en orden cronológico
    Arrays.sort(starts);
    Arrays.sort(ends);

    int rooms = 0, maxRooms = 0;
    // Puntero del arreglo ends. Apunta a la reunión que termina más temprano
    int endPtr = 0;

    // Se recorre el arreglo starts desde el principio. Cada iteración representa el evento "una nueva reunión comienza"
    for (int i = 0; i < n; i++) {
        if (starts[i] < ends[endPtr]) {
            // La hora de inicio de la reunión actual es anterior a la hora de fin de la reunión que termina más temprano → se produce una superposición, por lo que se asigna una nueva sala
            rooms++;
        } else {
            // La reunión que termina más temprano ya ha finalizado, por lo que se puede reutilizar esa sala. No se incrementa el número de salas y se avanza endPtr para apuntar a la siguiente reunión que termina más temprano
            endPtr++;
        }
        // Se actualiza el número máximo de salas en uso simultáneo
        maxRooms = Math.max(maxRooms, rooms);
    }
    // maxRooms es el valor máximo de salas utilizadas simultáneamente, que es el número mínimo de salas de reuniones necesarias
    return maxRooms;
}
```
