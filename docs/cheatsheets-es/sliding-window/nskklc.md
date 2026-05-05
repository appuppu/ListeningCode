# Finding the Smallest Window Containing All Characters — Encontrar la subcadena más corta que contiene todos los caracteres

## Esencia del problema

Se dan dos cadenas `s` y `t`. Se debe encontrar y devolver la **subcadena más corta** de `s` que contenga todos los caracteres de `t` (incluyendo duplicados). Si no existe dicha subcadena, se devuelve una cadena vacía.

## Idea central

Se extiende el puntero derecho para crear una ventana que cumpla la condición, y se contrae el puntero izquierdo para minimizarla. Al gestionar el "número de tipos de caracteres que cumplen la condición" con una sola variable, se puede determinar la validez de la ventana en O(1).

## Proceso de razonamiento

1. **Contar previamente las ocurrencias de los caracteres necesarios**: Se registra en un HashMap el número de ocurrencias de cada carácter contenido en `t`. Esto define la condición que la ventana debe cumplir. Por ejemplo, si `t = "ABC"`, el resultado es `{A:1, B:1, C:1}`
2. **Expandir la ventana hacia la derecha para cumplir la condición**: Se avanza el puntero derecho `r` de uno en uno para agregar caracteres a la ventana, y se gestiona el número de ocurrencias de los caracteres dentro de la ventana con otro HashMap. Cada vez que un tipo de carácter alcanza el número requerido de ocurrencias dentro de la ventana, se incrementa el contador `have`
3. **Determinar el cumplimiento de la condición en O(1)**: Se define `required` como el tamaño de `need` (el número de tipos de caracteres necesarios), y cuando se cumple `have == required`, la ventana contiene todos los caracteres de `t`. Al gestionar por tipo de carácter, se elimina la necesidad de comparar todos los caracteres en cada iteración
4. **Contraer la ventana desde la izquierda para minimizarla**: Mientras se cumpla `have == required`, se avanza el puntero izquierdo `left` hacia la derecha para reducir la ventana. En cada reducción, se compara la longitud de la ventana con el valor mínimo actual y se actualiza si es más corta
5. **Procesamiento al excluir el carácter del extremo izquierdo**: Al excluir el carácter `s.charAt(left)` de la ventana, si ese carácter está contenido en `need` y el número de ocurrencias dentro de la ventana cae por debajo del número requerido, se decrementa `have`. Esto hace que el bucle `while` termine y se regrese a la expansión del puntero derecho
6. **Qué se devuelve al final**: Tras completar el recorrido, si se encontró una ventana mínima, se devuelve `s.substring(resStart, resStart + resLen)`. Si no se encontró, se devuelve una cadena vacía

## Conocimientos previos

### Qué es un HashMap

Es una estructura de datos que almacena pares de clave y valor. Permite buscar y obtener valores especificando una clave en O(1). En este problema se utiliza para gestionar el número de ocurrencias de los caracteres.

```java
HashMap<Character, Integer> map = new HashMap<>();  // Crear un HashMap vacío
map.put('A', 1);                    // Almacenar el valor 1 con la clave 'A'
map.getOrDefault('A', 0);           // Devolver el valor de la clave 'A'. Si no existe, devolver 0 → 1
map.containsKey('A');               // Devolver un boolean indicando si la clave 'A' existe → true
map.get('A').equals(map.get('B'));  // Usar equals para comparar objetos Integer entre sí
```

### Qué es Sliding Window (ventana deslizante)

Es una técnica que gestiona un rango continuo (ventana) sobre un arreglo o cadena mediante dos punteros `left` y `right`. Al expandir la ventana con el puntero derecho y contraerla con el puntero izquierdo, se optimiza el procesamiento de O(n²) para examinar todas las subcadenas a O(n).

```java
int left = 0;
for (int r = 0; r < s.length(); r++) {
    // Procesamiento para expandir la ventana con el puntero derecho
    while (condiciónSeCumple) {
        // Procesamiento para contraer la ventana con el puntero izquierdo
        left++;
    }
}
```

