# Reversing a Linked List — Invertir una lista enlazada simple

## Esencia del problema

Se recibe el nodo inicial `head` de una lista enlazada simple (singly linked list). Se deben invertir todos los enlaces (punteros) de la lista para que el nodo que originalmente era el último se convierta en el nuevo nodo inicial, y se retorna ese nuevo nodo inicial.

## Idea central

Si se reasigna el puntero `next` de cada nodo para que apunte al nodo anterior en lugar del siguiente, toda la lista queda invertida. Utilizando tres punteros (prev, curr, next), se puede reasignar cada enlace de forma segura uno por uno con un solo recorrido.

## Proceso de razonamiento

1. **Invertir significa cambiar la dirección de los enlaces**: El orden de una lista enlazada está determinado por los punteros `next` de los nodos. Si se cambia el `next` de todos los nodos para que apunte al nodo anterior en vez del siguiente, toda la lista queda invertida
2. **Al reasignar un enlace se pierde la referencia al nodo siguiente**: En el momento en que se escribe `curr.next = prev`, se pierde la referencia al nodo siguiente original. Por eso, antes de reasignar, es necesario guardar `curr.next` en una variable separada `next`
3. **Se gestiona el estado con tres punteros**: Con `prev` (el nodo anterior al que se redirige el enlace), `curr` (el nodo que se está procesando actualmente) y `next` (respaldo del nodo siguiente original), se puede reasignar enlaces y recorrer la lista simultáneamente
4. **Se define el estado inicial**: Dado que el `next` del nodo final de la lista invertida (el nodo inicial original) debe ser `null`, el valor inicial de `prev` se establece como `null`. El valor inicial de `curr` se establece como `head` (el nodo inicial)
5. **Condición de fin del bucle y valor de retorno**: Cuando `curr` se convierte en `null`, todos los nodos han sido procesados. En ese momento `prev` apunta al último nodo procesado (el nodo final original), por lo que se retorna `prev` como el nuevo nodo inicial

## Conocimientos previos

### Qué es un ListNode (nodo de lista enlazada)

Es el elemento que compone una lista enlazada. Cada nodo contiene un "valor (val)" y un "puntero al nodo siguiente (next)". El `next` del último nodo es `null`.

```java
class ListNode {
    int val;          // Valor almacenado en el nodo
    ListNode next;    // Referencia al nodo siguiente (null si es el último)

    ListNode(int val) {
        this.val = val;
        this.next = null;
    }
}
```

### Qué es la reasignación de punteros

Consiste en cambiar la dirección de un enlace asignando un nodo diferente al campo `next` de un nodo.

```java
// Estado original: A → B → C
// A.next apunta a B

A.next = null;   // A → null (se corta el enlace entre A y B)
B.next = A;      // B → A (se crea un enlace inverso de B hacia A)
// Resultado: C → null, B → A → null
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita un recorrido de la lista |
| Space | O(1) — Solo se utilizan tres variables de puntero, sin estructuras de datos adicionales |

## Código

```java
// Entrada: nodo inicial head de una lista enlazada simple
// Salida: retorna el nuevo nodo inicial (ListNode) de la lista invertida
ListNode reverseList(ListNode head) {
    // prev: destino de la reasignación del enlace (el "nodo anterior" en la lista invertida)
    // El primer nodo (el inicial original) se convierte en el último tras la inversión, por lo que su next debe ser null. Por eso el valor inicial es null
    ListNode prev = null;
    // curr: el nodo cuyo enlace se va a reasignar. El procesamiento comienza desde el nodo inicial
    ListNode curr = head;

    // Cuando curr se convierte en null, todos los nodos han sido procesados
    while (curr != null) {
        // Se guarda el nodo siguiente original (se preserva la referencia para no perderla al sobrescribir curr.next en el siguiente paso)
        ListNode next = curr.next;

        // Se invierte el enlace: se hace que apunte al nodo anterior en lugar del siguiente. Esta es la operación principal de inversión
        curr.next = prev;

        // Se avanza prev al nodo actual (se usará como destino de reasignación del enlace del siguiente nodo en la próxima iteración)
        prev = curr;
        // Se avanza curr al nodo siguiente original guardado previamente (esto permite continuar el recorrido de la lista)
        curr = next;
    }

    // En la última iteración del bucle, a prev se le asignó el último nodo procesado (el nodo final original)
    // Este es el nuevo nodo inicial de la lista invertida
    return prev;
}
```
