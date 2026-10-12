// Rewrite audit: §3.8, §5.1.2; final override validation.
// Generic override comparison substitutes and removes unchecked requirements before validation.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class UE <: UncheckedException {}
interface Action<E> where E <: Exception {
    func run(e: E): Unit throws E
}
class Impl <: Action<UE> {
    public func run(e: UE): Unit { throw e }
}
main(): Int64 {
    let value: Action<UE> = Impl()
    try { value.run(UE()) } catch (e: UE) { return 0 }
    return 1
}
