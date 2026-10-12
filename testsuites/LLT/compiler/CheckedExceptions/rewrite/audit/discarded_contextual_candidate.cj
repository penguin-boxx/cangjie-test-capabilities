// Rewrite audit: §3.5–7; candidate isolation.
// Rejected contextual lambda candidates must not add residual demands to the enclosing function.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}
func choose(f: () throws BE -> String): Int64 {
    try { f(); 2 } catch (e: BE) { 3 }
}
func choose(f: () throws AE -> Int64): Int64 {
    try { f() } catch (e: AE) { 7 }
}
func source(): Int64 throws AE { throw AE() }
func caller(): Int64 { choose({ => source() }) }
main(): Int64 {
    let pure: () -> Int64 = caller
    return if (pure() == 7) { 0 } else { 1 }
}
