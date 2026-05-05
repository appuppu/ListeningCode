# Finding the Redundant Edge in a Graph — Encontrar la arista redundante en un grafo formado al agregar una arista a un árbol

## Esencia del problema

Se proporciona un grafo formado al agregar una arista a un árbol compuesto por n nodos y n-1 aristas, de modo que se forma exactamente un ciclo. El objetivo es encontrar y devolver la arista redundante que fue agregada. Al eliminar esa arista, el grafo vuelve a ser un árbol válido.

## Idea central

Al procesar las aristas una por una, si aparece una arista que conecta dos nodos que ya pertenecen a la misma componente conexa, esa arista es la arista redundante que crea el ciclo. Union-Find es la estructura de datos óptima para esta verificación.

## Proceso de razonamiento

1. **Aprovechar las propiedades de un árbol**: Un árbol es una estructura que conecta n nodos con n-1 aristas y no contiene ciclos. Al agregar una arista, se forma exactamente un ciclo. Es decir, basta con detectar la arista que genera el ciclo durante el proceso de agregar aristas en orden
2. **Considerar la condición de detección de ciclos**: Al agregar la arista (u, v), si u y v ya pertenecen a la misma componente conexa, esa arista forma un ciclo. Por el contrario, si u y v pertenecen a componentes conexas diferentes, esa arista solo une las dos componentes y no genera un ciclo
3. **Union-Find es adecuado para gestionar componentes conexas**: Union-Find es la estructura de datos que permite realizar de forma eficiente la verificación de si dos nodos pertenecen a la misma componente conexa y la operación de unir dos componentes conexas. Comparando las raíces mediante la operación find se determina si pertenecen a la misma componente, y mediante la operación union se unen las componentes
4. **Optimización de Union-Find**: Mediante la compresión de caminos (path compression), en cada operación find se reconectan los nodos directamente a la raíz. Mediante la unión por rango (rank), se limita la altura del árbol. Con estas dos optimizaciones, la complejidad de cada operación es α(n) (función inversa de Ackermann, prácticamente constante)
5. **Procesar las aristas en orden**: Se procesa el arreglo de aristas proporcionado desde el inicio en orden, intentando la operación union para cada arista. La arista para la cual union falla (= ya pertenecen a la misma componente) es la arista redundante, y se devuelve
6. **Valor a devolver**: Se devuelve como `int[]` la arista para la cual la operación union falló. Debido a las restricciones del problema, siempre existe exactamente una arista redundante, por lo que no hay caso en que no se encuentre una respuesta

## Conocimientos previos

### Qué es Union-Find (estructura de datos de conjuntos disjuntos)

Es una estructura de datos que divide múltiples elementos en grupos (componentes conexas) y permite realizar de forma eficiente la verificación de si dos elementos pertenecen al mismo grupo y la operación de unir dos grupos. Representa la estructura de árbol de los grupos mediante un arreglo `parent`, y determina que dos elementos pertenecen al mismo grupo si tienen la misma raíz (elemento representante).

```java
int[] parent = new int[n + 1];  // parent[i] almacena el padre del nodo i
int[] rank = new int[n + 1];    // rank[i] es el límite superior de la altura del árbol con raíz en el nodo i
for (int i = 1; i <= n; i++)
    parent[i] = i;              // En el estado inicial, cada nodo es su propio padre (todos son grupos independientes)
```

### Operación find (con compresión de caminos)

Devuelve la raíz (elemento representante) del grupo al que pertenece el nodo x. Recorre los padres recursivamente y reconecta todos los nodos en el camino directamente a la raíz (compresión de caminos). Esto acelera las operaciones find posteriores.

```java
int find(int[] parent, int x) {
    if (parent[x] != x)                    // Si x no es la raíz
        parent[x] = find(parent, parent[x]); // Recorre los padres recursivamente y reconecta directamente a la raíz
    return parent[x];                       // Devuelve la raíz de x
}
```

### Operación union (unión por rango)

