# Generating All Subsets of a Set — Generar todos los subconjuntos de un conjunto

## Esencia del problema

Se proporciona un arreglo de enteros distintos `nums`. Se debe devolver una lista con todos los subconjuntos (conjunto potencia) de `nums`. Los subconjuntos no deben contener duplicados, y el orden de devolución no importa.

## Idea central

Un conjunto de `n` elementos tiene `2^n` subconjuntos. Si se enumeran los enteros de `n` bits desde `0` hasta `2^n - 1`, cada bit representa "si se incluye o no el elemento correspondiente", por lo que se pueden generar todos los subconjuntos sin omisiones ni duplicados.

## Proceso de razonamiento

1. **El número de subconjuntos se determina por 2^n**: Para cada elemento existen dos opciones, "incluirlo" o "no incluirlo", por lo que un conjunto de `n` elementos tiene `2^n` subconjuntos. Para enumerarlos todos, se necesita un mecanismo que represente todos los `2^n` patrones de selección
2. **La enumeración de dos opciones se puede representar con bits**: Si se establece la correspondencia "incluir=1, no incluir=0", los patrones de selección de `n` elementos se pueden representar con un entero de `n` bits. Por ejemplo, cuando `nums = [a, b, c]`, la cadena de bits `101` significa "incluir a, no incluir b, incluir c", es decir, el subconjunto `[a, c]`
3. **Los enteros de 0 a 2^n-1 cubren todos los patrones**: Los enteros representables con `n` bits van desde `0` (todos los bits en 0 = conjunto vacío) hasta `2^n - 1` (todos los bits en 1 = conjunto con todos los elementos), lo que da `2^n` valores. Al enumerarlos en orden, se pueden generar todos los subconjuntos sin omisiones ni duplicados
4. **Método para construir un subconjunto a partir de cada entero**: Se puede determinar si el bit `i` del entero `mask` es `1` mediante `(mask & (1 << i)) != 0`. Si es `1`, se agrega `nums[i]` al subconjunto. Al recorrer `i` desde `0` hasta `n-1`, se completa el subconjunto correspondiente a `mask`
5. **Calcular 2^n con 1 << n**: En Java, se utiliza el operador de desplazamiento de bits `<<` para calcular `2^n` mediante `1 << n`. Al usar `mask < (1 << n)` como condición del bucle, se enumeran todos los valores desde `0` hasta `2^n - 1` sin omisiones
6. **Resultado final a devolver**: Se agrega a una lista el subconjunto correspondiente a cada `mask`, y después de procesar todos los `mask`, se devuelve la lista de subconjuntos `result`

## Conocimientos previos

### Qué es una máscara de bits

Es una técnica que utiliza cada bit (0 o 1) de un entero como una "bandera". Las combinaciones de "incluir/no incluir" para `n` elementos se pueden representar con un solo entero.

```java
int mask = 5;            // 101 en binario
// Bit 0: 1 (incluir), Bit 1: 0 (no incluir), Bit 2: 1 (incluir)
```

### Operadores de bits

Se combinan `&` (AND) y `<<` (desplazamiento a la izquierda) para determinar si un bit específico está activado.

```java
1 << 0;                  // 1 (binario: 001) — crea una máscara donde solo el bit 0 es 1
1 << 1;                  // 2 (binario: 010) — crea una máscara donde solo el bit 1 es 1
1 << 2;                  // 4 (binario: 100) — crea una máscara donde solo el bit 2 es 1

int mask = 5;            // binario: 101
(mask & (1 << 0)) != 0;  // true  — el bit 0 es 1
(mask & (1 << 1)) != 0;  // false — el bit 1 es 0
(mask & (1 << 2)) != 0;  // true  — el bit 2 es 1
```

### Calcular 2^n con 1 << n

El desplazamiento de bits `1 << n` desplaza `1` hacia la izquierda `n` bits, y el resultado es `2^n`. Se utiliza para obtener el número total de subconjuntos.

```java
1 << 3;                  // 8 (= 2^3) — con 3 elementos hay 8 subconjuntos
```

## Complejidad computacional

| | Valor |
|---|---|
| Tiempo | O(n × 2^n) — se recorren n bits por cada una de las 2^n máscaras |
| Espacio | O(n × 2^n) — se almacenan 2^n subconjuntos, y el número promedio de elementos por subconjunto es n/2 |

## Código

```java
// Entrada: un arreglo de enteros distintos nums
// Salida: devuelve un List<List<Integer>> que contiene todos los subconjuntos
List<List<Integer>> subsets(int[] nums) {
    // Número de elementos de nums. Se utiliza tanto para el número de bits de la máscara como para el rango de recorrido del arreglo
    int n = nums.length;
    // Lista que almacena todos los subconjuntos. Se agrega aquí cada subconjunto generado a partir de cada mask
    List<List<Integer>> result = new ArrayList<>();

    // Se enumera mask de 0 a 2^n-1, donde cada valor corresponde a un subconjunto
    // Se calcula 2^n con 1 << n y se usa como condición del bucle para enumerar todos los 2^n patrones
    for (int mask = 0; mask < (1 << n); mask++) {
        // Se crea un subconjunto vacío donde se agregarán los elementos correspondientes al mask actual
        List<Integer> subset = new ArrayList<>();

        // i es el índice de nums y al mismo tiempo determina qué bit de mask se examina
        for (int i = 0; i < n; i++) {
            // Se crea una máscara donde solo el bit i es 1 con 1 << i, y se extrae el valor del bit i mediante AND con mask
            // Si el bit es 1, significa "incluir este elemento"; si es 0, significa "no incluirlo" y se avanza al siguiente i
            if ((mask & (1 << i)) != 0) {
                subset.add(nums[i]);
            }
        }

        // Después de terminar el bucle interno, se agrega el subconjunto completado a la lista de resultados
        result.add(subset);
    }
    // Después de procesar todos los mask, se devuelve result que contiene los 2^n subconjuntos
    return result;
}
```
