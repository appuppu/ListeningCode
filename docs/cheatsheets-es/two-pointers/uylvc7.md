# Maximizing Water Held Between Two Lines — Encontrar el volumen máximo de agua contenida entre dos líneas verticales

## Esencia del problema

Se proporciona un arreglo de enteros no negativos `height`. Cada elemento `height[i]` representa la altura de una línea vertical ubicada en la posición `i` sobre el eje x. Se deben seleccionar dos líneas y calcular el **volumen máximo de agua** que puede contener el recipiente formado junto con el eje x. El volumen del recipiente se determina por "la distancia entre las dos líneas × la altura de la línea más corta de las dos".

## Idea central

Se comienza con el ancho máximo del recipiente (ambos extremos) y se mueve el puntero del lado más corto hacia el interior. Esto permite explorar todos los pares de forma eficiente, manteniendo la posibilidad de mejorar el área mediante un aumento de altura. La razón de mover el lado más corto es que, dado que el ancho se reduce, el área no mejorará a menos que la altura aumente.

## Proceso de razonamiento

1. **Organizar la fórmula del área**: El área del recipiente formado por dos líneas `i` y `j` (i < j) es `(j - i) × min(height[i], height[j])`. Para maximizar el área, es necesario maximizar el producto del "ancho" por el "valor mínimo de las alturas"
2. **Comenzar desde el estado de ancho máximo**: Para maximizar el ancho, se seleccionan las dos líneas en el extremo izquierdo (índice 0) y el extremo derecho (índice n-1). Si se inicia la exploración desde este estado, se parte con el ancho máximo posible
3. **Decidir qué puntero mover**: El ancho siempre se reduce en 1 al mover un puntero hacia el interior. Para mejorar el área, solo se puede aumentar la altura. Dado que la altura del recipiente se determina por la línea más corta de las dos, al mover el puntero del lado más corto hacia el interior, existe la posibilidad de encontrar una línea más alta. Por el contrario, mover el lado más largo no mejora el área porque el lado más corto sigue siendo el cuello de botella
4. **Registrar el área en cada paso**: Cada vez que se mueve un puntero, se calcula la nueva área y se compara con el valor máximo registrado hasta el momento para actualizarlo. De esta manera, se obtiene el mismo resultado que una búsqueda exhaustiva
5. **Determinar la condición de finalización**: Cuando el puntero izquierdo y el puntero derecho se encuentran, todos los pares prometedores ya han sido examinados, por lo que se finaliza la exploración
6. **Valor a retornar al final**: Se retorna el valor máximo del área `maxarea` registrado durante la exploración

## Conocimientos previos

### ¿Qué es Two Pointers (dos punteros)?

Es una técnica que coloca dos punteros (índices) en ambos extremos o en diferentes posiciones de un arreglo, y los mueve uno o ambos según las condiciones mientras se realiza la exploración. Es efectiva cuando se puede reducir una búsqueda de todos los pares O(n²) a O(n) aprovechando las condiciones.

```java
int left = 0;                      // Colocar el puntero izquierdo al inicio del arreglo
int right = height.length - 1;     // Colocar el puntero derecho al final del arreglo
while (left < right) {             // Iterar hasta que los dos punteros se encuentren
    // Mover left o right
    left++;   // Avanzar el puntero izquierdo una posición a la derecha
    right--;  // Retroceder el puntero derecho una posición a la izquierda
}
```

### ¿Qué son Math.min / Math.max?

`Math.min(a, b)` retorna el menor de dos valores, y `Math.max(a, b)` retorna el mayor. Se utilizan para determinar la altura del recipiente (la línea más corta) y para actualizar el valor máximo del área.

```java
Math.min(3, 7);          // Retorna el menor de los dos → 3
Math.max(10, 25);        // Retorna el mayor de los dos → 25
```

### Cálculo del área del recipiente

El área del recipiente formado por dos líneas `left` y `right` se obtiene como ancho × altura. La altura se determina por la línea más corta de las dos.

```java
int width = right - left;                              // Ancho = distancia entre las dos líneas
int minHeight = Math.min(height[left], height[right]);  // Altura = altura de la línea más corta
int area = width * minHeight;                           // Área = ancho × altura
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Los punteros izquierdo y derecho avanzan hacia el interior una sola vez, recorriendo el arreglo una vez |
| Space | O(1) — Solo se utilizan variables para los punteros y el valor máximo |

## Código

```java
// Entrada: un arreglo de enteros no negativos height (cada elemento es la altura de una línea vertical)
// Salida: retorna como int el volumen máximo de agua que puede contener el recipiente formado por dos líneas y el eje x
public int maxArea(int[] height) {
    // Variable que registra el valor máximo del área encontrado durante la exploración. Se inicializa en 0
    int maxarea = 0;
    // Colocar el puntero izquierdo al inicio del arreglo. Se inicia la exploración desde el estado de ancho máximo
    int left = 0;
    // Colocar el puntero derecho al final del arreglo
    int right = height.length - 1;

    // Iterar hasta que los dos punteros se encuentren. Cuando se encuentran, todos los pares prometedores ya han sido examinados
    while (left < right) {
        // Ancho = distancia entre las dos líneas
        int width = right - left;
        // Altura = altura de la línea más corta. El volumen del recipiente se determina por la línea más corta
        int minHeight = Math.min(height[left], height[right]);
        // Área = ancho × altura
        int area = width * minHeight;

        // Comparar con el valor máximo registrado hasta el momento y actualizarlo
        maxarea = Math.max(area, maxarea);

        // Mover el puntero del lado más corto hacia el interior. Dado que el ancho se reduce, el área no mejorará a menos que la altura aumente
        // Mover el lado más largo no mejora el área porque el lado más corto sigue siendo el cuello de botella
        if (height[left] <= height[right]) {
            // La línea izquierda es más corta (o igual), así que se avanza el puntero izquierdo una posición a la derecha para buscar una mejora en la altura
            left++;
        } else {
            // La línea derecha es más corta, así que se retrocede el puntero derecho una posición a la izquierda para buscar una mejora en la altura
            right--;
        }
    }
    // Retornar el valor máximo del área registrado durante la exploración
    return maxarea;
}
```
