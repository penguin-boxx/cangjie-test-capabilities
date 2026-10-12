// Rewrite acceptance: §3.5, §5.1.2.
// An unchecked throw does not introduce a capability requirement for a literal.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class UE <: UncheckedException {}
func unchecked(): Unit { throw UE() }
main(): Int64 {
    let f: () -> Unit = { => unchecked() }
    try { f() } catch (e: UE) { return 0 }
    return 1
}
