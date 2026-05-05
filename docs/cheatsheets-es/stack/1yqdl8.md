# Evaluating an Expression in Reverse Polish Notation — Evaluar una expresión aritmética en notación polaca inversa

## Esencia del problema

Se recibe un arreglo de cadenas `tokens` que representa una expresión aritmética en notación polaca inversa (RPN). Se debe evaluar esta expresión y devolver el resultado como un entero. Los operadores válidos son `+`, `-`, `*` y `/`, y cada operando es un entero o una subexpresión. La división se trunca hacia cero. Ejemplo: `["2","1","+","3","*"]` → `((2+1)*3)` → `9`.

## Idea central

En la notación polaca inversa no es necesario manejar la precedencia de operadores ni los paréntesis. Basta con recorrer los tokens de izquierda a derecha, apilar los valores numéricos en una pila y, cuando aparece un operador, extraer los dos valores superiores, calcular el resultado y devolverlo a la pila para evaluar correctamente toda la expresión.

## Proceso de razonamiento

1. **Comprender las propiedades de la RPN**: En la notación polaca inversa, cada operador actúa sobre los dos operandos inmediatamente anteriores. Es decir, en el momento en que aparece un operador, sus dos operandos ya están determinados. Por esta propiedad, la pila (stack), una estructura de datos LIFO que extrae primero el último elemento agregado, resulta ideal
2. **Bifurcar el procesamiento según si el token es un número o un operador**: Se examina cada token en orden; si es un número, se apila; si es un operador, se realiza el cálculo. Con solo estas dos operaciones se puede evaluar toda la expresión
3. **Prestar atención al orden de los operandos al procesar un operador**: El primer valor extraído con pop de la pila es el operando derecho (`a`), y el segundo valor extraído es el operando izquierdo (`b`). El cálculo se realiza en el orden `b operador a`. Si se invierte este orden, la resta y la división producen resultados incorrectos
4. **Devolver el resultado del cálculo a la pila**: Al hacer push del resultado de la operación en la pila, dicho resultado se utiliza como operando para las operaciones posteriores. De este modo, las subexpresiones anidadas se procesan de forma natural
5. **El resultado final queda como único elemento en la pila**: Si la expresión RPN es válida, después de procesar todos los tokens queda exactamente un valor en la pila. Se extrae ese valor con pop y se devuelve

## Conocimientos previos

### Qué es un Stack

Es una estructura de datos de tipo último en entrar, primero en salir (LIFO). El último elemento agregado es el primero en ser extraído. Tanto la inserción (push) como la extracción (pop) se realizan en O(1).

```java
Stack<Integer> stack = new Stack<>();  // Crear una pila vacía
stack.push(5);     // Apilar 5 en la cima de la pila → [5]
stack.push(3);     // Apilar 3 en la cima de la pila → [5, 3]
stack.pop();       // Extraer y devolver el elemento de la cima → 3, la pila queda [5]
stack.pop();       // Extraer y devolver el elemento de la cima → 5, la pila queda []
```

### Qué es la notación polaca inversa (RPN)

Es una notación en la que el operador se coloca después de los operandos. La notación infija habitual `(2 + 1) * 3` se escribe en RPN como `2 1 + 3 *`. No se necesitan paréntesis y la expresión se evalúa correctamente con solo procesarla de izquierda a derecha.

```
Notación infija:       (2 + 1) * 3
RPN:                   2 1 + 3 *
Proceso de evaluación: 2 1 + → 3, luego 3 3 * → 9
```

### Qué es Integer.parseInt

Es un método estático de Java que convierte una cadena en un entero. También convierte correctamente cadenas que representan números negativos (por ejemplo: `"-3"`).

```java
Integer.parseInt("42");    // → 42
Integer.parseInt("-3");    // → -3
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se requiere un único recorrido de los tokens del arreglo |
| Space | O(n) — La pila almacena como máximo n elementos |

## Código

```java
// Entrada: arreglo de cadenas tokens que representa una expresión aritmética en notación polaca inversa
// Salida: el resultado de evaluar la expresión, devuelto como entero
public int evalRPN(String[] tokens) {
    // Pila para almacenar temporalmente los operandos numéricos y los resultados intermedios
    Stack<Integer> stack = new Stack<>();

    // Recorrer el arreglo tokens uno por uno desde el inicio hasta el final
    for (String token : tokens) {
        // Determinar si el token actual es un operador (+, -, *, / alguno de ellos)
        switch (token) {
            case "+": {
                int a = stack.pop();  // Primer pop → operando derecho
                int b = stack.pop();  // Segundo pop → operando izquierdo
                // Al hacer push del resultado, este se utiliza como operando para operaciones posteriores
                stack.push(b + a);
                break;
            }
            case "-": {
                int a = stack.pop();
                int b = stack.pop();
                // Atención: como el orden de pop es inverso, siempre se calcula b - a. Si se usa a - b, el resultado se invierte
                stack.push(b - a);
                break;
            }
            case "*": {
                int a = stack.pop();
                int b = stack.pop();
                stack.push(b * a);
                break;
            }
            case "/": {
                int a = stack.pop();
                int b = stack.pop();
                // La división entera de Java trunca automáticamente hacia cero, por lo que no se necesita un tratamiento especial
                // Atención: como el orden de pop es inverso, siempre se calcula b / a. Si se usa a / b, el resultado se invierte
                stack.push(b / a);
                break;
            }
            default: {
                // Convertir el token numérico a entero y apilarlo en la pila
                // Los números negativos (por ejemplo: "-3") también son procesados correctamente por parseInt
                stack.push(Integer.parseInt(token));
            }
        }
    }

    // Si la expresión RPN es válida, después de procesar todos los tokens queda exactamente un resultado en la pila
    return stack.pop();
}
```
