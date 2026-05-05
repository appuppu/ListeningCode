# Finding the Longest Palindromic Substring — Encontrar la subcadena palíndroma más larga dentro de una cadena

## Esencia del problema

Se da una cadena `s`. Se debe encontrar y devolver la **subcadena más larga que sea un palíndromo** (se lee igual de izquierda a derecha que de derecha a izquierda) dentro de `s`. Si existen varios palíndromos de la misma longitud máxima, se puede devolver cualquiera de ellos.

## Idea central

Todo palíndromo tiene un «centro». Si se expande hacia la izquierda y la derecha desde cada posición de la cadena y se sigue expandiendo mientras los caracteres coincidan, se pueden descubrir todos los palíndromos sin omisiones. Es necesario probar dos tipos de centro: «un solo carácter (longitud impar)» y «entre dos caracteres adyacentes (longitud par)».

## Proceso de razonamiento

1. **Un palíndromo tiene una estructura simétrica que se extiende desde el centro**: El palíndromo `"racecar"` se extiende simétricamente desde la `e` central hacia ambos lados como `c→a→r`. Aprovechando esta propiedad, se puede detectar un palíndromo fijando el centro y expandiendo hacia la izquierda y la derecha
2. **Existen dos tipos de candidatos a centro**: Un palíndromo de longitud impar (ejemplo: `"aba"`) tiene un solo carácter como centro, y un palíndromo de longitud par (ejemplo: `"abba"`) tiene como centro el espacio entre dos caracteres adyacentes. Para detectar todos los palíndromos sin omisiones, es necesario probar ambos tipos de centro
3. **Se define el procedimiento de expansión**: Se colocan los punteros `left` y `right` a ambos lados del centro y, mientras `s.charAt(left) == s.charAt(right)`, se mueve `left` una posición a la izquierda y `right` una posición a la derecha. La expansión termina cuando los caracteres no coinciden o se alcanza el extremo de la cadena
4. **Se calcula la longitud del palíndromo a partir del resultado de la expansión**: Cuando la expansión termina, `left` y `right` se encuentran una posición más allá del rango del palíndromo. Por lo tanto, la longitud del palíndromo se calcula como `right - left - 1`
5. **Se registran las posiciones de inicio y fin del palíndromo más largo**: Si la longitud del palíndromo obtenido desde cada centro supera la longitud máxima actual, se actualizan la posición de inicio `start` y la posición de fin `end`. A partir de la posición central `i` y la longitud del palíndromo `len`, se calculan como `start = i - (len - 1) / 2` y `end = i + len / 2`
6. **Se devuelve la subcadena final**: Después de probar todos los centros, se extrae y devuelve la subcadena del palíndromo más largo mediante `s.substring(start, end + 1)`

## Conocimientos previos

### Qué es un palíndromo (Palindrome)

Un palíndromo es una cadena que se lee igual de izquierda a derecha que de derecha a izquierda. `"aba"`, `"abba"` y `"racecar"` son palíndromos. Una cadena de un solo carácter también es un palíndromo.

### Qué es el método de expansión desde el centro (Expand Around Center)

Es una técnica que fija el centro de un palíndromo y expande un carácter a la vez hacia la izquierda y la derecha para determinar si la subcadena es un palíndromo. Dado que se comparan los caracteres desde el centro hacia el exterior, la detección de palíndromos se realiza de manera eficiente.

```java
// Si left=right, se detecta un palíndromo de longitud impar (centro de 1 carácter)
// Si left=i, right=i+1, se detecta un palíndromo de longitud par (centro de 2 caracteres)
expand(s, 2, 2);    // Busca un palíndromo de longitud impar con centro en el índice 2
expand(s, 2, 3);    // Busca un palíndromo de longitud par con centro entre los índices 2 y 3
```

### Qué es String.substring(int, int)

Es un método que extrae una subcadena de una cadena. El primer argumento es el índice de inicio (incluido) y el segundo argumento es el índice de fin (excluido).

```java
String s = "babad";
s.substring(0, 3);   // Devuelve "bab" (caracteres en los índices 0, 1, 2)
s.substring(1, 4);   // Devuelve "aba" (caracteres en los índices 1, 2, 3)
```

### Qué es String.charAt(int)

Es un método que devuelve el carácter en el índice especificado de una cadena.

```java
String s = "babad";
s.charAt(0);   // Devuelve 'b'
s.charAt(2);   // Devuelve 'b'
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n²) — Se realiza una expansión de hasta O(n) desde cada índice como centro, y existen n centros |
| Space | O(1) — Solo se utilizan variables para registrar punteros y longitudes; no se requieren estructuras de datos adicionales |

## Código

```java
// Entrada: cadena s
// Salida: devuelve la subcadena palíndroma más larga de s como String

// Método auxiliar que expande desde el centro hacia la izquierda y la derecha y devuelve la longitud del palíndromo
private int expand(String s, int left, int right) {
    // Se sigue expandiendo mientras los caracteres izquierdo y derecho coincidan y estén dentro del rango de la cadena
    while (left >= 0
            && right < s.length()
            && s.charAt(left)
            == s.charAt(right)) {
        left--;  // Expandir una posición a la izquierda
        right++; // Expandir una posición a la derecha
    }
    // Al finalizar la expansión, left y right están una posición más allá del rango del palíndromo
    // Por lo tanto, la longitud del palíndromo se obtiene como right - left - 1
    return right - left - 1;
}

public String longestPalindrome(String s) {
    // Variables para registrar los índices de inicio y fin del palíndromo más largo
    // El valor inicial 0 corresponde a que, como mínimo, el primer carácter es un palíndromo de longitud 1
    int start = 0, end = 0;

    // Se recorre cada índice i como candidato a centro del palíndromo
    for (int i = 0; i < s.length(); i++) {
        // Se expande el palíndromo de longitud impar (centro de 1 carácter) y se obtiene su longitud
        int odd = expand(s, i, i);
        // Se expande el palíndromo de longitud par (centro de 2 caracteres) y se obtiene su longitud
        int even = expand(s, i, i + 1);
        // Se adopta el mayor entre la longitud impar y la par
        int len = Math.max(odd, even);

        // Si supera la longitud del palíndromo más largo actual (end - start + 1), se actualizan las posiciones de inicio y fin
        if (len > end - start + 1) {
            // (len - 1) / 2 es la distancia desde el centro hacia la izquierda
            start = i - (len - 1) / 2;
            // len / 2 es la distancia desde el centro hacia la derecha
            end = i + len / 2;
        }
    }
    // El segundo argumento de substring tiene la especificación de «no incluido», por lo que se especifica end + 1 para incluir el carácter en end
    return s.substring(start, end + 1);
}
```
