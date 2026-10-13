// Section 6 acceptance: §6.3.1: unchecked consumer projects both recorded axes away.
// DEPENDENCE: r6meta.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt %enableEH --enable-checked-effects error --enable-checked-exceptions=error r6meta.cj -o r6meta.%middle
// EXEC: %compiler %cmp_opt %enableEH r6meta.%middle %n.cj -o %output
// EXEC: %run %output

import r6meta.*
main(): Int64 {
    let f: () -> Int64 = work
    let fs: Array<() -> Int64> = nested()
    let value = Capturing()
    if (f() + fs[0]() == 16) { 0 } else { 1 }
}
