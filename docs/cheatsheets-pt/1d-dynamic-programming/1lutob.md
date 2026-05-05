# Determining if a String Can Be Segmented Into Dictionary Words — Determinar se uma string pode ser segmentada em palavras do dicionário

## Essência do problema

Uma string `s` e uma lista de palavras do dicionário `wordDict` são fornecidas. O objetivo é determinar se `s` pode ser segmentada como uma concatenação de palavras contidas no dicionário e retornar um **boolean**. Cada palavra do dicionário pode ser reutilizada quantas vezes forem necessárias.

## Ideia central

Se registrarmos "se é possível segmentar ou não" para cada substring desde o início da string até cada posição `i`, a determinação na posição `i` pode ser reduzida a verificar se "a segmentação até um ponto de divisão `j` é possível" e "a substring de `j` até `i` existe no dicionário".

## Processo de raciocínio

1. **O problema pode ser decomposto em subproblemas**: Para determinar se os primeiros `i` caracteres da string `s` são segmentáveis, basta dividir em uma posição `j` e verificar se "os primeiros `j` caracteres são segmentáveis" e "de `j` até `i` é uma palavra do dicionário". Essa estrutura é adequada para programação dinâmica
2. **Definir o DP**: Definimos `dp[i]` como um boolean que representa "se os primeiros `i` caracteres da string `s` podem ser segmentados apenas com palavras do dicionário". A resposta final será `dp[n]` (`n` é o comprimento da string)
3. **Estabelecer a condição base**: Uma string vazia sempre pode ser segmentada, portanto definimos `dp[0] = true`. Essa condição base permite detectar palavras do dicionário que começam no início da string
4. **Definir a relação de transição**: A condição para que `dp[i]` seja `true` é que, para algum `j` onde `0 ≤ j < i`, "`dp[j]` é `true`" e "`s.substring(j, i)` existe no dicionário". A determinação é feita testando todos os valores de `j`
5. **Acelerar a busca no dicionário**: Convertendo a lista de palavras em um HashSet, é possível verificar se uma substring está contida no dicionário em O(1) usando `contains`. Isso é mais eficiente do que uma busca linear na lista
6. **Eliminar trabalho desnecessário com término antecipado**: Uma vez que `dp[i] = true` é confirmado para algum `j`, não é necessário testar mais valores de `j`. Usamos `break` para sair do loop interno e avançar para o próximo `i`

## Conhecimentos prévios

### O que é um HashSet

É uma estrutura de dados que armazena elementos sem duplicatas. A verificação de existência de um elemento é feita em O(1). É utilizado para buscar rapidamente na lista de palavras do dicionário.

```java
Set<String> set = new HashSet<>();       // Criar um HashSet vazio
set.add("apple");                        // Adicionar um elemento
set.contains("apple");                   // Retorna boolean indicando se o elemento existe → true
```

### Conversão de List para Set usando o construtor

Ao passar uma List para o construtor do `HashSet`, todos os elementos da List são convertidos em um Set. Isso é usado para converter o dicionário em um HashSet em uma única linha.

```java
List<String> list = Arrays.asList("a", "b", "c");
Set<String> set = new HashSet<>(list);   // Converter todos os elementos da List em um Set
```

### O que é substring

É um método que extrai uma parte de uma string. `s.substring(j, i)` retorna os caracteres do índice `j` até `i - 1`. É usado na transição do DP para obter "a substring da posição `j` até a posição `i`".

```java
String s = "leetcode";
s.substring(0, 4);                       // Retorna "leet" (índices 0 a 3)
s.substring(4, 8);                       // Retorna "code" (índices 4 a 7)
```

### O que é um array de DP (array de boolean)

É um array que armazena os resultados dos subproblemas na programação dinâmica. Ao criá-lo com `boolean[] dp = new boolean[n + 1]`, todos os elementos são inicializados como `false`. Atribuir `true` a `dp[i]` registra o resultado de que "os primeiros `i` caracteres são segmentáveis".

```java
boolean[] dp = new boolean[5];           // Inicializado como [false, false, false, false, false]
dp[0] = true;                           // Definir a condição base
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n^2) — O loop externo executa n vezes, o loop interno executa no máximo n vezes, e se a geração de substring em cada passo custar O(n), a complexidade exata é O(n^3), mas na média é tratada como O(n^2) |
| Space | O(n) — Um array de DP de tamanho n+1 e um HashSet para armazenar as palavras do dicionário |

## Código

```java
// Entrada: string s e lista de palavras do dicionário wordDict
// Saída: retorna true se s puder ser segmentada apenas com palavras do dicionário, caso contrário retorna false
public boolean wordBreak(String s, List<String> wordDict) {
    // Converter a lista de palavras do dicionário em um HashSet para busca em O(1)
    Set<String> set = new HashSet<>(wordDict);
    // Armazenar o comprimento da string em uma variável
    int n = s.length();

    // dp[i] = se os primeiros i caracteres podem ser segmentados apenas com palavras do dicionário
    // O tamanho é n+1 porque dp[n] representa a possibilidade de segmentação da string inteira
    boolean[] dp = new boolean[n + 1];

    // Uma string vazia sempre pode ser segmentada (condição base)
    // Sem essa definição, não é possível detectar palavras do dicionário que começam no início da string
    dp[0] = true;

    // Loop externo: i representa "quantos caracteres desde o início estamos considerando"
    for (int i = 1; i <= n; i++) {
        // Loop interno: j é o candidato a ponto de divisão. Posição que divide em "primeiros j caracteres" e "substring de j até i"
        for (int j = 0; j < i; j++) {
            // Se os primeiros j caracteres são segmentáveis E de j até i é uma palavra do dicionário, então os primeiros i caracteres são segmentáveis
            // Ambas as condições sendo verdadeiras simultaneamente = é possível dividir em "parte segmentável + palavra do dicionário"
            if (dp[j] && set.contains(s.substring(j, i))) {
                dp[i] = true;
                break;  // Já foi confirmado como segmentável, não é necessário testar outros valores de j
            }
        }
    }

    // dp[n] representa se a string s inteira é segmentável
    return dp[n];
}
```
