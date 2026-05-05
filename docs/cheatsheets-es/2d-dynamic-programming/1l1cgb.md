# Finding the Longest Common Subsequence — Encontrar la longitud de la subsecuencia común más larga entre dos cadenas

## Esencia del problema

Se dan dos cadenas `text1` y `text2`. Se debe devolver la **longitud** de la **subsecuencia (subsequence)** común más larga que aparece en ambas cadenas. Una subsecuencia es una secuencia obtenida seleccionando caracteres de la cadena original manteniendo su orden relativo, sin necesidad de que sean consecutivos.

## Idea central

Si los últimos caracteres de las dos cadenas coinciden, ese carácter forma parte de la LCS, y el subproblema restante consiste en ambas cadenas acortadas en un carácter. Si no coinciden, se adopta el mayor de los dos subproblemas en los que se acorta una u otra cadena en un carácter. Al llenar esta estructura recursiva de forma ascendente (bottom-up) en una tabla bidimensional, se obtiene la solución óptima sin cálculos redundantes.

## Proceso de razonamiento

1. **Definición del subproblema**: Se define `dp[i][j]` como la longitud de la LCS entre los primeros `i` caracteres de `text1` y los primeros `j` caracteres de `text2`. La respuesta final que se busca es `dp[m][n]` (`m` = longitud de text1, `n` = longitud de text2)
2. **Transición cuando los últimos caracteres coinciden**: Cuando `text1[i-1] == text2[j-1]`, este carácter forma parte de la LCS. Por lo tanto, `dp[i][j] = dp[i-1][j-1] + 1`. Se suma 1 a la respuesta del subproblema en el que ambas cadenas se acortan en un carácter
3. **Transición cuando los últimos caracteres no coinciden**: Cuando `text1[i-1] != text2[j-1]`, al menos uno de los últimos caracteres no forma parte de la LCS. Se adopta el mayor entre el caso en que se acorta `text1` en un carácter (`dp[i-1][j]`) y el caso en que se acorta `text2` en un carácter (`dp[i][j-1]`). Es decir, `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`
4. **Caso base**: Cuando alguna de las cadenas está vacía (longitud 0), no existe subsecuencia común, por lo que `dp[0][j] = 0` y `dp[i][0] = 0`. En Java, al crear un `int[][]`, todos los elementos se inicializan en 0, por lo que no es necesario establecerlos explícitamente
5. **Forma de llenar la tabla**: `dp[i][j]` depende de `dp[i-1][j-1]`, `dp[i-1][j]` y `dp[i][j-1]`. Por lo tanto, si se llena `i` de 1 a m y `j` de 1 a n en orden ascendente, las celdas referenciadas siempre estarán calculadas previamente
6. **Valor a devolver**: Después de llenar toda la tabla, `dp[m][n]` representa la longitud de la LCS de ambas cadenas completas, y este valor se devuelve

## Conocimientos previos

### Qué es una subsecuencia (Subsequence)

Una subsecuencia es una secuencia obtenida al eliminar cero o más caracteres de una cadena y extraer los caracteres restantes sin cambiar su orden relativo. A diferencia de una subcadena (substring), los caracteres no necesitan ser consecutivos.

```
Cadena: "abcde"
Ejemplo de subsecuencia: "ace" (se seleccionan a, c, e; se eliminan b, d)
Ejemplo que no es subsecuencia: "aec" (viola el orden a→c→e en la cadena original)
```

### Creación e inicialización de un arreglo bidimensional

En Java, al declarar `new int[m+1][n+1]`, se crea un arreglo bidimensional de tamaño `(m+1) × (n+1)` con todos los elementos inicializados en 0.

```java
int[][] dp = new int[m + 1][n + 1];  // Crea un arreglo de (m+1) filas × (n+1) columnas, todos los elementos en 0
dp[i][j] = 5;                         // Asigna el valor 5 a la fila i, columna j
int val = dp[i][j];                    // Obtiene el valor de la fila i, columna j → 5
```

### Qué es Math.max

Es un método que devuelve el mayor de dos enteros. Se utiliza para comparar las soluciones de dos subproblemas y seleccionar la mejor.

```java
Math.max(3, 7);    // Devuelve el mayor de los dos valores → 7
Math.max(dp[i-1][j], dp[i][j-1]);  // Compara los valores de dos celdas y devuelve el mayor
```

### Qué es charAt

Es un método que devuelve el carácter en la posición especificada de una cadena. El índice comienza en 0.

```java
String s = "abc";
s.charAt(0);    // Devuelve el carácter en el índice 0 → 'a'
s.charAt(2);    // Devuelve el carácter en el índice 2 → 'c'
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m × n) — Se llena cada celda de la tabla de m×n una sola vez |
| Space | O(m × n) — Se utiliza un arreglo bidimensional de tamaño (m+1)×(n+1) |

## Código

```java
// Entrada: dos cadenas text1 y text2
// Salida: devuelve la longitud de la subsecuencia común más larga de las dos cadenas como int
public int longestCommonSubsequence(String text1, String text2) {
    // Se asigna la longitud de text1 a m y la longitud de text2 a n. Se usan para el tamaño de la tabla y el límite de los bucles
    int m = text1.length();
    int n = text2.length();

    // dp[i][j] = longitud de la LCS entre los primeros i caracteres de text1 y los primeros j caracteres de text2
    // El tamaño es (m+1)×(n+1) para representar el caso en que alguna cadena esté vacía (caso base)
    // En Java, todos los elementos de int[][] se inicializan en 0, por lo que los casos base dp[0][j]=0 y dp[i][0]=0 se satisfacen automáticamente
    int[][] dp = new int[m + 1][n + 1];

    // i representa cuántos caracteres del inicio de text1 se están considerando
    for (int i = 1; i <= m; i++) {
        // j representa cuántos caracteres del inicio de text2 se están considerando
        for (int j = 1; j <= n; j++) {
            // El índice de dp comienza en 1, pero el índice de la cadena comienza en 0, por lo que se accede con i-1 y j-1
            if (text1.charAt(i - 1) == text2.charAt(j - 1)) {
                // Si los caracteres coinciden, el carácter coincidente se añade a la LCS, por lo que se suma 1 a la respuesta del subproblema con ambas cadenas acortadas en un carácter
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                // Si los caracteres no coinciden, se adopta el caso con la LCS más larga entre acortar text1 en un carácter y acortar text2 en un carácter
                dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }

    // La celda inferior derecha de la tabla representa la longitud de la LCS de text1 y text2 completos
    return dp[m][n];
}
```
