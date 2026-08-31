// Checked exceptions (package metadata): clauses on imported METHODS and PROPERTY ACCESSORS cross the
// boundary too, not just free functions.

// DEPENDENCE: libx.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions libx.cj -o libx.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions libx.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-XException'
// ASSERT: scan Cannot find a capability for 'Class-YException'

import libx.*

public func viaMethod(c: Connection): Int64 {
    return c.execute("select 1") // error: XException not supplied
}

public func viaProp(c: Connection): Int64 {
    return c.status // error: YException not supplied
}

main() {
    return 0
}
