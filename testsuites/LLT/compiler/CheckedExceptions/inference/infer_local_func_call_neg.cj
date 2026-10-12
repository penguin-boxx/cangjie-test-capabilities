// An independent local contract is demanded at invocation, not at declaration.
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: Cannot find a capability for 'Class-AException'
// ASSERT: regex infer_local_func_call_neg\.cj:9:[0-9]+:
// ASSERT: scan-not Internal Compiler Error
class AException <: Exception {}
main(): Int64 {
    func local(): Unit throws ... { throw AException() }
    local()
    return 0
}
