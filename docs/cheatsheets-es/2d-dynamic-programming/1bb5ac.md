# Maximizing Stock Profit With a Cooldown Period — Obtener la ganancia máxima en compraventa de acciones con período de enfriamiento

## Esencia del problema

Se recibe un arreglo de precios de acciones `prices`. Cada índice representa un día. Se pueden comprar y vender acciones múltiples veces, pero el día siguiente a una venta es un **período de enfriamiento** en el que no se puede operar. Se debe devolver la **ganancia máxima** posible bajo esta restricción.

## Idea central

Se clasifican los estados de cada día en tres categorías: «tenencia de acciones (hold)», «recién vendido (sold)» y «en reposo (rest)». Se definen las transiciones desde los tres estados del día anterior hacia los tres estados del día actual. Como cada día depende únicamente del día anterior, se pueden gestionar los estados con solo tres variables en lugar de un arreglo.

## Proceso de razonamiento

1. **Cada día tiene tres estados posibles**: Al final de un día, uno se encuentra en uno de estos estados: «tiene acciones en cartera (hold)», «vendió ese día (sold)» o «no hizo nada (rest)». Estos tres estados cubren todos los casos posibles
2. **Se definen las transiciones entre estados**: hold es el mayor entre «mantener hold del día anterior sin hacer nada» y «estar en rest el día anterior y comprar hoy». sold es «estar en hold el día anterior y vender hoy». rest es el mayor entre «mantener rest del día anterior sin hacer nada» y «estar en sold el día anterior y terminar el enfriamiento». La restricción de enfriamiento se expresa naturalmente con la regla de que «el día siguiente a sold no se puede transicionar a hold»
3. **Se establecen los estados iniciales**: Si se compra en el día 0, hold = -prices[0] (la ganancia es negativa). Como en el día 0 no es posible vender ni descansar, sold = Integer.MIN_VALUE (este valor indica que el estado aún no se ha alcanzado) y rest = 0 (si no se hace nada, la ganancia es 0)
4. **Cada día depende únicamente del estado del día anterior**: Al observar las fórmulas de transición, cada estado del día actual se calcula solo a partir de los tres estados del día anterior. Esto significa que no es necesario mantener un arreglo para todos los días; basta con actualizar tres variables cada día
5. **Es necesario actualizar simultáneamente**: Como hold, sold y rest del día actual se calculan a partir de los valores del día anterior, se almacenan los nuevos valores en variables temporales y luego se sobrescriben las variables del día anterior de una sola vez. Si se sobrescribieran secuencialmente, se perderían los valores del día anterior que aún se necesitan para el cálculo
6. **Qué se devuelve al final**: Terminar el último día con acciones en cartera no es óptimo, por lo que la ganancia máxima es el mayor entre prevSold y prevRest

## Conocimientos previos

### ¿Qué es una máquina de estados (State Machine)?

Es un modelo compuesto por un número finito de estados y reglas de transición entre ellos. En cada momento se encuentra en exactamente un estado y transiciona a otro según la entrada recibida. En este problema, se modela la operación bursátil como una máquina de estados con los tres estados hold / sold / rest.

```
rest ---(comprar)---> hold
hold ---(vender)---> sold
sold ---(esperar)---> rest (enfriamiento)
hold ---(mantener)---> hold
rest ---(mantener)---> rest
```

### ¿Qué es Math.max?

Es un método que devuelve el mayor de dos enteros. Se utiliza para elegir la opción con mayor ganancia cuando hay múltiples alternativas en una transición de estados.

```java
Math.max(3, 7);    // → 7 (devuelve el mayor)
Math.max(-5, -2);  // → -2 (también devuelve el mayor entre números negativos)
```

### ¿Qué es Integer.MIN_VALUE?

Es el valor mínimo que puede tener el tipo int de Java (-2,147,483,648). Se utiliza para representar que «este estado aún no se ha alcanzado». Como cualquier valor lo supera en Math.max, permite ignorar de forma segura los estados no alcanzados.

```java
int x = Integer.MIN_VALUE;  // Representa un estado aún no alcanzado
Math.max(x, 0);             // → 0 (el estado no alcanzado no es seleccionado)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se requiere un recorrido del arreglo |
| Space | O(1) — Se gestionan los estados con solo tres variables |

## Código

```java
// Entrada: arreglo de enteros prices (cada elemento es el precio de la acción de ese día)
// Salida: devuelve como int la ganancia máxima obtenible con la restricción de enfriamiento
public int maxProfit(int[] prices) {
    int n = prices.length;
    // Se necesitan al menos 2 días para comprar y vender. Si n < 2, no se puede operar, así que se devuelve 0
    if (n < 2) return 0;

    // Se inicializan los estados del día 0
    int prevHold = -prices[0];          // Ganancia si se compra en el día 0 (es negativa porque es un gasto)
    int prevSold = Integer.MIN_VALUE;   // No es posible vender en el día 0 (representa estado no alcanzado)
    int prevRest = 0;                   // Si no se hace nada, la ganancia es 0

    for (int i = 1; i < n; i++) {
        // Se calculan los tres estados del día actual a partir de los tres estados del día anterior
        // newHold: el mayor entre «mantener tenencia del día anterior (prevHold)» y «estar en reposo el día anterior y comprar hoy (prevRest - prices[i])»
        // Nota: «estar en sold el día anterior y comprar hoy» no es una opción. Esto expresa la restricción de enfriamiento
        int newHold = Math.max(prevHold,
            prevRest - prices[i]);

        // newSold: se vende hoy la acción que se tenía. Como sell solo puede transicionar desde hold, Math.max no es necesario
        int newSold = prevHold + prices[i];

        // newRest: el mayor entre «mantener reposo del día anterior (prevRest)» y «haber vendido el día anterior y terminar el enfriamiento (prevSold)»
        int newRest = Math.max(prevRest,
            prevSold);

        // Se actualizan todas las variables de una sola vez después de calcular todos los valores
        // Para no sobrescribir los valores del día anterior durante el cálculo, se asignan los tres nuevos valores solo después de obtenerlos todos
        prevHold = newHold;
        prevSold = newSold;
        prevRest = newRest;
    }
    // Terminar el último día con acciones en cartera (prevHold) no es óptimo porque la ganancia no se materializa
    // La ganancia máxima es el mayor entre sold y rest
    return Math.max(prevSold, prevRest);
}
```
