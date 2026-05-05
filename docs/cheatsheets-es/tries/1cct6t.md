# Implementing a Prefix Tree — Diseñar una estructura de datos que realice eficientemente la inserción, búsqueda exacta y búsqueda por prefijo de cadenas dadas

## Esencia del problema

Diseñar e implementar una estructura de datos llamada Trie (árbol de prefijos). Esta estructura de datos debe soportar tres operaciones: (1) `insert(word)` inserta una palabra, (2) `search(word)` determina si existe una palabra que coincida exactamente, (3) `startsWith(prefix)` determina si entre las palabras insertadas existe alguna que comience con el prefijo especificado.

## Idea central

Si se descompone una cadena carácter por carácter en una estructura de árbol, las palabras que comparten un prefijo común comparten nodos entre sí. Al asignar a cada nodo un flag que indica "aquí termina una palabra", la diferencia entre la búsqueda exacta y la búsqueda por prefijo se reduce únicamente a verificar o no ese flag al finalizar el recorrido.

## Proceso de razonamiento

1. **Expandir la cadena carácter por carácter en una estructura de árbol**: Se representa cada carácter de la palabra a insertar como un nodo, y la relación padre-hijo expresa el orden de los caracteres. De esta manera, palabras con un prefijo común como "apple" y "app" pueden compartir los primeros 3 nodos (a→p→p)
2. **Gestionar los nodos hijos de cada nodo con un HashMap**: Cada nodo posee nodos hijos correspondientes a los caracteres que le siguen. Para gestionar los nodos hijos se utiliza un HashMap, almacenando el "carácter" como clave y la "referencia al nodo hijo" como valor. De esta forma, la transición a cualquier carácter se realiza en O(1)
3. **Se necesita un flag para distinguir el final de una palabra**: Después de insertar "apple", si se busca "app", se pueden recorrer los nodos a→p→p. Sin embargo, como "app" no fue insertada, se debe devolver false. Al asignar un flag `isEnd` a cada nodo y establecer `isEnd = true` en el último nodo durante `insert`, se puede distinguir el final de una palabra
4. **Las tres operaciones se basan en el recorrido de nodos**: `insert`, `search` y `startsWith` comienzan desde la raíz y recorren la cadena carácter por carácter transitando entre nodos. `insert` crea un nuevo nodo si el destino de transición no existe. `search` y `startsWith` devuelven false inmediatamente si el destino de transición no existe
5. **La diferencia entre search y startsWith es solo la verificación de isEnd**: `search` verifica si `node.isEnd` es true después de recorrer todos los caracteres. `startsWith` devuelve true simplemente al terminar de recorrer todos los caracteres. La lógica de recorrido es idéntica, solo difiere la verificación final
6. **El nodo raíz es un nodo ficticio**: El nodo raíz que sirve como punto de inicio del Trie se inicializa como un nodo vacío sin carácter. Todas las operaciones comienzan su recorrido desde este nodo raíz

## Conocimientos previos

### Qué es un Trie

Es una estructura de árbol para almacenar y buscar cadenas de manera eficiente. Cada nodo corresponde a un carácter, y el camino desde la raíz hasta una hoja representa una cadena. Las cadenas que comparten un prefijo común comparten nodos, por lo que es una estructura de datos especializada en búsquedas por prefijo.

```
Ejemplo: estructura del árbol al insertar "app", "apple", "bat"

      root
      / \
     a   b
     |   |
     p   a
     |   |
     p*  t*
     |
     l
     |
     e*

* indica nodos con isEnd = true (final de una palabra)
```

### Qué es un HashMap

Es una estructura de datos que almacena pares de clave y valor. Permite buscar y obtener valores especificando la clave en O(1). En un Trie, se utiliza para gestionar los nodos hijos de cada nodo.

```java
HashMap<Character, TrieNode> children = new HashMap<>();  // Crear un HashMap vacío
children.put('a', new TrieNode());      // Almacenar un nuevo nodo con la clave 'a'
children.containsKey('a');              // Devolver un boolean indicando si la clave 'a' existe → true
children.get('a');                      // Devolver el nodo correspondiente a la clave 'a'
children.putIfAbsent('a', new TrieNode());  // Almacenar solo si la clave 'a' no está registrada
```

