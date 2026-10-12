// Rewrite acceptance: §3.4, §3.6, §5.3.3.
// Generic substitution must preserve completed function types, including invariant containers and joins.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}

func identity<T>(x: T): T { x }
func choose<T>(x: T, y: T, first: Bool): T { if (first) { x } else { y } }
class Box<T> {
    let value: T
    init(value: T) { this.value = value }
}
main(): Int64 {
    let a: () throws AE -> Unit = identity(risky)
    let box: Box<() throws AE -> Unit> = Box(risky)
    let both: () throws (AE, BE) -> Unit = choose(risky, other, false)
    var caught = 0
    try { a() } catch (e: AE) { caught++ }
    try { box.value() } catch (e: AE) { caught++ }
    try { both() } catch (e: BE) { caught++ } catch (e: AE) { return 1 }
    match (Some(risky)) {
        case Some(f) => try { f() } catch (e: AE) { caught++ }
        case None => return 1
    }
    return if (caught == 4) { 0 } else { 1 }
}
func risky(): Unit { throw AE() }
func other(): Unit { throw BE() }
