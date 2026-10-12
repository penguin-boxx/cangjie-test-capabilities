// Rewrite audit: §3.5, §5.3.2–3; collector ownership.
// Unused named local functions have independent lists; returning one does not demand its capabilities.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
func unused(): Int64 {
    func inner(): Unit throws ... { throw AE() }
    return 7
}
func factory(): () throws AE -> Unit {
    func inner(): Unit throws ... { throw AE() }
    inner
}
func nested(): Int64 {
    func inner(): Int64 {
        func unusedAgain(): Unit throws ... { throw AE() }
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
