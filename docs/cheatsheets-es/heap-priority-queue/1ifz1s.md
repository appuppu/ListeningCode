# Finding the Median From a Data Stream — Obtener la mediana en tiempo real a partir de un flujo de datos

## Esencia del problema

En una situación donde se agregan enteros sucesivamente desde un flujo de datos, se debe diseñar una estructura de datos que soporte dos operaciones. `addNum(int num)` agrega un entero, y `findMedian()` devuelve la **mediana** de todos los enteros agregados hasta el momento. Si la cantidad de elementos es impar, se devuelve el valor central; si es par, se devuelve el promedio de los dos valores centrales.

## Idea central

Si se dividen todos los elementos en "la mitad inferior" y "la mitad superior", y se gestiona cada una con un max-heap y un min-heap respectivamente, la mediana siempre se puede obtener en O(1) desde la cima de los dos heaps.

## Proceso de razonamiento

1. **La mediana se encuentra "en el medio"**: Para obtener la mediana, es necesario mantener todos los elementos en estado ordenado y acceder al elemento central. Sin embargo, ordenar cada vez que se agrega un elemento cuesta O(n log n)
2. **No se necesita el orden completo, solo conocer el medio**: Si se dividen todos los elementos en "la mitad inferior (lower half)" y "la mitad superior (upper half)", el valor máximo de la mitad inferior y el valor mínimo de la mitad superior se convierten en los candidatos para la mediana
3. **Se necesita obtener el valor extremo de cada mitad rápidamente**: Para obtener el máximo de la mitad inferior en O(1), un max-heap es adecuado; para obtener el mínimo de la mitad superior en O(1), un min-heap es adecuado. La inserción en el heap cuesta O(log n)
4. **Mantener el balance de tamaño entre los dos heaps**: Para calcular correctamente la mediana, la diferencia de tamaño entre los dos heaps debe mantenerse en un máximo de 1. Se balancea de modo que el tamaño de lo (max-heap) sea siempre mayor o igual al tamaño de hi (min-heap)
5. **Procedimiento de balanceo al agregar un elemento**: Primero se agrega el nuevo elemento a lo, y luego se mueve el máximo de lo a hi. Esto garantiza siempre que el máximo de lo ≤ el mínimo de hi. Después, si el tamaño de hi supera al de lo, se devuelve el mínimo de hi a lo
6. **Obtención de la mediana**: Si el tamaño de lo es mayor que el de hi, la cantidad de elementos es impar, por lo que la cima de lo (el valor máximo) es la mediana. Si los tamaños son iguales, la cantidad de elementos es par, por lo que la mediana es el promedio de la cima de lo y la cima de hi

## Conocimientos previos

### ¿Qué es PriorityQueue (heap)?

Es una estructura de datos que gestiona los elementos en orden de prioridad. Por defecto, funciona como un min-heap (el valor mínimo está en la cima). La obtención del elemento en la cima es O(1), y la inserción y eliminación de elementos es O(log n).

```java
// min-heap (por defecto): el valor mínimo queda en la cima
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.offer(5);       // Se agrega el elemento 5
minHeap.offer(3);       // Se agrega el elemento 3
minHeap.peek();          // Se obtiene el valor mínimo de la cima → 3 (sin eliminarlo)
minHeap.poll();          // Se extrae el valor mínimo de la cima → 3 (eliminándolo)

// max-heap: el valor máximo queda en la cima (se especifica Collections.reverseOrder())
PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
maxHeap.offer(5);       // Se agrega el elemento 5
maxHeap.offer(3);       // Se agrega el elemento 3
maxHeap.peek();          // Se obtiene el valor máximo de la cima → 5
```

### Diferencias entre offer / poll / peek

| Método | Comportamiento | Valor de retorno |
|---|---|---|
| `offer(e)` | Agrega el elemento `e` al heap | `boolean` (true si tiene éxito) |
| `poll()` | Extrae el elemento de la cima y lo **elimina** | El elemento extraído (`null` si está vacío) |
| `peek()` | Consulta el elemento de la cima **sin eliminarlo** | El elemento de la cima (`null` si está vacío) |

### ¿Qué es la mediana (median)?

Es el valor central de una lista ordenada. Si la cantidad de elementos es impar, es el único valor central; si es par, es el promedio de los dos valores centrales.
Ejemplo: `[1, 2, 3]` → la mediana es `2`. `[1, 2, 3, 4]` → la mediana es `(2 + 3) / 2.0 = 2.5`.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(log n) — En `addNum` se realizan como máximo 3 inserciones/extracciones en el heap, y cada operación es O(log n). `findMedian` es O(1) |
| Space | O(n) — Los dos heaps almacenan todos los elementos |

## Código

```java
// Entrada: se reciben enteros uno a uno como flujo mediante addNum(int num)
// Salida: findMedian() devuelve la mediana de todos los enteros agregados como double
class MedianFinder {
    // Max-heap que gestiona la mitad inferior (la cima es el valor máximo)
    PriorityQueue<Integer> lo;
    // Min-heap que gestiona la mitad superior (la cima es el valor mínimo)
    PriorityQueue<Integer> hi;

    MedianFinder() {
        // El max-heap se configura en orden descendente con Collections.reverseOrder()
        lo = new PriorityQueue<>(Collections.reverseOrder());
        // El min-heap se deja por defecto (orden ascendente)
        hi = new PriorityQueue<>();
    }

    void addNum(int num) {
        // Cualquier elemento se inserta primero en la mitad inferior (lo)
        lo.offer(num);
        // Se mueve el máximo de lo a hi para mantener siempre la relación: todos los elementos de lo ≤ todos los elementos de hi
        hi.offer(lo.poll());

        // Si el tamaño de hi supera al de lo, se devuelve el mínimo de hi a lo para restablecer el balance
        // Esta operación garantiza que el tamaño de lo sea siempre mayor o igual al de hi (diferencia máxima de 1)
        if (hi.size() > lo.size())
            lo.offer(hi.poll());
    }

    double findMedian() {
        // Si lo es más grande = la cantidad total de elementos es impar → la cima de lo (el máximo de la mitad inferior) es la mediana
        if (lo.size() > hi.size())
            return lo.peek();

        // Si los tamaños son iguales = la cantidad total de elementos es par → se devuelve el promedio de los dos valores centrales
        // Se divide entre 2.0 para realizar una división de punto flotante en lugar de una división entera
        return (lo.peek() + hi.peek()) / 2.0;
    }
}
```
