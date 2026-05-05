# Determining if a Number is a Happy Number — Determinar si un número es un número feliz repitiendo la suma de los cuadrados de cada dígito

## Esencia del problema

Se da un entero positivo `n`. Se repite la operación de elevar al cuadrado cada dígito de `n` y sumar los resultados. Si el resultado llega a **1**, se devuelve `true` indicando que es un "número feliz". Si no llega a 1 y entra en un ciclo infinito, se devuelve `false`.

## Idea central

La operación de repetir la suma de los cuadrados de cada dígito siempre recorre un conjunto finito de valores. Esta estructura es idéntica a la detección de ciclos en una lista enlazada, y utilizando el puntero lento y el puntero rápido de Floyd, se puede determinar la existencia de un ciclo y el valor de destino sin memoria adicional.

## Proceso de razonamiento

1. **Repetir la operación siempre produce un ciclo**: Al repetir la operación de calcular la suma de los cuadrados de cada dígito, los valores se mantienen dentro de un rango finito, por lo que eventualmente se alcanza un valor que ya apareció anteriormente. Es decir, la secuencia siempre entra en un "ciclo que se detiene en 1" o en un "ciclo que no contiene 1"
2. **La detección de ciclos se reduce a un problema de detección de ciclos en grafos**: Si se considera la transición de cada valor al siguiente como un "enlace de nodo a nodo", este problema tiene la misma estructura que detectar si una lista enlazada contiene un ciclo
3. **El método de dos punteros de Floyd detecta ciclos con espacio O(1)**: El puntero lento avanza 1 paso a la vez y el puntero rápido avanza 2 pasos a la vez. Si existe un ciclo, los dos punteros siempre se encuentran en algún punto dentro del ciclo
4. **El valor en el punto de encuentro determina el resultado**: Cuando los dos punteros se encuentran, si el valor es 1, entonces el número es feliz (la suma de los cuadrados de los dígitos de 1 es 1, por lo que 1 forma un ciclo consigo mismo). Si se encuentran en un valor distinto de 1, significa que el número ha entrado en un ciclo que no contiene 1, por lo que no es un número feliz
5. **Configuración de los valores iniciales**: El puntero lento se establece en `n` y el puntero rápido se establece en `getNext(n)`. De esta manera, el bucle `while (slow != fast)` se inicia de forma natural

## Conocimientos previos

### Cálculo de la suma de los cuadrados de cada dígito

Para extraer cada dígito de un entero `n`, se obtiene el dígito menos significativo con `n % 10` y se elimina ese dígito con `n /= 10`, repitiendo la operación hasta que `n` sea 0.

```java
int n = 19;
int digit = n % 10;   // Obtener el dígito menos significativo → 9
n /= 10;              // Eliminar el dígito menos significativo → n se convierte en 1
digit = n % 10;       // Obtener el siguiente dígito → 1
// 19 → 1² + 9² = 1 + 81 = 82
```

### Método de detección de ciclos de Floyd (método de dos punteros)

Es un algoritmo que detecta si existe un ciclo (bucle) en una lista enlazada o en una secuencia numérica. El puntero lento avanza 1 paso a la vez y el puntero rápido avanza 2 pasos a la vez. Si existe un ciclo, el puntero rápido alcanza al puntero lento y ambos se encuentran inevitablemente. Como no se utiliza ninguna estructura de datos adicional, la complejidad espacial es O(1).

```java
int slow = start;                // El puntero lento avanza 1 paso a la vez
int fast = getNext(start);       // El puntero rápido comienza 1 posición adelante
while (slow != fast) {
    slow = getNext(slow);        // Avanzar 1 paso
    fast = getNext(getNext(fast)); // Avanzar 2 pasos
}
// Al finalizar el bucle, slow == fast es el valor en el punto de encuentro
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(log n) — El cálculo de la suma de los cuadrados de cada dígito toma O(log n), y el número de iteraciones hasta alcanzar el ciclo se mantiene constante |
| Space | O(1) — Solo se utilizan dos variables: el puntero lento y el puntero rápido |

## Código

```java
// Entrada: un entero positivo n
// Salida: devuelve true si n es un número feliz, false en caso contrario

// Función auxiliar que calcula y devuelve la suma de los cuadrados de cada dígito del entero n
// Extrae el dígito menos significativo con n % 10, acumula su cuadrado y elimina el dígito con n /= 10 repetidamente
private int getNext(int n) {
    int sum = 0;
    while (n > 0) {
        int digit = n % 10;   // Extraer el dígito menos significativo
        sum += digit * digit;  // Sumar el cuadrado del dígito a sum
        n /= 10;               // Eliminar el dígito menos significativo
    }
    return sum;
}

public boolean isHappy(int n) {
    // El puntero lento comienza en n, el puntero rápido comienza en getNext(n), un paso adelante
    // Al iniciar fast un paso adelante, el bucle while (slow != fast) se inicia de forma natural
    int slow = n;
    int fast = getNext(n);

    // Iterar hasta que los dos punteros se encuentren
    // Debido a la diferencia de velocidad entre el lento y el rápido, si existe un ciclo, siempre se encuentran
    while (slow != fast) {
        slow = getNext(slow);           // El puntero lento avanza 1 paso
        fast = getNext(getNext(fast));   // El puntero rápido avanza 2 pasos
    }

    // Si el punto de encuentro es 1, el número es feliz (la suma de los cuadrados de los dígitos de 1 es 1, formando un ciclo consigo mismo)
    // Si se encuentran en un valor distinto de 1, el número ha entrado en un ciclo que no contiene 1, por lo que no es un número feliz
    return fast == 1;
}
```
