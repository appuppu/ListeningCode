# Validating a Sudoku Board — Determine Whether a 9×9 Sudoku Board Is Valid

## Problem

You are given a 9×9 Sudoku board represented as a two-dimensional character array. You return `true` if the board is valid, meaning no row, column, or 3×3 sub-grid contains duplicate digits. Empty cells are represented by a dot `.`. The board does not need to be fully filled; you only check whether the current placement violates any rules.

## Key Insight

You scan the entire board once and determine that the board is invalid if any digit has already appeared in its row, its column, or its 3×3 box. You can uniquely map any cell `(i, j)` to a box index from 0 to 8 using the formula `(i/3) * 3 + j/3`.

## Thought Process

1. **Identify the conditions to verify**: Sudoku validity depends on three conditions: no duplicates in any row, no duplicates in any column, and no duplicates in any 3×3 box. Verifying all three conditions simultaneously is the most efficient approach.
2. **HashSet is suitable for detecting duplicates**: A HashSet can determine whether a digit has already appeared in O(1) time. You prepare 9 HashSets for rows, 9 for columns, and 9 for boxes — 27 HashSets in total — so that you can check all three conditions at once.
3. **You need a mapping from cell to box**: You need to calculate which box a cell `(i, j)` belongs to. Integer division `i/3` groups rows into three groups (0, 1, 2), and `j/3` groups columns into three groups (0, 1, 2). You convert these to a one-dimensional index with `(i/3) * 3 + j/3`, which assigns each of the 9 boxes a unique number from 0 to 8.
4. **You verify all conditions in a single pass**: You use a nested for-loop to scan the entire board and check each cell against the row, column, and box Sets for duplicates, registering the digit in each Set. You skip dots because they are not digits.
5. **You return false immediately when you find a duplicate**: If any of the three Sets already contains the same digit, the board is invalid, so you return `false` immediately.
6. **You return true after scanning all cells**: If no duplicate is ever found, the board is valid.

## Prerequisites

### What Is a HashSet

A HashSet is a data structure that manages a collection of unique elements. It supports adding elements and checking for existence in O(1) time. In this problem, you use it to quickly determine whether a digit has already appeared.

```java
Set<Character> set = new HashSet<>();  // Create an empty HashSet
set.add('5');            // Add element '5'
set.contains('5');       // Check whether element '5' exists → returns true
set.contains('3');       // Check whether element '3' exists → returns false
```

### How to Create an Array of HashSets

You manage 9 HashSets together as an array. Because you cannot directly create a generic array, you create a raw-type array with `new HashSet[9]` and initialize each element in a loop.

```java
Set<Character>[] sets = new HashSet[9];  // Allocate an array for 9 elements
for (int i = 0; i < 9; i++) {
    sets[i] = new HashSet<>();           // Initialize each element with an empty HashSet
}
```

### Box Index Formula

`boxIdx = (i/3) * 3 + j/3` returns the number (0–8) of the 3×3 box to which cell `(i, j)` belongs. `i/3` represents the box position in the row direction (0, 1, 2), and `j/3` represents the box position in the column direction (0, 1, 2). You multiply the row position by 3 and add the column position to assign a unique number to each of the 9 boxes.

```
Box number layout:
0 | 1 | 2
3 | 4 | 5
6 | 7 | 8

Example: Cell (4, 7) → (4/3)*3 + 7/3 = 1*3 + 2 = 5 → belongs to Box 5
```

## Complexity

| | Value |
|---|---|
| Time | O(n²) — You scan the entire 9×9 board once (since n=9 is fixed, this is also O(81) = O(1)) |
| Space | O(n²) — You store up to 81 elements across 27 HashSets |

## Code

```java
// Input: a 9×9 two-dimensional character array board (digits '1'–'9' or dot '.')
// Output: return true if the board is valid, false if the board is invalid
public boolean isValidSudoku(char[][] board) {
    // Create arrays of HashSets to record digits that have appeared in each row, column, and box
    // rowset[i] records digits in row i, columnset[j] records digits in column j, boxset[k] records digits in box k
    Set<Character>[] rowset = createSets();
    Set<Character>[] columnset = createSets();
    Set<Character>[] boxset = createSets();

    // The outer loop iterates over rows and the inner loop iterates over columns, visiting all 81 cells once
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            // Get the value of the current cell
            char c = board[i][j];
            // Skip dots because they represent empty cells (not digits)
            if (c == '.') {
                continue;
            }

            // Calculate the box number (uniquely mapped to 0–8) that cell (i, j) belongs to
            int boxIdx = (i / 3) * 3 + j / 3;

            // If any of the row, column, or box Sets already contains the same digit, return false immediately because it is a duplicate
            if (rowset[i].contains(c) || columnset[j].contains(c) || boxset[boxIdx].contains(c)) {
                return false;
            }

            // If there is no duplicate, register the current digit in all three Sets to detect future duplicates
            rowset[i].add(c);
            columnset[j].add(c);
            boxset[boxIdx].add(c);
        }
    }
    // If no duplicate is found after scanning all cells, the board is valid
    return true;
}

// Helper method that creates an array containing 9 empty HashSets
public Set<Character>[] createSets() {
    Set<Character>[] sets = new HashSet[9];
    for (int i = 0; i < 9; i++) {
        sets[i] = new HashSet<>();
    }
    return sets;
}
```
