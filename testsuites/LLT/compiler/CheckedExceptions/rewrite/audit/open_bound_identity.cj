// Rewrite audit: §3.2, §3.4.1, §3.6.
// Coverage from where-bounds is canonical inside the generic declaration before substitution.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

open class Base <: Exception {}
class Sub <: Base {}
class Box<T> { let value: T; init(value: T) { this.value = value } }
func normalize<E>(value: Box<() throws (E, Base) -> Unit>): Box<() throws Base -> Unit> where E <: Base {
    let normalized: Box<() throws Base -> Unit> = value
    normalized
}
func fail(): Unit throws Base { throw Sub() }
main(): Int64 {
    let box = normalize<Sub>(Box(fail))
    try { box.value() } catch (e: Base) { return 0 }
    return 1
}
