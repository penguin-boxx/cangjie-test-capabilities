// Rewrite audit: §3.4.1, §5.1.2, §5.2.
// A generic list alias normalizes after unchecked substitution and remains an ordinary tuple elsewhere.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class UE <: UncheckedException {}
type Errors<E> = (E, AE)
class Box<T> { let value: T; init(value: T) { this.value = value } }
func source<E>(): Unit throws Errors<E> where E <: Exception { throw AE() }
main(): Int64 {
    let pair: Errors<UE> = (UE(), AE())
    let f: Box<() throws AE -> Unit> = Box(source<UE>)
    try { f.value() } catch (e: AE) { return 0 }
    return 1
}
