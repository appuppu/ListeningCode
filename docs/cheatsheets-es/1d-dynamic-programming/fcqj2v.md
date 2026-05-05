# Finding the Fewest Coins to Make a Target Amount — Encontrar la cantidad mínima de monedas para alcanzar un monto objetivo

## Esencia del problema

Se recibe un arreglo `coins` que contiene las denominaciones de las monedas y un monto objetivo `amount`. Se pueden usar tantas monedas como se desee de `coins` para formar combinaciones que sumen `amount`, y se debe devolver la **cantidad mínima de monedas**. Si no es posible formar `amount` con ninguna combinación, se devuelve `-1`.

## Idea central

Si se calcula de forma ascendente "la cantidad mínima de monedas necesaria para formar cada monto" desde el monto 0 hasta el monto objetivo, la cantidad mínima para el monto `i` se obtiene como el valor mínimo entre "`la cantidad mínima para el monto i menos cada denominación de moneda` + 1".

## Proceso de razonamiento

1. **Se puede descomponer en subproblemas**: Si la última moneda usada para formar el monto `i` es la moneda `c`, y se conoce la cantidad mínima para formar el monto restante `i - c`, entonces la cantidad mínima para el monto `i` se obtiene con `dp[i - c] + 1`. Esta estructura es adecuada para la programación dinámica
2. **No se sabe de antemano cuál moneda es la última**: Los candidatos para la última moneda son todas las denominaciones disponibles. Por lo tanto, se calcula `dp[i - c] + 1` para cada moneda `c` y se asigna el valor mínimo a `dp[i]`. Esta es la ecuación de transición `dp[i] = min(dp[i - c] + 1)` for each coin `c`
3. **Definir el caso base**: Se necesitan 0 monedas para formar el monto 0, por lo que se establece `dp[0] = 0`. Este es el punto de partida del cálculo ascendente
4. **Establecer un valor inicial que represente "inalcanzable"**: Como no se sabe de antemano si cada monto es alcanzable, se inicializan todos los elementos del arreglo `dp` con `amount + 1` (una cantidad imposiblemente grande). Los montos cuyo valor no se actualice significan que "no se pueden formar"
5. **Rellenar desde el monto 1 en orden ascendente**: Partiendo de `dp[0]`, se rellena la tabla en orden: monto 1, 2, ..., `amount`. Al momento de calcular el monto `i`, la cantidad mínima para todos los montos menores que `i` ya está determinada, por lo que se puede consultar `dp[i - c]` de forma segura
6. **Qué se devuelve al final**: Si `dp[amount]` permanece con el valor `amount + 1`, el monto objetivo no se puede formar y se devuelve `-1`. En caso contrario, `dp[amount]` es la cantidad mínima de monedas

## Conocimientos previos

### ¿Qué es la programación dinámica (Dynamic Programming)?

Es una técnica que descompone un problema grande en subproblemas más pequeños y construye la solución de forma ascendente mientras registra la solución de cada subproblema en una tabla. Al evitar resolver los mismos subproblemas repetidamente, se logra una alta eficiencia computacional.

```java
// Patrón básico de DP ascendente
int[] dp = new int[n + 1];     // Crear la tabla
dp[0] = baseCase;              // Establecer el caso base
for (int i = 1; i <= n; i++) { // Resolver desde los subproblemas más pequeños en orden
    dp[i] = /* Calcular usando resultados anteriores como dp[i-1] */;
}
return dp[n];                  // Devolver la respuesta final
```

### ¿Qué es Arrays.fill?

Es un método estándar de Java que llena todos los elementos de un arreglo con un valor especificado. Se usa frecuentemente para inicializar arreglos de DP.

```java
int[] dp = new int[5];       // Se crea [0, 0, 0, 0, 0]
Arrays.fill(dp, 100);        // Se llenan todos los elementos con 100 → [100, 100, 100, 100, 100]
```

### ¿Qué es Math.min?

Es un método estándar de Java que devuelve el menor de dos enteros. Se usa para seleccionar el valor mínimo entre varios candidatos.

```java
Math.min(3, 7);    // → 3
Math.min(dp[i], dp[i - coin] + 1);  // Seleccionar el menor entre el valor actual y el nuevo candidato
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(amount × n) — Se recorren n tipos de monedas por cada monto (n es la longitud del arreglo coins) |
| Space | O(amount) — Se almacenan amount+1 elementos en el arreglo dp |

## Código

```java
// Entrada: un arreglo de enteros coins con las denominaciones y un entero amount como monto objetivo
// Salida: se devuelve un int con la cantidad mínima de monedas que suman amount. Si no es posible, se devuelve -1
int coinChange(int[] coins, int amount) {
    // dp[i] = cantidad mínima de monedas necesaria para formar el monto i
    // El tamaño es amount + 1 para cubrir cada monto desde el índice 0 hasta amount
    int[] dp = new int[amount + 1];

    // Se inicializan todos los elementos con un valor centinela que representa "inalcanzable"
    // Como la denominación mínima de una moneda es 1, nunca se necesitarán más de amount monedas, por lo que si este valor permanece, se determina que "no se puede formar"
    Arrays.fill(dp, amount + 1);

    // Caso base: se necesitan 0 monedas para formar el monto 0. Es el punto de partida del cálculo ascendente
    dp[0] = 0;

    // Se rellena la tabla en orden desde el monto 1 hasta amount
    // Al calcular desde los montos más pequeños, se garantiza que dp[i - coin] ya está determinado
    for (int i = 1; i <= amount; i++) {
        // Se evalúa cada moneda como candidata a "última moneda para formar el monto i" y se busca la denominación óptima
        for (int coin : coins) {
            // Si coin > i, esa moneda no puede formar el monto i, por lo que se omite
            if (coin <= i)
                // dp[i - coin] + 1 es "la cantidad mínima para el monto i - coin más una moneda adicional"
                // Se compara con el dp[i] actual y se adopta el menor de los dos
                dp[i] = Math.min(dp[i],
                    dp[i - coin] + 1);
        }
    }

    // Si el valor centinela permanece sin cambios, el monto objetivo no se puede formar y se devuelve -1
    return dp[amount] > amount
        ? -1 : dp[amount];
}
```
