// Generic bounds must be available before a functional effect component is filtered.
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-effects error %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability.*Ask
// ASSERT: regex generic_effect_contract_neg\.cj:16:[0-9]+:
// ASSERT: scan-not Internal Compiler Error

import stdx.effect.*
class Ask <: Command<Int64> {}
func retain<C, T, R>(f: () performs C -> R): () performs C -> R where C <: Command<T> { f }
func callback(): Int64 performs Ask { perform Ask() }
func factory(): () performs Ask -> Int64 performs () {
    retain<Ask, Int64, Int64>(callback)
}
public func caller(): Unit performs () {
    let f = factory()
    f()
}
main(): Int64 { 0 }
