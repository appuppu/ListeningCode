# Evaluating an Expression in Reverse Polish Notation — Avaliar uma expressão aritmética em Notação Polonesa Reversa

## Essência do problema

Um array de strings `tokens` é fornecido como uma expressão aritmética em Notação Polonesa Reversa (RPN). O objetivo é avaliar essa expressão e retornar o resultado como um inteiro. Os operadores válidos são os 4 seguintes: `+`, `-`, `*`, `/`, e cada operando é um inteiro ou outra subexpressão. A divisão é truncada em direção a zero. Exemplo: `["2","1","+","3","*"]` → `((2+1)*3)` → `9`.

## Ideia central

Na Notação Polonesa Reversa, não é necessário lidar com precedência de operadores nem com parênteses. Basta percorrer os tokens da esquerda para a direita, empilhando valores numéricos em uma pilha, e quando um operador aparece, retirar os dois valores do topo, calcular o resultado e devolvê-lo à pilha, avaliando corretamente toda a expressão.

## Processo de raciocínio

1. **Compreender as propriedades da RPN**: Na Notação Polonesa Reversa, um operador age sobre os dois operandos imediatamente anteriores. Ou seja, no momento em que um operador aparece, os dois operandos alvo já estão determinados. Essa propriedade torna adequada a pilha, uma estrutura de dados LIFO que remove primeiro o último elemento adicionado
2. **Ramificar o processamento conforme o token seja número ou operador**: Examina-se cada token em ordem; se for um número, empilha-se; se for um operador, realiza-se o cálculo. Apenas essas duas operações são suficientes para avaliar toda a expressão
3. **Atentar para a ordem dos operandos ao processar operadores**: O primeiro valor retirado com pop da pilha é o operando direito (`a`), e o segundo valor retirado é o operando esquerdo (`b`). O cálculo é feito na ordem `b operador a`. Se essa ordem for invertida, subtração e divisão produzirão resultados incorretos
4. **Devolver o resultado do cálculo à pilha**: Ao fazer push do resultado da operação na pilha, esse resultado passa a ser utilizado como operando para operações subsequentes. Isso permite que subexpressões aninhadas sejam processadas naturalmente
5. **O resultado final é o único elemento restante na pilha**: Se a expressão RPN for válida, após o processamento de todos os tokens, restará apenas um resultado na pilha. Esse valor é retirado com pop e retornado

## Conhecimentos prévios

### O que é uma Stack

Uma estrutura de dados do tipo último a entrar, primeiro a sair (LIFO). O último elemento adicionado é o primeiro a ser removido. Tanto a adição (push) quanto a remoção (pop) de elementos são realizadas em O(1).

```java
Stack<Integer> stack = new Stack<>();  // Cria uma pilha vazia
stack.push(5);     // Empilha 5 no topo da pilha → [5]
stack.push(3);     // Empilha 3 no topo da pilha → [5, 3]
stack.pop();       // Remove e retorna o elemento do topo → 3, pilha fica [5]
stack.pop();       // Remove e retorna o elemento do topo → 5, pilha fica []
```

### O que é Notação Polonesa Reversa (RPN)

Uma notação que coloca o operador após os operandos. A notação infixa usual `(2 + 1) * 3` é escrita em RPN como `2 1 + 3 *`. Não são necessários parênteses, e a expressão pode ser avaliada corretamente apenas processando da esquerda para a direita.

```
Notação infixa:  (2 + 1) * 3
RPN:             2 1 + 3 *
Processo de avaliação:  2 1 + → 3, depois 3 3 * → 9
```

### O que é Integer.parseInt

Um método estático do Java que converte uma string em um inteiro. Strings que representam números negativos (exemplo: `"-3"`) também são convertidas corretamente.

```java
Integer.parseInt("42");    // → 42
Integer.parseInt("-3");    // → -3
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer os tokens do array uma única vez |
| Space | O(n) — A pilha armazena no máximo n elementos |

## Código

```java
// Entrada: array de strings tokens representando uma expressão aritmética em Notação Polonesa Reversa
// Saída: retorna o resultado da avaliação da expressão como um inteiro
public int evalRPN(String[] tokens) {
    // Pilha para armazenar temporariamente operandos numéricos e resultados intermediários
    Stack<Integer> stack = new Stack<>();

    // Percorre o array tokens do início ao fim, um a um
    for (String token : tokens) {
        // Verifica se o token atual é um operador (+, -, *, / — qualquer um deles)
        switch (token) {
            case "+": {
                int a = stack.pop();  // Primeiro pop → operando direito
                int b = stack.pop();  // Segundo pop → operando esquerdo
                // Ao fazer push do resultado, ele será usado como operando para operações subsequentes
                stack.push(b + a);
                break;
            }
            case "-": {
                int a = stack.pop();
                int b = stack.pop();
                // Atenção: como a ordem do pop é invertida, deve-se sempre calcular b - a. Usar a - b inverteria o resultado
                stack.push(b - a);
                break;
            }
            case "*": {
                int a = stack.pop();
                int b = stack.pop();
                stack.push(b * a);
                break;
            }
            case "/": {
                int a = stack.pop();
                int b = stack.pop();
                // A divisão inteira em Java trunca automaticamente em direção a zero, não sendo necessário tratamento especial
                // Atenção: como a ordem do pop é invertida, deve-se sempre calcular b / a. Usar a / b inverteria o resultado
                stack.push(b / a);
                break;
            }
            default: {
                // Converte o token numérico em inteiro e o empilha
                // Números negativos (exemplo: "-3") também são processados corretamente pelo parseInt
                stack.push(Integer.parseInt(token));
            }
        }
    }

    // Se a expressão RPN for válida, após o processamento de todos os tokens, restará apenas um resultado na pilha
    return stack.pop();
}
```
