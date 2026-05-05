# Encoding and Decoding a List of Strings — Codificar y decodificar una lista de cadenas en una sola cadena

## Esencia del problema

Se proporciona una lista de cadenas `strs`. El método `encode` convierte la lista en una sola cadena, y el método `decode` restaura esa cadena a la lista original. La codificación y la decodificación deben ser sin estado (stateless), y es necesario manejar correctamente cualquier entrada, incluyendo cadenas vacías, caracteres especiales y cadenas que contengan el propio delimitador.

## Idea central

Si se antepone la longitud de cada cadena antes de su contenido, se puede extraer con precisión independientemente de lo que contenga la cadena. Cuando se conoce la longitud, el problema de colisión con el delimitador no ocurre por principio.

## Proceso de razonamiento

1. **Reconocer el problema del enfoque ingenuo con delimitadores**: Si se unen las cadenas de la lista con delimitadores como comas o saltos de línea, no se puede decodificar correctamente cuando la propia cadena contiene ese delimitador. Incluso si se introduce un proceso de escape, se necesita escapar el propio carácter de escape, lo cual añade complejidad
2. **Transmitir la longitud de la cadena previamente elimina las colisiones**: Si se registra la longitud de cada cadena (número de caracteres, no de bytes) antes de ella, al decodificar se sabe de antemano cuántos caracteres leer. Como se extrae el contenido sin interpretar la cadena en absoluto, no hay problema sin importar qué caracteres contenga
3. **Usar `#` como separador entre la longitud y el cuerpo de la cadena**: Dado que la longitud es un entero de dígitos variables, se necesita un símbolo que indique el final de la parte de longitud. Se usa `#` como separador, con el formato `longitud#cuerpo de la cadena`. Al decodificar, se lee la parte de longitud desde la posición del primer `#` y se extrae el número especificado de caracteres después de él
4. **Codificación**: Para cada cadena, se concatena `longitud de la cadena + "#" + cuerpo de la cadena` para construir una sola cadena. Por ejemplo, `["hello", "a#b"]` se convierte en `5#hello3#a#b`
5. **Decodificación**: Desde el inicio, se busca `#` para leer la longitud, y se extrae la cantidad de caracteres correspondiente inmediatamente después de `#`. La posición final de la extracción se usa como la posición inicial siguiente y se repite el proceso. Incluso si el cuerpo de la cadena contiene `#`, no se produce una identificación errónea porque el rango exacto se conoce por la longitud
6. **Valor de retorno final**: `encode` devuelve un solo `String` concatenado, y `decode` devuelve una `List<String>` restaurada a partir de ese `String`

## Conocimientos previos

### Qué es StringBuilder

Es una clase para concatenar cadenas de forma eficiente. La concatenación mediante el operador `+` de `String` genera un nuevo objeto `String` cada vez, pero `StringBuilder` añade al búfer interno, por lo que la concatenación se realiza en O(1).

```java
StringBuilder sb = new StringBuilder();  // Crear un StringBuilder vacío
sb.append("hello");                      // Añadir "hello" al final
sb.append(5);                            // Añadir el entero 5 como cadena al final
sb.toString();                           // Devolver la cadena resultante "hello5"
```

### Qué es String.indexOf(char, int)

Es un método que busca el carácter especificado hacia adelante desde la posición inicial indicada y devuelve la posición (índice) de la primera ocurrencia encontrada. Devuelve -1 si no se encuentra.

```java
String str = "12#hello";
str.indexOf('#', 0);    // Buscar '#' desde la posición 0 → devuelve 2
str.indexOf('#', 3);    // Buscar '#' desde la posición 3 → devuelve -1 si no se encuentra
```

### Qué es String.substring(int, int)

Es un método que extrae un rango especificado de la cadena. El primer argumento es la posición inicial (incluida), y el segundo argumento es la posición final (excluida).

```java
String str = "5#hello";
str.substring(0, 1);    // Desde la posición 0 hasta antes de la posición 1 → "5"
str.substring(2, 7);    // Desde la posición 2 hasta antes de la posición 7 → "hello"
```

### Qué es Integer.parseInt(String)

Es un método estático que convierte una cadena en un entero. Se utiliza para leer la parte numérica del prefijo de longitud como un entero.

```java
Integer.parseInt("5");    // Convertir la cadena "5" en el entero 5
Integer.parseInt("123");  // Convertir la cadena "123" en el entero 123
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n × k) — n es el número de cadenas, k es la longitud promedio de las cadenas. Se procesa cada cadena una vez |
| Space | O(n × k) — Se utiliza espacio para todas las cadenas como resultado de la codificación o la decodificación |

## Código

```java
// === encode ===
// Entrada: lista de cadenas strs (List<String>)
// Salida: devuelve un String que agrupa todas las cadenas en una sola
public String encode(List<String> strs) {
    // Se usa StringBuilder para concatenar cadenas eficientemente dentro del bucle
    StringBuilder sb = new StringBuilder();
    // Se recorre cada cadena de la lista desde el inicio
    for (String str : strs) {
        // Se antepone "longitud#" a cada cadena y se concatena
        // Al registrar la longitud previamente, se puede conocer el rango exacto del cuerpo de la cadena al decodificar
        sb.append(str.length() + "#" + str);
    }
    // Se devuelve el contenido del StringBuilder como un String
    return sb.toString();
}

// === decode ===
// Entrada: una sola cadena codificada str (String)
// Salida: devuelve la lista restaurada de cadenas List<String>
public List<String> decode(String str) {
    List<String> result = new ArrayList<>();
    // Variable que indica la posición actual de lectura. Se comienza desde el inicio
    int i = 0;
    while (i < str.length()) {
        // Se busca el primer '#' desde la posición actual i para identificar la posición de separación entre la parte de longitud y el cuerpo de la cadena
        int separatorIndex = str.indexOf('#', i);
        // Se lee como entero hasta antes de '#' para obtener la longitud del cuerpo de la cadena
        int textLength = Integer.parseInt(str.substring(i, separatorIndex));
        // La posición inmediatamente después de '#' es el inicio del cuerpo de la cadena
        int textStart = separatorIndex + 1;
        // La posición final es la posición inicial más la longitud. Como el rango se determina por la longitud, se extrae correctamente incluso si el cuerpo de la cadena contiene '#'
        int textEnd = textStart + textLength;
        // Se extrae el cuerpo de la cadena y se añade a la lista de resultados
        result.add(str.substring(textStart, textEnd));
        // Se mueve la posición de lectura al inicio de la parte de longitud de la siguiente cadena
        i = textEnd;
    }
    return result;
}
```
