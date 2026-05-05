# Checking if Two Binary Trees Are Identical — Determinar si dos árboles binarios son idénticos en estructura y valores

## Esencia del problema

Se dan dos árboles binarios `p` y `q`. Se dice que dos árboles son "idénticos" cuando sus estructuras coinciden completamente y los valores de todos los nodos correspondientes son iguales. Se debe devolver `true` si son idénticos y `false` en caso contrario.

## Idea central

Se insertan los nodos correspondientes de ambos árboles como "pares" en una cola y se extraen de uno en uno en orden por niveles para compararlos. Si la estructura y el valor coinciden en todos los pares, los árboles son idénticos; si se encuentra al menos una discrepancia, se determina de inmediato que no son idénticos.

## Proceso de razonamiento

1. **Basta con comparar los nodos correspondientes entre sí**: Para determinar si dos árboles son idénticos, se comparan uno a uno los nodos que ocupan la misma posición en ambos árboles. Si los valores coinciden en todos los pares y la estructura (presencia o ausencia de hijos) también coincide, los dos árboles son idénticos
2. **Cómo gestionar los pares**: Es necesario gestionar los pares de nodos a comparar en el orden correcto. Utilizando una cola (FIFO), se pueden extraer y comparar los pares nivel por nivel en orden de amplitud. La cola almacena arreglos `TreeNode[]` de 2 elementos, donde `pair[0]` representa el nodo del árbol p y `pair[1]` representa el nodo del árbol q
3. **Qué se determina al extraer un par**: Para cada par extraído se evalúan tres casos en orden. (a) Si ambos son null, la estructura coincide en esa posición y se avanza al siguiente par. (b) Si solo uno es null, la estructura difiere y se devuelve `false`. (c) Si ambos son no null pero los valores difieren, se devuelve `false`
4. **Si el par pasa la evaluación, se añaden los pares de nodos hijos a la cola**: Cuando el par actual coincide, lo siguiente a comparar son los hijos izquierdos entre sí y los hijos derechos entre sí. Se añaden a la cola los dos pares `{n1.left, n2.left}` y `{n1.right, n2.right}`. Se pueden añadir incluso si los hijos son null (la evaluación de null del paso 3 los procesará correctamente)
5. **Si la cola se vacía, todos los pares coincidieron**: Si se terminan de comparar todos los pares sin encontrar discrepancias, los dos árboles son idénticos y se devuelve `true`

## Conocimientos previos

### Qué es una Queue (cola)

Es una estructura de datos de tipo primero en entrar, primero en salir (FIFO). El primer elemento añadido es el primero en ser extraído. Se utiliza en la búsqueda en amplitud para procesar los nodos nivel por nivel. En Java, se implementa la interfaz `Queue` con `LinkedList`.

```java
Queue<TreeNode[]> queue = new LinkedList<>();  // Crear una cola que almacena arreglos de TreeNode
queue.add(new TreeNode[]{p, q});               // Añadir un par (arreglo de 2 elementos) al final de la cola
TreeNode[] pair = queue.poll();                 // Extraer y devolver el par del frente de la cola (devuelve null si la cola está vacía)
queue.isEmpty();                               // Devolver un boolean indicando si la cola está vacía → true/false
```

### Qué es un TreeNode (nodo de árbol binario)

Es una clase que representa cada nodo de un árbol binario. El campo `val` contiene el valor del nodo, y los campos `left` y `right` contienen referencias al nodo hijo izquierdo y al nodo hijo derecho respectivamente. Si un hijo no existe, su valor es `null`.

```java
TreeNode node = new TreeNode(5);   // Crear un nodo con valor 5
node.val;                          // Obtener el valor del nodo → 5
node.left;                         // Obtener el nodo hijo izquierdo (null si no existe)
node.right;                        // Obtener el nodo hijo derecho (null si no existe)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Se compara cada nodo de ambos árboles como máximo una vez, hasta n nodos |
| Space | O(n) — La cola almacena un número de pares proporcional al número de nodos |

## Código

```java
// Entrada: los nodos raíz p y q de dos árboles binarios
// Salida: devuelve true si los dos árboles son idénticos en estructura y valores, false en caso contrario
public boolean isSameTree(TreeNode p, TreeNode q) {
    // Crear una cola para gestionar los pares de nodos a comparar
    // Cada par se almacena como un arreglo TreeNode[] de 2 elementos, donde pair[0] es el nodo del árbol p y pair[1] es el nodo del árbol q
    Queue<TreeNode[]> queue = new LinkedList<>();
    // Como estado inicial, añadir a la cola el par de nodos raíz de ambos árboles (el primer par a comparar)
    queue.add(new TreeNode[]{p, q});

    // Mientras la cola no esté vacía, extraer y comparar los pares uno a uno
    while (!queue.isEmpty()) {
        // Extraer el par del frente de la cola
        TreeNode[] pair = queue.poll();
        TreeNode n1 = pair[0];
        TreeNode n2 = pair[1];

        // Si ambos son null, en esta posición ninguno de los dos árboles tiene un hijo, por lo que la estructura coincide. Se avanza al siguiente par
        if (n1 == null && n2 == null)
            continue;
        // Si solo uno es null, un árbol tiene un nodo en esta posición y el otro no, por lo que la estructura difiere
        if (n1 == null || n2 == null)
            return false;
        // Si los valores difieren, los valores de los nodos correspondientes no coinciden y se devuelve false
        if (n1.val != n2.val)
            return false;

        // El par actual coincide, así que se añaden a la cola los pares de nodos hijos a comparar a continuación
        // Se añaden incluso si los hijos son null (la evaluación de null anterior los procesará correctamente)
        queue.add(new TreeNode[]{n1.left, n2.left});
        queue.add(new TreeNode[]{n1.right, n2.right});
    }
    // Todos los pares coincidieron en estructura y valores, por lo que se devuelve true
    return true;
}
```
