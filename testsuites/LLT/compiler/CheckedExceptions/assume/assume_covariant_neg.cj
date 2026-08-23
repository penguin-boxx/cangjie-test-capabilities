// Checked exceptions (assumption imports): the assumed list reaches every functional value the
// dependency hands out in a covariant position -- a call's result, a function-typed field, a
// method taken as a value -- not only the calls that resolve into the package. Reading such a
// value out of the package is what pays the obligation here; the text puts the list on the type
// instead, which would pay it at the eventual call (recorded as an implementation artifact).
//
// The field and bound-method cases are what discriminate: before the rule existed neither
// produced any diagnostic at all, since the declared type of 'worker' carries no list.

// DEPENDENCE: legacy_callbacks.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt legacy_callbacks.cj -o legacy_callbacks.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions legacy_callbacks.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: Cannot find a capability for 'Class-LegacyException'
// ASSERT: scan assume_covariant_neg.cj:30:13
// ASSERT: scan assume_covariant_neg.cj:37:13

@AssumeThrows[LegacyException]
import legacy_callbacks.*

// The result of a call into the package.
public func fromResult(): Int64
throws () {
    let w = getWorker()
    return w()
}

// A function-typed field of one of its types.
public func fromField(r: Registry): Int64
throws () {
    let w = r.worker
    return w()
}

// One of its methods taken as a value.
public func fromBoundMethod(r: Registry): Int64
throws () {
    let m = r.direct
    return m()
}

main(): Int64 {
    return 0
}
