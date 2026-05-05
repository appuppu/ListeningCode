# Counting Ways to Assign Signs to Reach a Target Sum — Contar el número de formas de asignar signos para alcanzar una suma objetivo

## Esencia del problema

Se recibe un arreglo de enteros `nums` y un entero `target`. Se debe asignar un signo `+` o `-` a cada elemento de `nums` y devolver cuántas combinaciones hacen que la suma total de todos los elementos sea igual a `target`.

## Idea central

El problema de asignar `+` o `-` a cada elemento es equivalente a dividir el arreglo en un "grupo de signos positivos (P)" y un "grupo de signos negativos (N)". Dado que P - N = target y P + N = totalSum, se deduce que P = (target + totalSum) / 2, por lo que el problema se transforma en un problema de suma de subconjuntos: "contar el número de subconjuntos cuya suma sea P".

## Proceso de razonamiento

1. **Interpretar la asignación de signos como una partición de conjuntos**: Si se define P como la suma de los elementos con signo `+` y N como la suma de los elementos con signo `-`, se cumple que P - N = target. Al mismo tiempo, se cumple que P + N = totalSum (la suma de todos los elementos). Al resolver este sistema de dos ecuaciones, se obtiene P = (target + totalSum) / 2
2. **Descartar primero las condiciones en las que no existe solución**: Si P = (target + totalSum) / 2 no es un número entero (es decir, si `(target + totalSum)` es impar), no existe una partición válida. Tampoco existe solución si `|target|` supera a `totalSum`. Se verifican estas condiciones al inicio y se devuelve 0
3. **Resolver como un problema de suma de subconjuntos con DP**: "El número de combinaciones en las que se seleccionan elementos del arreglo `nums` y su suma es `subsetSum` (= P)" es un problema clásico de conteo de sumas de subconjuntos. Se define el arreglo DP `dp[j]` como "el número de subconjuntos cuya suma es j" y se actualiza para cada elemento
4. **Optimizar el espacio con un arreglo DP unidimensional**: En lugar de usar una tabla bidimensional, se prepara un arreglo unidimensional `dp[0..subsetSum]` y, para cada elemento `num`, se recorre `j` en orden inverso desde `subsetSum` hasta `num`, actualizando `dp[j] += dp[j - num]`. La razón de recorrer en orden inverso es evitar que se use el mismo elemento más de una vez
5. **Establecer la condición inicial**: Se establece `dp[0] = 1`. Esto significa que "existe exactamente 1 forma de obtener una suma de 0 sin seleccionar ningún elemento"
6. **Valor que se devuelve al final**: `dp[subsetSum]` después de procesar todos los elementos es el número de subconjuntos cuya suma es `subsetSum`, es decir, la respuesta al problema original

## Conocimientos previos

### ¿Qué es el problema de suma de subconjuntos (Subset Sum Problem)?

Es un problema en el que se seleccionan elementos de un conjunto dado y se buscan las combinaciones cuya suma sea igual a un valor específico. Es una variante del problema de la mochila y se puede resolver eficientemente con DP.

### Conteo de sumas de subconjuntos con un arreglo DP unidimensional

`dp[j]` representa "el número de subconjuntos cuya suma es j". Para cada elemento `num`, se actualiza mediante `dp[j] += dp[j - num]`.

```java
int[] dp = new int[targetSum + 1]; // dp[j] = número de combinaciones cuya suma es j
dp[0] = 1;                         // Existe 1 forma de obtener una suma de 0 (no seleccionar nada)
dp[j] += dp[j - num];              // Usar num para obtener j = sumar el número de formas de obtener j-num sin usar num
```

### Razón del bucle en orden inverso

El bucle interno se recorre en orden inverso desde `subsetSum` hasta `num`. Si se recorriera en orden directo, se sumaría el mismo elemento `num` varias veces dentro de la misma iteración. Al recorrer en orden inverso, se cumple la restricción de mochila 0-1, en la que cada elemento se "selecciona o no se selecciona".

```java
// Bucle en orden inverso: cada elemento se usa como máximo 1 vez (mochila 0-1)
for (int j = subsetSum; j >= num; j--) {
    dp[j] += dp[j - num];
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n × subsetSum) — Se recorre el arreglo DP una vez por cada elemento |
| Space | O(subsetSum) — Solo se utiliza un arreglo DP unidimensional |

## Código

```java
// Entrada: un arreglo de enteros nums y un entero target
// Salida: devuelve como int el número de combinaciones en las que se asigna +/- a cada elemento y la suma es igual a target
public int findTargetSumWays(int[] nums, int target) {
    // Calcular la suma de todos los elementos del arreglo nums y asignarla a la variable totalSum
    int totalSum = 0;
    for (int num : nums) {
        totalSum += num;
    }

    // Verificar las condiciones en las que no existe solución
    // Si (target + totalSum) es impar, P = (target + totalSum) / 2 no es un entero,
    // por lo que no se puede lograr con un subconjunto compuesto por un número entero de elementos, y se devuelve 0
    // Si |target| supera a totalSum, no se puede alcanzar target sin importar cómo se asignen los signos, y se devuelve 0
    if ((target + totalSum) % 2 != 0
        || Math.abs(target) > totalSum)
        return 0;

    // Calcular la suma total del grupo con signo +. Este valor se convierte en el objetivo a alcanzar en el procesamiento posterior
    int subsetSum = (target + totalSum) / 2;

    // dp[j] = número de combinaciones en las que se seleccionan elementos de nums y su suma es j
    int[] dp = new int[subsetSum + 1];
    // Caso base: existe exactamente 1 forma de obtener una suma de 0 sin seleccionar ningún elemento
    dp[0] = 1;

    // Bucle externo: recorrer cada elemento del arreglo nums desde el inicio hasta el final
    for (int num : nums) {
        // Bucle interno: recorrer en orden inverso desde subsetSum hasta num
        // Razón del orden inverso: evitar que se use el mismo num varias veces dentro de la misma iteración (restricción de mochila 0-1)
        for (int j = subsetSum; j >= num; j--) {
            // Sumar al número de formas de obtener una suma j usando num, el número de formas de obtener una suma j - num sin usar num
            dp[j] += dp[j - num];
        }
    }

    // dp[subsetSum] es el número de subconjuntos cuya suma es subsetSum, es decir, el número total de formas de asignar signos en el problema original
    return dp[subsetSum];
}
```
