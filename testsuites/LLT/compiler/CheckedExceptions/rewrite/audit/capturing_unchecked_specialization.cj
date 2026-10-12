// Rewrite audit: §3.9, §5.1.2 under §6.5.
// An unchecked specialization removes its construction demand while a checked specialization retains one.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class UE <: UncheckedException {}
class Holder<E> captures E where E <: Exception {
    init() {}
    func fail(e: E): Unit throws () { throw e }
}
func unchecked(): Holder<UE> throws () { Holder<UE>() }
main(): Int64 {
    let h = unchecked()
    var caught = 0
    try { h.fail(UE()) } catch (e: UE) { caught++ }
    try { Holder<AE>().fail(AE()) } catch (e: AE) { caught++ }
    return if (caught == 2) { 0 } else { 1 }
}
