# Finding the Minimum Meeting Rooms Required — Encontrar o número mínimo de salas de reunião necessárias para realizar todas as reuniões sem conflitos

## Essência do Problema

É fornecido um array de intervalos de tempo de reuniões (horário de início e horário de término). O objetivo é retornar o **número mínimo de salas de reunião** necessárias para realizar todas as reuniões sem conflitos. Reuniões que se sobrepõem no mesmo intervalo de tempo precisam utilizar salas de reunião diferentes.

## Ideia Central

Se processarmos os inícios e términos das reuniões como eventos separados em ordem cronológica, podemos determinar o número máximo de reuniões ocorrendo simultaneamente em um dado momento. Esse número máximo é o número de salas de reunião necessárias.

## Processo de Raciocínio

1. **O número de reuniões simultâneas é a resposta**: O número máximo de reuniões ocorrendo simultaneamente em um dado momento = número de salas de reunião necessárias. O problema se reduz a encontrar eficientemente o valor máximo de reuniões simultâneas
2. **Tratar inícios e términos como eventos separados**: No início de uma reunião, uma sala se torna necessária; no término, uma sala é liberada. Ao separar inícios e términos e ordenar cada um, podemos processar os eventos em ordem cronológica
3. **Varrer dois arrays ordenados**: Ordenamos o array starts e o array ends, e percorremos starts desde o início. Para cada horário de início, verificamos se ele é anterior ao término mais próximo, determinando assim se uma sala é necessária ou se uma sala é liberada
4. **Rastrear reuniões simultâneas com dois ponteiros**: Preparamos o ponteiro `i` para o array starts e o ponteiro `endPtr` para o array ends. Se `starts[i] < ends[endPtr]`, a nova reunião se sobrepõe a uma reunião existente, então adicionamos uma sala. Caso contrário, uma reunião terminou e uma sala é liberada, então avançamos `endPtr`
5. **Registrar o valor máximo**: Durante a varredura, registramos continuamente o valor máximo de `rooms` em `maxRooms`. Após a varredura completa, retornamos `maxRooms`

## Conhecimentos Prévios

### O que é Arrays.sort

É o método padrão do Java que ordena um array em ordem crescente. Para arrays de tipos primitivos, utiliza o Dual-Pivot Quicksort (O(n log n)).

```java
int[] arr = {5, 2, 8, 1};
Arrays.sort(arr);        // arr se torna {1, 2, 5, 8}
```

### O que é Dois Ponteiros (Two Pointer)

É uma técnica que utiliza duas variáveis de índice, cada uma percorrendo o array de forma independente. Ao aplicar em arrays ordenados, permite comparar e mesclar elementos de dois arrays de forma eficiente.

```java
int i = 0;          // ponteiro para o primeiro array
int endPtr = 0;     // ponteiro para o segundo array
// decide qual ponteiro avançar de acordo com a condição
```

### O que é Varredura de Eventos (Event Sweep)

É uma técnica que processa eventos (inícios e términos) em ordem cronológica ao longo do eixo temporal, rastreando o estado em um dado momento (como o número de ocorrências simultâneas). Ao incrementar o contador em eventos de início e decrementá-lo em eventos de término, é possível determinar o número de ocorrências simultâneas em qualquer instante.

## Complexidade

| | Valor |
|---|---|
| Time | O(n log n) — a ordenação dos dois arrays é o fator dominante |
| Space | O(n) — são criados dois arrays para armazenar os horários de início e término |

## Código

```java
// Entrada: array bidimensional de inteiros intervals representando os intervalos de tempo das reuniões (cada elemento é [start, end])
// Saída: retorna como int o número mínimo de salas de reunião necessárias para realizar todas as reuniões sem conflitos
public int minMeetingRooms(int[][] intervals) {
    // Se a entrada for null ou vazia, não existem reuniões, então retorna 0
    if (intervals == null || intervals.length == 0)
        return 0;

    int n = intervals.length;
    // Ao separar inícios e términos, cada um pode ser ordenado independentemente
    int[] starts = new int[n];  // array para armazenar os horários de início
    int[] ends = new int[n];    // array para armazenar os horários de término

    // Percorre intervals e armazena os horários de início e término em arrays separados
    for (int i = 0; i < n; i++) {
        starts[i] = intervals[i][0];
        ends[i] = intervals[i][1];
    }

    // Ordena ambos os arrays em ordem crescente, preparando para processar os eventos em ordem cronológica
    Arrays.sort(starts);
    Arrays.sort(ends);

    int rooms = 0, maxRooms = 0;
    // Ponteiro do array ends. Aponta para a reunião que termina mais cedo
    int endPtr = 0;

    // Percorre o array starts desde o início. Cada iteração representa o evento "uma nova reunião começa"
    for (int i = 0; i < n; i++) {
        if (starts[i] < ends[endPtr]) {
            // O horário de início da reunião atual é anterior ao horário de término da reunião que termina mais cedo → ocorre sobreposição, então atribui uma nova sala
            rooms++;
        } else {
            // A reunião que termina mais cedo já terminou, então sua sala pode ser reutilizada. Não incrementa o número de salas e avança endPtr para apontar para a próxima reunião que termina mais cedo
            endPtr++;
        }
        // Atualiza o número máximo de salas em uso simultâneo
        maxRooms = Math.max(maxRooms, rooms);
    }
    // maxRooms é o valor máximo de salas utilizadas simultaneamente, que é o número mínimo de salas de reunião necessárias
    return maxRooms;
}
```
