# Finding the Best Time to Buy and Sell a Stock — Find the Maximum Profit from a Single Buy-Sell Transaction in a Stock Price Array

## Problem

You are given an integer array `prices`, where each element `prices[i]` represents the stock price on day `i`. You can perform at most one "buy → sell" transaction, and you must return the **maximum profit** you can achieve. If no profit is possible, return `0`. The buy must occur on a day before the sell.

## Key Insight

If you scan the array from left to right while tracking the minimum price seen so far, you can compute the maximum profit from selling on each day in O(1) by simply subtracting the minimum price from the current price. Taking the maximum of these profits across all days gives you the answer.

## Thought Process

1. **Profit is determined by "sell price − buy price"**: To maximize profit when selling on a given day, you should minimize the buy price. In other words, you should buy at the lowest price among all days before the sell day.
2. **You want to efficiently find the minimum price before each day**: As you scan the array from left to right, you track the minimum price seen so far in a variable `minPrice`. You only need to update `minPrice` each time you encounter a new price, so no additional array is needed and the space complexity is O(1).
3. **You calculate the profit from selling on each day**: For each day `i` during the scan, `prices[i] - minPrice` is the maximum profit from selling on that day. You compare this value with the variable `maxProfit` and update `maxProfit` if the new value is larger.
4. **You clarify the relationship between updating minPrice and calculating profit**: If the current price is less than `minPrice`, you update `minPrice`. Selling on this day would yield a negative profit, so you skip the profit calculation. If the current price is greater than or equal to `minPrice`, you calculate the profit and update `maxProfit`.
5. **You handle the case where no profit is possible**: If the stock prices are monotonically decreasing, `maxProfit` remains at its initial value of `0` and is never updated. The algorithm naturally returns `0` without any special conditional logic.
6. **You return the final result**: After completing a single pass through the array, you return the value of `maxProfit`. This value represents the maximum profit achievable from a single buy-sell transaction.

## Prerequisites

### What Is Integer.MAX_VALUE

`Integer.MAX_VALUE` is the maximum value that Java's `int` type can hold (2,147,483,647). You use it as the initial value in algorithms that search for a minimum. Because it is guaranteed to be larger than any stock price, the first comparison will always replace it with an actual stock price.

```java
int minPrice = Integer.MAX_VALUE;  // Set a sufficiently large value as the initial minimum
// If prices[0] is 7, then 7 < Integer.MAX_VALUE, so minPrice is updated to 7
```

### What Is Math.max

`Math.max` is a static method that takes two `int` values and returns the larger one. It allows you to write the maximum-value update logic in a single line.

```java
int a = 5;
int b = 3;
Math.max(a, b);  // → returns 5

// Use it to update the maximum profit
maxProfit = Math.max(maxProfit, profit);  // Update maxProfit if profit is larger
```

### What Is Running Minimum (Tracking the Minimum During a Scan)

A running minimum is a technique where you track the minimum value of all elements seen so far using a variable as you scan through an array. At each step, you compare the current element with the variable and update the variable with the smaller value. This allows you to obtain the minimum value among all elements up to any position in O(1).

```java
int minPrice = Integer.MAX_VALUE;
for (int price : prices) {
    if (price < minPrice) {
        minPrice = price;  // Update the minimum price seen so far
    }
    // At this point, minPrice holds the minimum value among prices[0] through prices[current]
}
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm requires only a single pass through the array |
| Space | O(1) — The algorithm uses only two variables (minPrice, maxProfit) |

## Code

```java
// Input: an integer array prices (each element represents the stock price on a given day)
// Output: return the maximum profit from a single buy-sell transaction as an int. Return 0 if no profit is possible
public int maxProfit(int[] prices) {
    // Variable to track the minimum price seen so far. Initializing with Integer.MAX_VALUE ensures that the first comparison always updates it with an actual stock price
    int minPrice = Integer.MAX_VALUE;
    // Variable to track the maximum profit seen so far. Initializing with 0 ensures that the algorithm naturally returns 0 when no profit is possible
    int maxProfit = 0;

    // Use a for-each loop to scan through the array from beginning to end, one element at a time
    for (int price : prices) {
        if (price < minPrice) {
            // If the current price is less than the minimum price, update the minimum price
            // This day is when the minimum price is updated, so selling on this day would not yield a profit (the profit would be negative). Therefore, skip the profit calculation
            minPrice = price;
        } else {
            // Calculate the profit from buying on the minimum price day and selling today
            int profit = price - minPrice;
            // If the profit exceeds the current maximum, update the maximum profit
            maxProfit = Math.max(maxProfit, profit);
        }
    }
    // The value of maxProfit at the end of the loop is the maximum profit across the entire array
    return maxProfit;
}
```
