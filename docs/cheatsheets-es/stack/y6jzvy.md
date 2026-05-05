# Finding How Many Days Until a Warmer Temperature — Encontrar el número de días hasta una temperatura más cálida para cada día

## Esencia del problema

Se proporciona un arreglo de enteros `temperatures`. Para cada día, se debe calcular cuántos días faltan hasta un **día futuro** con una temperatura más alta, y devolver los resultados en un arreglo. Si no existe un día futuro con una temperatura más alta, la respuesta para ese día es `0`.

## Idea central

Al apilar índices en un stack monótono decreciente, en el stack solo permanecen "los días que aún no han encontrado un día más cálido". Si la temperatura de un nuevo día es mayor que la temperatura del día en el tope del stack, la diferencia de índices se convierte directamente en el "número de días de espera".

## Proceso de razonamiento

1. **Es necesario encontrar "el siguiente día con temperatura más alta" para cada día**: La solución ingenua consiste en realizar una búsqueda lineal hacia la derecha desde cada día, pero esto resulta en O(n²). Se necesita un mecanismo que gestione eficientemente el "estado no resuelto" de cada día.
2. **Se desea rastrear "los días cuya respuesta aún no se ha determinado"**: Al recorrer el arreglo de izquierda a derecha, si se mantienen como "días no resueltos" aquellos para los cuales aún no se ha encontrado un día futuro con temperatura más alta, se pueden resolver todos de una vez cuando llega un nuevo día.
3. **Se gestionan los días no resueltos con un stack**: Se apilan índices en el stack. Si la temperatura del nuevo día es mayor que la temperatura del día en el tope del stack, la respuesta de ese día no resuelto queda determinada. El stack siempre mantiene un orden monótono decreciente de temperaturas de arriba hacia abajo (las temperaturas más bajas se apilan encima).
4. **La respuesta se obtiene mediante la diferencia de índices**: Cuando el día no resuelto `j` es resuelto por el día actual `i`, el número de días de espera es `i - j`. Esta diferencia se almacena en la posición `j` del arreglo de resultados.
5. **Cada elemento se somete a push y pop como máximo una vez**: El push al stack ocurre una vez por cada elemento, y el pop también ocurre como máximo una vez, por lo que el número total de operaciones incluyendo el bucle while se mantiene en O(n).

## Conocimientos previos

### ¿Qué es un Stack (pila)?

Es una estructura de datos de último en entrar, primero en salir (LIFO). El último elemento agregado es el primero en ser extraído. En Java se utiliza la clase `Stack<Integer>`.

```java
Stack<Integer> stack = new Stack<>();  // Se crea un stack vacío
stack.push(5);          // Se agrega 5 en el tope del stack
stack.peek();           // Se devuelve el elemento del tope del stack sin extraerlo → 5
stack.pop();            // Se extrae y devuelve el elemento del tope del stack → 5
stack.isEmpty();        // Se devuelve un boolean indicando si el stack está vacío → true
```

### ¿Qué es un Stack monótono (Monotonic Stack)?

Es un stack gestionado de manera que los elementos dentro de él siempre mantengan un orden monótono creciente o monótono decreciente. En este problema se utiliza un **stack monótono decreciente**. Antes de agregar un nuevo elemento, se hace pop de todos los elementos que romperían el orden del stack, manteniendo así la monotonía. Este patrón es aplicable para "encontrar el siguiente elemento mayor (o menor)".

```java
// Patrón básico de un stack monótono decreciente
// Las temperaturas dentro del stack decrecen de abajo hacia arriba
// Ejemplo: fondo del stack [75, 71, 69] tope ← las temperaturas están decreciendo
// Cuando llega 72, se hace pop de 69 y 71 para resolverlos, quedando [75, 72]
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Cada elemento realiza push y pop en el stack como máximo una vez cada uno, por lo que el total es O(n) |
| Space | O(n) — Se almacenan como máximo n índices en el stack |

## Código

```java
// Entrada: arreglo de enteros temperatures (la temperatura de cada día)
// Salida: se devuelve un int[] que contiene el número de días hasta el siguiente día con temperatura más alta para cada día
public int[] dailyTemperatures(int[] temperatures) {
    // Se crea el arreglo de resultados (en Java el valor inicial de int[] es 0, por lo que la respuesta 0 para días sin un día más cálido en el futuro se establece por defecto)
    int[] result = new int[temperatures.length];
    // Stack que almacena los índices de los días que aún no han encontrado un día más cálido
    // La razón de almacenar índices en lugar de valores de temperatura: se necesita la diferencia de índices para calcular los días de espera, y la temperatura se puede consultar mediante temperatures[index]
    Stack<Integer> indexStack = new Stack<>();

    // Se recorre el arreglo desde el índice i = 0 hasta el final, uno por uno
    for (int i = 0; i < temperatures.length; i++) {
        // Mientras la temperatura actual sea mayor que la temperatura del día en el tope del stack, se resuelven los días no resueltos
        // Condición: el stack no está vacío Y la temperatura actual > la temperatura a la que apunta el índice en el tope del stack
        while (!indexStack.isEmpty() && temperatures[i] > temperatures[indexStack.peek()]) {
            // Se extrae el índice del tope del stack
            int stackTopIndex = indexStack.pop();
            // Días de espera = índice actual - índice del día que estaba esperando
            result[stackTopIndex] = i - stackTopIndex;
        }
        // Tras finalizar el bucle while (el stack está vacío o la temperatura en el tope del stack es mayor o igual a la temperatura actual), se agrega el índice actual al stack
        // En este punto, el orden monótono decreciente dentro del stack se mantiene
        indexStack.push(i);
    }

    // Los índices que permanecen en el stack son "días para los cuales no existió un día más cálido en el futuro"
    // El resultado para estos días permanece con el valor inicial 0, por lo que no se requiere procesamiento adicional
    return result;
}
```
