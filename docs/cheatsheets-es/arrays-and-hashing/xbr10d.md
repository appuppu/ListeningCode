# Finding the K Most Frequent Elements — Devolver los K elementos con mayor frecuencia de aparición en un arreglo

## Esencia del problema

Se recibe un arreglo de enteros `nums` y un entero `k`. Se deben seleccionar los `k` elementos con mayor número de apariciones en `nums` y devolverlos en un arreglo. El orden de los elementos devueltos no importa. Se garantiza que la respuesta es única.

## Idea central

Después de contar la frecuencia de aparición de cada elemento, se crea un arreglo de cubetas donde la frecuencia sirve como índice. De esta forma, se pueden extraer los elementos en orden de frecuencia en O(n), sin necesidad de ordenamiento (O(n log n)). El valor máximo de frecuencia es menor o igual a la longitud `n` del arreglo, por lo que el tamaño del arreglo de cubetas es finito.

## Proceso de razonamiento

1. **Primero se necesita contar las apariciones de cada elemento**: Para obtener los K elementos con mayor frecuencia, se necesita saber cuántas veces aparece cada elemento. Usando un HashMap, se almacena el «valor numérico» como clave y el «número de apariciones» como valor, lo que permite contabilizar la frecuencia de todos los elementos en O(n)
2. **Se desea ordenar por frecuencia, pero el ordenamiento cuesta O(n log n)**: Una vez completado el mapa de frecuencias, se quieren extraer los K elementos con mayor frecuencia. Ordenar por frecuencia costaría O(n log n), pero existe un método más rápido
3. **Se utiliza un arreglo de cubetas donde la frecuencia sirve como índice**: Cuando la longitud del arreglo es `n`, la frecuencia máxima de cualquier elemento es `n`. Por lo tanto, se prepara un arreglo de tamaño `n+1` y en la posición del índice `i` se almacena «la lista de elementos cuya frecuencia de aparición es `i` veces». Este es el concepto de bucket sort
4. **Se recorre el arreglo de cubetas desde el final para recolectar K elementos**: Cuanto mayor sea el índice del arreglo de cubetas, mayor será la frecuencia de aparición. Se recorre desde el final (índice `n`) hacia el inicio, y si la cubeta no está vacía, se agregan sus elementos a la lista de resultados. Cuando el tamaño de la lista de resultados alcanza `k`, se convierte la lista en un arreglo y se devuelve

## Conocimientos previos

### Qué es un HashMap

Es una estructura de datos que almacena pares de clave y valor. Permite buscar y obtener valores especificando la clave en O(1). En este problema, se utiliza como un contador para contar el número de apariciones de cada valor numérico.

```java
HashMap<Integer, Integer> map = new HashMap<>();  // Crear un HashMap vacío
map.merge(1, 1, Integer::sum);  // Sumar 1 al valor de la clave 1 (si la clave no existe, se inicializa con 1)
map.entrySet();                 // Devolver todos los pares de clave y valor como un Set
entry.getKey();                 // Obtener la clave del par
entry.getValue();               // Obtener el valor del par
```

### Qué es el método merge

`map.merge(key, value, remappingFunction)` almacena `value` directamente si la clave no existe, y si la clave ya existe, combina el valor existente con `value` mediante `remappingFunction`. Si se pasa `Integer::sum`, se suma `value` al valor existente. Es un método conveniente que permite escribir en una sola línea la combinación de `put` + `getOrDefault`.

```java
map.merge(5, 1, Integer::sum);  // Si la clave 5 no existe, se almacena 1; si existe, se almacena el valor existente + 1
// Lo anterior tiene el mismo significado que lo siguiente
map.put(5, map.getOrDefault(5, 0) + 1);
```

### Qué es el bucket sort

Es un método de ordenamiento que distribuye los elementos en un arreglo utilizando el propio valor del elemento como índice. A diferencia del ordenamiento basado en comparaciones (O(n log n)), si el rango de valores es finito, se puede procesar en O(n). En este problema, se utiliza la frecuencia de aparición (máximo `n`) como índice.

