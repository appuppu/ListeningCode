# Finding Duplicates in an Array — Determinar si existen valores duplicados en un array

## Esencia del problema

Se recibe un array de enteros `nums`. Si algún valor aparece dos o más veces en el array, se devuelve `true`; si todos los elementos son distintos, se devuelve `false`.

## Idea central

Si se recorre el array y se registra cada elemento visto en un HashSet, se puede determinar en O(1) si cada elemento ya ha aparecido antes. En el momento en que se encuentra un duplicado, se devuelve `true` de inmediato.

## Proceso de razonamiento

1. **Detectar duplicados = determinar "si ya se ha visto el mismo valor antes"**: Al recorrer el array desde el inicio, si el elemento actual ya ha aparecido anteriormente, entonces es un duplicado. Es decir, si se puede gestionar un "conjunto de elementos vistos hasta ahora", se pueden detectar los duplicados
2. **Se necesita buscar rápidamente entre los elementos ya vistos**: Para determinar en O(1) si "este valor ya se ha visto", el HashSet es la estructura adecuada. El HashSet permite verificar la existencia de un elemento en O(1)
3. **Qué se almacena en el HashSet**: Como el problema solo requiere devolver un valor booleano y no índices, basta con almacenar únicamente los valores en el HashSet
4. **Construir el HashSet mientras se recorre el array**: Se recorre el array en orden desde el inicio y, para cada elemento, se verifica "si ya está contenido en el HashSet". Si está contenido, se ha encontrado un duplicado; si no, se añade el elemento actual al HashSet y se avanza al siguiente
5. **Optimizar mediante retorno anticipado**: En el momento en que se encuentra un duplicado, se devuelve `true` de inmediato. Si se termina de recorrer todo el array sin encontrar duplicados, se devuelve `false`

## Conocimientos previos

### Qué es un HashSet

Es una estructura de datos que gestiona un conjunto de elementos sin duplicados. Permite añadir elementos y verificar su existencia en O(1). A diferencia de un HashMap, no almacena pares de clave y valor, sino únicamente valores. Posee la propiedad de eliminar duplicados automáticamente.

```java
HashSet<Integer> set = new HashSet<>();  // Crear un HashSet vacío
set.add(10);              // Añadir el elemento 10
set.contains(10);         // Verificar si el elemento 10 existe, devuelve boolean → true
set.contains(5);          // Verificar si el elemento 5 existe, devuelve boolean → false
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se necesita recorrer el array una vez |
| Space | O(n) — Se almacenan como máximo n elementos en el HashSet |

## Código

```java
// Entrada: array de enteros nums
// Salida: true si existe un valor duplicado, false si todos son distintos
public boolean containsDuplicate(int[] nums) {
    // HashSet que registra los elementos recorridos hasta ahora
    // Como el problema solo requiere un valor booleano, basta con almacenar únicamente los valores
    HashSet<Integer> seen = new HashSet<>();

    for (int num : nums) {
        // Si el elemento actual ya existe en el HashSet, el mismo valor ha aparecido dos veces, confirmando un duplicado
        if (seen.contains(num)) {
            return true;  // Se devuelve de inmediato al encontrar un duplicado (retorno anticipado)
        }

        // Se añade el elemento actual al HashSet y se avanza al siguiente
        // Este elemento será referenciado como "elemento visto anteriormente" en las iteraciones posteriores
        seen.add(num);
    }
    // Si el bucle termina sin encontrar duplicados, se confirma que todos los elementos son distintos
    return false;
}
```
