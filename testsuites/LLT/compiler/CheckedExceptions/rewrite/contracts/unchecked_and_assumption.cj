// Rewrite acceptance: §5.1, §5.3.
// Unchecked substitution erases requirements; static Exception still requires one; the escape hatch removes one.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class UE <: UncheckedException {}
func raise<E>(e: E): Unit where E <: Exception throws E { throw e }
func unchecked(e: UE): Unit { throw e }
func widened(e: Exception): Unit { throw e }
func assumed(): Int64 { unsafeCanThrow<AE, Int64>({ => 42 }) }
main(): Int64 {
    let f: (UE) -> Unit = raise<UE>
    let g: (UE) -> Unit = unchecked
    let h: (Exception) throws Exception -> Unit = widened
    var caught = 0
    try { f(UE()) } catch (e: UE) { caught++ }
    try { g(UE()) } catch (e: UE) { caught++ }
    try { h(UE()) } catch (e: Exception) { caught++ }
    return if (caught == 3 && assumed() == 42) { 0 } else { 1 }
}
