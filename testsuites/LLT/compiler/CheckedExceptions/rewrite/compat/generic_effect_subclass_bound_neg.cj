// Effect bounds through a Command subclass survive source elaboration and metadata.
// DEPENDENCE: r6genericbounds.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt %enableEH --enable-checked-effects error r6genericbounds.cj -o r6genericbounds.%middle
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-effects error r6genericbounds.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability.*Ask
// ASSERT: regex generic_effect_subclass_bound_neg\.cj:19:[0-9]+:
// ASSERT: scan-not mismatched types
// ASSERT: scan-not parameters and arguments mismatch
// ASSERT: scan-not Internal Compiler Error

import r6genericbounds.*
import stdx.effect.*

func callback(): Int64 performs Ask { perform Ask() }
func factory(): () performs Ask -> Int64 performs () {
    retain<Ask, Int64>(callback)
}
public func caller(): Unit performs () {
    factory()()
}
main(): Int64 { 0 }
