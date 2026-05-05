# Traversing a Binary Tree Level by Level — Agrupar los nodos de un árbol binario por nivel en listas

## Esencia del problema

Se recibe el `root` de un árbol binario. Se deben agrupar los nodos **por nivel (profundidad)** y devolver una `List<List<Integer>>` donde cada `List<Integer>` contiene los valores de los nodos de ese nivel, ordenados de izquierda a derecha, comenzando desde el nivel superior.

## Idea central

Utilizando una cola (Queue), se pueden procesar los nodos en orden de "primero en anchura", de izquierda a derecha. Al registrar el tamaño de la cola al inicio de cada nivel y extraer exactamente esa cantidad de nodos, se puede gestionar con precisión la separación entre niveles.

## Proceso de razonamiento

1. **La búsqueda en anchura (BFS) es adecuada para procesar por niveles**: La búsqueda en profundidad (DFS) recorre una rama hasta el fondo, lo que dificulta la agrupación por niveles. BFS procesa los nodos desde los más superficiales, por lo que se adapta naturalmente al recorrido por niveles
2. **Se utiliza una cola para implementar BFS**: La cola es una estructura de datos FIFO (primero en entrar, primero en salir) que permite "procesar primero los nodos (más superficiales) que se agregaron antes", realizando así el comportamiento de BFS
3. **Cómo determinar la separación entre niveles**: Al comenzar el procesamiento de cada nivel, todos los nodos en la cola pertenecen al mismo nivel. En ese momento se registra `queue.size()` en una variable `size` y se extraen exactamente `size` nodos, procesando así exactamente un nivel completo
4. **Se agregan los hijos de los nodos extraídos a la cola como el siguiente nivel**: Al extraer cada nodo, se agregan sus hijos izquierdo y derecho a la cola. Estos nodos hijos no se extraen durante el procesamiento del nivel actual (porque el número de extracciones está limitado por `size`). Se procesarán como el siguiente nivel en la próxima iteración del bucle while
5. **Se recopilan los resultados de cada nivel en una lista y se devuelven**: Para cada nivel se crea una `List<Integer>` donde se almacenan los valores de los nodos de ese nivel. Al terminar el procesamiento de un nivel, se agrega esta lista al resultado final `List<List<Integer>>`
6. **Cuando la cola se vacía, el procesamiento de todos los niveles ha terminado**: Cuando se han extraído todos los nodos, la cola queda vacía y el bucle while finaliza. En ese momento, la lista de resultados contiene los valores de los nodos de todos los niveles, ordenados desde el nivel superior

## Conocimientos previos

### Qué es una Queue (cola)

Es una estructura de datos de tipo primero en entrar, primero en salir (FIFO). El primer elemento agregado es el primero en ser extraído. En Java se utiliza LinkedList como implementación de la interfaz Queue.

```java
Queue<TreeNode> queue = new LinkedList<>();  // Crear una cola vacía
queue.offer(node);   // Agregar node al final de la cola
queue.poll();        // Extraer y devolver el elemento del frente de la cola (se elimina de la cola)
queue.size();        // Devolver el número de elementos en la cola → int
queue.isEmpty();     // Devolver un boolean indicando si la cola está vacía
```

### Qué es BFS (búsqueda en anchura)

Es un algoritmo que explora un grafo o árbol en dirección de "anchura". Procesa los nodos en orden desde los más cercanos al punto de inicio. Se implementa utilizando una cola. Al aplicarlo a un árbol, visita los nodos en el orden nivel 0 → nivel 1 → nivel 2…

### Estructura de TreeNode

Es una clase que representa cada nodo de un árbol binario. Tiene tres campos: el valor `val`, el hijo izquierdo `left` y el hijo derecho `right`.

```java
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Se procesa cada nodo del árbol exactamente una vez |
| Space | O(n) — La cola almacena como máximo la cantidad de nodos del nivel más ancho del árbol (en el peor caso n/2) |

## Código

```java
// Entrada: el nodo raíz root de un árbol binario
// Salida: devuelve una List<List<Integer>> que agrupa los valores de los nodos por nivel
List<List<Integer>> levelOrder(TreeNode root) {
    // Resultado final que almacena la lista de valores de nodos de cada nivel
    List<List<Integer>> result = new ArrayList<>();

    // Si root es null, el árbol está vacío, así que se devuelve result vacío directamente
    if (root == null) return result;

    // Crear una cola para BFS y agregar el nodo raíz
    // En este momento la cola contiene solo un nodo del nivel 0
    Queue<TreeNode> queue = new LinkedList<>();
    queue.offer(root);

    // Repetir el procesamiento por nivel hasta que la cola esté vacía
    // Cuando la cola se vacía, el procesamiento de todos los nodos ha terminado
    while (!queue.isEmpty()) {
        // Nota: es necesario guardar este valor en una variable antes del bucle
        // Dentro del bucle for se agregan nodos hijos a la cola, lo que cambia su tamaño,
        // por lo que usar queue.size() directamente en la condición del for no daría la separación correcta de niveles
        int size = queue.size();
        // Lista que almacena los valores de los nodos del nivel actual
        List<Integer> level = new ArrayList<>();

        for (int i = 0; i < size; i++) {
            // Extraer el nodo del frente de la cola
            TreeNode node = queue.poll();
            // Agregar el valor del nodo a la lista del nivel actual
            level.add(node.val);

            // Si existe el hijo izquierdo, agregarlo a la cola (se procesará en el siguiente nivel)
            if (node.left != null)
                queue.offer(node.left);
            // Si existe el hijo derecho, agregarlo a la cola
            // Al agregar los hijos en orden izquierdo → derecho, los nodos del siguiente nivel también se procesan de izquierda a derecha
            if (node.right != null)
                queue.offer(node.right);
        }

        // El procesamiento de un nivel ha terminado, así que se agrega al resultado
        result.add(level);
    }
    // Devolver result, que contiene los valores de los nodos de todos los niveles ordenados de arriba hacia abajo
    return result;
}
```
