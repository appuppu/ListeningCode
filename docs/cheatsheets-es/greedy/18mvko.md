# Finding the Starting Gas Station for a Circular Route — Encontrar la gasolinera de inicio para completar una ruta circular

## Esencia del problema

Se proporcionan dos arreglos de enteros de longitud `n`: `gas` y `cost`. `gas[i]` representa el combustible que se obtiene en la estación `i`, y `cost[i]` representa el combustible necesario para desplazarse desde la estación `i` hasta la siguiente estación. Se debe devolver el índice de la estación de inicio desde la cual se puede completar una vuelta completa de la ruta circular. Si no existe ninguna estación desde la cual se pueda completar la vuelta, se devuelve `-1`. La solución es única o no existe.

## Idea central

Si la suma total del balance de combustible de todas las estaciones es no negativa, entonces necesariamente existe una solución. Las estaciones recorridas hasta el punto donde el combustible acumulado se vuelve negativo no pueden ser el punto de inicio, por lo que al reiniciar con la siguiente estación como nuevo candidato de inicio, se encuentra la respuesta en un solo recorrido.

## Proceso de razonamiento

1. **Considerar el balance de combustible de cada estación**: En la estación `i`, se obtienen `gas[i]` unidades de combustible y se consumen `cost[i]` unidades, por lo que el cambio neto de combustible se expresa como `net = gas[i] - cost[i]`. Si `net` es positivo, esa estación genera un excedente de combustible; si es negativo, genera un déficit de combustible
2. **Determinar la condición para completar la vuelta**: Si la suma de `net` de todas las estaciones (`totalBalance`) es no negativa, el combustible total obtenido en la ruta es igual o mayor al combustible consumido, por lo que necesariamente se puede completar la vuelta desde algún punto de inicio. Por el contrario, si `totalBalance` es negativo, el combustible es insuficiente sin importar desde dónde se parta, y por lo tanto no existe solución
3. **Reducir eficientemente los candidatos de inicio**: Supongamos que se parte de la estación `start` y, al avanzar en el recorrido, en cierto punto `i` el combustible acumulado (`currentBalance`) se vuelve negativo. En ese caso, ninguna estación desde `start` hasta `i` puede ser el punto de inicio viable. Esto se debe a que la acumulación desde `start` hasta cualquier estación intermedia `j` era no negativa, por lo que si se partiera desde `j`, se llegaría a `i` con aún menos combustible. Por lo tanto, se descartan todas las estaciones desde `start` hasta `i` de una sola vez, y se establece `i + 1` como el nuevo candidato de inicio
4. **Reiniciar currentBalance y continuar el recorrido**: Para rastrear el combustible acumulado desde el nuevo candidato de inicio `i + 1`, se reinicia `currentBalance` a `0` y se actualiza `start` a `i + 1`. El recorrido en sí solo necesita realizarse una vez de principio a fin
5. **Realizar la verificación final con totalBalance al terminar el recorrido**: Al finalizar el recorrido, si `totalBalance >= 0`, la solución existe y se devuelve `start`. Si `totalBalance < 0`, completar la vuelta es imposible y se devuelve `-1`

## Conocimientos previos

### net (cambio neto de combustible)

Es el balance de combustible en cada estación. Se calcula como `net = gas[i] - cost[i]`. Si es positivo, significa que sobra combustible; si es negativo, significa que falta combustible.

```java
int net = gas[i] - cost[i];  // Calcular el balance de combustible en la estación i
// Ejemplo: cuando gas[i]=3, cost[i]=5, net=-2 (faltan 2 unidades de combustible)
// Ejemplo: cuando gas[i]=4, cost[i]=1, net=3 (sobran 3 unidades de combustible)
```

### Rol de totalBalance y currentBalance

`totalBalance` es la suma total del balance de combustible de toda la ruta y se utiliza para determinar si es posible completar la vuelta. `currentBalance` es el combustible acumulado desde el candidato de inicio actual hasta la estación en curso, y se utiliza para determinar si se debe actualizar el candidato de inicio.

```java
int totalBalance = 0;    // Suma total del balance de combustible de toda la ruta (para determinar si la vuelta es posible)
int currentBalance = 0;  // Combustible acumulado desde el candidato de inicio actual (para determinar la actualización del candidato)
totalBalance += net;     // Se suma continuamente para todas las estaciones
currentBalance += net;   // Se reinicia a 0 cada vez que se cambia el candidato de inicio
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita un único recorrido del arreglo |
| Space | O(1) — Solo se utilizan 3 variables, sin depender del tamaño de la entrada |

## Código

```java
// Entrada: arreglo de enteros gas (combustible obtenido en cada estación) y arreglo de enteros cost (combustible necesario para desplazarse desde cada estación a la siguiente)
// Salida: devuelve como int el índice de la estación de inicio desde la cual se puede completar la ruta circular. Devuelve -1 si no es posible completar la vuelta
public int canCompleteCircuit(int[] gas, int[] cost) {
    // Suma total del balance de combustible de toda la ruta (se usa para la verificación final de si la vuelta es posible)
    int totalBalance = 0;
    // Combustible acumulado desde el candidato de inicio actual (se usa para determinar el reinicio del candidato)
    int currentBalance = 0;
    // Índice del candidato de inicio (comienza en 0 y se actualiza en cada reinicio)
    int start = 0;

    // Recorrer el arreglo uno por uno desde el índice 0 hasta el final
    for (int i = 0; i < gas.length; i++) {
        // Calcular el cambio neto de combustible en la estación i
        int net = gas[i] - cost[i];
        // Sumar siempre al balance total de combustible de la ruta (se usa al final para determinar si la vuelta es posible)
        totalBalance += net;
        // Sumar al combustible acumulado desde el candidato de inicio actual (equivale al combustible restante al llegar a la estación i)
        currentBalance += net;

        // Si el combustible acumulado se vuelve negativo, ninguna estación desde start hasta i puede ser el punto de inicio
        if (currentBalance < 0) {
            // Reiniciar el combustible acumulado y establecer la siguiente estación como nuevo candidato de inicio
            currentBalance = 0;
            start = i + 1;
        }
    }
    // Si el balance total de combustible de la ruta es no negativo, la vuelta es posible y se devuelve start; si es negativo, es imposible y se devuelve -1
    return totalBalance >= 0 ? start : -1;
}
```
