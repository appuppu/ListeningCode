# Finding the Diameter of a Binary Tree — Encontrar el camino más largo (número de aristas) en un árbol binario

## Esencia del problema

Se da el `root` de un árbol binario. Se debe devolver la longitud (número de aristas) del camino más largo entre cualquier par de nodos del árbol. Este camino no necesita pasar por la raíz.

## Idea central

En cualquier nodo, "la altura del subárbol izquierdo + la altura del subárbol derecho + 2" es el número de aristas del camino más largo que pasa por ese nodo. Si se obtiene la altura de cada nodo mediante DFS y se rastrea el valor máximo de esta expresión, el diámetro se puede calcular en un solo recorrido.

## Proceso de razonamiento

1. **El diámetro pasa por algún nodo como "vértice"**: El camino más largo siempre toma un nodo como el punto más alto (punto de inflexión) y va desde algún lugar del subárbol izquierdo de ese nodo hacia algún lugar del subárbol derecho. Por lo tanto, se calcula "la longitud del camino que tiene a ese nodo como vértice" para cada nodo, y el valor máximo es el diámetro
2. **La longitud del camino que pasa por el vértice se determina por las alturas izquierda y derecha**: El número de aristas del camino que tiene a un nodo como vértice se calcula como "altura del subárbol izquierdo + altura del subárbol derecho + 2". La altura izquierda es el número de aristas hasta el nodo más profundo del lado izquierdo, la altura derecha es el número de aristas hasta el nodo más profundo del lado derecho, y se suma +2 porque se añade una arista desde el vértice hacia cada lado
3. **La definición de altura se ajusta al "número de aristas"**: Si se define la altura de un nodo como "el número de aristas desde ese nodo hasta la hoja más lejana", la altura de un nodo hoja es 0 y la altura de un nodo null es -1. Al definir null como -1, la altura del nodo hoja se calcula naturalmente como `1 + max(-1, -1) = 0`
4. **Se actualiza el diámetro mientras se devuelve la altura mediante DFS**: Usando un DFS en postorden, se obtiene recursivamente la altura de los hijos izquierdo y derecho de cada nodo. A partir de las alturas izquierda y derecha obtenidas, se calcula "la longitud del camino que tiene a ese nodo como vértice" y se actualiza la variable global `maxDiameter`, mientras que como valor de retorno se devuelve la altura del propio nodo `1 + max(left, right)`
5. **Se rastrea el valor máximo con una variable global**: El valor de retorno del DFS es "la altura" y no "el diámetro", por lo que el valor máximo del diámetro se registra en la variable global `maxDiameter`. En cada nodo se compara `left + right + 2` con el `maxDiameter` actual y se conserva el mayor
6. **Lo que se devuelve al final**: Después de que el DFS recorre todos los nodos, el valor almacenado en `maxDiameter` es el diámetro de todo el árbol

## Conocimientos previos

### Qué es la altura (height) de un árbol binario

Es el número de aristas en el camino desde un nodo hasta el nodo hoja más lejano. La altura de un nodo hoja se define como 0 y la altura de un nodo null se define como -1. La altura de un nodo padre se obtiene como `1 + max(altura del hijo izquierdo, altura del hijo derecho)`.

```
      1          Altura del nodo 1: 2 (aristas de 1→2→4)
     / \         Altura del nodo 2: 1 (aristas de 2→4)
    2   3        Altura del nodo 3: 0 (nodo hoja)
   /             Altura del nodo 4: 0 (nodo hoja)
  4
```

### Qué es el DFS (búsqueda en profundidad) recursivo

Es una técnica que visita recursivamente cada nodo del árbol. En el recorrido en postorden, se procesan en el orden: hijo izquierdo → hijo derecho → nodo actual. Es adecuado cuando se necesita usar los resultados de los hijos para calcular el valor del padre.

```java
int dfs(TreeNode node) {
    if (node == null) return -1;   // Caso base: un nodo null tiene altura -1
    int left = dfs(node.left);     // Se procesa recursivamente el subárbol izquierdo
    int right = dfs(node.right);   // Se procesa recursivamente el subárbol derecho
    return 1 + Math.max(left, right);  // Se calcula y devuelve la altura del nodo actual
}
```

### Qué es Math.max

Es un método estándar de Java que devuelve el mayor de dos valores.

```java
Math.max(3, 5);    // → 5
Math.max(-1, -1);  // → -1
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita un DFS que visita cada nodo exactamente una vez |
| Space | O(n) — La pila de llamadas recursivas puede tener como máximo n niveles (en el caso de un árbol sesgado) |

## Código

```java
// Entrada: el nodo raíz root de un árbol binario
// Salida: se devuelve como int el diámetro del árbol (número de aristas del camino más largo entre cualquier par de nodos)

// Variable global que mantiene el diámetro máximo descubierto durante el recorrido DFS
// El valor inicial es 0 porque el diámetro de un árbol con un solo nodo es 0
int maxDiameter = 0;

// Función recursiva que devuelve la altura de cada nodo y, como efecto secundario, actualiza maxDiameter
int dfs(TreeNode node) {
    // La altura de un nodo null es -1 (representa que no existe ninguna arista)
    // Devolver -1 permite que la altura del padre (nodo hoja) se calcule correctamente como 1 + max(-1, -1) = 0
    if (node == null) return -1;

    // Se obtiene recursivamente la altura del subárbol izquierdo
    int left = dfs(node.left);
    // Se obtiene recursivamente la altura del subárbol derecho
    int right = dfs(node.right);

    // Se actualiza el valor máximo del diámetro con el número de aristas del camino que tiene al nodo actual como vértice (left + right + 2)
    // El +2 se debe a que se añaden las 2 aristas desde el nodo actual hacia los hijos izquierdo y derecho
    maxDiameter = Math.max(
        maxDiameter,
        left + right + 2);

    // Se devuelve la altura del nodo actual al padre (nótese que es la altura, no el diámetro)
    // Es el valor que el nodo padre usa para calcular la longitud de su propio camino
    return 1 + Math.max(left, right);
}

public int diameterOfBinaryTree(TreeNode root) {
    // Se recorren todos los nodos con DFS y se actualiza maxDiameter a partir de la longitud del camino que tiene a cada nodo como vértice
    dfs(root);
    // El maxDiameter después de completar el recorrido es el diámetro de todo el árbol
    return maxDiameter;
}
```
