# Finding the Kth Largest Element in an Array — Encontrar o K-ésimo maior elemento em um array não ordenado

## Essência do problema

Recebe-se um array de inteiros `nums` e um inteiro `k`. O objetivo é retornar o valor do elemento que ocupa a k-ésima posição quando o array é ordenado em ordem decrescente. Valores duplicados são contados independentemente (não se trata do k-ésimo maior valor "distinto").

## Ideia central

Mesmo sem ordenar o array inteiro, ao dividi-lo usando um pivô como referência, é possível saber imediatamente "qual é a posição do pivô em ordem de grandeza". Ao restringir o intervalo de busca a apenas um dos lados até que a posição do pivô seja `k-1`, é possível alcançar o elemento desejado em O(n) na média.

## Processo de raciocínio

1. **O k-ésimo maior elemento é determinado pelo índice após a ordenação**: Se o array for ordenado em ordem decrescente, o elemento no índice `k-1` é a resposta. Porém, uma ordenação completa custa O(n log n), então buscamos um método mais eficiente
2. **Só precisamos da posição k-ésima**: Não é necessário ordenar tudo; basta descobrir "qual é o k-ésimo maior elemento". Ao usar um pivô para dividir o array em "grupo maior que o pivô" e "grupo menor ou igual ao pivô", a posição (índice) do pivô indica sua classificação em ordem de grandeza
3. **Restringir o intervalo de busca pela posição do pivô**: Suponha que, após o partition, o pivô ficou no índice `p`. Se `p == k-1`, a resposta foi encontrada. Se `p < k-1`, o elemento desejado está à direita do pivô (lado dos menores), então o intervalo de busca é restringido a partir de `p+1`. Se `p > k-1`, o intervalo é restringido ao lado esquerdo
4. **Fazer partition em ordem decrescente**: O partition padrão do QuickSort é em ordem crescente, mas para encontrar "o k-ésimo maior", fazemos o partition em ordem decrescente. Ou seja, os elementos maiores que o pivô são agrupados à esquerda. Dessa forma, o índice `k-1` corresponde à posição da resposta
5. **Processar repetidamente apenas um lado com um loop**: O QuickSort processa ambos os lados recursivamente, mas o Quickselect precisa processar apenas o lado que contém a resposta. Com um loop while enquanto `l <= r`, o partition é repetido e, quando `p == k-1`, o elemento é retornado

## Conhecimentos prévios

### O que é Quickselect

É um algoritmo que utiliza a mesma operação de partition do QuickSort para encontrar o k-ésimo menor (ou maior) elemento de um array em O(n) na média. Enquanto o QuickSort processa ambos os lados recursivamente, o Quickselect processa apenas um lado, resultando em uma complexidade média de O(n).

### O que é partition (divisão)

É a operação de selecionar um pivô do array e mover os elementos maiores que o pivô para o lado esquerdo e os elementos menores ou iguais para o lado direito. Após a operação, o pivô é colocado em sua posição correta final. Essa posição (índice) representa a "classificação" do pivô.

```java
// Partition decrescente: agrupa os elementos maiores que o pivô à esquerda
// Valor de retorno: índice onde o pivô foi colocado
int pivot = nums[r];       // Seleciona o elemento da extremidade direita como pivô
int store = l;             // Ponteiro que indica a próxima posição de swap
// Se nums[i] > pivot, faz swap de nums[i] para a posição store e avança store
// Por fim, coloca o pivô na posição store → store é a posição final do pivô
```

### O que é swap (troca de elementos)

É a operação de trocar as posições de dois elementos em um array. Utiliza-se uma variável temporária `temp` para salvar o valor e evitar a sobrescrita.

```java
int temp = nums[i];    // Salva o valor de nums[i] em uma variável temporária
nums[i] = nums[store]; // Sobrescreve nums[i] com o valor de nums[store]
nums[store] = temp;    // Escreve o valor original de nums[i], salvo anteriormente, em nums[store]
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) na média — como o intervalo de busca é reduzido pela metade a cada iteração, n + n/2 + n/4 + ... ≈ 2n = O(n) |
| Space | O(1) — o array é manipulado in-place, sem uso de estruturas de dados adicionais |

## Código

```java
// Entrada: array de inteiros nums e inteiro k
// Saída: retorna como int o valor do k-ésimo maior elemento do array

// Partition decrescente: agrupa os elementos maiores que o pivô à esquerda e retorna a posição final do pivô
private int partition(int[] nums, int l, int r) {
    // Seleciona o elemento da extremidade direita do intervalo de busca como pivô
    int pivot = nums[r];
    // store indica "a próxima posição onde um elemento maior que o pivô deve ser colocado"
    int store = l;

    // Percorre de l até r-1 e agrupa os elementos maiores que o pivô à esquerda
    for (int i = l; i < r; i++) {
        // Se o elemento atual é maior que o pivô, faz swap para a posição store e agrupa à esquerda
        if (nums[i] > pivot) {
            int temp = nums[i];
            nums[i] = nums[store];
            nums[store] = temp;
            // Avança store em 1 para atualizar a próxima posição de swap
            store++;
        }
    }

    // Coloca o pivô na posição store (posição correta final do pivô)
    // Neste ponto, à esquerda de store estão os elementos maiores que o pivô, e à direita estão os menores ou iguais
    int temp = nums[store];
    nums[store] = nums[r];
    nums[r] = temp;
    // store é a posição final do pivô e representa sua "classificação" em ordem decrescente
    return store;
}

public int findKthLargest(int[] nums, int k) {
    // Inicializa as extremidades esquerda e direita do intervalo de busca. Inicialmente, o array inteiro é o intervalo
    int l = 0, r = nums.length - 1;

    // A cada iteração do loop, o intervalo de busca é reduzido
    while (l <= r) {
        // Executa o partition no intervalo de busca atual [l, r] e obtém a posição do pivô
        int p = partition(nums, l, r);

        if (p == k - 1) {
            // O pivô está na posição do k-ésimo maior. Em ordem decrescente, o índice k-1 corresponde à posição do k-ésimo maior elemento
            return nums[p];
        } else if (p < k - 1) {
            // O k-ésimo maior elemento está à direita do pivô (lado dos menores)
            l = p + 1;
        } else {
            // O k-ésimo maior elemento está à esquerda do pivô (lado dos maiores)
            r = p - 1;
        }
    }
    // Pelas restrições do problema, um k válido é sempre fornecido, portanto este ponto nunca é alcançado
    return -1;
}
```
