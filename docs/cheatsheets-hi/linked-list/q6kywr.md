# Merging K Sorted Linked Lists — K सॉर्ट की गई लिंक्ड लिस्ट को एक में मर्ज करना

## समस्या का सार

K सॉर्ट की गई लिंक्ड लिस्ट (Linked List) की एक array दी गई है। इन सभी को **एक सॉर्ट की गई लिंक्ड लिस्ट** में मर्ज करना है और उसके head node को return करना है। प्रत्येक लिस्ट अलग-अलग सॉर्ट की हुई है, और मर्ज के बाद भी लिस्ट को ascending order में बनाए रखना आवश्यक है।

## मूल विचार

K लिस्ट को एक साथ मर्ज करने के बजाय, दो-दो के जोड़े बनाकर बार-बार मर्ज करना है। प्रत्येक राउंड में लिस्ट की संख्या आधी हो जाती है, इसलिए log k राउंड में एक लिस्ट में समेट दिया जाता है, और कुल N elements के लिए O(N log k) की efficiency प्राप्त होती है।

## विचार प्रक्रिया

1. **मूल operation "दो सॉर्ट की गई लिस्ट का मर्ज" है**: K लिस्ट को मर्ज करने की समस्या को "दो सॉर्ट की गई लिस्ट को एक में मर्ज करना" इस मूल operation के संयोजन में विभाजित किया जा सकता है। दो लिस्ट का मर्ज, दोनों के head की तुलना करके छोटे वाले को चुनने की प्रक्रिया को दोहराकर O(n) में किया जा सकता है
2. **K लिस्ट पर इस मूल operation को कैसे लागू करें**: सरलतम तरीके से पहली और दूसरी को मर्ज करें, फिर उस परिणाम को तीसरी के साथ मर्ज करें… इस प्रकार क्रमशः करने पर O(Nk) हो जाता है। क्योंकि हर बार मर्ज का परिणाम लंबा होता जाता है, बाद के मर्ज की cost अधिक हो जाती है
3. **Pairwise मर्ज करने से cost समान रहती है**: लिस्ट को दो-दो के जोड़े में मर्ज करने पर, प्रत्येक राउंड में सभी elements को केवल एक बार process करना पड़ता है। लिस्ट की संख्या प्रत्येक राउंड में आधी हो जाती है, इसलिए राउंड की संख्या log k होती है, और कुल मिलाकर O(N log k) प्राप्त होता है
4. **Array के index से जोड़ों को manage करना**: `interval` variable को 1, 2, 4, 8… इस प्रकार दोगुना करते हुए, `lists[i]` और `lists[i + interval]` को मर्ज करके `lists[i]` में store करना है। इससे अतिरिक्त array का उपयोग किए बिना in-place pairwise मर्ज को लागू किया जा सकता है
5. **सभी राउंड समाप्त होने के बाद, lists[0] अंतिम परिणाम होता है**: प्रत्येक राउंड में मर्ज के परिणाम `lists[0]`, `lists[2]`, `lists[4]`… इस प्रकार even index पर एकत्रित होते जाते हैं, और अंततः `lists[0]` में सभी elements समेट दिए जाते हैं

## पूर्वापेक्षित ज्ञान

### ListNode (लिंक्ड लिस्ट का नोड) क्या है

लिंक्ड लिस्ट के प्रत्येक element को दर्शाने वाला class है। `val` में value और `next` में अगले node का reference रखा जाता है। जिस node का `next` `null` है, वह लिस्ट का अंतिम node है।

```java
class ListNode {
    int val;              // इस node में stored value
    ListNode next;        // अगले node का reference (अंतिम node के लिए null)
    ListNode(int val) {   // Constructor: value specify करके node बनाना
        this.val = val;
    }
}
```

### Dummy Node (Sentinel Node) क्या है

लिस्ट निर्माण को सरल बनाने की तकनीक है। value 0 वाला dummy node सबसे आगे रखा जाता है, और उसके पीछे वास्तविक nodes जोड़े जाते हैं। अंत में `dummy.next` return करने से head node के लिए विशेष handling की आवश्यकता नहीं रहती।

```java
ListNode dummy = new ListNode(0);  // Dummy node बनाना
ListNode tail = dummy;             // tail अंतिम node को track करने वाला pointer है
tail.next = someNode;              // Dummy के पीछे node जोड़ना
tail = tail.next;                  // tail को अंतिम स्थान पर आगे बढ़ाना
return dummy.next;                 // Dummy के अगले node, अर्थात वास्तविक head को return करना
```

### Divide and Conquer (विभाजन और विजय) क्या है

