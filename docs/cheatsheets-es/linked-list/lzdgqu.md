# Deep Copying a Linked List With Random Pointers — Crear una copia completa de una lista enlazada con punteros aleatorios

## Esencia del problema

Se proporciona una lista enlazada en la que cada nodo tiene, además del puntero `next`, un puntero `random` que apunta a cualquier nodo de la lista (o a null). El objetivo es crear y devolver una **copia profunda** (una réplica completamente independiente) de esta lista enlazada. El puntero `random` de cada nodo copiado debe apuntar al nodo correspondiente dentro de la lista copiada, no al nodo de la lista original.

## Idea central

Si se inserta cada nodo copiado inmediatamente después de su nodo original (entrelazado), el "siguiente nodo" del `random` del nodo original se convierte en el nodo correspondiente en el lado de la copia. Aprovechando esta relación estructural, se pueden establecer correctamente los punteros aleatorios en espacio O(1) sin necesidad de un HashMap.

## Proceso de razonamiento

1. **Lo difícil es establecer la correspondencia de los punteros random**: Si solo existiera el puntero `next`, bastaría con copiar los nodos en orden secuencial. Sin embargo, como `random` apunta a cualquier nodo arbitrario, se necesita un medio para conocer la correspondencia entre los nodos originales y los nodos copiados.
2. **Con un HashMap se resuelve en espacio O(n), pero ¿se puede lograr en O(1)?**: Almacenar la correspondencia nodo original → nodo copiado en un HashMap resuelve el problema, pero se plantea si es posible expresar la correspondencia utilizando la propia estructura de la lista sin emplear estructuras de datos adicionales.
3. **Insertar el nodo copiado inmediatamente después del nodo original**: Al insertar la copia A' justo después del nodo original A, se obtiene una estructura entrelazada `A → A' → B → B' → C → C'`. De este modo, para cualquier nodo original `X`, `X.next` siempre es su copia `X'`, y esta correspondencia queda incorporada en la propia estructura de la lista.
4. **Establecer los punteros random mediante la estructura entrelazada**: Cuando el `random` del nodo original `curr` apunta a otro nodo original `R`, el `random` del nodo copiado `curr.next` debe establecerse como la copia de `R`, es decir, `R.next`. En otras palabras, se puede configurar de forma uniforme con la expresión `curr.next.random = curr.random.next`.
5. **Separar las dos listas**: Después de establecer los punteros random, se extraen alternadamente los nodos de la lista entrelazada para separar la lista original y la lista copiada. También es necesario restaurar la lista original a su estado inicial.
6. **Se completa en tres pasadas**: La primera pasada inserta los nodos copiados, la segunda establece los punteros random y la tercera separa las listas. Cada pasada es O(n) y no se utilizan estructuras de datos adicionales, por lo que el espacio es O(1).

## Conocimientos previos

### Estructura de nodo de lista enlazada (con random)

Un nodo especial que, además del `next` de una lista enlazada convencional, posee un puntero `random` que apunta a cualquier nodo dentro de la lista. El puntero `random` también puede ser `null`.

```java
class Node {
    int val;
    Node next;      // Apunta al siguiente nodo (lista enlazada convencional)
    Node random;    // Apunta a cualquier nodo de la lista o a null

    Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
```

### Qué es una copia profunda

Consiste en crear una réplica completamente independiente del objeto original. Los nodos de la copia no deben hacer referencia a ningún nodo de la lista original. Todos los punteros (`next` y `random`) deben apuntar únicamente a nodos dentro de la lista copiada.

```java
// Copia superficial (incorrecto): copy.random apunta a un nodo de la lista original
copy.random = original.random;

// Copia profunda (correcto): copy.random apunta al nodo correspondiente en la copia
copy.random = originalToCopyMapping(original.random);
```

### Qué es el entrelazado (intercalación)

Consiste en colocar alternadamente los elementos de dos secuencias. En este problema, se insertan los nodos copiados entre los nodos de la lista original, creando la estructura `A → A' → B → B' → C → C'`. De este modo, la copia del nodo original `X` siempre es accesible mediante `X.next`.

```java
// Lista original:       A → B → C → null
// Después del entrelazado: A → A' → B → B' → C → C' → null
// La copia de A es accesible mediante A.next, la copia de B mediante B.next
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Se recorre la lista tres veces. Cada pasada es O(n), por lo que el total es O(3n) = O(n) |
| Space | O(1) — No se utilizan estructuras de datos adicionales aparte de los nodos copiados para la salida |

## Código

```java
// Entrada: nodo cabeza head de una lista enlazada con punteros random
// Salida: devuelve el nodo cabeza de la copia profunda de la lista de entrada
public Node copyRandomList(Node head) {
    // No hay nada que copiar en una lista vacía
    if (head == null) return null;

    // === Primera pasada: insertar un nodo copiado inmediatamente después de cada nodo original ===
    // Al finalizar esta pasada, se obtiene la estructura entrelazada A → A' → B → B' → C → C'
    Node curr = head;
    while (curr != null) {
        // Crear un nuevo nodo copiado con el mismo valor que el nodo original
        Node copy = new Node(curr.val);
        copy.next = curr.next;       // Establecer el siguiente de la copia como el siguiente del original
        curr.next = copy;            // Establecer el siguiente del original como la copia, insertándola justo después de curr
        curr = copy.next;            // copy.next es el siguiente nodo original. Avanzar al siguiente nodo original
    }

    // === Segunda pasada: establecer los punteros random aprovechando la estructura entrelazada ===
    curr = head;
    while (curr != null) {
        // curr.next es el nodo copiado, curr.random.next es el nodo copiado del destino de random
        // Si curr.random es null, el random de la copia también se deja como null
        curr.next.random =
            curr.random != null
            ? curr.random.next : null;
        curr = curr.next.next;       // Saltar el nodo copiado y avanzar al siguiente nodo original
    }

    // === Tercera pasada: separar la lista entrelazada en la lista original y la lista copiada ===
    // Es necesario restaurar la lista original a su estado inicial
    curr = head;
    Node copyHead = head.next;       // Guardar la cabeza de la lista copiada. Este será el valor de retorno final
    while (curr != null) {
        Node copy = curr.next;       // Obtener el nodo copiado
        curr.next = copy.next;       // Restaurar el next de la lista original (saltar la copia y apuntar al siguiente nodo original)
        copy.next = copy.next != null
            ? copy.next.next : null;  // Conectar el next de la lista copiada (saltar el nodo original y apuntar a la siguiente copia)
        curr = curr.next;            // Avanzar al siguiente nodo original restaurado
    }

    // copyHead es la cabeza de la lista que ha sido copiada en profundidad
    return copyHead;
}
```
