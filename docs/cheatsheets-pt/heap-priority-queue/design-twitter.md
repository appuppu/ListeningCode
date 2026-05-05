# Designing a Simplified Twitter Feed — Projetar um sistema que obtém eficientemente os 10 tweets mais recentes a partir dos tweets de múltiplos usuários

## Essência do Problema

Implementar quatro operações como um sistema simplificado do Twitter. `postTweet` publica um tweet, `getNewsFeed` obtém os **10 tweets mais recentes** dos tweets do próprio usuário e dos usuários que ele segue, `follow` segue um usuário e `unfollow` deixa de seguir um usuário. O desafio central consiste em **mesclar as listas de tweets de múltiplos usuários em ordem cronológica e extrair eficientemente apenas os 10 primeiros**.

## Ideia Central

A lista de tweets de cada usuário já está ordenada pela ordem de publicação (ordem cronológica). O problema de extrair os K primeiros itens de múltiplas listas ordenadas pode ser resolvido não reordenando todas as listas, mas utilizando um **K-way merge com heap**, comparando apenas o primeiro elemento de cada lista e extraindo um item por vez, com o número mínimo necessário de comparações.

## Processo de Raciocínio

1. **Decidir como armazenar os dados**: É necessário gerenciar os tweets publicados por cada usuário em ordem cronológica. Utilizando um HashMap com o ID do usuário como chave e a lista de tweets como valor, é possível obter a lista de tweets de qualquer usuário em O(1). Cada tweet recebe um timestamp global para registrar a ordem de publicação
2. **Decidir como gerenciar as relações de seguimento**: Seguir e deixar de seguir correspondem à adição e remoção em um conjunto de IDs de usuários. Utilizando um HashMap com o ID do usuário como chave e um Set de IDs dos usuários seguidos como valor, é possível realizar adição, remoção e listagem de seguidores em O(1)
3. **Identificar a essência da obtenção do feed de notícias**: `getNewsFeed` é uma operação que retorna os 10 tweets mais recentes dentre os tweets do próprio usuário e de todos os usuários que ele segue. Como a lista de tweets de cada usuário já está ordenada pela ordem de publicação, o problema se reduz a **extrair os K primeiros itens de múltiplas listas ordenadas (K-way merge)**
4. **Utilizar heap para o K-way merge**: Inserir o último elemento (tweet mais recente) da lista de tweets de cada usuário em um Max-Heap. Extrair do heap o elemento com o maior timestamp e adicionar ao heap o próximo tweet mais recente desse usuário. Repetindo esse processo 10 vezes, obtêm-se os 10 tweets mais recentes
5. **Decidir quais informações cada elemento do heap deve conter**: Para adicionar o próximo tweet do mesmo usuário após a extração do heap, cada entrada deve conter quatro informações: "timestamp", "ID do tweet", "ID do usuário" e "índice na lista". Decrementando o índice em 1, é possível acessar o próximo tweet mais recente desse usuário
6. **Encerrar antecipadamente ao obter 10 itens**: O loop é encerrado quando o heap fica vazio ou quando a lista de resultados atinge 10 itens. Não é necessário processar todos os tweets

## Conhecimentos Prévios

### O que é PriorityQueue (Fila de Prioridade / Heap)

Uma estrutura de dados que reordena automaticamente os elementos por prioridade cada vez que um elemento é adicionado. O elemento de maior prioridade pode ser extraído em O(log N). A PriorityQueue do Java é, por padrão, um Min-Heap (o menor valor fica no topo), mas é possível alterá-la para um Max-Heap (o maior valor fica no topo) especificando um Comparator.

```java
// Criar um Max-Heap (timestamp maior = mais recente fica no topo)
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> b[0] - a[0]);
pq.offer(new int[]{5, 101});   // Adicionar [timestamp, ID do tweet]
pq.offer(new int[]{3, 102});   // Após a adição, os elementos são ordenados internamente em ordem decrescente de timestamp
int[] top = pq.poll();         // Extrair o elemento com o maior timestamp → [5, 101]
pq.isEmpty();                  // Retornar boolean indicando se o heap está vazio → false
```

### O que é computeIfAbsent

Um método que, apenas quando a chave não existe no HashMap, gera e registra o valor usando a função especificada e retorna esse valor. Quando a chave já existe, retorna o valor existente tal como está. Permite condensar em uma única linha os três passos de fazer `get`, verificar se é `null` e fazer `put`.

```java
Map<Integer, List<int[]>> tweets = new HashMap<>();
// Se a chave 1 não existir, criar e registrar uma nova ArrayList e retornar essa lista
tweets.computeIfAbsent(1, k -> new ArrayList<>()).add(new int[]{0, 101});
// A chave 1 já existe, então retornar a lista existente e adicionar a ela
tweets.computeIfAbsent(1, k -> new ArrayList<>()).add(new int[]{1, 102});
```

### O que é K-way Merge

