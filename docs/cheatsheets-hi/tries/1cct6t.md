# Implementing a Prefix Tree — दी गई स्ट्रिंग की insertion, exact match search, और prefix search को कुशलतापूर्वक करने वाली data structure को design करना

## समस्या का सार

Trie (prefix tree) नामक data structure को design और implement करना है। इस data structure को तीन operations को support करना आवश्यक है: (1) `insert(word)` से शब्द को insert करना, (2) `search(word)` से exactly match होने वाला शब्द मौजूद है या नहीं यह निर्धारित करना, (3) `startsWith(prefix)` से insert किए गए शब्दों में से किसी specified prefix से शुरू होने वाला शब्द मौजूद है या नहीं यह निर्धारित करना।

## मूल विचार

यदि string को एक-एक character करके node के रूप में tree structure में विभाजित किया जाए, तो common prefix वाले शब्द आपस में nodes को share करते हैं। प्रत्येक node में "यहाँ शब्द समाप्त होता है या नहीं" दर्शाने वाला flag रखने से, exact match search और prefix search का अंतर केवल यह रह जाता है कि traversal समाप्त होने पर उस flag की जाँच करनी है या नहीं।

## विचार प्रक्रिया

1. **String को एक-एक character करके tree structure में विस्तारित करना**: Insert किए जाने वाले शब्द को एक-एक character करके node के रूप में represent करना है, और parent-child relationship से characters के क्रम को दर्शाना है। इस प्रकार "apple" और "app" जैसे common prefix वाले शब्द, पहले 3 nodes (a→p→p) को share कर सकते हैं
2. **प्रत्येक node के child nodes को HashMap से manage करना**: प्रत्येक node अगले आने वाले character के corresponding child node रखता है। Child nodes के management के लिए HashMap का उपयोग किया जाता है, key में "character" और value में "child node का reference" store किया जाता है। इस प्रकार किसी भी character पर transition O(1) में हो सकता है
3. **शब्द के अंत को पहचानने के लिए flag आवश्यक है**: "apple" insert करने के बाद, "app" को search करने पर, a→p→p तक nodes को traverse किया जा सकता है। लेकिन "app" insert नहीं किया गया है, इसलिए false return करना आवश्यक है। प्रत्येक node में `isEnd` flag रखकर, `insert` के समय अंतिम node पर `isEnd = true` सेट करने से, शब्द के अंत को पहचाना जा सकता है
4. **तीनों operations मूलतः nodes के traversal पर आधारित हैं**: `insert`, `search`, `startsWith` सभी root से शुरू होकर, string को एक-एक character करके traverse करते हुए nodes पर transition करते हैं। `insert` में यदि transition target मौजूद नहीं है तो नया node बनाया जाता है। `search` और `startsWith` में यदि transition target मौजूद नहीं है तो तुरंत false return किया जाता है
5. **search और startsWith का अंतर केवल isEnd की जाँच है**: `search` सभी characters को traverse करने के बाद `node.isEnd` true है या नहीं यह जाँचता है। `startsWith` सभी characters को traverse कर लेने पर true return करता है। Traversal का logic समान है, केवल अंतिम निर्णय भिन्न है
6. **Root node एक dummy node है**: Trie के starting point root node को, कोई character न रखने वाले खाली node के रूप में initialize किया जाता है। सभी operations इस root node से traversal शुरू करते हैं

## पूर्वापेक्षित ज्ञान

### Trie क्या है

String को कुशलतापूर्वक store और search करने के लिए एक tree structure है। प्रत्येक node एक character के corresponding होता है, और root से leaf तक का path एक string को represent करता है। Common prefix वाली strings nodes को share करती हैं, इसलिए यह prefix search में कुशल data structure है।

```
उदाहरण: "app", "apple", "bat" को insert करने पर tree structure

      root
      / \
     a   b
     |   |
     p   a
     |   |
     p*  t*
     |
     l
     |
     e*

* वे nodes हैं जहाँ isEnd = true है (शब्द का अंत)
```

### HashMap क्या है

Key और value के pair को store करने वाली data structure है। Key specify करके value की search और retrieval O(1) में की जा सकती है। Trie में, प्रत्येक node के child nodes को manage करने के लिए इसका उपयोग किया जाता है।

```java
HashMap<Character, TrieNode> children = new HashMap<>();  // खाली HashMap बनाना
children.put('a', new TrieNode());      // key 'a' में नया node store करना
children.containsKey('a');              // key 'a' मौजूद है या नहीं boolean में return करना → true
children.get('a');                      // key 'a' के corresponding node को return करना
children.putIfAbsent('a', new TrieNode());  // key 'a' अभी तक registered नहीं है तभी store करना
```

