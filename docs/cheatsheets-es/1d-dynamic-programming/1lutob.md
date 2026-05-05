# Determining if a String Can Be Segmented Into Dictionary Words — Determinar si una cadena se puede segmentar en palabras del diccionario

## Esencia del problema

Se reciben una cadena `s` y una lista de palabras del diccionario `wordDict`. Se debe determinar si `s` se puede segmentar como una concatenación de palabras contenidas en el diccionario y devolver un **boolean**. Cada palabra del diccionario se puede reutilizar tantas veces como sea necesario.

## Idea central

Si se registra "si es segmentable o no" para la subcadena desde el inicio de la cadena hasta cada posición `i`, la determinación de la posición `i` se reduce a verificar si "hasta algún punto de segmentación `j` es segmentable" y "la subcadena desde `j` hasta `i` existe en el diccionario".

## Proceso de razonamiento

1. **Se puede descomponer en subproblemas**: Para determinar si los primeros `i` caracteres de la cadena `s` son segmentables, se divide en dos partes en alguna posición `j` y se verifica que "los primeros `j` caracteres son segmentables" y "desde `j` hasta `i` es una palabra del diccionario". Esta estructura es adecuada para la programación dinámica
2. **Definir el DP**: Se define `dp[i]` como un boolean que representa "si los primeros `i` caracteres de la cadena `s` se pueden segmentar solo con palabras del diccionario". Finalmente, `dp[n]` (donde `n` es la longitud de la cadena) será la respuesta
3. **Establecer la condición base**: La cadena vacía siempre es segmentable, por lo que se establece `dp[0] = true`. Esta condición base permite detectar palabras del diccionario que comienzan desde el inicio de la cadena
4. **Definir la transición**: La condición para que `dp[i]` sea `true` es que exista algún `j` en `0 ≤ j < i` tal que "`dp[j]` sea `true`" y "`s.substring(j, i)` exista en el diccionario". Se puede determinar probando todos los `j`
5. **Acelerar la búsqueda en el diccionario**: Si se convierte la lista de palabras en un HashSet, se puede determinar si una subcadena está contenida en el diccionario en O(1) con `contains`. Esto es más eficiente que una búsqueda lineal en la lista
6. **Eliminar cálculos innecesarios con terminación anticipada**: Una vez que se confirma que `dp[i] = true` para algún `j`, no es necesario probar más valores de `j`. Se sale del bucle interno con `break` y se avanza al siguiente `i`

## Conocimientos previos

### Qué es un HashSet

Es una estructura de datos que almacena elementos sin duplicados. La verificación de si un elemento está contenido se realiza en O(1). Se utiliza para buscar rápidamente en la lista de palabras del diccionario.

```java
Set<String> set = new HashSet<>();       // Crear un HashSet vacío
set.add("apple");                        // Agregar un elemento
set.contains("apple");                   // Devuelve un boolean indicando si el elemento existe → true
```

### Conversión de List a Set mediante el constructor

Si se pasa una List al constructor de `HashSet`, se pueden convertir todos los elementos de la List en un Set. Se utiliza para convertir el diccionario en un HashSet en una sola línea.

```java
List<String> list = Arrays.asList("a", "b", "c");
Set<String> set = new HashSet<>(list);   // Convertir todos los elementos de la List en un Set
```

### Qué es substring

Es un método que extrae una parte de una cadena. `s.substring(j, i)` devuelve los caracteres desde el índice `j` hasta `i - 1`. Se utiliza en la transición del DP para obtener "la subcadena desde la posición `j` hasta la posición `i`".

```java
String s = "leetcode";
s.substring(0, 4);                       // Devuelve "leet" (índices 0 a 3)
s.substring(4, 8);                       // Devuelve "code" (índices 4 a 7)
```

### Qué es un arreglo DP (arreglo de boolean)

Es un arreglo que almacena los resultados de subproblemas en la programación dinámica. Al crear `boolean[] dp = new boolean[n + 1]`, todos los elementos se inicializan en `false`. Al asignar `true` a `dp[i]`, se registra el resultado de que "los primeros `i` caracteres son segmentables".

```java
boolean[] dp = new boolean[5];           // Se inicializa como [false, false, false, false, false]
dp[0] = true;                           // Establecer la condición base
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n^2) — El bucle externo se ejecuta n veces y el bucle interno se ejecuta hasta n veces. Si la generación de substring en cada paso toma O(n), estrictamente es O(n^3), pero en promedio se trata como O(n^2) |
| Space | O(n) — Un arreglo DP de tamaño n+1 y un HashSet que almacena las palabras del diccionario |

## Código

```java
// Entrada: una cadena s y una lista de palabras del diccionario wordDict
// Salida: devuelve true si s se puede segmentar solo con palabras del diccionario, false en caso contrario
public boolean wordBreak(String s, List<String> wordDict) {
    // Convertir la lista de palabras del diccionario en un HashSet para que la búsqueda sea O(1)
    Set<String> set = new HashSet<>(wordDict);
    // Almacenar la longitud de la cadena en una variable
    int n = s.length();

    // dp[i] = si los primeros i caracteres se pueden segmentar solo con palabras del diccionario
    // El tamaño es n+1 porque dp[n] representa la segmentabilidad de la cadena completa
    boolean[] dp = new boolean[n + 1];

    // La cadena vacía siempre es segmentable (condición base)
    // Sin esta configuración, no se pueden detectar palabras del diccionario que comienzan desde el inicio de la cadena
    dp[0] = true;

    // Bucle externo: i representa "hasta cuántos caracteres desde el inicio se consideran"
    for (int i = 1; i <= n; i++) {
        // Bucle interno: j es un candidato de punto de segmentación. Posición que divide en "los primeros j caracteres" y "la subcadena de j a i"
        for (int j = 0; j < i; j++) {
            // Si los primeros j caracteres son segmentables Y de j a i es una palabra del diccionario, entonces los primeros i caracteres son segmentables
            // Que ambas condiciones se cumplan simultáneamente = se puede dividir en "parte segmentable + palabra del diccionario"
            if (dp[j] && set.contains(s.substring(j, i))) {
                dp[i] = true;
                break;  // Ya se confirmó que es segmentable, no es necesario probar otros valores de j
            }
        }
    }

    // dp[n] representa si la cadena s completa es segmentable
    return dp[n];
}
```
