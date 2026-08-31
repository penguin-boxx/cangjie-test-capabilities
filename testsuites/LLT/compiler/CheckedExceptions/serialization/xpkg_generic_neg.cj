// Checked exceptions (package metadata with overloading): an imported generic declaration's capability list is
// instantiated at the call site, so the demand names the instantiated type.

// DEPENDENCE: libx.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions libx.cj -o libx.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions libx.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-GenException<Int64>'

import libx.*

public func bad(): Int64 {
    return generic<Int64>(1) // demands GenException<Int64>
}

main() {
    return 0
}
