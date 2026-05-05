# Finding the Duplicate in an Array of N Plus One Integers — Encontrar el número duplicado en un arreglo de N+1 enteros

## Esencia del problema

Se recibe un arreglo de enteros `nums` de longitud n+1. Cada elemento está en el rango de 1 a n, y existe exactamente un número duplicado. Se debe encontrar y devolver ese número duplicado sin modificar el arreglo y utilizando únicamente espacio adicional constante.

## Idea central

Si se interpreta la relación de moverse desde cada índice `i` hacia `nums[i]` como una "lista enlazada", en el punto donde existe el número duplicado los enlaces convergen y se produce un ciclo (bucle). Utilizando Floyd's Cycle Detection (el algoritmo de la tortuga y la liebre), se puede identificar la entrada del ciclo, que es el número duplicado, con espacio O(1).

## Proceso de razonamiento

1. **Interpretar el arreglo como una lista enlazada implícita**: Se considera el valor `nums[i]` en el índice `i` como un "puntero al siguiente nodo". Partiendo desde el índice 0, se recorre `nums[0]` → `nums[nums[0]]` → …, lo cual equivale a recorrer una lista enlazada. Dado que los valores están en el rango de 1 a n, nunca se regresa al índice 0, y siempre se apunta a un índice válido
2. **Comprender por qué el duplicado genera un ciclo**: Cuando dos índices distintos tienen el mismo valor, existen dos flechas apuntando al índice de ese valor. Esto equivale a que dos nodos en una lista enlazada apunten al mismo nodo, y desde ese punto de convergencia comienza un ciclo. La entrada del ciclo es precisamente el número duplicado
3. **Detectar la existencia del ciclo**: El puntero slow avanza un paso a la vez (`slow = nums[slow]`) y el puntero fast avanza dos pasos a la vez (`fast = nums[nums[fast]]`). Si existe un ciclo, slow y fast se encontrarán inevitablemente en algún punto dentro del ciclo
4. **Identificar la entrada del ciclo**: Después del encuentro, se regresa slow al punto de inicio (`nums[0]`) y se deja fast en su posición actual. Al avanzar ambos un paso a la vez, se encontrarán de nuevo en la entrada del ciclo. El valor correspondiente al índice de esta entrada es el número duplicado
5. **Por qué se encuentran en la entrada**: Está demostrado matemáticamente que la distancia desde el inicio hasta la entrada del ciclo es igual a la distancia desde el punto de encuentro hasta la entrada del ciclo. Por lo tanto, al avanzar ambos a la misma velocidad, coinciden en la entrada

## Conocimientos previos

### ¿Qué es una lista enlazada implícita (Implicit Linked List)?

Sin crear objetos de nodo reales, se puede representar la misma estructura que una lista enlazada interpretando los valores del arreglo como "punteros al siguiente índice". El "siguiente nodo" del nodo en el índice `i` es el nodo en el índice `nums[i]`.

```java
// Recorrido de la lista enlazada para el arreglo nums = [1, 3, 4, 2, 2]
int current = nums[0];       // Valor en el índice 0 → 1 (se va al índice 1)
current = nums[current];     // Valor en el índice 1 → 3 (se va al índice 3)
current = nums[current];     // Valor en el índice 3 → 2 (se va al índice 2)
current = nums[current];     // Valor en el índice 2 → 4 (se va al índice 4)
current = nums[current];     // Valor en el índice 4 → 2 (regresa al índice 2 → ciclo)
```

### ¿Qué es Floyd's Cycle Detection (detección de ciclos de Floyd)?

Es un algoritmo que detecta un ciclo en una lista enlazada e identifica su entrada. Utiliza dos punteros (slow: avanza 1 paso, fast: avanza 2 pasos). Si existe un ciclo, ambos se encontrarán inevitablemente, y mediante el procedimiento posterior se puede identificar la entrada del ciclo.

```java
// Fase 1: Encuentro dentro del ciclo
slow = nums[slow];           // slow avanza 1 paso
fast = nums[nums[fast]];     // fast avanza 2 pasos

// Fase 2: Identificación de la entrada del ciclo
slow = nums[slow];           // Ambos avanzan 1 paso a la vez
fast = nums[fast];           // El punto donde se encuentran es la entrada del ciclo
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Cada puntero solo necesita recorrer la lista enlazada como máximo dos vueltas |
| Space | O(1) — Solo se utilizan las dos variables slow y fast |

## Código

```java
// Entrada: arreglo de enteros nums de longitud n+1 (cada elemento está entre 1 y n, con exactamente un duplicado)
// Salida: devuelve el número duplicado como int
public int findDuplicate(int[] nums) {
    // Se inicializan tanto slow como fast en la cabeza de la lista enlazada (nums[0])
    // El índice 0 no está incluido en el rango de valores (1 a n), por lo que no forma parte del ciclo y es un punto de inicio seguro
    int slow = nums[0];
    int fast = nums[0];

    // Fase 1: slow avanza 1 paso y fast avanza 2 pasos, repitiendo hasta que se encuentren dentro del ciclo
    // Se usa do-while porque los valores iniciales son iguales y es necesario omitir la primera comparación
    do {
        slow = nums[slow];           // Se avanza slow 1 paso
        fast = nums[nums[fast]];     // Se avanza fast 2 pasos (si hay un ciclo, inevitablemente lo alcanzará)
    } while (slow != fast);

    // Fase 2: se regresa slow al punto de inicio y ambos avanzan 1 paso a la vez
    // Se aprovecha la propiedad de que la distancia del inicio a la entrada = la distancia del punto de encuentro a la entrada
    slow = nums[0];
    while (slow != fast) {
        slow = nums[slow];           // Ambos avanzan 1 paso a la vez
        fast = nums[fast];           // Se encontrarán inevitablemente en la entrada del ciclo
    }

    // La entrada del ciclo = el número apuntado desde dos índices distintos = se devuelve el número duplicado
    return slow;
}
```
