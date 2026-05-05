# Partitioning a String Into Maximum Parts — Dividir una cadena en el máximo número de partes donde cada carácter pertenece a una sola parte

## Esencia del problema

Se da una cadena `s` compuesta por letras minúsculas del alfabeto inglés. Se debe dividir la cadena en la mayor cantidad posible de partes, de modo que cada carácter aparezca en como máximo una sola parte. Se devuelve una lista con la **longitud** de cada parte.

## Idea central

Si un carácter está incluido en la parte actual, se debe extender esa parte hasta la última posición de aparición de dicho carácter. Si se calcula previamente la última posición de aparición de cada carácter, se pueden determinar los límites de cada parte de forma greedy en un solo recorrido.

## Proceso de razonamiento

1. **Comprender la restricción de la división**: Un mismo carácter no debe aparecer en dos partes distintas. Es decir, la parte que contiene un carácter debe incluir al menos hasta la última posición de aparición de ese carácter
2. **Calcular previamente la última posición de aparición de cada carácter**: Se recorre la cadena una vez y se registra en un arreglo el índice de la última aparición de cada carácter. Como solo existen 26 letras minúsculas, un arreglo de tamaño 26 es suficiente
3. **Extender el final de la parte de forma greedy**: Se recorre la cadena desde el inicio y se rastrea como `end` el valor máximo de la última posición de aparición de todos los caracteres incluidos en la parte actual. Cada vez que se encuentra un nuevo carácter, se actualiza `end` comparándolo con la última posición de aparición de ese carácter
4. **Identificar la condición para confirmar una parte**: Cuando el índice actual `i` alcanza `end`, se garantiza que todos los caracteres dentro de la parte actual están contenidos dentro del rango de esta parte. En ese momento se confirma la parte y se inicia la siguiente
5. **Calcular la longitud de la parte**: Cada vez que se confirma una parte, se calcula su longitud como `end - start + 1` y se añade a la lista de resultados. La posición de inicio `start` de la siguiente parte se actualiza a `i + 1`

## Conocimientos previos

### Conversión de caracteres a índices

En Java, el tipo `char` se puede tratar como un entero. Mediante `s.charAt(i) - 'a'`, se convierte la letra minúscula `'a'` en `0`, `'b'` en `1`, ..., `'z'` en `25`. Esto permite gestionar todas las letras minúsculas con un arreglo de tamaño 26.

```java
char c = 'c';
int index = c - 'a';    // 2 ('c' es la segunda letra después de 'a')
int[] arr = new int[26]; // Arreglo para 26 letras
arr[c - 'a'] = 5;       // Almacena el valor 5 en la posición correspondiente a 'c'
```

### Qué es Math.max

Es un método que devuelve el mayor de dos valores. Se utiliza al extender el final de una parte para comparar el `end` actual con la última posición de aparición del nuevo carácter y adoptar el valor más lejano.

```java
Math.max(3, 7);   // Devuelve 7
Math.max(10, 2);  // Devuelve 10
```

### Qué es ArrayList

Es una lista de tamaño variable. Como no se conoce de antemano el número de partes, es adecuada para ir añadiendo las longitudes de las partes una por una.

```java
List<Integer> res = new ArrayList<>();  // Crea una lista vacía
res.add(9);    // Añade 9 al final → [9]
res.add(7);    // Añade 7 al final → [9, 7]
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se requieren dos recorridos de la cadena (uno para registrar las últimas posiciones y otro para dividir en partes) |
| Space | O(1) — Solo se utiliza un arreglo fijo de tamaño 26, independiente del tamaño de la entrada |

## Código

```java
// Entrada: una cadena s compuesta por letras minúsculas del alfabeto inglés
// Salida: devuelve un List<Integer> que contiene la longitud de cada parte
List<Integer> partitionLabels(String s) {
    // Arreglo de enteros de tamaño 26 que almacena el índice de la última aparición de cada carácter ('a' a 'z')
    // Como solo existen 26 letras minúsculas, el tamaño 26 es fijo
    int[] last = new int[26];

    // Primer recorrido: registra la última posición de aparición de cada carácter
    // Si un mismo carácter aparece varias veces, se sobrescribe con el índice posterior, por lo que queda la última posición
    for (int i = 0; i < s.length(); i++) {
        last[s.charAt(i) - 'a'] = i;
    }

    // Se usa una lista de tamaño variable porque no se conoce de antemano el número de partes
    List<Integer> res = new ArrayList<>();
    // start: posición de inicio de la parte actual, end: posición del final de la parte actual
    int start = 0, end = 0;

    // Segundo recorrido: se confirman las partes de forma greedy
    for (int i = 0; i < s.length(); i++) {
        // Si la última posición de aparición del carácter actual es más lejana que end, se extiende el final de la parte hasta allí
        // De este modo, end siempre mantiene el valor máximo de la última posición de aparición de todos los caracteres en la parte
        end = Math.max(end,
            last[s.charAt(i) - 'a']);

        // i alcanza end → se garantiza que todos los caracteres de la parte están contenidos en este rango
        // Esto se debe a que ningún carácter de la parte aparece después de end
        if (i == end) {
            // Se calcula la longitud de la parte como end - start + 1 y se añade a la lista de resultados
            res.add(end - start + 1);
            // Se actualiza la posición de inicio de la siguiente parte
            start = i + 1;
        }
    }
    // Se devuelve la lista que contiene las longitudes de todas las partes
    return res;
}
```
