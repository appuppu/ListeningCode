# Maximizing Stock Profit With a Cooldown Period

## Problem

You are given an array `prices` where each index represents a day. You can buy and sell stocks multiple times, but you cannot trade on the day immediately after you sell a stock due to a **cooldown** restriction. Return the **maximum profit** you can achieve under this constraint.

## Key Insight

You classify the state of each day into three categories: "holding a stock (hold)," "just sold (sold)," and "resting (rest)." You define the transitions from the previous day's three states to the current day's three states. Because each day depends only on the previous day, you can manage the states with just three variables instead of arrays.

## Thought Process

1. **Each day has three possible states**: At the end of any given day, you are in one of the following states: "holding a stock (hold)," "sold a stock today (sold)," or "did nothing (rest)." These three states cover all possible cases
2. **Define the transitions between states**: hold is the maximum of "was hold yesterday and did nothing" or "was rest yesterday and bought today." sold is "was hold yesterday and sold today." rest is the maximum of "was rest yesterday and did nothing" or "was sold yesterday and the cooldown has ended." The cooldown constraint is naturally expressed by the rule that "the day after sold cannot transition to hold"
3. **Set the initial states**: If you buy on day 0, then hold = -prices[0] (the profit is negative). Since you cannot sell or rest on day 0, sold = Integer.MIN_VALUE (meaning this state is unreachable) and rest = 0 (doing nothing yields zero profit)
4. **Each day depends only on the previous day's states**: The transition formulas show that each state for the current day can be computed solely from the previous day's three states. This means you do not need arrays for all days; you only need to update three variables each day
5. **You must update all values simultaneously**: Because the current day's hold, sold, and rest are all computed from the previous day's values, you store the new values in temporary variables first, then overwrite the previous day's variables all at once. Overwriting them one at a time would destroy previous-day values that are still needed for computation
6. **What to return at the end**: Ending the final day while still holding a stock is never optimal, so the maximum profit is the larger of prevSold and prevRest

## Prerequisites

### State Machine

A state machine is a model composed of a finite number of states and transition rules between them. At any point in time, the system is in exactly one state and transitions to another state based on input. In this problem, you model the trading process as a state machine with three states: hold, sold, and rest.

```
rest ---(buy)---> hold
hold ---(sell)---> sold
sold ---(wait)---> rest (cooldown)
hold ---(keep)---> hold
rest ---(keep)---> rest
```

### Math.max

Math.max is a method that returns the larger of two integers. You use it to choose the more profitable option when a state transition has multiple choices.

```java
Math.max(3, 7);    // → 7 (returns the larger value)
Math.max(-5, -2);  // → -2 (returns the larger value even for negative numbers)
```

### Integer.MIN_VALUE

Integer.MIN_VALUE is the smallest value that Java's int type can hold (-2,147,483,648). You use it to represent "this state has not been reached yet." Because Math.max never selects it over any other value, you can safely ignore unreachable states.

```java
int x = Integer.MIN_VALUE;  // represents an unreachable state
Math.max(x, 0);             // → 0 (the unreachable state is not selected)
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — You only need to traverse the array once |
| Space | O(1) — You manage the states with only three variables |

## Code

```java
// Input: an integer array prices (each element is the stock price on that day)
// Output: return the maximum profit as an int under the cooldown constraint
public int maxProfit(int[] prices) {
    int n = prices.length;
    // You need at least 2 days to complete a transaction. If n < 2, no transaction is possible, so return 0
    if (n < 2) return 0;

    // Initialize each state for day 0
    int prevHold = -prices[0];          // Profit if you bought on day 0 (negative because it is an expense)
    int prevSold = Integer.MIN_VALUE;   // Selling on day 0 is impossible (represents an unreachable state)
    int prevRest = 0;                   // Doing nothing yields zero profit

    for (int i = 1; i < n; i++) {
        // Compute the current day's three states from the previous day's three states
        // newHold: the larger of "was holding yesterday (prevHold)" or "was resting yesterday and bought today (prevRest - prices[i])"
        // Note: "was sold yesterday and bought today" is not an option. This enforces the cooldown constraint
        int newHold = Math.max(prevHold,
            prevRest - prices[i]);

        // newSold: sell the stock you were holding today. Since sell can only transition from hold, Math.max is unnecessary
        int newSold = prevHold + prices[i];

        // newRest: the larger of "was resting yesterday (prevRest)" or "sold yesterday and the cooldown has ended (prevSold)"
        int newRest = Math.max(prevRest,
            prevSold);

        // Update all values together after computing them all
        // To avoid overwriting previous-day values during computation, assign all three new values only after computing them
        prevHold = newHold;
        prevSold = newSold;
        prevRest = newRest;
    }
    // Ending the final day while still holding a stock (prevHold) is not optimal because the profit is not realized
    // The maximum profit is the larger of sold and rest
    return Math.max(prevSold, prevRest);
}
```
