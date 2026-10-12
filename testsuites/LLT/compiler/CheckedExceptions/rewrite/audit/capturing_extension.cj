// Rewrite audit: §3.9.3 under §6.5.
// Non-Modal extension and bound methods use receiver captures without requiring caller capabilities.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class Worker captures AE { init() {} }
extend Worker {
    func fail(): Unit throws () { throw AE() }
}
func invoke(w: Worker): Unit throws () {
    let bound: () -> Unit = w.fail
    bound()
}
main(): Int64 {
    try { invoke(Worker()) } catch (e: AE) { return 0 }
    return 1
}
