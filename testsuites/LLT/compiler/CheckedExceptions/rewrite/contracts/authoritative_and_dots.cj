// Rewrite acceptance: §3.3, §5.3.1–2, §5.3.5.
// Ellipsis adds residual requirements; handling and explicit callback parameters remove them.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}

func openList(flag: Bool): Unit throws AE, ... {
    if (flag) { throw BE() }
}
func handled(): Int64 throws () {
    try { openList(true); 0 } catch (e: AE) { 1 } catch (e: BE) { 2 }
}
func invokes(f: () throws AE -> Unit): Int64 throws () {
    try { f(); 0 } catch (e: AE) { 3 }
}
public func exposed(): Int64 { handled() + invokes({ => risky() }) }
func risky(): Unit { throw AE() }
main(): Int64 { if (exposed() == 5) { 0 } else { 1 } }
