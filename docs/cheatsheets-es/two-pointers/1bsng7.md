# Checking if a String is a Palindrome — Determinar si una cadena es un palíndromo

## Esencia del problema

Se da una cadena `s`. Considerando solo caracteres alfanuméricos e ignorando la diferencia entre mayúsculas y minúsculas, se debe determinar si la cadena es un palíndromo (se lee igual de izquierda a derecha que de derecha a izquierda). Se devuelve `true` si es un palíndromo, y `false` en caso contrario.

## Idea central

Si se avanzan dos punteros desde ambos extremos de la cadena hacia el centro, saltando los caracteres no alfanuméricos y comparando carácter por carácter, se puede determinar si la cadena es un palíndromo con espacio O(1) sin generar cadenas adicionales.

## Proceso de razonamiento

1. **Confirmar la definición de palíndromo**: Un palíndromo es una cadena que se lee igual de izquierda a derecha que de derecha a izquierda. Es decir, si el primer y el último carácter coinciden, y los caracteres interiores también coinciden de la misma manera, la cadena es un palíndromo
2. **Comparar desde ambos extremos permite determinar el resultado en un solo recorrido**: Se coloca un puntero `left` al inicio y un puntero `right` al final, y se avanzan hacia el centro comparando hasta que se encuentren. De esta forma, se examina cada carácter solo una vez para completar la determinación
3. **Es necesario saltar los caracteres no alfanuméricos**: Dado que el problema solo considera caracteres alfanuméricos, cuando un puntero apunta a un carácter que no es alfanumérico, se debe saltar y avanzar al siguiente. Se puede determinar si un carácter es alfanumérico con `Character.isLetterOrDigit`
4. **Unificar mayúsculas y minúsculas antes de comparar**: Dado que el problema no distingue entre mayúsculas y minúsculas, antes de comparar se convierten ambos caracteres a minúsculas con `Character.toLowerCase` y luego se verifica la coincidencia
5. **Devolver `false` inmediatamente al encontrar una discrepancia**: Si un solo par de caracteres difiere, la cadena no es un palíndromo, por lo que se puede hacer un retorno anticipado
6. **Si los punteros se cruzan sin encontrar discrepancias, la cadena es un palíndromo**: Si el bucle termina normalmente, significa que todos los pares de caracteres correspondientes coincidieron, por lo que se devuelve `true`

## Conocimientos previos

### ¿Qué es Two Pointers (técnica de dos punteros)?

Es una técnica que consiste en colocar punteros en ambos extremos de un arreglo o cadena y moverlos hacia el centro según las condiciones. Es efectiva para problemas que aprovechan la simetría (determinación de palíndromos, búsqueda de pares, etc.). Como el problema se resuelve en un solo recorrido, se logra un tiempo O(n) y un espacio O(1).

```java
int left = 0;                    // Puntero que apunta al inicio
int right = s.length() - 1;     // Puntero que apunta al final
// Se repite el bucle hasta que left y right se crucen
while (left < right) {
    // Se realiza la comparación o el procesamiento
    left++;    // Se avanza el puntero izquierdo hacia la derecha
    right--;   // Se avanza el puntero derecho hacia la izquierda
}
```

### ¿Qué es Character.isLetterOrDigit?

Es un método que determina si un carácter es una letra (a-z, A-Z) o un dígito (0-9). Se utiliza cuando se desea excluir caracteres no alfanuméricos como espacios o símbolos.

```java
Character.isLetterOrDigit('A');   // true (letra)
Character.isLetterOrDigit('3');   // true (dígito)
Character.isLetterOrDigit(' ');   // false (espacio)
Character.isLetterOrDigit(',');   // false (símbolo)
```

### ¿Qué es Character.toLowerCase?

Es un método que convierte una letra a minúscula. Se utiliza cuando se desea comparar sin distinguir entre mayúsculas y minúsculas. Si el carácter ya es una minúscula o un dígito, se devuelve tal cual.

```java
Character.toLowerCase('A');   // 'a'
Character.toLowerCase('a');   // 'a' (sin cambio)
Character.toLowerCase('3');   // '3' (los dígitos se devuelven tal cual)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Cada puntero recorre la cadena como máximo una vez |
| Space | O(1) — Solo se usan dos punteros, sin cadenas ni estructuras de datos adicionales |

## Código

```java
// Entrada: cadena s
// Salida: devuelve true si s es un palíndromo, false en caso contrario
public boolean isPalindrome(String s) {
    // Se colocan punteros al inicio y al final. Estos dos avanzan desde ambos extremos de la cadena hacia el centro
    int left = 0;
    int right = s.length() - 1;

    // Se repite hasta que los dos punteros se crucen. Cuando se cruzan, significa que todas las comparaciones se han completado
    while (left < right) {
        // Si left no apunta a un carácter alfanumérico, se salta hacia la derecha
        // Nota: durante el salto se mantiene la condición left < right para evitar que los punteros se crucen
        while (left < right && !Character.isLetterOrDigit(s.charAt(left))) {
            left++;
        }
        // Si right no apunta a un carácter alfanumérico, se salta hacia la izquierda. De igual forma se mantiene la condición left < right
        while (left < right && !Character.isLetterOrDigit(s.charAt(right))) {
            right--;
        }
        // Se convierten ambos caracteres a minúsculas antes de compararlos, ignorando así la diferencia entre mayúsculas y minúsculas
        // Si no coinciden, la cadena no es un palíndromo. Si un solo par difiere, no se cumple la condición de palíndromo, por lo que se devuelve inmediatamente
        if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right))) {
            return false;
        }
        // Los dos caracteres coincidieron, así que se avanzan ambos punteros hacia el centro para comparar el siguiente par de caracteres
        left++;
        right--;
    }
    // El bucle terminó normalmente (todos los pares de caracteres correspondientes coincidieron), por lo tanto la cadena es un palíndromo
    return true;
}
```
