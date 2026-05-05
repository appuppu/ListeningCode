# Determinar se Todos os Cursos Podem Ser Concluídos — 全コースを完了できるかを判定する

## Essência do Problema

São dados `numCourses` cursos rotulados de `0` a `n-1` e uma lista de pares de pré-requisitos `prerequisites`. Cada par `[a, b]` significa que "o curso `b` deve ser concluído antes de cursar o curso `a`". O objetivo é retornar um `boolean` indicando se é possível concluir todos os cursos. Este é um problema de detectar se existe um ciclo (dependência circular) em um grafo direcionado.

## Ideia Central

Ao representar as dependências entre cursos como um grafo direcionado, determinar se todos os cursos podem ser concluídos equivale a verificar se "o grafo não contém ciclos". Realizamos uma ordenação topológica processando os nós a partir daqueles com grau de entrada (número de arestas que chegam ao nó) igual a 0. Se todos os nós forem processados, então não existe ciclo.

## Processo de Raciocínio

1. **Converter o problema em um grafo**: Cada curso é um nó, e cada pré-requisito `[a, b]` é uma aresta direcionada `b → a`. Construímos uma lista de adjacência para representar as dependências como estrutura de grafo
2. **Se houver ciclo, é impossível concluir todos os cursos**: Se o curso A depende de B e B depende de A, nenhum dos dois pode ser cursado primeiro. Portanto, o problema se reduz a "verificar se existe um ciclo no grafo direcionado"
3. **Focar no grau de entrada**: Contamos o grau de entrada (número de pré-requisitos) de cada nó. Nós com grau de entrada 0 não possuem pré-requisitos e podem ser cursados imediatamente. Estes são os pontos de partida
4. **Inserir os nós com grau de entrada 0 na fila e iniciar o processamento**: Utilizamos uma fila como na BFS, processando os nós com grau de entrada 0 em sequência. Para cada nó processado, reduzimos em 1 o grau de entrada dos nós adjacentes, e adicionamos à fila aqueles cujo grau de entrada se tornou 0
5. **Determinar pelo número de nós processados**: Se todos os nós foram processados (contagem de processados == `numCourses`), não existe ciclo e todos os cursos podem ser concluídos. Os nós dentro de um ciclo nunca terão grau de entrada 0, portanto permanecem sem serem processados

## Conhecimentos Prévios

### O que é uma Lista de Adjacência (Adjacency List)

É uma estrutura de dados para representar grafos. Para cada nó, mantém uma lista dos nós destino das arestas que partem dele. Implementamos com `List<List<Integer>>`, e `graph.get(i)` retorna a lista de nós adjacentes ao nó `i`.

```java
List<List<Integer>> graph = new ArrayList<>();
for (int i = 0; i < n; i++)
    graph.add(new ArrayList<>());  // Cria uma lista vazia para cada nó
graph.get(0).add(1);               // Adiciona uma aresta do nó 0 para o nó 1
graph.get(0);                       // Lista de nós adjacentes ao nó 0 → [1]
```

### O que é Grau de Entrada (In-degree)

Em um grafo direcionado, é o número de arestas que chegam a um determinado nó. Nós com grau de entrada 0 não dependem de nenhum outro nó. Gerenciamos o grau de entrada do nó `i` com o array `inDegree[i]`.

```java
int[] inDegree = new int[n];   // Inicializa o grau de entrada de todos os nós com 0
inDegree[0]++;                  // Incrementa o grau de entrada do nó 0 em 1
```

### O que é uma Queue (Fila)

É uma estrutura de dados primeiro a entrar, primeiro a sair (FIFO). É utilizada na BFS para gerenciar os nós aguardando processamento. `offer` adiciona ao final e `poll` remove do início.

```java
Queue<Integer> queue = new LinkedList<>();
queue.offer(0);       // Adiciona 0 à fila
queue.poll();          // Remove e retorna o elemento do início da fila → 0
queue.isEmpty();       // Retorna um boolean indicando se a fila está vazia → true
```

## Complexidade

| | Valor |
|---|---|
| Time | O(V + E) — Processa cada nó (V nós) e cada aresta (E arestas) exatamente uma vez |
| Space | O(V + E) — Armazena todas as arestas na lista de adjacência, e todos os nós no array de grau de entrada e na fila |

## Código

```java
// Entrada: número de cursos numCourses e array de pré-requisitos prerequisites (cada elemento é [a, b] representando a dependência "b → a")
// Saída: true se todos os cursos podem ser concluídos, false se existe um ciclo impossibilitando a conclusão
boolean canFinish(int numCourses, int[][] prerequisites) {
    // Array que armazena o grau de entrada (número de pré-requisitos) de cada nó. O grau de entrada representa "quantos pré-requisitos o curso possui"
    int[] inDegree = new int[numCourses];

    // Constrói o grafo com lista de adjacência. graph.get(i) é a lista de nós destino das arestas que partem do nó i
    List<List<Integer>> graph = new ArrayList<>();
    for (int i = 0; i < numCourses; i++)
        graph.add(new ArrayList<>());

    // Adiciona arestas a partir de cada pré-requisito e atualiza os graus de entrada. Isso completa o grafo de dependências e o grau de entrada de cada nó
    for (int[] p : prerequisites) {
        graph.get(p[1]).add(p[0]);  // Adiciona a aresta p[1] → p[0]
        inDegree[p[0]]++;           // Incrementa o grau de entrada de p[0] em 1
    }

    // Adiciona à fila os nós com grau de entrada 0 (sem pré-requisitos). Estes são os cursos que podem ser cursados primeiro
    Queue<Integer> queue = new LinkedList<>();
    for (int i = 0; i < numCourses; i++)
        if (inDegree[i] == 0)
            queue.offer(i);

    // Processa os nós com grau de entrada 0 em sequência usando BFS
    int count = 0;  // Variável que rastreia o número de cursos processados
    while (!queue.isEmpty()) {
        int course = queue.poll();
        count++;  // Considera este nó como curso concluído

        // Reduz o grau de entrada dos nós adjacentes em 1 (significa que um pré-requisito foi satisfeito). Se chegar a 0, todos os pré-requisitos foram satisfeitos, então adiciona à fila
        for (int nei : graph.get(course))
            if (--inDegree[nei] == 0)
                queue.offer(nei);
    }

    // Se todos os nós foram processados, não existe ciclo (todos os cursos podem ser concluídos). Nós dentro de um ciclo nunca terão grau de entrada 0 e permanecerão sem serem processados
    return count == numCourses;
}
```
