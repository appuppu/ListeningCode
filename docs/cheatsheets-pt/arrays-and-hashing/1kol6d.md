# Two Sum — Encontrar o par de dois números cuja soma é igual ao alvo

## Essência do problema

É dado um array de inteiros `nums` e um inteiro `target`. Encontre dois elementos em `nums` cuja soma seja igual a `target` e retorne os **índices** desses elementos em um array. Existe exatamente uma solução, e o mesmo elemento não pode ser usado duas vezes.

## Ideia central

Ao percorrer o array, para cada elemento `nums[i]`, o "par complementar (target - nums[i])" é determinado de forma única. Se os elementos já visitados forem registrados em um HashMap, é possível verificar a existência do par em O(1) e encontrar a resposta em uma única passagem pelo array.

## Processo de raciocínio

1. **O par complementar pode ser calculado**: Como o objetivo é encontrar um par cuja soma seja `target`, para o elemento atual `nums[i]`, o outro valor é determinado de forma única por `complement = target - nums[i]`
2. **Queremos verificar rapidamente se o par já apareceu antes**: Ao percorrer o array, se os números já visitados forem registrados, é possível verificar em O(1) se o complement já foi registrado. O HashMap é adequado para esse registro
3. **O que armazenar no HashMap**: Como o problema exige retornar índices, a chave do HashMap armazena o "valor numérico" e o valor armazena o "índice desse número". Dessa forma, a verificação da existência do par e a obtenção do índice são feitas simultaneamente
4. **Construir o HashMap durante a varredura**: O array é percorrido do início ao fim e, para cada elemento, verifica-se "se o complement existe no HashMap". Se existir, o par foi encontrado; caso contrário, o elemento atual é registrado no HashMap e a varredura prossegue
5. **O registro é feito após a verificação**: Se o registro no HashMap for feito antes da verificação, `nums[i]` pode corresponder a si mesmo como complement. Por isso, a ordem verificação → registro deve ser respeitada
6. **O que retornar ao final**: Quando o complement é encontrado no HashMap, retorna-se `map.get(complement)` (índice do par) e `i` (índice atual) em um `int[]`

## Conhecimento prévio

### O que é um HashMap

É uma estrutura de dados que armazena pares de chave e valor. A busca e a obtenção de valores por chave são feitas em O(1). Funciona como um dicionário que permite acesso por qualquer chave com a mesma velocidade do acesso por índice em um array.

```java
HashMap<Integer, Integer> map = new HashMap<>();  // Cria um HashMap vazio
map.put(10, 0);           // Armazena o valor 0 com a chave 10
map.containsKey(10);      // Retorna boolean indicando se a chave 10 existe → true
map.get(10);              // Retorna o valor correspondente à chave 10 → 0
```

### O que é complement (complemento)

É o valor obtido subtraindo o elemento atual de `target`. Representa o número que forma o par. É calculado por `complement = target - nums[i]`.
Exemplo: quando target=9 e nums[i]=2, complement=7. Se 7 existir no array, o par está formado.

## Complexidade

| | Valor |
|---|---|
| Time | O(n) — Basta percorrer o array uma única vez |
| Space | O(n) — O HashMap armazena no máximo n elementos |

## Código

```java
// Entrada: array de inteiros nums e inteiro target
// Saída: retorna os índices dos 2 elementos cuja soma é target em um int[]
public int[] twoSum(int[] nums, int target) {
    // HashMap que armazena chave=valor numérico, valor=índice desse número
    // Como o problema pede índices e não valores, o índice é armazenado como valor
    HashMap<Integer, Integer> map = new HashMap<>();

    for (int i = 0; i < nums.length; i++) {
        // Calcula o par complementar e armazena em uma variável para reutilizar em containsKey e get
        int complement = target - nums[i];

        // Se o complement já estiver registrado no HashMap, o par foi encontrado
        if (map.containsKey(complement)) {
            // map.get(complement) é o índice do par, i é o índice atual
            return new int[]{map.get(complement), i};
        }

        // Atenção: o registro é feito após a verificação. Se registrar antes, nums[i] pode corresponder a si mesmo
        map.put(nums[i], i);
    }
    // Pela restrição do problema, uma solução sempre existe, então este ponto nunca é alcançado
    return new int[]{};
}
```
