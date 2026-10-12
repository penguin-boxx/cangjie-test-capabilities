// An unused nested body still needs lexical supply; omission does not infer its own list.
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(capability|CanThrow)
// ASSERT: scan-not Internal Compiler Error
class AE <: Exception {}
public func outer(): Unit {
    func unused(): Unit { throw AE() } // ERROR
}
main(): Int64 { 0 }
