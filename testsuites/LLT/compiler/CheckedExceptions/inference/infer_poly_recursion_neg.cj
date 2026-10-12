// Rewrite policy: all recursive contract inference is rejected, including growing
// generic instantiations. A generic recursion-specific failure must not hide a
// missing cycle diagnostic. Authoritative complete contracts can break the cycle.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*recursive capability inference

class Box<T> {}
class GenericException<T> <: Exception {}

func f<T>(n: Int64): Int64 {
    if (n < 0) {
        throw GenericException<T>()
    }
    if (n == 0) {
        0
    } else {
        f<Box<T>>(n - 1) // re-enters at a growing instantiation
    }
}

main() {
    try {
        let _ = f<Int64>(3)
    } catch (e: Exception) {
    }
    return 0
}
