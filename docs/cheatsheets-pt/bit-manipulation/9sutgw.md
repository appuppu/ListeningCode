# Reversing the Bits of an Integer — Inverter os bits de um inteiro sem sinal de 32 bits

## Essência do problema

Um inteiro sem sinal de 32 bits é fornecido. O objetivo é retornar o inteiro com a sequência de bits invertida (em ordem reversa). Por exemplo, a entrada `00000000000000000000000000001011` se torna `11010000000000000000000000000000`.

## Ideia central

O algoritmo desloca o resultado 1 bit para a esquerda enquanto extrai o bit menos significativo da entrada um a um e o adiciona ao resultado. Repetindo isso 32 vezes, a sequência de bits da entrada é acumulada no resultado em ordem reversa.

## Processo de raciocínio

1. **A inversão de bits é a operação de "extrair do final e empilhar no início"**: O algoritmo extrai o bit menos significativo (extremidade direita) da entrada, adiciona-o ao bit menos significativo (extremidade direita) do resultado e então desloca o resultado para a esquerda, de modo que o primeiro bit extraído acaba se movendo para a posição mais significativa. Isso constitui a construção reversa da sequência de bits
2. **Como extrair o bit menos significativo**: Calculando `n & 1`, é possível obter apenas o bit menos significativo de `n`. O mecanismo utiliza a operação AND para mascarar todos os bits exceto o menos significativo, tornando-os 0
3. **Como adicionar o bit extraído ao resultado**: Usando a operação OR com `result |= (n & 1)`, é possível definir o bit extraído no bit menos significativo do result. Como o bit menos significativo do result se tornou 0 pelo deslocamento à esquerda anterior, a operação OR o define corretamente
4. **Como avançar para o próximo bit**: Deslocando a entrada `n` 1 bit para a direita com `n >>>= 1`, o próximo bit passa a ocupar a posição menos significativa. O operador `>>>` é um deslocamento à direita sem sinal que sempre preenche a posição mais significativa com 0
5. **Como criar espaço no resultado**: Deslocando o resultado 1 bit para a esquerda com `result <<= 1` antes de adicionar um novo bit, o bit menos significativo se torna 0, criando espaço para receber o novo bit
6. **Repetir 32 vezes completa o processo**: Como o inteiro tem 32 bits, repetir a sequência "deslocar à esquerda → adicionar bit → deslocar à direita" 32 vezes armazena todos os bits da entrada em ordem reversa no resultado

## Conhecimentos prévios

### O que é a operação AND bit a bit (&)

Uma operação que compara cada bit de dois inteiros e retorna 1 apenas nos bits em que ambos são 1. É utilizada como "máscara" para extrair bits específicos.

```java
int n = 0b1011;       // 1011 em binário (11 em decimal)
int bit = n & 1;      // Obtém apenas o bit menos significativo → 1
int bit2 = 0b1010 & 1; // Caso em que o bit menos significativo é 0 → 0
```

### O que é a operação OR bit a bit (|=)

Uma operação que compara cada bit de dois inteiros e retorna 1 no bit se qualquer um dos dois for 1. É utilizada para definir (tornar 1) bits específicos.

```java
int result = 0b0000;
result |= 1;          // Define o bit menos significativo como 1 → 0b0001
result |= 0;          // OR com 0 não causa alteração → 0b0001
```

### O que é a operação de deslocamento à esquerda (<<=)

Uma operação que desloca a sequência de bits para a esquerda pelo número especificado de posições. A extremidade direita é preenchida com 0. Um deslocamento de 1 bit à esquerda tem o efeito de dobrar o valor.

```java
int result = 0b0011;   // 11 em binário (3 em decimal)
result <<= 1;          // Desloca 1 bit para a esquerda → 0b0110 (6 em decimal)
```

### O que é a operação de deslocamento à direita sem sinal (>>>=)

Uma operação que desloca a sequência de bits para a direita pelo número especificado de posições. A extremidade esquerda é sempre preenchida com 0. Diferentemente de `>>`, preenche com 0 independentemente do bit de sinal, sendo adequada para a manipulação de inteiros sem sinal.

```java
int n = 0b1011;        // 1011 em binário
n >>>= 1;              // Desloca 1 bit para a direita → 0b0101 (o 1 menos significativo desaparece e o próximo bit ocupa a extremidade direita)
```

## Complexidade

| | Valor |
|---|---|
| Time | O(1) — O loop é sempre fixo em 32 iterações e não depende do valor da entrada |
| Space | O(1) — Utiliza apenas a variável adicional `result` e não depende do tamanho da entrada |

## Código

```java
// Entrada: inteiro sem sinal de 32 bits n
// Saída: retorna como int o inteiro com a sequência de bits invertida
public int reverseBits(int n) {
    // Variável para armazenar a sequência de bits invertida. O valor inicial 0 significa que todos os bits estão em estado 0
    int result = 0;

    // Itera 32 vezes para processar todos os bits do inteiro de 32 bits
    for (int i = 0; i < 32; i++) {
        // Desloca result 1 bit para a esquerda, tornando o bit menos significativo 0 e criando espaço para receber o novo bit
        // Nota: o deslocamento à esquerda é feito antes da adição do bit. Se feito depois, ocorreria um deslocamento extra após a última adição de bit, dobrando o resultado
        result <<= 1;
        // Extrai o bit menos significativo de n com n & 1 e o define no bit menos significativo do result usando a operação OR
        // Como o bit menos significativo se tornou 0 pelo deslocamento à esquerda anterior, a operação OR o define corretamente
        result |= (n & 1);
        // Desloca n para a direita sem sinal para mover o próximo bit para a posição menos significativa
        // O operador >>> é usado porque é necessário preencher com 0 independentemente do bit de sinal
        n >>>= 1;
    }
    // Após completar as 32 iterações do loop, o bit 0 da entrada está no bit 31 do result, o bit 1 no bit 30, e todos os bits estão armazenados em ordem reversa
    return result;
}
```
