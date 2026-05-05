# Finding the Minimum Edits to Transform One String Into Another — Encontrar la distancia mínima de edición entre dos cadenas

## Esencia del problema

Se dan dos cadenas `word1` y `word2`. Se debe devolver el **número mínimo de operaciones** necesarias para transformar `word1` en `word2`. Las operaciones permitidas son "inserción", "eliminación" y "sustitución", y cada una cuenta como una operación.

## Idea central

Al comparar dos cadenas desde el final, si los caracteres actuales coinciden, no se necesita ninguna operación y se avanzan ambos índices; si no coinciden, se elige la operación de menor costo entre "inserción", "eliminación" y "sustitución". La superposición de estos subproblemas se resuelve con una tabla DP, y dado que cada celda solo depende de la fila actual y la fila anterior, se puede optimizar el espacio utilizando únicamente un arreglo de una fila.

## Proceso de razonamiento

1. **Las opciones en cada posición se limitan a tres**: Al comparar `word1[i]` con `word2[j]`, si los caracteres coinciden, se avanza a `(i+1, j+1)` sin realizar ninguna operación. Si no coinciden, se elige el menor costo entre "inserción (avanzar j)", "eliminación (avanzar i)" y "sustitución (avanzar ambos)". Esta estructura recursiva sugiere la aplicación de DP
2. **Definición de la tabla DP**: Se define `dp[i][j]` como "el número mínimo de operaciones para transformar `word1[i:]` en `word2[j:]`". La respuesta final es `dp[0][0]`
3. **Determinar los casos base**: Si el resto de `word1` está vacío (`i == m`), se necesitan tantas inserciones como caracteres quedan en `word2[j:]`, por lo que `dp[m][j] = n - j`. Si el resto de `word2` está vacío (`j == n`), se necesitan tantas eliminaciones como caracteres quedan en `word1[i:]`, por lo que `dp[i][n] = m - i`
4. **Determinar la dirección de llenado bottom-up**: Como `dp[i][j]` depende de `dp[i+1][j+1]`, `dp[i][j+1]` y `dp[i+1][j]`, se llena en orden inverso: `i` desde `m-1` hasta `0` y `j` desde `n-1` hasta `0`
5. **Optimizar el espacio**: Para calcular cada fila `i`, solo se necesitan "la fila anterior (`i+1`)" y "la fila actual (`i`)". Por lo tanto, no es necesario mantener un arreglo bidimensional; basta con dos arreglos unidimensionales: `prev` (fila anterior) y `curr` (fila actual). Al terminar el cálculo de cada fila, se intercambian con `prev = curr`
6. **Valor a devolver**: Después de procesar todas las filas, `prev[0]` corresponde al valor de `dp[0][0]`, que es el número mínimo de operaciones para transformar `word1` completo en `word2` completo

## Conocimientos previos

### ¿Qué es la Edit Distance (distancia de edición)?

Es una métrica que representa la "similitud" entre dos cadenas, definida como el número mínimo de operaciones necesarias para transformar una cadena en la otra. También se conoce como distancia de Levenshtein. Las operaciones permitidas son las siguientes tres, cada una con costo 1.

- **Inserción (Insert)**: Se agrega un carácter a la cadena
- **Eliminación (Delete)**: Se elimina un carácter de la cadena
- **Sustitución (Replace)**: Se cambia un carácter de la cadena por otro carácter diferente

### ¿Qué es el DP bottom-up (programación dinámica)?

Es una técnica que resuelve subproblemas recursivos registrándolos en una tabla, comenzando desde los problemas más pequeños. A diferencia de la memorización recursiva (top-down), no tiene la sobrecarga de las llamadas recursivas y permite aplicar la optimización de espacio con mayor facilidad.

```java
// Ejemplo de DP unidimensional: calcular la secuencia de Fibonacci con 2 variables
int a = 0, b = 1;
for (int i = 2; i <= n; i++) {
    int temp = a + b;  // El valor actual depende solo de los 2 valores anteriores
    a = b;             // Se descarta el valor antiguo y se actualiza
    b = temp;
}
```

### ¿Qué es Math.min()?

Es un método estándar de Java que devuelve el menor de dos enteros. Para comparar tres o más valores, se anidan las llamadas.

```java
Math.min(3, 5);                    // → 3
Math.min(3, Math.min(5, 1));       // → 1 (el mínimo de 3 valores)
```

### ¿Qué es String.charAt(int index)?

Es un método que devuelve el carácter en la posición especificada de la cadena. El índice comienza desde 0.

```java
String s = "abc";
s.charAt(0);  // → 'a'
s.charAt(2);  // → 'c'
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m × n) — Para cada posición de `word1`, se recorren todas las posiciones de `word2` |
| Space | O(n) — En lugar de una tabla bidimensional, se mantiene únicamente un arreglo de una fila |

## Código

```java
// Entrada: dos cadenas word1 (de longitud m) y word2 (de longitud n)
// Salida: se devuelve como int el número mínimo de operaciones para transformar word1 en word2
public int minDistance(String w1, String w2) {
    int m = w1.length();  // Se obtiene la longitud de word1
    int n = w2.length();  // Se obtiene la longitud de word2

    // Arreglo prev: corresponde a la fila inferior (i+1) de la tabla DP
    // Se inicializa con prev[j] = n - j: cuando word1 está vacío, el número de operaciones para insertar los n-j caracteres restantes de word2[j:]
    int[] prev = new int[n + 1];
    for (int j = 0; j <= n; j++)
        prev[j] = n - j;

    // Se recorre word1 en orden inverso desde el final hasta el inicio (i es la posición actual en word1)
    for (int i = m - 1; i >= 0; i--) {
        // Arreglo curr: corresponde a la fila actual (i) de la tabla DP
        int[] curr = new int[n + 1];
        // Cuando word2 está vacío, el número de operaciones para eliminar los m-i caracteres restantes de word1[i:]
        curr[n] = m - i;

        // Se recorre word2 en orden inverso desde el final hasta el inicio (j es la posición actual en word2)
        for (int j = n - 1; j >= 0; j--) {
            if (w1.charAt(i) == w2.charAt(j)) {
                // Si los caracteres coinciden, no se necesita operación. prev[j+1] es la respuesta del subproblema dp[i+1][j+1] donde se avanzan ambos un carácter
                curr[j] = prev[j + 1];
            } else {
                // Si no coinciden, se elige el menor costo entre las 3 operaciones y se suma 1 por la operación actual
                curr[j] = 1 + Math.min(
                    curr[j + 1],           // Inserción: se avanza un carácter en word2 (dp[i][j+1])
                    Math.min(prev[j],      // Eliminación: se avanza un carácter en word1 (dp[i+1][j])
                        prev[j + 1]));     // Sustitución: se avanza un carácter en ambos (dp[i+1][j+1])
            }
        }
        // Se guarda la fila actual como la fila anterior para preparar la siguiente iteración (i-1)
        prev = curr;
    }

    // prev[0] corresponde a dp[0][0], el número mínimo de operaciones para transformar word1 completo en word2 completo
    return prev[0];
}
```