### Qué es putIfAbsent

Es un método de HashMap que almacena un valor solo si la clave especificada aún no existe. Si la clave ya existe, no hace nada. Se utiliza en la operación `insert` para agregar solo nodos nuevos sin destruir las rutas existentes.

```java
map.putIfAbsent('a', new TrieNode());  // Si 'a' no está registrada, se registra un nuevo nodo
map.putIfAbsent('a', new TrieNode());  // Como 'a' ya está registrada, no se hace nada
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m) — Tanto insert como search y startsWith recorren la cadena una sola vez, de forma proporcional a la longitud m de la cadena |
| Space | O(n * m) — Se almacenan n palabras (con longitud promedio m). Dado que los prefijos comunes comparten nodos, el uso real de memoria es menor que este valor |

## Código

```java
// Entrada: insert(word) recibe la cadena word, search(word) recibe la cadena word, startsWith(prefix) recibe la cadena prefix
// Salida: insert no tiene valor de retorno (agrega una palabra al Trie), search devuelve un boolean indicando si existe una palabra con coincidencia exacta, startsWith devuelve un boolean indicando si existe una palabra que coincida con el prefijo

// Clase TrieNode: representa cada nodo del Trie
class TrieNode {
    // Mapeo hacia los nodos hijos. Clave=carácter, Valor=nodo hijo correspondiente
    Map<Character, TrieNode> children;
    // Flag que indica si una palabra termina en este nodo (valor inicial es false)
    // Este flag permite que search distinga entre coincidencia exacta y coincidencia por prefijo
    boolean isEnd;

    TrieNode() {
        children = new HashMap<>();
        isEnd = false;
    }
}

class Trie {
    // Nodo raíz que sirve como punto de inicio de todas las operaciones (nodo ficticio vacío sin carácter)
    private TrieNode root;

    // El constructor crea un TrieNode vacío como raíz
    public Trie() {
        root = new TrieNode();
    }

    public void insert(String word) {
        // node es un puntero que representa la posición actual del recorrido. El recorrido comienza desde la raíz
        TrieNode node = root;
        // Se recorre la cadena word carácter por carácter desde el inicio
        for (char c : word.toCharArray()) {
            // Con putIfAbsent, si el nodo hijo no existe se crea uno nuevo; si ya existe, no se hace nada
            // Al usar putIfAbsent, se evita sobrescribir las rutas existentes (nodos compartidos por otras palabras)
            node.children.putIfAbsent(c, new TrieNode());
            // Se avanza el puntero al nodo hijo correspondiente al carácter c
            node = node.children.get(c);
        }
        // Se establece el flag de final de palabra en el último nodo
        // Este flag permite que search distinga entre "apple" insertada y "app" no insertada
        node.isEnd = true;
    }

    public boolean search(String word) {
        // El recorrido comienza desde la raíz
        TrieNode node = root;
        // Se recorre la cadena word carácter por carácter desde el inicio
        for (char c : word.toCharArray()) {
            // Si el nodo hijo correspondiente no existe, no hay ruta para este carácter en el Trie, se devuelve false inmediatamente
            if (!node.children.containsKey(c))
                return false;
            // Se avanza el puntero al nodo hijo
            node = node.children.get(c);
        }
        // Si el nodo alcanzado tras recorrer todos los caracteres es un final de palabra, se devuelve true; de lo contrario, false
        // De esta manera, cuando "apple" está insertada y "app" no lo está, search("app") devuelve correctamente false
        return node.isEnd;
    }

    public boolean startsWith(String prefix) {
        // El recorrido comienza desde la raíz
        TrieNode node = root;
        // Se recorre la cadena prefix carácter por carácter desde el inicio
        for (char c : prefix.toCharArray()) {
            // Si el nodo hijo correspondiente no existe, no hay ruta para este prefijo en el Trie, se devuelve false inmediatamente
            if (!node.children.containsKey(c))
                return false;
            // Se avanza el puntero al nodo hijo
            node = node.children.get(c);
        }
        // Como se pudieron recorrer todos los caracteres, existe una palabra en el Trie que comienza con este prefijo
        // La diferencia con search es únicamente que no se verifica isEnd
        return true;
    }
}
```
