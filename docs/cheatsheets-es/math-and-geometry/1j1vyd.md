# Multiplying Two Numbers Represented as Strings — Multiplicar dos números representados como cadenas

## Esencia del problema

Se dan dos cadenas `num1` y `num2` que representan enteros no negativos. Se debe devolver el **producto** de los dos números como una cadena. Está prohibido usar bibliotecas de enteros grandes integradas o convertir la entrada directamente a enteros.

## Idea central

Se simula exactamente la multiplicación a mano que se aprende en la escuela primaria. La clave es la relación de posiciones: el producto del dígito i-ésimo de `num1` y el dígito j-ésimo de `num2` se suma a las posiciones `i + j` e `i + j + 1` del resultado.

## Proceso de razonamiento

1. **Reproducir la multiplicación a mano**: Como no se puede convertir a enteros, se implementa directamente el algoritmo de multiplicación a mano, multiplicando dígito por dígito y acumulando los resultados
2. **Estimar el número máximo de dígitos del producto**: El producto de un número de n dígitos y un número de m dígitos tiene como máximo `n + m` dígitos (ejemplo: 99 × 99 = 9801, 2 dígitos × 2 dígitos = 4 dígitos). Por lo tanto, se prepara un arreglo `pos` de tamaño `n + m` para almacenar el valor de cada dígito
3. **Determinar a qué posición del resultado corresponde el producto de cada par de dígitos**: El producto del dígito i-ésimo desde la derecha de `num1` y el dígito j-ésimo desde la derecha de `num2` afecta a las posiciones `i + j` e `i + j + 1` desde la derecha del resultado. En términos de índices de cadena, el producto `num1[i] * num2[j]` se suma a `pos[i + j + 1]` (dígito inferior) y `pos[i + j]` (dígito superior)
4. **Procesar el acarreo en el momento**: Después de calcular el producto de cada par de dígitos, se suma al valor ya acumulado en `pos[p2]`, se deja el resto de dividir entre 10 en esa posición, y se suma el cociente de dividir entre 10 a la posición superior `pos[p1]`. De esta manera, el acarreo se procesa de inmediato
5. **Eliminar los ceros iniciales y construir la cadena**: El arreglo `pos` puede contener ceros al inicio (ejemplo: cuando el producto de 3 dígitos × 2 dígitos tiene 4 dígitos, la primera posición del arreglo de 5 posiciones es 0). Se construye la cadena con `StringBuilder` omitiendo los ceros iniciales
6. **Tratamiento especial del cero**: Si cualquiera de las entradas es `"0"`, el producto es necesariamente `"0"`, por lo que se devuelve `"0"` de forma anticipada

## Conocimientos previos

### charAt y conversión de carácter a número

`String.charAt(i)` devuelve el carácter en la posición i de la cadena como tipo `char`. Para convertir los caracteres `'0'`–`'9'` de tipo `char` a los enteros 0–9, se resta el código del carácter `'0'`.

```java
String s = "123";
char c = s.charAt(0);       // '1' (tipo char)
int digit = c - '0';        // 1 (tipo int). Se resta el código 48 de '0' al código 49 de '1'
```

### Relación de posiciones en la multiplicación a mano

En la multiplicación a mano de n dígitos × m dígitos, el producto de `num1[i]` y `num2[j]` (máximo 81) puede tener 2 dígitos. Estos 2 dígitos corresponden a `pos[i + j]` (dígito superior) y `pos[i + j + 1]` (dígito inferior) del resultado.

```
Ejemplo: "12" × "34"
  num1[0]=1, num2[0]=3 → producto 3  → se suma a pos[0], pos[1]
  num1[0]=1, num2[1]=4 → producto 4  → se suma a pos[1], pos[2]
  num1[1]=2, num2[0]=3 → producto 6  → se suma a pos[1], pos[2]
  num1[1]=2, num2[1]=4 → producto 8  → se suma a pos[2], pos[3]
```

### StringBuilder

Clase para construir cadenas de longitud variable de forma eficiente. Se añaden caracteres al final con `append` y al terminar se convierte a `String` con `toString`.

```java
StringBuilder sb = new StringBuilder();  // Se crea un StringBuilder vacío
sb.append(4);                            // Se añade "4" al final
sb.append(0);                            // Se convierte en "40"
sb.append(8);                            // Se convierte en "408"
sb.toString();                           // Devuelve el String "408"
sb.length();                             // Devuelve el número actual de caracteres → 3
```

## Complejidad

| | Valor |
|---|---|
| Time | O(n × m) — Se multiplica cada dígito de num1 por cada dígito de num2 exactamente una vez |
| Space | O(n + m) — El tamaño del arreglo que almacena cada dígito del producto es n + m |

## Código

```java
// Entrada: cadenas num1 y num2 que representan enteros no negativos
// Salida: devuelve una cadena que representa el producto de los dos números
String multiply(String num1, String num2) {
    // Si cualquiera de los dos es "0", el producto es necesariamente 0, así que se devuelve "0" de forma anticipada
    if (num1.equals("0") || num2.equals("0"))
        return "0";

    int n = num1.length();
    int m = num2.length();
    // Arreglo que almacena cada dígito del producto. El producto de n dígitos × m dígitos tiene como máximo n+m dígitos, por lo que este tamaño es suficiente
    int[] pos = new int[n + m];

    // Al igual que en la multiplicación a mano, se multiplica desde los dígitos inferiores (final) hacia el inicio
    for (int i = n - 1; i >= 0; i--) {
        for (int j = m - 1; j >= 0; j--) {
            // Se convierte el carácter obtenido con charAt a su entero correspondiente restando '0', y luego se multiplica
            int mul = (num1.charAt(i) - '0')
                * (num2.charAt(j) - '0');
            // Posiciones donde se suma el producto: p1 es el dígito superior, p2 es el dígito inferior. Esta relación de posiciones se basa en la correspondencia de dígitos en la multiplicación a mano
            int p1 = i + j;
            int p2 = i + j + 1;
            // Se considera el valor sumado en la misma posición en iteraciones anteriores, sumándolo al valor ya acumulado
            int sum = mul + pos[p2];
            // Se deja solo un dígito en la posición inferior (resto de dividir entre 10) y se suma el acarreo a la posición superior (cociente de dividir entre 10)
            pos[p2] = sum % 10;
            pos[p1] += sum / 10;
        }
    }

    // Se construye la cadena omitiendo los ceros iniciales (ejemplo: caso en que la primera posición del arreglo de 5 posiciones es 0)
    StringBuilder sb = new StringBuilder();
    for (int p : pos) {
        // Si el StringBuilder está vacío y el valor actual es 0, se trata de un cero inicial y se omite
        if (sb.length() == 0 && p == 0)
            continue;
        sb.append(p);
    }
    // Se convierte el StringBuilder a tipo String y se devuelve
    return sb.toString();
}
```
