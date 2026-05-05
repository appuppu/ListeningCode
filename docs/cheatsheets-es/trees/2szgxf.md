# Counting Good Nodes in a Binary Tree — Contar los "nodos buenos" en un árbol binario

## Esencia del problema

Se da un árbol binario. Si el valor de un nodo es mayor o igual que el valor máximo de todos los nodos en el camino desde la raíz hasta ese nodo, se considera un "nodo bueno (good node)". Se debe devolver la cantidad de nodos buenos en todo el árbol.

## Idea central

Si se lleva el "valor máximo hasta el momento" mientras se recorre desde la raíz hacia cada nodo, se puede determinar en O(1) si cada nodo es un nodo bueno. Al recorrer el árbol con DFS y propagar el valor máximo hacia los nodos hijos, se obtiene la respuesta visitando cada nodo una sola vez.

## Proceso de razonamiento

1. **Organizar la condición de evaluación**: Para determinar si un nodo es bueno, basta con compararlo con el valor máximo en el camino desde la raíz hasta ese nodo. Es decir, si se conoce el valor máximo en el camino, se puede hacer la evaluación
2. **Cómo gestionar el valor máximo en el camino**: Al recorrer el árbol con DFS, la pila de llamadas recursivas corresponde al camino desde la raíz hasta el nodo actual. Si se pasa el "valor máximo hasta el momento" como argumento de la recursión, cada nodo tiene la información necesaria para la evaluación
3. **Definir el procesamiento en cada nodo**: Si el valor del nodo actual es mayor o igual que el valor máximo, es un nodo bueno y se suma 1 al resultado; de lo contrario, se suma 0. De esta forma, la evaluación y el conteo se realizan simultáneamente
4. **Actualizar el valor máximo que se pasa a los nodos hijos**: El valor máximo que se pasa a los nodos hijos es el mayor entre el valor máximo actual y el valor del nodo actual. De esta forma, a medida que el camino se extiende, el valor máximo se actualiza de manera monótonamente no decreciente
5. **Procesar recursivamente los subárboles izquierdo y derecho**: Se obtiene recursivamente la cantidad de nodos buenos del subárbol izquierdo y del subárbol derecho, y se suman con el resultado del nodo actual para devolver el total
6. **Valor máximo en la llamada inicial**: El nodo raíz siempre es un nodo bueno (solo él mismo está en el camino). Si se establece el valor inicial como `Integer.MIN_VALUE`, el valor de la raíz siempre será mayor o igual, por lo que la evaluación es correcta

## Conocimientos previos

### Qué es el DFS recursivo (búsqueda en profundidad)

Es un algoritmo que recorre un árbol o grafo priorizando la dirección más profunda. En un árbol binario, se implementa haciendo que la función recursiva se llame a sí misma para el hijo izquierdo y el hijo derecho. La pila de llamadas recursivas mantiene implícitamente el camino desde la raíz hasta el nodo actual.

```java
void dfs(TreeNode node) {
    if (node == null) return;  // Caso base: si se llega a un nodo null, se retorna
    // Procesamiento del nodo actual
    dfs(node.left);            // Se recorre recursivamente el subárbol izquierdo
    dfs(node.right);           // Se recorre recursivamente el subárbol derecho
}
```

### Qué es Math.max

Es un método que devuelve el mayor de dos valores. Se utiliza para actualizar el valor máximo en el camino.

```java
Math.max(5, 3);    // → 5 (devuelve el mayor entre 5 y 3)
Math.max(-1, 4);   // → 4
```

### Qué es Integer.MIN_VALUE

Es el valor mínimo que puede tener el tipo `int` de Java (-2,147,483,648). Como el valor de cualquier nodo es mayor o igual que este valor, al usarlo como valor máximo inicial, el nodo raíz siempre se evalúa como nodo bueno.

```java
Integer.MIN_VALUE;  // → -2147483648 (valor mínimo del tipo int)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Se visita cada nodo exactamente una vez |
| Space | O(h) — La pila de llamadas recursivas utiliza espacio proporcional a la altura del árbol |

## Código

```java
// Entrada: nodo raíz del árbol binario root
// Salida: se devuelve el número total de nodos buenos como int

// Función auxiliar: devuelve la cantidad de nodos buenos en el subárbol con raíz en node
// maxSoFar representa el valor máximo en el camino desde la raíz hasta el nodo actual
private int dfs(TreeNode node, int maxSoFar) {
    // Caso base: si se llega a null, hay 0 nodos buenos (se pasó de un nodo hoja, no hay nodos que contar)
    if (node == null) return 0;

    // Se evalúa si el nodo actual es un nodo bueno (es bueno si su valor es mayor o igual al valor máximo en el camino)
    int result = node.val >= maxSoFar ? 1 : 0;

    // Se actualiza el valor máximo que se pasa a los nodos hijos (si el valor del nodo actual es mayor se actualiza, de lo contrario se mantiene el valor máximo anterior)
    int newMax = Math.max(maxSoFar, node.val);

    // Se obtiene recursivamente la cantidad de nodos buenos del subárbol izquierdo y se suma
    result += dfs(node.left, newMax);
    // Se obtiene recursivamente la cantidad de nodos buenos del subárbol derecho y se suma
    result += dfs(node.right, newMax);

    // Se devuelve la cantidad total de nodos buenos en el subárbol con raíz en el nodo actual
    return result;
}

public int goodNodes(TreeNode root) {
    // Al establecer el valor máximo inicial como el mínimo de int, el nodo raíz siempre se evalúa como nodo bueno
    return dfs(root, Integer.MIN_VALUE);
}
```
