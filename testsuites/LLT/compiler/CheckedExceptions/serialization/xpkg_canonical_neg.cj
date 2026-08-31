// Checked exceptions (package metadata rule 1): the capability list written to the .cjo is in canonical
// normal form — entries subsumed by another entry are dropped, so an importer of
// 'throws SubExc, BaseExc' sees 'BaseExc' alone and gets ONE diagnostic, not two. Dropping the
// subsumed entry loses no obligation: any supply discharging 'BaseExc' discharges 'SubExc' too.

// DEPENDENCE: libx.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions libx.cj -o libx.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions libx.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-BaseExc'
// ASSERT: scan 1 error generated

import libx.*

public func bad(): Int64 {
    return subsumed() // one missing capability: the canonical list holds only BaseExc
}

main() {
    return 0
}
