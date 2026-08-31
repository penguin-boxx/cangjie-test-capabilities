// Checked exceptions (package metadata): a 'throws' clause on a public declaration must cross the package
// boundary through the .cjo, so a call in another package demands the same capabilities.

// DEPENDENCE: libx.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions libx.cj -o libx.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions libx.%middle %n.cj -o %output
// EXEC: %run %output

import libx.*

// The imported requirement is dischargeable by a clause of our own...
func viaClause(): Int64 throws XException {
    return query("select 1")
}

main() {
    // ... and by a try-catch here.
    try {
        let a = query("select 1")
        let b = viaClause()
        let c = Connection().execute("select 2")
        if (a + b + c == 0) {
            return 1
        }
    } catch (e: XException) {
        return 1
    }
    // An authoritative empty clause imports as empty: no capability needed.
    if (clean() == 0) {
        return 1
    }
    return 0
}
