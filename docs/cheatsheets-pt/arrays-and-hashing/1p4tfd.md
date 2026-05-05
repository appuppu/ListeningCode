# Finding Duplicates in an Array — Determinar se existem valores duplicados em um array

## Essência do Problema

É dado um array de inteiros `nums`. Retornar `true` se algum valor aparecer duas ou mais vezes no array, ou `false` se todos os elementos forem distintos.

## Ideia Central

Ao percorrer o array e registrar os elementos já vistos em um HashSet, é possível verificar em O(1) se cada elemento já apareceu anteriormente. Assim que uma duplicata for encontrada, retorna-se imediatamente `true`.

## Processo de Raciocínio

1. **Detectar duplicatas = verificar "se o mesmo valor já foi visto antes"**: Ao percorrer o array desde o início, se o elemento atual já tiver aparecido anteriormente, ele é uma duplicata. Ou seja, se for possível gerenciar um conjunto dos elementos já vistos, é possível detectar duplicatas
2. **Busca rápida entre os elementos já vistos**: Para verificar em O(1) se "este valor já foi visto", o HashSet é a estrutura de dados adequada. O HashSet realiza verificações de existência em O(1)
3. **O que armazenar no HashSet**: Como o problema exige apenas um valor booleano e não índices, basta armazenar os próprios valores no HashSet
4. **Construir o HashSet durante a travessia**: Percorrer o array desde o início e, para cada elemento, verificar "se já está contido no HashSet". Se estiver, uma duplicata foi encontrada; caso contrário, adicionar o elemento atual ao HashSet e prosseguir
5. **Otimizar com retorno antecipado**: Retornar `true` imediatamente ao encontrar uma duplicata. Se o array inteiro for percorrido sem encontrar duplicatas, retornar `false`

## Conhecimentos Prévios

### O que é um HashSet

É uma estrutura de dados que gerencia um conjunto de elementos sem duplicatas. A adição de elementos e a verificação de existência são realizadas em O(1). Diferentemente do HashMap, armazena apenas valores, e não pares de chave e valor. Possui a propriedade de eliminar duplicatas automaticamente.

```java
HashSet<Integer> set = new HashSet<>();  // Criar um HashSet vazio
set.add(10);              // Adicionar o elemento 10
set.contains(10);         // Verificar se o elemento 10 existe, retornando boolean → true
set.contains(5);          // Verificar se o elemento 5 existe, retornando boolean → false
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer o array uma única vez |
| Space | O(n) — O HashSet armazena no máximo n elementos |

## Código

```java
// Entrada: array de inteiros nums
// Saída: true se existir valor duplicado, false se todos forem distintos
public boolean containsDuplicate(int[] nums) {
    // HashSet para registrar os elementos já percorridos
    // Como o problema exige apenas um valor booleano, basta armazenar os valores
    HashSet<Integer> seen = new HashSet<>();

    for (int num : nums) {
        // Se o elemento atual já existir no HashSet, o mesmo valor apareceu duas vezes, confirmando a duplicata
        if (seen.contains(num)) {
            return true;  // Retornar imediatamente ao encontrar uma duplicata (retorno antecipado)
        }

        // Adicionar o elemento atual ao HashSet e prosseguir
        // Este elemento será referenciado como "elemento já visto" nas travessias seguintes
        seen.add(num);
    }
    // Se o loop terminar sem encontrar duplicatas, confirma-se que todos os elementos são distintos
    return false;
}
```
