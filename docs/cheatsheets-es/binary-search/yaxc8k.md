# Designing a Time-Based Key-Value Store — Diseñar un almacén clave-valor con marcas de tiempo

## Esencia del problema

Se diseña una estructura de datos que almacena claves y valores con marcas de tiempo mediante `set(key, value, timestamp)`, y que con `get(key, timestamp)` devuelve el valor correspondiente a la marca de tiempo máxima que sea **igual o menor** a la marca de tiempo especificada. Si no existe una marca de tiempo que cumpla la condición, se devuelve una cadena vacía.

## Idea central

Si se mantienen las marcas de tiempo ordenadas para cada clave, es posible buscar "la clave máxima igual o menor a un valor dado" en tiempo logarítmico. El TreeMap de Java ofrece esta operación de forma integrada mediante el método `floorEntry`.

## Proceso de razonamiento

1. **Organizar las operaciones**: La operación `set` agrega un par de marca de tiempo y valor a una clave. La operación `get` devuelve el valor correspondiente a "la marca de tiempo máxima que sea igual o menor a la marca de tiempo especificada". La esencia de `get` es un problema de búsqueda que consiste en "encontrar el valor máximo igual o menor a un valor dado"
2. **Gestionar las marcas de tiempo por cada clave**: Dado que las distintas claves son independientes entre sí, se separan mediante un HashMap externo por clave, y se mantiene una correspondencia de marca de tiempo → valor para cada clave
3. **Elegir una estructura de datos que obtenga eficientemente "el valor máximo igual o menor"**: Para obtener "el máximo igual o menor a un valor dado" en datos ordenados, se necesita una búsqueda binaria. Un TreeMap (árbol rojo-negro, un árbol de búsqueda binaria balanceado) mantiene las claves en orden, y `floorEntry(key)` devuelve "la entrada máxima igual o menor a la clave especificada" en O(log n)
4. **Definir la implementación de set**: Si la clave no está registrada en el HashMap externo, se crea un nuevo TreeMap. Luego se inserta la marca de tiempo como clave y el valor como valor en el TreeMap mediante `put`. Usando `computeIfAbsent`, se puede escribir la verificación de existencia y la creación en una sola línea
5. **Definir la implementación de get**: Primero se verifica si la clave existe en el HashMap; si no existe, se devuelve una cadena vacía. Si existe, se invoca `floorEntry(timestamp)` del TreeMap; si el resultado no es null, se devuelve su valor; si es null, se devuelve una cadena vacía
6. **Manejar los casos límite**: Se devuelve una cadena vacía en dos casos: cuando la clave no está registrada, y cuando la clave existe pero todas las marcas de tiempo son mayores que el valor especificado

## Conocimientos previos

### Qué es un HashMap

Es una estructura de datos que almacena pares de clave y valor. Permite buscar y obtener valores especificando la clave en O(1).

```java
HashMap<String, TreeMap<Integer, String>> map = new HashMap<>();  // Se crea un HashMap vacío
map.containsKey("foo");    // Devuelve un boolean indicando si la clave "foo" existe
map.get("foo");            // Devuelve el valor correspondiente a la clave "foo"
```

### Qué es computeIfAbsent

Es un método de HashMap. Solo si la clave no está registrada, genera un valor mediante una expresión lambda, lo registra y lo devuelve. Si la clave ya existe, devuelve el valor existente. Permite escribir la verificación de existencia → creación → registro en una sola línea.

```java
map.computeIfAbsent("foo", k -> new TreeMap<>());
// Si "foo" no está registrada → se crea un nuevo TreeMap, se registra y se devuelve ese TreeMap
// Si "foo" ya está registrada → se devuelve el TreeMap existente
```

### Qué es un TreeMap

Es un Map basado en un árbol de búsqueda binaria balanceado que mantiene las claves en orden (ascendente). A diferencia de un HashMap convencional, ofrece operaciones de búsqueda basadas en las relaciones de orden entre claves. Las operaciones `put` y `get` funcionan en O(log n).

```java
TreeMap<Integer, String> tree = new TreeMap<>();  // Se crea un TreeMap vacío
tree.put(1, "one");        // Se almacena "one" en la marca de tiempo 1
tree.put(3, "three");      // Se almacena "three" en la marca de tiempo 3
tree.put(5, "five");       // Se almacena "five" en la marca de tiempo 5
```

### Qué es floorEntry

Es un método de TreeMap. Devuelve la entrada (par de clave y valor) correspondiente a la clave máxima que sea **igual o menor** a la clave especificada. Si no existe una entrada que cumpla la condición, devuelve null. Funciona en O(log n) ya que realiza una búsqueda binaria internamente.

```java
tree.floorEntry(4);   // Máximo igual o menor a la clave 4 → devuelve la entrada de la clave 3: {3="three"}
tree.floorEntry(5);   // Máximo igual o menor a la clave 5 → devuelve la entrada de la clave 5: {5="five"}
tree.floorEntry(0);   // No existe una entrada igual o menor a la clave 0 → devuelve null

Map.Entry<Integer, String> entry = tree.floorEntry(4);
entry.getValue();     // Se obtiene el valor de la entrada → "three"
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(log n) — Tanto set como get realizan operaciones de TreeMap en O(log n) (n es el número de marcas de tiempo almacenadas para esa clave) |
| Space | O(n) — Se almacenan las entradas guardadas en todas las llamadas a set (n es el número total de entradas) |

## Código

```java
// Entrada: set(key, value, timestamp) — clave de tipo String, valor de tipo String, marca de tiempo de tipo int / get(key, timestamp) — clave de tipo String, marca de tiempo de tipo int
// Salida: set no tiene valor de retorno / get devuelve el valor correspondiente como String (si no hay coincidencia, devuelve una cadena vacía)
class TimeMap {
    // HashMap que mantiene un TreeMap de (marca de tiempo → valor) por cada clave
    // El HashMap externo separa por clave, y el TreeMap interno mantiene las marcas de tiempo en orden
    Map<String, TreeMap<Integer, String>> map;

    public TimeMap() {
        // Se crea un HashMap como estructura de datos externa
        map = new HashMap<>();
    }

    public void set(String key, String val, int ts) {
        // computeIfAbsent crea y registra automáticamente un nuevo TreeMap si la clave no está registrada; si ya existe, devuelve el TreeMap existente
        // El TreeMap coloca las claves en orden durante la inserción, por lo que no se necesita una operación de ordenamiento explícita
        map.computeIfAbsent(key, k -> new TreeMap<>())
            .put(ts, val);
    }

    public String get(String key, int ts) {
        // Si la clave no existe, significa que nunca se ha llamado a set, por lo que se devuelve una cadena vacía
        if (!map.containsKey(key))
            return "";

        // Se obtiene el TreeMap de esa clave
        TreeMap<Integer, String> tree = map.get(key);

        // Se busca la entrada máxima igual o menor a la marca de tiempo especificada (el TreeMap recorre su árbol de búsqueda binaria interno en O(log n))
        Map.Entry<Integer, String> entry = tree.floorEntry(ts);

        // Si se encuentra una entrada, se devuelve su valor. Si es null, significa que todas las marcas de tiempo son mayores que el valor especificado, por lo que se devuelve una cadena vacía
        return entry != null ? entry.getValue() : "";
    }
}
```
