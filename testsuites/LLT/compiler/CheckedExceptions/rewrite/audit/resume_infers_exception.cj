// Rewrite audit: §5.3.2, §5.4.5.
// An uncovered resume-throwing site contributes to its enclosing exception inference.
//
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-effects error --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*
class Ask <: Command<Int64> {}
class AE <: Exception {}
func injected(): Int64 {
    try { perform Ask() } handle (_: Ask) { resume throwing AE() }
}
main(): Int64 {
    let f: () throws AE -> Int64 = injected
    try { f() } catch (e: AE) { return 0 }
    return 1
}
