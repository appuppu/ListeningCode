# Finding the Smallest Interval Containing Each Query — Encontrar el intervalo más pequeño que contiene cada consulta

## Esencia del problema

Se reciben un arreglo 2D de enteros `intervals` (cada elemento es `[left, right]`) y un arreglo de enteros `queries`. Para cada valor de consulta, se debe encontrar el intervalo que lo contiene y cuyo **tamaño sea el mínimo**. El tamaño del intervalo se define como `right - left + 1`. Si no existe ningún intervalo que contenga la consulta, se devuelve `-1`.

## Idea central

Al ordenar tanto las consultas como los intervalos y procesarlos en orden ascendente del valor de consulta, se pueden agregar secuencialmente al Min-Heap los intervalos cuyo extremo izquierdo sea menor o igual al valor de consulta. Extrayendo del Min-Heap el intervalo de tamaño mínimo cuyo extremo derecho sea mayor o igual al valor de consulta, se obtiene la respuesta.

## Proceso de razonamiento

1. **Examinar todos los intervalos para cada consulta es ineficiente**: Recorrer todos los intervalos para cada consulta cuesta O(n×q). Si se ordenan tanto las consultas como los intervalos, el proceso de agregar intervalos se comparte entre todas las consultas, eliminando recorridos redundantes
2. **Al procesar las consultas en orden ascendente, la adición de intervalos se vuelve monótona**: Si se ordenan los intervalos por su extremo izquierdo y las consultas en orden ascendente por valor, a medida que el valor de consulta aumenta, los intervalos que cumplen la condición "extremo izquierdo menor o igual a la consulta" solo aumentan y nunca disminuyen. Es decir, la adición de intervalos se convierte en una operación monótona que solo avanza un puntero
3. **Se desea obtener rápidamente el tamaño mínimo entre los intervalos agregados**: Para extraer el intervalo de tamaño mínimo entre los candidatos, el Min-Heap (montículo mínimo) es la estructura adecuada. Si se usa el tamaño del intervalo como clave del heap, se puede obtener el intervalo de tamaño mínimo en O(1) con la operación peek
4. **Los intervalos cuyo extremo derecho es menor que el valor de consulta son inválidos**: Entre los intervalos que permanecen en el heap, aquellos cuyo extremo derecho es menor que el valor de consulta no contienen dicha consulta. Estos intervalos se eliminan secuencialmente desde la cima del heap con poll. Una vez eliminado un intervalo, también es inválido para las consultas posteriores (ya que los valores de consulta van en aumento), por lo que no es necesario volver a agregarlo
5. **Es necesario preservar el orden original de las consultas**: Las consultas se procesan ordenadas, pero los resultados deben devolverse en el orden original. Por ello, antes de ordenar se conserva el índice original de cada consulta como un par, y se escribe la respuesta en la posición correspondiente del arreglo de resultados
6. **Si el heap está vacío, no existe ningún intervalo que contenga la consulta**: Si después de eliminar los intervalos inválidos el heap queda vacío, no existe ningún intervalo que contenga esa consulta, por lo que se almacena `-1` en el resultado

## Conocimientos previos

### ¿Qué es PriorityQueue (Min-Heap)?

Es una estructura de datos que gestiona elementos según su prioridad. Por defecto, el valor mínimo se ubica en la cima (Min-Heap). La adición y extracción de elementos se realizan en O(log n), y la consulta del elemento en la cima se realiza en O(1).

```java
// Min-Heap que almacena int[] y los ordena en orden ascendente por el elemento en la posición 0 (tamaño)
PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[0] - b[0]);
heap.offer(new int[]{5, 10});  // Agregar un elemento
heap.peek();                    // Consultar el elemento en la cima sin extraerlo → {5, 10}
heap.poll();                    // Extraer y eliminar el elemento en la cima → {5, 10}
heap.isEmpty();                 // Verificar si el heap está vacío → true
```

### ¿Qué es una consulta offline?

Es una técnica que consiste en reordenar las consultas en un orden conveniente para el procesamiento, en lugar de procesarlas en el orden de llegada. Los resultados se escriben en la posición correcta utilizando el índice original. Es efectiva cuando no existe dependencia entre las consultas.

