# Counting the Number of Islands in a Grid — Contar el número de islas en una cuadrícula

## Esencia del problema

Se proporciona una cuadrícula 2D compuesta por `'1'` (tierra) y `'0'` (agua). Un conjunto de celdas de tierra adyacentes en dirección horizontal o vertical se considera una "isla", y se debe devolver el **número total** de islas en la cuadrícula.

## Idea central

Si se considera cada celda de tierra como un nodo y se unen las celdas de tierra adyacentes entre sí mediante Union-Find, el número de grupos independientes (raíces) que quedan al final corresponde directamente al número de islas.

## Proceso de razonamiento

1. **Una isla es un "componente conexo"**: Dado que un conjunto de celdas de tierra adyacentes forma una isla, este problema se reduce a encontrar el número de componentes conexos en la cuadrícula
2. **Union-Find es adecuado para gestionar componentes conexos**: Union-Find puede realizar las operaciones de "unir dos elementos en el mismo grupo" y "determinar si dos elementos pertenecen al mismo grupo" en prácticamente O(1). Si se trata cada celda de tierra de la cuadrícula como un elemento, basta con unir secuencialmente las celdas adyacentes para obtener los componentes conexos
3. **Convertir las celdas de la cuadrícula 2D a índices 1D**: Como el arreglo de Union-Find es unidimensional, se convierte la celda `(i, j)` en un solo entero mediante `i * n + j` (donde n es el número de columnas). De esta manera, las celdas de la cuadrícula 2D se pueden manejar como elementos de Union-Find
4. **Contar las celdas de tierra durante la inicialización**: Se establece el `parent` de cada celda de tierra como ella misma y se inicializa `count` (número de islas) con el total de celdas de tierra. En este punto, cada celda de tierra es una isla independiente
5. **Reducir el número de islas mediante la unión con celdas adyacentes**: Se recorre la cuadrícula y, para cada celda de tierra, se ejecuta `union` si la celda adyacente a la derecha o hacia abajo es tierra. Cada vez que `union` fusiona dos grupos distintos, `count` se reduce en 1. Basta con verificar solo la derecha y abajo, ya que la izquierda y arriba ya fueron procesadas durante el recorrido de celdas anteriores, cubriendo así todas las relaciones de adyacencia
6. **El count final es la respuesta**: El valor de `count` después de completar todas las uniones es el número de componentes conexos independientes, es decir, el número de islas

## Conocimientos previos

### ¿Qué es Union-Find (estructura de datos de conjuntos disjuntos)?

Es una estructura de datos que gestiona múltiples elementos dividiéndolos en grupos. Proporciona dos operaciones: "unir dos elementos en el mismo grupo (union)" y "averiguar a qué grupo pertenece un elemento (find)". Se gestiona el padre de cada elemento mediante el arreglo `parent` y se representan los grupos con una estructura de árbol.

```java
int[] parent = new int[n];   // parent[i] = padre del elemento i
int[] rank = new int[n];     // rank[i] = límite superior de la altura del árbol con raíz en el elemento i

// Inicialización: se establece el padre de cada elemento como él mismo (cada elemento es un grupo independiente)
for (int i = 0; i < n; i++)
    parent[i] = i;
```

### ¿Qué es la compresión de caminos (Path Compression)?

Es una técnica de optimización que, durante la operación `find`, reasigna el padre de todos los nodos en el camino de búsqueda directamente a la raíz. Después de encontrar la raíz de forma recursiva, se actualiza el padre a la raíz con `parent[x] = find(parent[x])`. Esto hace que las operaciones `find` posteriores se acerquen a O(1).

```java
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);  // Reasignar el padre a la raíz
    return parent[x];
}
```

### ¿Qué es la unión por rango (Union by Rank)?

Es una técnica que, durante la operación `union`, conecta el árbol de menor altura (rank) debajo del de mayor altura. Esto suprime el aumento de la altura del árbol y mantiene la eficiencia de búsqueda de `find`. Solo cuando ambos rangos son iguales se incrementa el rango en 1 después de la unión.

