# Searching for a Target in a Sorted Array — Encontrar la posición de un objetivo en un arreglo ordenado

## Esencia del problema

Se proporcionan un arreglo ordenado de enteros `nums` y un entero `target`. Se debe encontrar el elemento en el arreglo que coincida con `target` y devolver su **índice**. Si `target` no existe en el arreglo, se devuelve `-1`.

## Idea central

Dado que el arreglo está ordenado, al comparar el elemento central con el objetivo, se puede reducir el rango de búsqueda a la mitad en cada iteración. Esto permite completar la búsqueda en O(log n) en lugar de O(n), que requeriría revisar todos los elementos.

## Proceso de razonamiento

1. **Aprovechar la condición de que el arreglo está ordenado**: Como el arreglo está ordenado, al observar el elemento en cualquier posición, se puede determinar si el objetivo se encuentra a su izquierda o a su derecha. Utilizando esta propiedad, se puede reducir el rango de búsqueda a la mitad en cada iteración
2. **Gestionar el rango de búsqueda con dos punteros**: Se representan los límites del rango de búsqueda con dos punteros: `left` para el extremo izquierdo y `right` para el extremo derecho del arreglo. En el estado inicial, el rango de búsqueda abarca todo el arreglo
3. **Comparar el elemento central con el objetivo**: Se calcula el índice central `mid` del rango de búsqueda y se compara `nums[mid]` con `target`. Si coinciden, `mid` es la respuesta
4. **Reducir el rango de búsqueda a la mitad según el resultado de la comparación**: Si `nums[mid] < target`, el objetivo se encuentra a la derecha del centro, por lo que se contrae el extremo izquierdo con `left = mid + 1`. Si `nums[mid] > target`, el objetivo se encuentra a la izquierda del centro, por lo que se contrae el extremo derecho con `right = mid - 1`
5. **Repetir hasta que el rango de búsqueda se agote**: La búsqueda continúa mientras `left <= right`. Cuando `left > right`, el rango de búsqueda está vacío, lo que significa que el objetivo no existe en el arreglo, y se devuelve `-1`
6. **Prevenir el desbordamiento al calcular el índice central**: La expresión `mid = (left + right) / 2` puede causar que `left + right` exceda el valor máximo de un entero. Al escribir `mid = left + (right - left) / 2`, se evita el desbordamiento

## Conocimientos previos

### ¿Qué es Binary Search (búsqueda binaria)?

Es un algoritmo que encuentra eficientemente un elemento objetivo reduciendo el rango de búsqueda a la mitad en cada iteración sobre un arreglo ordenado. Se compara el elemento central del rango de búsqueda con el objetivo y, si no coinciden, se descarta la mitad izquierda o la mitad derecha. Al repetir este proceso, el número de búsquedas se reduce a O(log n).

```java
// Número de búsquedas cuando el arreglo tiene longitud 8
// Iteración 1: 8 → 4 (se reduce a la mitad)
// Iteración 2: 4 → 2 (se reduce a la mitad)
// Iteración 3: 2 → 1 (se reduce a la mitad)
// Máximo 3 iteraciones = log₂(8) = 3
```

### Cálculo del índice central

Se obtiene la posición intermedia entre los dos punteros `left` y `right`. Al usar `left + (right - left) / 2` en lugar de `(left + right) / 2`, se previene el desbordamiento de enteros causado por la suma de `left + right`.

```java
int left = 0;
int right = 10;
int mid = left + (right - left) / 2;  // mid = 0 + (10 - 0) / 2 = 5
```

### Condición del bucle while `left <= right`

La condición `left <= right` significa que queda al menos un elemento en el rango de búsqueda. Cuando `left == right`, queda exactamente un elemento en el rango de búsqueda, y es necesario verificar este elemento, por lo que se usa `<=` en lugar de `<`.

```java
// Cuando left=3, right=3, nums[3] aún no se ha verificado
// left <= right es true, por lo que se puede verificar nums[3]
// Si se usara left < right, sería false y se terminaría sin verificar nums[3]
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(log n) — Al reducir el rango de búsqueda a la mitad en cada iteración, se necesitan como máximo log₂(n) comparaciones |
| Space | O(1) — Solo se utilizan variables para los punteros, sin necesidad de estructuras de datos adicionales |

## Código

```java
// Entrada: arreglo ordenado de enteros nums y un entero target
// Salida: devuelve el índice del elemento que coincide con target como int. Si no existe, devuelve -1
public int binarySearch(int[] nums, int target) {
    // Inicializar los extremos izquierdo y derecho del rango de búsqueda. Estas dos variables gestionan el rango de búsqueda
    int left = 0;
    int right = nums.length - 1;

    // left <= right: se repite mientras quede al menos un elemento en el rango de búsqueda
    // Cuando left > right, el rango de búsqueda está vacío y se sale del bucle
    while (left <= right) {
        // Nota: (left + right) / 2 puede causar desbordamiento de enteros en la suma left + right
        // Al escribir left + (right - left) / 2, se previene el desbordamiento
        int mid = left
            + (right - left) / 2;

        // Si el elemento central coincide con el objetivo, se devuelve el índice
        if (nums[mid] == target) {
            return mid;
        }

        // Si el objetivo es mayor que el elemento central, se reduce el rango de búsqueda a la mitad derecha
        // Como mid ya fue verificado, se establece mid + 1
        if (nums[mid] < target) {
            left = mid + 1;
        }
        // Si el objetivo es menor que el elemento central, se reduce el rango de búsqueda a la mitad izquierda
        // Como mid ya fue verificado, se establece mid - 1
        else {
            right = mid - 1;
        }
    }

    // El rango de búsqueda se ha agotado, por lo que el objetivo no existe en el arreglo
    return -1;
}
```
