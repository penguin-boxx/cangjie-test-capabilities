// Rewrite acceptance: §3.4–6, §5.3.3.
// An inferred function type survives generic construction and projection to an interface.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
interface Read<T> { func get(): T }
class Box<T> <: Read<T> {
    let value: T
    init(value: T) { this.value = value }
    public func get(): T { value }
}
main(): Int64 {
    let view: Read<() throws AE -> Unit> = Box(risky)
    try { view.get()() } catch (e: AE) { return 0 }
    return 1
}
func risky(): Unit { throw AE() }
