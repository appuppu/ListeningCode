# Finding the Kth Largest Element in an Array — Encontrar el K-ésimo elemento más grande en un arreglo sin ordenar

## Esencia del problema

Se recibe un arreglo de enteros `nums` y un entero `k`. Se debe devolver el valor del elemento que ocupa la posición `k` contando desde el más grande, como si el arreglo estuviera ordenado. Los valores duplicados se cuentan de forma independiente (no se busca el K-ésimo valor "distinto" más grande).

## Idea central

Sin necesidad de ordenar todo el arreglo, al dividirlo usando un pivote se puede saber de inmediato "en qué posición de mayor a menor se encuentra el pivote". Al reducir el rango de búsqueda a un solo lado hasta que la posición del pivote sea `k-1`, se alcanza el elemento deseado en un tiempo promedio de O(n).

## Proceso de razonamiento

1. **El K-ésimo elemento más grande se determina por su índice después de ordenar**: Si se ordena el arreglo en orden descendente, el elemento en el índice `k-1` es la respuesta. Sin embargo, un ordenamiento completo cuesta O(n log n), por lo que se busca un método más eficiente
2. **Solo se necesita la posición K-ésima**: No se requiere el orden completo; basta con saber "cuál es el K-ésimo elemento más grande". Al usar un pivote para dividir el arreglo en un "grupo mayor que el pivote" y un "grupo menor o igual al pivote", la posición (índice) del pivote indica su rango de mayor a menor
3. **Se reduce el rango de búsqueda según la posición del pivote**: Supongamos que, como resultado de la partición, el pivote queda en el índice `p`. Si `p == k-1`, se encontró la respuesta. Si `p < k-1`, el elemento buscado está a la derecha del pivote (en el lado de los valores más pequeños), por lo que el rango de búsqueda se reduce a partir de `p+1`. Si `p > k-1`, se reduce al lado izquierdo
4. **Se hace la partición en orden descendente**: La partición habitual de QuickSort es ascendente, pero para buscar "el K-ésimo más grande" se hace en orden descendente. Es decir, los elementos mayores que el pivote se agrupan a la izquierda. De esta forma, el índice `k-1` corresponde a la posición de la respuesta
5. **Se procesa repetidamente solo un lado mediante un bucle**: QuickSort procesa ambos lados de forma recursiva, pero Quickselect solo necesita procesar el lado que contiene la respuesta. Con un bucle while que se ejecuta mientras `l <= r`, se repite la partición y se devuelve el elemento cuando `p == k-1`

## Conocimientos previos

### Qué es Quickselect

Es un algoritmo que utiliza la misma operación de partición que QuickSort para encontrar el K-ésimo elemento más pequeño (o más grande) de un arreglo en un tiempo promedio de O(n). Mientras que QuickSort procesa ambos lados de forma recursiva, Quickselect solo procesa un lado, lo que reduce la complejidad promedio a O(n).

### Qué es la partición (partition)

Es una operación que selecciona un pivote del arreglo y mueve los elementos mayores que el pivote al lado izquierdo y los elementos menores o iguales al lado derecho. Después de la operación, el pivote queda en su posición correcta final. Esta posición (índice) representa el "rango" del pivote.

```java
// Partición descendente: agrupa los elementos mayores que el pivote a la izquierda
// Valor de retorno: el índice donde queda ubicado el pivote
int pivot = nums[r];       // Se elige el elemento del extremo derecho como pivote
int store = l;             // Puntero que indica la siguiente posición de intercambio
// Si nums[i] > pivot, se intercambia nums[i] con la posición store y se avanza store
// Al final se coloca el pivote en la posición store → store es la posición final del pivote
```

### Qué es el intercambio (swap)

Es una operación que intercambia las posiciones de dos elementos dentro de un arreglo. Se utiliza una variable temporal `temp` para respaldar el valor y evitar la sobreescritura.

```java
int temp = nums[i];    // Se respalda el valor de nums[i] en una variable temporal
nums[i] = nums[store]; // Se sobreescribe nums[i] con el valor de nums[store]
nums[store] = temp;    // Se escribe el valor original de nums[i] respaldado en nums[store]
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) promedio — Dado que el rango de búsqueda se reduce en promedio a la mitad en cada iteración, n + n/2 + n/4 + ... ≈ 2n = O(n) |
| Space | O(1) — Se opera sobre el arreglo in-place sin utilizar estructuras de datos adicionales |

## Código

```java
// Entrada: un arreglo de enteros nums y un entero k
// Salida: se devuelve como int el valor del K-ésimo elemento más grande del arreglo

// Partición descendente: agrupa los elementos mayores que el pivote a la izquierda y devuelve la posición final del pivote
private int partition(int[] nums, int l, int r) {
    // Se elige el elemento del extremo derecho del rango de búsqueda como pivote
    int pivot = nums[r];
    // store indica "la siguiente posición donde se debe colocar un elemento mayor que el pivote"
    int store = l;

    // Se recorre desde l hasta r-1, agrupando los elementos mayores que el pivote a la izquierda
    for (int i = l; i < r; i++) {
        // Si el elemento actual es mayor que el pivote, se intercambia con la posición store para agruparlo a la izquierda
        if (nums[i] > pivot) {
            int temp = nums[i];
            nums[i] = nums[store];
            nums[store] = temp;
            // Se avanza store en 1 para actualizar la siguiente posición de intercambio
            store++;
        }
    }

    // Se coloca el pivote en la posición store (la posición correcta final del pivote)
    // En este punto, a la izquierda de store están los elementos mayores que el pivote, y a la derecha los menores o iguales
    int temp = nums[store];
    nums[store] = nums[r];
    nums[r] = temp;
    // store es la posición final del pivote y representa su "rango" en orden descendente
    return store;
}

public int findKthLargest(int[] nums, int k) {
    // Se inicializan los extremos izquierdo y derecho del rango de búsqueda. Inicialmente, el rango abarca todo el arreglo
    int l = 0, r = nums.length - 1;

    // En cada iteración del bucle, el rango de búsqueda se reduce
    while (l <= r) {
        // Se ejecuta la partición en el rango de búsqueda actual [l, r] y se obtiene la posición del pivote
        int p = partition(nums, l, r);

        if (p == k - 1) {
            // El pivote está en la posición del K-ésimo más grande. En orden descendente, el índice k-1 corresponde a la posición del K-ésimo elemento más grande
            return nums[p];
        } else if (p < k - 1) {
            // El K-ésimo elemento más grande está a la derecha del pivote (en el lado de los valores más pequeños)
            l = p + 1;
        } else {
            // El K-ésimo elemento más grande está a la izquierda del pivote (en el lado de los valores más grandes)
            r = p - 1;
        }
    }
    // Según las restricciones del problema, siempre se proporciona un k válido, por lo que este punto nunca se alcanza
    return -1;
}
```
