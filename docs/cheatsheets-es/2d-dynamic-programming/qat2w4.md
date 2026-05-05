# Counting Combinations to Make a Target Amount — Contar el número de combinaciones de monedas para alcanzar un monto objetivo

## Esencia del problema

Se recibe un arreglo `coins` que contiene las denominaciones de las monedas y un entero `amount`. Se debe devolver el **número de combinaciones** en las que se pueden usar las monedas de `coins` con repetición ilimitada para que la suma sea exactamente `amount`. Dos combinaciones son diferentes si al menos una denominación se usa un número distinto de veces. Las combinaciones que solo difieren en el orden se consideran iguales.

## Idea central

Se procesan los tipos de monedas uno por uno en orden, y para cada moneda se acumulan en el arreglo DP "el número de combinaciones al usar cero o más unidades de esa moneda". Al iterar sobre los tipos de monedas en el bucle exterior, se eliminan naturalmente los duplicados (permutaciones) que contarían el mismo conjunto de monedas en diferente orden.

## Proceso de razonamiento

1. **Distinguir entre combinaciones y permutaciones**: Este problema pide "el número de combinaciones", por lo que [1,2] y [2,1] se deben contar como lo mismo. Si se coloca el monto en el bucle exterior y se eligen las monedas en el interior, se cuentan permutaciones. Por eso es necesario colocar los tipos de monedas en el bucle exterior para fijar el orden de procesamiento
2. **Definir el estado del DP**: Se define `dp[a]` como "el número de combinaciones para formar exactamente el monto `a`". La respuesta final es `dp[amount]`
3. **Establecer el caso base**: La única forma de formar el monto 0 es "no usar ninguna moneda", por lo que se establece `dp[0] = 1`. Sin este caso base, al usar cualquier moneda el número de combinaciones se sumaría a 0 y la respuesta siempre sería 0
4. **Derivar la ecuación de transición**: Para formar el monto `a` usando al menos una unidad de cierta moneda `coin`, se suma el número de combinaciones del monto restante `a - coin`. Es decir, la ecuación de transición es `dp[a] += dp[a - coin]`. Como `dp[a - coin]` ya incluye las combinaciones que usan cero o más unidades de la misma moneda, esta suma cubre automáticamente los casos de usar "1, 2, …" unidades de coin
5. **Determinar el orden de los bucles**: El bucle exterior procesa un tipo de moneda a la vez, y el bucle interior recorre el monto `a` en orden ascendente desde `coin` hasta `amount`. De esta forma, cada moneda suma su contribución al "número de combinaciones acumulado hasta los tipos de moneda anteriores", evitando el conteo duplicado de permutaciones
6. **Valor a devolver**: Después de procesar todas las monedas, `dp[amount]` es el número total de combinaciones para formar el monto objetivo

## Conocimientos previos

### ¿Qué es un arreglo DP (arreglo unidimensional de programación dinámica)?

Es una técnica que almacena las respuestas de los subproblemas en un arreglo y las reutiliza para calcular eficientemente la respuesta del problema mayor. En este problema, `dp[a]` representa "el número de combinaciones para formar el monto `a`".

```java
int[] dp = new int[amount + 1];  // Crear un arreglo con índices de 0 a amount (todos inicializados en 0)
dp[0] = 1;                       // Caso base: hay exactamente 1 forma de formar el monto 0
dp[a] += dp[a - coin];           // Transición: sumar al número de combinaciones del monto a las combinaciones del monto restante al usar 1 unidad de coin
```

### Por qué las monedas deben estar en el bucle exterior

Si se coloca el monto en el exterior y las monedas en el interior, al formar el monto 5 se contarían [1,2,2], [2,1,2] y [2,2,1] por separado (permutaciones). Al colocar las monedas en el exterior, se completa el procesamiento de la moneda 1 antes de procesar la moneda 2, lo que fija el orden "moneda 1 → moneda 2" y permite contar únicamente combinaciones.

```java
// Contar combinaciones (orden correcto)
for (int coin : coins) {          // Exterior: procesar por tipo de moneda
    for (int a = coin; a <= amount; a++) {  // Interior: recorrer los montos
        dp[a] += dp[a - coin];
    }
}

// Cuenta permutaciones (orden incorrecto)
for (int a = 1; a <= amount; a++) {         // Exterior: procesar por monto
    for (int coin : coins) {                // Interior: probar todas las monedas
        if (a >= coin) dp[a] += dp[a - coin];
    }
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n × amount) — Se recorren los montos de 0 a amount por cada uno de los n tipos de monedas |
| Space | O(amount) — Se utiliza un solo arreglo DP de tamaño amount+1 |

## Código

```java
// Entrada: un arreglo de enteros coins con las denominaciones de las monedas y un entero amount como monto objetivo
// Salida: devuelve un int con el número de combinaciones de monedas cuya suma es exactamente amount
public int change(int amount, int[] coins) {
    // dp[a] = número de combinaciones para formar exactamente el monto a
    // El tamaño es amount + 1 (para cubrir cada monto desde el índice 0 hasta amount)
    int[] dp = new int[amount + 1];

    // Caso base: la única forma de formar el monto 0 es "no elegir nada"
    // Sin este caso base, el valor origen de la suma en la transición siempre sería 0, y todos los resultados serían 0
    dp[0] = 1;

    // Procesar por tipo de moneda (el bucle exterior fija el orden y cuenta solo combinaciones)
    // Al colocar los tipos de monedas en el bucle exterior, se evitan los duplicados (permutaciones) que contarían el mismo conjunto de monedas en diferente orden
    for (int coin : coins) {
        // Recorrer en orden ascendente desde coin hasta amount
        // Se inicia desde coin porque a - coin debe ser mayor o igual a 0
        // Al recorrer en orden ascendente, los casos de usar múltiples unidades de la misma moneda se reflejan naturalmente
        for (int a = coin; a <= amount; a++) {
            // Sumar el número de combinaciones del monto restante a-coin al usar 1 unidad de coin
            // Como dp[a - coin] ya incluye las combinaciones que usan 0 o más unidades de la misma moneda,
            // esta sola línea cubre todos los casos de usar "1, 2, 3… unidades de coin"
            dp[a] += dp[a - coin];
        }
    }

    // Devolver el número total de combinaciones para formar el monto objetivo
    return dp[amount];
}
```
