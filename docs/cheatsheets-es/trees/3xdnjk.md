# Checking if a Binary Tree is Height-Balanced — Determinar si un árbol binario está equilibrado en altura

## Esencia del problema

Se recibe el nodo raíz `root` de un árbol binario. Se debe determinar si el árbol está **equilibrado en altura (height-balanced)**. Un árbol está equilibrado en altura cuando, para todos los nodos, la diferencia entre la altura del subárbol izquierdo y la altura del subárbol derecho es como máximo 1. Se devuelve el resultado como `boolean`.

## Idea central

Durante el proceso recursivo que calcula la altura de cada nodo, se devuelve y propaga el valor `-1` en el instante en que se detecta un desequilibrio. Al realizar el cálculo de la altura y la verificación del equilibrio simultáneamente en un único recorrido en postorden (post-order traversal), se obtiene la respuesta visitando cada nodo una sola vez.

## Proceso de razonamiento

1. **Interpretar la definición de equilibrio de forma recursiva**: Que un árbol esté equilibrado significa que, en todos los nodos, la diferencia de altura entre los subárboles izquierdo y derecho es como máximo 1. Es decir, para verificar el equilibrio de un nodo se necesita la "altura" de ambos subárboles
2. **El cálculo de la altura es en sí mismo recursivo**: La altura de un nodo se obtiene como `1 + max(altura izquierda, altura derecha)`. Al recorrer el árbol de abajo hacia arriba (en postorden) con esta recursión, la altura de cada nodo se obtiene de forma natural
3. **Integrar el cálculo de la altura y la verificación del equilibrio**: Dentro de la función recursiva que devuelve la altura, se devuelve el valor especial `-1` que indica "desequilibrio" en cuanto la diferencia de alturas supera 1. De esta forma, el cálculo de la altura y la verificación del equilibrio se realizan simultáneamente en una sola función
4. **Eliminar exploraciones innecesarias mediante terminación anticipada**: Si el resultado del subárbol izquierdo es `-1`, el árbol completo está desequilibrado sin necesidad de examinar el subárbol derecho. Se comprueba en cada paso si el valor de retorno de la recursión es `-1`, y en cuanto se encuentra un desequilibrio se devuelve `-1` inmediatamente para interrumpir la recursión
5. **Aprovechar el doble significado del valor de retorno**: Si el valor de retorno es `0 o mayor`, representa una altura válida; si es `-1`, indica desequilibrio. El método `isBalanced` que realiza la llamada solo necesita verificar si el valor final es distinto de `-1` para obtener la respuesta

## Conocimientos previos

### Qué es la altura (height) de un árbol binario

Es el número de aristas desde un nodo hasta el nodo hoja más lejano. La altura de un nodo hoja es 1 (cuando se cuenta por número de nodos), y la altura de `null` es 0. De forma recursiva se obtiene como `height(node) = 1 + max(height(node.left), height(node.right))`.

```
        1           Altura del nodo 1: 3
       / \          Altura del nodo 2: 2
      2   3         Altura del nodo 4: 1
     /              Altura del nodo 3: 1
    4
```

### Qué es el recorrido en postorden (Post-Order Traversal)

Es un método de recorrido que procesa los nodos en el orden: subárbol izquierdo → subárbol derecho → nodo actual. Dado que primero se determina la información de los hijos antes de procesar el padre, es adecuado para procesos de agregación de abajo hacia arriba, como "calcular la altura del padre utilizando la altura de los hijos".

```java
void postOrder(TreeNode node) {
    if (node == null) return;
    postOrder(node.left);   // Se procesa primero el subárbol izquierdo
    postOrder(node.right);  // Se procesa después el subárbol derecho
    // Aquí se procesa el propio nodo (los resultados izquierdo y derecho ya están determinados)
}
```

### Qué es Math.abs

Es un método estándar de Java que devuelve el valor absoluto de un entero. Se utiliza para verificar si la diferencia de alturas entre los subárboles izquierdo y derecho es como máximo 1, independientemente de si el resultado es positivo o negativo.

```java
Math.abs(3 - 1);    // → 2
Math.abs(1 - 3);    // → 2
Math.abs(2 - 3);    // → 1
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Se visita cada nodo exactamente una vez |
| Space | O(n) — La pila de llamadas recursivas alcanza como máximo n niveles (cuando el árbol está desbalanceado) |

## Código

```java
// Entrada: nodo raíz root de un árbol binario
// Salida: devuelve true si el árbol está equilibrado en altura, false en caso contrario

// Función recursiva que devuelve la altura de un nodo. Devuelve el valor centinela -1 si detecta desequilibrio
// Si el valor de retorno es 0 o mayor, representa una altura válida; -1 significa "algún subárbol está desequilibrado"
private int checkHeight(TreeNode node) {
    // Caso base: null representa un subárbol vacío con altura 0
    if (node == null) return 0;

    // Se obtiene recursivamente la altura del subárbol izquierdo (parte "primero el izquierdo" del recorrido en postorden)
    int left = checkHeight(node.left);
    // Si el subárbol izquierdo está desequilibrado, se propaga -1 inmediatamente sin examinar el subárbol derecho (terminación anticipada)
    if (left == -1) return -1;

    // Se obtiene recursivamente la altura del subárbol derecho (parte "después el derecho" del recorrido en postorden)
    int right = checkHeight(node.right);
    // Si el subárbol derecho está desequilibrado, se propaga -1 inmediatamente
    if (right == -1) return -1;

    // Si en el nodo actual la diferencia de alturas supera 1, hay desequilibrio (parte "procesamiento del propio nodo" del recorrido en postorden)
    // Se usa Math.abs para verificar correctamente la diferencia sin importar cuál subárbol es más alto
    if (Math.abs(left - right) > 1)
        return -1;

    // Si está equilibrado, se devuelve la altura del nodo actual. Se utilizará en el cálculo del nodo padre
    return 1 + Math.max(left, right);
}

public boolean isBalanced(TreeNode root) {
    // Si checkHeight no devuelve -1, el árbol completo está equilibrado
    // -1 es un valor centinela que indica "algún subárbol está desequilibrado"
    return checkHeight(root) != -1;
}
```
