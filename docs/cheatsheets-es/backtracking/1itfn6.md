# Generating All Unique Subsets With Duplicates — Generar todos los subconjuntos únicos a partir de un arreglo con elementos duplicados

## Esencia del problema

Se proporciona un arreglo de enteros `nums` que puede contener valores duplicados. Se deben retornar todos los subconjuntos únicos posibles. El resultado no debe contener subconjuntos duplicados, y el orden de los elementos dentro de cada subconjunto puede ser cualquiera.

## Idea central

Si se ordena el arreglo previamente, se puede prevenir de raíz la generación de subconjuntos duplicados simplemente omitiendo el elemento cuando, en el mismo nivel de recursión, se intenta seleccionar un valor igual al del elemento anterior.

## Proceso de razonamiento

1. **La generación de subconjuntos es un problema típico de backtracking**: Se pueden enumerar todos los subconjuntos decidiendo recursivamente para cada elemento si "se selecciona o no se selecciona". Si en cada etapa de la recursión se agrega el subconjunto actual directamente al resultado, se obtienen todos los subconjuntos
2. **Identificar la causa de los duplicados**: Cuando el arreglo contiene múltiples valores iguales, por ejemplo en `[1,2,2]`, seleccionar el primer 2 o seleccionar el segundo 2 genera el mismo subconjunto. Los duplicados ocurren cuando "se selecciona el mismo valor múltiples veces en el mismo nivel de recursión"
3. **Ordenar para que los elementos duplicados queden adyacentes**: Al ordenar el arreglo, los elementos con el mismo valor quedan uno al lado del otro. Esto permite determinar si "el valor es igual al del elemento anterior" mediante una simple comparación
4. **Omitir duplicados en el mismo nivel de recursión**: Dentro del bucle for, cuando se cumple la condición `i > start && nums[i] == nums[i-1]`, se omite ese elemento. La condición `i > start` significa "es la segunda opción o posterior en el mismo nivel de recursión", lo cual permite seleccionar el mismo valor en diferentes niveles de recursión (se permite incluir múltiples valores iguales en un subconjunto)
5. **Agregar al resultado en cada etapa de la recursión**: Al inicio de la función recursiva se agrega el subconjunto actual `curr` a la lista de resultados. De esta manera, desde el conjunto vacío hasta el conjunto con todos los elementos, todos los subconjuntos quedan incluidos en el resultado
6. **Restaurar el estado original mediante backtracking**: Al eliminar el último elemento de `curr` después de la llamada recursiva, se restaura el estado original para explorar correctamente la siguiente opción

## Conocimientos previos

### Qué es el backtracking

Es una técnica de búsqueda que construye candidatos de solución de forma recursiva y, cuando no se cumple una condición, deshace la última elección para probar otra alternativa. Se utiliza para enumerar subconjuntos, permutaciones y combinaciones.

```java
// Estructura básica del backtracking
void backtrack(estado, listaDeOpciones) {
    agregarEstadoActualAlResultado;
    for (cadaOpción) {
        aplicarLaElección;
        backtrack(siguienteEstado, opcionesRestantes);
        deshacerLaElección;  // ← backtrack
    }
}
```

### Qué es Arrays.sort

Es un método que ordena un arreglo en orden ascendente. Al hacer que los elementos duplicados queden adyacentes, facilita la detección de duplicados.

```java
int[] nums = {4, 1, 4, 2};
Arrays.sort(nums);  // nums se convierte en {1, 2, 4, 4}
```

### Copia de ArrayList

`new ArrayList<>(list)` crea una copia superficial de una lista existente. Al agregar un subconjunto al resultado, si se agrega la referencia en lugar de una copia, el contenido se modificará durante el backtracking posterior.

```java
List<Integer> curr = new ArrayList<>();
curr.add(1);
curr.add(2);
List<Integer> copy = new ArrayList<>(curr);  // Se crea una copia de [1, 2]
curr.remove(curr.size() - 1);               // curr vuelve a ser [1], pero copy permanece como [1, 2]
```

### Eliminación del último elemento de una List

`list.remove(list.size() - 1)` elimina el último elemento de la lista. Se utiliza en el backtracking para deshacer el elemento agregado anteriormente.

```java
List<Integer> curr = new ArrayList<>();
curr.add(5);        // curr = [5]
curr.add(3);        // curr = [5, 3]
curr.remove(curr.size() - 1);  // curr vuelve a ser [5]
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n × 2^n) — Existen como máximo 2^n subconjuntos, y copiar cada subconjunto toma como máximo O(n) |
| Space | O(n) — La profundidad máxima de la recursión es n, y la longitud máxima de la lista de trabajo `curr` también es n (excluyendo la lista de resultados) |

## Código

```java
// Entrada: un arreglo de enteros nums que puede contener duplicados
// Salida: retorna un List<List<Integer>> que contiene todos los subconjuntos únicos
void backtrack(int[] nums, int start, List<Integer> curr, List<List<Integer>> result) {
    // Se agrega una copia del subconjunto actual al resultado
    // Se usa new ArrayList<>(curr) para crear una copia porque curr cambia su contenido en las recursiones posteriores, por lo que es necesario guardar el estado en ese momento en lugar de la referencia
    result.add(new ArrayList<>(curr));

    // Al recorrer desde start, no se seleccionan elementos anteriores a uno mismo, manteniendo el orden de los elementos del subconjunto
    for (int i = start; i < nums.length; i++) {
        // Si el valor es igual al del elemento anterior en el mismo nivel de recursión, se omite para evitar duplicados
        // i > start: no es la primera opción de este nivel (en niveles diferentes sí se permite seleccionar el mismo valor)
        // nums[i] == nums[i-1]: el valor es igual al del elemento anterior
        // Cuando ambas condiciones se cumplen simultáneamente, se seleccionaría el mismo valor dos veces en el mismo nivel, generando subconjuntos duplicados
        if (i > start && nums[i] == nums[i - 1]) continue;

        // Se agrega el elemento actual al subconjunto y se avanza al siguiente nivel
        curr.add(nums[i]);
        // Al pasar i + 1, en el siguiente nivel de recursión solo se consideran los elementos posteriores al actual
        backtrack(nums, i + 1, curr, result);

        // Backtrack: se elimina el último elemento para restaurar el estado original y permitir seleccionar otro elemento en la siguiente iteración
        curr.remove(curr.size() - 1);
    }
}

public List<List<Integer>> subsetsWithDup(int[] nums) {
    // Se ordena para que los elementos con el mismo valor queden adyacentes. Esto permite detectar duplicados mediante la simple comparación nums[i] == nums[i-1]
    Arrays.sort(nums);
    List<List<Integer>> result = new ArrayList<>();
    // 0 significa "iniciar la búsqueda desde el principio del arreglo"
    backtrack(nums, 0, new ArrayList<>(), result);
    // Una vez completadas todas las recursiones, result contiene todos los subconjuntos únicos
    return result;
}
```
