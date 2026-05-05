# Finding the Minimum Cost to Climb Stairs — Encontrar el costo mínimo para llegar a la cima de la escalera

## Esencia del problema

Se da un arreglo de enteros `cost`, donde `cost[i]` representa el costo de pisar el escalón i. Se puede comenzar desde el escalón 0 o el escalón 1, y en cada paso se puede subir 1 o 2 escalones. El objetivo es devolver el costo total mínimo para llegar a la **cima** de la escalera (una posición más allá del final del arreglo).

## Idea central

El costo mínimo para llegar a cada escalón se determina por el menor entre "venir desde un escalón antes" y "venir desde dos escalones antes". Como este cálculo solo necesita los dos resultados inmediatamente anteriores, se puede obtener el costo mínimo con solo 2 variables en lugar de un arreglo completo.

## Proceso de razonamiento

1. **Hay 2 formas de llegar a la cima**: A la cima (índice n) se puede llegar subiendo 1 escalón desde el escalón anterior (n-1), o subiendo 2 escalones desde dos escalones antes (n-2). La respuesta es el menor de los dos costos
2. **El costo mínimo para cada escalón se puede definir recursivamente**: Si se define `dp[i]` como el costo mínimo para llegar al escalón i, se cumple la recurrencia `dp[i] = min(dp[i-1] + cost[i-1], dp[i-2] + cost[i-2])`. Es el menor entre "el costo mínimo del escalón anterior + el costo de ese escalón" y "el costo mínimo de dos escalones antes + el costo de ese escalón"
3. **Establecer las condiciones iniciales**: Como se puede comenzar desde el escalón 0 o el escalón 1, el costo de llegar a ambos escalones es 0. Es decir, `dp[0] = 0`, `dp[1] = 0`
4. **No se necesita el arreglo completo, solo los dos valores anteriores**: La recurrencia `dp[i]` depende únicamente de `dp[i-1]` y `dp[i-2]`. Por lo tanto, en lugar de un arreglo, basta con mantener solo 2 variables: `prev1` (uno antes) y `prev2` (dos antes)
5. **Avanzar actualizando las variables**: Se itera desde el escalón 2 hasta el escalón n, calculando `curr` en cada paso y luego deslizando con `prev2 = prev1`, `prev1 = curr`. Al finalizar el bucle, `prev1` contiene el costo mínimo para llegar a la cima

## Conocimientos previos

### ¿Qué es la Programación Dinámica (Dynamic Programming)?

Es una técnica que divide un problema grande en subproblemas más pequeños y reutiliza los resultados de los subproblemas para obtener la solución de forma eficiente. En este problema, se define "el costo mínimo para llegar al escalón i" como subproblema y se resuelve desde los índices menores hacia los mayores (enfoque bottom-up).

### ¿Qué es Math.min?

Es un método estándar de Java que devuelve el menor de dos enteros. Se utiliza para elegir la opción con menor costo entre dos alternativas.

```java
Math.min(5, 3);    // Devuelve 3 — devuelve el menor de los dos argumentos
Math.min(10, 10);  // Devuelve 10 — si ambos valores son iguales, devuelve ese valor
```

### Concepto de optimización de espacio

Cuando cada elemento del arreglo DP depende solo de unos pocos elementos inmediatamente anteriores, se puede realizar el cálculo con solo las variables necesarias en lugar de mantener el arreglo completo. En este problema, solo se necesitan `dp[i-1]` y `dp[i-2]`, por lo que 2 variables son suficientes.

```java
int prev2 = 0;  // Variable equivalente a dp[i-2]
int prev1 = 0;  // Variable equivalente a dp[i-1]
int curr;       // Variable equivalente a dp[i] (se calcula y actualiza en cada iteración)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita recorrer el arreglo una vez |
| Space | O(1) — Solo se usan 2 variables, sin depender del tamaño del arreglo |

## Código

```java
// Entrada: arreglo de enteros cost (costo de pisar cada escalón)
// Salida: devuelve como int el costo total mínimo para llegar a la cima de la escalera (índice n)
public int minCostClimbingStairs(int[] cost) {
    // Obtener la longitud del arreglo. La cima está en la posición de índice n (una posición más allá del final del arreglo)
    int n = cost.length;

    // prev2=costo mínimo para llegar al escalón de dos antes, prev1=costo mínimo para llegar al escalón anterior
    // Como se puede comenzar desde el escalón 0 o el escalón 1, el costo inicial es 0
    int prev2 = 0, prev1 = 0;

    // Calcular el costo mínimo en orden desde el escalón 2 hasta la cima (escalón n). i es el escalón al que se intenta llegar actualmente
    for (int i = 2; i <= n; i++) {
        // prev1 + cost[i-1]: costo total de subir 1 escalón desde el escalón anterior
        // prev2 + cost[i-2]: costo total de subir 2 escalones desde dos escalones antes
        // Se elige el menor de los dos
        int curr = Math.min(
            prev1 + cost[i - 1],
            prev2 + cost[i - 2]);

        // Deslizar las variables una posición hacia adelante
        // Nota: se debe actualizar prev2 primero, de lo contrario se pierde el valor original de prev1
        prev2 = prev1;
        prev1 = curr;
    }

    // prev1 contiene el costo mínimo para llegar a la cima, calculado en la última iteración del bucle (i = n)
    return prev1;
}
```
