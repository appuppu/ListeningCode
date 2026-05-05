# Finding the Median of Two Sorted Arrays — Encontrar la mediana al fusionar dos arrays ordenados

## Esencia del problema

Se proporcionan dos arrays de enteros ordenados `n1` y `n2`. Se debe encontrar la **mediana** cuando se fusionan ambos arrays. La solución debe ejecutarse en tiempo logarítmico respecto al número total de elementos.

## Idea central

Encontrar la mediana de dos arrays ordenados equivale a encontrar el límite que divide correctamente los elementos en una "mitad izquierda" y una "mitad derecha". Al realizar una búsqueda binaria sobre el array más corto para determinar la posición de corte, la posición de corte del otro array se determina automáticamente.

## Proceso de razonamiento

1. **La mediana se determina por "el máximo de la mitad izquierda" y "el mínimo de la mitad derecha"**: Si se puede dividir el array fusionado en dos mitades iguales manteniendo el orden, la mediana es el máximo de la mitad izquierda (si el total es impar) o el promedio entre el máximo de la mitad izquierda y el mínimo de la mitad derecha (si el total es par). Es decir, no es necesario ordenar todos los elementos; basta con encontrar la posición de corte correcta
2. **Al determinar la posición de corte en un array, la del otro se determina automáticamente**: Si se decide colocar un total de `half = (m + n + 1) / 2` elementos en la mitad izquierda, al tomar `cut1` elementos del array `n1`, se necesitan `cut2 = half - cut1` elementos del array `n2`. Es decir, solo se necesita buscar `cut1`
3. **La corrección del corte se verifica mediante "comparación cruzada"**: Un corte correcto significa que todos los elementos de la mitad izquierda son menores o iguales que todos los elementos de la mitad derecha. Como cada array ya está ordenado, solo es necesario verificar las partes que se cruzan. Concretamente, el corte es correcto si se cumple que el último elemento de la parte izquierda de `n1` (`l1`) ≤ el primer elemento de la parte derecha de `n2` (`r2`), y el último elemento de la parte izquierda de `n2` (`l2`) ≤ el primer elemento de la parte derecha de `n1` (`r1`)
4. **Se busca `cut1` eficientemente mediante búsqueda binaria**: El rango de `cut1` va de `0` a `m`. Si `l1 > r2`, se están tomando demasiados elementos de `n1`, por lo que se reduce `cut1`. Si `l2 > r1`, se están tomando muy pocos elementos de `n1`, por lo que se aumenta `cut1`. Esta lógica permite aplicar la búsqueda binaria
5. **Razón para buscar en el array más corto**: Como el rango de la búsqueda binaria va de `0` a `m` (longitud del array), elegir el array más corto reduce el rango de búsqueda y la complejidad resulta `O(log(min(m, n)))`
6. **Se usan valores centinela para el manejo de límites**: Cuando `cut1 = 0` (no se toma ningún elemento de `n1`) o `cut1 = m` (se toman todos los elementos de `n1`), se accedería a elementos inexistentes. Usando `Integer.MIN_VALUE` e `Integer.MAX_VALUE` como valores centinela, las condiciones de comparación funcionan correctamente en todos los casos

## Conocimientos previos

### Qué es la mediana (Median)

Es el valor que se encuentra en la posición central de una secuencia ordenada. Si el número de elementos es impar, es el único elemento central; si es par, se toma el promedio de los dos elementos centrales.

```java
// Impar: [1, 3, 5] → La mediana es 3
// Par: [1, 3, 5, 7] → La mediana es (3 + 5) / 2.0 = 4.0
```

### Qué es la búsqueda binaria (Binary Search)

Es una técnica que encuentra un valor objetivo en O(log n) reduciendo el rango de búsqueda a la mitad en cada iteración sobre datos ordenados. Se gestiona el rango de búsqueda con `lo` y `hi`, y se reduce el rango basándose en el valor central.

```java
int lo = 0, hi = n;
while (lo <= hi) {
    int mid = (lo + hi) / 2;       // Calcular el centro del rango de búsqueda
    if (条件を満たす) { /* respuesta */ }
    else if (midが大きすぎる) { hi = mid - 1; }  // Reducir a la mitad izquierda
    else { lo = mid + 1; }                        // Reducir a la mitad derecha
}
```

