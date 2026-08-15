// Checked exceptions (§3.9 with §3.10.2): the imported captures requirement is discharged at the
// construction site, and the instance's methods then need no capability of their own.

// DEPENDENCE: libx.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions libx.cj -o libx.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions libx.%middle %n.cj -o %output
// EXEC: %run %output

import libx.*

main() {
    try {
        let s = Session() // discharged here
        s.run()
        return 1
    } catch (e: XException) {
    }
    return 0
}
