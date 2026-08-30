// Checked exceptions (inference and function values): a reference that turns an inferred
// declaration into a value pays the declaration's inferred list at the formation site. Without
// this, the value's functional type -- formed before inference ran -- carries no list, a call
// through it demands nothing, and a program with no handler anywhere compiles and leaks at run
// time (found by review, 2026-08-30). Declared clauses are unaffected: a reference's type
// carries those. The obligation lands at formation rather than at the eventual call, which is
// stricter than the text's type-riding reading -- same boundary semantics as assumption imports.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: Cannot find a capability for 'Class-LeakExc'
// ASSERT: scan infer_ref_value_neg.cj:21:25
// ASSERT: scan error: Cannot find a capability for 'Class-LeakExc'

class LeakExc <: Exception {}

func risky(): Unit {   // no clause: throws LeakExc by inference
    throw LeakExc()
}

main(): Int64 {
    let w: () -> Unit = risky   // formation site: pays LeakExc
    w()
    let u = risky               // and with no annotation too
    u()
    return 0
}
