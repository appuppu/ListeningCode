# Finding the Subarray With Maximum Sum — Encontrar el subarreglo contiguo con la suma máxima

## Esencia del problema

Se recibe un arreglo de enteros `nums`. El arreglo puede contener tanto números positivos como negativos. Se debe encontrar el subarreglo contiguo (subarray) cuya suma de elementos sea la máxima, y devolver ese **valor de la suma**.

## Idea central

Al llegar a cada elemento, solo existen dos opciones: "extender el subarreglo acumulado hasta ahora" o "comenzar un nuevo subarreglo desde este elemento". Si la suma acumulada hasta el momento es negativa, siempre es más conveniente descartarla y comenzar de nuevo en lugar de arrastrarla.

## Proceso de razonamiento

1. **Solo existen dos opciones en cada elemento**: Al llegar al elemento `nums[i]`, las únicas acciones posibles son "agregar `nums[i]` al subarreglo anterior para extenderlo" o "iniciar un nuevo subarreglo con `nums[i]` como primer elemento". Debido a la restricción de subarreglo contiguo, no se pueden omitir elementos intermedios
2. **Criterio para decidir entre extender o comenzar de nuevo**: Si la suma acumulada `currentSum` hasta el momento es positiva, al sumarla con `nums[i]` se obtiene un valor mayor que `nums[i]` solo, por lo que se extiende el subarreglo. Si `currentSum` es negativa, al sumarla se obtiene un valor menor que `nums[i]` solo, por lo que se descarta y se comienza de nuevo. Es decir, basta con elegir el mayor entre `currentSum + nums[i]` y `nums[i]`
3. **Esta decisión se expresa con `Math.max`**: Con la sola línea `currentSum = Math.max(currentSum + nums[i], nums[i])`, se completa la decisión entre extender y comenzar de nuevo. `currentSum + nums[i]` corresponde a la extensión, y `nums[i]` corresponde al nuevo inicio
4. **Se rastrea el máximo global por separado**: `currentSum` representa "la suma del subarreglo actual" y su valor sube y baja durante el recorrido. Lo que el problema pide es "la suma máxima a lo largo de todo el arreglo", por lo que se utiliza otra variable `maxSum` para registrar continuamente el valor máximo de `currentSum` que aparece durante el recorrido
5. **Se inicializa `maxSum` con `Integer.MIN_VALUE`**: Para que el algoritmo funcione correctamente incluso cuando todos los elementos son negativos, se inicializa `maxSum` con el valor mínimo de los enteros. Si se inicializa con 0, cuando todos los elementos son negativos se juzgaría erróneamente que "el subarreglo vacío (suma 0)" es el máximo
6. **Al final se devuelve `maxSum`**: Cuando el recorrido del arreglo termina, `maxSum` contiene la suma máxima entre todos los subarreglos contiguos. Se devuelve este valor

## Conocimientos previos

### Qué es Math.max

Es un método estándar de Java que recibe dos valores y devuelve el mayor de los dos. Permite expresar una bifurcación condicional en una sola línea.

```java
Math.max(5, 3);       // Devuelve el mayor de los dos valores → 5
Math.max(-2, -7);     // También devuelve el mayor entre números negativos → -2
Math.max(a + b, b);   // También se pueden comparar resultados de expresiones
```

### Qué es Integer.MIN_VALUE

Es una constante que representa el valor mínimo del tipo `int` en Java (-2,147,483,648). Se utiliza como valor inicial para el estado "aún no se ha comparado nada". Al comparar con cualquier entero mediante `Math.max`, siempre se elige el otro valor.

```java
int maxSum = Integer.MIN_VALUE;   // Se inicializa con el valor mínimo del tipo int
maxSum = Math.max(maxSum, -5);    // Cualquier valor es mayor que maxSum → -5
```

### Qué es un subarreglo contiguo (subarray)

Es una porción del arreglo formada por elementos adyacentes extraídos sin interrupción. No se pueden seleccionar elementos saltándose otros.
Ejemplo: cuando `nums = [-2, 1, -3, 4, -1, 2]`, `[4, -1, 2]` es un subarreglo contiguo (suma 5). `[1, 4, 2]` no es un subarreglo contiguo porque los elementos no son adyacentes.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita recorrer el arreglo una vez |
| Space | O(1) — Solo se utilizan dos variables: `maxSum` y `currentSum` |

## Código

```java
// Entrada: un arreglo de enteros nums que puede contener números positivos y negativos
// Salida: devuelve como int el valor máximo de la suma de un subarreglo contiguo
public int maxSubArray(int[] nums) {
    // Variable que registra la suma máxima de subarreglos encontrada durante todo el recorrido
    // Se inicializa con Integer.MIN_VALUE para seleccionar correctamente el máximo incluso cuando todos los elementos son negativos
    // Nota: si se inicializa con 0, cuando todos los elementos son negativos se juzgaría erróneamente que "el subarreglo vacío (suma 0)" es el máximo
    int maxSum = Integer.MIN_VALUE;
    // Variable que mantiene la suma del subarreglo que se está construyendo actualmente. Es 0 al inicio del recorrido porque aún no se incluye ningún elemento
    int currentSum = 0;

    // Se recorre el arreglo uno por uno desde el principio hasta el final
    for (int num : nums) {
        // currentSum + num es "la suma al extender el subarreglo anterior"
        // num es "la suma al comenzar un nuevo subarreglo desde este elemento"
        // Al elegir el mayor de los dos, siempre se toma la decisión óptima
        currentSum = Math.max(currentSum + num, num);
        // Si la suma del subarreglo actual supera el máximo registrado hasta ahora se actualiza; si no, se mantiene
        maxSum = Math.max(maxSum, currentSum);
    }
    // Cuando el recorrido termina, maxSum contiene la suma máxima entre todos los subarreglos contiguos
    return maxSum;
}
```
