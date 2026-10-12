// Rewrite audit: §3.6, §5.3.3; declaration completion cache.
// One generic declaration retains open requirements across distinct and repeated instantiations.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class GE<T> <: Exception {}
class Box<T> { let value: T; init(value: T) { this.value = value } }
func factory<T>() { fail<T> }
func fail<T>(): Unit { throw GE<T>() }
main(): Int64 {
    let a: Box<() throws GE<Int64> -> Unit> = Box(factory<Int64>())
    let b: Box<() throws GE<String> -> Unit> = Box(factory<String>())
    let again: Box<() throws GE<Int64> -> Unit> = Box(factory<Int64>())
    var caught = 0
    try { b.value() } catch (e: GE<String>) { caught++ }
    try { a.value() } catch (e: GE<Int64>) { caught++ }
    try { again.value() } catch (e: GE<Int64>) { caught++ }
    return if (caught == 3) { 0 } else { 1 }
}
