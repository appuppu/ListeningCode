# Finding the Minimum Jumps to Reach the End — Encontrar el número mínimo de saltos para llegar al final del arreglo

## Esencia del problema

Se proporciona un arreglo de enteros `nums`, donde cada elemento `nums[i]` representa el número máximo de posiciones que se pueden saltar desde esa posición. El objetivo es devolver el **número mínimo de saltos** necesarios para llegar al último índice partiendo desde el índice 0. Se garantiza que siempre es posible llegar al final.

## Idea central

Se interpreta cada salto como "el rango (ventana) alcanzable con un solo salto", y cada vez que se llega al límite de la ventana, se incrementa el contador de saltos en 1. Al recorrer la ventana y registrar el punto más lejano alcanzable de la siguiente ventana, se logra el mismo efecto que una búsqueda por niveles de BFS con un espacio de O(1).

## Proceso de razonamiento

1. **Los problemas que buscan el mínimo número de pasos se pueden resolver con BFS**: Si se considera cada posición como un nodo y el rango alcanzable de cada salto como una arista, el problema se convierte en encontrar el camino más corto desde el índice 0 hasta el final. Como BFS explora nivel por nivel, el primer nivel que alcanza el final corresponde al número mínimo de saltos
2. **Representar los niveles de BFS con ventanas**: Un BFS convencional utiliza una cola y consume un espacio de O(n). Sin embargo, en los saltos sobre un arreglo, el rango alcanzable en cada nivel forma un intervalo continuo, por lo que se puede representar el nivel actual solamente con el extremo del intervalo `currentEnd`
3. **Rastrear el punto más lejano alcanzable dentro de la ventana**: Al recorrer la ventana actual (desde el `currentEnd` anterior hasta el `currentEnd` actual), se registra en la variable `farthest` el valor máximo de `i + nums[i]`, que representa el punto más lejano alcanzable desde cada posición `i`. Este valor se convierte en el extremo de la siguiente ventana
4. **Confirmar el salto en el límite de la ventana**: Cuando el índice `i` alcanza `currentEnd`, esto significa que se ha agotado la ventana actual. En ese momento se incrementa el contador de saltos en 1 y se actualiza `currentEnd` a `farthest` para pasar a la siguiente ventana
5. **El rango del bucle llega hasta una posición antes del final**: Al ejecutar el bucle con `i < nums.length - 1`, se evita contar un salto adicional al llegar al último índice. Como se garantiza que se puede llegar al final, no es necesario verificar si se alcanzó
6. **Valor que se devuelve al final**: Tras finalizar el bucle, se devuelve el número mínimo de saltos acumulado en la variable `jumps`

## Conocimientos previos

### ¿Qué es Greedy BFS (búsqueda en amplitud voraz)?

BFS (búsqueda en amplitud) es un algoritmo que encuentra el camino más corto desde el punto de inicio hasta cada nodo en un grafo. Normalmente utiliza una cola, pero en los problemas de saltos sobre arreglos, como el rango alcanzable forma un intervalo continuo, se puede obtener el mismo resultado con un enfoque voraz que solo gestiona los límites del intervalo. Al seleccionar vorazmente el punto más lejano alcanzable en cada nivel (equivalente a un salto), se obtiene el número mínimo de saltos.

### ¿Qué es Math.max?

Es un método estándar de Java que devuelve el mayor de dos enteros. Se utiliza para comparar el punto más lejano alcanzable actual con el nuevo punto calculado y conservar el que sea mayor.

```java
Math.max(3, 7);       // Devuelve el mayor de los dos valores → 7
Math.max(farthest, i + nums[i]);  // Compara el punto más lejano actual con el nuevo punto alcanzable
```

### ¿Qué es una ventana (rango de salto)?

Es el intervalo continuo de índices alcanzables con un solo salto. La variable `currentEnd` representa el extremo derecho de la ventana. Cuando `i` alcanza `currentEnd`, significa que se ha agotado la ventana actual y se necesita el siguiente salto.
Ejemplo: para `nums = [2,3,1,1,4]`, la primera ventana es `[1,2]` (hasta 2 posiciones adelante desde el índice 0), y la siguiente ventana es `[3,4]` (hasta el punto más lejano alcanzable 4 dentro de la ventana).

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se requiere un recorrido del arreglo |
| Space | O(1) — Solo se utilizan 3 variables y no se necesitan estructuras de datos adicionales |

## Código

```java
// Entrada: arreglo de enteros nums (cada elemento representa la longitud máxima de salto desde esa posición)
// Salida: devuelve un int con el número mínimo de saltos para llegar al último índice
public int jump(int[] nums) {
    // Variable que registra el número de saltos. Se incrementa en 1 cada vez que se alcanza el límite de la ventana
    int jumps = 0;
    // Extremo derecho de la ventana de salto actual. Se inicializa en 0 porque se comienza en el índice 0
    int currentEnd = 0;
    // Índice más lejano alcanzable desde la ventana. Se utiliza para determinar el extremo derecho de la siguiente ventana
    int farthest = 0;

    // Se recorre hasta una posición antes del final. Al llegar al final se cumple el objetivo, por lo que no es necesario saltar desde allí
    for (int i = 0; i < nums.length - 1; i++) {
        // i + nums[i] es el índice de destino al realizar el salto máximo desde la posición actual i
        // Se actualiza si es mayor que el farthest registrado hasta el momento
        farthest = Math.max(farthest, i + nums[i]);

        // Cuando se alcanza el extremo derecho de la ventana actual, se necesita el siguiente salto
        if (i == currentEnd) {
            // Se incrementa el número de saltos en 1
            jumps++;
            // Se establece el extremo derecho de la siguiente ventana como farthest. El rango de la siguiente ventana va desde currentEnd+1 hasta el nuevo currentEnd
            currentEnd = farthest;
        }
    }
    // Se devuelve el número mínimo de saltos acumulado
    return jumps;
}
```