Uma técnica para integrar K listas ordenadas em uma única sequência ordenada. Apenas o primeiro elemento de cada lista é inserido no heap, e cada vez que o menor (ou maior) é extraído, o próximo elemento da lista à qual o elemento extraído pertence é adicionado ao heap. É possível integrar em O(N log K), o que é mais eficiente do que ordenar todos os elementos juntos em O(N log N).

## Complexidade

| | Valor |
|---|---|
| Time | O(K log K) — K é o número de usuários seguidos. A inserção inicial no heap custa O(K log K), e no máximo 10 operações de poll/offer custam O(10 log K) |
| Space | O(K) — No máximo K elementos são armazenados simultaneamente no heap |

## Código

```java
// Entrada: chamadas das operações postTweet(userId, tweetId), follow(followerId, followeeId), unfollow(followerId, followeeId), getNewsFeed(userId)
// Saída: getNewsFeed retorna os 10 IDs de tweets mais recentes do usuário e dos usuários que ele segue como List<Integer>
class Twitter {
    // Timestamp global. Identifica de forma única a ordem de publicação entre os tweets de todos os usuários
    // Como é monotonicamente crescente, permite comparação cronológica correta mesmo entre tweets de usuários diferentes
    int time = 0;
    // Chave=ID do usuário, Valor=lista de tweets desse usuário (cada elemento é [timestamp, ID do tweet])
    // Os elementos são adicionados ao final da lista na ordem de publicação, portanto o final é o mais recente
    Map<Integer, List<int[]>> tweets;
    // Chave=ID do usuário que segue, Valor=Set de IDs dos usuários seguidos
    // O uso de Set permite que adição, remoção e eliminação de duplicatas sejam feitas em O(1)
    Map<Integer, Set<Integer>> follows;

    Twitter() {
        tweets = new HashMap<>();
        follows = new HashMap<>();
    }

    void postTweet(int userId, int tweetId) {
        // Obter a lista de tweets do usuário (criando-a se não existir) e adicionar [timestamp, ID do tweet] ao final
        // time++ atribui um timestamp global e registra a ordem de publicação
        tweets.computeIfAbsent(userId, k -> new ArrayList<>())
            .add(new int[]{time++, tweetId});
    }

    void follow(int followerId, int followeeId) {
        // Adicionar followeeId ao Set de seguidos (como é um Set, seguir o mesmo usuário duas vezes não gera duplicata)
        follows.computeIfAbsent(followerId, k -> new HashSet<>())
            .add(followeeId);
    }

    void unfollow(int followerId, int followeeId) {
        // Remover followeeId do Set apenas se a relação de seguimento existir
        // Chamar get em uma chave inexistente causa NullPointerException, por isso verificar primeiro com containsKey
        if (follows.containsKey(followerId))
            follows.get(followerId).remove(followeeId);
    }

    List<Integer> getNewsFeed(int userId) {
        // Max-Heap: especificar Comparator para que o elemento com maior timestamp (mais recente) fique no topo
        PriorityQueue<int[]> pq =
            new PriorityQueue<>((a, b) -> b[0] - a[0]);

        // Usuários alvo do feed = próprio usuário + todos os usuários seguidos
        // Como os próprios tweets também devem ser incluídos no feed, não esquecer de adicionar o próprio usuário
        Set<Integer> users = new HashSet<>();
        users.add(userId);
        if (follows.containsKey(userId))
            users.addAll(follows.get(userId));

        // Adicionar o tweet mais recente (último da lista) de cada usuário ao heap (inicialização do K-way merge)
        for (int uid : users) {
            // Pular usuários que não possuem tweets
            if (!tweets.containsKey(uid)) continue;
            List<int[]> t = tweets.get(uid);
            int idx = t.size() - 1;
            int[] tw = t.get(idx);
            // [timestamp, ID do tweet, ID do usuário, índice na lista]
            // Incluir o ID do usuário e o índice para poder navegar até o próximo tweet desse usuário após a extração
            pq.offer(new int[]{tw[0], tw[1], uid, idx});
        }

        // Extrair no máximo 10 itens do heap (execução do K-way merge)
        List<Integer> res = new ArrayList<>();
        while (!pq.isEmpty() && res.size() < 10) {
            // Extrair o elemento com o maior timestamp
            int[] top = pq.poll();
            // Adicionar o ID do tweet extraído ao resultado
            res.add(top[1]);
            int uid = top[2];
            // Decrementar o índice em 1 para apontar para o próximo tweet mais recente desse usuário
            int idx = top[3] - 1;
            // Se esse usuário ainda tiver tweets mais antigos, adicioná-los ao heap (se o índice for negativo, todos já foram processados)
            if (idx >= 0) {
                int[] tw = tweets.get(uid).get(idx);
                pq.offer(new int[]{tw[0], tw[1], uid, idx});
            }
        }
        // Os IDs dos 10 tweets mais recentes (ou de todos os tweets se o total for inferior a 10) estão armazenados em ordem decrescente de timestamp
        return res;
    }
}
```
