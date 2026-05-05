# Finding the Kth Smallest Element in a BST — Encontrar el k-ésimo elemento más pequeño en un BST

## Esencia del problema

Se proporcionan el nodo raíz `root` de un árbol binario de búsqueda (BST) y un entero `k`. Se debe devolver el **k-ésimo valor más pequeño** entre todos los valores de los nodos del BST. Se garantiza que el árbol contiene al menos k nodos.

## Idea central

Cuando se realiza un recorrido en orden (in-order traversal) de un BST, los valores de los nodos se obtienen en orden ascendente. Por lo tanto, el valor del k-ésimo nodo visitado durante el recorrido en orden es directamente la respuesta. No es necesario recorrer todos los nodos; se puede terminar inmediatamente al alcanzar el k-ésimo nodo.

## Proceso de razonamiento

1. **Aprovechar las propiedades del BST**: En un BST, para cualquier nodo se cumple que «todos los nodos del subárbol izquierdo < el nodo mismo < todos los nodos del subárbol derecho». Gracias a esta propiedad, al realizar un recorrido en orden (izquierda → nodo → derecha), se obtienen los valores de los nodos en orden ascendente
2. **El k-ésimo valor más pequeño es el k-ésimo elemento del recorrido en orden**: La respuesta es el k-ésimo elemento de la secuencia ascendente obtenida mediante el recorrido en orden, por lo que basta con contar durante el recorrido
3. **Elegir un recorrido iterativo con pila en lugar de recursión**: Con recursión no se puede hacer return inmediatamente al alcanzar el k-ésimo elemento (es necesario desenrollar la pila de llamadas). Con un recorrido iterativo usando una pila, se puede salir con return en el momento en que se encuentra el k-ésimo elemento
4. **Cómo implementar el recorrido en orden con una pila**: Desde el nodo actual, se recorren los hijos izquierdos sucesivamente apilándolos en la pila. Al llegar al extremo izquierdo, se hace pop de la pila y se «visita» ese nodo. Luego se pasa al hijo derecho y se repite el mismo proceso
5. **Detectar el k-ésimo elemento con un contador**: Cada vez que se hace pop de un nodo y se visita, se decrementa k. Cuando k llega a 0, el valor de ese nodo es la respuesta
6. **Qué se devuelve finalmente**: Se devuelve el valor `curr.val` del nodo en el momento en que k llega a 0

## Conocimientos previos

### Qué es el recorrido en orden de un BST (árbol binario de búsqueda)

Es un método de recorrido que visita un árbol binario de búsqueda en el orden «subárbol izquierdo → nodo actual → subárbol derecho». Al realizar un recorrido en orden sobre un BST, se obtienen los valores de los nodos en orden ascendente (de menor a mayor).

```
Ejemplo:     5
            / \
           3   7
          / \
         2   4

Resultado del recorrido en orden: 2, 3, 4, 5, 7 (orden ascendente)
```

### Qué es un Stack

Es una estructura de datos de tipo último en entrar, primero en salir (LIFO). El último elemento añadido es el primero en ser extraído. En el recorrido en orden, se utiliza para recordar los nodos padre por los que se pasa mientras se recorren los hijos izquierdos.

```java
Stack<TreeNode> stack = new Stack<>();  // Crear una pila vacía
stack.push(node);      // Añadir node a la parte superior de la pila
stack.pop();           // Extraer y devolver el elemento superior de la pila
stack.isEmpty();       // Devolver un boolean indicando si la pila está vacía
```

### Patrón del recorrido en orden iterativo

El recorrido en orden con pila repite el ciclo «descender hasta el extremo izquierdo → hacer pop y visitar → moverse al hijo derecho». La condición de continuación del bucle se mantiene mientras se cumpla alguna de estas condiciones: «el nodo actual no es null» o «la pila no está vacía».

```java
TreeNode curr = root;
while (curr != null || !stack.isEmpty()) {
    while (curr != null) {       // Descender hasta el extremo izquierdo
        stack.push(curr);
        curr = curr.left;
    }
    curr = stack.pop();          // Visitar (aquí se obtienen los nodos en orden ascendente)
    curr = curr.right;           // Moverse al hijo derecho
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(h + k) — Se desciende h veces hasta el extremo izquierdo y se hace pop de k nodos |
| Space | O(h) — En la pila se apilan como máximo h nodos, donde h es la altura del árbol |

## Código

```java
// Entrada: nodo raíz root de un árbol binario de búsqueda y un entero k
// Salida: devuelve como int el valor del k-ésimo nodo más pequeño en el BST
public int kthSmallest(TreeNode root, int k) {
    // Pila para guardar temporalmente los nodos padre recorridos al seguir los hijos izquierdos, y poder volver a ellos después
    Stack<TreeNode> stack = new Stack<>();
    // Puntero que señala al nodo actualmente enfocado
    TreeNode curr = root;

    // Aunque curr sea null, si quedan nodos en la pila hay nodos sin visitar, por lo que se continúa
    while (curr != null || !stack.isEmpty()) {
        // Descender hasta el extremo izquierdo apilando los nodos por los que se pasa (se alcanza el valor mínimo del subárbol actual)
        while (curr != null) {
            stack.push(curr);
            curr = curr.left;
        }

        // El nodo extraído con pop es el siguiente nodo a visitar en el recorrido en orden (el que tiene el valor más pequeño entre los no visitados)
        curr = stack.pop();
        // Hacer pop equivale a haber visitado un nodo en el recorrido en orden, por lo que se reduce en 1 el número de visitas restantes
        k--;

        // El nodo en el que k llega a 0 es el k-ésimo elemento más pequeño, por lo que se devuelve su valor inmediatamente y se termina
        if (k == 0)
            return curr.val;

        // Si existe un subárbol derecho, en la siguiente iteración se descenderá hasta su extremo izquierdo. Si no existe, curr será null y se hará pop del padre desde la pila
        curr = curr.right;
    }
    // Según las restricciones del problema, el árbol contiene al menos k nodos, por lo que nunca se alcanza este punto
    return -1;
}
```
