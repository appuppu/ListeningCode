# Checking if a Tree is a Subtree of Another — Determinar si un árbol está contenido como subárbol de otro

## Esencia del problema

Se proporcionan dos árboles binarios `root` y `subRoot`. Se debe devolver un `boolean` que indique si existe dentro de `root` un subárbol que coincida completamente en estructura y valores con `subRoot`. Un subárbol significa que, al tomar un nodo de `root` como raíz, el árbol completo desde ese nodo hacia abajo es idéntico a `subRoot`.

## Idea central

Si se serializa un árbol en una cadena mediante un recorrido en preorden con marcadores null, la determinación de subárbol se reduce a un problema de búsqueda de cadenas: verificar si una cadena está contenida dentro de otra.

## Proceso de razonamiento

1. **La verificación de coincidencia de subárboles es una "comparación de forma y valores del árbol completo"**: Para que sea un subárbol, la estructura desde un nodo hacia abajo y los valores de todos los nodos deben coincidir completamente. Es decir, se necesita un método que preserve la información de la forma del árbol y luego realice la comparación
2. **Si se puede representar un árbol de forma única, la comparación se vuelve sencilla**: Con la estructura de árbol tal cual, la comparación requiere un recorrido recursivo nodo por nodo. Si se serializa el árbol en una cadena, la comparación de estructura y valores se transforma en una comparación de cadenas, lo cual se puede procesar eficientemente
3. **Se garantiza la unicidad agregando marcadores null al recorrido en preorden**: Solo con el recorrido en preorden, árboles diferentes pueden generar la misma cadena. Al insertar un marcador como `#` en las posiciones donde un hijo es null, se puede codificar la estructura del árbol de forma única
4. **Se agrega un separador de coma antes del valor de cada nodo**: Para delimitar claramente los valores de cada nodo, se añade una coma `,` antes del valor. Esto evita que, por ejemplo, el valor `2` y el valor `12` se confundan entre sí
5. **La determinación de subárbol se reduce a la verificación de contención de cadenas**: Si la cadena serializada de `subRoot` está contenida como subcadena dentro de la cadena serializada de `root`, entonces `subRoot` es un subárbol de `root`. Con `String.contains()` de Java se puede realizar la verificación en O(m+n)

## Conocimientos previos

### Qué es el recorrido en preorden de un árbol binario (Preorder Traversal)

Es un método de recorrido que visita los nodos del árbol en el orden "raíz → hijo izquierdo → hijo derecho". Al implementarlo con recursión, primero se procesa el nodo actual, luego se procesa recursivamente el subárbol izquierdo y finalmente el subárbol derecho.

```java
void preorder(TreeNode node) {
    if (node == null) return;
    System.out.println(node.val);  // Procesar la raíz
    preorder(node.left);           // Recorrer recursivamente el subárbol izquierdo
    preorder(node.right);          // Recorrer recursivamente el subárbol derecho
}
```

### Qué es StringBuilder

Es una clase para concatenar cadenas de forma eficiente. El operador `+` de `String` crea un nuevo objeto en cada concatenación, pero `StringBuilder` añade al búfer interno, permitiendo agregar en O(1).

```java
StringBuilder sb = new StringBuilder();  // Crear un StringBuilder vacío
sb.append(",5");                         // Agregar la cadena ",5" al final del búfer
sb.append(",#");                         // Agregar la cadena ",#" al final del búfer
sb.toString();                           // Convertir el contenido del búfer a tipo String → ",5,#"
```

### Qué es String.contains()

Es un método que devuelve un `boolean` indicando si una cadena contiene a otra cadena como subcadena.

```java
String s = ",1,2,#,#,3,#,#";
s.contains(",2,#,#");    // Verificar si s contiene ",2,#,#" → true
s.contains(",4,#,#");    // Verificar si s contiene ",4,#,#" → false
```

### Qué es un marcador null

Es un símbolo especial que se inserta en las posiciones donde un nodo hijo no existe (null) durante la serialización de un árbol. Se suele utilizar `#`. Sin marcadores null, árboles con estructuras diferentes pueden producir el mismo resultado de recorrido. Por ejemplo, los marcadores null son necesarios para distinguir un árbol que solo tiene hijo izquierdo de un árbol que solo tiene hijo derecho.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m + n) — Se recorre una vez cada árbol, root (m nodos) y subRoot (n nodos), para serializarlos, y luego se realiza la verificación de contención de cadenas |
| Space | O(m + n) — Se almacenan los resultados de serialización de los dos árboles en StringBuilder |

## Código

```java
// Entrada: los nodos raíz de los árboles binarios root y subRoot
// Salida: devuelve true si subRoot es un subárbol de root, false en caso contrario

// Método auxiliar que serializa un árbol en una cadena mediante recorrido en preorden
void serialize(TreeNode node, StringBuilder sb) {
    if (node == null) {
        // Agregar el marcador null ",#" para indicar explícitamente que el nodo hijo no existe
        // Esto permite distinguir un árbol que solo tiene hijo izquierdo de uno que solo tiene hijo derecho
        sb.append(",#");
        return;
    }
    // Agregar una coma antes del valor para evitar ambigüedad en los límites de números como 2 y 12
    sb.append("," + node.val);
    // Serializar recursivamente el subárbol izquierdo
    serialize(node.left, sb);
    // Serializar recursivamente el subárbol derecho
    serialize(node.right, sb);
}

boolean isSubtree(TreeNode root, TreeNode subRoot) {
    // sb1 almacena el resultado de serialización de root, sb2 almacena el de subRoot
    StringBuilder sb1 = new StringBuilder();
    StringBuilder sb2 = new StringBuilder();

    // Serializar ambos árboles en cadenas mediante recorrido en preorden
    serialize(root, sb1);
    serialize(subRoot, sb2);

    // Si la cadena de root contiene la cadena de subRoot como subcadena, entonces es un subárbol
    return sb1.toString().contains(sb2.toString());
}
```
