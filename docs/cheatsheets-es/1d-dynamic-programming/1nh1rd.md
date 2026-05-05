# Finding the Longest Increasing Subsequence — Encontrar la longitud de la subsecuencia estrictamente creciente más larga

## Esencia del problema

Se recibe un arreglo de enteros `nums`. Se debe devolver la longitud de la **subsecuencia estrictamente creciente** más larga que se pueda formar eliminando elementos del arreglo original (sin cambiar el orden). La subsecuencia no necesita ser contigua, pero debe mantener el orden relativo dentro del arreglo original.

## Idea central

"Cuanto menor sea el último elemento de una subsecuencia creciente de longitud `k`, mayor será la posibilidad de extenderla con elementos posteriores". Si se gestiona el valor mínimo del último elemento para cada longitud en un arreglo `tails`, se puede determinar la posición de inserción de un nuevo elemento mediante búsqueda binaria en O(log n), y resolver el problema completo en O(n log n).

## Proceso de razonamiento

1. **Un último elemento menor es más ventajoso para extender la subsecuencia creciente**: Cuando existen varias subsecuencias crecientes de la misma longitud, la que tiene el último elemento más pequeño posee el rango más amplio de valores que se pueden agregar a continuación. Por lo tanto, basta con registrar solo el valor mínimo del último elemento para cada longitud
2. **Gestionar los valores mínimos de los últimos elementos con el arreglo tails**: Se prepara un arreglo `tails` donde `tails[i]` almacena el valor mínimo del último elemento que puede tener una subsecuencia creciente de longitud `i+1`. Este arreglo siempre se mantiene ordenado (porque cuanto más larga es la subsecuencia, mayor es su último elemento)
3. **El procesamiento de un nuevo elemento se divide en 2 patrones**: Para cada elemento `num` del arreglo, se busca mediante búsqueda binaria el menor elemento en `tails` que sea mayor o igual a `num`. Si la posición encontrada supera el final de `tails`, significa que `num` es mayor que la subsecuencia más larga existente, por lo que se agrega al final de `tails`. Si no supera el final, se reemplaza el valor en esa posición por `num` para actualizar el valor mínimo del último elemento
4. **Razón por la que se puede usar búsqueda binaria**: Como el arreglo `tails` siempre está ordenado, se puede determinar la posición de inserción de `num` en O(log n) mediante `Collections.binarySearch`. Esto hace que el procesamiento de cada elemento sea O(log n), logrando O(n log n) en total
5. **La longitud del arreglo tails es la respuesta**: En el procesamiento de cada elemento, `tails` recibe una adición o un reemplazo. Una adición significa que la longitud de la subsecuencia más larga aumentó en 1. El valor de `tails.size()` al terminar de procesar todos los elementos es la longitud de la subsecuencia creciente más larga

## Conocimientos previos

### Qué es ArrayList

Es un arreglo de longitud variable. Permite agregar, obtener y actualizar elementos en O(1). A diferencia de los arreglos normales, no es necesario definir el tamaño de antemano.

```java
List<Integer> list = new ArrayList<>();  // Crear un ArrayList vacío
list.add(10);          // Agregar 10 al final → [10]
list.add(20);          // Agregar 20 al final → [10, 20]
list.get(0);           // Obtener el elemento en el índice 0 → 10
list.set(0, 5);        // Reemplazar el elemento en el índice 0 por 5 → [5, 20]
list.size();           // Devolver la cantidad de elementos → 2
```

### Qué es Collections.binarySearch

Es un método que realiza una búsqueda binaria en una lista ordenada y devuelve la posición del valor especificado. Si el valor se encuentra, devuelve su índice. Si no se encuentra, devuelve un valor negativo de la forma `-(posición de inserción) - 1`. La posición de inserción es la posición donde se podría insertar el valor manteniendo el orden de la lista.

