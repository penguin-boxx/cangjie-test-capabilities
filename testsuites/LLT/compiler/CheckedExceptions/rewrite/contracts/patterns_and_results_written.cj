// Rewrite acceptance: §3–5 equivalence control.
// Authoritative-clause twin of patterns_and_results; both variants must compile and run identically.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}

func consume(): Unit throws AE {
    match ((risky, 42)) { case (f, _) => f() }
}
func arrayCall(): Unit throws AE {
    let fs = [quiet, risky]
    for (f in fs) { f() }
}
func lambdaResult(): Unit throws AE { let make = { => risky }; make()() }
func matched(flag: Bool): Unit throws AE {
    let f = match (flag) { case true => quiet case false => risky }
    f()
}
main(): Int64 {
    var caught = 0
    try { consume() } catch (e: AE) { caught++ }
    try { arrayCall() } catch (e: AE) { caught++ }
    try { lambdaResult() } catch (e: AE) { caught++ }
    try { matched(false) } catch (e: AE) { caught++ }
    return if (caught == 4) { 0 } else { 1 }
}
func risky(): Unit throws AE { throw AE() }
func quiet(): Unit {}
