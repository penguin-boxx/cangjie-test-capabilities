// Checked exceptions (inference and function values, migration level): the replay that rejects an
// inferred list against a clause-free target reports the same obligation the checking pass does,
// so it follows the same migration level. At 'warn' the diagnostic is a warning in the 'chexc'
// group and the package still compiles -- which is what an existing library needs while its
// higher-order signatures are being annotated. 'infer_ref_value_neg.cj' is the 'error' half.
//
// This is not hypothetical: at 'error' both std.net's lazy address providers and stdx's
// 'TarHeader.addPaxData' hit exactly this rule, and both libraries build only because 'warn'
// downgrades it.

// EXEC-PIPE: %compiler %cmp_opt --experimental --enable-checked-exceptions=warn %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan warning: the inferred capability list requires 'Class-LeakExc', which the type '() -> Unit' expected at this argument does not admit

class LeakExc <: Exception {}

func risky(): Unit {   // no clause: infers 'throws LeakExc'
    throw LeakExc()
}

// The signature this library has not annotated yet.
func takesPlain(f: () -> Unit): Int64 {
    try {
        f()
        return 1
    } catch (e: LeakExc) {
        return 0
    }
}

main(): Int64 {
    return takesPlain(risky)
}
