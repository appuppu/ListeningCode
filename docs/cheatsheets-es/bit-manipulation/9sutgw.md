# Reversing the Bits of an Integer — Invertir los bits de un entero sin signo de 32 bits

## Esencia del problema

Se proporciona un entero sin signo de 32 bits. Se debe devolver el entero resultante de invertir (revertir el orden) de su secuencia de bits. Por ejemplo, la entrada `00000000000000000000000000001011` se convierte en `11010000000000000000000000000000`.

## Idea central

Se desplaza el resultado un bit hacia la izquierda cada vez, se extrae el bit menos significativo de la entrada uno por uno y se añade al resultado. Al repetir este proceso 32 veces, la secuencia de bits de la entrada se acumula en orden inverso en el resultado.

## Proceso de razonamiento

1. **La inversión de bits es una operación de "extraer desde el final y apilar al principio"**: Se extrae el bit menos significativo (extremo derecho) de la entrada, se añade al bit menos significativo (extremo derecho) del resultado y luego se desplaza el resultado hacia la izquierda. De esta forma, el primer bit extraído termina moviéndose a la posición más significativa. Esto constituye la construcción inversa de la secuencia de bits
2. **Cómo extraer el bit menos significativo**: Al calcular `n & 1`, se obtiene únicamente el bit menos significativo de `n`. La operación AND enmascara todos los bits excepto el menos significativo, poniéndolos a 0
3. **Cómo añadir el bit extraído al resultado**: Usando la operación OR con `result |= (n & 1)`, se establece el bit extraído en el bit menos significativo de result. Como el bit menos significativo de result se ha puesto a 0 mediante el desplazamiento a la izquierda previo, la operación OR lo establece correctamente
4. **Cómo avanzar al siguiente bit**: Al desplazar la entrada `n` un bit a la derecha con `n >>>= 1`, el siguiente bit pasa a ser el menos significativo. `>>>` es el desplazamiento a la derecha sin signo, que siempre rellena con 0 en la posición más significativa
5. **Cómo crear espacio en el resultado**: Al desplazar el resultado un bit a la izquierda con `result <<= 1` antes de añadir un nuevo bit, el bit menos significativo se pone a 0, creando espacio para recibir el nuevo bit
6. **Se completa al repetir 32 veces**: Como se trata de un entero de 32 bits, al repetir la operación "desplazamiento a la izquierda → adición de bit → desplazamiento a la derecha" 32 veces, todos los bits de la entrada quedan almacenados en orden inverso en el resultado

## Conocimientos previos

### Operación AND a nivel de bits (&)

Es una operación que compara cada bit de dos enteros y produce 1 solo cuando ambos bits son 1. Se utiliza como "máscara" para extraer bits específicos.

```java
int n = 0b1011;       // 1011 en binario (11 en decimal)
int bit = n & 1;      // Se obtiene solo el bit menos significativo → 1
int bit2 = 0b1010 & 1; // Cuando el bit menos significativo es 0 → 0
```

### Operación OR a nivel de bits (|=)

Es una operación que compara cada bit de dos enteros y produce 1 cuando al menos uno de los bits es 1. Se utiliza para establecer (poner a 1) bits específicos.

```java
int result = 0b0000;
result |= 1;          // Se establece el bit menos significativo a 1 → 0b0001
result |= 0;          // OR con 0 no produce cambio → 0b0001
```

### Operación de desplazamiento a la izquierda (<<=)

Es una operación que desplaza la secuencia de bits hacia la izquierda en la cantidad especificada. Se rellena con 0 en el extremo derecho. Un desplazamiento de 1 bit a la izquierda tiene el efecto de multiplicar el valor por 2.

```java
int result = 0b0011;   // 11 en binario (3 en decimal)
result <<= 1;          // Se desplaza 1 bit a la izquierda → 0b0110 (6 en decimal)
```

### Operación de desplazamiento a la derecha sin signo (>>>=)

Es una operación que desplaza la secuencia de bits hacia la derecha en la cantidad especificada. Se rellena siempre con 0 en el extremo izquierdo. A diferencia de `>>`, rellena con 0 independientemente del bit de signo, por lo que es adecuada para la manipulación de enteros sin signo.

```java
int n = 0b1011;        // 1011 en binario
n >>>= 1;              // Se desplaza 1 bit a la derecha → 0b0101 (el 1 menos significativo desaparece y el siguiente bit pasa al extremo derecho)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(1) — El bucle siempre se ejecuta exactamente 32 veces y no depende del valor de la entrada |
| Space | O(1) — Solo se utiliza la variable adicional `result` y no depende del tamaño de la entrada |

## Código

```java
// Entrada: entero sin signo de 32 bits n
// Salida: se devuelve como int el entero con la secuencia de bits invertida
public int reverseBits(int n) {
    // Variable para almacenar la secuencia de bits invertida. El valor inicial 0 significa que todos los bits están en 0
    int result = 0;

    // Se itera 32 veces para procesar todos los bits del entero de 32 bits
    for (int i = 0; i < 32; i++) {
        // Se desplaza result 1 bit a la izquierda para poner el bit menos significativo a 0 y crear espacio para recibir un nuevo bit
        // Nota: el desplazamiento a la izquierda se realiza antes de añadir el bit. Si se hiciera después, se produciría un desplazamiento extra tras la última adición de bit, lo que duplicaría el resultado
        result <<= 1;
        // Se extrae el bit menos significativo de n con n & 1 y se establece en el bit menos significativo de result mediante la operación OR
        // Como el bit menos significativo se ha puesto a 0 con el desplazamiento a la izquierda previo, la operación OR lo establece correctamente
        result |= (n & 1);
        // Se desplaza n a la derecha sin signo para mover el siguiente bit a la posición menos significativa
        // Se usa >>> porque es necesario rellenar con 0 independientemente del bit de signo
        n >>>= 1;
    }
    // Tras completar las 32 iteraciones, el bit 0 de la entrada está en el bit 31 de result, el bit 1 en el bit 30, y así todos los bits quedan almacenados en orden inverso
    return result;
}
```
