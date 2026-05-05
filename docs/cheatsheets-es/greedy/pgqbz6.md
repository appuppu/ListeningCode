# Merging Triplets to Form a Target Triplet — Determinar si se puede formar el objetivo mediante el máximo por elemento de tripletas

## Esencia del problema

Se recibe un arreglo bidimensional `triplets` de tripletas compuestas por tres enteros y una tripleta objetivo `target`. Se debe determinar si es posible seleccionar un subconjunto arbitrario de `triplets` y, al tomar el máximo por elemento (element-wise maximum), obtener un resultado que coincida exactamente con `target`, devolviendo un **boolean**.

## Idea central

Una tripleta que tenga algún valor superior a algún elemento del objetivo no puede usarse nunca, ya que al incluirla en el merge esa posición superaría al objetivo. Por el contrario, si se combinan únicamente las tripletas cuyos elementos son todos menores o iguales al objetivo, se pueden acumular los máximos sin riesgo de exceder el objetivo, y solo resta verificar si el resultado final coincide con el objetivo.

## Proceso de razonamiento

1. **Identificar las tripletas inutilizables**: Si algún elemento de una tripleta `t` supera al elemento correspondiente de `target`, incluir `t` en el merge haría que el máximo exceda al objetivo. Como el máximo una vez incrementado no puede reducirse, esas tripletas no pueden seleccionarse bajo ninguna circunstancia
2. **Todas las tripletas utilizables pueden incluirse**: Las tripletas cuyos elementos son todos menores o iguales a `target` no harán que el merge exceda al objetivo. Como incluirlas no causa daño, se adoptan todas de forma voraz
3. **Cómo acumular el resultado del merge**: Se inicializa un arreglo `result` con `[0, 0, 0]` y se actualiza tomando el máximo entre cada elemento de `result` y cada elemento de las tripletas utilizables. Al usar `Math.max` por elemento, se obtiene el element-wise maximum de todas las tripletas seleccionadas
4. **Verificación final**: Después de procesar todas las tripletas, si `result` coincide exactamente con `target` se devuelve `true`; de lo contrario se devuelve `false`. Se puede usar `Arrays.equals` para comparar todos los elementos del arreglo

## Conocimientos previos

### Qué es el element-wise maximum (máximo por elemento)

Es la operación que compara los elementos en la misma posición de dos o más arreglos y toma el valor máximo en cada posición. Por ejemplo, el element-wise maximum de `[2, 5, 3]` y `[5, 1, 6]` es `[5, 5, 6]`.

```java
int[] a = {2, 5, 3};
int[] b = {5, 1, 6};
int[] merged = new int[3];
merged[0] = Math.max(a[0], b[0]);  // max(2, 5) → 5
merged[1] = Math.max(a[1], b[1]);  // max(5, 1) → 5
merged[2] = Math.max(a[2], b[2]);  // max(3, 6) → 6
// merged = [5, 5, 6]
```

### Qué es Math.max

Es un método que devuelve el mayor de dos valores. Se utiliza para acumular el resultado del merge.

```java
Math.max(3, 7);   // → 7
Math.max(5, 5);   // → 5
Math.max(0, 4);   // → 4 (se usa para actualizar comparando con el valor inicial 0)
```

### Qué es Arrays.equals

Es un método que determina si dos arreglos tienen la misma longitud y todos sus elementos coinciden, devolviendo un boolean. El operador `==` compara referencias, por lo que para comparar el contenido de los arreglos se debe usar este método.

```java
int[] a = {2, 5, 3};
int[] b = {2, 5, 3};
a == b;              // → false (porque las referencias son distintas)
Arrays.equals(a, b); // → true (porque todos los elementos coinciden)
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Solo se recorre el arreglo de tripletas una vez (el procesamiento de cada tripleta es O(1)) |
| Space | O(1) — Solo se utiliza el arreglo `result` de tamaño fijo 3 |

## Código

```java
// Entrada: arreglo bidimensional de enteros triplets (cada elemento es una tripleta de longitud 3) y un arreglo de enteros target de longitud 3
// Salida: true si se puede formar target con el element-wise maximum de un subconjunto de tripletas, false en caso contrario
public boolean mergeTriplets(int[][] triplets, int[] target) {
    // Se inicializa con [0, 0, 0] el arreglo que acumulará el element-wise maximum de las tripletas utilizables
    int[] result = new int[3];

    // Se recorre cada tripleta t de triplets desde el inicio hasta el final, una por una
    for (int[] t : triplets) {
        // Se omite la tripleta si alguno de sus elementos supera al objetivo, ya que incluirla haría que el máximo exceda al objetivo sin posibilidad de corregirlo
        if (t[0] > target[0] ||
            t[1] > target[1] ||
            t[2] > target[2])
            continue;

        // Como todos los elementos son menores o iguales al objetivo, esta actualización no hará que result supere al objetivo
        // Se actualiza el resultado con el máximo de cada elemento
        result[0] = Math.max(result[0], t[0]);
        result[1] = Math.max(result[1], t[1]);
        result[2] = Math.max(result[2], t[2]);
    }

    // Se determina y devuelve si el resultado acumulado coincide exactamente con el objetivo
    return Arrays.equals(result, target);
}
```
