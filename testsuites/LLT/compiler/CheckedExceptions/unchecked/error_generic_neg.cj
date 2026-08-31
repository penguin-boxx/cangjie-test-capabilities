// The discriminating half of 'error_generic.cj': a parameter bounded by 'Exception' is tracked, so
// a clause-free empty-clause function that throws it is still rejected. The Error exemption must
// not have widened into "generic parameters never demand".

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: Cannot find a capability for 'Generics-E'

public func failChecked<E>(e: E): Unit
throws () where E <: Exception {
    throw e
}

main(): Int64 { 0 }
