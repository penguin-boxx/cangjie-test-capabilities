// Rewrite audit: §3–5 equivalence control.
// Written-clause control for local_declaration_isolation; inference must preserve the same behavior.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
func unused(): Int64 throws () {
    func inner(): Unit throws AE { throw AE() }
    return 7
}
func factory(): () throws AE -> Unit throws () {
    func inner(): Unit throws AE { throw AE() }
    inner
}
func nested(): Int64 throws () {
    func inner(): Int64 throws () {
        func unusedAgain(): Unit throws AE { throw AE() }
        return 8
    }
    inner()
}
main(): Int64 {
    let pure: () -> Int64 = unused
    let make: () -> (() throws AE -> Unit) = factory
    if (pure() != 7 || nested() != 8) { return 1 }
    let f = make()
    try { f() } catch (e: AE) { return 0 }
    return 2
}
