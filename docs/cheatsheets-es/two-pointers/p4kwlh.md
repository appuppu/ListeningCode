# Calculating Trapped Rainwater Between Bars — Calcular la cantidad de agua de lluvia atrapada entre barras

## Esencia del problema

Se proporciona un arreglo de enteros no negativos `height`. Cada elemento representa un mapa de alturas con barras de ancho 1. Se debe calcular y devolver la **cantidad total de agua** que se acumula entre las barras después de que llueve.

## Idea central

La cantidad de agua que se acumula en una posición se determina restando la altura de la barra en esa posición al menor valor entre la altura máxima del lado izquierdo y la altura máxima del lado derecho. Si se mueven dos punteros desde ambos extremos hacia el centro mientras se actualizan las alturas máximas de cada lado, se puede calcular la cantidad de agua en cada posición sin necesidad de arreglos adicionales.

## Proceso de razonamiento

1. **La cantidad de agua en cada posición se determina por las alturas máximas de ambos lados**: La cantidad de agua que se acumula en una posición `i` es `min(altura máxima izquierda, altura máxima derecha) - height[i]`. El agua solo se acumula hasta la altura de la pared más baja entre las paredes izquierda y derecha
2. **Se busca obtener las alturas máximas de ambos lados de forma eficiente**: Recorrer ambos lados para obtener las alturas máximas en cada posición requiere O(n²). Si se preparan dos arreglos para precalcular los valores, se reduce a O(n), pero se necesita Space O(n). Se busca una forma de lograrlo con Space O(1)
3. **Se mueven los punteros desde ambos extremos hacia el centro**: Se coloca un puntero `left` en el extremo izquierdo y un puntero `right` en el extremo derecho, y se mueven hacia el centro. Se rastrean las alturas máximas vistas hasta el momento en cada lado con las variables `maxLeftHeight` y `maxRightHeight`
4. **Se mueve el puntero del lado menor**: Cuando `height[left] <= height[right]`, se garantiza que la altura máxima del lado izquierdo es menor o igual que la del lado derecho. Esto se debe a que en el lado derecho existe al menos una pared de altura `height[right]` o mayor. Por esta razón, en la posición del puntero izquierdo se puede determinar la cantidad de agua solo con `maxLeftHeight`
5. **Se suma la cantidad de agua después de mover el puntero**: Se avanza el puntero una posición, se actualiza la altura máxima en la nueva posición y se suma `maxLeftHeight - height[left]` (o `maxRightHeight - height[right]`) a la cantidad de agua. Como la altura máxima siempre es mayor o igual que la altura de la barra actual, esta diferencia siempre es 0 o mayor
6. **Se finaliza cuando ambos punteros se encuentran**: Se continúa el bucle mientras `left < right` y se devuelve `totalwater`, que es la suma de la cantidad de agua de todas las posiciones

## Conocimientos previos

### Qué es Two Pointers (2 punteros)

Es una técnica que consiste en colocar dos punteros en ambos extremos o en diferentes posiciones de un arreglo y recorrerlo moviendo uno u otro según la condición. Permite procesar todo el arreglo en un solo recorrido y es eficaz para arreglos ordenados o búsquedas desde ambos extremos.

```java
int left = 0;                    // Puntero en el extremo izquierdo
int right = height.length - 1;   // Puntero en el extremo derecho
while (left < right) {           // Bucle hasta que los dos punteros se encuentren
    // Se mueve el puntero hacia el centro con left++ o right-- según la condición
}
```

### Qué es Math.max

Es un método estático de Java que devuelve el mayor de dos valores. Aquí se utiliza para actualizar la altura máxima vista hasta el momento cada vez que el puntero avanza.

```java
int maxHeight = 3;
maxHeight = Math.max(maxHeight, 5);  // maxHeight se actualiza a 5
maxHeight = Math.max(maxHeight, 2);  // maxHeight permanece en 5 (porque 2 < 5)
```

### Condición para que se acumule agua

Para que se acumule agua en una posición, se necesitan paredes más altas que la barra actual en ambos lados de esa posición. La cantidad de agua acumulada es el valor que resulta de restar la altura de la barra actual a la altura de la pared más baja entre las paredes izquierda y derecha.

```
// height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]
// Posición 2 (altura 0): máx izquierdo=1, máx derecho=3 → min(1,3) - 0 = se acumula 1 de agua
// Posición 5 (altura 0): máx izquierdo=2, máx derecho=3 → min(2,3) - 0 = se acumulan 2 de agua
```

## Complejidad computacional

| | Valor |
|---|---|
| Time | O(n) — Los punteros izquierdo y derecho se mueven un total de n veces y recorren el arreglo una sola vez |
| Space | O(1) — Solo se utilizan variables para los punteros y las alturas máximas, sin necesidad de arreglos adicionales |

## Código

```java
// Entrada: arreglo de enteros no negativos height (cada elemento es la altura de una barra)
// Salida: devuelve la cantidad total de agua acumulada entre las barras como int
public int trap(int[] height) {
    // Se inicializa en 0 la variable que almacena la cantidad total de agua acumulada
    int totalwater = 0;

    // Se establece el puntero izquierdo al inicio del arreglo y el puntero derecho al final del arreglo
    int left = 0;
    int right = height.length - 1;

    // Se inicializan las alturas máximas de cada lado vistas hasta el momento
    // Las barras en los extremos no acumulan agua, por lo que se usan como valores iniciales
    int maxLeftHeight = height[left];
    int maxRightHeight = height[right];

    // Se ejecuta el bucle hasta que los dos punteros se encuentren
    while (left < right) {
        // Cuando height[left] <= height[right], existe al menos una pared de altura height[right] en el lado derecho
        // Por lo tanto, se puede determinar la cantidad de agua solo con la altura máxima del lado izquierdo
        if (height[left] <= height[right]) {
            // Se avanza el puntero una posición a la derecha y luego se calcula la cantidad de agua
            left++;
            // Se actualiza la altura máxima del lado izquierdo vista hasta el momento
            maxLeftHeight = Math.max(maxLeftHeight, height[left]);
            // Como maxLeftHeight siempre es mayor o igual que height[left], el valor sumado siempre es 0 o mayor
            totalwater += maxLeftHeight - height[left];
        } else {
            // Cuando height[left] > height[right], existe al menos una pared de altura height[left] en el lado izquierdo
            // Por lo tanto, se puede determinar la cantidad de agua solo con la altura máxima del lado derecho
            right--;
            // Se actualiza la altura máxima del lado derecho vista hasta el momento
            maxRightHeight = Math.max(maxRightHeight, height[right]);
            // Como maxRightHeight siempre es mayor o igual que height[right], el valor sumado siempre es 0 o mayor
            totalwater += maxRightHeight - height[right];
        }
    }
    // Al finalizar el bucle, se devuelve totalwater con la suma de la cantidad de agua de todas las posiciones
    return totalwater;
}
```
