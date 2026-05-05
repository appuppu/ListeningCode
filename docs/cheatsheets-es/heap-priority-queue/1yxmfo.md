# Finding the K Closest Points to the Origin — Encontrar los K puntos más cercanos al origen

## Esencia del problema

Se recibe un arreglo de puntos `points` en un plano bidimensional y un entero `k`. Se deben devolver los `k` puntos más cercanos al origen (0, 0) medidos por la distancia euclidiana. La respuesta se puede devolver en cualquier orden.

## Idea central

No es necesario realizar un ordenamiento completo para encontrar los "k puntos más cercanos". Si se utiliza el algoritmo Quickselect, basta con dividir el arreglo mediante un pivote y encontrar el límite en la posición k, de modo que los k puntos más cercanos queden agrupados en el lado izquierdo.

## Proceso de razonamiento

1. **Un ordenamiento completo es excesivo**: Solo se necesita devolver los k puntos más cercanos, y el orden no importa. Es decir, basta con poder dividir los puntos en "los k más cercanos" y "el resto". Un ordenamiento completo requiere O(n log n), pero la simple partición se puede hacer más rápido
2. **Encontrar la posición de partición con Quickselect**: Si se utiliza la operación de partición de Quicksort, los elementos menores que el pivote se agrupan a la izquierda y los mayores a la derecha. Si la posición final del pivote resulta ser exactamente k-1, los k elementos a la izquierda son la respuesta
3. **Simplificar el cálculo de la distancia**: La distancia euclidiana es `√(x² + y²)`, pero si solo se necesita comparar magnitudes, la raíz cuadrada es innecesaria y basta con comparar `x² + y²`. Esto permite evitar operaciones de punto flotante
4. **Mecanismo de la operación de partición**: Se selecciona el elemento del extremo derecho como pivote y se gestiona con `storeIdx` "la siguiente posición donde colocar un elemento menor o igual al pivote". Durante el recorrido, cuando se encuentra un elemento menor o igual al pivote, se intercambia con la posición de `storeIdx` y se avanza `storeIdx`
5. **Reducir el rango de búsqueda según la posición final del pivote**: Después de la partición, el pivote queda en la posición `storeIdx`. Si esta posición es menor que `k-1`, los elementos del lado izquierdo son insuficientes, por lo que se busca en la mitad derecha; si es mayor o igual a `k-1`, se busca en la mitad izquierda. Repitiendo este proceso, la partición se completa en O(n) en promedio
6. **Devolver los primeros k elementos**: Al finalizar el bucle, los primeros k elementos del arreglo son los puntos más cercanos, por lo que se extraen con `Arrays.copyOfRange(points, 0, k)` y se devuelven

## Conocimientos previos

### Qué es Quickselect

Es un algoritmo que encuentra el k-ésimo elemento más pequeño de un arreglo en O(n) en promedio. Aplica recursivamente la operación de partición de Quicksort solo a un lado, determinando así la posición deseada sin realizar un ordenamiento completo.

```java
// Estructura básica de la partición
int pivotValue = arr[right];       // Se selecciona el extremo derecho como pivote
int storeIdx = left;               // Posición donde se colocan los elementos menores o iguales al pivote
for (int i = left; i < right; i++) {
    if (arr[i] <= pivotValue) {    // Si es menor o igual al pivote, se agrupa a la izquierda
        swap(arr, i, storeIdx);
        storeIdx++;
    }
}
swap(arr, storeIdx, right);        // Se coloca el pivote en su posición correcta
// storeIdx es la posición final del pivote
```

### Cuadrado de la distancia euclidiana

La distancia desde el origen es `√(x² + y²)`, pero si solo se necesita comparar magnitudes, se puede omitir la raíz cuadrada y comparar con `x² + y²`. Dado que la función de raíz cuadrada es monótonamente creciente, la relación de orden de las distancias se preserva también con el cuadrado de las distancias.

```java
private int dist(int[] point) {
    return point[0] * point[0] + point[1] * point[1];  // x² + y²
}
```

### Qué es Arrays.copyOfRange

Es un método utilitario de Java que copia un rango especificado de un arreglo y lo devuelve como un nuevo arreglo.

```java
int[][] result = Arrays.copyOfRange(points, 0, k);  // Copia k elementos desde el índice 0 hasta k-1
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) en promedio — Dado que la partición se aplica solo a un lado, converge en un promedio de n + n/2 + n/4 + ... = 2n comparaciones |
| Space | O(1) — No se utiliza memoria adicional ya que el arreglo de entrada se reordena in-place |

## Código

```java
// Entrada: un arreglo de coordenadas bidimensionales points (cada elemento es [x, y]) y un entero k
// Salida: devuelve un int[][] que contiene los k puntos más cercanos al origen

// Devuelve el cuadrado de la distancia euclidiana de un punto al origen (se omite la raíz cuadrada ya que no es necesaria para comparar magnitudes)
private int dist(int[] p) {
    return p[0] * p[0] + p[1] * p[1];
}

public int[][] kClosest(int[][] points, int k) {
    // Se inicializan los extremos izquierdo y derecho del rango de búsqueda. Dentro de este rango se repite la partición para reordenar los primeros k elementos como los puntos más cercanos
    int left = 0;
    int right = points.length - 1;

    // Se repite la partición hasta que los primeros k elementos sean los puntos más cercanos
    while (left < right) {
        // Se selecciona el punto del extremo derecho como pivote y se calcula el cuadrado de su distancia euclidiana (x² + y²)
        int pivotDist = dist(points[right]);
        // storeIdx gestiona "la siguiente posición donde colocar un punto con distancia menor o igual al pivote"
        int storeIdx = left;

        // Se compara la distancia de cada punto con el pivote y se agrupan a la izquierda los puntos con distancia menor o igual
        for (int i = left; i < right; i++) {
            if (dist(points[i]) <= pivotDist) {
                // Es menor o igual al pivote, así que se intercambia a la posición de storeIdx para agruparlo a la izquierda
                int[] temp = points[i];
                points[i] = points[storeIdx];
                points[storeIdx] = temp;
                storeIdx++;
            }
        }

        // Se coloca el pivote en su posición final correcta storeIdx. A la izquierda quedan los puntos con distancia menor o igual, y a la derecha los puntos con distancia mayor
        int[] temp = points[storeIdx];
        points[storeIdx] = points[right];
        points[right] = temp;

        // Se compara la posición final del pivote con k-1 para reducir el rango de búsqueda a la mitad
        if (storeIdx < k - 1) {
            // Los elementos del lado izquierdo son menos de k, por lo que se busca en el lado derecho
            left = storeIdx + 1;
        } else {
            // Nota: cuando storeIdx es exactamente k-1, al reducir right el bucle termina porque la condición left < right se vuelve falsa
            right = storeIdx - 1;
        }
    }

    // Al finalizar el bucle, los primeros k elementos del arreglo son los k puntos más cercanos al origen
    return Arrays.copyOfRange(points, 0, k);
}
```
