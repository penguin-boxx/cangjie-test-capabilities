// Checked exceptions (capability capturing rule 4 with package metadata): constructing an imported capturing class demands
// its captured capabilities at the construction site, so the 'captures' clause must cross the
// package boundary too.

// DEPENDENCE: libx.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions libx.cj -o libx.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions libx.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-XException'

import libx.*

public func build(): Int64 {
    let s = Session() // error: constructing a capturing class demands XException
    return s.run()
}

main() {
    return 0
}
