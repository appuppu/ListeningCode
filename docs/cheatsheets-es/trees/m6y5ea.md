# Finding the Maximum Path Sum in a Binary Tree — Encontrar la suma máxima de cualquier camino en un árbol binario

## Esencia del problema

Se da un árbol binario. Cada nodo tiene un valor entero (que puede ser negativo). Entre todos los caminos posibles que conectan nodos mediante aristas (cada nodo se puede usar como máximo una vez), se debe encontrar el camino cuya suma de valores de nodos sea la máxima y devolver esa **suma**. El camino no necesita pasar por la raíz; puede ir desde cualquier nodo hasta cualquier otro nodo.

## Idea central

En cada nodo se calcula la "ganancia máxima obtenible desde los descendientes izquierdos" y la "ganancia máxima obtenible desde los descendientes derechos", y la suma del camino que une izquierda y derecha pasando por ese nodo como vértice se considera candidata al máximo global. Por otro lado, el valor que se devuelve al padre solo elige una de las dos ramas (porque un camino no puede bifurcarse).

## Proceso de razonamiento

1. **Considerar la estructura del camino**: En cualquier camino existe exactamente un nodo que se encuentra en la posición más alta (el vértice). Desde la perspectiva de ese nodo, el camino se compone de tres partes: "la parte que desciende hacia los descendientes izquierdos", "el propio nodo" y "la parte que desciende hacia los descendientes derechos". Se prueba cada nodo como vértice y se busca la suma máxima del camino
2. **Definir la ganancia (gain) en cada nodo**: La suma máxima que se puede llevar hacia el padre desde el subárbol con raíz en un nodo se llama "ganancia". La ganancia se calcula como "el valor del nodo + la ganancia del hijo mayor entre izquierdo y derecho". Como el camino no puede bifurcarse, no se pueden devolver ambos lados al padre simultáneamente
3. **Tratar la ganancia negativa como 0**: Si la ganancia de un hijo es negativa, incluir esa rama reduce la suma del camino. Por eso se usa `Math.max(0, gain)` para elevar la ganancia negativa a 0 (no usar esa rama). Esto permite representar de forma natural caminos que consisten en un solo nodo o que solo usan una rama
4. **Gestionar el máximo global por separado**: La expresión "ganancia izquierda + valor del nodo + ganancia derecha" en cada nodo como vértice es la suma máxima del camino que pasa por ese nodo. Este valor se compara y actualiza con la variable global `maxSum`. Como es un cálculo diferente a la ganancia que se devuelve al padre, se debe gestionar de forma independiente
5. **Calcular con DFS en postorden (postorder DFS)**: Como se necesita conocer la ganancia de los hijos antes de calcular la del nodo actual, el DFS en postorden que procesa en orden izquierdo→derecho→propio nodo es adecuado. Esto permite probar todos los nodos como vértice en un solo recorrido
6. **Qué se devuelve finalmente**: Después de completar el DFS, `maxSum` contiene la suma máxima del camino encontrada al probar todos los nodos como vértice. Se devuelve este valor

## Conocimientos previos

### Qué es el DFS en postorden (Postorder DFS) de un árbol binario

Es un método de recorrido que visita recursivamente el árbol binario en el orden "hijo izquierdo → hijo derecho → propio nodo". Es adecuado cuando se necesitan los resultados del cálculo de los hijos para realizar el cálculo del padre.

```java
void postorder(TreeNode node) {
    if (node == null) return;     // Caso base: si es null, no se hace nada
    postorder(node.left);         // Se procesa primero el subárbol izquierdo
    postorder(node.right);        // Se procesa después el subárbol derecho
    // Aquí se procesa el propio nodo (los resultados de los hijos ya están determinados)
}
```

### Qué es Math.max

Es un método estándar de Java que devuelve el mayor de dos valores. Se usa para elevar ganancias negativas a 0 y para comparar las ganancias izquierda y derecha.

```java
Math.max(0, -5);    // → 0 (se eleva el valor negativo a 0)
Math.max(3, 7);     // → 7 (se devuelve el mayor)
Math.max(0, gain(node.left));  // Si la ganancia del hijo izquierdo es negativa, se convierte en 0
```

### Qué es Integer.MIN_VALUE

Es el valor mínimo que puede tener el tipo `int` de Java (-2,147,483,648). Se usa como valor inicial en algoritmos que buscan el máximo. Se garantiza que cualquier valor con el que se compare provocará una actualización.

```java
int maxSum = Integer.MIN_VALUE;  // Valor inicial menor que cualquier suma de camino
maxSum = Math.max(maxSum, 10);   // → 10 (en la primera comparación siempre se actualiza)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Se realiza un DFS que visita cada nodo exactamente una vez |
| Space | O(n) — La pila de llamadas recursivas alcanza n niveles en el peor caso (árbol degenerado) |

## Código

```java
// Entrada: nodo raíz root del árbol binario (cada nodo tiene un valor entero val, hijo izquierdo left e hijo derecho right)
// Salida: se devuelve como int la suma máxima de cualquier camino en el árbol binario
class Solution {
    // Se registra la suma máxima del camino encontrada al probar todos los nodos como vértice
    // Se inicializa con Integer.MIN_VALUE para que sea menor que cualquier camino con valores negativos y se actualice en la primera comparación
    int maxSum = Integer.MIN_VALUE;

    // Función recursiva que devuelve la ganancia máxima que se puede llevar hacia el padre desde un nodo (se calcula en postorden DFS: hijos → padre)
    int gain(TreeNode node) {
        // Caso base: la ganancia de un nodo null es 0 (de un hijo inexistente no se obtiene nada)
        if (node == null) return 0;

        // Se obtiene la ganancia del hijo izquierdo y si es negativa se eleva a 0 (se elige no usar una rama negativa porque reduciría la suma del camino)
        int leftGain = Math.max(0, gain(node.left));
        // Se obtiene la ganancia del hijo derecho y de igual forma si es negativa se eleva a 0
        int rightGain = Math.max(0, gain(node.right));

        // Se actualiza el máximo global con la suma del camino que une izquierda y derecha pasando por el nodo actual como vértice
        // Este valor representa la suma del camino "descendientes izquierdos → nodo actual → descendientes derechos"
        // Si leftGain o rightGain es 0, significa un camino con solo una rama o un camino de un solo nodo
        maxSum = Math.max(maxSum, node.val + leftGain + rightGain);

        // La ganancia que se devuelve al padre es solo la rama mayor entre izquierda y derecha
        // El camino debe ser continuo como un trazo sin levantar el lápiz y no puede bifurcarse en un nodo, por lo que no se pueden devolver ambas ramas
        return node.val + Math.max(leftGain, rightGain);
    }

    int maxPathSum(TreeNode root) {
        // Se inicia el DFS recursivo desde la raíz, probando todos los nodos como vértice
        gain(root);
        // Después de completar el DFS, maxSum contiene la suma máxima entre todos los caminos probados con cada nodo como vértice
        return maxSum;
    }
}
```
