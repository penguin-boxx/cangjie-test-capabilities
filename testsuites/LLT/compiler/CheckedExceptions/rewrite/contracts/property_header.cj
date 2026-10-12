// Rewrite acceptance: §3.2, §3.3.2.
// Property-level clauses supply accessor bodies and impose requirements on property reads.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}

class Source {
    prop value: Int64 throws AE {
        get() { throw AE() }
    }
}
func read(): Int64 { Source().value }
main(): Int64 {
    try { read() } catch (e: AE) { return 0 }
    return 1
}
