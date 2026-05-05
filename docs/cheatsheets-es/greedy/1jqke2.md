# Determining if You Can Reach the End of an Array — Determinar si se puede alcanzar el final de un arreglo

## Esencia del problema

Se recibe un arreglo de enteros `nums`. Cada elemento `nums[i]` representa la **longitud máxima** que se puede saltar hacia adelante desde ese índice. Se debe retornar un `boolean` que indique si es posible alcanzar el **último índice** del arreglo partiendo desde el índice `0`.

## Idea central

Si se actualiza continuamente "el punto más lejano alcanzable desde aquí" en cada posición, en el momento en que ese punto más lejano quede por detrás de la posición actual, se puede determinar que el final es inalcanzable. No es necesario rastrear cada ruta de salto individual; basta con un solo valor: "el índice más lejano alcanzable hasta ahora".

## Proceso de razonamiento

1. **La alcanzabilidad se determina por el punto más lejano**: Para determinar si el índice `i` es alcanzable, basta con verificar si el "índice más lejano alcanzable", calculado a partir de todos los elementos anteriores, es mayor o igual a `i`. Los detalles de la ruta intermedia son innecesarios; solo importa el punto más lejano
2. **El punto más lejano se puede gestionar con una sola variable**: En cada índice `i`, `i + nums[i]` representa el punto más lejano alcanzable desde esa posición. Si se compara con el punto más lejano anterior y se conserva el mayor de los dos, una sola variable permite rastrear el rango alcanzable completo
3. **Condición para determinar la inalcanzabilidad**: Al recorrer el arreglo de izquierda a derecha, si el índice actual `i` supera el punto más lejano `maxReach`, significa que el índice `i` no es alcanzable en primer lugar. Es decir, `i > maxReach` es la condición de inalcanzabilidad
4. **Condición de terminación temprana**: En el momento en que `maxReach` sea mayor o igual al último índice del arreglo `nums.length - 1`, se confirma que el final es alcanzable, por lo que se puede omitir el resto del recorrido y retornar `true`
5. **Cuando el recorrido se completa hasta el final**: Si el bucle termina sin retornar ni `false` ni `true` a mitad de camino, significa que todos los índices fueron alcanzables, por lo que se retorna `true`

## Conocimientos previos

### Qué es Math.max

Es un método estático que recibe dos enteros y retorna el mayor de los dos. Se utiliza para comparar "el punto más lejano actual" con "el nuevo punto alcanzable calculado" al actualizar el punto más lejano.

```java
Math.max(3, 5);    // Retorna 5 — el mayor de los dos argumentos
Math.max(7, 2);    // Retorna 7
Math.max(4, 4);    // Retorna 4 — si son iguales, retorna ese valor
```

### Qué es maxReach (índice más lejano alcanzable)

Es una variable que representa el índice más lejano alcanzable considerando todos los elementos desde el inicio del arreglo hasta la posición actual. Cuando se está en el índice `i`, `i + nums[i]` es el punto más lejano alcanzable desde esa posición, y con `maxReach = Math.max(maxReach, i + nums[i])` se conserva siempre el valor máximo.
Ejemplo: cuando `nums = [2, 3, 1, 1, 4]`, en `i=0` se obtiene `maxReach = 0 + 2 = 2`, y en `i=1` se obtiene `maxReach = max(2, 1 + 3) = 4`, lo que permite determinar que el último índice `4` es alcanzable.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita un único recorrido del arreglo |
| Space | O(1) — La única variable adicional es `maxReach` |

## Código

```java
// Entrada: arreglo de enteros nums (cada elemento es la longitud máxima de salto desde ese índice)
// Salida: retorna true si se puede alcanzar el último índice, false en caso contrario
boolean canJump(int[] nums) {
    // Variable que rastrea el índice más lejano alcanzable hasta ahora
    // El punto de inicio es el índice 0, por lo que el valor inicial es 0
    int maxReach = 0;

    // Se recorre el arreglo uno por uno desde el inicio hasta el final
    for (int i = 0; i < nums.length; i++) {
        // Si el índice actual supera el punto más lejano alcanzable, no se puede llegar aquí
        if (i > maxReach) return false;

        // i + nums[i] es el índice más lejano alcanzable desde la posición actual
        // Se compara con el maxReach anterior y se conserva el mayor de los dos
        maxReach = Math.max(maxReach,
            i + nums[i]);

        // Si el punto más lejano alcanzable es mayor o igual al último índice del arreglo, se confirma que el final es alcanzable
        if (maxReach >= nums.length - 1)
            return true;
    }
    // Si el bucle se completa hasta el final, todos los índices fueron alcanzables, por lo que se retorna true
    return true;
}
```
