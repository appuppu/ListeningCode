# Serializing and Deserializing a Binary Tree — Convertir un árbol binario en una cadena de texto y restaurar la estructura original del árbol

## Esencia del problema

Se debe diseñar un algoritmo que serialice un árbol binario en una cadena de texto y que deserialice esa cadena para reconstruir el árbol binario original. El viaje de ida y vuelta debe ser sin pérdidas — el árbol restaurado debe ser completamente idéntico al árbol original.

## Idea central

Al serializar el árbol mediante un recorrido Preorder (preorden), la estructura "hijo izquierdo → hijo derecho" de cada nodo se registra recursivamente. Si se registran explícitamente los valores null como valores centinela, durante la deserialización basta con consumir los tokens en orden desde el inicio para restaurar de forma única y recursiva la estructura original del árbol.

## Proceso de razonamiento

1. **Qué se necesita para restaurar de forma única la estructura del árbol**: Para determinar de forma única la estructura de un árbol binario, se necesita la información de si cada nodo tiene o no hijos. Si se registran explícitamente las posiciones de null, se puede reproducir de forma única la estructura del árbol con un solo orden de recorrido
2. **Razón por la que el recorrido Preorder es adecuado**: Preorder visita los nodos en el orden "raíz → subárbol izquierdo → subárbol derecho". Como la raíz aparece primero, durante la deserialización se pueden generar los nodos recursivamente mientras se consumen los tokens desde el inicio. La implementación resulta natural porque el orden de recorrido coincide con el orden de generación de nodos
3. **Registrar null como valor centinela**: Cuando un nodo es null, se registra la cadena `"null"`. De esta manera, durante la deserialización se puede determinar el límite donde "aquí termina un subárbol". Sin el centinela, no sería posible identificar el final de un subárbol
4. **Formato de la serialización**: Los valores de cada nodo se concatenan separados por comas. El formato es como `"1,2,null,null,3,4,null,null,5,null,null"`. Al hacer split por comas se obtiene un arreglo de tokens
5. **La deserialización consume tokens recursivamente**: Se extrae (poll) un token a la vez desde el inicio de la lista de tokens. Si el valor extraído es `"null"`, se retorna null; de lo contrario, se crea un nodo y se construyen recursivamente el hijo izquierdo y el hijo derecho. Usando LinkedList, la extracción desde el inicio se realiza en O(1)
6. **El orden de la recursión coincide con Preorder**: El orden Preorder durante la serialización (raíz → izquierdo → derecho) y el orden de las llamadas recursivas durante la deserialización (generar nodo → hijo izquierdo → hijo derecho) coinciden completamente, por lo que el árbol correcto se restaura simplemente consumiendo los tokens en orden

## Conocimientos previos

### Qué es el recorrido Preorder (preorden)

Es un método de recorrido que visita recursivamente un árbol binario en el orden "raíz → subárbol izquierdo → subárbol derecho". Como la raíz se procesa primero, el inicio de los datos serializados siempre corresponde al nodo raíz.

```java
void preorder(TreeNode node) {
    if (node == null) return;
    visit(node);           // Primero se procesa la raíz
    preorder(node.left);   // Luego se procesa recursivamente el subárbol izquierdo
    preorder(node.right);  // Por último se procesa recursivamente el subárbol derecho
}
```

### Qué es StringBuilder

Es una clase para concatenar cadenas de texto de forma eficiente. La concatenación de cadenas con el operador `+` genera un nuevo objeto String cada vez, lo que resulta en O(n²), pero StringBuilder añade al búfer interno, por lo que se realiza en O(n).

```java
StringBuilder sb = new StringBuilder();  // Crear un StringBuilder vacío
sb.append("hello");                      // Añadir una cadena al final
sb.append(",");                          // Añadir una coma
sb.deleteCharAt(sb.length() - 1);        // Eliminar el último carácter
sb.toString();                           // Convertir a String → "hello"
```

### LinkedList y el método poll

