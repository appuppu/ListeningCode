# Adding One to a Number Represented as an Array — Sumar uno a un número representado como un arreglo

## Esencia del problema

Se proporciona un arreglo `digits` que almacena un entero no negativo dígito por dígito. El primer elemento del arreglo es el dígito más significativo y el último elemento es el dígito menos significativo. Se debe sumar 1 a este número y devolver el resultado en el mismo formato de arreglo. Cada elemento es un dígito de 0 a 9.

## Idea central

Se suma 1 comenzando desde el último dígito, y se retorna inmediatamente en cuanto no se produce acarreo. El acarreo solo ocurre cuando el dígito es 9, y la longitud del arreglo aumenta en 1 únicamente cuando todos los dígitos son 9.

## Proceso de razonamiento

1. **La suma se realiza desde el dígito menos significativo**: Dado que la suma numérica comienza naturalmente desde las unidades, se recorre el arreglo en orden inverso, desde el final hasta el inicio
2. **Considerar la condición en la que el acarreo se detiene**: Si el dígito actual es menor que 9, sumar 1 no produce acarreo. En ese punto la suma está completa, por lo que se puede devolver el arreglo inmediatamente
3. **Considerar el procesamiento cuando el dígito es 9**: Cuando el dígito actual es 9, sumar 1 da 10 y se produce un acarreo. Se establece este dígito en 0 y se propaga el acarreo al siguiente dígito superior. En la siguiente iteración del bucle, la suma de 1 al dígito superior se realiza de forma natural
4. **Considerar el caso en que todos los dígitos son 9**: Cuando todos los dígitos son 9, como en 999, el acarreo no se detiene aunque el bucle llegue al final. El resultado tiene un dígito más, como 1000. Solo en este caso se crea un nuevo arreglo y se establece 1 en la primera posición. Dado que `new int[]` en Java inicializa todos los elementos en 0, no es necesario asignar 0 a los dígitos restantes
5. **No es necesario gestionar el acarreo con una variable**: El valor del acarreo siempre es 1, y mientras el bucle continúa, se garantiza que existe un acarreo. Por lo tanto, no se necesita una variable carry; la propia continuación del bucle representa la existencia del acarreo

## Conocimientos previos

### Recorrido inverso de un arreglo

Se recorre el arreglo desde el final hasta el inicio. Se comienza con `i = n - 1` y se decrementa con `i--` mientras `i >= 0`.

```java
int[] digits = {1, 2, 3};
int n = digits.length;                  // Se obtiene la longitud del arreglo → 3
for (int i = n - 1; i >= 0; i--) {      // Se itera en el orden i=2, 1, 0
    System.out.println(digits[i]);      // Se imprime en el orden 3, 2, 1
}
```

### Inicialización de arreglos en Java

Al crear un arreglo de enteros de longitud n con `new int[n]`, todos los elementos se inicializan automáticamente en 0. No es necesario asignar 0 explícitamente.

```java
int[] result = new int[4];   // Se inicializa como {0, 0, 0, 0}
result[0] = 1;               // Se convierte en {1, 0, 0, 0}
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Se recorre el arreglo como máximo una vez desde el final hasta el inicio |
| Space | O(1) — Excepto cuando todos los dígitos son 9, se modifica el arreglo de entrada en su lugar y no se requiere memoria adicional |

## Código

```java
// Entrada: arreglo de enteros digits que almacena cada dígito de un entero no negativo
// Salida: devuelve un int[] que contiene el resultado de sumar 1 al número representado por digits
public int[] plusOne(int[] digits) {
    // Se guarda la longitud del arreglo. Se usa como límite del bucle inverso y como longitud del nuevo arreglo cuando todos los dígitos son 9
    int n = digits.length;

    // Se recorre desde el final hasta el inicio. La propia continuación del bucle significa que "existe un acarreo"
    for (int i = n - 1; i >= 0; i--) {
        // Si el dígito actual es menor que 9, no se produce acarreo. Se suma y se devuelve inmediatamente
        if (digits[i] < 9) {
            digits[i]++;
            return digits;  // Sin acarreo. Se devuelve el arreglo modificado y se finaliza
        }
        // El dígito actual es 9, por lo que se establece en 0 y se propaga el acarreo al dígito superior
        digits[i] = 0;
    }

    // Todos los dígitos eran 9 (ejemplo: [9,9,9] → [0,0,0]), por lo que el número de dígitos aumenta en 1
    // Dado que new int[] inicializa todos los elementos en 0, no es necesario asignar 0 a los dígitos restantes
    int[] result = new int[n + 1];
    result[0] = 1;  // Se establece 1 en la primera posición (ejemplo: 999 + 1 = 1000 → [1, 0, 0, 0])
    return result;
}
```
