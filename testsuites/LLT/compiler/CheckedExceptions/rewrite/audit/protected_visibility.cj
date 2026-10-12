// Rewrite audit: §5.3.1.
// Top-level protected and protected members of internal classes are inference-eligible.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
protected func helper(): Unit { throw AE() }
open class Worker {
    protected func work(): Unit { helper() }
}
class Child <: Worker { func invoke(): Unit { work() } }
main(): Int64 {
    try { Child().invoke() } catch (e: AE) { return 0 }
    return 1
}
