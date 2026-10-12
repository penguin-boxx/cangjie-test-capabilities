// Rewrite acceptance: §3.2, §3.4, §5.2.
// Normalize inferred lists before invariant identity; preserve contravariant meets in returned functions.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

open class Base <: Exception {}
class Sub <: Base {}
class Other <: Exception {}
type Errors = (Base, (Sub, Base))
class Box<T> { let value: T; init(value: T) { this.value = value } }
func first(f: () throws Base -> Unit): Unit {}
func second(f: () throws Other -> Unit): Unit {}
func getFirst() { first }
func getSecond() { second }
func canonical(flag: Bool): Unit {
    if (flag) { throw Sub() }
    throw Base()
}
main(): Int64 {
    let boxed: Box<(Bool) throws Errors -> Unit> = Box(canonical)
    let joined = if (true) { getFirst() } else { getSecond() }
    let meet: (() -> Unit) -> Unit = joined
    meet({ => })
    try { boxed.value(false) } catch (e: Base) { return 0 }
    return 1
}
