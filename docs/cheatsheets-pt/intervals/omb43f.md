# Determinar se é possível participar de todas as reuniões — Meeting Rooms

## Essência do problema

É fornecido um array `intervals` de intervalos que representam os horários das reuniões (pares de horário de início e horário de término). O objetivo é determinar se uma pessoa pode **participar de todas as reuniões** e retornar um `boolean`. Se uma reunião começa antes do término de outra, as duas reuniões estão em conflito (sobreposição), e não é possível participar de todas.

## Ideia central

Se os intervalos forem ordenados pelo horário de início, a sobreposição só pode ocorrer entre intervalos adjacentes. Basta comparar os pares adjacentes em ordem e verificar se o horário de início do próximo intervalo é anterior ao horário de término do intervalo anterior para determinar a sobreposição em todo o conjunto.

## Processo de raciocínio

1. **Organizar a condição de sobreposição**: Dois intervalos se sobrepõem quando o horário de início de um é anterior ao horário de término do outro. No entanto, se os intervalos estiverem em ordem aleatória, seria necessário comparar todos os pares, resultando em O(n²)
2. **Limitar os alvos de comparação com ordenação**: Ao ordenar os intervalos em ordem crescente pelo horário de início, a sobreposição fica restrita aos intervalos adjacentes. Isso ocorre porque, se `intervals[i]` e `intervals[i+2]` se sobrepõem, então `intervals[i]` e `intervals[i+1]` também necessariamente se sobrepõem
3. **Verificação de sobreposição entre pares adjacentes**: Após a ordenação, se o horário de início de `intervals[i]` for anterior ao horário de término de `intervals[i-1]`, as duas reuniões estão sobrepostas. Essa condição é expressa como `intervals[i][0] < intervals[i-1][1]`
4. **Uma única sobreposição determina o resultado imediatamente**: Se pelo menos um par sobreposto for encontrado, não é possível participar de todas as reuniões, então retorna-se `false`. Se todos os pares adjacentes forem verificados sem sobreposição, retorna-se `true`

## Conhecimentos prévios

### Arrays.sort e Comparator personalizado

`Arrays.sort` é um método que ordena arrays. No caso de arrays bidimensionais, é possível especificar um Comparator (função de comparação) com uma expressão lambda para controlar qual elemento será usado como critério de ordenação.

```java
int[][] intervals = {{7, 10}, {2, 4}, {5, 8}};
Arrays.sort(intervals, (a, b) -> a[0] - b[0]);  // Ordena em ordem crescente pelo horário de início ([0]) de cada intervalo
// Resultado: {{2, 4}, {5, 8}, {7, 10}}
```

`(a, b) -> a[0] - b[0]` recebe dois intervalos `a` e `b` e retorna a diferença dos horários de início. Se a diferença for negativa, `a` vem primeiro; se for positiva, `b` vem primeiro.

### Verificação de sobreposição de intervalos

Quando dois intervalos estão ordenados pelo horário de início, eles se sobrepõem se o início do intervalo posterior for anterior ao término do intervalo anterior.

```java
int[] prev = {2, 4};   // Reunião das 2h às 4h
int[] curr = {3, 6};   // Reunião das 3h às 6h
curr[0] < prev[1];     // 3 < 4 → true → Estão sobrepostos
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n log n) — A ordenação é O(n log n) e a varredura dos pares adjacentes é O(n), sendo a ordenação o fator dominante |
| Space | O(1) — A ordenação reorganiza o array de entrada diretamente, sem utilizar arrays adicionais |

## Código

```java
// Entrada: array bidimensional de inteiros intervals representando os horários das reuniões (cada elemento é [horário de início, horário de término])
// Saída: true se for possível participar de todas as reuniões, false se houver reuniões sobrepostas
public boolean canAttendMeetings(int[][] intervals) {
    // Ordena os intervalos em ordem crescente pelo horário de início
    // Passa a expressão lambda (a, b) -> a[0] - b[0] como Comparator
    // Com isso, basta comparar apenas os pares adjacentes nos intervalos ordenados cronologicamente
    Arrays.sort(intervals, (a, b) -> a[0] - b[0]);

    // Começa em i = 1, não em i = 0. Em cada passo, compara o par adjacente intervals[i] e intervals[i-1]
    for (int i = 1; i < intervals.length; i++) {
        // Se o horário de início da reunião atual for anterior ao horário de término da reunião anterior, há sobreposição
        if (intervals[i][0] < intervals[i - 1][1]) {
            // Se houver pelo menos uma sobreposição, não é possível participar de todas as reuniões, então retorna false imediatamente
            return false;
        }
        // Se não houver sobreposição, avança para o próximo par adjacente
    }
    // Se o loop for concluído até o final, nenhum par adjacente apresentou sobreposição, então retorna true
    return true;
}
```
