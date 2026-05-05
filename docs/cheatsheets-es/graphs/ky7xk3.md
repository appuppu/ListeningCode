# Counting Connected Components in an Undirected Graph — Contar el número de componentes conexos en un grafo no dirigido

## Esencia del problema

Se proporcionan `n` nodos etiquetados de `0` a `n-1` y una lista de aristas no dirigidas `edges`. El objetivo es devolver como entero el **número de componentes conexos (connected components)** en el grafo. Un componente conexo es un conjunto de nodos que son alcanzables entre sí siguiendo las aristas.

## Idea central

Inicialmente se considera cada nodo como un componente conexo independiente, y se procesan las aristas una por una para unificar los grupos a los que pertenecen los nodos en ambos extremos. El número de grupos que quedan después de procesar todas las aristas es el número de componentes conexos.

## Proceso de razonamiento

1. **Los nodos conectados por una arista pertenecen al mismo grupo**: Dado que un componente conexo es "el conjunto de nodos alcanzables siguiendo aristas", dos nodos unidos por una arista pertenecen necesariamente al mismo componente conexo. Si se repite la operación de "agrupar los nodos de ambos extremos en el mismo grupo" para todas las aristas, se obtienen finalmente los componentes conexos
2. **Union-Find es adecuado para gestionar los grupos**: Union-Find es una estructura de datos que realiza de forma eficiente las operaciones de "unificar dos elementos en el mismo grupo (union)" y "determinar a qué grupo pertenece un elemento (find)". Cada nodo tiene un "nodo padre", y los nodos que comparten la misma raíz (root) se consideran del mismo grupo
3. **En el estado inicial, cada nodo tiene a sí mismo como padre**: Al inicializar con `parent[i] = i`, cada uno de los n nodos comienza como un grupo independiente (componente conexo). El número inicial de componentes conexos es `n`
4. **Se ejecuta union al procesar cada arista, y si se produce una unificación se reduce el número de componentes**: Para cada arista `[a, b]`, se obtiene la raíz de `a` y la raíz de `b`. Si las raíces son diferentes, pertenecen a grupos distintos, por lo que se convierte la raíz de uno en hijo de la raíz del otro para unificarlos, y se reduce el número de componentes conexos en 1. Si las raíces son iguales, ya pertenecen al mismo grupo y no se hace nada
5. **La compresión de caminos y el rango aceleran las operaciones**: Durante find se aplica compresión de caminos (path compression), reasignando el padre de los nodos visitados directamente a la raíz. Durante union se compara el rango (límite superior de la altura del árbol) y se coloca el árbol más bajo debajo del más alto (union by rank). Esto hace que la complejidad de find sea prácticamente O(1) (exactamente O(α(V)))
6. **El valor de `components` tras procesar todas las aristas es la respuesta**: El resultado de reducir en 1 cada vez que una operación union tiene éxito, partiendo del valor inicial `n`, es el número final de componentes conexos

## Conocimientos previos

### Qué es Union-Find (estructura de datos de conjuntos disjuntos)

Es una estructura de datos que gestiona elementos dividiéndolos en grupos. Proporciona dos operaciones: "unificar dos elementos en el mismo grupo (union)" y "obtener el representante (raíz) del grupo al que pertenece un elemento (find)". Se registra el padre de cada elemento en un arreglo `parent`, y se identifica el representante del grupo siguiendo los padres hasta la raíz.

```java
int[] parent = new int[n];   // parent[i] almacena el nodo padre del nodo i
for (int i = 0; i < n; i++)
    parent[i] = i;            // Estado inicial: cada nodo tiene a sí mismo como padre (grupo independiente)
```

### Qué es la compresión de caminos (Path Compression)

Es una técnica de optimización que, durante el proceso recursivo de find, reasigna el padre de todos los nodos visitados directamente a la raíz. Esto permite que las llamadas posteriores a find devuelvan la raíz inmediatamente, y al aplanar el árbol, la complejidad se reduce a prácticamente O(1).

