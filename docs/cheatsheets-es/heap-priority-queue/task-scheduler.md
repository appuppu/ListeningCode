# Scheduling Tasks With Cooldown Intervals — Encontrar el tiempo mínimo de ejecución de tareas con cooldown

## Esencia del problema

Se recibe un arreglo de tareas (representadas como caracteres) y un entero no negativo `n` (intervalo de cooldown). Una misma tarea no puede ejecutarse de nuevo sin dejar al menos `n` intervalos entre ejecuciones. Durante el cooldown, la CPU permanece en estado inactivo. Se debe devolver el **número mínimo de unidades de tiempo** necesarias para completar todas las tareas.

## Idea central

La tarea con mayor frecuencia determina la estructura general del calendario. Dependiendo de si los huecos de cooldown entre las tareas más frecuentes pueden llenarse con otras tareas, el tiempo total será el mayor entre el "resultado calculado mediante la fórmula" y el "número total de tareas".

## Proceso de razonamiento

1. **La tarea más frecuente se convierte en el cuello de botella**: La restricción de cooldown es más severa para la tarea con mayor número de apariciones. Esta tarea domina la longitud total del calendario
2. **Al colocar la tarea más frecuente se generan huecos**: Si la cantidad de apariciones de la tarea más frecuente es `maxFreq`, al colocar esta tarea con `n` intervalos de separación se generan `(maxFreq - 1)` bloques entre tareas. La longitud de cada bloque es `(n + 1)` (1 tarea + `n` slots de cooldown)
3. **Los huecos se llenan con otras tareas**: En los slots de cooldown dentro de cada bloque se colocan otras tareas para reducir el tiempo inactivo. Si todos los huecos se llenan, no se produce tiempo inactivo
4. **El último bloque recibe un tratamiento especial**: La última ejecución no requiere cooldown, por lo que el último bloque solo contiene las tareas más frecuentes (y las que tienen la misma frecuencia). Si el número de tareas con la misma frecuencia máxima es `maxCount`, la longitud del último bloque es `maxCount`
5. **Se calcula la longitud total con una fórmula**: `(maxFreq - 1) * (n + 1) + maxCount` da la longitud del calendario basado en la tarea más frecuente
6. **Es necesario comparar con el número total de tareas**: Si todos los huecos se llenan y aún sobran tareas, no se necesita ningún tiempo inactivo y el número total de tareas se convierte directamente en la respuesta. Por lo tanto, la respuesta final es `Math.max(formulaResult, tasks.length)`

## Conocimientos previos

### Qué es un arreglo de frecuencias

Es una técnica que utiliza un arreglo de tamaño fijo para contar el número de apariciones de cada carácter. Cuando solo hay letras mayúsculas del alfabeto inglés, un arreglo de tamaño 26 cubre todos los caracteres. Es más rápido y consume menos memoria que un HashMap.

```java
int[] freq = new int[26];            // Inicializa 26 contadores correspondientes a A–Z en 0
freq['B' - 'A']++;                   // Incrementa en 1 el conteo de apariciones de 'B' (índice 1)
freq['B' - 'A'];                     // Obtiene el conteo de apariciones de 'B' → 1
```

### Qué es Math.max

Es un método que devuelve el mayor de dos valores. Se utiliza para elegir la respuesta entre dos candidatos.

```java
Math.max(10, 7);    // → 10 (devuelve el mayor)
Math.max(5, 12);    // → 12
```

### Qué es la estructura de bloques en este problema

Si la tarea más frecuente es `A` (con 3 apariciones) y `n = 2`, el calendario tiene la siguiente estructura de bloques:

```
[A _ _] [A _ _] [A]
 Bloque1  Bloque2  Último
```

`_` representa un slot de cooldown, donde se coloca otra tarea o tiempo inactivo. El último bloque no requiere cooldown, por lo que solo contiene `A`.

## Complejidad

| | Valor |
|---|---|
| Time | O(k) — Se recorre el arreglo de tareas una vez y se recorre el arreglo fijo de tamaño 26 un número constante de veces (k es el número de tareas) |
| Space | O(1) — Solo se utiliza un arreglo de tamaño fijo 26 |

## Código

```java
// Entrada: arreglo de caracteres tasks (cada carácter representa una tarea) y entero no negativo n (intervalo de cooldown)
// Salida: devuelve como int el número mínimo de unidades de tiempo necesarias para completar todas las tareas
public int leastInterval(char[] tasks, int n) {
    // Arreglo de frecuencias para contar las apariciones de cada tarea (A–Z). freq[0] corresponde a 'A', freq[1] corresponde a 'B'
    int[] freq = new int[26];
    // Recorre el arreglo tasks y convierte cada carácter en un índice de 0 a 25 mediante t - 'A' para incrementar el conteo
    for (char t : tasks)
        freq[t - 'A']++;

    // Obtiene la frecuencia máxima de apariciones. Este valor determina el número de bloques del calendario
    int maxFreq = 0;
    for (int f : freq)
        maxFreq = Math.max(maxFreq, f);

    // Cuenta el número de tareas que tienen la misma frecuencia máxima. Este valor es la cantidad de tareas que entran en el último bloque
    int maxCount = 0;
    for (int f : freq)
        if (f == maxFreq) maxCount++;

    // Calcula mediante la fórmula basada en la estructura de bloques
    // (maxFreq - 1): número de bloques que requieren cooldown
    // (n + 1): longitud de cada bloque (1 tarea + n slots de cooldown)
    // maxCount: longitud del último bloque (solo entran las tareas con la misma frecuencia máxima)
    int formulaResult =
        (maxFreq - 1) * (n + 1)
        + maxCount;

    // formulaResult: longitud cuando se produce tiempo inactivo por cooldown
    // tasks.length: longitud cuando no se necesita ningún tiempo inactivo (cuando todos los huecos se llenan y sobran tareas)
    // El mayor de los dos es la respuesta correcta
    return Math.max(formulaResult,
        tasks.length);
}
```
