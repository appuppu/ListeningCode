# Adding Two Numbers Without the Plus Operator — Calcular la suma de dos enteros sin usar el operador de suma

## Esencia del problema

Se dan dos enteros `a` y `b`. Se debe calcular y devolver la suma de los dos enteros utilizando **únicamente operaciones de bits**, sin usar los operadores `+` ni `-`.

## Idea central

La suma en binario se puede descomponer en dos partes: "la suma de cada dígito sin acarreo (XOR)" y "el acarreo (AND desplazado a la izquierda)". Si se repite esta descomposición hasta que el acarreo sea cero, se obtiene la suma final.

## Proceso de razonamiento

1. **Pensar en la esencia de la suma a nivel de bits**: La suma de cada dígito en binario, ignorando el acarreo, da como resultado 1 cuando "solo uno de los dos bits es 1". Esto es exactamente la operación XOR (`a ^ b`)
2. **Calcular el acarreo por separado**: El acarreo se produce "cuando ambos dígitos son 1". Esto se obtiene con la operación AND (`a & b`). Como el acarreo afecta al siguiente dígito, se desplaza el resultado 1 bit a la izquierda (`(a & b) << 1`)
3. **Es necesario sumar el acarreo al resultado parcial**: La suma final se obtiene sumando el resultado del XOR y el acarreo, pero no se puede usar `+`. Sin embargo, como esto se reduce al mismo problema de "sumar dos números", se puede aplicar el mismo proceso de forma recursiva
4. **Definir la condición de terminación de la recursión**: Cuando el acarreo `b` es cero, no queda ningún valor por sumar, por lo que `a` en ese momento es la suma final. Este es el caso base
5. **La terminación está garantizada porque el ancho de bits de los enteros es finito**: El desplazamiento a la izquierda mueve los bits del acarreo hacia posiciones superiores en cada iteración, y en un entero de 32 bits, el acarreo se vuelve cero en un máximo de 32 recursiones

## Conocimientos previos

### Operación XOR (OR exclusivo)

Es una operación de bits que devuelve 1 cuando los dos bits son diferentes y 0 cuando son iguales. Produce el mismo resultado que una suma ignorando el acarreo.

```java
int result = 5 ^ 3;   // 0101 ^ 0011 = 0110 → 6
int result2 = 7 ^ 7;  // 0111 ^ 0111 = 0000 → 0 (el XOR de dos valores iguales es 0)
```

### Operación AND

Es una operación de bits que devuelve 1 solo cuando ambos bits son 1. Se utiliza para identificar los dígitos donde se produce un acarreo.

```java
int result = 5 & 3;   // 0101 & 0011 = 0001 → 1
int result2 = 6 & 3;  // 0110 & 0011 = 0010 → 2
```

### Operación de desplazamiento a la izquierda

Es una operación que desplaza la secuencia de bits hacia la izquierda en la cantidad especificada y rellena con ceros los bits vacíos de la derecha. Un desplazamiento de 1 bit a la izquierda tiene el efecto de multiplicar el valor por 2. El acarreo afecta al siguiente dígito, por lo que se desplaza 1 bit a la izquierda para moverlo a la posición correcta.

```java
int result = 1 << 1;  // 0001 → 0010 → 2
int result2 = 3 << 1; // 0011 → 0110 → 6
```

### Mecanismo de la suma en binario

De la misma manera que la suma escrita en decimal, se suma cada dígito y se envía el acarreo al dígito superior.
Ejemplo: `5 + 3` (`0101 + 0011`):
- XOR (suma sin acarreo): `0101 ^ 0011 = 0110` (6)
- AND + desplazamiento a la izquierda (acarreo): `(0101 & 0011) << 1 = 0001 << 1 = 0010` (2)
- Se suman 6 y 2 con el mismo método → `0110 ^ 0010 = 0100` (4), `(0110 & 0010) << 1 = 0100` (4)
- Se suman 4 y 4 → `0100 ^ 0100 = 0000` (0), `(0100 & 0100) << 1 = 1000` (8)
- Se suman 0 y 8 → `0000 ^ 1000 = 1000` (8), el acarreo es 0 → fin. El resultado es **8**

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(1) — En un entero de 32 bits, el desplazamiento del acarreo termina en un máximo de 32 iteraciones, por lo que la recursión se completa en un número constante de veces |
| Space | O(1) — La profundidad de la recursión también es constante con un máximo de 32 niveles, y no se utiliza ninguna estructura de datos adicional |

## Código

```java
// Entrada: dos enteros a y b
// Salida: devuelve la suma de a y b como int
public int getSum(int a, int b) {
    // Caso base: si el acarreo (b) es cero, no queda ningún valor por sumar, por lo que a es la suma final
    if (b == 0) return a;

    // a ^ b: calcula la suma de cada dígito ignorando el acarreo (XOR devuelve 1 cuando "los dos bits son diferentes")
    // (a & b) << 1: calcula el acarreo (AND identifica "los dígitos donde ambos son 1" y el desplazamiento a la izquierda lo mueve a la posición del siguiente dígito)
    // En cada recursión, los bits del acarreo se mueven hacia posiciones superiores, y en un entero de 32 bits el acarreo se vuelve cero en un máximo de 32 iteraciones
    return getSum(a ^ b, (a & b) << 1);
}
```
