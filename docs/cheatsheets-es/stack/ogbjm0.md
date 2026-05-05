# Counting Car Fleets Arriving at a Destination — Calcular el número de flotas de autos que llegan al destino

## Esencia del problema

Se proporcionan un entero `target` (la posición del destino), un arreglo de enteros `position` (la posición actual de cada auto) y un arreglo de enteros `speed` (la velocidad de cada auto). Todos los autos se dirigen hacia el mismo destino. Cuando un auto más rápido alcanza a un auto más lento que va delante, ambos forman una flota (fleet) y avanzan a la velocidad del auto más lento. Se debe devolver como entero el **número de flotas** que finalmente llegan al destino.

## Idea central

Si se procesan los autos en orden desde el más cercano al destino y se gestionan los "tiempos de llegada al destino" de cada auto mediante un stack, entonces si el tiempo de llegada de un auto trasero es menor o igual al del auto delantero, se fusionan; si es mayor, se determina que forma una nueva flota. El tamaño final del stack corresponde al número de flotas.

## Proceso de razonamiento

1. **Determinar la formación de flotas mediante el tiempo de llegada**: Si un auto trasero alcanza o no al auto delantero depende del tiempo de llegada al destino. Si el tiempo de llegada del auto trasero es menor o igual al del auto delantero, significa que lo alcanza en el camino y forman la misma flota. El tiempo de llegada se calcula como `(target - position[i]) / speed[i]`
2. **Procesar los autos en orden desde el más cercano al destino**: La determinación de fusión de flotas depende de "si el auto delantero (más cercano al destino) actúa como barrera". Por lo tanto, si se ordenan y procesan de más cercano a más lejano del destino, se puede evaluar secuencialmente cada auto trasero tomando como referencia el tiempo de llegada del auto delantero
3. **El objeto de ordenamiento es el arreglo de índices**: Como position y speed son arreglos separados, se crea un arreglo de índices y se ordena en orden descendente de `position` (de más cercano a más lejano del destino). De esta manera, se pueden consultar los valores correspondientes de position y speed sin modificar los arreglos originales
4. **Gestionar las flotas con un stack**: El tope del stack contiene el tiempo de llegada de la flota inmediatamente anterior (es decir, el tiempo de llegada del auto líder de esa flota). Si el tiempo de llegada del nuevo auto es menor o igual al tope del stack, ese auto se fusiona con la flota anterior y no se agrega al stack. Si el tiempo de llegada es mayor que el tope, se forma una nueva flota y se hace push al stack
5. **El tamaño del stack es la respuesta**: Los autos que se fusionan no se agregan al stack, y solo los autos que forman nuevas flotas se insertan con push. Por lo tanto, la cantidad final de elementos en el stack corresponde directamente al número de flotas

## Conocimientos previos

### Cálculo del tiempo de llegada

Cuando la posición actual de un auto es `pos`, su velocidad es `speed` y el destino es `target`, el tiempo de llegada se obtiene con `(target - pos) / speed`. Cuanto menor sea este valor, más pronto llega el auto.

```
Ejemplo: cuando target=12, pos=10, speed=2
Tiempo de llegada = (12 - 10) / 2 = 1.0
```

### Ordenamiento personalizado de Integer[]

El tipo primitivo `int[]` no se puede ordenar con expresiones lambda, por lo que se crea un arreglo de índices de tipo `Integer[]` y se pasa un Comparator a `Arrays.sort` para realizar el ordenamiento.

```java
Integer[] idx = new Integer[n];
for (int i = 0; i < n; i++) idx[i] = i;
// Ordenar los índices en orden descendente de pos (de más cercano al destino)
Arrays.sort(idx, (a, b) -> pos[b] - pos[a]);
```

### Qué es un Stack

Es una estructura de datos de tipo último en entrar, primero en salir (LIFO). Se apilan elementos con `push`, se consulta el elemento superior con `peek` y se extrae con `pop`. Aquí se mantiene en el tope del stack el "tiempo de llegada de la flota inmediatamente anterior" y se utiliza como referencia para determinar la fusión.

```java
Stack<Double> stack = new Stack<>();  // Crear un stack vacío
stack.push(3.0);    // Apilar el elemento 3.0 en la parte superior del stack
stack.peek();        // Consultar el elemento superior sin extraerlo → 3.0
stack.isEmpty();     // Determinar si el stack está vacío → false
stack.size();        // Devolver la cantidad de elementos en el stack → 1
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n log n) — El ordenamiento del arreglo de índices requiere O(n log n) y el recorrido posterior requiere O(n) |
| Space | O(n) — Se almacenan como máximo n elementos en el arreglo de índices y en el stack respectivamente |

## Código

```java
// Entrada: entero target (posición del destino), arreglo de enteros pos (posición de cada auto), arreglo de enteros speed (velocidad de cada auto)
// Salida: devolver como entero el número de flotas que llegan al destino
public int carFleet(int target, int[] pos, int[] speed) {
    // Obtener la cantidad de autos
    int n = pos.length;

    // Crear un arreglo de índices de tipo Integer[] e inicializarlo con valores de 0 a n-1
    // Al ordenar el arreglo de índices, se puede cambiar el orden sin modificar los arreglos originales
    Integer[] idx = new Integer[n];
    for (int i = 0; i < n; i++) {
        idx[i] = i;
    }

    // Ordenar el arreglo de índices en orden descendente de position (de más cercano al destino)
    // Procesar desde el auto más cercano al destino permite determinar la fusión tomando como referencia el auto delantero
    Arrays.sort(idx, (a, b) -> pos[b] - pos[a]);

    // Stack para almacenar el tiempo de llegada de cada flota
    // El tope del stack representa "el tiempo de llegada de la flota confirmada inmediatamente anterior"
    Stack<Double> stack = new Stack<>();

    for (int i : idx) {
        // Calcular el tiempo de llegada al destino de este auto
        // Se requiere el cast a double para evitar la división entera que descarta la parte decimal
        double time = (double) (target - pos[i]) / speed[i];

        // Si el tiempo de llegada es menor o igual al tope del stack, este auto alcanza a la flota delantera y se fusiona
        // Se usa continue para omitir la adición al stack y pasar al procesamiento del siguiente auto
        if (!stack.isEmpty() && time <= stack.peek()) {
            continue;
        }

        // Si el stack está vacío o time es mayor que el tope, el auto no puede alcanzar a la flota delantera
        // Se forma una nueva flota y se apila el tiempo de llegada en el stack
        stack.push(time);
    }

    // El stack contiene un tiempo de llegada por cada flota, por lo que su tamaño coincide con el número de flotas
    return stack.size();
}
```
