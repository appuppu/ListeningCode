# Mapping Phone Number Digits to Letter Combinations — Generar todas las combinaciones de letras a partir de los dígitos de un número telefónico

## Esencia del problema

Se recibe una cadena `digits` compuesta por dígitos del 2 al 9. Cada dígito se mapea a las letras correspondientes del teclado telefónico (ejemplo: 2→"abc", 3→"def"). Se debe devolver una lista con **todas las combinaciones posibles de letras** que se forman al seleccionar una letra por cada dígito de `digits`.

## Idea central

Cada posición de dígito tiene entre 3 y 4 letras posibles, y es necesario enumerar todas las combinaciones. Se selecciona una letra a la vez y se agrega al final; cuando se han seleccionado letras para todos los dígitos, se registra el resultado; luego se deshace la última selección y se prueba otra letra. Este proceso de «backtracking» permite explorar todos los patrones sin omisiones.

## Proceso de razonamiento

1. **Cada posición de dígito tiene opciones**: Cada dígito corresponde a 3 o 4 letras, y se selecciona una letra por posición. La combinación de selecciones en todas las posiciones forma la respuesta, por lo que es necesario enumerar todos los patrones de forma sistemática
2. **Se procesa un dígito a la vez mediante recursión**: Se selecciona una letra del primer dígito y se delega el procesamiento del siguiente dígito a una llamada recursiva. De esta manera, cada nivel de profundidad de la recursión corresponde a una posición de dígito, lo que simplifica la estructura
3. **La condición de terminación es haber procesado todos los dígitos**: Cuando la profundidad de la recursión alcanza la longitud de `digits`, la cadena en construcción constituye una combinación completa. Se agrega esta cadena a la lista de resultados
4. **El backtracking permite probar otras opciones**: Al retornar de la recursión, se elimina la última letra agregada al final del `StringBuilder`. De esta forma, se prepara el estado para probar otra letra en la misma posición
5. **Se utiliza un arreglo de mapeo para convertir dígitos en letras**: Se prepara un arreglo de cadenas con índices del 0 al 9, y se convierte el dígito a entero mediante `digits.charAt(idx) - '0'` para acceder por índice y obtener el grupo de letras correspondiente en O(1)
6. **Se maneja la entrada de cadena vacía**: Si `digits` está vacío, no existen combinaciones posibles, por lo que se devuelve la lista vacía tal cual

## Conocimientos previos

### Qué es el backtracking

Es una técnica de exploración que construye candidatos de solución uno a uno; cuando se completa uno, se registra; luego se deshace la última selección y se prueba otra opción. Se utiliza en problemas que requieren enumerar todas las combinaciones o permutaciones. El ciclo «seleccionar → avanzar → deshacer → probar otra opción» se implementa mediante recursión.

```java
// Patrón básico de backtracking
void backtrack(estado, listaDeResultados) {
    if (condiciónDeTerminación) {
        listaDeResultados.add(estadoActual);
        return;
    }
    for (opción : listaDeOpcionesActuales) {
        agregarOpciónAlEstado;              // Seleccionar
        backtrack(siguienteEstado, listaDeResultados); // Avanzar
        eliminarOpciónDelEstado;            // Deshacer (backtrack)
    }
}
```

### Qué es StringBuilder

Es una clase para construir cadenas de forma eficiente. `String` es inmutable (se crea un nuevo objeto cada vez que se modifica), pero `StringBuilder` modifica directamente su búfer interno, lo que permite agregar y eliminar caracteres en O(1). Es adecuado para construir cadenas durante el backtracking.

```java
StringBuilder sb = new StringBuilder();  // Crear un StringBuilder vacío
sb.append('a');           // Agregar el carácter 'a' al final → "a"
sb.append('b');           // Agregar el carácter 'b' al final → "ab"
sb.deleteCharAt(sb.length() - 1);  // Eliminar el último carácter → "a"
sb.toString();            // Convertir a tipo String y devolver → "a"
```

### Mapeo del teclado telefónico

La correspondencia entre dígitos y letras se representa mediante un arreglo. El índice del arreglo corresponde al dígito, y el valor es el grupo de letras asignado a ese dígito.

```java
String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};
// phone[2] → "abc",  phone[7] → "pqrs",  phone[9] → "wxyz"
// Conversión del carácter '3' al entero 3: '3' - '0' → 3
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(4^n) — Cada dígito tiene como máximo 4 letras posibles, y se enumeran todas las combinaciones para n dígitos |
| Space | O(n) — La profundidad máxima de la recursión es n, y la longitud del StringBuilder también es como máximo n (excluyendo la lista de resultados) |

## Código

```java
// Entrada: una cadena digits compuesta por dígitos del 2 al 9
// Salida: se devuelve una List<String> que contiene todas las combinaciones de letras

// Se selecciona una letra por dígito mediante backtracking y se enumeran todas las combinaciones
void backtrack(String digits, String[] phone, int idx, StringBuilder path, List<String> result) {
    // Condición de terminación: si idx es igual a la longitud de digits, se han seleccionado letras para todos los dígitos
    // Se convierte el contenido del StringBuilder a String y se agrega al resultado
    if (idx == digits.length()) {
        result.add(path.toString());
        return;
    }

    // Se convierte el carácter del dígito a entero mediante digits.charAt(idx) - '0' y se obtiene el grupo de letras correspondiente del arreglo phone
    String letters = phone[digits.charAt(idx) - '0'];

    // Se prueba cada letra correspondiente al dígito actual, una por una
    for (char c : letters.toCharArray()) {
        path.append(c);                            // Selección: se elige la letra y se agrega al final
        backtrack(digits, phone, idx + 1, path, result);  // Recursión: se avanza al procesamiento del siguiente dígito
        path.deleteCharAt(path.length() - 1);      // Restauración: se elimina la última letra para volver al estado anterior (backtrack)
    }
}

List<String> letterCombinations(String digits) {
    // Se crea una lista vacía para almacenar los resultados
    List<String> result = new ArrayList<>();

    // Si la cadena está vacía, no existen combinaciones, por lo que se devuelve la lista vacía
    if (digits.isEmpty()) return result;

    // Se define el arreglo de mapeo donde el índice corresponde al dígito
    // Los índices 0 y 1 se establecen como cadenas vacías porque no tienen letras asignadas en el teclado telefónico
    String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    // Se inicia el backtracking desde la posición 0 con un StringBuilder vacío
    backtrack(digits, phone, 0, new StringBuilder(), result);

    // Una vez completada toda la recursión, se devuelve result que contiene todas las combinaciones
    return result;
}
```
