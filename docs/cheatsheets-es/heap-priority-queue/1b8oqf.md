# Scheduling Tasks With Cooldown Intervals — Encontrar el tiempo mínimo de ejecución de tareas con cooldown

## Esencia del problema

Se recibe un arreglo de tareas (representadas como caracteres) y un entero no negativo `n` (intervalo de cooldown). La misma tarea no puede ejecutarse de nuevo sin dejar al menos `n` intervalos entre ejecuciones. Durante el cooldown, la CPU permanece en estado inactivo. Se debe devolver el **número mínimo de unidades de tiempo** necesarias para completar todas las tareas.

## Idea central

La tarea con mayor frecuencia determina la estructura general del calendario. Dependiendo de si los huecos de cooldown entre las tareas más frecuentes pueden llenarse con otras tareas, el tiempo total será el mayor entre el "resultado calculado por la fórmula" y el "número total de tareas".

## Proceso de razonamiento

1. **La tarea más frecuente es el cuello de botella**: La restricción de cooldown es más severa para la tarea que aparece con mayor frecuencia. Esta tarea domina la longitud total del calendario
2. **Al colocar la tarea más frecuente se generan huecos**: Si la frecuencia máxima es `maxFreq`, al colocar esta tarea con `n` intervalos de separación, se generan `(maxFreq - 1)` bloques entre tareas. La longitud de cada bloque es `(n + 1)` (1 tarea + `n` slots de cooldown)
3. **Se llenan los huecos con otras tareas**: En los slots de cooldown dentro de cada bloque, se colocan otras tareas para reducir el tiempo inactivo. Si todos los huecos se llenan, no se produce tiempo inactivo
4. **El último bloque se trata de forma especial**: La última ejecución no requiere cooldown, por lo que el último bloque solo contiene la tarea más frecuente (y las tareas con la misma frecuencia). Si el número de tareas que tienen la misma frecuencia máxima es `maxCount`, la longitud del último bloque es `maxCount`
5. **Se calcula la longitud total con la fórmula**: `(maxFreq - 1) * (n + 1) + maxCount` da la longitud del calendario basado en la tarea más frecuente
6. **Es necesario comparar con el número total de tareas**: Si todos los huecos se llenan y aún sobran tareas, no se necesita ningún tiempo inactivo y el número total de tareas es directamente la respuesta. Por lo tanto, la respuesta final es `Math.max(formulaResult, tasks.length)`

## Conocimientos previos

### Qué es un arreglo de frecuencias

Es una técnica que utiliza un arreglo de tamaño fijo para contar las ocurrencias de cada carácter. Si solo se usan letras mayúsculas, un arreglo de tamaño 26 cubre todos los caracteres. Es más rápido y usa menos memoria que un HashMap.

```java
int[] freq = new int[26];            // Inicializa 26 contadores en 0, correspondientes a A–Z
freq['B' - 'A']++;                   // Incrementa en 1 el conteo de 'B' (índice 1)
freq['B' - 'A'];                     // Obtiene el conteo de 'B' → 1
```

### Qué es Math.max

Es un método que devuelve el mayor de dos valores. Se utiliza para elegir la respuesta entre dos candidatos.

```java
Math.max(10, 7);    // → 10 (devuelve el mayor)
Math.max(5, 12);    // → 12
```

### Qué es la estructura de bloques en este problema

Si la tarea más frecuente es `A` (con 3 ocurrencias) y `n = 2`, el calendario tiene la siguiente estructura de bloques:

```
[A _ _] [A _ _] [A]
 Bloque1  Bloque2  Último
```

`_` es un slot de cooldown, donde se coloca otra tarea o tiempo inactivo. El último bloque no requiere cooldown, por lo que solo contiene `A`.

## Complejidad

| | Valor |
|---|---|
| Time | O(k) — Se recorre el arreglo de tareas una vez y se recorre el arreglo fijo de tamaño 26 un número constante de veces (k es el número de tareas) |
| Space | O(1) — Solo se utiliza un arreglo fijo de tamaño 26 |

## Código

```java
// Entrada: arreglo de caracteres tasks (cada tarea es una letra mayúscula de 'A' a 'Z') y un entero no negativo n (intervalo de cooldown)
// Salida: devuelve como int el número mínimo de unidades de tiempo necesarias para completar todas las tareas
public int leastInterval(char[] tasks, int n) {
    // Crea un arreglo de frecuencias de tamaño 26. freq[0] corresponde al conteo de 'A', freq[1] al de 'B'
    int[] freq = new int[26];
    // Recorre tasks y convierte cada carácter a un índice de 0 a 25 mediante t - 'A' para contar las ocurrencias
    for (char t : tasks)
        freq[t - 'A']++;

    // Recorre el arreglo freq para obtener la frecuencia máxima. maxFreq determina el número de bloques del calendario
    int maxFreq = 0;
    for (int f : freq)
        maxFreq = Math.max(maxFreq, f);

    // Cuenta el número de tareas cuya frecuencia es igual a maxFreq. maxCount es el número de tareas en el último bloque
    int maxCount = 0;
    for (int f : freq)
        if (f == maxFreq) maxCount++;

    // (maxFreq - 1): número de bloques que requieren cooldown
    // (n + 1): longitud de cada bloque (1 tarea + n slots de cooldown)
    // maxCount: longitud del último bloque (solo contiene las tareas con la frecuencia máxima)
    int formulaResult =
        (maxFreq - 1) * (n + 1)
        + maxCount;

    // formulaResult es la longitud cuando se produce tiempo inactivo por cooldown
    // tasks.length es la longitud cuando no se necesita ningún tiempo inactivo (todos los huecos se llenan y sobran tareas)
    // El mayor de los dos es la respuesta correcta
    return Math.max(formulaResult,
        tasks.length);
}
```
