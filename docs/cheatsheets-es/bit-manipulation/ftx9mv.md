# Counting the Number of Set Bits — Contar el número de bits con valor 1 en la representación binaria de un entero

## Esencia del problema

Se da un entero no negativo `n`. Se debe devolver la cantidad de bits con valor 1 (peso de Hamming) en la representación binaria de `n`.

## Idea central

La operación `n & (n - 1)` elimina únicamente el bit 1 de menor peso de `n`. Si se repite esta operación hasta que `n` se convierta en 0, el número de repeticiones será exactamente la cantidad de bits con valor 1.

## Proceso de razonamiento

1. **Contar solo los bits con valor 1 de forma eficiente**: En lugar de recorrer los 32 bits completos, si se procesan únicamente las posiciones donde existe un bit 1, el tiempo será proporcional al número de bits con valor 1, `k`
2. **Pensar en cómo eliminar el bit 1 de menor peso**: Al calcular `n - 1`, el bit 1 de menor peso de `n` se convierte en 0 y todos los bits inferiores se invierten a 1. Por ejemplo, cuando `n = 1100`, se obtiene `n - 1 = 1011`
3. **n AND (n - 1) elimina solo el bit 1 de menor peso**: Al aplicar AND entre `n` y `n - 1`, todos los bits desde la posición del bit 1 de menor peso hacia abajo se convierten en 0, mientras que los bits superiores permanecen intactos. `1100 & 1011 = 1000`, y así se elimina un bit 1
4. **Contar repitiendo la operación de eliminación**: Se aplica `n &= (n - 1)` repetidamente y se cuenta el número de iteraciones hasta que `n` se convierta en 0; ese conteo es la cantidad de bits con valor 1 del `n` original
5. **Condición de terminación del bucle**: Cuando se eliminan todos los bits con valor 1, `n` se convierte en 0. Si se usa `n != 0` como condición del bucle, este iterará exactamente tantas veces como bits con valor 1 haya y terminará de forma natural

## Conocimientos previos

### Operación AND a nivel de bits (&)

Es una operación que compara cada bit de dos enteros y el resultado es 1 solo cuando ambos bits son 1. Para cualquier otra combinación, el resultado es 0.

```java
int a = 0b1100;       // 1100 en binario
int b = 0b1010;       // 1010 en binario
int result = a & b;   // El resultado es 0b1000 (solo las posiciones donde ambos son 1 dan 1)
```

### Funcionamiento de n & (n - 1)

Al restar 1 a `n`, el bit 1 de menor peso se convierte en 0 y todos los bits inferiores se invierten a 1. Al aplicar AND con `n`, todos los bits desde el bit 1 de menor peso hacia abajo se convierten en 0.

```java
int n = 0b1100;       // n     = 1100 (2 bits con valor 1)
n &= (n - 1);        // n - 1 = 1011, n = 1100 & 1011 = 1000 (se redujo a 1 bit con valor 1)
n &= (n - 1);        // n - 1 = 0111, n = 1000 & 0111 = 0000 (se redujo a 0 bits con valor 1)
```

### Peso de Hamming (Hamming Weight)

Es la cantidad de bits con valor 1 en la representación binaria de un entero. Por ejemplo, la representación binaria de `11` es `1011`, por lo que su peso de Hamming es 3.

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(k) — k es la cantidad de bits con valor 1 en `n`. El bucle se ejecuta exactamente k veces |
| Space | O(1) — Solo se utiliza una variable de contador |

## Código

```java
// Entrada: entero no negativo n
// Salida: devuelve como int la cantidad de bits con valor 1 en la representación binaria de n
public int hammingWeight(int n) {
    // Contador que registra el número de veces que se elimina un bit 1. El total de eliminaciones es la respuesta final
    int count = 0;

    // Si n es 0, no quedan bits con valor 1, por lo que se termina el bucle
    while (n != 0) {
        // Elimina un solo bit 1 de menor peso (Brian Kernighan's Trick)
        // Al calcular n - 1, los bits desde el bit 1 de menor peso hacia abajo se invierten, y el AND con n convierte en 0 todos esos bits
        n &= (n - 1);
        // Se eliminó un bit con valor 1, por lo que se registra la eliminación
        count++;
    }
    // count almacena el total de eliminaciones de bits 1, es decir, la cantidad de bits con valor 1 que contenía el n original
    return count;
}
```