```java
void union(int x, int y) {
    int rx = find(x), ry = find(y);  // Encontrar la raíz de cada uno
    if (rx == ry) return;            // Si ya pertenecen al mismo grupo, no se hace nada
    if (rank[rx] < rank[ry])         // Conectar el de menor rango debajo del de mayor rango
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;                  // Incrementar el rango solo cuando ambos rangos son iguales
    }
}
```

### Conversión de índice 2D a índice 1D

Es la fórmula para convertir la celda `(i, j)` de una cuadrícula 2D en un índice de arreglo unidimensional. Si el número de columnas es `n`, se convierte en un entero único mediante `id = i * n + j`.

```java
int m = 3, n = 4;          // Cuadrícula de 3 filas y 4 columnas
int id = i * n + j;        // Celda (1, 2) → 1 * 4 + 2 = 6
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(m × n × α(m × n)) — Se recorren todas las celdas y se realizan como máximo 2 operaciones de union/find por celda. α es la función inversa de Ackermann, que en la práctica se considera una constante |
| Space | O(m × n) — Se almacenan m × n elementos en cada uno de los arreglos parent y rank |

## Código

```java
// Entrada: char[][] grid compuesto por '1' (tierra) y '0' (agua)
// Salida: se devuelve como int el número de islas en la cuadrícula

int[] parent;
int[] rank;
int count;

// find con compresión de caminos: devuelve la raíz del elemento x y reasigna el padre de todos los nodos en el camino a la raíz
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);
    return parent[x];
}

// Unión por rango: une dos elementos en el mismo grupo y reduce count en 1 si la unión es exitosa
void union(int x, int y) {
    int rx = find(x), ry = find(y);
    if (rx == ry) return;       // Si ya pertenecen al mismo grupo, no se hace nada
    if (rank[rx] < rank[ry])
        parent[rx] = ry;       // Conectar el de menor rango debajo del de mayor rango
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;             // Incrementar el rango solo cuando ambos rangos son iguales
    }
    count--;                    // Dos grupos se fusionaron en uno, por lo que se reduce el número de islas en 1
}

public int numIslandsUF(char[][] grid) {
    // Obtener el número de filas m y el número de columnas n de la cuadrícula
    int m = grid.length;
    int n = grid[0].length;
    // Crear los arreglos parent y rank con tamaño m * n
    parent = new int[m * n];
    rank = new int[m * n];
    // Inicializar el número de islas en 0 (se contarán las celdas de tierra en el recorrido siguiente)
    count = 0;

    // Inicialización: se establece el padre de cada celda de tierra como ella misma (i * n + j) y se asigna a count el total de celdas de tierra
    // En este punto, cada celda de tierra es una isla independiente
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            parent[i * n + j] = i * n + j;  // Convertir el índice 2D a 1D y establecer el padre como él mismo
            count++;                          // Incrementar count en 1 por cada celda de tierra
        }

    // Para cada celda de tierra, se une con la celda adyacente a la derecha y abajo si es tierra
    // Razón por la que solo se verifican las 2 direcciones derecha y abajo: la izquierda y arriba ya fueron procesadas durante el recorrido de celdas anteriores
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            int id = i * n + j;              // Calcular el índice 1D de la celda actual
            if (j + 1 < n && grid[i][j + 1] == '1')
                union(id, id + 1);           // Unir con la celda de tierra a la derecha (id + 1 es el índice 1D de la celda derecha)
            if (i + 1 < m && grid[i + 1][j] == '1')
                union(id, id + n);           // Unir con la celda de tierra de abajo (id + n es el índice 1D de la celda inferior)
        }

    // count se ha reducido en 1 con cada unión exitosa desde su valor inicial (total de celdas de tierra), y su valor final es el número de islas
    return count;
}
```
