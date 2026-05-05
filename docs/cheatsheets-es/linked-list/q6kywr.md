# Merging K Sorted Linked Lists — Integrar K listas enlazadas ordenadas en una sola

## Esencia del problema

Se recibe un arreglo de K listas enlazadas (Linked List) ordenadas. El objetivo es integrar todas ellas en **una sola lista enlazada ordenada** y devolver su nodo cabeza. Cada lista está ordenada individualmente, y la lista resultante tras la integración también debe mantener el orden ascendente.

## Idea central

En lugar de integrar las K listas de una sola vez, se emparejan de dos en dos y se repite el proceso de merge. Como la cantidad de listas se reduce a la mitad en cada ronda, el proceso converge en una sola lista en log k rondas, logrando una eficiencia de O(N log k) para el total de N elementos.

## Proceso de razonamiento

1. **La operación básica es "merge de dos listas ordenadas"**: El problema de integrar K listas se puede descomponer en combinaciones de la operación básica "hacer merge de dos listas ordenadas en una sola". El merge de dos listas se ejecuta en O(n) comparando repetidamente las cabezas y seleccionando la menor
2. **Cómo aplicar esta operación básica a K listas**: Si simplemente se hace merge de la primera con la segunda, luego del resultado con la tercera, y así sucesivamente, la complejidad resulta O(Nk). Esto se debe a que el resultado del merge crece en cada paso, haciendo que los merges posteriores sean cada vez más costosos
3. **El merge por pares equilibra los costos**: Si se emparejan las listas de dos en dos para hacer merge, en cada ronda solo se necesita procesar todos los elementos una vez. Como la cantidad de listas se reduce a la mitad en cada ronda, el número de rondas es log k, logrando un total de O(N log k)
4. **Gestión de pares mediante índices del arreglo**: Se utiliza una variable `interval` que se duplica como 1, 2, 4, 8…, y se hace merge de `lists[i]` con `lists[i + interval]`, almacenando el resultado en `lists[i]`. De esta forma se logra un merge por pares in-place sin necesidad de arreglos adicionales
5. **Tras finalizar todas las rondas, lists[0] contiene el resultado final**: En cada ronda, los resultados del merge se acumulan en los índices pares `lists[0]`, `lists[2]`, `lists[4]`…, y finalmente todos los elementos quedan integrados en `lists[0]`

## Conocimientos previos

### Qué es un ListNode (nodo de lista enlazada)

Es una clase que representa cada elemento de una lista enlazada. El campo `val` almacena el valor y `next` almacena la referencia al siguiente nodo. El nodo cuyo `next` es `null` constituye el final de la lista.

```java
class ListNode {
    int val;              // Valor que almacena este nodo
    ListNode next;        // Referencia al siguiente nodo (null si es el último)
    ListNode(int val) {   // Constructor: crea un nodo con el valor especificado
        this.val = val;
    }
}
```

### Qué es un nodo ficticio (Sentinel Node)

Es una técnica para simplificar la construcción de listas. Se coloca un nodo ficticio con valor 0 al inicio y se enlazan los nodos reales detrás de él. Al final se devuelve `dummy.next`, eliminando la necesidad de un tratamiento especial para el nodo cabeza.

```java
ListNode dummy = new ListNode(0);  // Crear el nodo ficticio
ListNode tail = dummy;             // tail es un puntero que rastrea el final
tail.next = someNode;              // Enlazar un nodo detrás del ficticio
tail = tail.next;                  // Avanzar tail al final
return dummy.next;                 // Devolver el siguiente del ficticio, es decir, la cabeza real
```

### Qué es Divide y Vencerás (Divide and Conquer)

Es una técnica que divide el problema en subproblemas más pequeños, resuelve los subproblemas y luego integra los resultados. Merge Sort es el ejemplo representativo, que divide el arreglo en mitades y hace merge de los subarreglos ya ordenados. En este problema se emparejan las K listas de dos en dos y se hace merge repetidamente.

```java
// interval se duplica como 1, 2, 4, 8..., ampliando la distancia entre pares
for (int interval = 1; interval < n; interval *= 2) {
    // En cada ronda se hace merge de los pares en orden
    for (int i = 0; i < n - interval; i += 2 * interval) {
        lists[i] = merge(lists[i], lists[i + interval]);
    }
}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(N log k) — Se procesan los N elementos una vez por ronda, y el número de rondas es log k |
| Space | O(log k) — No se usa recursión, pero corresponde al espacio de pila del bucle para cada ronda de merge |

## Código

```java
// Entrada: arreglo de listas enlazadas ordenadas ListNode[] lists (K elementos)
// Salida: devuelve el nodo cabeza ListNode de una sola lista enlazada ordenada que integra todas las listas

// Método auxiliar que hace merge de dos listas ordenadas en una sola
private ListNode mergeTwoLists(ListNode a, ListNode b) {
    // Crear un nodo ficticio que sirve como marca del inicio de la lista resultado del merge (los datos reales comienzan en dummy.next)
    ListNode dummy = new ListNode(0);
    // tail rastrea siempre el final del resultado del merge e indica la posición donde se enlaza el siguiente nodo
    ListNode tail = dummy;

    // Mientras ambas listas tengan nodos restantes, se selecciona y enlaza el menor (para mantener el orden)
    while (a != null && b != null) {
        if (a.val <= b.val) {
            tail.next = a;  // Enlazar el nodo actual de a al resultado del merge
            a = a.next;     // Avanzar a al siguiente nodo
        } else {
            tail.next = b;  // Enlazar el nodo actual de b al resultado del merge
            b = b.next;     // Avanzar b al siguiente nodo
        }
        tail = tail.next;   // Avanzar tail al final y preparar para enlazar el siguiente nodo
    }

    // Tras finalizar el bucle while, quedan nodos restantes en a o en b. Como ambos están ordenados, se pueden enlazar directamente sin problema
    tail.next = (a != null) ? a : b;

    // dummy es solo un nodo ficticio, por lo que el siguiente nodo es la cabeza real del resultado del merge
    return dummy.next;
}

public ListNode mergeKLists(ListNode[] lists) {
    // Si la entrada es null o está vacía, no existen listas para integrar, por lo que se devuelve null
    if (lists == null || lists.length == 0) return null;

    // Almacenar en n la cantidad K de listas
    int n = lists.length;

    // interval se duplica como 1, 2, 4, 8... interval representa la distancia entre los pares a fusionar, y la cantidad de listas se reduce a la mitad en cada ronda
    for (int interval = 1; interval < n; interval *= 2) {
        // La condición i < n - interval garantiza que el lado derecho del par lists[i + interval] exista dentro del rango del arreglo
        for (int i = 0; i < n - interval; i += 2 * interval) {
            // Almacenar el resultado del merge del par en lists[i]. La lista del lado derecho no se usa después, por lo que se puede sobrescribir en el lado izquierdo sin problema
            lists[i] = mergeTwoLists(lists[i], lists[i + interval]);
        }
    }

    // Tras finalizar todas las rondas, el resultado del merge de todas las listas queda acumulado en lists[0]
    return lists[0];
}
```