```java
int find(int[] parent, int x) {
    if (parent[x] != x)
        parent[x] = find(parent, parent[x]);  // Encuentra la raíz recursivamente y reasigna el padre a la raíz
    return parent[x];                          // Devuelve la raíz
}
```

### Qué es union por rango (Rank)

Es una técnica que, al ejecutar union, compara el límite superior de la altura del árbol (rango) y coloca el árbol de menor rango debajo del de mayor rango. Al limitar el aumento de la altura del árbol, se mantiene la eficiencia de find. Solo cuando los rangos son iguales se incrementa en 1 el rango del destino de la unificación.

```java
int[] rank = new int[n];     // rank[i] es el límite superior de la altura del árbol con raíz en el nodo i (valor inicial es 0)
// Se establece como padre al de mayor rango → el árbol no se profundiza fácilmente
if (rank[r1] > rank[r2])
    parent[r2] = r1;         // Se coloca el árbol de r2 debajo de r1
```

### Qué es α (función inversa de Ackermann)

Es una función que aparece en la complejidad de Union-Find. Para tamaños de entrada prácticos, α(V) es siempre 5 o menor, por lo que se puede considerar efectivamente como una constante. Por ello, cada operación de Union-Find funciona en prácticamente O(1).

## Complejidad

| | Valor |
|---|---|
| Time | O(V + E · α(V)) — O(V) para la inicialización; se ejecutan find y union para cada arista, pero como α(V) es prácticamente una constante, en la práctica es O(V + E) |
| Space | O(V) — Se almacenan V elementos en cada uno de los arreglos parent y rank |

## Código

```java
// Entrada: número de nodos n y lista de aristas edges (cada arista es un arreglo de 2 elementos [a, b])
// Salida: devuelve el número de componentes conexos como entero

// Función find con compresión de caminos: devuelve la raíz del grupo al que pertenece el nodo x
int find(int[] parent, int x) {
    if (parent[x] != x)
        // Encuentra la raíz recursivamente y reasigna el padre directamente a la raíz (compresión de caminos)
        // Esto permite que las llamadas posteriores a find devuelvan la raíz inmediatamente
        parent[x] = find(parent, parent[x]);
    return parent[x];
}

int countComponents(int n, int[][] edges) {
    // Arreglo que almacena el padre de cada nodo. Se inicializa con parent[i] = i para que cada nodo sea un grupo independiente
    int[] parent = new int[n];
    // Arreglo que almacena el límite superior de la altura del árbol con raíz en cada nodo (se usa para decidir cuál se coloca debajo durante union)
    int[] rank = new int[n];
    for (int i = 0; i < n; i++)
        parent[i] = i;

    // En el estado inicial cada nodo es un componente conexo independiente, por lo que el número de componentes es n
    int components = n;

    // Se recorren las aristas una por una y se unifican los grupos a los que pertenecen los nodos de ambos extremos
    for (int[] e : edges) {
        // Se obtiene la raíz del grupo al que pertenece cada nodo extremo de la arista (la compresión de caminos reasigna los padres de los nodos visitados a la raíz)
        int r1 = find(parent, e[0]);
        int r2 = find(parent, e[1]);

        // Si las raíces son diferentes, pertenecen a grupos distintos y se unifican (si las raíces son iguales, ya pertenecen al mismo grupo y no se hace nada)
        if (r1 != r2) {
            // Se comparan los rangos y se coloca el de menor rango debajo del de mayor rango (para limitar el aumento de la altura del árbol)
            if (rank[r1] > rank[r2])
                parent[r2] = r1;
            else if (rank[r1] < rank[r2])
                parent[r1] = r2;
            else {
                // Si los rangos son iguales, se coloca r2 debajo de r1 y se incrementa el rango de r1 en 1
                parent[r2] = r1;
                rank[r1]++;
            }
            // Dos grupos se unificaron en uno, por lo que se reduce el número de componentes en 1
            components--;
        }
    }
    // El valor de components tras procesar todas las aristas es el número de componentes conexos
    return components;
}
```
