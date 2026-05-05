# Finding Combinations That Sum to a Target Without Reuse — Encontrar todas las combinaciones únicas que suman un objetivo a partir de un arreglo con elementos duplicados

## Esencia del problema

Se proporciona un arreglo de enteros `candidates` (que puede contener elementos duplicados) y un entero `target`. El objetivo es encontrar todas las combinaciones de números del arreglo cuya suma sea igual a `target`. Cada número solo se puede usar **una vez** en cada combinación, y el resultado **no debe contener combinaciones duplicadas**.

## Idea central

Al ordenar el arreglo, los elementos con el mismo valor quedan adyacentes, lo que permite aplicar la condición `i > start && cands[i] == cands[i-1]` para omitir elementos duplicados en el mismo nivel de recursión. Esto previene la generación de combinaciones duplicadas desde la raíz, mientras se exploran todas las combinaciones únicas sin omisiones.

## Proceso de razonamiento

1. **Es necesario enumerar todas las combinaciones**: El problema pide "todas las combinaciones que cumplan la condición", por lo que se debe explorar todo el espacio de soluciones en lugar de buscar una única solución óptima. El backtracking es adecuado para este tipo de problemas de "enumeración completa"
2. **Se ramifica en "usar/no usar" cada elemento**: Para cada elemento del arreglo, se elige recursivamente si "incluirlo o no en la combinación actual". Para usar cada elemento solo una vez, se avanza el índice de inicio a `i + 1` en la llamada recursiva
3. **Es necesario eliminar combinaciones duplicadas**: Cuando el arreglo contiene elementos duplicados, seleccionar el mismo valor en diferentes índices genera combinaciones idénticas. Por ejemplo, en `[1,1,2]` con target=3, la combinación del primer 1 con 2 y la del segundo 1 con 2 producen el mismo `[1,2]`
4. **Ordenar y omitir duplicados**: Al ordenar el arreglo, los valores iguales quedan adyacentes. En el mismo nivel de recursión (dentro del mismo bucle for), si se omiten los elementos con el mismo valor que el anterior, se previene la generación de combinaciones duplicadas. La condición de omisión es `i > start && cands[i] == cands[i-1]`. La condición `i > start` permite usar el primero de los valores iguales y omite los siguientes
5. **Optimizar la búsqueda mediante poda**: Como el arreglo está ordenado, cuando el elemento actual supera el valor restante `remain`, todos los elementos posteriores también lo superarán. Con `if (cands[i] > remain) break` se interrumpe el bucle para eliminar búsquedas innecesarias
6. **Determinación del caso base**: Cuando `remain` llega a 0, significa que la suma de los elementos en el `path` actual es exactamente igual a `target`, por lo que se agrega una copia de `path` a la lista de resultados

## Conocimientos previos

### Qué es el backtracking

El backtracking es una técnica de búsqueda que construye candidatos de solución de forma incremental y, cuando se determina que no cumplen la condición, retrocede al estado anterior (backtrack) para probar otro candidato. Se implementa con el patrón "selección → recursión → deshacer la selección".

```java
path.add(element);          // Selección: agregar el elemento a la combinación
backtrack(next_state);      // Recursión: continuar la exploración con el siguiente elemento
path.remove(path.size()-1); // Deshacer: eliminar el elemento de la combinación para restaurar el estado original
```

### Qué es Arrays.sort

Es un método estándar de Java que ordena un arreglo en orden ascendente. Al ordenar, los elementos con el mismo valor quedan adyacentes, lo que facilita la detección y omisión de duplicados.

```java
int[] arr = {2, 1, 2, 3};
Arrays.sort(arr);           // arr se transforma en {1, 2, 2, 3}
```

### Constructor de copia de ArrayList

`new ArrayList<>(path)` crea una nueva lista copiando el contenido de `path`. En el backtracking, como `path` cambia continuamente durante la recursión, es necesario crear una copia en el momento de agregarla al resultado.

```java
List<Integer> path = new ArrayList<>(Arrays.asList(1, 2));
List<Integer> copy = new ArrayList<>(path);  // Se crea una copia de [1, 2]
path.add(3);        // path se transforma en [1, 2, 3]
// copy permanece sin cambios como [1, 2]
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(2^n) — Dado que cada elemento tiene dos opciones "usar/no usar", en el peor caso se exploran 2^n combinaciones |
| Space | O(n) — La profundidad máxima de la recursión es n, y path también almacena como máximo n elementos |

## Código

```java
// Entrada: arreglo de enteros candidates (puede contener elementos duplicados) y un entero target
// Salida: devuelve un List<List<Integer>> que contiene todas las combinaciones únicas cuya suma es target
private void backtrack(int[] cands, int start, int remain,
        List<Integer> path, List<List<Integer>> result) {
    // Si remain es 0, se encontró una combinación cuya suma en path es exactamente igual a target
    if (remain == 0) {
        // Como path seguirá cambiando en las recursiones posteriores, se crea una copia y se agrega al resultado
        result.add(new ArrayList<>(path));
        return;
    }

    // Al comenzar desde start, se evita seleccionar nuevamente elementos ya usados (anteriores a start)
    for (int i = start; i < cands.length; i++) {
        // Si es el segundo o posterior elemento en el mismo nivel de recursión y tiene el mismo valor que el anterior, se omite para prevenir combinaciones duplicadas
        // i > start significa "no es el primer elemento en el mismo nivel de recursión"
        if (i > start && cands[i] == cands[i - 1]) continue;

        // Como el arreglo está ordenado, si el valor actual supera remain, todos los posteriores también lo superarán (poda)
        if (cands[i] > remain) break;

        path.add(cands[i]);                  // Selección: agregar el elemento a la combinación
        backtrack(cands, i + 1,              // Recursión: usar i+1 para evitar reutilizar el mismo elemento
            remain - cands[i], path, result); // Se resta el elemento actual de remain para actualizar la suma restante
        path.remove(path.size() - 1);        // Deshacer: eliminar el elemento y restaurar el estado para probar otro elemento
    }
}

public List<List<Integer>> combinationSum2(
        int[] candidates, int target) {
    // El ordenamiento coloca los elementos duplicados con el mismo valor de forma adyacente, habilitando la condición de omisión
    Arrays.sort(candidates);
    // Se crean la lista para almacenar resultados y un path vacío para registrar la combinación actual
    List<List<Integer>> result = new ArrayList<>();
    // Se inicia la exploración recursiva desde el índice 0 con la suma restante igual a target
    backtrack(candidates, 0, target, new ArrayList<>(), result);
    // Después de completar toda la recursión, se devuelven todas las combinaciones únicas almacenadas
    return result;
}
```
