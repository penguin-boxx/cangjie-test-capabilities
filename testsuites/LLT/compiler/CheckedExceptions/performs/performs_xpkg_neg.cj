// Effects (§8.2 with §3.10.2): an imported, unhandled effect requirement is a missing
// capability — and it is not inferred even here, since effect requirements never are.

// DEPENDENCE: libeff.cj
// EXEC: %compiler %cmp_opt %enableEH %compile_lib_opt --enable-checked-exceptions libeff.cj -o libeff.%middle
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions libeff.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-GetToken'

import stdx.effect.*
import libeff.*

func unhandled(): Int64 {
    return fetch()
}

main() {
    return 0
}