### Qué es el patrón have / required

Es una técnica para determinar en O(1) si la ventana cumple la condición. `required` representa el número total de tipos de caracteres que se deben satisfacer, y `have` representa el número de tipos de caracteres que han alcanzado el número requerido en el momento actual. Cuando `have == required`, la ventana cumple todas las condiciones.

```java
int required = need.size();  // Número de tipos de caracteres necesarios (ej: need={A:1,B:1,C:1} → 3)
int have = 0;                // Número de tipos de caracteres que cumplen la condición (valor inicial 0)
// Cuando el conteo de 'A' en la ventana alcanza el conteo de 'A' en need, have++ → have==required significa que se cumplen todas las condiciones
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — El puntero derecho y el puntero izquierdo recorren `s` como máximo una vez cada uno |
| Space | O(n) — Los HashMap `need` y `window` almacenan como máximo tantos elementos como tipos de caracteres en `s` y `t` |

## Código

```java
// Entrada: cadena s y cadena t
// Salida: devolver como String la subcadena más corta de s que contenga todos los caracteres de t. Si no existe, devolver una cadena vacía
String minWindow(String s, String t) {
    // Si s es más corta que t, no puede existir una ventana que contenga todos los caracteres
    if (s.length() < t.length())
        return "";

    // HashMap que registra el número requerido de ocurrencias de cada carácter de t. Esto define la condición que la ventana debe cumplir
    Map<Character, Integer> need = new HashMap<>();
    for (char c : t.toCharArray()) {
        need.put(c, need.getOrDefault(c, 0) + 1);
    }

    // HashMap que gestiona el número de ocurrencias de cada carácter dentro de la ventana
    Map<Character, Integer> window = new HashMap<>();
    int have = 0;              // Número de tipos de caracteres que cumplen la condición
    int required = need.size(); // Número total de tipos de caracteres que se deben satisfacer (número de claves en need)
    int resLen = Integer.MAX_VALUE; // Longitud de la ventana mínima (valor inicial que representa estado no encontrado)
    int resStart = 0;          // Posición de inicio de la ventana mínima
    int left = 0;              // Puntero izquierdo

    // Expandir la ventana hacia la derecha con el puntero derecho
    for (int r = 0; r < s.length(); r++) {
        char c = s.charAt(r);
        // Incrementar en 1 el conteo de ocurrencias del carácter c en la ventana (la ventana se expande 1 carácter hacia la derecha)
        window.put(c, window.getOrDefault(c, 0) + 1);

        // Si el carácter c es necesario en t y su conteo en la ventana acaba de alcanzar el número requerido, incrementar have
        // Nota: usar equals en lugar de == para comparar objetos Integer
        if (need.containsKey(c)
            && window.get(c).equals(need.get(c))) {
            have++;
        }

        // Mientras la ventana cumpla todas las condiciones (have == required), contraerla desde la izquierda para minimizarla
        while (have == required) {
            int wLen = r - left + 1;
            // Si se encuentra una ventana más corta, actualizar el resultado
            if (wLen < resLen) {
                resLen = wLen;
                resStart = left;
            }
            // Excluir el carácter del extremo izquierdo de la ventana
            char lc = s.charAt(left);
            window.put(lc, window.get(lc) - 1);
            // Si al excluirlo el conteo en la ventana cae por debajo del número requerido, la condición se rompe y se decrementa have
            if (need.containsKey(lc)
                && window.get(lc) < need.get(lc)) {
                have--;
            }
            // Avanzar el puntero izquierdo hacia la derecha para contraer la ventana
            left++;
        }
    }

    // Si resLen sigue con el valor inicial, no se encontró una ventana que cumpla la condición, así que se devuelve una cadena vacía
    if (resLen == Integer.MAX_VALUE)
        return "";
    // Extraer y devolver la subcadena desde la posición de inicio de la ventana mínima con la longitud de la ventana mínima
    return s.substring(resStart, resStart + resLen);
}
```
