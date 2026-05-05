# Finding the Minimum in a Rotated Sorted Array — Encontrar el valor mínimo en un arreglo ordenado y rotado

## Esencia del problema

Se tiene un arreglo de enteros únicos ordenados en orden ascendente que ha sido rotado entre 1 y n veces. El objetivo es encontrar y devolver el **elemento mínimo** de este arreglo rotado. La rotación consiste en mover el último elemento del arreglo al inicio, lo que genera un pivote donde el orden original se "quiebra".

## Idea central

En un arreglo ordenado y rotado, el valor mínimo se encuentra en la posición del "pivote", donde el orden se rompe. Al comparar el elemento central con el elemento del extremo derecho, se puede determinar en una sola comparación si el valor mínimo está en la mitad izquierda o en la mitad derecha, lo que permite encontrarlo en O(log n) mediante búsqueda binaria.

## Proceso de razonamiento

1. **El valor mínimo se encuentra en la posición del pivote**: Un arreglo ordenado y rotado se divide en dos subsecuencias ordenadas: una "parte mayor" y una "parte menor". El valor mínimo está al inicio de la "parte menor", es decir, en la posición del pivote. Encontrar este pivote es la esencia del problema
2. **Se desea usar búsqueda binaria en lugar de búsqueda lineal**: Aunque el arreglo no está completamente ordenado, tiene la estructura de estar dividido en dos partes ordenadas. Aprovechando esta estructura, se puede aplicar una búsqueda binaria que descarta la mitad en cada iteración
3. **Se compara el elemento central con el elemento del extremo derecho**: Si se cumple `nums[mid] > nums[right]`, el pivote (la ruptura del orden) existe entre mid y right, por lo que el valor mínimo está en la mitad derecha. Por el contrario, si `nums[mid] <= nums[right]`, la sección de mid a right está ordenada, y el valor mínimo se encuentra en la parte izquierda de mid (incluyendo mid mismo)
4. **Razón por la que se compara con el extremo derecho y no con el izquierdo**: Si se compara con el extremo izquierdo, no se puede determinar correctamente el caso en que el arreglo no ha sido rotado (es decir, está completamente ordenado). Al comparar con el extremo derecho, se puede acotar correctamente la posición del valor mínimo independientemente de si hubo rotación o no
5. **Método de actualización del rango de búsqueda**: Cuando `nums[mid] > nums[right]`, se confirma que mid no es el valor mínimo, por lo que se establece `left = mid + 1`. En caso contrario, mid podría ser el valor mínimo, por lo que se establece `right = mid` (sin excluir mid)
6. **Condición de terminación del bucle**: El bucle se ejecuta mientras `left < right`, y cuando `left == right`, el rango de búsqueda se reduce a un solo elemento. Ese elemento `nums[left]` es el valor mínimo

## Conocimientos previos

### Qué es un arreglo ordenado y rotado

Si se rota dos veces a la derecha el arreglo ordenado en orden ascendente `[1, 2, 3, 4, 5]`, se obtiene `[4, 5, 1, 2, 3]`. El arreglo se divide en dos subsecuencias ordenadas `[4, 5]` y `[1, 2, 3]`, y el límite entre ellas es el pivote.

```
Arreglo original:          [1, 2, 3, 4, 5]
Después de 2 rotaciones:   [4, 5, 1, 2, 3]
                                ↑ Pivote (valor mínimo)
```

### Estructura básica de la búsqueda binaria

Es una técnica que encuentra el elemento objetivo en O(log n) reduciendo el rango de búsqueda a la mitad en cada iteración. El rango de búsqueda se gestiona con dos punteros, left y right, y se actualiza el rango en función del elemento central.

```java
int left = 0;
int right = nums.length - 1;
int mid = left + (right - left) / 2;  // Cálculo del punto medio que previene el desbordamiento
```

### Qué significa `left + (right - left) / 2`

Es una expresión que calcula el índice central. Aunque `(left + right) / 2` produce el mismo resultado, cuando left y right tienen valores grandes, la suma puede superar el valor máximo de int. Esta expresión es una forma segura de escribirlo que **previene ese desbordamiento**.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(log n) — Dado que el rango de búsqueda se reduce a la mitad en cada iteración, el valor mínimo se encuentra en un máximo de log n comparaciones |
| Space | O(1) — Solo se utilizan tres variables: left, right y mid, sin necesidad de estructuras de datos adicionales |

## Código

```java
// Entrada: arreglo de enteros únicos ordenado y rotado nums
// Salida: devuelve el valor mínimo del arreglo como int
public int findMin(int[] nums) {
    // Se inicializan los extremos del rango de búsqueda. Estas dos variables representan los límites del rango
    int left = 0;
    int right = nums.length - 1;

    // Cuando left == right, el rango de búsqueda se reduce a un solo elemento, y ese elemento es el valor mínimo
    while (left < right) {
        // Se usa esta expresión en lugar de (left + right) / 2 para prevenir el desbordamiento de enteros
        int mid = left + (right - left) / 2;

        // Si el elemento central es mayor que el extremo derecho, el pivote (ruptura del orden) existe entre mid y right
        if (nums[mid] > nums[right]) {
            // El valor mínimo está a la derecha de mid. Como mid es mayor que el extremo derecho, no es el mínimo y se puede excluir
            left = mid + 1;
        } else {
            // Desde mid hasta right el arreglo está ordenado. El valor mínimo está a la izquierda de mid (incluyendo mid mismo)
            // Como mid mismo podría ser el valor mínimo, no se excluye del rango de búsqueda
            right = mid;
        }
    }

    // left == right, el rango de búsqueda se ha reducido a un solo elemento, por lo que ese elemento es el valor mínimo
    return nums[left];
}
```
