# Adding Two Numbers Represented as Linked Lists — Sumar dos números representados como listas enlazadas en orden inverso

## Esencia del problema

Se proporcionan dos listas enlazadas no vacías. Cada lista enlazada representa un número entero no negativo en **orden inverso** (el dígito de las unidades está al inicio), y cada nodo almacena un dígito. Se deben sumar los dos números y devolver el resultado como una **lista enlazada en orden inverso**.

## Idea central

Dado que las listas enlazadas están almacenadas en orden inverso (el dígito de las unidades está al inicio), al sumar secuencialmente desde el nodo inicial se puede realizar la adición en el mismo orden que una suma a mano: unidades → decenas → centenas… Se mantiene el acarreo (carry) en una variable y se conectan los resultados de cada dígito como nuevos nodos.

## Proceso de razonamiento

1. **El orden inverso es una ventaja**: La suma de números se realiza desde el dígito de las unidades. Como la lista enlazada está en orden inverso, al procesar desde el nodo inicial se suman naturalmente desde las unidades. No es necesario invertir el orden de los dígitos.
2. **Gestionar la suma de cada dígito y el acarreo**: En cada dígito se calcula `valor de l1 + valor de l2 + carry`. Si la suma es 10 o mayor, se produce un acarreo. `sum % 10` es el resultado de ese dígito y `sum / 10` es el acarreo hacia el siguiente dígito. Esta es exactamente la regla de la suma a mano.
3. **Manejar listas de diferente longitud**: Aunque una lista termine antes, se debe continuar el procesamiento mientras queden nodos en la otra lista o exista un acarreo pendiente. Al establecer la condición del bucle while como `l1 != null || l2 != null || carry != 0`, se pueden manejar todos los casos de manera unificada.
4. **Simplificar la construcción de la lista resultado con un nodo cabecera ficticio**: Para evitar tratar de forma especial el primer nodo de la lista resultado, se coloca un nodo ficticio con valor 0 al inicio. Se agregan todos los resultados de cada dígito mediante `curr.next` y al final se devuelve `dummy.next` para obtener la lista resultado correcta.
5. **Unificar el procesamiento dentro del bucle**: En cada iteración, si `l1` y `l2` no son null, se suma el valor de cada uno a sum y se avanza el puntero al siguiente nodo. Si es null, no se realiza ninguna acción. Esta bifurcación condicional absorbe naturalmente la diferencia de longitud entre las listas.
6. **Qué se devuelve al final**: El nodo siguiente al nodo cabecera ficticio, `dummy.next`, es el inicio de la lista resultado. Se devuelve este nodo.

## Conocimientos previos

### Qué es un ListNode

Es una clase que representa un nodo de una lista enlazada unidireccional. Cada nodo tiene un valor entero `val` y una referencia al siguiente nodo `next`. El nodo cuyo `next` es `null` es el final de la lista.

```java
public class ListNode {
    int val;              // Valor numérico de un dígito que almacena este nodo
    ListNode next;        // Referencia al siguiente nodo (null si es el final)
    ListNode(int val) {   // Constructor: crea un nodo con el valor especificado
        this.val = val;
    }
}
```

### Qué es un nodo cabecera ficticio (Dummy Head)

Es un nodo ficticio sin valor significativo que se coloca al inicio de la lista. Es una técnica que permite construir la lista resultado sin tratar de forma especial el primer nodo. Todos los nodos se agregan de manera uniforme mediante `curr.next = new ListNode(...)`, y al final se devuelve `dummy.next` para obtener el nodo inicial real.

```java
ListNode dummy = new ListNode(0);  // Crear el nodo cabecera ficticio
ListNode curr = dummy;             // curr es un puntero que rastrea el final de la lista
curr.next = new ListNode(5);       // Agregar un nodo con valor 5 después del nodo ficticio
curr = curr.next;                  // Avanzar curr al final
// dummy.next apunta al inicio real de la lista (el nodo con valor 5)
```

### Qué es el acarreo (Carry)

Es el valor que se traslada al siguiente dígito cuando la suma de dos dígitos individuales es 10 o mayor. Se calcula con `sum / 10` (al ser división entera, el resultado es 0 o 1). El valor que permanece en el dígito actual se obtiene con `sum % 10`.
Ejemplo: cuando 7 + 8 = 15, carry = 15 / 10 = 1, valor del dígito actual = 15 % 10 = 5.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(max(n, m)) — Se recorren tantos nodos como la longitud de la lista más larga |
| Space | O(max(n, m)) — El número de nodos de la lista resultado es como máximo max(n, m) + 1 |

## Código

```java
// Entrada: listas enlazadas en orden inverso l1 y l2 (cada nodo es un entero no negativo de un dígito)
// Salida: devuelve la suma de los dos números como una lista enlazada en orden inverso
public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
    // Crear el nodo cabecera ficticio. Permite no tratar de forma especial el primer nodo de la lista resultado
    // No se incluye en el resultado final; dummy.next será el inicio real
    ListNode dummy = new ListNode(0);
    // curr es un puntero que rastrea el final de la lista resultado
    ListNode curr = dummy;
    // Variable que mantiene el acarreo. Valor que se traslada al siguiente dígito cuando la suma es 10 o mayor (0 o 1)
    int carry = 0;

    // Continuar el bucle mientras quede alguna lista o exista un acarreo
    // La condición carry != 0 permite manejar casos donde aumenta el número de dígitos, como 999 + 1 = 1000
    while (l1 != null || l2 != null || carry != 0) {
        // Calcular sum usando el acarreo del dígito anterior como valor inicial
        int sum = carry;

        // Si l1 aún tiene nodos, sumar su valor y avanzar el puntero al siguiente
        // Si es null, no se realiza ninguna acción. Esto permite continuar el procesamiento aunque l1 termine primero
        if (l1 != null) {
            sum += l1.val;
            l1 = l1.next;
        }

        // Si l2 aún tiene nodos, sumar su valor y avanzar el puntero al siguiente
        // Si es null, no se realiza ninguna acción. Esto permite continuar el procesamiento aunque l2 termine primero
        if (l2 != null) {
            sum += l2.val;
            l2 = l2.next;
        }

        // Calcular el acarreo. Si sum es 10 o mayor el resultado es 1; si es menor que 10, el resultado es 0
        carry = sum / 10;
        // Crear un nuevo nodo con el valor del dígito actual (sum % 10) y conectarlo al final de la lista resultado
        curr.next = new ListNode(sum % 10);
        // Avanzar curr al final para poder agregar un nuevo nodo en la siguiente iteración
        curr = curr.next;
    }

    // El nodo siguiente al nodo cabecera ficticio es el inicio de la lista resultado
    return dummy.next;
}
```