### putIfAbsent क्या है

HashMap का method है, जो specified key अभी तक मौजूद नहीं होने पर ही value को store करता है। यदि key पहले से मौजूद है तो कुछ नहीं करता। `insert` operation में, existing path को नष्ट किए बिना केवल नए nodes जोड़ने के लिए इसका उपयोग किया जाता है।

```java
map.putIfAbsent('a', new TrieNode());  // 'a' अभी registered नहीं है तो नया node register करना
map.putIfAbsent('a', new TrieNode());  // 'a' पहले से registered है इसलिए कुछ नहीं करना
```

## गणना जटिलता

| | मान |
|---|---|
| Time | O(m) — insert, search, startsWith सभी में, string की लंबाई m के अनुपात में केवल एक बार traverse किया जाता है |
| Space | O(n * m) — n शब्दों (औसत लंबाई m) को store किया जाता है। Common prefix के कारण nodes share होते हैं, इसलिए वास्तविक उपयोग इससे कम होता है |

## कोड

```java
// Input: insert(word) में string word, search(word) में string word, startsWith(prefix) में string prefix
// Output: insert का कोई return value नहीं है (Trie में शब्द जोड़ता है), search exact match शब्द मौजूद है या नहीं boolean में return करता है, startsWith prefix से match होने वाला शब्द मौजूद है या नहीं boolean में return करता है

// TrieNode class: Trie के प्रत्येक node को represent करता है
class TrieNode {
    // Child nodes का mapping। Key=character, Value=corresponding child node
    Map<Character, TrieNode> children;
    // इस node पर शब्द समाप्त होता है या नहीं दर्शाने वाला flag (initial value false है)
    // इस flag के कारण, search exact match और prefix match को अलग पहचान सकता है
    boolean isEnd;

    TrieNode() {
        children = new HashMap<>();
        isEnd = false;
    }
}

class Trie {
    // सभी operations का starting point root node (कोई character न रखने वाला खाली dummy node)
    private TrieNode root;

    // Constructor में खाली TrieNode को root के रूप में बनाना
    public Trie() {
        root = new TrieNode();
    }

    public void insert(String word) {
        // node वर्तमान traversal position को दर्शाने वाला pointer है। Root से traversal शुरू करना
        TrieNode node = root;
        // String word को शुरू से एक-एक character करके traverse करना
        for (char c : word.toCharArray()) {
            // putIfAbsent से, child node मौजूद नहीं है तो नया बनाना, मौजूद है तो कुछ नहीं करना
            // putIfAbsent का उपयोग करने से, existing path (अन्य शब्दों द्वारा share किए जा रहे nodes) को overwrite नहीं किया जाता
            node.children.putIfAbsent(c, new TrieNode());
            // Pointer को character c के corresponding child node पर आगे बढ़ाना
            node = node.children.get(c);
        }
        // अंतिम node पर शब्द का end flag सेट करना
        // इस flag के कारण, search में "apple" inserted और "app" not inserted को अलग पहचाना जा सकता है
        node.isEnd = true;
    }

    public boolean search(String word) {
        // Root से traversal शुरू करना
        TrieNode node = root;
        // String word को शुरू से एक-एक character करके traverse करना
        for (char c : word.toCharArray()) {
            // Corresponding child node मौजूद नहीं है तो, इस character के लिए Trie में path नहीं है इसलिए तुरंत false
            if (!node.children.containsKey(c))
                return false;
            // Pointer को child node पर आगे बढ़ाना
            node = node.children.get(c);
        }
        // सभी characters traverse करने के बाद वह node शब्द का अंत है तो true, अन्यथा false
        // इसके कारण "apple" inserted और "app" not inserted होने पर, search("app") सही ढंग से false return करता है
        return node.isEnd;
    }

    public boolean startsWith(String prefix) {
        // Root से traversal शुरू करना
        TrieNode node = root;
        // String prefix को शुरू से एक-एक character करके traverse करना
        for (char c : prefix.toCharArray()) {
            // Corresponding child node मौजूद नहीं है तो, इस prefix के लिए Trie में path नहीं है इसलिए तुरंत false
            if (!node.children.containsKey(c))
                return false;
            // Pointer को child node पर आगे बढ़ाना
            node = node.children.get(c);
        }
        // सभी characters traverse हो गए, इसलिए इस prefix से शुरू होने वाला शब्द Trie में मौजूद है
        // search से अंतर केवल यह है कि isEnd की जाँच नहीं की जाती
        return true;
    }
}
```
