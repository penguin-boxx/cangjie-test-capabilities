// Rewrite acceptance: §3.4.3, §5.3.2–3.
// Requirements propagate through match bindings, tuple/array projections, inferred results and callers.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}

func consume(): Unit {
    match ((risky, 42)) { case (f, _) => f() }
}
func arrayCall(): Unit {
    let fs = [quiet, risky]
    for (f in fs) { f() }
}
func lambdaResult(): Unit { let make = { => risky }; make()() }
func matched(flag: Bool): Unit {
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
func risky(): Unit { throw AE() }
func quiet(): Unit {}
