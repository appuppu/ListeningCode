# Finding the Shortest Word Transformation Sequence — Encontrar la longitud de la secuencia más corta de transformación de palabras

## Esencia del problema

Se proporcionan una palabra inicial `beginWord`, una palabra final `endWord` y un diccionario de palabras válidas `wordList`. Se debe retornar la **longitud mínima** de una secuencia de transformación desde la palabra inicial hasta la palabra final, donde **cada paso cambia exactamente un carácter** y todas las palabras intermedias deben existir en el diccionario. Si no existe ninguna secuencia de transformación, se retorna 0.

## Idea central

Si se consideran las transformaciones de un carácter entre palabras como aristas de un grafo, la secuencia de transformación más corta se convierte en un problema de camino más corto. Al ejecutar BFS simultáneamente desde el punto de inicio y el punto final, y expandir siempre la frontera más pequeña, se reduce drásticamente el espacio de búsqueda.

## Proceso de razonamiento

1. **Modelar como un grafo**: Se considera un grafo donde cada palabra es un nodo y las palabras que difieren en un solo carácter están conectadas por una arista. La longitud de la secuencia de transformación más corta corresponde a la longitud del camino más corto desde beginWord hasta endWord en este grafo
2. **Usar BFS para el camino más corto**: Como se trata de un problema de camino más corto en un grafo sin pesos, BFS (búsqueda en anchura) es el algoritmo adecuado. Cada nivel corresponde a un paso de transformación
3. **Ineficiencia del BFS unidireccional**: Si se ejecuta BFS solo desde el punto de inicio, los candidatos crecen exponencialmente en cada nivel. El espacio de búsqueda explota conforme aumenta la profundidad
4. **Reducir el espacio de búsqueda con BFS bidireccional**: Al avanzar BFS simultáneamente desde el inicio y el final, se encuentra el camino más corto en el momento en que ambas búsquedas se encuentran. Como la profundidad de búsqueda de cada lado se reduce a d/2, el espacio de búsqueda se reduce significativamente
5. **Expandir prioritariamente la frontera más pequeña**: En cada paso, se compara el tamaño de las fronteras del lado inicial y del lado final (el conjunto de palabras del nivel actual), y se expande la más pequeña. De esta manera, se controla constantemente la expansión de las fronteras
6. **Método de generación de palabras adyacentes**: En lugar de comparar con todas las palabras del diccionario, se generan palabras adyacentes probando las 26 letras de la a a la z en cada posición de la palabra. Cuando la longitud m de la palabra es suficientemente menor que el tamaño n del diccionario, este método es más eficiente
7. **Detección de confluencia con la frontera opuesta**: Si una palabra adyacente generada está contenida en la frontera del lado opuesto, significa que ambas búsquedas han confluido, y se retorna el nivel actual + 1

## Conocimientos previos

### ¿Qué es BFS (búsqueda en anchura)?

BFS es un algoritmo que explora los nodos de un grafo en orden de cercanía desde el punto de inicio. Como la distancia aumenta en 1 en cada nivel, la distancia en el momento de la primera llegada es la distancia más corta. Se utiliza para problemas de camino más corto en grafos sin pesos.

### ¿Qué es HashSet?

HashSet es una estructura de datos que mantiene un conjunto de elementos. Permite agregar, buscar y eliminar elementos en O(1). Elimina automáticamente los duplicados.

```java
Set<String> set = new HashSet<>();   // Crear un HashSet vacío
set.add("hot");                      // Agregar un elemento
set.contains("hot");                 // Retornar boolean indicando si el elemento existe → true
set.size();                          // Retornar el número de elementos → 1
```

### ¿Qué es BFS bidireccional?

Mientras que el BFS normal explora solo desde el punto de inicio, el BFS bidireccional avanza la exploración simultáneamente desde el inicio y el final. El camino más corto se encuentra en el momento en que las fronteras de ambos lados se superponen. El espacio de búsqueda se reduce de O(b^d) a O(b^(d/2)) (donde b es el factor de ramificación y d es la distancia más corta).

### ¿Qué son toCharArray / String.valueOf?

Son métodos para convertir un String en un arreglo de caracteres y manipularlo carácter por carácter.

```java
char[] ch = "hot".toCharArray();     // Convertir String → char[] → ['h','o','t']
ch[0] = 'b';                        // Reemplazar directamente un carácter → ['b','o','t']
String next = String.valueOf(ch);    // Convertir char[] → String → "bot"
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n × m) — n es el número de palabras en el diccionario, m es la longitud de la palabra. Se prueban 26 caracteres en cada posición de cada palabra |
| Space | O(n × m) — Se almacenan hasta n palabras (cada una de longitud m) en el conjunto de visitados y las fronteras |

## Código

```java
// Entrada: palabra inicial beginWord, palabra final endWord, diccionario de palabras válidas wordList
// Salida: retornar la longitud de la secuencia de transformación más corta como int. Retornar 0 si no existe una secuencia de transformación
int ladderLength(String beginWord, String endWord, List<String> wordList) {
    // Convertir el diccionario a HashSet para verificar la existencia de palabras en O(1)
    Set<String> wordSet = new HashSet<>(wordList);
    // Si endWord no está en el diccionario, no se puede construir una secuencia de transformación, por lo que se retorna 0
    if (!wordSet.contains(endWord)) return 0;

    // Crear tres HashSet: frontera del lado inicial, frontera del lado final y conjunto de visitados
    Set<String> start = new HashSet<>();
    Set<String> end = new HashSet<>();
    Set<String> visited = new HashSet<>();
    start.add(beginWord);
    end.add(endWord);
    // Registrar las palabras de ambas fronteras como visitadas
    visited.add(beginWord);
    visited.add(endWord);
    // level es la longitud de la secuencia de transformación (contando la palabra inicial como 1)
    int level = 1;

    // Si alguna de las fronteras queda vacía, el destino es inalcanzable y se sale del bucle
    while (!start.isEmpty() && !end.isEmpty()) {
        // Expandir siempre la frontera más pequeña para controlar la expansión del espacio de búsqueda
        if (start.size() > end.size()) {
            Set<String> temp = start;
            start = end;
            end = temp;
        }

        // Conjunto para almacenar los candidatos del siguiente nivel
        Set<String> nextLevel = new HashSet<>();

        for (String word : start) {
            // Convertir la palabra a char[] y reemplazar cada posición carácter por carácter para generar palabras adyacentes
            char[] ch = word.toCharArray();
            for (int j = 0; j < ch.length; j++) {
                // Guardar el carácter original para restaurarlo después de la exploración
                char orig = ch[j];
                // Probar las 26 letras de la a a la z en cada posición para generar palabras adyacentes
                for (char c = 'a'; c <= 'z'; c++) {
                    ch[j] = c;
                    String next = String.valueOf(ch);
                    // Si la palabra está contenida en la frontera opuesta, ambas búsquedas han confluido
                    if (end.contains(next)) return level + 1;
                    // Si la palabra está en el diccionario y no ha sido visitada, agregarla a la siguiente frontera
                    // Agregarla a visited previene la revisita de la misma palabra
                    if (wordSet.contains(next) && !visited.contains(next)) {
                        nextLevel.add(next);
                        visited.add(next);
                    }
                }
                // Restaurar el carácter original para preparar la exploración de la siguiente posición
                ch[j] = orig;
            }
        }
        // Reemplazar la frontera con el siguiente nivel e incrementar level en 1 para la siguiente iteración
        start = nextLevel;
        level++;
    }
    // Si alguna de las fronteras quedó vacía, no existe una secuencia de transformación
    return 0;
}
```
