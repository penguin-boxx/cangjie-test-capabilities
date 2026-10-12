// Declaration-local completion: nested clauses and lexical ownership.
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
func first(): Unit {
    throw AE()
    func inner(): Unit throws ... { throw AE() }
    let f: () throws AE -> Unit = inner
}
func second(): Unit {
    func inner(): Unit throws ... { throw AE() }
    let f: () throws AE -> Unit = inner
    throw AE()
}
main(): Int64 {
    let a: () throws AE -> Unit = first
    let b: () throws AE -> Unit = second
    try { a() } catch (e: AE) {}
    try { b() } catch (e: AE) { return 0 }
    return 1
}
