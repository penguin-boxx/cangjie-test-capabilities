// Checked exceptions (§3.4 with §3.10.2): a clause on a FUNCTIONAL TYPE is part of the type, so
// it must survive nested inside an imported signature — the lambda passed here is covered by the
// parameter type's capability list and may throw without a try of its own.

// DEPENDENCE: libx.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions libx.cj -o libx.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions libx.%middle %n.cj -o %output
// EXEC: %run %output

import libx.*

main() {
    try {
        // The literal's capability list comes from the expected type (proposal 3.5), which the
        // .cjo must have carried across: the body may throw XException with no local handler.
        withCallback({ => throw XException() })
        return 1
    } catch (e: XException) {
    }
    return 0
}