### Qué es un valor centinela (Sentinel Value)

Es un valor especial que se usa para evitar accesos fuera de los límites del array. Al utilizar `Integer.MIN_VALUE` (valor mínimo de entero) e `Integer.MAX_VALUE` (valor máximo de entero), se garantiza que las condiciones de comparación no fallen en los casos límite.

```java
Integer.MIN_VALUE;  // -2147483648 — Se usa como un valor menor que cualquier elemento
Integer.MAX_VALUE;  //  2147483647 — Se usa como un valor mayor que cualquier elemento
```

## Complejidad

| | Valor |
|---|---|
| Time | O(log(min(m, n))) — Se realiza una búsqueda binaria sobre el array más corto |
| Space | O(1) — Solo se utilizan variables, sin crear estructuras de datos adicionales |

## Código

```java
// Entrada: dos arrays de enteros ordenados n1 y n2
// Salida: la mediana al fusionar ambos arrays, devuelta como double
public double findMedian(int[] n1, int[] n2) {
    // Para realizar la búsqueda binaria en el array más corto, si n1 es más largo se intercambian y se hace una llamada recursiva
    // Esto minimiza el rango de búsqueda y logra O(log(min(m, n)))
    if (n1.length > n2.length)
        return findMedian(n2, n1);

    int m = n1.length, n = n2.length;
    // Número de elementos en la mitad izquierda. Al sumar +1, cuando el total es impar la mitad izquierda tiene un elemento más,
    // y el máximo de la mitad izquierda se convierte directamente en la mediana
    int half = (m + n + 1) / 2;
    // Rango de búsqueda de cut1: 0 (no tomar ninguno de n1) a m (tomar todos de n1)
    int lo = 0, hi = m;

    while (lo <= hi) {
        // Determinar la cantidad de elementos de n1 en la mitad izquierda usando el punto medio de la búsqueda binaria
        int cut1 = (lo + hi) / 2;
        // Cantidad de elementos de n2 en la mitad izquierda (se determina automáticamente para que el total de la mitad izquierda sea half)
        int cut2 = half - cut1;

        // Último elemento de la mitad izquierda de n1 (si cut1=0 la mitad izquierda está vacía,
        // se usa un valor centinela menor que cualquier elemento para que la condición de comparación siempre se cumpla)
        int l1 = cut1 == 0 ?
            Integer.MIN_VALUE :
            n1[cut1 - 1];
        // Último elemento de la mitad izquierda de n2 (si cut2=0 la mitad izquierda está vacía, se usa un valor centinela)
        int l2 = cut2 == 0 ?
            Integer.MIN_VALUE :
            n2[cut2 - 1];
        // Primer elemento de la mitad derecha de n1 (si cut1=m la mitad derecha está vacía,
        // se usa un valor centinela mayor que cualquier elemento para que la condición de comparación siempre se cumpla)
        int r1 = cut1 == m ?
            Integer.MAX_VALUE :
            n1[cut1];
        // Primer elemento de la mitad derecha de n2 (si cut2=n la mitad derecha está vacía, se usa un valor centinela)
        int r2 = cut2 == n ?
            Integer.MAX_VALUE :
            n2[cut2];

        // Comparación cruzada: si todos los elementos de la mitad izquierda ≤ todos los de la mitad derecha, el corte es correcto
        if (l1 <= r2 && l2 <= r1) {
            // Se encontró el corte correcto
            if ((m + n) % 2 == 1)
                // Impar: el máximo de la mitad izquierda es directamente la mediana
                return Math.max(l1, l2);
            // Par: la mediana es el promedio entre el máximo de la mitad izquierda y el mínimo de la mitad derecha
            return (Math.max(l1, l2)
                + Math.min(r1, r2))
                / 2.0;
        } else if (l1 > r2) {
            // El último elemento de la mitad izquierda de n1 supera al primero de la mitad derecha de n2 → se tomaron demasiados de n1 → reducir cut1
            hi = cut1 - 1;
        } else {
            // l2 > r1: se tomaron muy pocos de n1 → aumentar cut1
            lo = cut1 + 1;
        }
    }
    // Según las restricciones del problema, siempre se encuentra un corte correcto, por lo que este punto nunca se alcanza
    return -1;
}
```