Une los grupos a los que pertenecen dos nodos. Conecta el grupo con menor rango (límite superior de la altura del árbol) debajo del grupo con mayor rango para limitar el aumento de la altura del árbol. Si los dos nodos ya pertenecen al mismo grupo, no realiza la unión y devuelve `false`.

```java
boolean union(int[] parent, int[] rank, int x, int y) {
    int rx = find(parent, x);  // Obtiene la raíz de x
    int ry = find(parent, y);  // Obtiene la raíz de y
    if (rx == ry) return false; // Si pertenecen al mismo grupo, no es necesario unir → devuelve false
    // Conecta el de menor rango debajo del de mayor rango
    if (rank[rx] < rank[ry]) parent[rx] = ry;
    else if (rank[rx] > rank[ry]) parent[ry] = rx;
    else { parent[ry] = rx; rank[rx]++; }  // Si los rangos son iguales, conecta uno debajo del otro e incrementa el rango en 1
    return true;  // Unión exitosa → devuelve true
}
```

### Qué es la función inversa de Ackermann α(n)

Es la función que expresa la complejidad por operación de Union-Find. α(n) crece muy lentamente, y para tamaños de entrada prácticos (n < 2^65536), α(n) ≤ 4, por lo que se puede considerar prácticamente como una constante.

## Complejidad

| | Valor |
|---|---|
| Time | O(n × α(n)) ≈ O(n) — Se realiza una operación find y una union por cada una de las n aristas. Como α(n) es prácticamente constante, se puede considerar O(n) |
| Space | O(n) — Se almacenan n+1 elementos en cada uno de los arreglos parent y rank |

## Código

```java
// Entrada: arreglo de aristas edges (cada elemento es int[]{u, v}, que representa una arista que conecta el nodo u con el nodo v)
// Salida: devuelve como int[] la arista redundante que forma un ciclo

// Devuelve la raíz del grupo al que pertenece el nodo x (con compresión de caminos)
int find(int[] parent, int x) {
    if (parent[x] != x)
        // Recorre los padres recursivamente y reconecta directamente a la raíz (compresión de caminos)
        parent[x] = find(parent,
            parent[x]);
    return parent[x];
}

// Une los grupos a los que pertenecen dos nodos. Devuelve false si ya pertenecen al mismo grupo
boolean union(int[] parent,
        int[] rank, int x, int y) {
    int rx = find(parent, x); // Obtiene la raíz de x
    int ry = find(parent, y); // Obtiene la raíz de y
    if (rx == ry) return false; // Ya pertenecen a la misma componente conexa → devuelve false porque se formaría un ciclo
    // Conecta el de menor rango debajo del de mayor rango para limitar el aumento de la altura del árbol
    if (rank[rx] < rank[ry])
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        // Si los rangos son iguales, conecta uno debajo del otro e incrementa el rango en 1
        parent[ry] = rx;
        rank[rx]++;
    }
    return true; // Unión exitosa → no se ha formado un ciclo
}

public int[] findRedundantConnection(
        int[][] edges) {
    // Número de aristas = número de nodos (n-1 del árbol + 1 redundante = n). Los nodos están numerados de 1 a n
    int n = edges.length;
    // Inicializa cada nodo como un grupo independiente (parent[i] = i, es decir, cada uno es su propia raíz)
    int[] parent = new int[n + 1];
    int[] rank = new int[n + 1]; // El arreglo rank se puede dejar con el valor predeterminado de 0
    for (int i = 1; i <= n; i++)
        parent[i] = i;

    // Procesa las aristas una por una desde el inicio y detecta la arista que forma un ciclo
    for (int[] e : edges) {
        // Si union devuelve false, e[0] y e[1] ya pertenecen a la misma componente conexa
        // → Esta arista es la arista redundante que forma un ciclo, por lo que se devuelve directamente
        if (!union(parent, rank,
                e[0], e[1]))
            return e;
    }
    // Debido a las restricciones del problema, siempre existe exactamente una arista redundante, por lo que este punto no se alcanza
    return new int[0];
}
```
