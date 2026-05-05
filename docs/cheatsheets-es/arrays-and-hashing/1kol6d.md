# Two Sum — Encontrar el par de dos números cuya suma sea igual al objetivo

## Esencia del problema

Se recibe un arreglo de enteros `nums` y un entero `target`. Se deben encontrar dos elementos en `nums` cuya suma sea igual a `target` y devolver sus **índices** en un arreglo. La solución siempre es única y no se puede usar el mismo elemento dos veces.

## Idea central

Al recorrer el arreglo, para cada elemento `nums[i]` el "complemento (target - nums[i])" se determina de forma única. Si se registran los elementos ya visitados en un HashMap, se puede verificar en O(1) si el complemento existe, y la respuesta se encuentra en un solo recorrido.

## Proceso de razonamiento

1. **El complemento se obtiene por cálculo**: Como se busca un par cuya suma sea `target`, para el elemento actual `nums[i]` el otro valor se determina de forma única como `complement = target - nums[i]`
2. **Se necesita verificar rápidamente si el complemento ya apareció**: Si se registran los números ya vistos mientras se recorre el arreglo, se puede verificar en O(1) si el complemento ya fue registrado. Un HashMap es adecuado para este registro
3. **Qué se almacena en el HashMap**: Como el problema requiere devolver índices, se almacena el "número" como clave y el "índice de ese número" como valor en el HashMap. De esta manera, se puede verificar la existencia del complemento y obtener su índice simultáneamente
4. **Se construye el HashMap mientras se recorre**: Se recorre el arreglo desde el inicio y para cada elemento se verifica si "el complemento existe en el HashMap". Si existe, se encontró el par; si no, se registra el elemento actual en el HashMap y se continúa
5. **El registro se realiza después de la verificación**: Si se registra en el HashMap antes de verificar, `nums[i]` podría coincidir consigo mismo como complemento. Por eso se debe respetar el orden: primero verificar, luego registrar
6. **Lo que se devuelve al final**: Cuando se encuentra el complemento en el HashMap, se devuelven `map.get(complement)` (el índice del complemento) e `i` (el índice actual) en un `int[]`

## Conocimientos previos

### Qué es un HashMap

Es una estructura de datos que almacena pares de clave y valor. Permite buscar y obtener valores especificando la clave en O(1). Es como un diccionario que permite acceder con cualquier clave a la misma velocidad que el acceso por índice en un arreglo.

```java
HashMap<Integer, Integer> map = new HashMap<>();  // Crear un HashMap vacío
map.put(10, 0);           // Almacenar el valor 0 con la clave 10
map.containsKey(10);      // Devolver un boolean indicando si la clave 10 existe → true
map.get(10);              // Devolver el valor correspondiente a la clave 10 → 0
```

### Qué es el complement (complemento)

Es el valor que resulta de restar el elemento actual a `target`. Es el número que corresponde al otro elemento del par. Se calcula como `complement = target - nums[i]`.
Ejemplo: cuando target=9 y nums[i]=2, complement=7. Si el número 7 existe en el arreglo, el par se completa.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita un recorrido del arreglo |
| Space | O(n) — Se almacenan como máximo n elementos en el HashMap |

## Código

```java
// Entrada: arreglo de enteros nums y un entero target
// Salida: devolver en un int[] los índices de los dos elementos cuya suma sea target
public int[] twoSum(int[] nums, int target) {
    // HashMap que almacena clave=número, valor=índice de ese número
    // Como el problema pide índices y no valores, se almacena el índice como valor
    HashMap<Integer, Integer> map = new HashMap<>();

    for (int i = 0; i < nums.length; i++) {
        // Calcular el complemento del par y almacenarlo en una variable para reutilizarlo en containsKey y get
        int complement = target - nums[i];

        // Si el complemento ya está registrado en el HashMap, se encontró el par
        if (map.containsKey(complement)) {
            // map.get(complement) es el índice del complemento, i es el índice actual
            return new int[]{map.get(complement), i};
        }

        // Nota: el registro se realiza después de la verificación. Si se registra antes, nums[i] coincidiría consigo mismo
        map.put(nums[i], i);
    }
    // Según las restricciones del problema, la solución siempre existe, por lo que nunca se llega aquí
    return new int[]{};
}
```
