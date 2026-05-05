# Finding the Kth Largest Element in an Array — Encontrar o K-ésimo maior elemento em um array não ordenado

## Essência do problema

Um array de inteiros `nums` e um inteiro `k` são fornecidos. O objetivo é retornar o valor do elemento que ocupa a K-ésima posição em ordem decrescente quando o array é ordenado. Valores duplicados são contados independentemente (não se trata do K-ésimo maior valor "distinto").

## Ideia central

Mesmo sem ordenar o array inteiro, ao dividi-lo com base em um pivô, é possível saber imediatamente "qual é a posição do pivô em ordem decrescente". Ao restringir o intervalo de busca a apenas um dos lados até que a posição do pivô se torne `k-1`, é possível alcançar o elemento desejado em O(n) na média.

## Processo de raciocínio

1. **O K-ésimo maior elemento é determinado pelo índice após a ordenação**: Se o array for ordenado em ordem decrescente, o elemento no índice `k-1` é a resposta. Porém, uma ordenação completa custa O(n log n), então buscamos um método mais eficiente
2. **Apenas a posição K é necessária**: A ordem total não é necessária; basta saber "qual é o K-ésimo maior elemento". Ao usar um pivô para dividir o array em "grupo maior que o pivô" e "grupo menor ou igual ao pivô", a posição (índice) do pivô revela sua classificação em ordem decrescente
3. **Restringir o intervalo de busca com base na posição do pivô**: Suponha que, após o partition, o pivô foi colocado no índice `p`. Se `p == k-1`, a resposta foi encontrada. Se `p < k-1`, o elemento desejado está à direita do pivô (lado dos menores), então o intervalo de busca é restringido a partir de `p+1`. Se `p > k-1`, o intervalo é restringido ao lado esquerdo
4. **Realizar o partition em ordem decrescente**: O partition padrão do QuickSort é em ordem crescente, mas para encontrar "o K-ésimo maior", realizamos o partition em ordem decrescente. Ou seja, os elementos maiores que o pivô são agrupados à esquerda. Assim, o índice `k-1` corresponde à posição da resposta
5. **Processar repetidamente apenas um dos lados com um loop**: O QuickSort processa ambos os lados recursivamente, mas o Quickselect precisa processar apenas o lado que contém a resposta. Com um loop while enquanto `l <= r`, o partition é repetido e, quando `p == k-1`, o elemento é retornado

## Conhecimentos prévios

### O que é Quickselect

É um algoritmo que utiliza a mesma operação de partition do QuickSort para encontrar o K-ésimo menor (ou maior) elemento de um array em O(n) na média. Enquanto o QuickSort processa ambos os lados recursivamente, o Quickselect processa apenas um dos lados, resultando em uma complexidade média de O(n).

### O que é partition (divisão)

É a operação de escolher um pivô no array e mover os elementos maiores que o pivô para a esquerda e os elementos menores ou iguais ao pivô para a direita. Após a operação, o pivô é colocado em sua posição correta final. Essa posição (índice) representa a "classificação" do pivô.

```java
// Partition em ordem decrescente: agrupa elementos maiores que o pivô à esquerda
// Valor de retorno: índice onde o pivô foi colocado
int pivot = nums[r];       // Seleciona o elemento mais à direita como pivô
int store = l;             // Ponteiro que indica a próxima posição para swap
// Se nums[i] > pivot, faz swap de nums[i] para a posição store e avança store
// No final, coloca o pivot na posição store → store é a posição final do pivô
```

### O que é swap (troca de elementos)

É a operação de trocar as posições de dois elementos em um array. Utiliza uma variável temporária `temp` para salvar o valor e evitar sobrescrita.

```java
int temp = nums[i];    // Salva o valor de nums[i] em uma variável temporária
nums[i] = nums[store]; // Sobrescreve nums[i] com o valor de nums[store]
nums[store] = temp;    // Escreve o valor original de nums[i] salvo anteriormente em nums[store]
```

## Complexidade

| | Valor |
|---|---|
| Time | O(n) na média — como o intervalo de busca é reduzido pela metade a cada iteração, n + n/2 + n/4 + ... ≈ 2n = O(n) |
| Space | O(1) — o array é manipulado in-place, sem uso de estruturas de dados adicionais |

## Código

```java
// Entrada: array de inteiros nums e inteiro k
// Saída: retorna como int o valor do K-ésimo maior elemento do array

// Partition em ordem decrescente: agrupa elementos maiores que o pivô à esquerda e retorna a posição final do pivô
private int partition(int[] nums, int l, int r) {
    // Seleciona o elemento mais à direita do intervalo de busca como pivô
    int pivot = nums[r];
    // store aponta para "a próxima posição onde um elemento maior que o pivô deve ser colocado"
    int store = l;

    // Percorre de l até r-1, agrupando elementos maiores que o pivô à esquerda
    for (int i = l; i < r; i++) {
        // Se o elemento atual é maior que o pivô, faz swap para a posição store para agrupá-lo à esquerda
        if (nums[i] > pivot) {
            int temp = nums[i];
            nums[i] = nums[store];
            nums[store] = temp;
            // Avança store para atualizar a próxima posição de colocação de elementos maiores
            store++;
        }
    }

    // Coloca o pivô na posição store (posição correta final do pivô)
    // Neste ponto, à esquerda de store estão elementos maiores que o pivô, e à direita estão elementos menores ou iguais
    int temp = nums[store];
    nums[store] = nums[r];
    nums[r] = temp;
    // store é a posição final do pivô = representa a "classificação em ordem decrescente" do pivô
    return store;
}

public int findKthLargest(int[] nums, int k) {
    // Inicializa o intervalo de busca como o array inteiro
    int l = 0, r = nums.length - 1;

    // Repete o partition enquanto o intervalo de busca for válido. O intervalo diminui a cada iteração do loop
    while (l <= r) {
        // Executa o partition no intervalo de busca atual e obtém a posição do pivô
        int p = partition(nums, l, r);

        if (p == k - 1) {
            // O pivô está na posição do K-ésimo maior, então retorna a resposta
            // Em ordem decrescente, o índice k-1 contando da esquerda é a posição do K-ésimo maior elemento
            return nums[p];
        } else if (p < k - 1) {
            // O K-ésimo está à direita do pivô (lado dos menores), então restringe o limite esquerdo do intervalo de busca
            l = p + 1;
        } else {
            // O K-ésimo está à esquerda do pivô (lado dos maiores), então restringe o limite direito do intervalo de busca
            r = p - 1;
        }
    }
    // Devido às restrições do problema, um k válido é sempre fornecido, então este ponto nunca é alcançado
    return -1;
}
```
