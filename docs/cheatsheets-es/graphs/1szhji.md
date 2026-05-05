# Deep Copying a Graph — Duplicar todos los nodos de un grafo no dirigido conexo mediante copia profunda

## Esencia del problema

Se recibe una referencia a un nodo de un grafo no dirigido conexo. Se debe crear una **copia profunda (clon)** de todo el grafo y devolver el nodo correspondiente del grafo clonado. Cada nodo tiene un valor entero `val` y una lista de nodos adyacentes `neighbors`. Es necesario construir un grafo completamente independiente sin hacer referencia a ningún nodo del grafo original.

## Idea central

Dado que un grafo puede contener ciclos, se utiliza un HashMap para registrar la correspondencia "nodo original → nodo clonado" y así evitar clonar el mismo nodo dos veces. Si un nodo no ha sido visitado, se crea su clon y se registra en el HashMap; si ya fue visitado, se devuelve el clon desde el HashMap. De esta manera, se previenen los bucles infinitos y se duplican todos los nodos con precisión.

## Proceso de razonamiento

1. **Se necesita recorrer el grafo**: Para copiar todo el grafo, se deben visitar todos los nodos alcanzables desde el nodo de inicio. Lo más natural es realizar el recorrido mediante DFS (búsqueda en profundidad) con recursión
2. **Es imprescindible manejar los ciclos**: En un grafo no dirigido siempre existen ciclos como A→B→A. Si se intenta clonar un nodo ya visitado, se cae en un bucle infinito, por lo que se necesita un mecanismo para determinar si un nodo ya fue clonado
3. **Se gestiona la correspondencia entre nodos originales y clones con un HashMap**: Se prepara un `HashMap<Node, Node>` donde la clave es el nodo original y el valor es su clon. Esto permite determinar en O(1) si un nodo ya fue clonado y obtener dicho clon en O(1)
4. **Acciones en cada paso de la recursión**: Si el nodo actual existe en el HashMap, se devuelve su clon (ya fue visitado). Si no existe, se crea un nuevo Node, se registra en el HashMap, se invoca recursivamente el clonado para todos los nodos adyacentes del nodo original y se agregan los clones devueltos a la lista neighbors del clon actual
5. **El registro se realiza antes de la recursión**: El registro en el HashMap se debe hacer **antes** de las llamadas recursivas a los nodos adyacentes. Si no se registra primero, cuando un ciclo regrese al nodo actual, el clon no se encontrará en el HashMap y se producirá un bucle infinito
6. **Valor de retorno final**: Se devuelve el clon del nodo de inicio. Desde este clon, todos los nodos clonados están conectados a través de las listas de adyacencia

## Conocimientos previos

### Qué es la clase Node

Es una clase que representa cada vértice del grafo. Tiene un valor entero `val` y una lista de nodos adyacentes `neighbors`.

```java
class Node {
    public int val;
    public List<Node> neighbors;

    public Node(int val) {        // Se crea un nodo especificando val
        this.val = val;
        this.neighbors = new ArrayList<>();  // La lista de adyacencia se inicializa vacía
    }
}
```

### Qué es un HashMap

Es una estructura de datos que almacena pares de clave y valor. Permite buscar y obtener un valor a partir de una clave en O(1). En este problema, se almacena el nodo original como clave y su nodo clonado como valor, cumpliendo a la vez la función de verificación de visita y obtención del clon.

```java
HashMap<Node, Node> map = new HashMap<>();  // Se crea un HashMap vacío
map.put(original, clone);     // Se almacena el nodo original como clave y el clon como valor
map.containsKey(original);    // Se devuelve un boolean indicando si el nodo original está registrado → true
map.get(original);            // Se devuelve el clon correspondiente al nodo original → clone
```

### Qué es DFS (búsqueda en profundidad)

Es uno de los algoritmos de recorrido de grafos. Avanza lo más profundo posible en una dirección y, al llegar a un callejón sin salida, retrocede y avanza en otra dirección. Se implementa de forma natural mediante llamadas recursivas. Si no se gestiona el control de nodos visitados, se produce un bucle infinito en los ciclos.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(V + E) — Se visita cada nodo una vez (V) y se procesa cada arista una vez (E) |
| Space | O(V) — Se almacenan V correspondencias de nodos en el HashMap y la pila de recursión alcanza un máximo de V niveles |

## Código

```java
// Entrada: un nodo node (tipo Node) de un grafo no dirigido conexo. Si el grafo está vacío, es null
// Salida: se devuelve el nodo clonado (tipo Node) correspondiente al nodo de entrada en la copia profunda de todo el grafo

// HashMap que almacena clave=nodo original, valor=nodo clonado
// Se coloca como campo de la clase para compartirlo en todas las llamadas recursivas
Map<Node, Node> map = new HashMap<>();

public Node cloneGraph(Node node) {
    // Si el grafo está vacío (null), se devuelve null y se termina
    if (node == null) return null;

    // Si el nodo actual ya fue clonado, se devuelve su clon
    // Este es el mecanismo que previene los bucles infinitos causados por ciclos
    if (map.containsKey(node))
        return map.get(node);

    // Se crea el clon del nodo actual (en este punto, neighbors está vacío)
    Node clone = new Node(node.val);

    // Nota: el registro se realiza antes de las llamadas recursivas en el siguiente bucle for
    // Si no se registra primero, cuando un ciclo regrese al nodo actual, containsKey no lo detectará y se producirá un bucle infinito
    map.put(node, clone);

    // Se clonan recursivamente todos los nodos adyacentes del nodo original y se agregan a la lista de adyacencia del clon
    // De esta manera, se construyen en el lado del clon las mismas relaciones de adyacencia que en el grafo original
    for (Node nbr : node.neighbors) {
        clone.neighbors
            .add(cloneGraph(nbr));
    }

    // El clone devuelto en la primera llamada se convierte en el nodo de inicio de todo el grafo clonado
    return clone;
}
```
