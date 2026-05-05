# Finding the Lowest Common Ancestor in a BST — Encontrar el ancestro común más profundo de dos nodos en un BST

## Esencia del problema

Se da un árbol binario de búsqueda (BST) y dos nodos `p`, `q` que existen en el árbol. Se debe devolver el nodo más profundo que tiene a ambos nodos como descendientes (ancestro común más bajo: LCA). Un nodo se considera descendiente de sí mismo.

## Idea central

En un BST, todos los descendientes izquierdos son menores que el nodo actual y todos los descendientes derechos son mayores. En el momento en que `p` y `q` se separan a la izquierda y a la derecha del nodo actual, ese nodo es el LCA.

## Proceso de razonamiento

1. **Se puede aprovechar la propiedad del BST**: En un BST, para cualquier nodo se garantiza el orden: todos los valores del subárbol izquierdo < valor del nodo < todos los valores del subárbol derecho. Gracias a esta propiedad, se puede determinar en qué subárbol se encuentran `p` y `q` simplemente comparando los valores de los nodos
2. **Si ambos están a la izquierda, se avanza a la izquierda**: Si tanto `p.val` como `q.val` son menores que el valor del nodo actual, entonces `p` y `q` se encuentran en el subárbol izquierdo. El LCA también está dentro de ese subárbol izquierdo, por lo que se avanza al hijo izquierdo
3. **Si ambos están a la derecha, se avanza a la derecha**: Si tanto `p.val` como `q.val` son mayores que el valor del nodo actual, entonces `p` y `q` se encuentran en el subárbol derecho. El LCA también está dentro de ese subárbol derecho, por lo que se avanza al hijo derecho
4. **Si se separan a izquierda y derecha, ese nodo es el LCA**: Si `p` y `q` se separan a la izquierda y a la derecha del nodo actual (uno es menor y el otro es mayor), no es posible que ambos estén contenidos en un único subárbol más profundo. Por lo tanto, el nodo actual es el LCA. Si `p` o `q` es igual al nodo actual, también se considera LCA, ya que un nodo se considera descendiente de sí mismo
5. **Se puede implementar de forma iterativa sin recursión**: Dado que en cada paso solo se avanza en una dirección (izquierda o derecha), no se necesita la pila de llamadas de la recursión. Basta con actualizar el nodo actual en un bucle while, lo que permite lograr una complejidad espacial de O(1)

## Conocimientos previos

### Qué es un árbol binario de búsqueda (BST)

Un árbol binario en el que cada nodo cumple el orden "descendientes izquierdos < nodo < descendientes derechos". Gracias a esta propiedad, se puede determinar a qué subárbol pertenece un nodo simplemente comparando los valores.

```
        6
       / \
      2    8
     / \  / \
    0   4 7   9
```

En este árbol, el LCA de los nodos 2 y 8 es 6. El LCA de los nodos 2 y 4 es 2 (el nodo 2 también es descendiente de sí mismo).

### Qué es el ancestro común más bajo (LCA)

El nodo más profundo (el más lejano de la raíz) entre los ancestros comunes de dos nodos `p` y `q`. Si `p` o `q` es ancestro del otro, ese nodo mismo es el LCA.

### Estructura de TreeNode

Clase que representa cada nodo de un BST. Tiene un valor `val`, un hijo izquierdo `left` y un hijo derecho `right`.

```java
TreeNode node = new TreeNode(6);   // Se crea un nodo con valor 6
node.val;                           // Se obtiene el valor del nodo → 6
node.left;                          // Se obtiene el hijo izquierdo
node.right;                         // Se obtiene el hijo derecho
```

## Complejidad

| | Valor |
|---|---|
| Time | O(h) — Se recorre la altura del árbol. En un BST balanceado es O(log n) |
| Space | O(1) — No se usa memoria adicional gracias al procesamiento iterativo |

## Código

```java
// Entrada: nodo raíz del BST root, dos nodos p y q que existen en el árbol
// Salida: se devuelve el TreeNode correspondiente al ancestro común más bajo (LCA) de p y q
TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    // Se inicializa la posición de búsqueda actual en la raíz. Se actualiza en el bucle while
    TreeNode node = root;

    // Se repite la búsqueda mientras node no sea null
    while (node != null) {
        // Se verifica si tanto p como q son menores que el nodo actual
        if (p.val < node.val && q.val < node.val) {
            // Ambos están en el subárbol izquierdo, por lo que el LCA también está en el subárbol izquierdo
            node = node.left;
        // Se verifica si tanto p como q son mayores que el nodo actual
        } else if (p.val > node.val && q.val > node.val) {
            // Ambos están en el subárbol derecho, por lo que el LCA también está en el subárbol derecho
            node = node.right;
        } else {
            // p y q se separaron a izquierda y derecha (o uno de ellos es igual al nodo actual)
            // No es posible que ambos nodos estén en un único subárbol más profundo, por lo que el LCA queda determinado
            return node;
        }
    }
    // Según las restricciones del problema, p y q existen en el árbol, por lo que siempre se termina en el return anterior y nunca se llega aquí
    return null;
}
```
