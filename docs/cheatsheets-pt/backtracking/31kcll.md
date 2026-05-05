# Mapping Phone Number Digits to Letter Combinations — Gerar todas as combinações de letras a partir dos dígitos de um número de telefone

## Essência do problema

Uma string `digits` composta por dígitos de 2 a 9 é fornecida. Cada dígito é mapeado para as letras correspondentes no teclado telefônico (exemplo: 2→"abc", 3→"def"). O objetivo é retornar uma lista com **todas as combinações possíveis de letras** formadas ao selecionar uma letra de cada dígito em `digits`.

## Ideia central

Cada posição de dígito possui 3 a 4 letras disponíveis, e é necessário enumerar todas as combinações. Selecionamos uma letra por vez e a adicionamos ao final; quando todas as posições forem preenchidas, registramos o resultado; então desfazemos a última escolha e tentamos outra letra — esse processo de "backtracking" permite explorar todos os padrões sem omissões.

## Processo de raciocínio

1. **Cada posição de dígito possui opções de escolha**: Cada dígito corresponde a 3 ou 4 letras, e selecionamos uma letra em cada posição. A combinação de escolhas em todas as posições forma a resposta, portanto é necessário enumerar todos os padrões sistematicamente
2. **Processamos um dígito por vez com recursão**: Selecionamos uma letra a partir do primeiro dígito e delegamos o processamento do próximo dígito à chamada recursiva. Dessa forma, cada nível de profundidade da recursão corresponde a uma posição de dígito, mantendo a estrutura simples
3. **A condição de término é quando todos os dígitos foram processados**: Quando a profundidade da recursão atinge o comprimento de `digits`, a string em construção representa uma combinação completa. Adicionamos essa string à lista de resultados
4. **O backtracking permite tentar outras opções**: Ao retornar da recursão, removemos a última letra adicionada ao final do `StringBuilder`. Isso prepara o estado para tentar outra letra na mesma posição
5. **Usamos um array de mapeamento para converter dígitos em letras**: Preparamos um array de strings com índices de 0 a 9, e convertemos o caractere do dígito em inteiro com `digits.charAt(idx) - '0'` para acessar o índice correspondente, obtendo o grupo de letras em O(1)
6. **Tratamos a entrada de string vazia**: Se `digits` estiver vazio, não existem combinações possíveis, então retornamos a lista vazia diretamente

## Conhecimento prévio

### O que é backtracking

É uma técnica de busca que constrói candidatos a solução um por um, registra quando completos, desfaz a última escolha e tenta outra opção. É utilizada em problemas que exigem enumerar todas as combinações e permutações. O ciclo "escolher → avançar → desfazer → tentar outro" é implementado com recursão.

```java
// Padrão básico de backtracking
void backtrack(estado, listaDeResultados) {
    if (condiçãoDeTermino) {
        listaDeResultados.add(estadoAtual);
        return;
    }
    for (opção : listaDeOpçõesAtuais) {
        adicionarOpçãoAoEstado;       // Escolher
        backtrack(próximoEstado, listaDeResultados); // Avançar
        removerOpçãoDoEstado;     // Desfazer (backtrack)
    }
}
```

### O que é StringBuilder

É uma classe para construir strings de forma eficiente. `String` é imutável (um novo objeto é criado a cada modificação), mas `StringBuilder` modifica diretamente o buffer interno, permitindo adição e remoção de caracteres em O(1). É adequado para construir strings durante o backtracking.

```java
StringBuilder sb = new StringBuilder();  // Cria um StringBuilder vazio
sb.append('a');           // Adiciona o caractere 'a' ao final → "a"
sb.append('b');           // Adiciona o caractere 'b' ao final → "ab"
sb.deleteCharAt(sb.length() - 1);  // Remove o último caractere → "a"
sb.toString();            // Converte para tipo String e retorna → "a"
```

### Mapeamento do teclado telefônico

A correspondência entre dígitos e letras é representada por um array. O índice do array corresponde ao dígito, e o valor são as letras atribuídas a esse dígito.

```java
String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};
// phone[2] → "abc",  phone[7] → "pqrs",  phone[9] → "wxyz"
// Conversão do caractere '3' para o inteiro 3: '3' - '0' → 3
```

## Complexidade

| | Valor |
|---|---|
| Tempo | O(4^n) — Cada dígito possui no máximo 4 letras como opção, e todas as combinações para n dígitos são enumeradas |
| Espaço | O(n) — A profundidade máxima da recursão é n, e o comprimento do StringBuilder também é no máximo n (excluindo a lista de resultados) |

## Código

```java
// Entrada: string digits composta por dígitos de 2 a 9
// Saída: retorna uma List<String> contendo todas as combinações de letras

// Seleciona uma letra por dígito com backtracking e enumera todas as combinações
void backtrack(String digits, String[] phone, int idx, StringBuilder path, List<String> result) {
    // Condição de término: se idx é igual ao comprimento de digits, todas as letras foram selecionadas
    // Converte o conteúdo do StringBuilder para String e adiciona ao resultado
    if (idx == digits.length()) {
        result.add(path.toString());
        return;
    }

    // Converte o caractere do dígito em inteiro com digits.charAt(idx) - '0' e obtém o grupo de letras correspondente do array phone
    String letters = phone[digits.charAt(idx) - '0'];

    // Tenta cada letra correspondente ao dígito atual, uma por vez
    for (char c : letters.toCharArray()) {
        path.append(c);                            // Escolha: seleciona a letra e adiciona ao final
        backtrack(digits, phone, idx + 1, path, result);  // Recursão: avança para o processamento do próximo dígito
        path.deleteCharAt(path.length() - 1);      // Restauração: remove a última letra e retorna ao estado anterior (backtrack)
    }
}

List<String> letterCombinations(String digits) {
    // Cria uma lista vazia para armazenar os resultados
    List<String> result = new ArrayList<>();

    // Se a string estiver vazia, não existem combinações, então retorna a lista vazia
    if (digits.isEmpty()) return result;

    // Define o array de mapeamento onde o índice corresponde ao dígito
    // Os índices 0 e 1 recebem string vazia porque não possuem letras atribuídas no teclado telefônico
    String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    // Inicia o backtracking a partir da posição 0 com um StringBuilder vazio
    backtrack(digits, phone, 0, new StringBuilder(), result);

    // Retorna result contendo todas as combinações após a conclusão de todas as recursões
    return result;
}
```