```java
List<Integer>[] buckets = new ArrayList[4];  // Crear un arreglo de cubetas con índices de 0 a 3
buckets[2] = new ArrayList<>();              // Inicializar la cubeta del índice 2
buckets[2].add(7);                           // Almacenar 7 como «elemento con frecuencia 2»
// buckets = [null, null, [7], null]
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — La construcción del mapa de frecuencias es O(n), la construcción del arreglo de cubetas es O(n) y la recolección de resultados es O(n), por lo que en total es O(n) |
| Space | O(n) — El mapa de frecuencias contiene como máximo n elementos y el arreglo de cubetas tiene tamaño n+1, por lo que en total es O(n) |

## Código

```java
// Entrada: arreglo de enteros nums y entero k
// Salida: devolver un int[] que contiene los k elementos con mayor frecuencia de aparición
public int[] topKFrequent(int[] nums, int k) {
    // Paso 1: Contabilizar la frecuencia de aparición de cada elemento con un HashMap
    Map<Integer, Integer> freqMap = buildFrequencyMap(nums);
    // Paso 2: Construir un arreglo de cubetas donde la frecuencia sirve como índice
    List<Integer>[] buckets = buildBuckets(freqMap, nums.length);
    // Paso 3: Recorrer el arreglo de cubetas desde el final para recolectar los K elementos principales
    return collectTopK(buckets, k);
}

// Contabilizar el número de apariciones de cada elemento con un HashMap y devolverlo
// Clave = valor numérico, Valor = número de apariciones de ese valor numérico
public Map<Integer, Integer> buildFrequencyMap(int[] nums) {
    Map<Integer, Integer> freqMap = new HashMap<>();
    for (int num : nums) {
        // Con merge, si la clave no existe se inicializa con 1; si existe, se suma 1 al valor existente
        freqMap.merge(num, 1, Integer::sum);
    }
    // Tras completar el recorrido, el HashMap contiene la frecuencia de aparición de todos los elementos
    return freqMap;
}

// Construir y devolver un arreglo de cubetas donde la frecuencia sirve como índice
// buckets[i] contiene la lista de elementos cuya frecuencia de aparición es i veces
public List<Integer>[] buildBuckets(Map<Integer, Integer> freqMap, int n) {
    // El tamaño es n+1 porque un elemento puede aparecer como máximo n veces, y se usan los índices de 0 a n
    List<Integer>[] buckets = new ArrayList[n + 1];
    for (var entry : freqMap.entrySet()) {
        int num = entry.getKey();
        int freq = entry.getValue();
        // Si la cubeta es null, se crea un nuevo ArrayList antes de agregar el elemento
        if (buckets[freq] == null) {
            buckets[freq] = new ArrayList<>();
        }
        // Se utiliza la frecuencia de aparición freq como índice y se agrega el valor numérico num a esa cubeta
        buckets[freq].add(num);
    }
    return buckets;
}

// Recorrer el arreglo de cubetas desde el final y recolectar K elementos en orden descendente de frecuencia
// Cuanto mayor sea el índice, mayor será la frecuencia de aparición, por lo que al recorrer en orden inverso se extraen primero los elementos con mayor frecuencia
public int[] collectTopK(List<Integer>[] buckets, int k) {
    List<Integer> result = new ArrayList<>();
    // Recorrer desde el final (índice n) hacia el inicio. Se excluye el índice 0 porque significa «frecuencia de aparición 0 veces»
    for (int i = buckets.length - 1; i > 0; i--) {
        if (buckets[i] != null) {
            for (int num : buckets[i]) {
                result.add(num);
                // Cuando se han recolectado K elementos, se convierten en un arreglo y se devuelven
                if (result.size() == k) {
                    return result.stream().mapToInt(Integer::intValue).toArray();
                }
            }
        }
    }
    // Según las restricciones del problema, la respuesta siempre existe, por lo que esta línea nunca se alcanza
    return new int[0];
}
```
