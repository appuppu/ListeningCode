# Maximizing Coins From Bursting Balloons — Optimizar el orden de reventar globos para maximizar las monedas

## Esencia del problema

Se proporciona un arreglo de enteros `nums` (el valor de cada globo). Al reventar el globo `i`, se obtienen `nums[left] * nums[i] * nums[right]` monedas (donde left y right son los globos adyacentes restantes). Se debe devolver el máximo de monedas que se pueden obtener al reventar todos los globos. Los valores fuera de los límites del arreglo se tratan como `1`.

## Idea central

En lugar de pensar "en qué orden reventar los globos", se invierte la perspectiva: "qué globo reventar **al final**" dentro del intervalo `[left, right]`. Al fijar el globo `k` como el último en reventarse, los subintervalos izquierdo y derecho se vuelven independientes entre sí, y se puede componer la solución óptima mediante DP de intervalos.

## Proceso de razonamiento

1. **Se desea eliminar la dependencia del orden de reventado**: Al reventar un globo, las relaciones de adyacencia cambian, por lo que las monedas obtenidas varían según el orden. Explorar todos los órdenes requiere `n!` combinaciones, lo cual no es práctico. Se necesita una perspectiva que rompa esta dependencia
2. **Pensar en "reventar al final" hace que los intervalos sean independientes**: Si se decide que el globo `k` es el último en reventarse dentro del intervalo `[left, right]`, en el momento de reventar `k` todos los globos de `[left, k-1]` y `[k+1, right]` ya han desaparecido. Esto significa que los adyacentes de `k` quedan fijados como `arr[left-1]` y `arr[right+1]`, que están fuera del intervalo. Los subproblemas izquierdo y derecho se vuelven independientes, permitiendo componer la solución con DP
3. **Simplificar el manejo de los límites**: Se crea un nuevo arreglo `arr` añadiendo globos virtuales con valor `1` en ambos extremos del arreglo original. Con `arr[0] = 1` y `arr[n+1] = 1`, se puede usar de forma uniforme la expresión `arr[left-1] * arr[k] * arr[right+1]` sin tratar los límites como casos especiales
4. **Definición de la tabla DP**: Se define `dp[left][right]` como "el máximo de monedas que se pueden obtener al reventar todos los globos del intervalo `[left, right]`". La respuesta final es `dp[1][n]` (el intervalo correspondiente a todo el arreglo original)
5. **Rellenar desde los intervalos más cortos**: Se comienza con intervalos de longitud 1 (un solo globo) y se avanza hasta intervalos de longitud `n`. Como los valores de intervalos largos dependen de los valores de intervalos cortos, al calcular desde los más cortos se garantiza que las referencias siempre están ya calculadas
6. **Explorar exhaustivamente el último globo en reventarse para cada intervalo**: Para el intervalo `[left, right]`, se prueba cada globo `k` desde `left` hasta `right` como el último en reventarse. Las monedas al reventar `k` al final son `arr[left-1] * arr[k] * arr[right+1] + dp[left][k-1] + dp[k+1][right]`, y se registra el máximo en `dp[left][right]`

## Conocimientos previos

### ¿Qué es el DP de intervalos (Interval DP)?

Es una técnica que construye la tabla DP tomando el intervalo `[left, right]` como unidad. Se divide el intervalo y se combinan las soluciones óptimas de los subintervalos para obtener la solución óptima global. Se calcula de forma bottom-up desde los intervalos cortos hasta los largos.

```java
// Estructura básica del DP de intervalos: se calcula en orden desde los intervalos más cortos
for (int len = 1; len <= n; len++) {        // Longitud del intervalo
    for (int left = 1; left <= n - len + 1; left++) {  // Extremo izquierdo del intervalo
        int right = left + len - 1;          // Extremo derecho del intervalo
        // Calcular dp[left][right]
    }
}
```

### ¿Qué es un centinela (Sentinel)?

Es una técnica que añade elementos virtuales en ambos extremos del arreglo para eliminar la necesidad de manejar los límites como casos especiales. En este problema, se colocan globos con valor `1` en ambos extremos.

```java
int[] arr = new int[n + 2];   // Se crea un arreglo 2 posiciones más grande que el original
arr[0] = 1;                   // Centinela del extremo izquierdo (valor 1)
arr[n + 1] = 1;               // Centinela del extremo derecho (valor 1)
for (int i = 0; i < n; i++)
    arr[i + 1] = nums[i];     // Se copian los elementos originales en los índices 1 a n
```

### Tabla DP con arreglo bidimensional

Se registra la solución óptima del intervalo `[i, j]` en `dp[i][j]`. En Java, al generar con `new int[n+2][n+2]`, todos los elementos se inicializan en `0`. Los intervalos vacíos (`left > right`) pueden dejarse en `0`, por lo que no se necesita procesamiento adicional de inicialización.

```java
int[][] dp = new int[n + 2][n + 2];  // Todos los elementos se inicializan en 0
dp[left][right];                      // Almacena el máximo de monedas del intervalo [left, right]
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n³) — Triple bucle para el extremo izquierdo, el extremo derecho y la posición del último globo reventado |
| Space | O(n²) — Se utiliza la tabla DP `dp[n+2][n+2]` |

## Código

```java
// Entrada: arreglo de enteros nums (el valor de cada globo)
// Salida: se devuelve como int el máximo de monedas obtenidas al reventar todos los globos
public int maxCoins(int[] nums) {
    int n = nums.length;

    // Se crea un arreglo con centinelas (valor 1) añadidos en ambos extremos
    // Estos centinelas eliminan la necesidad de manejar los límites como casos especiales al referenciar el exterior del intervalo
    int[] arr = new int[n + 2];
    arr[0] = arr[n + 1] = 1;
    for (int i = 0; i < n; i++)
        arr[i + 1] = nums[i];

    // dp[left][right] = máximo de monedas obtenidas al reventar todos los globos del intervalo [left, right]
    // El tamaño es n+2 para incluir los índices de los centinelas (0 y n+1)
    // Los intervalos vacíos (left > right) pueden dejarse con valor 0
    int[][] dp = new int[n + 2][n + 2];

    // Se calcula en orden desde los intervalos más cortos
    // Al calcular desde los intervalos cortos, se garantiza que los valores de los subintervalos necesarios para los intervalos largos siempre están ya calculados
    for (int len = 1; len <= n; len++) {
        // Se recorren todos los intervalos de longitud len
        for (int left = 1; left <= n - len + 1; left++) {
            int right = left + len - 1;

            // Se explora exhaustivamente el globo k que se revienta al final en el intervalo [left, right]
            for (int k = left; k <= right; k++) {
                // Al decidir que k se revienta al final, los adyacentes de k quedan fijados como arr[left-1] y arr[right+1] fuera del intervalo
                int coins = arr[left - 1] * arr[k] * arr[right + 1];
                // Se suman las monedas de los subintervalos izquierdo y derecho para obtener el total
                int total = coins + dp[left][k - 1] + dp[k + 1][right];
                // Se actualiza dp[left][right] con el valor máximo
                dp[left][right] = Math.max(dp[left][right], total);
            }
        }
    }

    // Se devuelve el máximo de monedas correspondiente a todo el arreglo original (índices 1 a n)
    return dp[1][n];
}
```