```java
int q = queries.length;
int[][] sortedQ = new int[q][2];
for (int i = 0; i < q; i++) {
    sortedQ[i] = new int[]{queries[i], i};  // Crear un par de {valor de consulta, índice original}
}
Arrays.sort(sortedQ, (a, b) -> a[0] - b[0]);  // Ordenar en orden ascendente por valor de consulta
```

### Comparador personalizado de Arrays.sort

Permite ordenar arreglos 2D o arreglos de objetos según un criterio arbitrario. La expresión lambda `(a, b) -> a[0] - b[0]` significa ordenar en orden ascendente por el valor en la posición 0 de cada elemento.

```java
int[][] intervals = {{3, 6}, {1, 4}, {2, 8}};
Arrays.sort(intervals, (a, b) -> a[0] - b[0]);  // Ordenar en orden ascendente por extremo izquierdo → {{1,4}, {2,8}, {3,6}}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n log n + q log q) — O(n log n) para ordenar los intervalos, O(q log q) para ordenar las consultas, y O(n log n) para las operaciones del heap ya que cada intervalo se agrega y elimina como máximo una vez |
| Space | O(n + q) — El heap almacena como máximo n intervalos y el arreglo de consultas ordenadas almacena q elementos |

## Código

```java
// Entrada: arreglo 2D de enteros intervals (cada elemento es [left, right]) y arreglo de enteros queries
// Salida: devuelve un int[] que contiene el tamaño del intervalo más pequeño que contiene cada consulta. Si no existe tal intervalo, se almacena -1
public int[] minInterval(int[][] intervals, int[] queries) {
    // Ordenar los intervalos en orden ascendente por extremo izquierdo. De este modo, basta con avanzar el puntero j para agregar sin omisión todos los intervalos cuyo extremo izquierdo sea menor o igual al valor de consulta
    Arrays.sort(intervals, (a, b) -> a[0] - b[0]);

    int q = queries.length;
    // Asignar a cada consulta su índice original formando un par. Es necesario para escribir los resultados en la posición correcta después de ordenar
    int[][] sortedQ = new int[q][2];
    for (int i = 0; i < q; i++) {
        sortedQ[i] = new int[]{queries[i], i};
    }
    // Ordenar en orden ascendente por valor de consulta. Al procesar en orden ascendente, la adición de intervalos se convierte en una operación monótona
    Arrays.sort(sortedQ, (a, b) -> a[0] - b[0]);

    // Min-Heap que almacena {tamaño del intervalo, extremo derecho} y los extrae en orden ascendente por tamaño. Al usar el tamaño como clave, se puede consultar el intervalo de tamaño mínimo en O(1)
    PriorityQueue<int[]> heap =
        new PriorityQueue<>((a, b) -> a[0] - b[0]);

    int[] res = new int[q];
    int j = 0;  // Puntero que recorre el arreglo de intervalos. Solo avanza a lo largo de todas las consultas, por lo que el total de adiciones de intervalos es O(n)

    for (int[] sq : sortedQ) {
        int val = sq[0], idx = sq[1];  // val=valor de consulta, idx=índice original

        // Agregar al heap todos los intervalos cuyo extremo izquierdo sea menor o igual al valor de consulta. Como j no retrocede, el total es O(n)
        while (j < intervals.length && intervals[j][0] <= val) {
            int sz = intervals[j][1] - intervals[j][0] + 1;  // Tamaño del intervalo = right - left + 1
            heap.offer(new int[]{sz, intervals[j][1]});  // Agregar {tamaño, extremo derecho} al heap
            j++;
        }

        // Eliminar los intervalos cuyo extremo derecho es menor que el valor de consulta (no contienen la consulta). Como los valores de consulta aumentan en orden ascendente, un intervalo eliminado una vez también es inválido en adelante
        while (!heap.isEmpty() && heap.peek()[1] < val) {
            heap.poll();
        }

        // Si el heap está vacío no existe ningún intervalo que contenga la consulta; de lo contrario, el tamaño del intervalo en la cima es la respuesta (los intervalos inválidos ya fueron eliminados, por lo que la cima es el mínimo válido)
        res[idx] = heap.isEmpty() ? -1 : heap.peek()[0];
    }
    return res;
}
```
