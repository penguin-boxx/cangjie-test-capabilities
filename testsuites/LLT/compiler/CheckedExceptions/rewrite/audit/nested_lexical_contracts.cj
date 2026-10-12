// Declaration-local completion: nested clauses and lexical ownership.
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
func capturesFromUnused(): Unit {
    func inner(): Unit { throw AE() }
}
func independent(): Unit {
    func inner(): Unit throws ... { throw AE() }
}
func writtenSupplies(): Unit throws AE {
    func inner(): Unit throws ... { throw AE() }
    let noRequirements: () -> Unit = inner
}
func pendingOuter(): Unit {
    func inner(): Unit throws ... { throw AE() }
    let requiresAE: () throws AE -> Unit = inner
    throw AE()
}
public func exportedParent(): Unit throws AE {
    func inner(): Unit throws () { throw AE() }
    try { inner() } catch (e: AE) {}
}
func recursiveLocal(): Unit {
    func inner(n: Int64): Unit {
        if (n > 0) { inner(n - 1) }
    }
    inner(2)
}
main(): Int64 {
    let captured: () throws AE -> Unit = capturesFromUnused
    let pure: () -> Unit = independent
    pure()
    recursiveLocal()
    try { exportedParent() } catch (e: AE) { return 1 }
    try { pendingOuter() } catch (e: AE) { return 0 }
    return 2
}
