// Checked exceptions (package metadata with overloading): the instantiated imported requirement is discharged by
// a handler for exactly that instantiation.

// DEPENDENCE: libx.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions libx.cj -o libx.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions libx.%middle %n.cj -o %output
// EXEC: %run %output

import libx.*

main() {
    try {
        if (generic<Int64>(1) == 0) {
            return 1
        }
    } catch (e: GenException<Int64>) {
        return 1
    }
    return 0
}
