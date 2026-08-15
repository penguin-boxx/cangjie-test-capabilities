// Effects (§8.2 with §3.10.2): a 'performs' requirement crosses the package boundary — the
// entries live in the functional type's capability list, which the .cjo carries.

// DEPENDENCE: libeff.cj
// EXEC: %compiler %cmp_opt %enableEH %compile_lib_opt --enable-checked-exceptions libeff.cj -o libeff.%middle
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-exceptions libeff.%middle %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*
import libeff.*

main() {
    let r = try {
        fetch()
    } handle (_: GetToken) {
        resume with 7
    }
    if (r != 7) {
        return 1
    }
    return 0
}
