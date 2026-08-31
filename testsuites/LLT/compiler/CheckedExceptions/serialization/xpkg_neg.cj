// Checked exceptions (package metadata): an imported requirement that is not discharged is a missing
// capability, exactly as it would be within the declaring package. Without cjo metadata the
// import silently arrives capability-free and this compiles, which is the bug being guarded.

// DEPENDENCE: libx.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions libx.cj -o libx.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions libx.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-XException'

import libx.*

public func unhandled(): Int64 {
    return query("select 1") // error: public, so no inference; nothing supplies XException
}

main() {
    return 0
}
