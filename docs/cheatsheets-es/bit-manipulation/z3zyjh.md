# Finding the Number That Appears Only Once — Encontrar el elemento que aparece solo una vez en un arreglo

## Esencia del problema

Se recibe un arreglo de enteros `nums`. Todos los elementos del arreglo aparecen exactamente 2 veces, excepto un único elemento que aparece solo 1 vez. Se debe devolver **el elemento que aparece solo una vez**.

## Idea central

La operación XOR tiene la propiedad de que "aplicar XOR dos veces con el mismo valor produce 0". Al aplicar XOR a todos los elementos del arreglo, los elementos que aparecen 2 veces se cancelan entre sí y se convierten en 0, quedando únicamente el elemento que aparece solo una vez.

## Proceso de razonamiento

1. **Si se eliminan los pares duplicados, queda la respuesta**: Si se eliminan todos los elementos que aparecen 2 veces en el arreglo, se obtiene el elemento que aparece solo 1 vez. Se busca una operación que realice esta "eliminación de pares" de forma eficiente
2. **Se utiliza la propiedad de autoinversión del XOR**: La operación XOR tiene la propiedad `a ^ a = 0`. Al aplicar XOR dos veces con el mismo valor, el resultado es 0. Es decir, los elementos que aparecen 2 veces se eliminan automáticamente
3. **Se utiliza el elemento neutro y las leyes asociativa y conmutativa del XOR**: `a ^ 0 = a` (el XOR con 0 no cambia el valor) y el XOR cumple las leyes asociativa y conmutativa. Por lo tanto, independientemente del orden de aparición de los elementos, al aplicar XOR a todos los elementos los pares desaparecen y solo queda el elemento único
4. **Se calcula el XOR acumulado con una sola variable**: Se inicializa la variable `result` en 0 y se recorre el arreglo aplicando XOR con cada elemento. Al finalizar el recorrido, el valor que permanece en `result` es la respuesta
5. **No se necesitan estructuras de datos adicionales**: Como se resuelve con una sola variable entera sin usar HashSet ni HashMap, la complejidad espacial es O(1)

## Conocimientos previos

### ¿Qué es XOR (OR exclusivo)?

Es una operación a nivel de bits que devuelve 1 cuando los dos bits son diferentes y 0 cuando son iguales. En Java se representa con el operador `^`. Al aplicarlo a enteros, el XOR se ejecuta en cada posición de bit individualmente.

```java
int a = 5;          // binario: 101
int b = 3;          // binario: 011
int c = a ^ b;      // binario: 110 → 6
```

### Propiedades importantes del XOR

La operación XOR tiene las siguientes 3 propiedades, y todas son necesarias para resolver este problema.

```java
// 1. Autoinversión: aplicar XOR dos veces con el mismo valor produce 0
a ^ a;    // → 0

// 2. Elemento neutro: el XOR con 0 no cambia el valor original
a ^ 0;    // → a

// 3. Leyes conmutativa y asociativa: el resultado es el mismo sin importar el orden
a ^ b ^ a;    // → (a ^ a) ^ b → 0 ^ b → b
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita recorrer el arreglo una vez |
| Space | O(1) — No se usan estructuras de datos adicionales, solo una variable entera |

## Código

```java
// Entrada: arreglo de enteros nums (todos los elementos aparecen 2 veces, y solo un elemento aparece 1 vez)
// Salida: se devuelve como int el elemento que aparece solo una vez
public int singleNumber(int[] nums) {
    // Valor inicial del XOR acumulado. 0 es el elemento neutro del XOR, por lo que al aplicar XOR con cualquier valor no lo modifica
    int result = 0;

    // El bucle for-each recorre cada elemento del arreglo desde el inicio hasta el final uno por uno
    for (int num : nums) {
        // Se calcula el XOR entre el result actual y num, y se asigna a result
        // Los elementos que aparecen 2 veces se cancelan por a ^ a = 0, y solo se acumula el elemento que aparece una vez
        result ^= num;
    }

    // Al finalizar el bucle, como resultado de la cancelación de todos los pares, solo queda el valor del elemento que aparece una vez
    return result;
}
```