LinkedList es una estructura de datos que permite añadir y eliminar elementos al inicio y al final en O(1). El método `poll()` extrae y devuelve el primer elemento de la lista (eliminándolo de la lista). Si la lista está vacía, devuelve null.

```java
LinkedList<String> tokens = new LinkedList<>(Arrays.asList("1", "2", "null"));
tokens.poll();  // Devuelve "1" y lo elimina de la lista. Resto: ["2", "null"]
tokens.poll();  // Devuelve "2" y lo elimina de la lista. Resto: ["null"]
```

### Qué es un valor centinela

Es un valor especial que se utiliza para indicar el final de los datos o un estado especial. En este problema, se usa la cadena `"null"` como centinela para expresar que "en esta posición no existe un nodo hijo". Gracias al centinela, durante la deserialización se pueden determinar con precisión los límites de los subárboles.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Se visita cada uno de los n nodos exactamente una vez |
| Space | O(n) — Se utiliza espacio para n elementos en la cadena serializada y la lista de tokens. La pila de llamadas recursivas es O(n) en el peor caso (cuando el árbol está sesgado) |

## Código

```java
// Entrada: Serialización — nodo raíz root del árbol binario. Deserialización — cadena data separada por comas
// Salida: Serialización — cadena separada por comas que representa el árbol. Deserialización — nodo raíz del árbol binario original

// Serializar el árbol binario en una cadena de texto
public String serialize(TreeNode root) {
    // Búfer para acumular los valores de todos los nodos del árbol separados por comas
    StringBuilder sb = new StringBuilder();
    // Recorrer el árbol en orden Preorder y añadir los valores al StringBuilder
    serHelper(root, sb);
    // Eliminar la coma sobrante al final
    if (sb.length() > 0)
        sb.deleteCharAt(sb.length() - 1);
    return sb.toString();
}

// Recorrer el árbol en orden Preorder y añadir el valor de cada nodo al StringBuilder
void serHelper(TreeNode node, StringBuilder sb) {
    // Los nodos null se registran como el valor centinela "null" (para determinar el final del subárbol durante la deserialización)
    if (node == null) {
        sb.append("null,");
        return;
    }
    // Registrar el valor del nodo actual (en Preorder, la raíz se procesa primero)
    // Cada valor se separa por comas
    sb.append(node.val).append(",");
    // Procesar recursivamente el subárbol izquierdo
    serHelper(node.left, sb);
    // Procesar recursivamente el subárbol derecho (el orden raíz → izquierdo → derecho realiza el recorrido Preorder)
    serHelper(node.right, sb);
}

// Deserializar una cadena de texto para reconstruir el árbol binario
public TreeNode deserialize(String data) {
    // Una cadena vacía representa un árbol vacío
    if (data.isEmpty()) return null;
    // Dividir por comas y convertir a LinkedList (porque se necesita poll() que extrae desde el inicio en O(1))
    LinkedList<String> tokens =
        new LinkedList<>(Arrays.asList(data.split(",")));
    // Generar nodos recursivamente mientras se consumen los tokens desde el inicio
    return desHelper(tokens);
}

// Generar nodos recursivamente mientras se consumen los tokens desde el inicio
TreeNode desHelper(LinkedList<String> tokens) {
    // Extraer el token del inicio (poll elimina el elemento de la lista, por lo que en la siguiente recursión el siguiente token estará al inicio)
    String val = tokens.poll();
    // Si es un valor centinela, se retorna null y se termina la recursión (el hijo del nodo padre se establece como null)
    if (val.equals("null")) return null;
    // Convertir el valor del token a entero y crear un nuevo nodo
    TreeNode node = new TreeNode(Integer.parseInt(val));
    // Siguiendo el orden Preorder, se construye primero el hijo izquierdo (como coincide con el orden de serialización, los tokens correctos se corresponden)
    node.left = desHelper(tokens);
    // Luego se construye el hijo derecho
    node.right = desHelper(tokens);
    // Retornar el nodo construido (el valor de retorno de la primera llamada es el nodo raíz = el árbol completo restaurado)
    return node;
}
```
