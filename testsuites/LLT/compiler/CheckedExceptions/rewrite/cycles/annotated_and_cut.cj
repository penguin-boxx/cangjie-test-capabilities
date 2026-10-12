// Rewrite acceptance: §5.3.4 rewrite policy.
// Complete annotations permit recursion and cut mixed inferred/written dependency cycles.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}

func first(n: Int64): Int64 throws AE { if (n > 0) { second(n - 1) } else { 0 } }
func second(n: Int64): Int64 throws AE { first(n) }
func anchor(n: Int64): Int64 throws AE { inferred(n) }
func inferred(n: Int64): Int64 { if (n > 0) { anchor(n - 1) } else { 0 } }
func pure(n: Int64): Int64 throws () { if (n > 0) { pure(n - 1) } else { 1 } }
main(): Int64 {
    try { return if (first(3) + inferred(3) + pure(3) == 1) { 0 } else { 1 } }
    catch (e: AE) { return 1 }
}
