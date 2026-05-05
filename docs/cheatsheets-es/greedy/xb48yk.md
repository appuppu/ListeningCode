# Dividing Cards Into Consecutive Groups — Determinar si las cartas se pueden dividir en grupos consecutivos de un tamaño especificado

## Esencia del problema

Se reciben un arreglo de enteros `hand` (valores de las cartas) y un entero `groupSize`. Se debe devolver un `boolean` que indique si todas las cartas se pueden dividir en grupos donde cada grupo esté compuesto por `groupSize` **valores consecutivos**. Es necesario utilizar todas las cartas sin que sobren ni falten.

## Idea central

Si se procesan las cartas de forma greedy desde el valor más pequeño, el grupo al que pertenece cada carta queda determinado de forma única. Se repite el proceso de crear un grupo consecutivo a partir de la carta más pequeña y eliminar las cartas utilizadas; si se logra utilizar todas las cartas, la división es posible.

## Proceso de razonamiento

1. **Verificar la condición previa**: Como se dividen las cartas en grupos de `groupSize` cartas cada uno, si el número total de cartas no es divisible por `groupSize`, la división es imposible. Realizar esta verificación primero permite evitar procesamiento innecesario
2. **Razón por la que se debe procesar desde la carta más pequeña**: La carta más pequeña solo puede pertenecer a un grupo consecutivo que comience con ella misma. Por ejemplo, si el valor mínimo es 3 y `groupSize` es 3, esa carta necesariamente forma parte del grupo [3, 4, 5]. Por lo tanto, la estrategia greedy de procesar desde el valor mínimo es correcta
3. **Es necesario gestionar la frecuencia de aparición de cada carta**: Como puede haber múltiples cartas con el mismo valor, se necesita una estructura de datos que registre la frecuencia de aparición de cada valor. Además, como se desea obtener el valor mínimo de manera eficiente, un TreeMap con claves ordenadas es la estructura adecuada
4. **Procedimiento para construir un grupo**: Se obtiene la clave mínima `first` del TreeMap y se verifica que todos los valores consecutivos desde `first` hasta `first + groupSize - 1` existan en el TreeMap. Si existen, se reduce la frecuencia de cada valor en 1, y si la frecuencia llega a 0, se elimina ese valor del TreeMap
5. **Cuando falta un valor consecutivo**: Si durante la construcción de un grupo un valor necesario no existe en el TreeMap, se determina que la división es imposible y se devuelve `false`
6. **Éxito al procesar todas las cartas**: Se repite la construcción de grupos hasta que el TreeMap quede vacío; si todas las construcciones tienen éxito, se devuelve `true`

## Conocimientos previos

### Qué es un TreeMap

Es una estructura de datos Map en la que las claves se mantienen siempre en orden. Al igual que un HashMap, almacena pares de clave y valor, pero permite operaciones basadas en el orden de las claves (como obtener la clave mínima) en O(log n). Internamente está implementado como un árbol rojo-negro (árbol binario de búsqueda autobalanceado).

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();  // Crear un TreeMap vacío
tm.put(5, 2);           // Almacenar el valor 2 con la clave 5
tm.put(3, 1);           // Almacenar el valor 1 con la clave 3
tm.firstKey();           // Devolver la clave mínima → 3
tm.containsKey(5);       // Devolver un boolean indicando si la clave 5 existe → true
tm.get(5);               // Devolver el valor correspondiente a la clave 5 → 2
tm.remove(3);            // Eliminar la clave 3 y su valor
```

### Qué es getOrDefault

Es un método que, al obtener un valor de un Map, devuelve un valor por defecto especificado si la clave no existe. Permite omitir la verificación de `null` en el conteo de frecuencias.

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();
tm.getOrDefault(10, 0);  // La clave 10 no existe, por lo que devuelve el valor por defecto 0 → 0
tm.put(10, 3);
tm.getOrDefault(10, 0);  // La clave 10 existe, por lo que devuelve su valor → 3
```

### Qué es el algoritmo greedy

Es una técnica que busca la solución óptima global realizando la elección localmente óptima en cada paso. En este problema, la elección greedy de "crear grupos en orden desde la carta más pequeña" conduce a una división correcta en su totalidad. Dado que la carta más pequeña no puede insertarse en medio de otro grupo, la elección greedy coincide con la solución óptima.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n log n) — La inserción y eliminación en el TreeMap son O(log n) cada una, y se procesan las n cartas en total |
| Space | O(n) — El TreeMap almacena como máximo n entradas |

## Código

```java
// Entrada: arreglo de enteros hand (valores de las cartas) y entero groupSize (tamaño de cada grupo)
// Salida: devuelve true si todas las cartas se pueden dividir en grupos de valores consecutivos, false en caso contrario
public boolean isNStraightHand(int[] hand, int groupSize) {
    // Si el número total de cartas no es divisible por el tamaño del grupo, la división equitativa es imposible
    if (hand.length % groupSize != 0)
        return false;

    // TreeMap donde clave = valor de la carta, valor = cantidad restante (frecuencia)
    // Se usa TreeMap porque permite obtener el valor mínimo de carta en O(log n)
    TreeMap<Integer, Integer> tm = new TreeMap<>();
    // Contar la frecuencia de aparición de cada carta, sumando 1 a la frecuencia existente con getOrDefault
    for (int card : hand) {
        tm.put(card, tm.getOrDefault(card, 0) + 1);
    }

    // Construir grupos hasta que el TreeMap quede vacío (si queda vacío, significa que todas las cartas fueron divididas)
    while (!tm.isEmpty()) {
        // Obtener el valor mínimo de carta actual y usarlo como inicio del grupo
        // El valor mínimo no puede insertarse en medio de otro grupo, por lo que siempre inicia un nuevo grupo
        int first = tm.firstKey();

        // Crear un grupo con groupSize valores consecutivos a partir de first
        for (int i = 0; i < groupSize; i++) {
            int cur = first + i;

            // Si el valor consecutivo no existe, no se puede formar el grupo y la división es imposible
            if (!tm.containsKey(cur))
                return false;

            // Si la frecuencia es 1, es la última carta con ese valor, así que se elimina; si es 2 o más, se reduce la frecuencia en 1
            if (tm.get(cur) == 1) {
                tm.remove(cur);
            } else {
                tm.put(cur, tm.get(cur) - 1);
            }
        }
    }

    // Todas las cartas fueron divididas exitosamente en grupos consecutivos
    return true;
}
```
