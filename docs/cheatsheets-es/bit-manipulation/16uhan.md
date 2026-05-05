# Counting Bits for Every Number Up to N — Devolver un arreglo con la cantidad de bits en 1 de cada entero del 0 al N

## Esencia del problema

Se recibe un entero no negativo `n`. Se debe devolver un arreglo de longitud `n + 1`. El elemento en el índice `i` del arreglo contiene la **cantidad de bits en 1** en la representación binaria de `i`. Ejemplo: cuando n=5, 0→0, 1→1, 2→1, 3→2, 4→1, 5→2, por lo que se devuelve `[0,1,1,2,1,2]`.

## Idea central

La cantidad de bits en 1 de cualquier entero `i` es igual a la cantidad de bits en 1 del valor `i >> 1` (obtenido al desplazar `i` un bit a la derecha) más el bit menos significativo de `i` (`i & 1`). Gracias a esta relación recursiva, se puede reutilizar el resultado de los valores más pequeños y calcular cada valor en O(1).

## Proceso de razonamiento

1. **Observar la estructura binaria**: Al desplazar un bit a la derecha la representación binaria del entero `i`, el bit menos significativo desaparece y la secuencia de bits restante es igual a `i / 2` (con truncamiento). Es decir, la secuencia de bits de `i` tiene la estructura "secuencia de bits de `i >> 1`" + "1 bit menos significativo"
2. **Descomponer la cantidad de bits en 1**: A partir de la estructura anterior, la cantidad de 1s en `i` se descompone en "cantidad de 1s en `i >> 1`" + "si el bit menos significativo es 1 o no (0 o 1)". Expresado como fórmula: `countBits(i) = countBits(i >> 1) + (i & 1)`
3. **Calcular en orden ascendente permite reutilizar resultados**: Dado que `i >> 1` siempre es un valor menor que `i`, al calcular en orden desde `i = 0`, `result[i >> 1]` siempre estará previamente calculado. Gracias a esta propiedad, se puede completar el arreglo con un bucle de forma secuencial en lugar de usar recursión
4. **El propio arreglo de resultados funciona como tabla DP**: Se utiliza el arreglo de resultados `result` directamente como tabla DP. Con `result[0] = 0` como caso base, se completa desde `i = 1` hasta `n` con `result[i] = result[i >> 1] + (i & 1)`. No se necesita ninguna estructura de datos adicional

## Conocimientos previos

### Qué es la operación de desplazamiento a la derecha (`>>`)

Es una operación que desplaza la representación binaria de un entero hacia la derecha una cantidad especificada de bits. Al desplazar un bit a la derecha, el bit menos significativo desaparece y el valor resultante es el cociente de dividir entre 2 (con truncamiento).

```java
int a = 6;      // Binario: 110
int b = a >> 1;  // Binario: 011 → el valor es 3 (6 ÷ 2 = 3)

int c = 7;      // Binario: 111
int d = c >> 1;  // Binario: 011 → el valor es 3 (7 ÷ 2 = 3, con truncamiento)
```

### Qué es la operación AND a nivel de bits (`&`)

Es una operación que compara cada bit de dos enteros y establece en 1 solo los bits que son 1 en ambos. `i & 1` extrae únicamente el bit menos significativo de `i` y devuelve 1 si `i` es impar o 0 si `i` es par.

```java
int a = 5;       // Binario: 101
int b = a & 1;   // Binario: 001 → el valor es 1 (impar, por lo que el bit menos significativo es 1)

int c = 4;       // Binario: 100
int d = c & 1;   // Binario: 000 → el valor es 0 (par, por lo que el bit menos significativo es 0)
```

### Qué es la programación dinámica (DP)

Es una técnica que divide un problema grande en subproblemas más pequeños y registra los resultados de los subproblemas en un arreglo para reutilizarlos. En este problema, se utiliza `result[i >> 1]` (el resultado ya calculado de un valor más pequeño) para obtener `result[i]` en O(1).

```java
int[] result = new int[n + 1];  // Crear el arreglo que sirve como tabla DP y resultado
result[0] = 0;                  // Caso base: la cantidad de bits en 1 de 0 es 0
result[i] = result[i >> 1] + (i & 1);  // Ecuación de transición: reutilizar el resultado ya conocido
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Para cada valor del 1 al n, solo se realiza una operación de desplazamiento de bits y una operación AND |
| Space | O(n) — Se utiliza un arreglo de longitud n+1 para almacenar los resultados (al ser la salida en sí, el espacio adicional también puede interpretarse como O(1)) |

## Código

```java
// Entrada: entero no negativo n
// Salida: int[] de longitud n+1. Cada result[i] contiene la cantidad de bits en 1 en la representación binaria de i
public int[] countBits(int n) {
    // Crear el arreglo que sirve como tabla DP y resultado. Con new int[n+1] todos los elementos se inicializan a 0,
    // por lo que result[0] = 0 (la cantidad de bits en 1 de 0 es 0) se cumple automáticamente
    int[] result = new int[n + 1];

    // i=0 ya es correcto con valor 0, por lo que el recorrido comienza desde i=1
    for (int i = 1; i <= n; i++) {
        // result[i >> 1]: cantidad de bits en 1 del valor obtenido al desplazar i un bit a la derecha (i >> 1 siempre es menor que i, por lo que ya está calculado)
        // i & 1: bit menos significativo de i (1 si es impar, 0 si es par)
        // La suma de estos dos valores da el total de bits en 1 en la representación binaria de i
        result[i] = result[i >> 1] + (i & 1);
    }
    // Se devuelve el arreglo donde cada elemento result[i] contiene la cantidad de bits en 1 del índice i
    return result;
}
```
