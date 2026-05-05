# Determinar si se pueden completar todos los cursos — Determining if All Courses Can Be Completed

## Esencia del problema

Se proporcionan `numCourses` cursos etiquetados del `0` al `n-1` y una lista de pares de prerrequisitos `prerequisites`. Cada par `[a, b]` significa que "no se puede cursar el curso `a` sin haber cursado primero el curso `b`". Se debe devolver un `boolean` que indique si es posible cursar todos los cursos. Este es un problema de detección de ciclos (dependencias circulares) en un grafo dirigido.

## Idea central

Si se representan las dependencias entre cursos como un grafo dirigido, determinar si se pueden cursar todos los cursos equivale a verificar si el grafo no contiene ciclos. Se realiza un ordenamiento topológico procesando primero los nodos con grado de entrada (número de aristas que llegan a ese nodo) igual a 0. Si se logran procesar todos los nodos, no existe ningún ciclo.

## Proceso de razonamiento

1. **Convertir el problema en un grafo**: Se construye una lista de adyacencia donde cada curso es un nodo y cada prerrequisito `[a, b]` se representa como una arista dirigida `b → a`. De esta forma, las dependencias quedan expresadas como una estructura de grafo
2. **Si hay un ciclo, no se pueden cursar todos los cursos**: Si el curso A depende del curso B y el curso B depende del curso A, no se puede cursar ninguno de los dos primero. Por lo tanto, el problema se reduce a determinar si existe un ciclo en el grafo dirigido
3. **Enfocarse en el grado de entrada**: Se cuenta el grado de entrada (número de prerrequisitos) de cada nodo. Los nodos con grado de entrada 0 no tienen prerrequisitos, por lo que se pueden cursar de inmediato. Estos nodos sirven como punto de partida
4. **Agregar los nodos con grado de entrada 0 a una cola y comenzar el procesamiento**: Se utiliza una cola de manera similar a BFS, procesando los nodos con grado de entrada 0 en orden. Se reduce en 1 el grado de entrada de los nodos destino de las aristas que salen del nodo procesado, y se agregan a la cola los nodos cuyo grado de entrada llega a 0
5. **Determinar el resultado según la cantidad de nodos procesados**: Si se logran procesar todos los nodos (cantidad procesada == `numCourses`), no existe ciclo y se pueden cursar todos los cursos. Los nodos dentro de un ciclo nunca alcanzan un grado de entrada de 0, por lo que quedan sin procesar

## Conocimientos previos

### Lista de adyacencia (Adjacency List)

Es una estructura de datos para representar grafos. Para cada nodo, se mantiene una lista de los nodos a los que apuntan sus aristas. Se implementa con `List<List<Integer>>`, y se obtiene la lista de nodos adyacentes del nodo `i` con `graph.get(i)`.

```java
List<List<Integer>> graph = new ArrayList<>();
for (int i = 0; i < n; i++)
    graph.add(new ArrayList<>());  // Se crea una lista vacía para cada nodo
graph.get(0).add(1);               // Se agrega una arista del nodo 0 al nodo 1
graph.get(0);                       // Lista de nodos adyacentes del nodo 0 → [1]
```

### Grado de entrada (In-degree)

En un grafo dirigido, es el número de aristas que llegan a un nodo. Un nodo con grado de entrada 0 no depende de ningún otro nodo. Se gestiona el grado de entrada del nodo `i` mediante el arreglo `inDegree[i]`.

```java
int[] inDegree = new int[n];   // Se inicializa el grado de entrada de todos los nodos en 0
inDegree[0]++;                  // Se incrementa en 1 el grado de entrada del nodo 0
```

### Cola (Queue)

Es una estructura de datos de tipo primero en entrar, primero en salir (FIFO). Se utiliza en BFS para gestionar los nodos pendientes de procesar. Se agrega al final con `offer` y se extrae del frente con `poll`.

```java
Queue<Integer> queue = new LinkedList<>();
queue.offer(0);       // Se agrega 0 a la cola
queue.poll();          // Se extrae y devuelve el elemento del frente de la cola → 0
queue.isEmpty();       // Se devuelve un boolean indicando si la cola está vacía → true
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(V + E) — Se procesa cada nodo (V nodos) y cada arista (E aristas) exactamente una vez |
| Space | O(V + E) — Se almacenan todas las aristas en la lista de adyacencia y todos los nodos en el arreglo de grado de entrada y la cola |

## Código

```java
// Entrada: número de cursos numCourses y arreglo de prerrequisitos prerequisites (cada elemento es [a, b] que representa la dependencia "b → a")
// Salida: true si se pueden cursar todos los cursos, false si existe un ciclo que lo impide
boolean canFinish(int numCourses, int[][] prerequisites) {
    // Arreglo que almacena el grado de entrada (número de prerrequisitos) de cada nodo. El grado de entrada representa cuántos prerrequisitos tiene ese curso
    int[] inDegree = new int[numCourses];

    // Se construye el grafo con lista de adyacencia. graph.get(i) es la lista de nodos a los que apuntan las aristas del nodo i
    List<List<Integer>> graph = new ArrayList<>();
    for (int i = 0; i < numCourses; i++)
        graph.add(new ArrayList<>());

    // Se agregan aristas a partir de cada prerrequisito y se actualiza el grado de entrada. Esto completa el grafo de dependencias y el grado de entrada de cada nodo
    for (int[] p : prerequisites) {
        graph.get(p[1]).add(p[0]);  // Se agrega la arista p[1] → p[0]
        inDegree[p[0]]++;           // Se incrementa en 1 el grado de entrada de p[0]
    }

    // Se agregan a la cola los nodos con grado de entrada 0 (sin prerrequisitos). Estos son los cursos que se pueden cursar primero
    Queue<Integer> queue = new LinkedList<>();
    for (int i = 0; i < numCourses; i++)
        if (inDegree[i] == 0)
            queue.offer(i);

    // Se procesan los nodos con grado de entrada 0 en orden mediante BFS
    int count = 0;  // Variable que rastrea la cantidad de cursos procesados
    while (!queue.isEmpty()) {
        int course = queue.poll();
        count++;  // Se considera este nodo como curso completado

        // Se reduce en 1 el grado de entrada de los nodos adyacentes (significa que se cumplió un prerrequisito). Si llega a 0, todos los prerrequisitos están cumplidos, así que se agrega a la cola
        for (int nei : graph.get(course))
            if (--inDegree[nei] == 0)
                queue.offer(nei);
    }

    // Si se procesaron todos los nodos, no hay ciclo (se pueden cursar todos los cursos). Los nodos dentro de un ciclo nunca alcanzan grado de entrada 0 y quedan sin procesar
    return count == numCourses;
}
```
