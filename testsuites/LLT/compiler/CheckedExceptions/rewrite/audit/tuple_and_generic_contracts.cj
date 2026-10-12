// Tuple return clauses and instantiated generic receiver filtering.
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
func pair(n: Int64): (Int64, Int64) throws () {
    if (n == 0) { (1, 2) } else { pair(n - 1) }
}
func optionalPair(): ?(Int64, Int64) throws () { (1, 2) }
func pairFactory(): () -> (Int64, Int64) throws AE { { => pair(0) } }
class PairSource {
    prop value: (Int64, Int64) throws () { get() { pair(0) } }
}
func failingPair(): (Int64, Int64) throws AE { throw AE() }
class Box<T> {
    let value: T
    init(value: T) { this.value = value }
    func map<U>(body: (T) -> U): Box<U> { Box<U>(body(value)) }
}
class Scope<T> {
    func run(body: () -> T): Unit { body() }
}
func invoke<T>(body: () -> T): Unit {
    let scope = Scope<T>()
    scope.run(body)
}
main(): Int64 {
    invoke<Int64>({ => 1 })
    let mapped = Box<Int64>(pair(2)[0]).map<String> { v => v.toString() }
    if (mapped.value != "1" || PairSource().value[0] != 1 || optionalPair().getOrThrow()[1] != 2) { return 1 }
    try {
        if (pairFactory()()[0] != 1) { return 3 }
    } catch (e: AE) { return 4 }
    try { failingPair() } catch (e: AE) { return 0 }
    return 2
}
