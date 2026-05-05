# Constructing a Binary Tree From Traversal Orders — Reconstruir el árbol binario original a partir del recorrido en preorden y en inorden

## Esencia del problema

Se proporcionan dos arreglos de enteros: `preorder` (recorrido en preorden) e `inorder` (recorrido en inorden). A partir de estos dos resultados de recorrido, se debe construir y devolver el árbol binario original. El recorrido en preorden ordena los elementos en el orden "raíz → izquierda → derecha", y el recorrido en inorden los ordena en el orden "izquierda → raíz → derecha".

## Idea central

El primer elemento del recorrido en preorden siempre es la raíz del subárbol actual. Al encontrar la posición de esa raíz en el recorrido en inorden, se puede dividir el recorrido en inorden en "elementos del subárbol izquierdo" y "elementos del subárbol derecho". Al repetir esta división de forma recursiva, se puede reconstruir el árbol completo.

## Proceso de razonamiento

1. **El primer elemento del recorrido en preorden es la raíz**: El recorrido en preorden ordena los elementos en el orden "raíz → izquierda → derecha", por lo que el primer elemento del arreglo siempre es el nodo raíz del árbol completo. Esta propiedad se cumple recursivamente también para los subárboles
2. **Si se conoce la posición de la raíz en el recorrido en inorden, se pueden separar los subárboles izquierdo y derecho**: El recorrido en inorden sigue el orden "izquierda → raíz → derecha", por lo que si el valor de la raíz se encuentra en la posición `mid` del recorrido en inorden, todos los elementos a la izquierda de `mid` pertenecen al subárbol izquierdo y todos los elementos a la derecha de `mid` pertenecen al subárbol derecho
3. **Se desea obtener la posición de la raíz de forma eficiente**: Si se realiza una búsqueda lineal en el recorrido en inorden cada vez, el costo total es O(n²). Si se registra previamente en un HashMap la correspondencia "valor → índice en el recorrido en inorden", se puede obtener la posición de la raíz en O(1)
4. **Representar el rango del subárbol mediante índices de frontera en lugar de copiar arreglos**: Si se copia el arreglo en cada llamada recursiva, se necesita O(n²) de espacio. Al representar el rango del recorrido en inorden con dos índices, `inLeft` e `inRight`, se puede especificar el rango del subárbol sin copiar arreglos
5. **Avanzar el puntero del recorrido en preorden de forma global**: El recorrido en preorden está ordenado como "raíz → subárbol izquierdo completo → subárbol derecho completo", por lo que si se prepara un puntero global `preIdx` y se incrementa cada vez que se extrae una raíz, cuando la recursión del subárbol izquierdo termine, el puntero apuntará naturalmente a la raíz del subárbol derecho
6. **Construir primero el subárbol izquierdo**: El orden del recorrido en preorden es "raíz → izquierda → derecha", por lo que después de extraer la raíz, siempre se debe construir recursivamente primero el subárbol izquierdo y luego el subárbol derecho. Al respetar este orden, `preIdx` avanza correctamente

## Conocimientos previos

### Qué es el recorrido en preorden (Preorder Traversal)

Es un método de recorrido que visita un árbol binario en el orden "raíz → subárbol izquierdo → subárbol derecho". El primer elemento del arreglo siempre es el valor del nodo raíz.

```
        3
       / \
      9   20
         / \
        15   7

Recorrido en preorden: [3, 9, 20, 15, 7]  ← El 3 al inicio es la raíz
```

### Qué es el recorrido en inorden (Inorder Traversal)

Es un método de recorrido que visita un árbol binario en el orden "subárbol izquierdo → raíz → subárbol derecho". Tomando el valor de la raíz como referencia, los elementos a la izquierda pertenecen al subárbol izquierdo y los elementos a la derecha pertenecen al subárbol derecho.

```
Recorrido en inorden: [9, 3, 15, 20, 7]  ← [9] a la izquierda del 3 es el subárbol izquierdo, [15,20,7] a la derecha es el subárbol derecho
```

### Qué es un HashMap

Es una estructura de datos que almacena pares de clave y valor. Permite buscar y obtener valores especificando la clave en O(1).

```java
HashMap<Integer, Integer> map = new HashMap<>();  // Crear un HashMap vacío
map.put(3, 1);           // Almacenar el valor 1 con la clave 3
map.get(3);              // Devolver el valor correspondiente a la clave 3 → 1
```

### Qué es un TreeNode

Es una clase que representa un nodo de un árbol binario. Tiene un valor `val`, un hijo izquierdo `left` y un hijo derecho `right`.

```java
TreeNode root = new TreeNode(3);    // Crear un nodo con el valor 3
root.left = new TreeNode(9);        // Establecer un nodo con el valor 9 como hijo izquierdo
root.right = new TreeNode(20);      // Establecer un nodo con el valor 20 como hijo derecho
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Se procesa cada nodo una sola vez, y la búsqueda mediante HashMap se realiza en O(1) |
| Space | O(n) — Se almacenan n elementos en el HashMap, y la pila de recursión es O(n) en el peor caso (cuando el árbol está sesgado) |

## Código

```java
// Entrada: arreglo de enteros preorder (recorrido en preorden) y arreglo de enteros inorder (recorrido en inorden)
// Salida: devolver el nodo raíz TreeNode del árbol binario reconstruido

// HashMap que almacena clave=valor del recorrido en inorden, valor=índice de ese valor en el recorrido en inorden
// Se utiliza para obtener en O(1) la posición en el recorrido en inorden a partir del valor de la raíz
Map<Integer, Integer> map = new HashMap<>();
// Puntero global que señala "la posición de la siguiente raíz a extraer" en el arreglo del recorrido en preorden
// Se incrementa y avanza con cada llamada recursiva
int preIdx = 0;

public TreeNode buildTree(int[] preorder, int[] inorder) {
    // Registrar cada valor y su índice del recorrido en inorden en el HashMap
    // Esto permite consultar de inmediato en qué posición del recorrido en inorden se encuentra cualquier valor
    for (int i = 0; i < inorder.length; i++)
        map.put(inorder[i], i);

    // Iniciar la recursión especificando el rango completo del arreglo (inLeft=0, inRight=último índice)
    return helper(preorder, 0, inorder.length - 1);
}

// inLeft e inRight representan el rango del subárbol actual dentro del arreglo del recorrido en inorden
TreeNode helper(int[] preorder, int inLeft, int inRight) {
    // Si el rango del subárbol está vacío (inLeft > inRight), no existe ningún nodo hijo
    if (inLeft > inRight) return null;

    // Extraer el valor de la raíz de la posición actual del recorrido en preorden y avanzar el puntero
    int rootVal = preorder[preIdx++];
    TreeNode root = new TreeNode(rootVal);

    // Obtener del HashMap la posición del valor de la raíz en el recorrido en inorden
    // mid indica la frontera entre el subárbol izquierdo y el subárbol derecho en el recorrido en inorden
    int mid = map.get(rootVal);

    // Nota: el recorrido en preorden está ordenado como "raíz → izquierda → derecha", por lo que siempre se debe construir primero el subárbol izquierdo
    // Este orden permite que preIdx apunte correctamente a la raíz del subárbol derecho
    // El rango del subárbol izquierdo va desde inLeft hasta mid-1 en el recorrido en inorden
    root.left = helper(preorder, inLeft, mid - 1);
    // El rango del subárbol derecho va desde mid+1 hasta inRight en el recorrido en inorden
    root.right = helper(preorder, mid + 1, inRight);

    // Devolver el nodo root construido. Cuando toda la recursión se completa, se devuelve el nodo raíz del árbol completo
    return root;
}
```
