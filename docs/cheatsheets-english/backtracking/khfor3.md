# Placing N Queens on a Board Without Conflicts

## Problem

Given an integer `n`, place n queens on an n×n chessboard such that no two queens share the same row, column, or diagonal. Return all valid board configurations as a list of strings.

## Key Insight

Placing one queen per row automatically eliminates row conflicts. Managing the remaining column, positive diagonal, and negative diagonal conflicts with individual bits in a bitmask enables O(1) constant-time conflict checking and state updates.

## Thought Process

1. **Eliminate row conflicts structurally**: Since the algorithm places n queens in n rows, placing exactly one queen per row guarantees that no row conflict occurs. The problem thus reduces to a search that decides which column to place a queen in for each row.
2. **Detect column and diagonal conflicts**: A set of already-used columns tracks column conflicts. Diagonal conflicts come in two types: positive diagonals (upper-right direction, where row + col is the same) and negative diagonals (upper-left direction, where row - col is the same). Maintaining these three sets detects all conflicts.
3. **Represent sets with bitmasks**: Bitmasks encode the usage status of columns, positive diagonals, and negative diagonals as bits in an integer. A 1 at bit c means "that column (or diagonal) is already occupied." Bitwise AND checks for conflicts and bitwise OR registers placements, both faster than a HashSet.
4. **Shift diagonal bitmasks per row**: When the row advances by one, the positive diagonal's influence shifts one column to the left, so the algorithm applies a left shift (`<< 1`). The negative diagonal's influence shifts one column to the right, so the algorithm applies a right shift (`>> 1`). This approach allows the algorithm to perform diagonal conflict checks using only the bit position of the column number.
5. **Explore all solutions with backtracking**: The algorithm iterates from row 0 to row n-1, trying each non-conflicting column in every row. When a valid column is found, the algorithm places a queen and recurses to the next row. When the algorithm reaches row n, it records one solution. Returning from recursion automatically undoes the placement, allowing the algorithm to try other columns.
6. **Return the total number of solutions**: The algorithm sums up the number of times it successfully places queens in all rows (reaches row == n) and returns that total.

## Prerequisites

### Backtracking

Backtracking is a search technique that tries one option, and when it reaches a dead end, returns to the previous decision point to try a different option. Recursive calls naturally implement the "try → advance → undo" cycle. This technique is well suited for problems that enumerate all valid combinations.

```java
void backtrack(int step) {
    if (step == goal) {       // Record the solution when the goal is reached
        recordSolution();
        return;
    }
    for (int choice : choices) {
        if (isValid(choice)) {    // Try the choice if it is valid
            apply(choice);        // Apply the choice
            backtrack(step + 1);  // Recurse to the next step
            undo(choice);         // Undo the choice and try another option
        }
    }
}
```

### Bitmask

A bitmask is a technique that uses each bit of an integer as a flag indicating whether an element is present in a set. Bitmasks perform set operations efficiently via bitwise operations.

```java
int mask = 0;             // Empty set (all bits are 0)
int bit = 1 << c;         // Create a value with only bit c set to 1 (represents element c)
mask |= bit;              // Add element c to the set (set bit c to 1)
(mask & bit) != 0;        // Check whether element c is in the set → true/false
```

### Tracking Diagonals with Bit Shifts

When the row advances by one on a chessboard, the positive diagonal (upper-right ↗ direction) influence shifts to a column number one smaller, and the negative diagonal (upper-left ↖ direction) influence shifts to a column number one larger. Shifting the bitmask represents this displacement.

```java
int posDiag = 0;          // Bitmask tracking positive diagonal usage
posDiag |= (1 << c);      // Register the positive diagonal for a queen placed at column c
posDiag << 1;              // On the next row, the influence shifts one column to the left (left shift)

int negDiag = 0;          // Bitmask tracking negative diagonal usage
negDiag |= (1 << c);      // Register the negative diagonal for a queen placed at column c
negDiag >> 1;              // On the next row, the influence shifts one column to the right (right shift)
```

## Complexity

| | Value |
|---|---|
| Time | O(n!) — The number of available columns per row decreases as n, n-1, n-2, ... |
| Space | O(n) — The recursion depth is n levels, and each level uses only a constant number of integer bitmasks |

## Code

```java
// Input: integer n (the size of the chessboard and the number of queens to place)
// Output: return the total number of valid configurations as an int
int totalNQueens(int n) {
    // Start the search from row 0 and initialize all bitmasks (columns, positive diagonals, negative diagonals) to empty (0)
    return backtrack(0, n, 0, 0, 0);
}

int backtrack(int row, int n,
    int cols, int posDiag,
    int negDiag) {
    // All rows have a queen placed, so the algorithm has found one solution
    if (row == n) return 1;

    // Variable that accumulates the number of solutions found from this row onward
    int count = 0;

    // Scan columns 0 through n-1 and check whether a queen can be placed in each column
    for (int c = 0; c < n; c++) {
        // Create the bit corresponding to column c and use it to check conflicts against the three bitmasks
        int bit = 1 << c;

        // Skip this column and try the next one if it conflicts with any column, positive diagonal, or negative diagonal
        if ((cols & bit) != 0 ||
            (posDiag & bit) != 0 ||
            (negDiag & bit) != 0)
            continue;

        // Place a queen at column c, update the three bitmasks, and recurse to the next row
        // cols | bit: register column c as occupied
        // (posDiag | bit) << 1: register the positive diagonal and apply a left shift to reflect the offset for the next row
        // (negDiag | bit) >> 1: register the negative diagonal and apply a right shift to reflect the offset for the next row
        // Because bitmasks are passed by value, returning from recursion automatically restores the pre-registration state, so no explicit undo operation is needed
        count += backtrack(row + 1, n,
            cols | bit,
            (posDiag | bit) << 1,
            (negDiag | bit) >> 1);
    }
    // Return the total number of solutions found after trying all columns
    return count;
}
```
