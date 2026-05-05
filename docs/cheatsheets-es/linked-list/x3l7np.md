# Designing a Least Recently Used Cache — Diseñar un caché que elimina automáticamente el elemento menos recientemente usado cuando se excede la capacidad

## Esencia del problema

Se debe diseñar un caché que almacene claves y valores enteros. El caché debe soportar dos operaciones: `get(key)` y `put(key, value)`, y ambas deben funcionar en O(1). Cuando el caché excede la capacidad `capacity`, se debe eliminar automáticamente el **elemento menos recientemente usado (Least Recently Used)** antes de insertar el nuevo elemento.

## Idea central

Si se crea un LinkedHashMap de Java en modo de orden de acceso y se sobreescribe el método `removeEldestEntry`, el orden de acceso se actualiza automáticamente con cada get/put, y el elemento más antiguo se elimina automáticamente cuando se excede la capacidad. Toda la funcionalidad del caché LRU se puede implementar únicamente con los mecanismos internos de LinkedHashMap.

## Proceso de razonamiento

1. **Se necesita get/put en O(1)**: Para acceder rápidamente a valores a partir de claves, se necesita un HashMap. Sin embargo, un HashMap convencional no tiene la capacidad de rastrear el orden de uso de los elementos
2. **Se necesita rastrear el orden de uso**: En LRU se debe identificar "el elemento menos recientemente usado". Se necesita una estructura ordenada donde cada elemento accedido se mueva a la posición "más reciente", y el elemento que permanece al inicio sea el "más antiguo"
3. **LinkedHashMap combina ambas capacidades**: El LinkedHashMap de Java, además de la funcionalidad de HashMap, posee internamente una lista doblemente enlazada. Si se pasa `true` como tercer argumento del constructor, se activa el modo de orden de acceso, y con cada get o put, el elemento correspondiente se mueve automáticamente al final de la lista
4. **Eliminación automática al exceder la capacidad**: Se sobreescribe el método `removeEldestEntry` de LinkedHashMap para que devuelva `true` cuando `size() > capacity`. LinkedHashMap invoca este método inmediatamente después de hacer put de un nuevo elemento, y si se devuelve `true`, elimina automáticamente el elemento al inicio de la lista (el elemento más antiguo)
5. **Cuando la clave no existe en get**: La especificación del problema requiere devolver `-1` cuando la clave no existe. Usando `getOrDefault(key, -1)`, se puede realizar la verificación de existencia y la obtención del valor en una sola invocación
6. **Estructura final**: Basta con crear un LinkedHashMap en modo de orden de acceso en el constructor y sobreescribir `removeEldestEntry`. Ambos métodos get/put se reducen a una simple delegación al LinkedHashMap

## Conocimientos previos

### Qué es LinkedHashMap

Es una estructura de datos que, además de toda la funcionalidad de HashMap, mantiene el orden de los elementos mediante una lista doblemente enlazada interna. Si se pasa `true` al tercer argumento `accessOrder` del constructor, cada vez que un elemento es accedido (get o put), dicho elemento se mueve al final de la lista. El elemento menos recientemente accedido permanece al inicio de la lista.

```java
// 1er argumento: capacidad inicial, 2do argumento: factor de carga, 3er argumento: true=modo de orden de acceso
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(16, 0.75f, true);
map.put(1, 10);     // Se almacena el valor 10 en la clave 1. Lista: [1]
map.put(2, 20);     // Se almacena el valor 20 en la clave 2. Lista: [1, 2]
map.get(1);          // Se accede a la clave 1. Lista: [2, 1] (1 se mueve al final)
map.put(3, 30);     // Se almacena el valor 30 en la clave 3. Lista: [2, 1, 3]
// En este punto, la clave 2 al inicio de la lista es "el elemento menos recientemente usado"
```

### Qué es removeEldestEntry

Es un método que LinkedHashMap invoca automáticamente inmediatamente después de hacer put de un nuevo elemento. Si este método devuelve `true`, LinkedHashMap elimina automáticamente el elemento más antiguo que se encuentra al inicio de la lista. Por defecto, siempre devuelve `false`, por lo que se debe sobreescribir para definir la condición de eliminación.

```java
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(cap, 0.75f, true) {
    @Override
    protected boolean removeEldestEntry(Map.Entry<Integer, Integer> eldest) {
        return size() > cap;  // Si el tamaño excede la capacidad, devuelve true para eliminar el elemento más antiguo
    }
};
```

### Qué es getOrDefault

Es un método de la interfaz Map. Si la clave existe, devuelve su valor; si no existe, devuelve el valor por defecto especificado en el segundo argumento. Permite combinar las dos invocaciones de `containsKey` y `get` en una sola.

```java
map.put(1, 10);
map.getOrDefault(1, -1);   // La clave 1 existe, por lo que devuelve el valor 10
map.getOrDefault(99, -1);  // La clave 99 no existe, por lo que devuelve el valor por defecto -1
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(1) — Tanto get como put operan en O(1), ya que el acceso al HashMap y el movimiento dentro de la lista se realizan en O(1) |
| Space | O(n) — Se almacenan los elementos correspondientes a la capacidad del caché dentro del LinkedHashMap (n es capacity) |

## Código

```java
// Entrada: el constructor recibe un entero capacity (capacidad máxima del caché), get recibe un entero key, put recibe un entero key y un entero value
// Salida: get devuelve el valor correspondiente a la clave (devuelve -1 si la clave no existe). put no devuelve ningún valor
class LRUCache {
    LinkedHashMap<Integer, Integer> map;
    // Variable de instancia que almacena la capacidad. Se usa para la decisión de eliminación dentro de removeEldestEntry
    int cap;

    // Recibe la capacidad e inicializa un LinkedHashMap en modo de orden de acceso
    LRUCache(int capacity) {
        cap = capacity;
        // 1er argumento: capacidad inicial, 2do argumento: factor de carga por defecto, 3er argumento: true=modo de orden de acceso
        // Gracias al modo de orden de acceso, con cada get o put, el elemento correspondiente se mueve automáticamente al final de la lista
        map = new LinkedHashMap<>(cap, 0.75f, true) {
            // Método que LinkedHashMap invoca automáticamente con cada put
            // Cuando size() > cap, devuelve true para eliminar automáticamente el elemento más antiguo al inicio de la lista
            // De esta manera, el tamaño del caché se mantiene siempre en cap o menos
            protected boolean removeEldestEntry(Map.Entry<Integer, Integer> e) {
                return size() > cap;
            }
        };
    }

    // Si la clave existe: gracias al modo de orden de acceso, el elemento se mueve al final de la lista (se registra como el más reciente), y se devuelve el valor
    // Si la clave no existe: se devuelve el valor por defecto -1
    int get(int key) {
        return map.getOrDefault(key, -1);
    }

    // Inserta o actualiza un par clave-valor
    // Después de la inserción, removeEldestEntry se invoca automáticamente, y si size() > cap, se elimina el elemento más antiguo
    // Si la clave ya existe, el valor se sobrescribe y el elemento se mueve al final de la lista
    void put(int key, int value) {
        map.put(key, value);
    }
}
```
