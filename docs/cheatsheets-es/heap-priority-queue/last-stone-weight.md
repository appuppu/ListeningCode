# Simulación del juego de la última piedra — Obtener el peso de la última piedra que queda tras chocar las piedras de dos en dos

## Esencia del problema

Se da un arreglo de enteros `stones`. En cada turno se extraen las **dos piedras más pesadas** y se chocan entre sí. Si ambas piedras pesan lo mismo, las dos se destruyen; si pesan distinto, la más ligera se destruye y la más pesada se reduce al peso de la diferencia. Se repite esta operación hasta que quede una piedra o ninguna, y se devuelve el peso de la piedra restante. Si no queda ninguna piedra, se devuelve 0.

## Idea central

Es necesario extraer de forma eficiente las "dos más pesadas" en cada turno. Usando un montículo máximo (Max-Heap), la extracción del valor máximo se realiza en O(log n), por lo que siempre se pueden obtener las dos piedras más pesadas sin necesidad de reordenar.

## Proceso de razonamiento

1. **En cada operación se necesitan los dos valores máximos**: La regla de chocar piedras exige seleccionar siempre las dos piedras más pesadas. Es decir, el problema consiste en repetir la operación de "extraer el valor máximo dos veces del conjunto actual"
2. **Se desea extraer el valor máximo de forma rápida**: Si se ordena el arreglo en cada turno, se incurre en O(n log n) por ronda. Con un montículo máximo, la extracción del máximo cuesta O(log n) y la inserción de un elemento también cuesta O(log n)
3. **Usar PriorityQueue de Java como Max-Heap**: La PriorityQueue de Java es por defecto un Min-Heap (el valor mínimo queda al frente). Pasando `Collections.reverseOrder()` como comparador, se hace funcionar como un Max-Heap donde el valor máximo queda al frente
4. **Insertar todas las piedras en el montículo**: Se añaden todos los elementos del arreglo `stones` a la PriorityQueue. Con esto, el montículo queda listo para gestionar el valor máximo
5. **Repetir la operación de choque mientras haya dos o más piedras**: Se extraen los dos valores máximos del montículo con `poll()` dos veces; si la diferencia no es 0, se devuelve la diferencia al montículo con `add()`. Si la diferencia es 0, no se devuelve nada (ambas piedras se destruyen)
6. **Evaluar el estado final y devolver el resultado**: Tras terminar el bucle, si el montículo está vacío, todas las piedras se destruyeron, por lo que se devuelve 0. Si queda una piedra en el montículo, se extrae su peso con `poll()` y se devuelve

## Conocimientos previos

### Qué es una PriorityQueue (cola de prioridad)

Es una estructura de datos que gestiona automáticamente el orden interno al añadir elementos, y permite extraer siempre el elemento de mayor prioridad con `poll()`. La implementación interna es un montículo (montículo binario), y tanto la adición como la extracción operan en O(log n).

```java
// Por defecto es un Min-Heap (el valor mínimo queda al frente)
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.add(5);       // Añade el elemento 5
minHeap.add(2);       // Añade el elemento 2
minHeap.poll();       // Extrae y devuelve el valor mínimo 2
minHeap.size();       // Devuelve el número actual de elementos → 1
minHeap.isEmpty();    // Devuelve un boolean indicando si la cola está vacía → false
```

### Qué es Collections.reverseOrder()

Es un comparador que se pasa al constructor de PriorityQueue para invertir el orden ascendente por defecto (Min-Heap) a orden descendente (Max-Heap). De este modo, `poll()` pasa a devolver el valor máximo.

```java
// Crear un Max-Heap (el valor máximo queda al frente)
PriorityQueue<Integer> maxHeap =
    new PriorityQueue<>(Collections.reverseOrder());
maxHeap.add(3);       // Añade el elemento 3
maxHeap.add(7);       // Añade el elemento 7
maxHeap.add(1);       // Añade el elemento 1
maxHeap.poll();       // Extrae y devuelve el valor máximo 7
maxHeap.poll();       // Extrae y devuelve el siguiente valor máximo 3
```

### Imagen del funcionamiento de un Max-Heap

stones = [2, 7, 4, 1, 8, 1] en este caso:
- Al añadir todos los elementos al montículo, internamente se gestionan como `[8, 7, 4, 1, 2, 1]`
- `poll()` → Se extrae 8. El montículo se reconstruye como `[7, 4, 2, 1, 1]`
- `poll()` → Se extrae 7. Se devuelve 8 - 7 = 1 al montículo con `add()`

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n log n) — Hay como máximo n operaciones de choque, y cada operación cuesta O(log n) por la extracción e inserción en el montículo |
| Space | O(n) — Se almacenan como máximo n piedras en el montículo |

## Código

```java
// Entrada: arreglo de enteros stones (cada elemento es el peso de una piedra)
// Salida: devuelve como int el peso de la última piedra que queda. Si no queda ninguna piedra, devuelve 0
public int lastStoneWeight(int[] stones) {
    // Se especifica Collections.reverseOrder() como comparador para crear un Max-Heap donde poll() devuelve el valor máximo
    PriorityQueue<Integer> pq =
        new PriorityQueue<>(Collections.reverseOrder());

    // Se añaden todas las piedras al montículo. Al completarse, el montículo queda gestionando el valor máximo al frente
    for (int s : stones) pq.add(s);

    // Se repite la operación de chocar las dos piedras más pesadas mientras haya dos o más piedras
    while (pq.size() >= 2) {
        // Se llama a poll() dos veces para extraer la piedra más pesada y la siguiente más pesada
        // Como es un Max-Heap, siempre se cumple que a >= b
        int a = pq.poll();
        int b = pq.poll();

        // Si los pesos son distintos, se devuelve la piedra con el peso de la diferencia al montículo. Si son iguales, ambas se destruyen y no se devuelve nada
        if (a != b) pq.add(a - b);
    }

    // Si el montículo está vacío, todas las piedras se destruyeron y se devuelve 0; si queda una, se devuelve su peso
    return pq.isEmpty() ? 0 : pq.poll();
}
```
