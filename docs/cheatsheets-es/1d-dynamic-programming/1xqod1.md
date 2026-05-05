# Counting All Palindromic Substrings — Contar el número total de subcadenas palindrómicas en una cadena

## Esencia del problema

Se da una cadena `s`. De todas las subcadenas de `s`, se debe devolver el **número total** de aquellas que son palíndromos (cadenas que se leen igual de izquierda a derecha que de derecha a izquierda). Cada subcadena de un solo carácter también se cuenta como un palíndromo.

## Idea central

Todo palíndromo tiene un "centro". Si se fija el centro y se expande hacia la izquierda y la derecha, se pueden enumerar todos los palíndromos que se originan desde ese centro. Los candidatos a centro son solo 2n-1 en total: cada carácter (longitud impar) y cada espacio entre dos caracteres adyacentes (longitud par), por lo que es posible realizar una búsqueda exhaustiva.

## Proceso de razonamiento

1. **Observar la propiedad estructural de los palíndromos**: Todo palíndromo es simétrico respecto a su centro. Los palíndromos de longitud impar tienen un solo carácter como centro, y los de longitud par tienen dos caracteres adyacentes como centro. Aprovechando esta propiedad, se pueden descubrir palíndromos de manera eficiente partiendo desde el centro
2. **Expandir desde el centro hacia afuera**: Para un centro dado, se establecen dos punteros `left` y `right`, y se expande hacia afuera mientras `s.charAt(left) == s.charAt(right)`. Cada vez que la expansión tiene éxito, se encuentra un nuevo palíndromo, por lo que se incrementa el contador en 1
3. **Procesar por separado los de longitud impar y par**: Para cada índice `i`, se llama a `expand(s, i, i)` para contar los palíndromos de longitud impar, y a `expand(s, i, i+1)` para contar los de longitud par. Con estas dos llamadas se cubren todos los palíndromos centrados en `i`
4. **Definir la condición de parada de la expansión**: La expansión se detiene cuando `left` es menor que 0, cuando `right` es mayor o igual que la longitud de la cadena, o cuando los caracteres izquierdo y derecho no coinciden. Esto previene accesos fuera de rango y permite la máxima expansión posible
5. **Sumar los resultados de cada centro**: La suma de los palíndromos de longitud impar y par para todos los índices da el número total de subcadenas palindrómicas en toda la cadena
6. **Valor a devolver**: Se devuelve como entero `result` la suma total de palíndromos obtenidos de todos los centros

## Conocimientos previos

### ¿Qué es un palíndromo (Palindrome)?

Es una cadena que se lee igual de izquierda a derecha que de derecha a izquierda. `"aba"`, `"abba"` y `"a"` son todos palíndromos. Existen dos tipos de palíndromos: de longitud impar (el centro es un solo carácter) y de longitud par (el centro está entre dos caracteres).

```
Ejemplo de longitud impar: "aba"  → el centro es 'b'
Ejemplo de longitud par:  "abba" → el centro está entre 'b' y 'b'
```

### ¿Qué es la expansión desde el centro (Expand Around Center)?

Es una técnica que fija el centro de un palíndromo y expande un carácter a la vez hacia la izquierda y la derecha para determinar si la subcadena es un palíndromo. La expansión continúa mientras los caracteres coincidan desde el centro hacia afuera, y se detiene cuando dejan de coincidir.

```
Cadena: "abacd"
Expansión desde el centro i=1 ('b'):
  left=1, right=1 → 'b'=='b' → palíndromo "b" encontrado, count=1
  left=0, right=2 → 'a'=='a' → palíndromo "aba" encontrado, count=2
  left=-1 → fuera de rango, se detiene la expansión
```

### ¿Qué es String.charAt(int index)?

Es un método que devuelve el carácter en el índice especificado de la cadena. El índice comienza en 0.

```java
String s = "abc";
s.charAt(0);    // devuelve 'a'
s.charAt(2);    // devuelve 'c'
s.length();     // devuelve la longitud de la cadena → 3
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n²) — Para cada centro (n centros) se realiza una expansión de O(n) como máximo |
| Space | O(1) — Solo se utilizan punteros y contadores, sin estructuras de datos adicionales |

## Código

```java
// Entrada: cadena s
// Salida: devuelve como entero el número total de subcadenas palindrómicas de s

// Expande hacia la izquierda y la derecha desde el centro especificado y devuelve el número de palíndromos encontrados
// Si left y right tienen el mismo valor, se buscan palíndromos de longitud impar; si son valores adyacentes, de longitud par
int expand(String s, int left, int right) {
    int count = 0;
    // Expande mientras se cumplan las 3 condiciones: extremo izquierdo dentro del rango, extremo derecho dentro del rango, caracteres izquierdo y derecho coinciden
    while (left >= 0 && right < s.length()
            && s.charAt(left) == s.charAt(right)) {
        count++;   // s.substring(left, right+1) es un nuevo palíndromo, se incrementa el contador
        left--;    // se expande 1 posición a la izquierda
        right++;   // se expande 1 posición a la derecha
    }
    // Devuelve el número total de palíndromos encontrados desde este centro
    return count;
}

int countSubstrings(String s) {
    // Variable que acumula el número de palíndromos encontrados desde todos los centros
    int result = 0;

    // Recorre cada índice como candidato a centro
    for (int i = 0; i < s.length(); i++) {
        // Palíndromos de longitud impar: se inicia la expansión desde un centro de 1 carácter con left=i, right=i
        result += expand(s, i, i);
        // Palíndromos de longitud par: se inicia la expansión desde un centro de 2 caracteres adyacentes con left=i, right=i+1
        result += expand(s, i, i + 1);
    }
    // Devuelve la suma total de palíndromos obtenidos de todos los centros
    return result;
}
```
