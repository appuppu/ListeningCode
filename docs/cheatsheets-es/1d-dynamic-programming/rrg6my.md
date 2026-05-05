# Counting Ways to Decode a Numeric String — Encontrar el número total de formas de convertir una cadena numérica en letras del alfabeto

## Esencia del problema

Se da una cadena `s` compuesta únicamente por dígitos. Según la correspondencia A=1, B=2, ..., Z=26, se debe devolver cuántas formas existen de decodificar la cadena en una secuencia de letras del alfabeto. Por ejemplo, "226" se puede decodificar de 3 formas: "BZ"(2,26), "VF"(22,6) y "BBF"(2,2,6).

## Idea central

El número de formas de decodificación en cada posición se obtiene sumando "el número de formas restantes al decodificar un carácter (1 dígito)" y "el número de formas restantes al decodificar dos caracteres (2 dígitos)". Como esta relación de dependencia se limita únicamente a los dos resultados inmediatamente anteriores, dos variables son suficientes.

## Proceso de razonamiento

1. **Cada posición tiene como máximo dos opciones**: Al observar el dígito en la posición `i`, existen como máximo dos alternativas: decodificarlo como 1 dígito (1–9) para obtener una letra, o decodificarlo como 2 dígitos (10–26) para obtener una letra. Dado que esta elección ocurre de forma recursiva, es necesario calcular sistemáticamente el número de formas de decodificación en cada posición
2. **'0' no se puede decodificar de forma individual**: No existe ninguna letra del alfabeto que corresponda a '0'. Si el dígito en la posición `i` es '0', la decodificación de 1 dígito a partir de esa posición es imposible, por lo que el número de formas es 0. '0' solo se puede decodificar combinándolo con el dígito anterior como 10 o 20
3. **Establecer la recurrencia de DP**: Se define `dp[i]` como "el número de formas de decodificación desde la posición `i` hasta el final". Si el dígito en la posición `i` no es '0', se suma `dp[i+1]`, que corresponde a las formas restantes al decodificar 1 dígito. Además, si los 2 dígitos en las posiciones `i` e `i+1` están en el rango de 10 a 26, también se suma `dp[i+2]`, que corresponde a las formas restantes al decodificar 2 dígitos. Es decir, `dp[i] = dp[i+1] + dp[i+2]` (con condiciones)
4. **La dependencia se limita a los dos elementos siguientes**: `dp[i]` depende únicamente de `dp[i+1]` y `dp[i+2]`. Por lo tanto, no es necesario mantener todo el arreglo; basta con dos variables (`next1` = `dp[i+1]`, `next2` = `dp[i+2]`) para realizar el cálculo. Esto permite lograr un espacio O(1)
5. **Recorrer desde el final hasta el inicio**: Dado que `dp[i]` depende de `dp[i+1]` y `dp[i+2]`, es necesario que el lado del final esté determinado primero. Por ello, se itera desde el final de la cadena hacia el inicio, calculando el número de formas en cada posición
6. **Valor a devolver**: Al finalizar el bucle, `next1` contiene `dp[0]` (el número de formas de decodificación de toda la cadena). Se devuelve este valor

## Conocimientos previos

### ¿Qué es la programación dinámica (DP)?

Es una técnica que divide un problema grande en subproblemas más pequeños y reutiliza los resultados de los subproblemas para obtener la respuesta del problema completo. Para evitar recalcular los mismos subproblemas repetidamente, se guardan los resultados ya calculados (memorización) o se calculan en orden (bottom-up).

```java
// Patrón típico de DP bottom-up: secuencia de Fibonacci
int prev2 = 0, prev1 = 1;
for (int i = 2; i <= n; i++) {
    int current = prev1 + prev2;  // Se calcula el valor actual usando solo los dos resultados anteriores
    prev2 = prev1;                // Se deslizan las variables para preparar la siguiente iteración
    prev1 = current;
}
// prev1 contiene el resultado final
```

### ¿Qué es Integer.parseInt?

Es un método que convierte una cadena en un entero. Se utiliza para evaluar una subcadena como un valor numérico.

```java
Integer.parseInt("26");          // Convierte la cadena "26" en el entero 26 → 26
Integer.parseInt("09");          // Convierte la cadena "09" en el entero 9 → 9
```

### ¿Qué es String.substring?

Es un método que obtiene una subcadena dentro del rango especificado de una cadena. Los argumentos son el índice de inicio (incluido) y el índice de fin (excluido).

```java
String s = "226";
s.substring(0, 2);   // Devuelve la subcadena desde el índice 0 hasta el 1 → "22"
s.substring(1, 3);   // Devuelve la subcadena desde el índice 1 hasta el 2 → "26"
```

### ¿Qué es String.charAt?

Es un método que devuelve el carácter en la posición especificada de una cadena. Como devuelve un tipo char, se puede determinar si es un dígito comparándolo con el carácter '0'.

```java
String s = "206";
s.charAt(0);          // Devuelve el carácter en el índice 0 → '2'
s.charAt(1);          // Devuelve el carácter en el índice 1 → '0'
s.charAt(1) == '0';   // Determina si el carácter es '0' → true
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita un único recorrido de la cadena desde el final hasta el inicio |
| Space | O(1) — Se calcula con solo dos variables (next1, next2), sin utilizar un arreglo |

## Código

```java
// Entrada: cadena s compuesta únicamente por dígitos
// Salida: devuelve como int el número total de formas de decodificar la cadena s en una secuencia de letras
public int numDecodings(String s) {
    // next1 = número de formas desde la posición 1 a la derecha (dp[i+1]), next2 = número de formas desde la posición 2 a la derecha (dp[i+2])
    // A la derecha del final de la cadena se define como "formas de decodificar una cadena vacía = 1 forma", por lo que el valor inicial es 1
    int next1 = 1, next2 = 1;

    // dp[i] depende de dp[i+1] y dp[i+2], por lo que se recorre desde el final hasta el inicio para determinar primero el lado derecho
    for (int i = s.length() - 1; i >= 0; i--) {
        int current;

        if (s.charAt(i) == '0') {
            // '0' no corresponde a ninguna letra por sí solo, por lo que el número de formas de decodificación desde esta posición es 0
            // '0' solo se puede decodificar combinándolo con el dígito anterior como 10 o 20
            current = 0;
        } else {
            // Decodificación de 1 dígito: se toma el dígito en la posición i (1–9) como una letra, y las formas restantes desde i+1 en adelante son next1
            current = next1;

            // Se verifica si es posible la decodificación de 2 dígitos (si i+1 está dentro del rango de la cadena, se pueden obtener 2 dígitos)
            if (i + 1 < s.length()) {
                // Se obtiene la subcadena de 2 dígitos con s.substring(i, i+2) y se convierte en un entero
                int two = Integer.parseInt(
                    s.substring(i, i + 2));
                // Si los 2 dígitos están en el rango de 10 a 26, se decodifican como una letra y se suman next2 formas desde i+2 en adelante
                if (two >= 10 && two <= 26)
                    current += next2;
            }
        }

        // Se deslizan las variables una posición a la izquierda: el current actual se convierte en next1 (1 posición a la derecha) en la siguiente iteración
        next2 = next1;
        next1 = current;
    }

    // Al finalizar el bucle, next1 contiene el último current calculado (= dp[0])
    // Este es el número total de formas de decodificación de toda la cadena
    return next1;
}
```