```java
List<Integer> list = Arrays.asList(2, 5, 8, 12);
Collections.binarySearch(list, 5);   // 5 está en el índice 1 → devuelve 1
Collections.binarySearch(list, 6);   // 6 no existe. La posición de inserción es 2 → -(2)-1 = devuelve -3
Collections.binarySearch(list, 1);   // 1 no existe. La posición de inserción es 0 → -(0)-1 = devuelve -1
Collections.binarySearch(list, 15);  // 15 no existe. La posición de inserción es 4 → -(4)-1 = devuelve -5
```

Para recuperar la posición de inserción a partir de un valor de retorno negativo, se calcula `-(valor de retorno + 1)`. Ejemplo: si el valor de retorno es -3, entonces `-(-3 + 1) = 2` es la posición de inserción.

### Concepto del arreglo tails

`tails` es un arreglo que registra el valor mínimo del último elemento de las subsecuencias crecientes para cada longitud. `tails[i]` significa "el valor mínimo del último elemento que puede tener una subsecuencia creciente de longitud `i+1`". Este arreglo siempre se mantiene ordenado en orden ascendente.

Ejemplo: proceso de procesar nums = [3, 1, 4, 1, 5]:
- Procesar 3 → tails = [3] (el valor mínimo del último elemento de una subsecuencia de longitud 1 es 3)
- Procesar 1 → tails = [1] (se actualiza el valor mínimo del último elemento de longitud 1 a 1. 1 es menor que 3, por lo que es más ventajoso)
- Procesar 4 → tails = [1, 4] (4 es mayor que 1, por lo que se agrega al final. Se formó una subsecuencia de longitud 2)
- Procesar 1 → tails = [1, 4] (la posición de inserción de 1 es el índice 0, y ya es 1, por lo que no hay cambio)
- Procesar 5 → tails = [1, 4, 5] (5 es mayor que 4, por lo que se agrega al final. Se formó una subsecuencia de longitud 3)

El valor final de `tails.size()` = 3 es la respuesta.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n log n) — Se realiza una búsqueda binaria de O(log n) para cada uno de los n elementos |
| Space | O(n) — El arreglo tails almacena como máximo n elementos |

## Código

```java
// Entrada: arreglo de enteros nums
// Salida: devuelve la longitud de la subsecuencia estrictamente creciente más larga como int
public int lengthOfLIS(int[] nums) {
    // Arreglo que mantiene en orden ascendente los valores mínimos del último elemento de las subsecuencias crecientes para cada longitud
    // tails[i] significa "el valor mínimo del último elemento que puede tener una subsecuencia creciente de longitud i+1"
    List<Integer> tails = new ArrayList<>();

    // Recorrer cada elemento del arreglo nums desde el inicio hasta el final, uno por uno
    for (int num : nums) {
        // Buscar mediante búsqueda binaria la posición donde num debe insertarse en el arreglo tails
        // Se puede usar búsqueda binaria porque tails siempre está ordenado
        int pos = Collections.binarySearch(tails, num);

        // Un valor negativo significa "no se encontró", por lo que se convierte a la posición de inserción
        // Si pos es 0 o mayor, significa que ya existe un valor igual a num en tails[pos], por lo que se usa tal cual
        if (pos < 0)
            pos = -(pos + 1);

        if (pos == tails.size()) {
            // num es mayor que todos los elementos de tails, por lo que se agrega al final
            // Esto significa que la longitud de la subsecuencia creciente más larga aumentó en 1
            tails.add(num);
        } else {
            // Se reemplaza y actualiza el valor mínimo del último elemento en la posición correspondiente por num
            // Con esto, el valor mínimo del último elemento de la subsecuencia creciente de longitud pos+1 se hace más pequeño,
            // lo que amplía la posibilidad de extender la subsecuencia en el futuro
            tails.set(pos, num);
        }
    }

    // La cantidad de elementos de tails coincide con el número de veces que se realizaron adiciones al final durante el procesamiento,
    // y esta es la longitud de la subsecuencia creciente más larga
    return tails.size();
}
```
