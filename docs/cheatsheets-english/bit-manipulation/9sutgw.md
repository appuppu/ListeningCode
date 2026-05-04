# Reversing the Bits of an Integer — Reverse the bits of a 32-bit unsigned integer

## Problem

You are given a 32-bit unsigned integer. You return the integer obtained by reversing the order of its bit sequence. For example, the input `00000000000000000000000000001011` becomes `11010000000000000000000000000000`.

## Key Insight

You shift the result left by one bit at a time while extracting the least significant bit from the input one by one and appending it to the result. Repeating this process 32 times builds up the reversed bit sequence in the result.

## Thought Process

1. **Bit reversal is the operation of "extracting from the tail and stacking onto the head"**: You extract the least significant bit (rightmost) of the input, append it to the least significant bit (rightmost) of the result, and then shift the result left. This causes the first extracted bit to eventually move to the most significant position. This process constitutes a reverse construction of the bit sequence.
2. **How to extract the least significant bit**: Computing `n & 1` retrieves only the least significant bit of `n`. The AND operation masks all bits except the least significant bit to 0.
3. **How to append the extracted bit to the result**: Using `result |= (n & 1)` with the OR operation sets the extracted bit at the least significant position of result. The left shift performed just before this operation has cleared the least significant bit of result to 0, so the OR operation sets it correctly.
4. **How to advance to the next bit**: Shifting the input `n` right by one bit with `n >>>= 1` brings the next bit to the least significant position. The `>>>` operator is an unsigned right shift that always fills the most significant bit with 0.
5. **How to make space in the result**: Shifting the result left by one bit with `result <<= 1` before appending a new bit clears the least significant bit to 0, creating space to accept the new bit.
6. **Repeating 32 times completes the reversal**: Since the integer is 32 bits, repeating the "left shift → append bit → right shift" cycle 32 times stores all bits of the input in reverse order in the result.

## Prerequisites

### Bitwise AND Operation (&)

The bitwise AND operation compares each bit of two integers and produces 1 only where both bits are 1. You use it as a "mask" to extract specific bits.

```java
int n = 0b1011;       // 1011 in binary (11 in decimal)
int bit = n & 1;      // Extract only the least significant bit → 1
int bit2 = 0b1010 & 1; // When the least significant bit is 0 → 0
```

### Bitwise OR Assignment (|=)

The bitwise OR operation compares each bit of two integers and produces 1 where either bit is 1. You use it to set (turn on) specific bits.

```java
int result = 0b0000;
result |= 1;          // Set the least significant bit to 1 → 0b0001
result |= 0;          // OR with 0 causes no change → 0b0001
```

### Left Shift Assignment (<<=)

The left shift operation shifts the bit sequence left by the specified number of positions. The system fills the rightmost positions with 0. Shifting left by one bit has the effect of doubling the value.

```java
int result = 0b0011;   // 11 in binary (3 in decimal)
result <<= 1;          // Shift left by 1 bit → 0b0110 (6 in decimal)
```

### Unsigned Right Shift Assignment (>>>=)

The unsigned right shift operation shifts the bit sequence right by the specified number of positions. The system always fills the leftmost positions with 0. Unlike `>>`, this operator fills with 0 regardless of the sign bit, making it suitable for operating on unsigned integers.

```java
int n = 0b1011;        // 1011 in binary
n >>>= 1;              // Shift right by 1 bit → 0b0101 (the rightmost 1 disappears, and the next bit moves to the rightmost position)
```

## Complexity

| | Value |
|---|---|
| Time | O(1) — The loop always runs exactly 32 times and does not depend on the input value |
| Space | O(1) — The algorithm uses only the additional variable `result` and does not depend on the input size |

## Code

```java
// Input: 32-bit unsigned integer n
// Output: Return the integer with the bit sequence reversed as int
public int reverseBits(int n) {
    // Variable to store the reversed bit sequence. The initial value 0 means all bits are 0
    int result = 0;

    // Loop 32 times to process all bits of the 32-bit integer
    for (int i = 0; i < 32; i++) {
        // Shift result left by 1 bit to clear the least significant bit to 0 and create space for the new bit
        // Note: The left shift must be performed before appending the bit. Performing it after would cause an extra shift after the last bit append, doubling the result
        result <<= 1;
        // Extract the least significant bit of n using n & 1 and set it at the least significant bit of result using the OR operation
        // The preceding left shift has cleared the least significant bit to 0, so the OR operation sets it correctly
        result |= (n & 1);
        // Unsigned right shift n to move the next bit to the least significant position
        // The >>> operator is used because the system must fill with 0 regardless of the sign bit
        n >>>= 1;
    }
    // After completing 32 iterations, bit 0 of the input is stored at bit 31 of result, bit 1 at bit 30, and so on — all bits are stored in reverse order
    return result;
}
```
