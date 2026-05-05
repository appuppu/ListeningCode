# Computing Power of a Number Efficiently — Calcular eficientemente la potencia de un número de punto flotante

## Esencia del problema

Se proporcionan un número de punto flotante `x` y un entero `n`. Se debe calcular y devolver `x` elevado a la potencia `n`. Dado que `n` puede tomar valores negativos, es necesario manejar exponentes negativos, y se debe calcular de manera eficiente incluso cuando el valor absoluto de `n` es muy grande.

## Idea central

Si se representa el exponente `n` en binario, el cálculo de la potencia se puede descomponer en la operación de "elevar `x` al cuadrado repetidamente y multiplicar el resultado solo cuando cada bit de `n` es 1". Esto reduce las multiplicaciones de n veces a log(n) veces.

## Proceso de razonamiento

1. **Convertir el exponente negativo en positivo**: `x^(-n)` es igual a `(1/x)^n`, por lo que si `n` es negativo, se reemplaza `x` por `1/x` y se invierte el signo de `n`, unificando así el problema en exponentes positivos
2. **Multiplicar n veces es demasiado lento**: Multiplicar `x` de forma ingenua `n` veces tiene un costo de O(n). Cuando `n` es de miles de millones, esto no es viable. Se necesita un método que reduzca el exponente a la mitad en cada paso
3. **La potencia se puede descomponer en cuadrados sucesivos**: Al igual que `x^10 = x^8 × x^2`, cualquier potencia se puede descomponer en un producto de potencias de 2. Esto corresponde a la representación binaria del exponente `n`. Como `10` en binario es `1010`, solo se necesita multiplicar `x^8` y `x^2`, que corresponden a los dígitos donde el bit es 1
4. **Se determina cada dígito con operaciones de bits**: Si el bit menos significativo de `n` es 1 se puede verificar con `(n & 1) == 1`. Si es 1, se multiplica el resultado por el valor actual de `x` (que ha sido elevado a la potencia de 2 correspondiente al dígito actual)
5. **Se avanza al siguiente dígito elevando x al cuadrado repetidamente**: En cada iteración del bucle, se actualiza `x` a `x * x`, de modo que `x` se convierte en el cuadrado, la cuarta potencia, la octava potencia... del valor original. Al mismo tiempo, se desplaza `n` un bit a la derecha para avanzar al siguiente dígito
6. **Condición de terminación del bucle**: Al desplazar `n` a la derecha continuamente, eventualmente se convierte en 0. Mientras `n > 0`, el bucle se ejecuta y se procesan todos los bits

## Conocimientos previos

### Qué son las operaciones de bits (& y >>)

Son operaciones que tratan los enteros como números binarios y los manipulan bit a bit. `&` (AND) produce 1 solo cuando ambos bits son 1. `>>` (desplazamiento a la derecha) desplaza la secuencia de bits hacia la derecha, descartando el bit menos significativo (equivale a dividir entre 2).

```java
int n = 10;           // Binario: 1010
n & 1;                // Obtener el bit menos significativo → 0 (par)
n >>= 1;              // Desplazar 1 bit a la derecha → n es 5 (binario: 101)
n & 1;                // Obtener el bit menos significativo → 1 (impar)
```

### Qué es la exponenciación rápida (Fast Exponentiation)

Es una técnica que utiliza la representación binaria del exponente para calcular la potencia con O(log n) multiplicaciones. Tomando `x^13` como ejemplo, como `13` en binario es `1101`, se descompone en `x^13 = x^8 × x^4 × x^1`. En el bucle, se eleva `x` al cuadrado repetidamente (`x → x^2 → x^4 → x^8`) y se multiplica el resultado solo cuando el bit correspondiente es 1.

```java
// Proceso de cálculo de x^13 (13 = 1101 en binario)
// Bit 0: 1 → result *= x    (result = x^1),  x = x^2
// Bit 1: 0 → Omitir,                          x = x^4
// Bit 2: 1 → result *= x^4  (result = x^5),  x = x^8
// Bit 3: 1 → result *= x^8  (result = x^13), x = x^16
```

### Por qué es necesario el cast a tipo long

El rango del tipo `int` en Java es de `-2^31` a `2^31 - 1`. Cuando `n = -2^31`, `-n` se convierte en `2^31`, lo que excede el rango de `int` y produce un desbordamiento. Si se hace el cast a tipo `long` antes de invertir el signo, se puede evitar este problema.

```java
int n = Integer.MIN_VALUE;   // -2147483648
long power = (long) n;       // -2147483648L (convertido a tipo long)
power = -power;              // 2147483648L (no representable en int, pero seguro en long)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(log n) — Se itera tantas veces como bits tiene el exponente n |
| Space | O(1) — Solo se utilizan 3 variables: result, x y power, sin necesidad de pila de recursión |

## Código

```java
// Entrada: número de punto flotante x y entero n
// Salida: devuelve el valor de x elevado a la n como double
double myPow(double x, int n) {
    // Se convierte a tipo long porque si n = -2^31, la inversión de signo con int causa desbordamiento
    long power = (long) n;

    // Se convierte el exponente negativo en positivo: x^(-n) = (1/x)^n
    // Esta conversión permite unificar el procesamiento posterior solo con exponentes positivos
    if (power < 0) {
        x = 1 / x;
        power = -power;
    }

    // Se inicializa la variable acumuladora del resultado en 1.0
    // Se acumula el resultado final multiplicando las potencias de x correspondientes a los dígitos con bit 1
    double result = 1.0;

    // Se procesan todos los bits de power en orden desde el menos significativo
    // Al desplazar power a la derecha continuamente, eventualmente se convierte en 0 y se completa el procesamiento de todos los dígitos
    while (power > 0) {
        // Se determina si el bit menos significativo (el dígito que se está procesando) es 1 mediante power & 1
        if ((power & 1) == 1) {
            // Si el bit es 1: en este punto x es el valor original de x elevado al cuadrado tantas veces como dígitos procesados (x original elevado a 2^k)
            // Se multiplica la contribución de este dígito en result para reflejarla
            result *= x;
        }
        // Se eleva x al cuadrado para actualizarlo al valor de potencia correspondiente al siguiente dígito (potencia con el doble del exponente)
        x *= x;
        // Se desplaza power 1 bit a la derecha para avanzar al siguiente dígito (se descarta el bit menos significativo)
        power >>= 1;
    }
    // Se devuelve el resultado final con las contribuciones de todos los bits multiplicadas entre sí
    return result;
}
```
