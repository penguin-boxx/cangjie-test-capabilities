// A bodyless accessor is permitted wherever an abstract method is permitted.
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
abstract class Base {
    public mut prop value: Int64 throws AE {
        get() throws () { 1 }
        set(v)
    }
}
class Concrete <: Base {
    public mut prop value: Int64 throws AE {
        get() throws () { 2 }
        set(v) { throw AE() }
    }
}
main(): Int64 {
    let value: Base = Concrete()
    if (value.value != 2) { return 1 }
    try { value.value = 3 } catch (e: AE) { return 0 }
    return 2
}
