# Searching for a Target in a Rotated Sorted Array — Buscar un objetivo en un arreglo ordenado y rotado

## Esencia del problema

Se tiene un arreglo de enteros ordenado en orden ascendente que ha sido rotado en un pivote desconocido. Se debe buscar el valor del `target` dado dentro de este arreglo y devolver su índice. Si el `target` no existe, se devuelve `-1`. Todos los elementos son únicos.

## Idea central

Al dividir un arreglo ordenado y rotado por el centro, una de las dos mitades (izquierda o derecha) siempre está ordenada. Se determina mediante una verificación de rango si el `target` se encuentra en la mitad ordenada; si no se encuentra allí, se explora la otra mitad. De esta forma, el rango de búsqueda se reduce a la mitad en cada iteración.

## Proceso de razonamiento

1. **Se desea usar Binary Search porque el arreglo está ordenado**: En un arreglo ordenado normal, Binary Search permite buscar en O(log n). Se busca una forma de mantener esta eficiencia incluso con la rotación.
2. **Al dividir un arreglo rotado por el centro, una de las mitades siempre está ordenada**: Si se divide el arreglo `[4,5,6,7,0,1,2]` en `mid=3` (valor 7), la mitad izquierda `[4,5,6,7]` está ordenada y la mitad derecha `[0,1,2]` también está ordenada. Dado que el pivote de rotación solo puede estar en una de las mitades, la otra mantiene necesariamente el orden ascendente.
3. **Método para determinar cuál mitad está ordenada**: Si se cumple `nums[left] <= nums[mid]`, la mitad izquierda está ordenada. Si no se cumple, la mitad derecha está ordenada. Se incluye el signo de igualdad para manejar correctamente el caso en que `left == mid` (cuando hay dos elementos o menos).
4. **Determinar si el target se encuentra en la mitad ordenada**: Como se conocen el valor mínimo y máximo de la mitad ordenada, se puede determinar mediante desigualdades si el `target` está dentro de ese rango. Por ejemplo, si la mitad izquierda está ordenada, se evalúa con `target >= nums[left] && target < nums[mid]`.
5. **Explorar la mitad que contiene el target**: Si el `target` está dentro del rango de la mitad ordenada, se restringe la búsqueda a esa mitad. Si está fuera del rango, el `target` debe estar en la otra mitad, por lo que se explora esa otra mitad.
6. **Procesamiento al finalizar el bucle**: Si la búsqueda continúa hasta que `left > right` sin encontrar el `target`, significa que el `target` no existe en el arreglo, por lo que se devuelve `-1`.

## Conocimientos previos

### ¿Qué es Binary Search (búsqueda binaria)?

Es una técnica de búsqueda en un arreglo ordenado que examina el elemento central del rango de búsqueda y reduce el rango a la mitad de forma repetida. Como el rango se reduce a la mitad en cada iteración, la búsqueda se realiza con una complejidad temporal de O(log n).

```java
int left = 0;
int right = nums.length - 1;
while (left <= right) {                    // Se itera mientras el rango de búsqueda sea válido
    int mid = left + (right - left) / 2;   // Cálculo del centro que previene el desbordamiento
    // Se compara nums[mid] con target y se actualiza left o right
}
```

### ¿Qué es un arreglo ordenado y rotado?

Es un arreglo ordenado en orden ascendente que se corta en cierta posición y se mueve la segunda mitad al inicio. Por ejemplo, al rotar `[0,1,2,4,5,6,7]` en el índice 4, se obtiene `[4,5,6,7,0,1,2]`. El arreglo completo no está ordenado, pero cada lado del pivote sí está ordenado individualmente.

```
Arreglo original:  [0, 1, 2, 4, 5, 6, 7]
Después de rotar:  [4, 5, 6, 7, 0, 1, 2]
                    ordenado↑  ↑ordenado
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(log n) — Como el rango de búsqueda se reduce a la mitad en cada iteración, se necesitan como máximo log n comparaciones |
| Space | O(1) — Solo se utilizan las 3 variables left, right y mid, sin necesidad de estructuras de datos adicionales |

## Código

```java
// Entrada: arreglo de enteros ordenado y rotado nums, y un entero target
// Salida: se devuelve el índice del target como int. Si no existe, se devuelve -1
public int search(int[] nums, int target) {
    // Se inicializan los extremos del rango de búsqueda. Estas 2 variables representan los extremos del rango
    int left = 0;
    int right = nums.length - 1;

    // Cuando left > right, significa que el rango de búsqueda se ha vaciado
    while (left <= right) {
        // Se usa esta fórmula en lugar de (left + right) / 2 para prevenir el desbordamiento de enteros en left + right
        int mid = left + (right - left) / 2;

        // Si el elemento central coincide con el target, se devuelve el índice
        if (nums[mid] == target) {
            return mid;
        }

        // Se determina si la mitad izquierda está ordenada
        // Se incluye el signo de igualdad para determinar correctamente que la mitad izquierda está ordenada cuando left == mid (rango de búsqueda con 2 elementos o menos)
        if (nums[left] <= nums[mid]) {
            // Se determina si el target está dentro del rango de la mitad izquierda
            if (target >= nums[left] && target < nums[mid]) {
                right = mid - 1;  // El target está dentro del rango de la mitad izquierda, así que se restringe a la mitad izquierda
            } else {
                left = mid + 1;   // El target está fuera del rango de la mitad izquierda, así que se restringe a la mitad derecha
            }
        // Caso en que la mitad derecha está ordenada
        } else {
            // Se determina si el target está dentro del rango de la mitad derecha
            if (target > nums[mid] && target <= nums[right]) {
                left = mid + 1;   // El target está dentro del rango de la mitad derecha, así que se restringe a la mitad derecha
            } else {
                right = mid - 1;  // El target está fuera del rango de la mitad derecha, así que se restringe a la mitad izquierda
            }
        }
    }

    // El rango de búsqueda se ha vaciado, por lo que el target no existe en el arreglo
    return -1;
}
```
