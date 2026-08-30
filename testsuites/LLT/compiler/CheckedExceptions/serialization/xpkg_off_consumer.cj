// Checked exceptions (author ruling on Q10): the consumer side of "off ignores 'throws' in all
// positions". The dependency is compiled WITH checking and records its lists; the consumer is
// compiled with the feature off, so the loaded signatures read as clause-free -- assignment to a
// clause-free functional type works, and nothing is demanded anywhere.

// DEPENDENCE: libx.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions libx.cj -o libx.%middle
// EXEC: %compiler %cmp_opt libx.%middle %n.cj -o %output
// EXEC: %run %output

import libx.*

main(): Int64 {
    // libx.query declares 'throws XException'; with checking off the clause shapes nothing, so
    // the reference is assignable to the clause-free type and nothing is demanded here.
    let w: (String) -> Int64 = query
    try {
        w("")
    } catch (e: XException) {
        return 0
    }
    return 1
}
