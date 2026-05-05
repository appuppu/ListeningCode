# Finding Combinations That Sum to a Target Without Reuse — 從包含重複元素的陣列中找出所有加總為目標值的唯一組合

## 問題的本質

給定一個整數陣列 `candidates`（可能包含重複元素）和一個整數 `target`。從陣列中找出所有加總為 `target` 的數值組合。每個數值在組合中只能使用**一次**，且結果中**不得包含重複的組合**。

## 核心思路

透過對陣列排序，使相同值的元素彼此相鄰，從而在遞迴的同一層級中利用條件 `i > start && cands[i] == cands[i-1]` 跳過重複元素。這樣就能從根本上防止生成重複的組合，同時不遺漏地探索所有唯一組合。

## 思考過程

1. **需要列舉所有組合**：問題要求「所有滿足條件的組合」，因此不是尋找單一最佳解，而是需要探索整個解空間。這類「全列舉」問題適合使用回溯法
2. **以「使用／不使用」對每個元素進行分支**：對陣列中的每個元素，遞迴地選擇「是否將其納入當前組合」。為了使每個元素只使用一次，在遞迴呼叫中將起始索引推進至 `i + 1`
3. **需要排除重複的組合**：當陣列中存在重複元素時，選擇不同索引處的相同值會生成相同的組合。例如在 `[1,1,2]` 且 target=3 時，選擇第一個1與2的組合，和選擇第二個1與2的組合，結果都是相同的 `[1,2]`
4. **透過排序並跳過重複元素**：對陣列排序後，相同的值會相鄰排列。在遞迴的同一層級（同一個 for 迴圈內），跳過與前一個值相同的元素，即可防止生成重複的組合。跳過條件為 `i > start && cands[i] == cands[i-1]`。條件 `i > start` 確保允許使用第一個元素，而跳過第二個及之後的相同值
5. **透過剪枝提升探索效率**：由於陣列已排序，當前元素超過剩餘合計 `remain` 時，之後的所有元素也必定超過。使用 `if (cands[i] > remain) break` 中斷迴圈，可以省略不必要的探索
6. **基礎情況的判定**：當 `remain` 為0時，表示當前 `path` 中元素的總和恰好等於 `target`，因此將 `path` 的副本加入結果列表

## 前置知識

### 什麼是回溯法

回溯法是一種逐步構建候選解，在確認不滿足條件時回到上一個狀態（回溯）並嘗試其他候選解的搜尋方法。透過「選擇→遞迴→撤銷選擇」的模式來實作。

```java
path.add(element);          // 選擇：將元素加入組合
backtrack(next_state);      // 遞迴：繼續探索下一個元素
path.remove(path.size()-1); // 撤銷：將元素從組合中移除，恢復原始狀態
```

### 什麼是 Arrays.sort

Arrays.sort 是 Java 的標準方法，用於將陣列按升序排序。排序後相同值的元素會相鄰排列，使得重複的偵測與跳過變得容易。

```java
int[] arr = {2, 1, 2, 3};
Arrays.sort(arr);           // arr 變為 {1, 2, 2, 3}
```

### ArrayList 的複製建構子

`new ArrayList<>(path)` 會建立一個複製了 `path` 內容的新列表。在回溯法中，由於 `path` 在遞迴過程中會持續變化，因此在加入結果時需要建立副本。

```java
List<Integer> path = new ArrayList<>(Arrays.asList(1, 2));
List<Integer> copy = new ArrayList<>(path);  // 建立 [1, 2] 的副本
path.add(3);        // path 變為 [1, 2, 3]
// copy 仍然保持為 [1, 2] 不變
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(2^n) — 由於每個元素都有「使用／不使用」兩種選擇，最壞情況下需要探索 2^n 種組合 |
| Space | O(n) — 遞迴深度最大為 n，path 也最多保存 n 個元素 |

## 程式碼

```java
// 輸入：整數陣列 candidates（可能包含重複元素）和整數 target
// 輸出：返回包含所有加總為 target 的唯一組合的 List<List<Integer>>
private void backtrack(int[] cands, int start, int remain,
        List<Integer> path, List<List<Integer>> result) {
    // 當 remain 為0時，表示發現了 path 的總和恰好等於 target 的組合
    if (remain == 0) {
        // 由於 path 在後續遞迴中會持續變化，因此建立副本並加入結果
        result.add(new ArrayList<>(path));
        return;
    }

    // 從 start 開始，防止重新選擇已使用的元素（start 之前的元素）
    for (int i = start; i < cands.length; i++) {
        // 在同一遞迴層級中，若為第二個及之後的元素且與前一個值相同，則跳過以防止重複組合
        // i > start 表示「不是同一遞迴層級中的第一個元素」
        if (i > start && cands[i] == cands[i - 1]) continue;

        // 由於已排序，若當前值超過 remain，則之後的元素也全部超過（剪枝）
        if (cands[i] > remain) break;

        path.add(cands[i]);                  // 選擇：將元素加入組合
        backtrack(cands, i + 1,              // 遞迴：使用 i+1 防止同一元素被使用兩次
            remain - cands[i], path, result); // 從 remain 中減去當前元素以更新剩餘合計
        path.remove(path.size() - 1);        // 撤銷：移除元素並恢復狀態以嘗試其他元素
    }
}

public List<List<Integer>> combinationSum2(
        int[] candidates, int target) {
    // 透過排序使相同值的重複元素相鄰，使跳過條件的判定成為可能
    Arrays.sort(candidates);
    // 建立空的結果列表和用於記錄當前組合的 path
    List<List<Integer>> result = new ArrayList<>();
    // 從索引0、剩餘合計 target 開始進行遞迴探索
    backtrack(candidates, 0, target, new ArrayList<>(), result);
    // 所有遞迴完成後，返回所有已儲存的唯一組合
    return result;
}
```