समस्या को छोटी उप-समस्याओं में विभाजित करके, उप-समस्याओं को हल करके, फिर परिणामों को मिलाने की विधि है। Merge Sort इसका प्रमुख उदाहरण है, जिसमें array को आधा-आधा विभाजित किया जाता है और सॉर्ट की गई उप-arrays को मर्ज किया जाता है। इस समस्या में K लिस्ट को दो-दो के जोड़े बनाकर बार-बार मर्ज किया जाता है।

```java
// interval 1, 2, 4, 8... इस प्रकार दोगुना होता है, जोड़ों के बीच की दूरी बढ़ाते हुए
for (int interval = 1; interval < n; interval *= 2) {
    // प्रत्येक राउंड में जोड़ों को क्रमशः मर्ज करना
    for (int i = 0; i < n - interval; i += 2 * interval) {
        lists[i] = merge(lists[i], lists[i + interval]);
    }
}
```

## समय और स्थान जटिलता

| | मान |
|---|---|
| Time | O(N log k) — कुल N elements को प्रत्येक राउंड में एक बार process किया जाता है, और राउंड की संख्या log k है |
| Space | O(log k) — Recursion का उपयोग नहीं है, लेकिन मर्ज राउंड की संख्या के अनुरूप loop stack की space लगती है |

## कोड

```java
// Input: सॉर्ट की गई लिंक्ड लिस्ट की array ListNode[] lists (K elements)
// Output: सभी लिस्ट को मर्ज करके बनी एक सॉर्ट की गई लिंक्ड लिस्ट का head node ListNode return करना

// दो सॉर्ट की गई लिस्ट को एक में मर्ज करने वाला helper method
private ListNode mergeTwoLists(ListNode a, ListNode b) {
    // Dummy node बनाकर मर्ज परिणाम लिस्ट के head का marker बनाना (वास्तविक data dummy.next से शुरू होता है)
    ListNode dummy = new ListNode(0);
    // tail हमेशा मर्ज परिणाम के अंतिम node को track करता है, और नया node जोड़ने की स्थिति दर्शाता है
    ListNode tail = dummy;

    // जब तक दोनों लिस्ट में nodes शेष हैं, छोटे वाले को चुनकर जोड़ना (sort order बनाए रखने के लिए)
    while (a != null && b != null) {
        if (a.val <= b.val) {
            tail.next = a;  // a के वर्तमान node को मर्ज परिणाम में जोड़ना
            a = a.next;     // a को अगले node पर आगे बढ़ाना
        } else {
            tail.next = b;  // b के वर्तमान node को मर्ज परिणाम में जोड़ना
            b = b.next;     // b को अगले node पर आगे बढ़ाना
        }
        tail = tail.next;   // tail को अंत में आगे बढ़ाकर अगला node जोड़ने की तैयारी करना
    }

    // while loop समाप्त होने के बाद, a या b में से किसी एक में शेष nodes हैं। दोनों सॉर्ट की हुई हैं इसलिए उन्हें सीधे जोड़ने में कोई समस्या नहीं है
    tail.next = (a != null) ? a : b;

    // dummy स्वयं एक dummy है, इसलिए उसका अगला node मर्ज परिणाम का वास्तविक head है
    return dummy.next;
}

public ListNode mergeKLists(ListNode[] lists) {
    // यदि input null या खाली है, तो मर्ज करने के लिए कोई लिस्ट नहीं है इसलिए null return करना
    if (lists == null || lists.length == 0) return null;

    // n में लिस्ट की संख्या K को store करना
    int n = lists.length;

    // interval को 1, 2, 4, 8... इस प्रकार दोगुना करना। interval मर्ज किए जाने वाले जोड़ों के बीच की दूरी दर्शाता है, और प्रत्येक राउंड में लिस्ट की संख्या आधी हो जाती है
    for (int interval = 1; interval < n; interval *= 2) {
        // i < n - interval शर्त यह सुनिश्चित करती है कि जोड़े का दायाँ भाग lists[i + interval] array की सीमा में मौजूद है
        for (int i = 0; i < n - interval; i += 2 * interval) {
            // जोड़े के मर्ज परिणाम को lists[i] में store करना। दायीं लिस्ट का आगे उपयोग नहीं होता, इसलिए बायीं में overwrite करने में कोई समस्या नहीं है
            lists[i] = mergeTwoLists(lists[i], lists[i + interval]);
        }
    }

    // सभी राउंड समाप्त होने के बाद, सभी लिस्ट का मर्ज परिणाम lists[0] में एकत्रित हो चुका है
    return lists[0];
}
```
