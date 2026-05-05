# Tracking the Kth Largest Element in a Stream — Obtener siempre el K-ésimo elemento más grande de un stream

## Esencia del problema

Se diseña una clase que recibe un entero `k` y una lista inicial de números. Cada vez que se invoca el método `add`, este agrega un nuevo número al stream y devuelve el **K-ésimo elemento más grande** de todo el stream en ese momento.

## Idea central

Como solo se necesita el K-ésimo elemento más grande, basta con mantener los K elementos mayores en un Min-Heap. De esta forma, la raíz del heap (el valor mínimo) siempre será el K-ésimo elemento más grande.

## Proceso de razonamiento

1. **Solo se necesita el K-ésimo elemento más grande**: No es necesario ordenar todo el stream; basta con conocer los K elementos mayores para determinar el K-ésimo elemento más grande
2. **Se desea gestionar los K elementos mayores de forma eficiente**: Un Min-Heap (heap mínimo) es adecuado porque permite agregar elementos y extraer el mínimo en O(log n). Dado que la raíz del Min-Heap siempre contiene el valor mínimo dentro del heap, si se mantiene el tamaño en K, la raíz será el K-ésimo elemento más grande
3. **Método para limitar el tamaño del heap a K**: Después de agregar un nuevo elemento, si el tamaño del heap supera K, se elimina la raíz (el valor mínimo) con `poll()`. De esta manera, los valores menores que el K-ésimo elemento más grande se eliminan automáticamente, y solo quedan los K elementos mayores
4. **Método para obtener el K-ésimo elemento más grande**: Cuando el tamaño del heap es exactamente K, el valor de la raíz es el K-ésimo elemento más grande. Se puede obtener en O(1) con `peek()`
5. **Reutilizar add durante la inicialización**: Si se invoca `add` para cada elemento de la lista inicial en el constructor, se puede construir el heap con la misma lógica. Esto permite compartir el código entre la inicialización y la adición

## Conocimientos previos

### Qué es un Min-Heap (heap mínimo)

Un heap es una estructura de datos con forma de árbol binario completo. En un Min-Heap, el valor del nodo padre siempre se mantiene menor o igual que el valor de los nodos hijos. Por lo tanto, la raíz siempre contiene el valor mínimo dentro del heap. La adición de elementos y la extracción del mínimo se realizan en O(log n).

### Qué es PriorityQueue

Es la clase de implementación de Min-Heap en Java. Por defecto, prioriza los elementos en orden ascendente (de menor a mayor).

```java
PriorityQueue<Integer> heap = new PriorityQueue<>();  // Crear un Min-Heap vacío
heap.offer(5);        // Agregar el elemento 5 al heap
heap.offer(3);        // Agregar el elemento 3 al heap
heap.offer(8);        // Agregar el elemento 8 al heap
heap.peek();          // Devolver la raíz (valor mínimo) del heap sin eliminarla → 3
heap.poll();          // Eliminar y devolver la raíz (valor mínimo) del heap → 3
heap.size();          // Devolver la cantidad de elementos en el heap → 2
```

### Por qué un Min-Heap permite conocer el K-ésimo elemento más grande

Un Min-Heap de tamaño K contiene los K elementos más grandes. La raíz del heap es el valor más pequeño entre ellos, es decir, "el mínimo de los K mayores" = "el K-ésimo elemento más grande del total".
Ejemplo: k=3, el contenido del heap es [4, 5, 8], la raíz es 4. Este es el tercer elemento más grande del total.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(log k) — Por cada invocación del método add, la inserción y la eliminación en un heap de tamaño K se realizan en O(log k) cada una |
| Space | O(k) — El heap mantiene siempre un máximo de K elementos |

## Código

```java
// Entrada: un entero k, un arreglo inicial de enteros nums, y un entero val que se pasa al método add
// Salida: el método add devuelve como int el K-ésimo elemento más grande de todo el stream
class KthLargest {
    // Se almacena K como campo porque se usa continuamente como límite de tamaño del heap
    int k;
    // PriorityQueue funciona por defecto como un Min-Heap (el valor mínimo está en la raíz)
    PriorityQueue<Integer> heap;

    // Constructor: recibe k y el arreglo inicial, y construye el heap
    KthLargest(int k, int[] nums) {
        this.k = k;
        heap = new PriorityQueue<>();
        // Como la limitación del tamaño del heap se realiza dentro del método add, no se necesita lógica específica para la inicialización
        for (int n : nums) {
            add(n);
        }
    }

    // Agrega un nuevo valor y devuelve el K-ésimo elemento más grande
    int add(int val) {
        // Inserta el elemento al final del heap y lo mueve hacia el padre para mantener la propiedad del heap (O(log k))
        heap.offer(val);

        // Si el tamaño supera K, existe un elemento adicional menor que el K-ésimo
        if (heap.size() > k) {
            // Como la raíz del Min-Heap siempre es el valor mínimo, lo que se elimina es un valor menor que el K-ésimo
            heap.poll();
        }

        // Cuando el tamaño del heap es exactamente K, la raíz es el valor mínimo del heap = el K-ésimo elemento más grande del total
        return heap.peek();
    }
}
```
