// Section 6.3.2: assumed callbacks retain their requirements until invocation.
// Formation inside a handler cannot erase the later invocation obligation.

// DEPENDENCE: legacy_callbacks.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt legacy_callbacks.cj -o legacy_callbacks.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions legacy_callbacks.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: Cannot find a capability for 'Class-LegacyException'

// ASSERT: regex assume_covariant_neg\.cj:19:[0-9]+:
// ASSERT: regex assume_covariant_neg\.cj:26:[0-9]+:
// ASSERT: regex assume_covariant_neg\.cj:33:[0-9]+:
@AssumeThrows[LegacyException]
import legacy_callbacks.*

// The result of a call into the package.
public func fromResult(): Int64
throws () {
    let w = try { getWorker() } catch (e: LegacyException) { { => 0 } }
    return w() // ERROR: invoke the obtained callback
}

// A function-typed field of one of its types.
public func fromField(r: Registry): Int64
throws () {
    let w = r.worker
    return w() // ERROR: invoke the obtained callback
}

// One of its methods taken as a value.
public func fromBoundMethod(r: Registry): Int64
throws () {
    let m = r.direct
    return m() // ERROR: invoke the obtained method
}

main(): Int64 {
    return 0
}
