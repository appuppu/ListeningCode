# Simulating a Last Stone Weight Game — Determinar el peso de la última piedra que queda tras chocar las piedras de dos en dos

## Esencia del problema

Se recibe un arreglo de enteros `stones`. En cada turno se extraen las **dos piedras más pesadas** y se hacen chocar. Si ambas piedras tienen el mismo peso, las dos se destruyen; si son diferentes, la más ligera se destruye y la más pesada se reduce al peso de la diferencia. Se repite esta operación hasta que quede una piedra o ninguna, y se devuelve el peso de la piedra restante. Si no queda ninguna piedra, se devuelve 0.

## Idea central

Es necesario extraer eficientemente las "dos más pesadas" en cada turno. Si se utiliza un Max-Heap (montículo máximo), la extracción del valor máximo se realiza en O(log n), lo que permite obtener siempre las dos piedras más pesadas sin necesidad de reordenar el arreglo.

## Proceso de razonamiento

1. **Cada operación requiere los dos valores máximos**: Las reglas de choque exigen seleccionar siempre las dos piedras más pesadas. Es decir, el problema consiste en repetir la operación de "extraer el máximo dos veces del conjunto actual"
2. **Se busca extraer el máximo de forma rápida**: Si se ordena el arreglo en cada turno, el costo es O(n log n) por ronda. Con un Max-Heap, la extracción del máximo cuesta O(log n) y la inserción también cuesta O(log n)
3. **Usar PriorityQueue de Java como Max-Heap**: La PriorityQueue de Java es por defecto un Min-Heap (el valor mínimo está al frente). Al pasar `Collections.reverseOrder()` como comparador, se logra que funcione como un Max-Heap con el valor máximo al frente
4. **Insertar todas las piedras en el heap**: Se agregan todos los elementos del arreglo `stones` a la PriorityQueue. Con esto, el heap queda listo para gestionar el valor máximo
5. **Repetir la operación de choque mientras haya dos o más piedras**: Se extrae el máximo dos veces con `poll()` y, si la diferencia no es 0, se devuelve la diferencia al heap con `add()`. Si la diferencia es 0, no se devuelve nada (ambas piedras se destruyen)
6. **Evaluar el estado final y devolver el resultado**: Tras finalizar el bucle, si el heap está vacío, todas las piedras se destruyeron y se devuelve 0. Si queda una piedra en el heap, se extrae su peso con `poll()` y se devuelve

## Conocimientos previos

### ¿Qué es una PriorityQueue (cola de prioridad)?

Es una estructura de datos en la que, al agregar elementos, el orden se gestiona automáticamente de forma interna, y con `poll()` siempre se extrae el elemento de mayor prioridad. La implementación interna es un heap (heap binario), y tanto la inserción como la extracción operan en O(log n).

```java
// Por defecto es un Min-Heap (el valor mínimo está al frente)
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.add(5);       // Agrega el elemento 5
minHeap.add(2);       // Agrega el elemento 2
minHeap.poll();       // Extrae y devuelve el valor mínimo 2
minHeap.size();       // Devuelve el número actual de elementos → 1
minHeap.isEmpty();    // Devuelve un boolean indicando si la cola está vacía → false
```

### ¿Qué es Collections.reverseOrder()?

Es un comparador que se pasa al constructor de PriorityQueue y que invierte el orden ascendente por defecto (Min-Heap) a orden descendente (Max-Heap). Con esto, `poll()` pasa a devolver el valor máximo.

```java
// Crear un Max-Heap (el valor máximo está al frente)
PriorityQueue<Integer> maxHeap =
    new PriorityQueue<>(Collections.reverseOrder());
maxHeap.add(3);       // Agrega el elemento 3
maxHeap.add(7);       // Agrega el elemento 7
maxHeap.add(1);       // Agrega el elemento 1
maxHeap.poll();       // Extrae y devuelve el valor máximo 7
maxHeap.poll();       // Extrae y devuelve el siguiente valor máximo 3
```

### Imagen del funcionamiento de un Max-Heap

Para stones = [2, 7, 4, 1, 8, 1]:
- Al agregar todos los elementos al heap, internamente se gestionan como `[8, 7, 4, 1, 2, 1]`
- `poll()` → Se extrae 8. El heap se reorganiza como `[7, 4, 2, 1, 1]`
- `poll()` → Se extrae 7. Se devuelve 8 - 7 = 1 al heap con `add()`

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n log n) — Se realizan como máximo n operaciones de choque, y cada operación requiere O(log n) para la extracción e inserción en el heap |
| Space | O(n) — El heap almacena como máximo n piedras |

## Código

```java
// Entrada: arreglo de enteros stones (cada elemento representa el peso de una piedra)
// Salida: devuelve como int el peso de la última piedra restante. Si no queda ninguna piedra, devuelve 0
public int lastStoneWeight(int[] stones) {
    // Se crea un Max-Heap (el valor máximo al frente) con Collections.reverseOrder()
    // La PriorityQueue por defecto es un Min-Heap, así que se invierte el orden con el comparador
    PriorityQueue<Integer> pq =
        new PriorityQueue<>(Collections.reverseOrder());

    // Se agregan todas las piedras al heap. Tras insertar todos los elementos, el heap gestiona el valor máximo al frente
    for (int s : stones) pq.add(s);

    // Se repite la operación de chocar las dos piedras más pesadas mientras haya dos o más piedras
    while (pq.size() >= 2) {
        // Se llama a poll() dos veces para extraer la piedra más pesada y la siguiente más pesada
        // Como es un Max-Heap, siempre se cumple que a >= b
        int a = pq.poll();  // Se extrae la piedra más pesada
        int b = pq.poll();  // Se extrae la siguiente piedra más pesada

        // Si los pesos son diferentes, se devuelve la piedra con el peso de la diferencia al heap. Si son iguales, ambas se destruyen y no se devuelve nada
        if (a != b) pq.add(a - b);
    }

    // Si el heap está vacío, todas las piedras se destruyeron y se devuelve 0; si queda una, se devuelve su peso
    return pq.isEmpty() ? 0 : pq.poll();
}
```
