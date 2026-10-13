// Section 6 acceptance: §6.2: producer both filters nested clauses and mixed captures independently.
// DEPENDENCE: r6meta.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt %enableEH --enable-checked-exceptions=error --enable-checked-effects error r6meta.cj -o r6meta.%middle
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-effects error --enable-checked-exceptions=error r6meta.%middle %n.cj -o %output
// EXEC: %run %output

import r6meta.*
func check(): Unit performs Ask throws AE {
    let f: () performs Ask throws AE -> Int64 = work
    let fs: Array<() performs Ask throws AE -> Int64> = nested()
    let value = Capturing()
    f()
    fs[0]()
}
main(): Int64 { 0 }
