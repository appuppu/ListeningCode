# Viewing a Binary Tree From the Right Side — Devolver los valores de los nodos visibles al observar un árbol binario desde el lado derecho

## Esencia del problema

Se da el `root` de un árbol binario. Al observar el árbol desde el lado derecho, solo se ve el nodo más a la derecha en cada profundidad. Se debe devolver una `List<Integer>` con los valores de esos nodos, ordenados de arriba (root) hacia abajo.

## Idea central

Si se realiza un DFS visitando primero el hijo derecho, el primer nodo alcanzado en cada profundidad siempre será el "nodo visible desde el lado derecho". Basta con comparar la profundidad con el tamaño de la lista de resultados para determinar si un nodo es el primero visitado en su profundidad.

## Proceso de razonamiento

1. **Qué es un nodo visible desde el lado derecho**: Es el nodo ubicado más a la derecha en cada profundidad. Es decir, el problema se reduce a seleccionar un nodo por cada profundidad
2. **Considerar un DFS que visita primero el hijo derecho**: Al recorrer el árbol con DFS, si se llama recursivamente al hijo derecho antes que al hijo izquierdo, se alcanza primero el nodo más a la derecha en cada profundidad. Aprovechando esta propiedad, basta con registrar solo el primer nodo visitado en cada profundidad
3. **Cómo determinar si es la primera visita en cada profundidad**: El tamaño de la lista de resultados `result` representa "la cantidad de profundidades registradas hasta el momento". Si la `depth` actual es igual a `result.size()`, significa que aún no se ha registrado un nodo para esa profundidad. Solo cuando se cumple esta condición se ejecuta `result.add(node.val)`
4. **Estructura de la recursión**: En cada nodo se procesa en el siguiente orden: "si la profundidad es nueva, registrar el valor" → "recurrir al hijo derecho" → "recurrir al hijo izquierdo". Como se visita primero el hijo derecho, los nodos del lado derecho se registran prioritariamente en cada profundidad
5. **Caso base**: Cuando el nodo es `null`, simplemente se ejecuta `return` sin hacer nada. Esto hace que la recursión más allá de los nodos hoja termine de forma natural
6. **Qué se devuelve al final**: Tras completar el DFS, la lista `result` contiene los valores de los nodos visibles desde el lado derecho, ordenados desde la profundidad 0 en adelante. Se devuelve esta lista tal cual

## Conocimientos previos

### Qué es DFS (búsqueda en profundidad)

Es un algoritmo para recorrer árboles o grafos. Partiendo de un nodo, se avanza lo más profundo posible antes de retroceder (backtracking). Se implementa de forma natural usando recursión.

```java
void dfs(TreeNode node) {
    if (node == null) return;  // Caso base: si es null, no hacer nada
    // Aquí se realiza el procesamiento del nodo
    dfs(node.left);   // Recorrer recursivamente el hijo izquierdo
    dfs(node.right);  // Recorrer recursivamente el hijo derecho
}
```

### size() y add() de List

`List` es un arreglo de longitud variable. `size()` devuelve el número actual de elementos y `add()` agrega un elemento al final. Los elementos se indexan como 0, 1, 2... en el orden en que fueron agregados.

```java
List<Integer> list = new ArrayList<>();  // Crear una lista vacía
list.size();      // Devuelve el número actual de elementos → 0
list.add(5);      // Agregar 5 al final → [5]
list.add(3);      // Agregar 3 al final → [5, 3]
list.size();      // → 2
```

### Qué es depth (profundidad)

Es el número de aristas desde la raíz hasta un nodo determinado. La profundidad de la raíz es 0, la de los hijos de la raíz es 1 y la de los nietos es 2. Al pasar `depth + 1` en la llamada recursiva, se puede rastrear la profundidad de cada nodo.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Se visita cada nodo exactamente una vez |
| Space | O(h) — Se requiere espacio en la pila de llamadas proporcional a la altura del árbol (h es la altura del árbol) |

## Código

```java
// Entrada: nodo raíz del árbol binario root
// Salida: List<Integer> con los valores de los nodos visibles desde el lado derecho, ordenados de arriba hacia abajo
List<Integer> rightSideView(TreeNode root) {
    // Lista que almacena el valor del nodo más a la derecha en cada profundidad
    // El índice de la lista corresponde a la profundidad (index 0 = depth 0)
    List<Integer> result = new ArrayList<>();
    dfs(root, 0, result);
    // Tras completar el DFS, result contiene los valores de los nodos visibles desde el lado derecho, ordenados desde la profundidad 0
    return result;
}

void dfs(TreeNode node, int depth,
         List<Integer> result) {
    // Caso base: si es null, no hacer nada (la recursión para el hijo inexistente de un nodo hoja termina aquí)
    if (node == null) return;

    // Si depth == result.size(), el nodo de esta profundidad aún no ha sido registrado
    // result.size() representa "la cantidad de profundidades registradas hasta el momento"
    if (depth == result.size()) {
        // Como el DFS visita primero el hijo derecho, el primer nodo alcanzado en cada profundidad es siempre el más a la derecha
        result.add(node.val);
    }

    // Al visitar primero el hijo derecho, el nodo más a la derecha de cada profundidad se registra primero
    // Esta es la esencia del algoritmo: visitar en orden derecha → izquierda
    dfs(node.right, depth + 1, result);
    // En las profundidades donde no existe hijo derecho, el hijo izquierdo se convierte en "el primer nodo visitado en esa profundidad" y se registra correctamente
    dfs(node.left, depth + 1, result);
}
```
