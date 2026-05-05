# Finding the Best Time to Buy and Sell a Stock — Encontrar la ganancia máxima obtenible con una sola transacción de compra y venta a partir de un arreglo de precios de acciones

## Esencia del problema

Se recibe un arreglo de enteros `prices`. Cada elemento `prices[i]` representa el precio de la acción en el día `i`. Bajo la condición de que solo se puede realizar una operación de "compra → venta", se debe devolver la **ganancia máxima** obtenible. Si no es posible obtener ganancia, se devuelve `0`. El día de compra debe ser anterior al día de venta.

## Idea central

Si se recorre el arreglo de izquierda a derecha registrando el "precio mínimo hasta el momento", basta con restar el precio mínimo al precio de cada día para obtener la ganancia máxima en caso de vender ese día en O(1). La respuesta es el valor máximo de esa ganancia a lo largo de todos los días.

## Proceso de razonamiento

1. **La ganancia se determina como "precio de venta − precio de compra"**: Para maximizar la ganancia al vender en un día determinado, se debe minimizar el precio de compra. Es decir, se debe comprar al precio mínimo entre todos los días anteriores al día de venta
2. **Se desea obtener eficientemente el "precio mínimo anterior" para cada día**: Al recorrer el arreglo de izquierda a derecha, se rastrea el valor mínimo de los precios vistos hasta el momento con una variable `minPrice`. Basta con actualizar `minPrice` cada vez que se encuentra un nuevo precio, por lo que no se necesita un arreglo adicional y el espacio requerido es O(1)
3. **Se calcula la "ganancia en caso de vender" para cada día**: Para cada día `i` durante el recorrido, `prices[i] - minPrice` es la ganancia máxima si se vende ese día. Se compara este valor con la variable `maxProfit` y, si es mayor, se actualiza `maxProfit`
4. **Se organiza la relación entre la actualización de minPrice y el cálculo de ganancia**: Si el precio actual es menor que `minPrice`, se actualiza `minPrice`. Vender ese día produciría una ganancia negativa, por lo que no es necesario calcular la ganancia. Si el precio actual es mayor o igual a `minPrice`, se calcula la ganancia y se actualiza `maxProfit`
5. **Manejo del caso sin ganancia**: Si los precios de las acciones son estrictamente decrecientes, `maxProfit` no se actualiza y permanece en su valor inicial `0`. Se devuelve `0` de forma natural sin necesidad de una condición especial
6. **Valor que se devuelve al final**: Se devuelve el valor de `maxProfit` una vez completado el recorrido del arreglo. Este es la ganancia máxima obtenible con una sola transacción de compra y venta

## Conocimientos previos

### Qué es Integer.MAX_VALUE

Es el valor máximo que puede tener el tipo `int` de Java (2,147,483,647). Se utiliza como valor inicial en algoritmos que buscan el mínimo. Dado que se garantiza que es mayor que cualquier precio de acción, en la primera comparación se reemplaza inevitablemente por un precio real.

```java
int minPrice = Integer.MAX_VALUE;  // Se establece un valor suficientemente grande como valor inicial del mínimo
// Si prices[0] es, por ejemplo, 7, como 7 < Integer.MAX_VALUE, minPrice se actualiza a 7
```

### Qué es Math.max

Es un método estático que recibe dos valores `int` y devuelve el mayor de los dos. Permite escribir la actualización del valor máximo en una sola línea.

```java
int a = 5;
int b = 3;
Math.max(a, b);  // → Devuelve 5

// Se utiliza para actualizar la ganancia máxima
maxProfit = Math.max(maxProfit, profit);  // Si profit es mayor, se actualiza maxProfit
```

### Qué es Running Minimum (rastreo del mínimo durante el recorrido)

Es una técnica que rastrea el valor mínimo de los elementos vistos hasta el momento mediante una variable mientras se recorre el arreglo. En cada paso, se compara el elemento actual con la variable y se actualiza la variable con el menor de los dos. Esto permite obtener en O(1) el "valor mínimo anterior a esa posición" en cualquier posición.

```java
int minPrice = Integer.MAX_VALUE;
for (int price : prices) {
    if (price < minPrice) {
        minPrice = price;  // Se actualiza el precio mínimo registrado hasta el momento
    }
    // En este punto, minPrice contiene el valor mínimo entre prices[0] y prices[actual]
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita un recorrido del arreglo |
| Space | O(1) — Solo se utilizan 2 variables (minPrice, maxProfit) |

## Código

```java
// Entrada: arreglo de enteros prices (cada elemento es el precio de la acción en un día)
// Salida: se devuelve la ganancia máxima obtenible con una sola transacción como int. Si no hay ganancia, se devuelve 0
public int maxProfit(int[] prices) {
    // Variable que rastrea el precio mínimo hasta el momento. Se inicializa con Integer.MAX_VALUE para que en la primera comparación se actualice inevitablemente con un precio real
    int minPrice = Integer.MAX_VALUE;
    // Variable que rastrea la ganancia máxima hasta el momento. Se inicializa con 0 para que, en caso de no haber ganancia, se devuelva 0 de forma natural
    int maxProfit = 0;

    // Se recorre el arreglo de principio a fin, uno por uno, con un bucle for-each
    for (int price : prices) {
        if (price < minPrice) {
            // Si el precio actual es menor que el precio mínimo, se actualiza el precio mínimo
            // Este día es el día de actualización del mínimo, por lo que vender este día no genera ganancia (la ganancia sería negativa). Por eso se omite el cálculo de ganancia
            minPrice = price;
        } else {
            // Se calcula la ganancia de comprar en el día del precio mínimo y vender hoy
            int profit = price - minPrice;
            // Si la ganancia supera el máximo registrado hasta ahora, se actualiza la ganancia máxima
            maxProfit = Math.max(maxProfit, profit);
        }
    }
    // El valor de maxProfit al finalizar el bucle es la ganancia máxima a lo largo de todo el arreglo
    return maxProfit;
}
```
